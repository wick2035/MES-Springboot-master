package com.wangziyang.mes.warehouse.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpWarehouseRequestReq extends BasePageReq {

    private String businessType;
    private String status;
    private String requestNoLike;
    private String sourceNoLike;
    private String warehouseId;
    private String materialLike;
    private String batchNoLike;
    private String direction;
    private String beginDate;
    private String endDate;

    public String getBusinessType() { return businessType; }
    public void setBusinessType(String businessType) { this.businessType = businessType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRequestNoLike() { return requestNoLike; }
    public void setRequestNoLike(String requestNoLike) { this.requestNoLike = requestNoLike; }
    public String getSourceNoLike() { return sourceNoLike; }
    public void setSourceNoLike(String sourceNoLike) { this.sourceNoLike = sourceNoLike; }
    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }
    public String getMaterialLike() { return materialLike; }
    public void setMaterialLike(String materialLike) { this.materialLike = materialLike; }
    public String getBatchNoLike() { return batchNoLike; }
    public void setBatchNoLike(String batchNoLike) { this.batchNoLike = batchNoLike; }
    public String getDirection() { return direction; }
    public void setDirection(String direction) { this.direction = direction; }
    public String getBeginDate() { return beginDate; }
    public void setBeginDate(String beginDate) { this.beginDate = beginDate; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
}
