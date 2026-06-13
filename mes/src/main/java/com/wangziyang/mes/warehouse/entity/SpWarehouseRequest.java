package com.wangziyang.mes.warehouse.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

@TableName("sp_warehouse_request")
public class SpWarehouseRequest extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String requestNo;
    private String businessType;
    private String sourceType;
    private String sourceId;
    private String sourceNo;
    private String warehouseId;
    private String status;
    private Integer itemCount;
    private BigDecimal totalQty;
    private String applyUsername;
    private String applyTime;
    private String confirmUsername;
    private String confirmTime;
    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    @TableField(exist = false)
    private String warehouseCode;

    @TableField(exist = false)
    private String warehouseName;

    @TableField(exist = false)
    private Integer confirmedCount;

    public String getRequestNo() { return requestNo; }
    public void setRequestNo(String requestNo) { this.requestNo = requestNo; }
    public String getBusinessType() { return businessType; }
    public void setBusinessType(String businessType) { this.businessType = businessType; }
    public String getSourceType() { return sourceType; }
    public void setSourceType(String sourceType) { this.sourceType = sourceType; }
    public String getSourceId() { return sourceId; }
    public void setSourceId(String sourceId) { this.sourceId = sourceId; }
    public String getSourceNo() { return sourceNo; }
    public void setSourceNo(String sourceNo) { this.sourceNo = sourceNo; }
    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getItemCount() { return itemCount; }
    public void setItemCount(Integer itemCount) { this.itemCount = itemCount; }
    public BigDecimal getTotalQty() { return totalQty; }
    public void setTotalQty(BigDecimal totalQty) { this.totalQty = totalQty; }
    public String getApplyUsername() { return applyUsername; }
    public void setApplyUsername(String applyUsername) { this.applyUsername = applyUsername; }
    public String getApplyTime() { return applyTime; }
    public void setApplyTime(String applyTime) { this.applyTime = applyTime; }
    public String getConfirmUsername() { return confirmUsername; }
    public void setConfirmUsername(String confirmUsername) { this.confirmUsername = confirmUsername; }
    public String getConfirmTime() { return confirmTime; }
    public void setConfirmTime(String confirmTime) { this.confirmTime = confirmTime; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public Integer getConfirmedCount() { return confirmedCount; }
    public void setConfirmedCount(Integer confirmedCount) { this.confirmedCount = confirmedCount; }
}
