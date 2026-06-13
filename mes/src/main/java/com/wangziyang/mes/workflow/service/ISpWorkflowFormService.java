package com.wangziyang.mes.workflow.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.workflow.entity.SpWorkflowForm;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;

import java.util.List;

public interface ISpWorkflowFormService extends IService<SpWorkflowForm> {

    Result saveForm(SpWorkflowForm record);

    SpWorkflowForm activeByBusinessType(String businessType);

    void ensureDefaultOrderApprovalForm();

    String renderUrl(String template, SpWorkflowTask task, SysUser user);

    String renderTitle(String template, SpWorkflowTask task, SysUser user);

    void fillTaskFormMeta(List<SpWorkflowTask> tasks, SysUser user);
}
