package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * 库存实体（记录某库位上某物料的批次与数量）
 *
 * @author Claude
 * @since 2026-06-08
 */
@TableName(value = "sp_inventory")
public class SpInventory extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 所属库房ID */
    private String warehouseId;
    /** 所属库位ID */
    private String locationId;
    /** 物料ID */
    private String materielId;
    /** 批号 */
    private String batchNo;
    /** 数量 */
    private BigDecimal qty;
    /** 单位（保存时从物料带出） */
    private String unit;
    private String stockStatus;

    /** 状态 0正常 1删除 */
    @TableField(value = "is_deleted")
    private String deleted;

    /** 展示字段：库房编码 */
    @TableField(exist = false)
    private String warehouseCode;
    /** 展示字段：库房名称 */
    @TableField(exist = false)
    private String warehouseName;
    /** 展示字段：库位编码 */
    @TableField(exist = false)
    private String locationCode;
    /** 展示字段：库位坐标-组 */
    @TableField(exist = false)
    private Integer groupNo;
    /** 展示字段：库位坐标-排 */
    @TableField(exist = false)
    private Integer rowNo;
    /** 展示字段：库位坐标-层 */
    @TableField(exist = false)
    private Integer layerNo;
    /** 展示字段：库位坐标-列 */
    @TableField(exist = false)
    private Integer columnNo;
    /** 展示字段：物料编码 */
    @TableField(exist = false)
    private String materielCode;
    /** 展示字段：物料名称 */
    @TableField(exist = false)
    private String materielDesc;

    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }

    public String getLocationId() { return locationId; }
    public void setLocationId(String locationId) { this.locationId = locationId; }

    public String getMaterielId() { return materielId; }
    public void setMaterielId(String materielId) { this.materielId = materielId; }

    public String getBatchNo() { return batchNo; }
    public void setBatchNo(String batchNo) { this.batchNo = batchNo; }

    public BigDecimal getQty() { return qty; }
    public void setQty(BigDecimal qty) { this.qty = qty; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getStockStatus() { return stockStatus; }
    public void setStockStatus(String stockStatus) { this.stockStatus = stockStatus; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }

    public String getLocationCode() { return locationCode; }
    public void setLocationCode(String locationCode) { this.locationCode = locationCode; }

    public Integer getGroupNo() { return groupNo; }
    public void setGroupNo(Integer groupNo) { this.groupNo = groupNo; }

    public Integer getRowNo() { return rowNo; }
    public void setRowNo(Integer rowNo) { this.rowNo = rowNo; }

    public Integer getLayerNo() { return layerNo; }
    public void setLayerNo(Integer layerNo) { this.layerNo = layerNo; }

    public Integer getColumnNo() { return columnNo; }
    public void setColumnNo(Integer columnNo) { this.columnNo = columnNo; }

    public String getMaterielCode() { return materielCode; }
    public void setMaterielCode(String materielCode) { this.materielCode = materielCode; }

    public String getMaterielDesc() { return materielDesc; }
    public void setMaterielDesc(String materielDesc) { this.materielDesc = materielDesc; }
}
