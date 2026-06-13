package com.wangziyang.mes.productionorder.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.entity.SpWorkOrderChange;
import com.wangziyang.mes.productionorder.request.WorkOrderChangeReq;

public interface ISpWorkOrderChangeService extends IService<SpWorkOrderChange> {

    String STATUS_APPROVING = "APPROVING";
    String STATUS_APPROVED = "APPROVED";
    String STATUS_REJECTED = "REJECTED";
    String STATUS_APPLIED = "APPLIED";

    boolean hasStarted(String workOrderId);

    boolean hasApprovingChange(String workOrderId);

    Result updateUnstarted(SpOrder workOrder, SpProductionOrderItem item, WorkOrderChangeReq req);

    SpWorkOrderChange buildApprovingChange(SpOrder workOrder, SpProductionOrder order,
                                           SpProductionOrderItem item, WorkOrderChangeReq req);

    Result applyApprovedChange(String changeId, String approveTime);

    void rejectChange(String changeId);
}
