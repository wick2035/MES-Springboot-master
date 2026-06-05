package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;

public interface ISpWarehouseLocationService extends IService<SpWarehouseLocation> {

    /**
     * 按库房分页查询库位（联表回显所属库房编码）
     */
    IPage<SpWarehouseLocation> pageByWarehouse(IPage<SpWarehouseLocation> page, String warehouseId);

    /**
     * 按库房规格（组×排×层×列）重新生成全部库位：先软删旧库位，再生成新库位
     */
    void regenerateLocations(SpWarehouse warehouse);

    /**
     * 软删某库房下的全部库位
     */
    void deleteByWarehouse(String warehouseId);
}
