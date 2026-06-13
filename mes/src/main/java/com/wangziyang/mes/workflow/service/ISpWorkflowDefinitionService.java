package com.wangziyang.mes.workflow.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.entity.SpWorkflowDefinition;
import com.wangziyang.mes.workflow.entity.SpWorkflowModel;

public interface ISpWorkflowDefinitionService extends IService<SpWorkflowDefinition> {

    Result publish(String modelId);

    Result changeStatus(String id, String status);

    SpWorkflowDefinition activeDefinition(String businessType);

    SpWorkflowDefinition ensureDefaultOrderApprovalDefinition();

    SpWorkflowModel ensureDefaultOrderApprovalModel();

    SpWorkflowDefinition ensureDefaultWorkOrderChangeDefinition();

    SpWorkflowModel ensureDefaultWorkOrderChangeModel();
}
