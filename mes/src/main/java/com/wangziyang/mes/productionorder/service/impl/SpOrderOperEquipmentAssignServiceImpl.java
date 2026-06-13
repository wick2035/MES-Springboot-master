package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.productionorder.entity.SpOrderOperEquipmentAssign;
import com.wangziyang.mes.productionorder.mapper.SpOrderOperEquipmentAssignMapper;
import com.wangziyang.mes.productionorder.service.ISpOrderOperEquipmentAssignService;
import org.springframework.stereotype.Service;

@Service
public class SpOrderOperEquipmentAssignServiceImpl
        extends ServiceImpl<SpOrderOperEquipmentAssignMapper, SpOrderOperEquipmentAssign>
        implements ISpOrderOperEquipmentAssignService {
}
