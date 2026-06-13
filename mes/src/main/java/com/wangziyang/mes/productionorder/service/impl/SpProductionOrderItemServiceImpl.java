package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.mapper.SpProductionOrderItemMapper;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderItemService;
import org.springframework.stereotype.Service;

/**
 * Production order item service implementation.
 */
@Service
public class SpProductionOrderItemServiceImpl extends ServiceImpl<SpProductionOrderItemMapper, SpProductionOrderItem>
        implements ISpProductionOrderItemService {
}
