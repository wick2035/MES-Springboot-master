package com.wangziyang.mes.warehouse.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequestItem;
import com.wangziyang.mes.warehouse.mapper.SpWarehouseRequestItemMapper;
import com.wangziyang.mes.warehouse.service.ISpWarehouseRequestItemService;
import org.springframework.stereotype.Service;

@Service
public class SpWarehouseRequestItemServiceImpl
        extends ServiceImpl<SpWarehouseRequestItemMapper, SpWarehouseRequestItem>
        implements ISpWarehouseRequestItemService {
}
