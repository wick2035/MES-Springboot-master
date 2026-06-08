package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 库房分页查询参数
 *
 * @author Claude
 * @since 2026-06-05
 */
public class SpWarehouseReq extends BasePageReq {

    /** 库房编码（右模糊） */
    private String warehouseCodeLike;
    /** 库房名称（右模糊） */
    private String warehouseNameLike;
    /** 库房类型 1原材料库 2成品库 3半成品库 */
    private String warehouseType;

    public String getWarehouseCodeLike() { return warehouseCodeLike; }
    public void setWarehouseCodeLike(String warehouseCodeLike) { this.warehouseCodeLike = warehouseCodeLike; }

    public String getWarehouseNameLike() { return warehouseNameLike; }
    public void setWarehouseNameLike(String warehouseNameLike) { this.warehouseNameLike = warehouseNameLike; }

    public String getWarehouseType() { return warehouseType; }
    public void setWarehouseType(String warehouseType) { this.warehouseType = warehouseType; }
}
