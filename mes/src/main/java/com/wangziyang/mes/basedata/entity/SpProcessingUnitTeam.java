package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 加工单元班组关系实体（加工单元 ↔ 班组，多对多）
 *
 * @author Claude
 * @since 2026-06-04
 */
@TableName(value = "sp_processing_unit_team")
public class SpProcessingUnitTeam extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 加工单元ID */
    private String unitId;
    /** 班组ID */
    private String teamId;
    /** 备注信息 */
    private String remark;

    /** 状态 0正常 1删除 */
    @TableField(value = "is_deleted")
    private String deleted;

    /** 展示字段：班组代码（联表 sp_team.team_code 回显，不存库） */
    @TableField(exist = false)
    private String teamCode;
    /** 展示字段：班组名称（联表 sp_team.team_name 回显，不存库） */
    @TableField(exist = false)
    private String teamName;
    /** 展示字段：班组状态（联表 sp_team.is_deleted 回显，不存库） */
    @TableField(exist = false)
    private String teamStatus;

    public String getUnitId() { return unitId; }
    public void setUnitId(String unitId) { this.unitId = unitId; }

    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    public String getTeamCode() { return teamCode; }
    public void setTeamCode(String teamCode) { this.teamCode = teamCode; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public String getTeamStatus() { return teamStatus; }
    public void setTeamStatus(String teamStatus) { this.teamStatus = teamStatus; }
}
