package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.request.SpInventoryReq;

import java.util.List;

/**
 * 库存服务
 *
 * @author Claude
 * @since 2026-06-08
 */
public interface ISpInventoryService extends IService<SpInventory> {

    /** 分页查询库存（联表回显） */
    IPage<SpInventory> pageList(SpInventoryReq req);

    /** 查询某库房全部库存（供 3D 场景使用） */
    List<SpInventory> listByWarehouse(String warehouseId);

    /** 入库：同一(库位+物料+批号)已有则累加数量，否则新增；保存时从物料带出单位 */
    void inbound(SpInventory record);
}
