package com.wangziyang.mes.productionorder.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * Material requirement planning result line.
 */
@TableName("sp_material_requirement_plan")
public class SpMaterialRequirementPlan extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String productionOrderId;

    private String productionOrderNo;

    private String orderItemId;

    private String productSerialNo;

    private String productMateriel;

    private String productName;

    private String materialId;

    private String materialCode;

    private String materialName;

    private String materialType;

    private String materialSource;

    private String unit;

    private Integer bomLevel;

    private String bomPath;

    private BigDecimal grossRequirement;

    private BigDecimal availableStock;

    private BigDecimal safetyStock;

    private BigDecimal netRequirement;

    private String requirementDate;

    private Integer leadTimeDays;

    private String releaseDate;

    private String deliveryStatus;

    private String inboundStatus;

    private String inboundRequestId;

    private String inboundRequestNo;

    private String outboundStatus;

    private String outboundRequestId;

    private String outboundRequestNo;

    private String calcBatchNo;

    private String calcTime;

    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getProductionOrderId() { return productionOrderId; }
    public void setProductionOrderId(String productionOrderId) { this.productionOrderId = productionOrderId; }

    public String getProductionOrderNo() { return productionOrderNo; }
    public void setProductionOrderNo(String productionOrderNo) { this.productionOrderNo = productionOrderNo; }

    public String getOrderItemId() { return orderItemId; }
    public void setOrderItemId(String orderItemId) { this.orderItemId = orderItemId; }

    public String getProductSerialNo() { return productSerialNo; }
    public void setProductSerialNo(String productSerialNo) { this.productSerialNo = productSerialNo; }

    public String getProductMateriel() { return productMateriel; }
    public void setProductMateriel(String productMateriel) { this.productMateriel = productMateriel; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getMaterialId() { return materialId; }
    public void setMaterialId(String materialId) { this.materialId = materialId; }

    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public String getMaterialType() { return materialType; }
    public void setMaterialType(String materialType) { this.materialType = materialType; }

    public String getMaterialSource() { return materialSource; }
    public void setMaterialSource(String materialSource) { this.materialSource = materialSource; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public Integer getBomLevel() { return bomLevel; }
    public void setBomLevel(Integer bomLevel) { this.bomLevel = bomLevel; }

    public String getBomPath() { return bomPath; }
    public void setBomPath(String bomPath) { this.bomPath = bomPath; }

    public BigDecimal getGrossRequirement() { return grossRequirement; }
    public void setGrossRequirement(BigDecimal grossRequirement) { this.grossRequirement = grossRequirement; }

    public BigDecimal getAvailableStock() { return availableStock; }
    public void setAvailableStock(BigDecimal availableStock) { this.availableStock = availableStock; }

    public BigDecimal getSafetyStock() { return safetyStock; }
    public void setSafetyStock(BigDecimal safetyStock) { this.safetyStock = safetyStock; }

    public BigDecimal getNetRequirement() { return netRequirement; }
    public void setNetRequirement(BigDecimal netRequirement) { this.netRequirement = netRequirement; }

    public String getRequirementDate() { return requirementDate; }
    public void setRequirementDate(String requirementDate) { this.requirementDate = requirementDate; }

    public Integer getLeadTimeDays() { return leadTimeDays; }
    public void setLeadTimeDays(Integer leadTimeDays) { this.leadTimeDays = leadTimeDays; }

    public String getReleaseDate() { return releaseDate; }
    public void setReleaseDate(String releaseDate) { this.releaseDate = releaseDate; }

    public String getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(String deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public String getInboundStatus() { return inboundStatus; }
    public void setInboundStatus(String inboundStatus) { this.inboundStatus = inboundStatus; }

    public String getInboundRequestId() { return inboundRequestId; }
    public void setInboundRequestId(String inboundRequestId) { this.inboundRequestId = inboundRequestId; }

    public String getInboundRequestNo() { return inboundRequestNo; }
    public void setInboundRequestNo(String inboundRequestNo) { this.inboundRequestNo = inboundRequestNo; }

    public String getOutboundStatus() { return outboundStatus; }
    public void setOutboundStatus(String outboundStatus) { this.outboundStatus = outboundStatus; }

    public String getOutboundRequestId() { return outboundRequestId; }
    public void setOutboundRequestId(String outboundRequestId) { this.outboundRequestId = outboundRequestId; }

    public String getOutboundRequestNo() { return outboundRequestNo; }
    public void setOutboundRequestNo(String outboundRequestNo) { this.outboundRequestNo = outboundRequestNo; }

    public String getCalcBatchNo() { return calcBatchNo; }
    public void setCalcBatchNo(String calcBatchNo) { this.calcBatchNo = calcBatchNo; }

    public String getCalcTime() { return calcTime; }
    public void setCalcTime(String calcTime) { this.calcTime = calcTime; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
