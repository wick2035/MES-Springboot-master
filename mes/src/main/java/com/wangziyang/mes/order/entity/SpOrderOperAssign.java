package com.wangziyang.mes.order.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 工单工序人员分配实体
 *
 * 记录工单每道工序自动/手动分配到的班组与员工，
 * 由「AI智能建模」向导在工单创建时写入。
 *
 * @since 2026-06-10
 */
@TableName(value = "sp_order_oper_assign")
public class SpOrderOperAssign extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 工单ID */
    private String orderId;
    /** 工单编号 */
    private String orderCode;
    /** 工艺路线ID */
    private String flowId;
    /** 工序ID */
    private String operId;
    /** 工序编码 */
    private String oper;
    /** 工序名称 */
    private String operDesc;
    /** 工序顺序 */
    private Integer sortNum;
    /** 加工单元ID */
    private String unitId;
    /** 班组ID */
    private String teamId;
    /** 员工用户ID */
    private String userId;
    /** 员工姓名 */
    private String userName;
    /** 任务状态 0待开工 1进行中 2已完成 */
    private String status;
    /** 备注 */
    private String remark;

    /** 状态 0正常 1删除 */
    @TableField(value = "is_deleted")
    private String deleted;

    /** 班组名称（仅展示用） */
    @TableField(exist = false)
    private String teamName;

    /** 加工单元名称（仅展示用） */
    @TableField(exist = false)
    private String unitName;

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }

    public String getFlowId() { return flowId; }
    public void setFlowId(String flowId) { this.flowId = flowId; }

    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }

    public String getOper() { return oper; }
    public void setOper(String oper) { this.oper = oper; }

    public String getOperDesc() { return operDesc; }
    public void setOperDesc(String operDesc) { this.operDesc = operDesc; }

    public Integer getSortNum() { return sortNum; }
    public void setSortNum(Integer sortNum) { this.sortNum = sortNum; }

    public String getUnitId() { return unitId; }
    public void setUnitId(String unitId) { this.unitId = unitId; }

    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public String getUnitName() { return unitName; }
    public void setUnitName(String unitName) { this.unitName = unitName; }
}
