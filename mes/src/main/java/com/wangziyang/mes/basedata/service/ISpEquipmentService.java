package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpEquipment;

public interface ISpEquipmentService extends IService<SpEquipment> {
    String nextEquipmentCode();
}
