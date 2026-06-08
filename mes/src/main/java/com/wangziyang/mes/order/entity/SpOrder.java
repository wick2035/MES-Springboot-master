package com.wangziyang.mes.order.entity;

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
        "}";
    }
}
