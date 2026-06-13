package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.entity.SpWorkOrderChange;
import com.wangziyang.mes.productionorder.mapper.SpWorkOrderChangeMapper;
import com.wangziyang.mes.productionorder.request.WorkOrderChangeReq;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderItemService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.productionorder.service.ISpWorkOrderChangeService;
import com.wangziyang.mes.productionorder.service.impl.SpProductionOrderServiceImpl;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.service.ISpSnProcessRecordService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class SpWorkOrderChangeServiceImpl extends ServiceImpl<SpWorkOrderChangeMapper, SpWorkOrderChange>
        implements ISpWorkOrderChangeService {

    private static final DateTimeFormatter DT_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final String WORK_STATUS_STARTED = "STARTED";

    @Autowired
    private ISpOrderService workOrderService;

    @Autowired
    private ISpProductionOrderItemService itemService;

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @Autowired
    private ISpSnProcessRecordService snProcessRecordService;

    @Override
    public boolean hasStarted(String workOrderId) {
        if (StringUtils.isBlank(workOrderId)) {
            return false;
        }
        SpOrder workOrder = workOrderService.getById(workOrderId);
        if (workOrder != null && WORK_STATUS_STARTED.equals(workOrder.getWorkStatus())) {
            return true;
        }
        return snProcessRecordService.count(new QueryWrapper<SpSnProcessRecord>()
                .eq("order_id", workOrderId)) > 0;
    }

    @Override
    public boolean hasApprovingChange(String workOrderId) {
        if (StringUtils.isBlank(workOrderId)) {
            return false;
        }
        return count(new QueryWrapper<SpWorkOrderChange>()
                .eq("work_order_id", workOrderId)
                .eq("status", STATUS_APPROVING)) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result updateUnstarted(SpOrder workOrder, SpProductionOrderItem item, WorkOrderChangeReq req) {
        applyToWorkOrder(workOrder, req);
        workOrderService.updateById(workOrder);

        SpProductionOrderItem itemUpdate = new SpProductionOrderItem();
        itemUpdate.setId(item.getId());
        itemUpdate.setQty(req.getQty());
        itemService.updateById(itemUpdate);
        return Result.success(null, "修改成功");
    }

    @Override
    public SpWorkOrderChange buildApprovingChange(SpOrder workOrder, SpProductionOrder order,
                                                  SpProductionOrderItem item, WorkOrderChangeReq req) {
        SpWorkOrderChange change = new SpWorkOrderChange();
        change.setWorkOrderId(workOrder.getId());
        change.setWorkOrderCode(workOrder.getOrderCode());
        change.setProductionOrderId(order.getId());
        change.setOrderItemId(item.getId());
        change.setBeforeFlowId(workOrder.getFlowId());
        change.setAfterFlowId(StringUtils.trimToEmpty(req.getFlowId()));
        change.setBeforeQty(workOrder.getQty());
        change.setAfterQty(req.getQty());
        change.setBeforePlanStartTime(workOrder.getPlanStartTime());
        change.setAfterPlanStartTime(StringUtils.trimToEmpty(req.getPlanStartTime()));
        change.setBeforePlanEndTime(workOrder.getPlanEndTime());
        change.setAfterPlanEndTime(StringUtils.trimToEmpty(req.getPlanEndTime()));
        change.setBeforeRemark(workOrder.getRemark());
        change.setAfterRemark(StringUtils.trimToEmpty(req.getRemark()));
        change.setStatus(STATUS_APPROVING);
        return change;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result applyApprovedChange(String changeId, String approveTime) {
        SpWorkOrderChange change = getById(changeId);
        if (change == null) {
            return Result.failure("工单变更申请不存在");
        }
        if (STATUS_APPLIED.equals(change.getStatus())) {
            return Result.success(null, "工单变更已生效");
        }
        SpOrder workOrder = workOrderService.getById(change.getWorkOrderId());
        if (workOrder == null) {
            return Result.failure("工单不存在，无法应用变更");
        }
        if (workOrder.getStatue() == null || workOrder.getStatue() != 5) {
            return Result.failure("工单不是已下发状态，无法应用变更");
        }
        SpProductionOrderItem item = itemService.getById(change.getOrderItemId());
        if (item == null || !StringUtils.equals(item.getWorkOrderId(), workOrder.getId())) {
            return Result.failure("工单来源计划明细不存在，无法应用变更");
        }
        SpProductionOrder productionOrder = productionOrderService.getById(change.getProductionOrderId());
        if (productionOrder == null || "1".equals(productionOrder.getDeleted())
                || !SpProductionOrderServiceImpl.OP_DISPATCHED.equals(productionOrder.getOperationStatus())) {
            return Result.failure("来源生产计划不是已下发状态，无法应用变更");
        }

        WorkOrderChangeReq req = new WorkOrderChangeReq();
        req.setId(workOrder.getId());
        req.setFlowId(change.getAfterFlowId());
        req.setQty(change.getAfterQty());
        req.setPlanStartTime(change.getAfterPlanStartTime());
        req.setPlanEndTime(change.getAfterPlanEndTime());
        req.setRemark(change.getAfterRemark());
        applyToWorkOrder(workOrder, req);
        workOrderService.updateById(workOrder);

        SpProductionOrderItem itemUpdate = new SpProductionOrderItem();
        itemUpdate.setId(item.getId());
        itemUpdate.setQty(change.getAfterQty());
        itemService.updateById(itemUpdate);

        change.setStatus(STATUS_APPLIED);
        change.setApplyTime(StringUtils.defaultIfBlank(approveTime, now()));
        updateById(change);
        return Result.success(null, "工单变更已生效");
    }

    @Override
    public void rejectChange(String changeId) {
        if (StringUtils.isBlank(changeId)) {
            return;
        }
        SpWorkOrderChange change = getById(changeId);
        if (change == null || !STATUS_APPROVING.equals(change.getStatus())) {
            return;
        }
        change.setStatus(STATUS_REJECTED);
        updateById(change);
    }

    private void applyToWorkOrder(SpOrder workOrder, WorkOrderChangeReq req) {
        workOrder.setFlowId(StringUtils.trimToEmpty(req.getFlowId()));
        workOrder.setQty(req.getQty());
        workOrder.setPlanStartTime(StringUtils.trimToEmpty(req.getPlanStartTime()));
        workOrder.setPlanEndTime(StringUtils.trimToEmpty(req.getPlanEndTime()));
        workOrder.setRemark(StringUtils.trimToEmpty(req.getRemark()));
    }

    private String now() {
        return LocalDateTime.now().format(DT_FMT);
    }
}
