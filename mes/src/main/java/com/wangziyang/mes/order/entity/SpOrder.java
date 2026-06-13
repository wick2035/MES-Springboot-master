package com.wangziyang.mes.order.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.wangziyang.mes.common.BaseEntity;

/**
 * <p>
 * 
 * </p>
 *
 * @author WangZiYang
 * @since 2020-07-01
 */
public class SpOrder extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 工单编号
     */
    private String orderCode;

    /**
     * 工单描述
     */
    private String orderDescription;

    /**
     * 工单数量
     */
    private Integer qty;

    /**
     * 订单类型 P 量产 A验证 F返工 
     */
    private String orderType;

    /**
     * 流程ID
     */
    private String flowId;

    /**
     * 物料编码
     */
    private String materiel;

    /**
     * 物料描述
     */
    private String materielDesc;

    /**
     * 计划开始时间
     */
    private String planStartTime;

    /**
     * 计划结束时间
     */
    private String planEndTime;

    /**
     * 1,创建 2 进行中，3订单结束，4订单终结
     */
    private Integer statue;

    /**
     * 设计人用户ID
     */
    private String designerId;

    /**
     * 设计人
     */
    private String designerName;

    /**
     * 审批人用户ID
     */
    private String approveUserId;

    /**
     * 审批人
     */
    private String approveUsername;

    /**
     * 审批时间
     */
    private String approveTime;

    private String workStatus;

    private String workStartTime;

    private String completeStatus;

    private String completeTime;

    private String completeUsername;

    private String deliveryStatus;

    private String deliveryTime;

    private String deliveryUsername;

    /**
     * 澶囨敞
     */
    private String remark;

    @TableField(exist = false)
    private String sourceOrderNo;

    @TableField(exist = false)
    private String sourceOrderItemId;

    @TableField(exist = false)
    private String sourceBomCode;

    @TableField(exist = false)
    private String sourceBomVersion;

    @TableField(exist = false)
    private String approvalStatusName;

    @TableField(exist = false)
    private String equipmentAssignStatusName;

    @TableField(exist = false)
    private String employeeAssignStatusName;

    @TableField(exist = false)
    private String dispatchStatusName;

    @TableField(exist = false)
    private String mainStatusName;

    @TableField(exist = false)
    private String workStatusName;

    @TableField(exist = false)
    private String completeStatusName;

    @TableField(exist = false)
    private String deliveryStatusName;

    @TableField(exist = false)
    private Boolean canComplete;

    @TableField(exist = false)
    private Boolean canDeliver;

    @TableField(exist = false)
    private String completeBlockReason;

    @TableField(exist = false)
    private String deliveryBlockReason;

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }
    public String getOrderDescription() {
        return orderDescription;
    }

    public void setOrderDescription(String orderDescription) {
        this.orderDescription = orderDescription;
    }
    public Integer getQty() {
        return qty;
    }

    public void setQty(Integer qty) {
        this.qty = qty;
    }
    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }
    public String getFlowId() {
        return flowId;
    }

    public void setFlowId(String flowId) {
        this.flowId = flowId;
    }
    public String getMateriel() {
        return materiel;
    }

    public void setMateriel(String materiel) {
        this.materiel = materiel;
    }
    public String getMaterielDesc() {
        return materielDesc;
    }

    public void setMaterielDesc(String materielDesc) {
        this.materielDesc = materielDesc;
    }
    public String getPlanStartTime() {
        return planStartTime;
    }

    public void setPlanStartTime(String planStartTime) {
        this.planStartTime = planStartTime;
    }
    public String getPlanEndTime() {
        return planEndTime;
    }

    public void setPlanEndTime(String planEndTime) {
        this.planEndTime = planEndTime;
    }
    public Integer getStatue() {
        return statue;
    }

    public void setStatue(Integer statue) {
        this.statue = statue;
    }

    public String getDesignerId() {
        return designerId;
    }

    public void setDesignerId(String designerId) {
        this.designerId = designerId;
    }

    public String getDesignerName() {
        return designerName;
    }

    public void setDesignerName(String designerName) {
        this.designerName = designerName;
    }

    public String getApproveUserId() {
        return approveUserId;
    }

    public void setApproveUserId(String approveUserId) {
        this.approveUserId = approveUserId;
    }

    public String getApproveUsername() {
        return approveUsername;
    }

    public void setApproveUsername(String approveUsername) {
        this.approveUsername = approveUsername;
    }

    public String getApproveTime() {
        return approveTime;
    }

    public void setApproveTime(String approveTime) {
        this.approveTime = approveTime;
    }

    public String getWorkStatus() {
        return workStatus;
    }

    public void setWorkStatus(String workStatus) {
        this.workStatus = workStatus;
    }

    public String getWorkStartTime() {
        return workStartTime;
    }

    public void setWorkStartTime(String workStartTime) {
        this.workStartTime = workStartTime;
    }

    public String getCompleteStatus() {
        return completeStatus;
    }

    public void setCompleteStatus(String completeStatus) {
        this.completeStatus = completeStatus;
    }

    public String getCompleteTime() {
        return completeTime;
    }

    public void setCompleteTime(String completeTime) {
        this.completeTime = completeTime;
    }

    public String getCompleteUsername() {
        return completeUsername;
    }

    public void setCompleteUsername(String completeUsername) {
        this.completeUsername = completeUsername;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public String getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(String deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public String getDeliveryUsername() {
        return deliveryUsername;
    }

    public void setDeliveryUsername(String deliveryUsername) {
        this.deliveryUsername = deliveryUsername;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getSourceOrderNo() {
        return sourceOrderNo;
    }

    public void setSourceOrderNo(String sourceOrderNo) {
        this.sourceOrderNo = sourceOrderNo;
    }

    public String getSourceOrderItemId() {
        return sourceOrderItemId;
    }

    public void setSourceOrderItemId(String sourceOrderItemId) {
        this.sourceOrderItemId = sourceOrderItemId;
    }

    public String getSourceBomCode() {
        return sourceBomCode;
    }

    public void setSourceBomCode(String sourceBomCode) {
        this.sourceBomCode = sourceBomCode;
    }

    public String getSourceBomVersion() {
        return sourceBomVersion;
    }

    public void setSourceBomVersion(String sourceBomVersion) {
        this.sourceBomVersion = sourceBomVersion;
    }

    public String getApprovalStatusName() {
        return approvalStatusName;
    }

    public void setApprovalStatusName(String approvalStatusName) {
        this.approvalStatusName = approvalStatusName;
    }

    public String getEquipmentAssignStatusName() {
        return equipmentAssignStatusName;
    }

    public void setEquipmentAssignStatusName(String equipmentAssignStatusName) {
        this.equipmentAssignStatusName = equipmentAssignStatusName;
    }

    public String getEmployeeAssignStatusName() {
        return employeeAssignStatusName;
    }

    public void setEmployeeAssignStatusName(String employeeAssignStatusName) {
        this.employeeAssignStatusName = employeeAssignStatusName;
    }

    public String getDispatchStatusName() {
        return dispatchStatusName;
    }

    public void setDispatchStatusName(String dispatchStatusName) {
        this.dispatchStatusName = dispatchStatusName;
    }

    public String getMainStatusName() {
        return mainStatusName;
    }

    public void setMainStatusName(String mainStatusName) {
        this.mainStatusName = mainStatusName;
    }

    public String getWorkStatusName() {
        return workStatusName;
    }

    public void setWorkStatusName(String workStatusName) {
        this.workStatusName = workStatusName;
    }

    public String getCompleteStatusName() {
        return completeStatusName;
    }

    public void setCompleteStatusName(String completeStatusName) {
        this.completeStatusName = completeStatusName;
    }

    public String getDeliveryStatusName() {
        return deliveryStatusName;
    }

    public void setDeliveryStatusName(String deliveryStatusName) {
        this.deliveryStatusName = deliveryStatusName;
    }

    public Boolean getCanComplete() {
        return canComplete;
    }

    public void setCanComplete(Boolean canComplete) {
        this.canComplete = canComplete;
    }

    public Boolean getCanDeliver() {
        return canDeliver;
    }

    public void setCanDeliver(Boolean canDeliver) {
        this.canDeliver = canDeliver;
    }

    public String getCompleteBlockReason() {
        return completeBlockReason;
    }

    public void setCompleteBlockReason(String completeBlockReason) {
        this.completeBlockReason = completeBlockReason;
    }

    public String getDeliveryBlockReason() {
        return deliveryBlockReason;
    }

    public void setDeliveryBlockReason(String deliveryBlockReason) {
        this.deliveryBlockReason = deliveryBlockReason;
    }

    @Override
    public String toString() {
        return "SpOrder{" +
            "orderCode=" + orderCode +
            ", orderDescription=" + orderDescription +
            ", qty=" + qty +
            ", orderType=" + orderType +
            ", flowId=" + flowId +
            ", materiel=" + materiel +
            ", materielDesc=" + materielDesc +
            ", planStartTime=" + planStartTime +
            ", planEndTime=" + planEndTime +
            ", statue=" + statue +
            ", designerId=" + designerId +
            ", designerName=" + designerName +
            ", approveUserId=" + approveUserId +
            ", approveUsername=" + approveUsername +
            ", approveTime=" + approveTime +
            ", workStatus=" + workStatus +
            ", workStartTime=" + workStartTime +
            ", completeStatus=" + completeStatus +
            ", completeTime=" + completeTime +
            ", completeUsername=" + completeUsername +
            ", deliveryStatus=" + deliveryStatus +
            ", deliveryTime=" + deliveryTime +
            ", deliveryUsername=" + deliveryUsername +
            ", remark=" + remark +
        "}";
    }
}
