package com.wangziyang.mes.llm.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.llm.entity.SpLlmConversation;
import com.wangziyang.mes.llm.entity.SpLlmMessage;
import com.wangziyang.mes.llm.service.ILlmChatService;
import com.wangziyang.mes.llm.service.ILlmConversationService;
import com.wangziyang.mes.llm.service.ILlmMessageService;
import com.wangziyang.mes.system.entity.SysUser;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.concurrent.Executor;

/**
 * MES 智能数据助手控制器。
 */
@Controller
@RequestMapping("/llm/chat")
public class LlmChatController extends BaseController {

    @Autowired
    private ILlmChatService chatService;

    @Autowired
    private ILlmConversationService conversationService;

    @Autowired
    private ILlmMessageService messageService;

    @Autowired
    @Qualifier("llmExecutor")
    private Executor llmExecutor;

    @GetMapping("/chat-ui")
    public String chatUI() {
        return "llm/chat/index";
    }

    /**
     * 流式对话（SSE）。前端用 EventSource 调用。
     */
    @GetMapping("/stream")
    public SseEmitter stream(@RequestParam(required = false) String conversationId,
                             @RequestParam String message) {
        SseEmitter emitter = new SseEmitter(300_000L);
        SysUser user = getSysUser();
        String userId = user == null ? null : user.getId();
        String username = user == null ? "anonymous" : user.getUsername();

        // 同步解析/创建会话，便于第一时间把会话ID回传前端
        SpLlmConversation conv = chatService.ensureConversation(conversationId, message, userId, username);
        final String convId = conv.getId();
        try {
            emitter.send(SseEmitter.event().name("meta")
                    .data("{\"conversationId\":\"" + convId + "\"}"));
        } catch (Exception ignore) {
            // 发送失败由后续流程兜底
        }

        llmExecutor.execute(() -> chatService.streamAnswer(convId, message, userId, username, emitter));
        return emitter;
    }

    /**
     * 我的会话列表。
     */
    @PostMapping("/conversations")
    @ResponseBody
    public Result conversations() {
        SysUser user = getSysUser();
        QueryWrapper<SpLlmConversation> qw = new QueryWrapper<SpLlmConversation>()
                .ne("is_deleted", "1");
        if (user != null) {
            qw.eq("user_id", user.getId());
        }
        qw.orderByDesc("update_time").last("limit 100");
        return Result.success(conversationService.list(qw));
    }

    /**
     * 某会话的历史消息。
     */
    @PostMapping("/messages")
    @ResponseBody
    public Result messages(String conversationId) {
        if (StringUtils.isBlank(conversationId)) {
            return Result.success(java.util.Collections.emptyList());
        }
        List<SpLlmMessage> list = messageService.list(new QueryWrapper<SpLlmMessage>()
                .eq("conversation_id", conversationId)
                .orderByAsc("create_time"));
        return Result.success(list);
    }

    /**
     * 删除会话（软删）。
     */
    @PostMapping("/delete-conversation")
    @ResponseBody
    public Result deleteConversation(String conversationId) {
        if (StringUtils.isBlank(conversationId)) {
            return Result.failure("缺少会话ID");
        }
        SpLlmConversation conv = conversationService.getById(conversationId);
        if (conv != null) {
            conv.setDeleted("1");
            conversationService.updateById(conv);
        }
        return Result.success();
    }
}
