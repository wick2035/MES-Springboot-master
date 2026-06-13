package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 库存分页查询参数
 *
 * @author Claude
 * @since 2026-06-08
 */
public class SpInventoryReq extends BasePageReq {

    /** 库房ID */
    private String warehouseId;
    /** 物料编码/名称（模糊） */
    private String materielLike;
    /** 库位编码（模糊） */
    private String locationCodeLike;
    private String batchNoLike;
    private String stockStatus;

    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }

    public String getMaterielLike() { return materielLike; }
    public void setMaterielLike(String materielLike) { this.materielLike = materielLike; }

    public String getLocationCodeLike() { return locationCodeLike; }
    public void setLocationCodeLike(String locationCodeLike) { this.locationCodeLike = locationCodeLike; }

    public String getBatchNoLike() { return batchNoLike; }
    public void setBatchNoLike(String batchNoLike) { this.batchNoLike = batchNoLike; }

    public String getStockStatus() { return stockStatus; }
    public void setStockStatus(String stockStatus) { this.stockStatus = stockStatus; }
}
