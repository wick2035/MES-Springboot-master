package com.wangziyang.mes.productionorder.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.wangziyang.mes.common.BaseEntity;

/**
 * Production order header for demand and forecast orders.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SpProductionOrder extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String orderNo;

    private String sourceType;

    private String customerName;

    private String customerGroup;

    private String externalNo;

    private String salesContractNo;

    private String businessType;

    private String orderDate;

    private String settlementCurrency;

    private String transportMode;

    private String paymentTerms;

    private String taxRate;

    private String receiverName;

    private String receiverPhone;

    private String receiverAddress;

    private String remark;

    private String status;

    private String approvalStatus;

    private String operationStatus;

    private String creationMethod;

    private String schedulingMethod;

    private String erpSourceNo;

    private String erpSyncTime;

    @TableField(value = "is_deleted")
    private String deleted;

    @TableField(exist = false)
    private Integer itemCount;

    @TableField(exist = false)
    private Integer totalQty;

    @TableField(exist = false)
    private String firstProductName;

    @TableField(exist = false)
    private String firstProductMateriel;

    @TableField(exist = false)
    private String firstBomCode;

    @TableField(exist = false)
    private String firstBomVersion;

    @TableField(exist = false)
    private String firstPlanDeliveryDate;

    @TableField(exist = false)
    private String firstPlanStartDate;

    @TableField(exist = false)
    private String mrpStatus;

    @TableField(exist = false)
    private String mrpCalcTime;

    @TableField(exist = false)
    private Integer mrpPlanCount;

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerGroup() {
        return customerGroup;
    }

    public void setCustomerGroup(String customerGroup) {
        this.customerGroup = customerGroup;
    }

    public String getExternalNo() {
        return externalNo;
    }

    public void setExternalNo(String externalNo) {
        this.externalNo = externalNo;
    }

    public String getSalesContractNo() {
        return salesContractNo;
    }

    public void setSalesContractNo(String salesContractNo) {
        this.salesContractNo = salesContractNo;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public String getSettlementCurrency() {
        return settlementCurrency;
    }

    public void setSettlementCurrency(String settlementCurrency) {
        this.settlementCurrency = settlementCurrency;
    }

    public String getTransportMode() {
        return transportMode;
    }

    public void setTransportMode(String transportMode) {
        this.transportMode = transportMode;
    }

    public String getPaymentTerms() {
        return paymentTerms;
    }

    public void setPaymentTerms(String paymentTerms) {
        this.paymentTerms = paymentTerms;
    }

    public String getTaxRate() {
        return taxRate;
    }

    public void setTaxRate(String taxRate) {
        this.taxRate = taxRate;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getReceiverAddress() {
        return receiverAddress;
    }

    public void setReceiverAddress(String receiverAddress) {
        this.receiverAddress = receiverAddress;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public String getOperationStatus() {
        return operationStatus;
    }

    public void setOperationStatus(String operationStatus) {
        this.operationStatus = operationStatus;
    }

    public String getCreationMethod() {
        return creationMethod;
    }

    public void setCreationMethod(String creationMethod) {
        this.creationMethod = creationMethod;
    }

    public String getSchedulingMethod() {
        return schedulingMethod;
    }

    public void setSchedulingMethod(String schedulingMethod) {
        this.schedulingMethod = schedulingMethod;
    }

    public String getErpSourceNo() {
        return erpSourceNo;
    }

    public void setErpSourceNo(String erpSourceNo) {
        this.erpSourceNo = erpSourceNo;
    }

    public String getErpSyncTime() {
        return erpSyncTime;
    }

    public void setErpSyncTime(String erpSyncTime) {
        this.erpSyncTime = erpSyncTime;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }

    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    public Integer getTotalQty() {
        return totalQty;
    }

    public void setTotalQty(Integer totalQty) {
        this.totalQty = totalQty;
    }

    public String getFirstProductName() {
        return firstProductName;
    }

    public void setFirstProductName(String firstProductName) {
        this.firstProductName = firstProductName;
    }

    public String getFirstProductMateriel() {
        return firstProductMateriel;
    }

    public void setFirstProductMateriel(String firstProductMateriel) {
        this.firstProductMateriel = firstProductMateriel;
    }

    public String getFirstBomCode() {
        return firstBomCode;
    }

    public void setFirstBomCode(String firstBomCode) {
        this.firstBomCode = firstBomCode;
    }

    public String getFirstBomVersion() {
        return firstBomVersion;
    }

    public void setFirstBomVersion(String firstBomVersion) {
        this.firstBomVersion = firstBomVersion;
    }

    public String getFirstPlanDeliveryDate() {
        return firstPlanDeliveryDate;
    }

    public void setFirstPlanDeliveryDate(String firstPlanDeliveryDate) {
        this.firstPlanDeliveryDate = firstPlanDeliveryDate;
    }

    public String getFirstPlanStartDate() {
        return firstPlanStartDate;
    }

    public void setFirstPlanStartDate(String firstPlanStartDate) {
        this.firstPlanStartDate = firstPlanStartDate;
    }

    public String getMrpStatus() {
        return mrpStatus;
    }

    public void setMrpStatus(String mrpStatus) {
        this.mrpStatus = mrpStatus;
    }

    public String getMrpCalcTime() {
        return mrpCalcTime;
    }

    public void setMrpCalcTime(String mrpCalcTime) {
        this.mrpCalcTime = mrpCalcTime;
    }

    public Integer getMrpPlanCount() {
        return mrpPlanCount;
    }

    public void setMrpPlanCount(Integer mrpPlanCount) {
        this.mrpPlanCount = mrpPlanCount;
    }
}
