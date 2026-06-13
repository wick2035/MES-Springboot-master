package com.wangziyang.mes.warehouse.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequestItem;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;
import org.apache.ibatis.annotations.Param;

public interface SpWarehouseRequestItemMapper extends BaseMapper<SpWarehouseRequestItem> {

    IPage<SpWarehouseRequestItem> pageItems(IPage<SpWarehouseRequestItem> page, @Param("req") SpWarehouseRequestReq req);
}
