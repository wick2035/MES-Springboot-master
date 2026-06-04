package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 班组员工关系实体
 *
 * @author Claude
 * @since 2026-06-04
 */
@TableName(value = "sp_team_employee")
public class SpTeamEmployee extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 班组ID */
    private String teamId;
    /** 员工(用户)ID */
    private String userId;
    /** 备注信息 */
    private String remark;

    /** 状态 0正常 1删除 */
    @TableField(value = "is_deleted")
    private String deleted;

    /** 展示字段：员工姓名（联表 sp_sys_user.name 回显，不存库） */
    @TableField(exist = false)
    private String userName;
    /** 展示字段：用户编码/用户名（联表 sp_sys_user.username 回显，不存库） */
    @TableField(exist = false)
    private String username;

    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
}
