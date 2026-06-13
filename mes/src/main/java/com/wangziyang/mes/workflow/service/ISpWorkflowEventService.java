package com.wangziyang.mes.workflow.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.workflow.entity.SpWorkflowEvent;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;

public interface ISpWorkflowEventService extends IService<SpWorkflowEvent> {

    void rebuildDefinitionEvents(String definitionId, String nodeJson);

    void executeCompleteEvents(SpWorkflowTask task);
}
