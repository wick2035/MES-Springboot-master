package com.wangziyang.mes.warehouse.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequest;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface SpWarehouseRequestMapper extends BaseMapper<SpWarehouseRequest> {

    IPage<SpWarehouseRequest> pageList(IPage<SpWarehouseRequest> page, @Param("req") SpWarehouseRequestReq req);

    List<Map<String, Object>> ledger(@Param("req") SpWarehouseRequestReq req);
}
