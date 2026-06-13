package com.wangziyang.mes.productionorder.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * Production order item.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SpProductionOrderItem extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String orderId;

    private String productMateriel;

    private String productName;

    private String bomId;

    private String bomCode;

    private String bomVersion;

    private String model;

    private String specification;

    private Integer qty;

    private BigDecimal unitPrice;

    private String configuration;

    private String planDeliveryDate;

    private String planStartDate;

    private Integer leadTimeDays;

    private BigDecimal targetCapacity;

    private String computedStartDate;

    private String computedDeliveryDate;

    private String materialReadyDate;

    private String adjustNote;

    private String workOrderId;

    private String workOrderCode;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getProductMateriel() {
        return productMateriel;
    }

    public void setProductMateriel(String productMateriel) {
        this.productMateriel = productMateriel;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBomId() {
        return bomId;
    }

    public void setBomId(String bomId) {
        this.bomId = bomId;
    }

    public String getBomCode() {
        return bomCode;
    }

    public void setBomCode(String bomCode) {
        this.bomCode = bomCode;
    }

    public String getBomVersion() {
        return bomVersion;
    }

    public void setBomVersion(String bomVersion) {
        this.bomVersion = bomVersion;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }

    public Integer getQty() {
        return qty;
    }

    public void setQty(Integer qty) {
        this.qty = qty;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getConfiguration() {
        return configuration;
    }

    public void setConfiguration(String configuration) {
        this.configuration = configuration;
    }

    public String getPlanDeliveryDate() {
        return planDeliveryDate;
    }

    public void setPlanDeliveryDate(String planDeliveryDate) {
        this.planDeliveryDate = planDeliveryDate;
    }

    public String getPlanStartDate() {
        return planStartDate;
    }

    public void setPlanStartDate(String planStartDate) {
        this.planStartDate = planStartDate;
    }

    public Integer getLeadTimeDays() {
        return leadTimeDays;
    }

    public void setLeadTimeDays(Integer leadTimeDays) {
        this.leadTimeDays = leadTimeDays;
    }

    public BigDecimal getTargetCapacity() {
        return targetCapacity;
    }

    public void setTargetCapacity(BigDecimal targetCapacity) {
        this.targetCapacity = targetCapacity;
    }

    public String getComputedStartDate() {
        return computedStartDate;
    }

    public void setComputedStartDate(String computedStartDate) {
        this.computedStartDate = computedStartDate;
    }

    public String getComputedDeliveryDate() {
        return computedDeliveryDate;
    }

    public void setComputedDeliveryDate(String computedDeliveryDate) {
        this.computedDeliveryDate = computedDeliveryDate;
    }

    public String getMaterialReadyDate() {
        return materialReadyDate;
    }

    public void setMaterialReadyDate(String materialReadyDate) {
        this.materialReadyDate = materialReadyDate;
    }

    public String getAdjustNote() {
        return adjustNote;
    }

    public void setAdjustNote(String adjustNote) {
        this.adjustNote = adjustNote;
    }

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
}
