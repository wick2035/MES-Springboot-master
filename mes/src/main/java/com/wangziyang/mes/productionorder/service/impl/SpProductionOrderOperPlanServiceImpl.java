package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderOperPlan;
import com.wangziyang.mes.productionorder.mapper.SpProductionOrderOperPlanMapper;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderOperPlanService;
import org.springframework.stereotype.Service;

/**
 * Production order operation plan service implementation.
 */
@Service
public class SpProductionOrderOperPlanServiceImpl
        extends ServiceImpl<SpProductionOrderOperPlanMapper, SpProductionOrderOperPlan>
        implements ISpProductionOrderOperPlanService {
}
