package com.wangziyang.mes.productionorder.request;

import java.math.BigDecimal;

/**
 * Forecast generation request.
 */
public class SpProductionOrderForecastReq {

    private String productMateriel;

    private String productName;

    private String customerName;

    private String firstPlanStartDate;

    private Integer months;

    private BigDecimal trendFactor;

    private BigDecimal seasonFactor;

    private Integer leadTimeDays;

    private BigDecimal targetCapacity;

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

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getFirstPlanStartDate() {
        return firstPlanStartDate;
    }

    public void setFirstPlanStartDate(String firstPlanStartDate) {
        this.firstPlanStartDate = firstPlanStartDate;
    }

    public Integer getMonths() {
        return months;
    }

    public void setMonths(Integer months) {
        this.months = months;
    }

    public BigDecimal getTrendFactor() {
        return trendFactor;
    }

    public void setTrendFactor(BigDecimal trendFactor) {
        this.trendFactor = trendFactor;
    }

    public BigDecimal getSeasonFactor() {
        return seasonFactor;
    }

    public void setSeasonFactor(BigDecimal seasonFactor) {
        this.seasonFactor = seasonFactor;
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
}
