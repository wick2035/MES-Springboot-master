package com.wangziyang.mes.llm.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 智能助手会话消息。仅持久化展示用的 user / assistant 消息，工具中间消息不落库。
 */
@TableName("sp_llm_message")
public class SpLlmMessage extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 所属会话ID */
    private String conversationId;

    /** 角色 user / assistant */
    private String role;

    /** 消息内容 */
    private String content;

    public String getConversationId() {
        return conversationId;
    }

    public void setConversationId(String conversationId) {
        this.conversationId = conversationId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
