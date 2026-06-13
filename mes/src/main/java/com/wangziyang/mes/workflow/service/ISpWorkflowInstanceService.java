package com.wangziyang.mes.workflow.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.productionorder.entity.SpWorkOrderChange;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.workflow.entity.SpWorkflowInstance;

public interface ISpWorkflowInstanceService extends IService<SpWorkflowInstance> {

    SpWorkflowInstance startOrderApproval(SpOrder order, SysUser user);

    SpWorkflowInstance startWorkOrderChangeApproval(SpWorkOrderChange change, SysUser user);
}
