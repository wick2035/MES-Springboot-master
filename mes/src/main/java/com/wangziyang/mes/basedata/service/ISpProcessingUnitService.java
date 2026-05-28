package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;

public interface ISpProcessingUnitService extends IService<SpProcessingUnit> {

    /** 生成下一个加工单元编号 JG000001 */
    String nextUnitCode();
}
