package com.wangziyang.mes.productionorder.request;

import com.alibaba.excel.annotation.ExcelProperty;

import java.math.BigDecimal;

/**
 * Production order Excel import row.
 */
public class SpProductionOrderImportDTO {

    @ExcelProperty("订单类型")
    private String sourceType;

    @ExcelProperty("外部订单号")
    private String externalNo;

    @ExcelProperty("客户名称")
    private String customerName;

    @ExcelProperty("销售合同号")
    private String salesContractNo;

    @ExcelProperty("产品BOM编码")
    private String bomCode;

    @ExcelProperty("产品物料")
    private String productMateriel;

    @ExcelProperty("需求数量")
    private Integer qty;

    @ExcelProperty("排产方式")
    private String schedulingMethod;

    @ExcelProperty("计划交付日期")
    private String planDeliveryDate;

    @ExcelProperty("计划开工日期")
    private String planStartDate;

    @ExcelProperty("提前期")
    private Integer leadTimeDays;

    @ExcelProperty("目标产能")
    private BigDecimal targetCapacity;

    @ExcelProperty("配置要求")
    private String configuration;

    @ExcelProperty("备注")
    private String remark;

    public String getSourceType() { return sourceType; }
    public void setSourceType(String sourceType) { this.sourceType = sourceType; }

    public String getExternalNo() { return externalNo; }
    public void setExternalNo(String externalNo) { this.externalNo = externalNo; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getSalesContractNo() { return salesContractNo; }
    public void setSalesContractNo(String salesContractNo) { this.salesContractNo = salesContractNo; }

    public String getBomCode() { return bomCode; }
    public void setBomCode(String bomCode) { this.bomCode = bomCode; }

    public String getProductMateriel() { return productMateriel; }
    public void setProductMateriel(String productMateriel) { this.productMateriel = productMateriel; }

    public Integer getQty() { return qty; }
    public void setQty(Integer qty) { this.qty = qty; }

    public String getSchedulingMethod() { return schedulingMethod; }
    public void setSchedulingMethod(String schedulingMethod) { this.schedulingMethod = schedulingMethod; }

    public String getPlanDeliveryDate() { return planDeliveryDate; }
    public void setPlanDeliveryDate(String planDeliveryDate) { this.planDeliveryDate = planDeliveryDate; }

    public String getPlanStartDate() { return planStartDate; }
    public void setPlanStartDate(String planStartDate) { this.planStartDate = planStartDate; }

    public Integer getLeadTimeDays() { return leadTimeDays; }
    public void setLeadTimeDays(Integer leadTimeDays) { this.leadTimeDays = leadTimeDays; }

    public BigDecimal getTargetCapacity() { return targetCapacity; }
    public void setTargetCapacity(BigDecimal targetCapacity) { this.targetCapacity = targetCapacity; }

    public String getConfiguration() { return configuration; }
    public void setConfiguration(String configuration) { this.configuration = configuration; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
