package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 库位实体（依库房规格自动生成）
 *
 * @author Claude
 * @since 2026-06-05
 */
@TableName(value = "sp_warehouse_location")
public class SpWarehouseLocation extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 所属库房ID */
    private String warehouseId;
    /** 库位编码 如 KF001-1-2-3-4 */
    private String locationCode;

    /** 坐标-组 */
    private Integer groupNo;
    /** 坐标-排 */
    private Integer rowNo;
    /** 坐标-层 */
    private Integer layerNo;
    /** 坐标-列 */
    private Integer columnNo;

    /** 状态 0正常 2禁用 */
    private String status;

    /** 状态 0正常 1删除 */
    @TableField(value = "is_deleted")
    private String deleted;

    /** 展示字段：所属库房编码（联表 sp_warehouse.warehouse_code 回显，不存库） */
    @TableField(exist = false)
    private String warehouseCode;

    public String getWarehouseId() { return warehouseId; }
    public void setWarehouseId(String warehouseId) { this.warehouseId = warehouseId; }

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

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
}
