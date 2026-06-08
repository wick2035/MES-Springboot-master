package com.wangziyang.mes.basedata.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.request.SpInventoryReq;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 库存 Mapper
 *
 * @author Claude
 * @since 2026-06-08
 */
public interface SpInventoryMapper extends BaseMapper<SpInventory> {

    /** 分页查询库存（联表回显库房/库位/物料） */
    IPage<SpInventory> pageList(IPage<SpInventory> page, @Param("req") SpInventoryReq req);

    /** 查询某库房全部库存（含库位坐标，供 3D 场景使用） */
    List<SpInventory> listByWarehouse(@Param("warehouseId") String warehouseId);
}
