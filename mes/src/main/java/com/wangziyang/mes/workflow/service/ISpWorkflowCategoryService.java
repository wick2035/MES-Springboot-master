package com.wangziyang.mes.workflow.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.entity.SpWorkflowCategory;

public interface ISpWorkflowCategoryService extends IService<SpWorkflowCategory> {

    Result saveCategory(SpWorkflowCategory record);
}
