package com.wangziyang.mes.llm.service;

import com.wangziyang.mes.llm.entity.SpLlmConversation;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

/**
 * 智能数据助手对话编排服务。
 */
public interface ILlmChatService {

    /**
     * 解析会话：传入会话ID则返回其本身；为空则按首条消息创建新会话。
     */
    SpLlmConversation ensureConversation(String conversationId, String firstMessage, String userId, String username);

    /**
     * 流式作答：内部完成「工具规划(非流式)→执行只读工具→最终回答(流式)」两轮，
     * 并通过 SSE 逐块推送。该方法应在独立线程中调用。
     */
    void streamAnswer(String conversationId, String userMessage, String userId, String username, SseEmitter emitter);
}
