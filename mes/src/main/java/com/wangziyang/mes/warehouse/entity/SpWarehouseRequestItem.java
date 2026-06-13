package com.wangziyang.mes.warehouse.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_warehouse_request_item")
public class SpWarehouseRequestItem extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String requestId;
    private String materialId;
    private String materialCode;
    private String materialName;
    private String warehouseId;
    private String locationId;
    private String batchNo;
    private BigDecimal requestQty;
    private BigDecimal confirmedQty;
    private String unit;
    private String status;
    private String sourceItemId;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    @TableField(exist = false)
    private String requestNo;

    @TableField(exist = false)
    private String businessType;

    @TableField(exist = false)
    private String warehouseCode;

    @TableField(exist = false)
    private String warehouseName;

    @TableField(exist = false)
    private String locationCode;

    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }
    public String getMaterialId() { return materialId; }
    public void setMaterialId(String materialId) { this.materialId = materialId; }
    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }
    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }
    public String getLocationId() { return locationId; }
    public void setLocationId(String locationId) { this.locationId = locationId; }
    public String getBatchNo() { return batchNo; }
    public void setBatchNo(String batchNo) { this.batchNo = batchNo; }
    public BigDecimal getRequestQty() { return requestQty; }
    public void setRequestQty(BigDecimal requestQty) { this.requestQty = requestQty; }
    public BigDecimal getConfirmedQty() { return confirmedQty; }
    public void setConfirmedQty(BigDecimal confirmedQty) { this.confirmedQty = confirmedQty; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getSourceItemId() { return sourceItemId; }
    public void setSourceItemId(String sourceItemId) { this.sourceItemId = sourceItemId; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
    public String getRequestNo() { return requestNo; }
    public void setRequestNo(String requestNo) { this.requestNo = requestNo; }
    public String getBusinessType() { return businessType; }
    public void setBusinessType(String businessType) { this.businessType = businessType; }
    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public String getLocationCode() { return locationCode; }
    public void setLocationCode(String locationCode) { this.locationCode = locationCode; }
}
