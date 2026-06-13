package com.wangziyang.mes.warehouse.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_warehouse_transaction")
public class SpWarehouseTransaction extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String transactionNo;
    private String requestId;
    private String requestNo;
    private String requestItemId;
    private String direction;
    private String businessType;
    private String warehouseId;
    private String locationId;
    private String materialId;
    private String batchNo;
    private BigDecimal qty;
    private BigDecimal beforeQty;
    private BigDecimal afterQty;
    private String operatorUsername;
    private String operateTime;
    private String remark;

    public String getTransactionNo() { return transactionNo; }
    public void setTransactionNo(String transactionNo) { this.transactionNo = transactionNo; }
    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }
    public String getRequestNo() { return requestNo; }
    public void setRequestNo(String requestNo) { this.requestNo = requestNo; }
    public String getRequestItemId() { return requestItemId; }
    public void setRequestItemId(String requestItemId) { this.requestItemId = requestItemId; }
    public String getDirection() { return direction; }
    public void setDirection(String direction) { this.direction = direction; }
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
    public BigDecimal getBeforeQty() { return beforeQty; }
    public void setBeforeQty(BigDecimal beforeQty) { this.beforeQty = beforeQty; }
    public BigDecimal getAfterQty() { return afterQty; }
    public void setAfterQty(BigDecimal afterQty) { this.afterQty = afterQty; }
    public String getOperatorUsername() { return operatorUsername; }
    public void setOperatorUsername(String operatorUsername) { this.operatorUsername = operatorUsername; }
    public String getOperateTime() { return operateTime; }
    public void setOperateTime(String operateTime) { this.operateTime = operateTime; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
