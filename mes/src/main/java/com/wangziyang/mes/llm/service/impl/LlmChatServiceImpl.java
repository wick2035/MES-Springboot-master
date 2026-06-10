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
        return "你是 MES 制造执行系统的智能数据助手。"
                + "你只能依据系统提供的工具查询到的真实数据作答，严禁编造数据或编号。"
                + "当用户的问题涉及工单、库存、报工合格率/质量、BOM、物料等业务数据时，必须先调用相应工具获取数据再回答。"
                + "可在一次回答中调用多个工具。回答使用简体中文，数据较多时用 Markdown 表格清晰呈现，并给出简要结论。"
                + "若工具返回为空或无数据，请如实说明，不要臆造。"
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
