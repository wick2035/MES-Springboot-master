package com.wangziyang.mes.warehouse.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.warehouse.entity.SpWarehouseTransaction;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;

import java.util.Map;

public interface ISpWarehouseTransactionService extends IService<SpWarehouseTransaction> {

    IPage<Map<String, Object>> pageList(SpWarehouseRequestReq req);
}
