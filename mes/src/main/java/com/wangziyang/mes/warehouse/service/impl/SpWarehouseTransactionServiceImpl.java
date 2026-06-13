package com.wangziyang.mes.warehouse.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.warehouse.entity.SpWarehouseTransaction;
import com.wangziyang.mes.warehouse.mapper.SpWarehouseTransactionMapper;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;
import com.wangziyang.mes.warehouse.service.ISpWarehouseTransactionService;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class SpWarehouseTransactionServiceImpl
        extends ServiceImpl<SpWarehouseTransactionMapper, SpWarehouseTransaction>
        implements ISpWarehouseTransactionService {

    @Override
    public IPage<Map<String, Object>> pageList(SpWarehouseRequestReq req) {
        if (req == null) {
            req = new SpWarehouseRequestReq();
        }
        return baseMapper.pageList(new Page<Map<String, Object>>(req.getCurrent(), req.getSize()), req);
    }
}
