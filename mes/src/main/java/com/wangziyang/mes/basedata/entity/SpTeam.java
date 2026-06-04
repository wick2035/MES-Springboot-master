package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 班组实体
 *
 * @author Claude
 * @since 2026-06-04
 */
@TableName(value = "sp_team")
public class SpTeam extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 班组代码（唯一） */
    private String teamCode;
    /** 班组名称 */
    private String teamName;
    /** 班组描述 */
    private String teamDesc;
    /** 备注信息 */
    private String remark;

    /** 状态 0正常 1删除 2禁用 */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getTeamCode() { return teamCode; }
    public void setTeamCode(String teamCode) { this.teamCode = teamCode; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public String getTeamDesc() { return teamDesc; }
    public void setTeamDesc(String teamDesc) { this.teamDesc = teamDesc; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
