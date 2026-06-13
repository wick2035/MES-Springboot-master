package com.wangziyang.mes.productionorder.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * Operation-level production order schedule.
 */
@TableName("sp_production_order_oper_plan")
public class SpProductionOrderOperPlan extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String orderId;

    private String orderItemId;

    private String orderNo;

    private String productMateriel;

    private String productName;

    private String flowId;

    private String operId;

    private String oper;

    private String operDesc;

    private Integer sortNum;

    private String unitId;

    private String planStartTime;

    private String planEndTime;

    private BigDecimal durationHours;

    private String durationSource;

    private String scheduleMethod;

    private String calcRemark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getOrderItemId() { return orderItemId; }
    public void setOrderItemId(String orderItemId) { this.orderItemId = orderItemId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public String getProductMateriel() { return productMateriel; }
    public void setProductMateriel(String productMateriel) { this.productMateriel = productMateriel; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

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

    public String getPlanStartTime() { return planStartTime; }
    public void setPlanStartTime(String planStartTime) { this.planStartTime = planStartTime; }

    public String getPlanEndTime() { return planEndTime; }
    public void setPlanEndTime(String planEndTime) { this.planEndTime = planEndTime; }

    public BigDecimal getDurationHours() { return durationHours; }
    public void setDurationHours(BigDecimal durationHours) { this.durationHours = durationHours; }

    public String getDurationSource() { return durationSource; }
    public void setDurationSource(String durationSource) { this.durationSource = durationSource; }

    public String getScheduleMethod() { return scheduleMethod; }
    public void setScheduleMethod(String scheduleMethod) { this.scheduleMethod = scheduleMethod; }

    public String getCalcRemark() { return calcRemark; }
    public void setCalcRemark(String calcRemark) { this.calcRemark = calcRemark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
