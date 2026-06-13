package com.wangziyang.mes.workflow.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.workflow.entity.SpWorkflowInstance;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;

public interface ISpWorkflowTaskService extends IService<SpWorkflowTask> {

    void createFirstTask(SpWorkflowInstance instance);

    Result complete(String taskId, String opinion, SysUser user);

    Result reject(String taskId, String opinion, SysUser user);

    Result transfer(String taskId, String targetUserId, String opinion, SysUser user);

    Result entrust(String taskId, String targetUserId, String opinion, SysUser user);

    Result revoke(String taskId, String opinion, SysUser user, boolean admin);

    Result completeOrderApprovalByBusinessId(String orderId, String opinion, SysUser user);

    boolean canHandle(SpWorkflowTask task, SysUser user);
}
