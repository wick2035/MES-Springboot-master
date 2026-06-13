package com.wangziyang.mes.warehouse.request;

import java.math.BigDecimal;

public class SpWarehouseApplyReq {

    private String businessType;
    private String warehouseId;
    private String locationId;
    private String materialId;
    private String batchNo;
    private BigDecimal qty;
    private String remark;

    public String getBusinessType() { return businessType; }
    public void setBusinessType(String businessType) { this.businessType = businessType; }
    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }
    public String getLocationId() { return locationId; }
    public void setLocationId(String locationId) { this.locationId = locationId; }
    public String getMaterialId() { return materialId; }
    public void setMaterialId(String materialId) { this.materialId = materialId; }
    public String getBatchNo() { return batchNo; }
    public void setBatchNo(String batchNo) { this.batchNo = batchNo; }
    public BigDecimal getQty() { return qty; }
    public void setQty(BigDecimal qty) { this.qty = qty; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
