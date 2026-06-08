package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 库房实体
 *
 * @author Claude
 * @since 2026-06-05
 */
@TableName(value = "sp_warehouse")
public class SpWarehouse extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 库房编码（唯一） */
    private String warehouseCode;
    /** 库房名称 */
    private String warehouseName;
    /** 库房类型 1原材料库 2成品库 3半成品库 */
    private String warehouseType;
    /** 库房描述 */
    private String warehouseDesc;

    /** 规格-组 */
    private Integer specGroup;
    /** 规格-排 */
    private Integer specRow;
    /** 规格-层 */
    private Integer specLayer;
    /** 规格-列 */
    private Integer specColumn;

    /** 备注信息 */
    private String remark;

    /** 状态 0正常 1删除 2禁用 */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }

    public String getWarehouseType() { return warehouseType; }
    public void setWarehouseType(String warehouseType) { this.warehouseType = warehouseType; }

    public String getWarehouseDesc() { return warehouseDesc; }
    public void setWarehouseDesc(String warehouseDesc) { this.warehouseDesc = warehouseDesc; }

    public Integer getSpecGroup() { return specGroup; }
    public void setSpecGroup(Integer specGroup) { this.specGroup = specGroup; }

    public Integer getSpecRow() { return specRow; }
    public void setSpecRow(Integer specRow) { this.specRow = specRow; }

    public Integer getSpecLayer() { return specLayer; }
    public void setSpecLayer(Integer specLayer) { this.specLayer = specLayer; }

    public Integer getSpecColumn() { return specColumn; }
    public void setSpecColumn(Integer specColumn) { this.specColumn = specColumn; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
