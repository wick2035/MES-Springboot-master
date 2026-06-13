package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productionorder.service.ISpWorkOrderChangeService;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysUserService;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.WorkflowPermissionUtil;
import com.wangziyang.mes.workflow.dto.WorkflowNodeDTO;
import com.wangziyang.mes.workflow.entity.SpWorkflowDefinition;
import com.wangziyang.mes.workflow.entity.SpWorkflowInstance;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;
import com.wangziyang.mes.workflow.mapper.SpWorkflowTaskMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowDefinitionService;
import com.wangziyang.mes.workflow.service.ISpWorkflowEventService;
import com.wangziyang.mes.workflow.service.ISpWorkflowInstanceService;
import com.wangziyang.mes.workflow.service.ISpWorkflowTaskService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class SpWorkflowTaskServiceImpl extends ServiceImpl<SpWorkflowTaskMapper, SpWorkflowTask>
        implements ISpWorkflowTaskService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private ISpWorkflowDefinitionService definitionService;

    @Autowired
    private ISpWorkflowInstanceService instanceService;

    @Autowired
    private ISpWorkflowEventService eventService;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISpWorkOrderChangeService workOrderChangeService;

    @Override
    public void createFirstTask(SpWorkflowInstance instance) {
        SpWorkflowDefinition definition = definitionService.getById(instance.getDefinitionId());
        WorkflowNodeDTO node = firstApprovalNode(definition);
        if (node == null) {
            throw new RuntimeException("流程定义缺少审批节点");
        }
        createTask(instance, definition, node);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result complete(String taskId, String opinion, SysUser user) {
        SpWorkflowTask task = getById(taskId);
        if (task == null) {
            return Result.failure("流程任务不存在");
        }
        if (!WorkflowConstants.TASK_TODO.equals(task.getStatus())) {
            return Result.failure("任务已处理，不能重复审批");
        }
        if (!canHandle(task, user)) {
            return Result.failure("当前用户不是该任务处理人");
        }

        task.setStatus(WorkflowConstants.TASK_DONE);
        task.setAction("approve");
        task.setOpinion(StringUtils.defaultIfBlank(opinion, "同意"));
        task.setAssigneeId(user == null ? task.getAssigneeId() : user.getId());
        task.setAssigneeName(displayUsername(user));
        task.setCompleteTime(now());
        updateById(task);
        eventService.executeCompleteEvents(task);

        SpWorkflowInstance instance = instanceService.getById(task.getInstanceId());
        SpWorkflowDefinition definition = definitionService.getById(task.getDefinitionId());
        WorkflowNodeDTO next = nextApprovalNode(definition, task.getNodeKey());
        if (next == null) {
            instance.setStatus(WorkflowConstants.INSTANCE_COMPLETED);
            instance.setCurrentNodeKey("end");
            instance.setCurrentNodeName("审批完成");
            instance.setEndTime(now());
            instanceService.updateById(instance);
        } else {
            createTask(instance, definition, next);
        }
        return Result.success();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result reject(String taskId, String opinion, SysUser user) {
        SpWorkflowTask task = getById(taskId);
        if (task == null) {
            return Result.failure("流程任务不存在");
        }
        if (!WorkflowConstants.TASK_TODO.equals(task.getStatus())) {
            return Result.failure("任务已处理，不能重复驳回");
        }
        if (!canHandle(task, user)) {
            return Result.failure("当前用户不是该任务处理人");
        }
        task.setStatus(WorkflowConstants.TASK_REJECTED);
        task.setAction("reject");
        task.setOpinion(StringUtils.defaultIfBlank(opinion, "驳回"));
        task.setAssigneeId(user == null ? task.getAssigneeId() : user.getId());
        task.setAssigneeName(displayUsername(user));
        task.setCompleteTime(now());
        updateById(task);

        SpWorkflowInstance instance = instanceService.getById(task.getInstanceId());
        if (instance != null) {
            instance.setStatus(WorkflowConstants.INSTANCE_REJECTED);
            instance.setCurrentNodeKey(task.getNodeKey());
            instance.setCurrentNodeName(task.getNodeName());
            instance.setEndTime(now());
            instanceService.updateById(instance);
        }
        if (WorkflowConstants.BUSINESS_WORK_ORDER_CHANGE.equals(task.getBusinessType())) {
            workOrderChangeService.rejectChange(task.getBusinessId());
        }
        return Result.success();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result transfer(String taskId, String targetUserId, String opinion, SysUser user) {
        return reassign(taskId, targetUserId, opinion, user, "transfer", "转办");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result entrust(String taskId, String targetUserId, String opinion, SysUser user) {
        return reassign(taskId, targetUserId, opinion, user, "entrust", "委托");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result revoke(String taskId, String opinion, SysUser user, boolean admin) {
        SpWorkflowTask task = getById(taskId);
        if (task == null) {
            return Result.failure("流程任务不存在");
        }
        if (!WorkflowConstants.TASK_TODO.equals(task.getStatus())) {
            return Result.failure("只有待处理任务可以撤回");
        }
        SpWorkflowInstance instance = instanceService.getById(task.getInstanceId());
        if (instance == null) {
            return Result.failure("流程实例不存在");
        }
        boolean initiator = user != null && StringUtils.equals(instance.getStartUserId(), user.getId());
        if (!admin && !initiator) {
            return Result.failure("只有流程发起人或管理员可以撤回");
        }
        task.setStatus(WorkflowConstants.TASK_REVOKED);
        task.setAction("revoke");
        task.setOpinion(StringUtils.defaultIfBlank(opinion, "撤回流程"));
        task.setCompleteTime(now());
        updateById(task);

        instance.setStatus(WorkflowConstants.INSTANCE_REVOKED);
        instance.setCurrentNodeKey(task.getNodeKey());
        instance.setCurrentNodeName(task.getNodeName());
        instance.setEndTime(now());
        instance.setRemark(StringUtils.defaultIfBlank(opinion, "撤回流程"));
        instanceService.updateById(instance);
        return Result.success();
    }

    @Override
    public Result completeOrderApprovalByBusinessId(String orderId, String opinion, SysUser user) {
        SpWorkflowTask task = getOne(new QueryWrapper<SpWorkflowTask>()
                .eq("business_type", WorkflowConstants.BUSINESS_ORDER_APPROVAL)
                .eq("business_id", orderId)
                .eq("status", WorkflowConstants.TASK_TODO)
                .orderByDesc("create_time")
                .last("limit 1"));
        if (task == null) {
            return Result.failure("该订单没有待审批流程任务");
        }
        return complete(task.getId(), opinion, user);
    }

    @Override
    public boolean canHandle(SpWorkflowTask task, SysUser user) {
        if (task == null || user == null) {
            return false;
        }
        if (WorkflowPermissionUtil.isSuperAdmin(user)) {
            return true;
        }
        if (WorkflowConstants.ASSIGNEE_USER.equals(task.getAssigneeType())) {
            return StringUtils.equals(task.getAssigneeId(), user.getId());
        }
        if (WorkflowConstants.ASSIGNEE_INITIATOR.equals(task.getAssigneeType())) {
            return true;
        }
        if (WorkflowConstants.ASSIGNEE_ROLE.equals(task.getAssigneeType())) {
            return WorkflowPermissionUtil.hasRole(user, task.getAssigneeId())
                    || canHandleLegacyProductionApproval(task, user);
        }
        return false;
    }

    private Result reassign(String taskId, String targetUserId, String opinion, SysUser user,
                            String action, String actionName) {
        SpWorkflowTask task = getById(taskId);
        if (task == null) {
            return Result.failure("流程任务不存在");
        }
        if (!WorkflowConstants.TASK_TODO.equals(task.getStatus())) {
            return Result.failure("只有待处理任务可以" + actionName);
        }
        if (!canHandle(task, user)) {
            return Result.failure("当前用户不是该任务处理人");
        }
        if (StringUtils.isBlank(targetUserId)) {
            return Result.failure("请选择目标处理人");
        }
        SysUser target = userService.getById(targetUserId);
        if (target == null) {
            return Result.failure("目标处理人不存在");
        }
        task.setAssigneeType(WorkflowConstants.ASSIGNEE_USER);
        task.setAssigneeId(target.getId());
        task.setAssigneeName(displayUsername(target));
        task.setAction(action);
        String from = displayUsername(user);
        task.setOpinion(actionName + "给 " + displayUsername(target)
                + (StringUtils.isBlank(from) ? "" : "，原处理人：" + from)
                + (StringUtils.isBlank(opinion) ? "" : "，说明：" + opinion));
        updateById(task);
        return Result.success();
    }

    private void createTask(SpWorkflowInstance instance, SpWorkflowDefinition definition, WorkflowNodeDTO node) {
        SpWorkflowTask task = new SpWorkflowTask();
        task.setInstanceId(instance.getId());
        task.setDefinitionId(definition.getId());
        task.setBusinessType(instance.getBusinessType());
        task.setBusinessId(instance.getBusinessId());
        task.setBusinessCode(instance.getBusinessCode());
        task.setTaskName(node.getNodeName());
        task.setNodeKey(node.getNodeKey());
        task.setNodeName(node.getNodeName());
        task.setAssigneeType(node.getAssigneeType());
        task.setAssigneeId(node.getAssigneeId());
        task.setAssigneeName(node.getAssigneeName());
        task.setStatus(WorkflowConstants.TASK_TODO);
        task.setStartTime(now());
        save(task);

        instance.setStatus(WorkflowConstants.INSTANCE_RUNNING);
        instance.setCurrentNodeKey(node.getNodeKey());
        instance.setCurrentNodeName(node.getNodeName());
        instanceService.updateById(instance);
    }

    private WorkflowNodeDTO firstApprovalNode(SpWorkflowDefinition definition) {
        List<WorkflowNodeDTO> nodes = nodes(definition);
        for (WorkflowNodeDTO node : nodes) {
            if (WorkflowConstants.NODE_APPROVAL.equals(node.getNodeType())) {
                return node;
            }
        }
        return null;
    }

    private WorkflowNodeDTO nextApprovalNode(SpWorkflowDefinition definition, String currentNodeKey) {
        List<WorkflowNodeDTO> nodes = nodes(definition);
        boolean seenCurrent = false;
        for (WorkflowNodeDTO node : nodes) {
            if (seenCurrent && WorkflowConstants.NODE_APPROVAL.equals(node.getNodeType())) {
                return node;
            }
            if (StringUtils.equals(currentNodeKey, node.getNodeKey())) {
                seenCurrent = true;
            }
        }
        return null;
    }

    private List<WorkflowNodeDTO> nodes(SpWorkflowDefinition definition) {
        try {
            return objectMapper.readValue(definition.getNodeJson(), new TypeReference<List<WorkflowNodeDTO>>() {});
        } catch (Exception e) {
            throw new RuntimeException("流程定义节点解析失败");
        }
    }

    private boolean canHandleLegacyProductionApproval(SpWorkflowTask task, SysUser user) {
        return WorkflowConstants.BUSINESS_ORDER_APPROVAL.equals(task.getBusinessType())
                && WorkflowConstants.ROLE_WAREHOUSE_MANAGER.equals(task.getAssigneeId())
                && WorkflowPermissionUtil.hasRole(user, WorkflowConstants.ROLE_PRODUCTION_MANAGER);
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
