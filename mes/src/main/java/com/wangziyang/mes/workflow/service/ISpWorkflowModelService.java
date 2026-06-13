package com.wangziyang.mes.workflow.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.entity.SpWorkflowModel;

public interface ISpWorkflowModelService extends IService<SpWorkflowModel> {

    Result saveModel(SpWorkflowModel record);
}
