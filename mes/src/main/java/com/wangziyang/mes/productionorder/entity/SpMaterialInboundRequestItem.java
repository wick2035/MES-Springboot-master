package com.wangziyang.mes.productionorder.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * Inbound request item.
 */
@TableName("sp_material_inbound_request_item")
public class SpMaterialInboundRequestItem extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String requestId;

    private String requestNo;

    private String planId;

    private String productionOrderId;

    private String productionOrderNo;

    private String materialId;

    private String materialCode;

    private String materialName;

    private String unit;

    private BigDecimal requestQty;

    private String requirementDate;

    private String releaseDate;

    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }

    public String getRequestNo() { return requestNo; }
    public void setRequestNo(String requestNo) { this.requestNo = requestNo; }

    public String getPlanId() { return planId; }
    public void setPlanId(String planId) { this.planId = planId; }

    public String getProductionOrderId() { return productionOrderId; }
    public void setProductionOrderId(String productionOrderId) { this.productionOrderId = productionOrderId; }

    public String getProductionOrderNo() { return productionOrderNo; }
    public void setProductionOrderNo(String productionOrderNo) { this.productionOrderNo = productionOrderNo; }

    public String getMaterialId() { return materialId; }
    public void setMaterialId(String materialId) { this.materialId = materialId; }

    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public BigDecimal getRequestQty() { return requestQty; }
    public void setRequestQty(BigDecimal requestQty) { this.requestQty = requestQty; }

    public String getRequirementDate() { return requirementDate; }
    public void setRequirementDate(String requirementDate) { this.requirementDate = requirementDate; }

    public String getReleaseDate() { return releaseDate; }
    public void setReleaseDate(String releaseDate) { this.releaseDate = releaseDate; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
