package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.productionorder.entity.SpWorkOrderChange;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.entity.SpWorkflowDefinition;
import com.wangziyang.mes.workflow.entity.SpWorkflowInstance;
import com.wangziyang.mes.workflow.mapper.SpWorkflowInstanceMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowDefinitionService;
import com.wangziyang.mes.workflow.service.ISpWorkflowInstanceService;
import com.wangziyang.mes.workflow.service.ISpWorkflowTaskService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class SpWorkflowInstanceServiceImpl extends ServiceImpl<SpWorkflowInstanceMapper, SpWorkflowInstance>
        implements ISpWorkflowInstanceService {

    @Autowired
    private ISpWorkflowDefinitionService definitionService;

    @Autowired
    private ISpWorkflowTaskService taskService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SpWorkflowInstance startOrderApproval(SpOrder order, SysUser user) {
        if (order == null || StringUtils.isBlank(order.getId())) {
            throw new RuntimeException("订单不能为空");
        }
        SpWorkflowInstance existing = getOne(new QueryWrapper<SpWorkflowInstance>()
                .eq("business_type", WorkflowConstants.BUSINESS_ORDER_APPROVAL)
                .eq("business_id", order.getId())
                .in("status", WorkflowConstants.INSTANCE_RUNNING)
                .last("limit 1"));
        if (existing != null) {
            return existing;
        }

        SpWorkflowDefinition definition = definitionService.ensureDefaultOrderApprovalDefinition();
        if (definition == null) {
            throw new RuntimeException("未找到可用的生产订单审批流程定义");
        }
        SpWorkflowInstance instance = new SpWorkflowInstance();
        instance.setDefinitionId(definition.getId());
        instance.setBusinessType(WorkflowConstants.BUSINESS_ORDER_APPROVAL);
        instance.setBusinessId(order.getId());
        instance.setBusinessCode(order.getOrderCode());
        instance.setTitle(StringUtils.defaultIfBlank(order.getOrderDescription(), "生产订单审批"));
        instance.setStatus(WorkflowConstants.INSTANCE_RUNNING);
        instance.setStartUserId(user == null ? null : user.getId());
        instance.setStartUsername(displayUsername(user));
        instance.setStartTime(now());
        save(instance);
        taskService.createFirstTask(instance);
        return instance;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SpWorkflowInstance startWorkOrderChangeApproval(SpWorkOrderChange change, SysUser user) {
        if (change == null || StringUtils.isBlank(change.getId())) {
            throw new RuntimeException("工单变更申请不能为空");
        }
        SpWorkflowInstance existing = getOne(new QueryWrapper<SpWorkflowInstance>()
                .eq("business_type", WorkflowConstants.BUSINESS_WORK_ORDER_CHANGE)
                .eq("business_id", change.getId())
                .in("status", WorkflowConstants.INSTANCE_RUNNING)
                .last("limit 1"));
        if (existing != null) {
            return existing;
        }

        SpWorkflowDefinition definition = definitionService.ensureDefaultWorkOrderChangeDefinition();
        if (definition == null) {
            throw new RuntimeException("未找到可用的工单变更审批流程定义");
        }
        SpWorkflowInstance instance = new SpWorkflowInstance();
        instance.setDefinitionId(definition.getId());
        instance.setBusinessType(WorkflowConstants.BUSINESS_WORK_ORDER_CHANGE);
        instance.setBusinessId(change.getId());
        instance.setBusinessCode(change.getWorkOrderCode());
        instance.setTitle("已下达工单变更审批-" + StringUtils.defaultString(change.getWorkOrderCode()));
        instance.setStatus(WorkflowConstants.INSTANCE_RUNNING);
        instance.setStartUserId(user == null ? null : user.getId());
        instance.setStartUsername(displayUsername(user));
        instance.setStartTime(now());
        save(instance);
        taskService.createFirstTask(instance);
        return instance;
    }

    private String displayUsername(SysUser user) {
        if (user == null) {
            return "";
        }
        return StringUtils.defaultIfBlank(user.getName(), user.getUsername());
    }

    private String now() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
}
