package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;

public interface ISpProcessingUnitService extends IService<SpProcessingUnit> {

    /** 生成下一个加工单元编号 JG000001 */
    String nextUnitCode();

    /** 加工单元编码是否重复（排除已删除，编辑时排除自身） */
    boolean isUnitCodeDuplicate(String unitCode, String excludeId);
}
