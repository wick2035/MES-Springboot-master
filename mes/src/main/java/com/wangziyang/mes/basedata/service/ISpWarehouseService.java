package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpWarehouse;

public interface ISpWarehouseService extends IService<SpWarehouse> {

    /**
     * 库房编码是否重复（排除已删除，编辑时排除自身）
     */
    boolean isWarehouseCodeDuplicate(String warehouseCode, String excludeId);

    /**
     * 保存/更新库房，并按规格重新生成全部库位
     */
    void saveOrUpdateWithLocations(SpWarehouse record);

    /**
     * 软删库房，并一并软删其库位
     */
    void deleteWithLocations(String id);
}
