package com.wangziyang.mes.warehouse.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.warehouse.entity.SpWarehouseTransaction;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

public interface SpWarehouseTransactionMapper extends BaseMapper<SpWarehouseTransaction> {

    IPage<Map<String, Object>> pageList(IPage<Map<String, Object>> page, @Param("req") SpWarehouseRequestReq req);
}
