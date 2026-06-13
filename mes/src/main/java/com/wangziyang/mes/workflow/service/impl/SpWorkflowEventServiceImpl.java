package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderItemService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.productionorder.service.ISpWorkOrderChangeService;
import com.wangziyang.mes.productionorder.service.impl.SpProductionOrderServiceImpl;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.dto.WorkflowNodeDTO;
import com.wangziyang.mes.workflow.dto.WorkflowNodeEventDTO;
import com.wangziyang.mes.workflow.entity.SpWorkflowEvent;
import com.wangziyang.mes.workflow.entity.SpWorkflowEventLog;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;
import com.wangziyang.mes.workflow.mapper.SpWorkflowEventMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowEventLogService;
import com.wangziyang.mes.workflow.service.ISpWorkflowEventService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SpWorkflowEventServiceImpl extends ServiceImpl<SpWorkflowEventMapper, SpWorkflowEvent>
        implements ISpWorkflowEventService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpProductionOrderItemService productionOrderItemService;

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @Autowired
    private ISpWorkOrderChangeService workOrderChangeService;

    @Autowired
    private ISpWorkflowEventLogService eventLogService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rebuildDefinitionEvents(String definitionId, String nodeJson) {
        remove(new QueryWrapper<SpWorkflowEvent>().eq("definition_id", definitionId));
        List<SpWorkflowEvent> events = new ArrayList<>();
        try {
            List<WorkflowNodeDTO> nodes = objectMapper.readValue(nodeJson, new TypeReference<List<WorkflowNodeDTO>>() {});
            for (WorkflowNodeDTO node : nodes) {
                if (node.getEvents() == null) {
                    continue;
                }
                int sort = 1;
                for (WorkflowNodeEventDTO e : node.getEvents()) {
                    if (StringUtils.isBlank(e.getActionCode())) {
                        continue;
                    }
                    SpWorkflowEvent event = new SpWorkflowEvent();
                    event.setDefinitionId(definitionId);
                    event.setNodeKey(node.getNodeKey());
                    event.setEventType(StringUtils.defaultIfBlank(e.getEventType(), WorkflowConstants.EVENT_COMPLETE));
                    event.setActionCode(e.getActionCode());
                    event.setActionName(StringUtils.defaultIfBlank(e.getActionName(), e.getActionCode()));
                    event.setStatus(WorkflowConstants.STATUS_NORMAL);
                    event.setSortNum(sort++);
                    events.add(event);
                }
            }
        } catch (Exception ignore) {
            events.clear();
        }
        if (!events.isEmpty()) {
            saveBatch(events);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void executeCompleteEvents(SpWorkflowTask task) {
        List<SpWorkflowEvent> events = list(new QueryWrapper<SpWorkflowEvent>()
                .eq("definition_id", task.getDefinitionId())
                .eq("node_key", task.getNodeKey())
                .eq("event_type", WorkflowConstants.EVENT_COMPLETE)
                .eq("status", WorkflowConstants.STATUS_NORMAL)
                .orderByAsc("sort_num"));
        for (SpWorkflowEvent event : events) {
            executeEvent(event, task);
        }
    }

    private void executeEvent(SpWorkflowEvent event, SpWorkflowTask task) {
        SpWorkflowEventLog log = new SpWorkflowEventLog();
        log.setDefinitionId(task.getDefinitionId());
        log.setInstanceId(task.getInstanceId());
        log.setTaskId(task.getId());
        log.setEventType(event.getEventType());
        log.setActionCode(event.getActionCode());
        try {
            if (WorkflowConstants.ACTION_ORDER_APPROVE.equals(event.getActionCode())) {
                approveOrder(task);
                log.setResultStatus("success");
                log.setResultMsg("订单状态已同步为已审批");
            } else if (WorkflowConstants.ACTION_WORK_ORDER_CHANGE_APPLY.equals(event.getActionCode())) {
                applyWorkOrderChange(task);
                log.setResultStatus("success");
                log.setResultMsg("工单变更已审批通过并生效");
            } else {
                log.setResultStatus("skip");
                log.setResultMsg("未识别的事件模板，已跳过");
            }
        } catch (Exception e) {
            log.setResultStatus("failure");
            log.setResultMsg(StringUtils.defaultIfBlank(e.getMessage(), "事件执行失败"));
            eventLogService.save(log);
            throw e;
        }
        eventLogService.save(log);
    }

    private void approveOrder(SpWorkflowTask task) {
        if (!WorkflowConstants.BUSINESS_ORDER_APPROVAL.equals(task.getBusinessType())) {
            return;
        }
        SpOrder order = orderService.getById(task.getBusinessId());
        if (order == null) {
            throw new RuntimeException("订单不存在，无法同步审批状态");
        }
        SpOrder update = new SpOrder();
        update.setId(order.getId());
        update.setStatue(2);
        update.setApproveUserId(task.getAssigneeId());
        update.setApproveUsername(task.getAssigneeName());
        update.setApproveTime(task.getCompleteTime());
        orderService.updateById(update);
        syncProductionOrderStatus(order.getId());
    }

    private void applyWorkOrderChange(SpWorkflowTask task) {
        if (!WorkflowConstants.BUSINESS_WORK_ORDER_CHANGE.equals(task.getBusinessType())) {
            return;
        }
        Result result = workOrderChangeService.applyApprovedChange(task.getBusinessId(), task.getCompleteTime());
        if ((Integer) result.get("code") != 0) {
            throw new RuntimeException(String.valueOf(result.get("msg")));
        }
    }

    private void syncProductionOrderStatus(String workOrderId) {
        SpProductionOrderItem current = productionOrderItemService.getOne(new QueryWrapper<SpProductionOrderItem>()
                .eq("work_order_id", workOrderId)
                .last("limit 1"), false);
        if (current == null || StringUtils.isBlank(current.getOrderId())) {
            return;
        }
        List<SpProductionOrderItem> items = productionOrderItemService.list(new QueryWrapper<SpProductionOrderItem>()
                .eq("order_id", current.getOrderId()));
        if (items == null || items.isEmpty()) {
            return;
        }
        for (SpProductionOrderItem item : items) {
            if (StringUtils.isBlank(item.getWorkOrderId())) {
                return;
            }
            SpOrder itemOrder = orderService.getById(item.getWorkOrderId());
            if (itemOrder == null || itemOrder.getStatue() == null || itemOrder.getStatue() != 2) {
                return;
            }
        }
        SpProductionOrder update = new SpProductionOrder();
        update.setId(current.getOrderId());
        update.setStatus(SpProductionOrderServiceImpl.STATUS_CONFIRMED);
        update.setApprovalStatus(SpProductionOrderServiceImpl.APPROVAL_APPROVED);
        update.setOperationStatus(SpProductionOrderServiceImpl.OP_WAIT_CALC);
        productionOrderService.updateById(update);
    }
}
