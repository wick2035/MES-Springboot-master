package com.wangziyang.mes.llm.service.impl;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpResponse;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.llm.config.DashScopeClient;
import com.wangziyang.mes.llm.entity.SpLlmConversation;
import com.wangziyang.mes.llm.entity.SpLlmMessage;
import com.wangziyang.mes.llm.service.ILlmChatService;
import com.wangziyang.mes.llm.service.ILlmConversationService;
import com.wangziyang.mes.llm.service.ILlmMessageService;
import com.wangziyang.mes.llm.tool.LlmToolRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * 对话编排实现：两轮（工具规划 + 流式作答）。
 */
@Service
public class LlmChatServiceImpl implements ILlmChatService {

    private static final Logger log = LoggerFactory.getLogger(LlmChatServiceImpl.class);

    /** 携带的历史消息上限，避免上下文过长 */
    private static final int HISTORY_LIMIT = 20;

    @Autowired
    private DashScopeClient client;

    @Autowired
    private LlmToolRegistry toolRegistry;

    @Autowired
    private ILlmConversationService conversationService;

    @Autowired
    private ILlmMessageService messageService;

    @Override
    public SpLlmConversation ensureConversation(String conversationId, String firstMessage, String userId, String username) {
        if (StrUtil.isNotBlank(conversationId)) {
            SpLlmConversation existing = conversationService.getById(conversationId);
            if (existing != null && !"1".equals(existing.getDeleted())) {
                return existing;
            }
        }
        SpLlmConversation conv = new SpLlmConversation();
        conv.setTitle(StrUtil.brief(StrUtil.trimToEmpty(firstMessage), 20));
        conv.setUserId(userId);
        conv.setDeleted("0");
        conversationService.save(conv);
        return conv;
    }

    @Override
    public void streamAnswer(String conversationId, String userMessage, String userId, String username, SseEmitter emitter) {
        try {
            if (!client.isConfigured()) {
                sendError(emitter, "未配置大模型 API Key，请在环境变量中设置 DASHSCOPE_API_KEY 后重启应用。");
                emitter.complete();
                return;
            }

            // 1. 持久化用户消息
            saveMessage(conversationId, "user", userMessage);

            // 2. 构建消息上下文（系统提示 + 历史 + 当前）
            JSONArray messages = buildMessages(conversationId);

            // 3. 第 1 轮：带工具的非流式规划
            JSONObject first = client.chat(messages, toolRegistry.toolSpecs());
            JSONObject assistantMsg = firstChoiceMessage(first);
            JSONArray toolCalls = assistantMsg == null ? null : assistantMsg.getJSONArray("tool_calls");

            if (toolCalls != null && !toolCalls.isEmpty()) {
                // 提示前端正在调用的工具
                JSONArray toolNames = new JSONArray();
                for (Object o : toolCalls) {
                    JSONObject tc = (JSONObject) o;
                    toolNames.add(tc.getJSONObject("function").getStr("name"));
                }
                sendEvent(emitter, "tool", new JSONObject().put("tools", toolNames));

                // 回灌 assistant(tool_calls) 与各工具结果
                messages.add(assistantMsg);
                for (Object o : toolCalls) {
                    JSONObject tc = (JSONObject) o;
                    JSONObject fn = tc.getJSONObject("function");
                    String tname = fn.getStr("name");
                    String argStr = fn.getStr("arguments");
                    JSONObject argObj = StrUtil.isBlank(argStr) ? new JSONObject() : JSONUtil.parseObj(argStr);
                    String toolResult = toolRegistry.invoke(tname, argObj);
                    JSONObject toolMsg = new JSONObject()
                            .put("role", "tool")
                            .put("tool_call_id", tc.getStr("id"))
                            .put("content", toolResult);
                    messages.add(toolMsg);
                }
            }

            // 4. 第 2 轮：流式最终作答
            String full = streamFinalAnswer(messages, emitter);

            // 5. 持久化 assistant 回答
            if (StrUtil.isNotBlank(full)) {
                saveMessage(conversationId, "assistant", full);
            }

            sendEvent(emitter, "done", new JSONObject().put("ok", true));
            emitter.complete();
        } catch (Exception e) {
            log.error("流式对话失败", e);
            sendError(emitter, "对话处理失败: " + e.getMessage());
            try {
                emitter.complete();
            } catch (Exception ignore) {
                // 已完成则忽略
            }
        }
    }

    private String streamFinalAnswer(JSONArray messages, SseEmitter emitter) throws Exception {
        HttpResponse resp = client.chatStream(messages);
        StringBuilder full = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(resp.bodyStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.isEmpty() || !line.startsWith("data:")) {
                    continue;
                }
                String data = line.substring(5).trim();
                if ("[DONE]".equals(data)) {
                    break;
                }
                JSONObject chunk = JSONUtil.parseObj(data);
                JSONArray choices = chunk.getJSONArray("choices");
                if (choices == null || choices.isEmpty()) {
                    continue;
                }
                JSONObject delta = choices.getJSONObject(0).getJSONObject("delta");
                if (delta == null) {
                    continue;
                }
                String c = delta.getStr("content");
                if (StrUtil.isNotEmpty(c)) {
                    full.append(c);
                    sendEvent(emitter, "delta", new JSONObject().put("c", c));
                }
            }
        } finally {
            resp.close();
        }
        return full.toString();
    }

    private JSONArray buildMessages(String conversationId) {
        JSONArray messages = new JSONArray();
        messages.add(new JSONObject().put("role", "system").put("content", systemPrompt()));

        List<SpLlmMessage> history = messageService.list(new QueryWrapper<SpLlmMessage>()
                .eq("conversation_id", conversationId)
                .orderByAsc("create_time")
                .last("limit " + HISTORY_LIMIT));
        for (SpLlmMessage m : history) {
            messages.add(new JSONObject().put("role", m.getRole()).put("content", m.getContent()));
        }
        return messages;
    }

    private String systemPrompt() {
        return "你是「黑科制造 MES 智能制造执行系统」的智能助手，既能查真实业务数据，也能讲清楚系统怎么操作、业务流程是什么。"
                + "系统涵盖：系统管理、基础数据中心、产品数据中心(物料/BOM)、工艺管理中心、生产计划中心(订单/MRP/派工/下发/工单)、"
                + "计划管理(工单管理/已交付)、库房管理中心(出入库/配套出库)、在制品管理(SN过站采集)、流程配置工具(审批工作流)、"
                + "数字化平台(大屏/数据中心)、数字孪生(3D仓库)、智能助手中心(数据助手/AI建模)。\n"
                + "【数据类问题】涉及工单、库存、报工合格率/质量、BOM、物料、超期工单、SN 追溯等具体数据时，必须先调用相应数据工具获取真实数据再回答，"
                + "严禁编造数据或编号；工具返回为空时如实说明，不要臆造。\n"
                + "【操作/流程类问题】当用户问“某功能在哪个菜单、怎么操作、需要哪些前置条件、完整生产流程是什么、为什么订单不能下发/配套出库失败、"
                + "各状态含义、角色权限怎么配”等操作答疑时，必须调用 queryOperationGuide 获取权威操作指引，再据此分步骤说明，不要凭空臆测路径或步骤。\n"
                + "可在一次回答中调用多个工具。回答统一使用简体中文，数据较多时用 Markdown 表格、操作步骤用有序列表清晰呈现，并给出简要结论或下一步建议。"
                + "今天的日期是 " + DateUtil.formatDate(DateUtil.date()) + "。";
    }

    private JSONObject firstChoiceMessage(JSONObject resp) {
        JSONArray choices = resp.getJSONArray("choices");
        if (choices == null || choices.isEmpty()) {
            return null;
        }
        return choices.getJSONObject(0).getJSONObject("message");
    }

    private void saveMessage(String conversationId, String role, String content) {
        SpLlmMessage msg = new SpLlmMessage();
        msg.setConversationId(conversationId);
        msg.setRole(role);
        msg.setContent(content);
        messageService.save(msg);
    }

    private void sendEvent(SseEmitter emitter, String name, JSONObject data) {
        try {
            emitter.send(SseEmitter.event().name(name).data(data.toString()));
        } catch (Exception e) {
            log.warn("SSE 推送失败 event={}", name, e);
        }
    }

    private void sendError(SseEmitter emitter, String message) {
        sendEvent(emitter, "error", new JSONObject().put("message", message));
    }
}
