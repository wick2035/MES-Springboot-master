package com.wangziyang.mes.warehouse.request;

import java.math.BigDecimal;

public class SpWarehouseConfirmReq {

    private String itemId;
    private String warehouseId;
    private String locationId;
    private BigDecimal qty;

    public String getItemId() { return itemId; }
    public void setItemId(String itemId) { this.itemId = itemId; }
    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }
    public String getLocationId() { return locationId; }
    public void setLocationId(String locationId) { this.locationId = locationId; }
    public BigDecimal getQty() { return qty; }
    public void setQty(BigDecimal qty) { this.qty = qty; }
}
