package com.wangziyang.mes.llm.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 智能助手会话。
 */
@TableName("sp_llm_conversation")
public class SpLlmConversation extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 会话标题（取首条提问摘要） */
    private String title;

    /** 所属用户ID */
    private String userId;

    /** 状态 0正常 1删除 */
    @TableField("is_deleted")
    private String deleted;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
