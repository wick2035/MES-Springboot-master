package com.wangziyang.mes.productionorder.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * Work order change approval request.
 */
@TableName("sp_work_order_change")
public class SpWorkOrderChange extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String workOrderId;
    private String workOrderCode;
    private String productionOrderId;
    private String orderItemId;
    private String beforeFlowId;
    private String afterFlowId;
    private Integer beforeQty;
    private Integer afterQty;
    private String beforePlanStartTime;
    private String afterPlanStartTime;
    private String beforePlanEndTime;
    private String afterPlanEndTime;
    private String beforeRemark;
    private String afterRemark;
    private String status;
    private String workflowInstanceId;
    private String applyTime;

    public String getWorkOrderId() {
        return workOrderId;
    }

    public void setWorkOrderId(String workOrderId) {
        this.workOrderId = workOrderId;
    }

    public String getWorkOrderCode() {
        return workOrderCode;
    }

    public void setWorkOrderCode(String workOrderCode) {
        this.workOrderCode = workOrderCode;
    }

    public String getProductionOrderId() {
        return productionOrderId;
    }

    public void setProductionOrderId(String productionOrderId) {
        this.productionOrderId = productionOrderId;
    }

    public String getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(String orderItemId) {
        this.orderItemId = orderItemId;
    }

    public String getBeforeFlowId() {
        return beforeFlowId;
    }

    public void setBeforeFlowId(String beforeFlowId) {
        this.beforeFlowId = beforeFlowId;
    }

    public String getAfterFlowId() {
        return afterFlowId;
    }

    public void setAfterFlowId(String afterFlowId) {
        this.afterFlowId = afterFlowId;
    }

    public Integer getBeforeQty() {
        return beforeQty;
    }

    public void setBeforeQty(Integer beforeQty) {
        this.beforeQty = beforeQty;
    }

    public Integer getAfterQty() {
        return afterQty;
    }

    public void setAfterQty(Integer afterQty) {
        this.afterQty = afterQty;
    }

    public String getBeforePlanStartTime() {
        return beforePlanStartTime;
    }

    public void setBeforePlanStartTime(String beforePlanStartTime) {
        this.beforePlanStartTime = beforePlanStartTime;
    }

    public String getAfterPlanStartTime() {
        return afterPlanStartTime;
    }

    public void setAfterPlanStartTime(String afterPlanStartTime) {
        this.afterPlanStartTime = afterPlanStartTime;
    }

    public String getBeforePlanEndTime() {
        return beforePlanEndTime;
    }

    public void setBeforePlanEndTime(String beforePlanEndTime) {
        this.beforePlanEndTime = beforePlanEndTime;
    }

    public String getAfterPlanEndTime() {
        return afterPlanEndTime;
    }

    public void setAfterPlanEndTime(String afterPlanEndTime) {
        this.afterPlanEndTime = afterPlanEndTime;
    }

    public String getBeforeRemark() {
        return beforeRemark;
    }

    public void setBeforeRemark(String beforeRemark) {
        this.beforeRemark = beforeRemark;
    }

    public String getAfterRemark() {
        return afterRemark;
    }

    public void setAfterRemark(String afterRemark) {
        this.afterRemark = afterRemark;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getWorkflowInstanceId() {
        return workflowInstanceId;
    }

    public void setWorkflowInstanceId(String workflowInstanceId) {
        this.workflowInstanceId = workflowInstanceId;
    }

    public String getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(String applyTime) {
        this.applyTime = applyTime;
    }
}
