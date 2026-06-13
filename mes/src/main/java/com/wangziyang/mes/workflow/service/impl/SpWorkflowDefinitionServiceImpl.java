package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.dto.WorkflowNodeDTO;
import com.wangziyang.mes.workflow.dto.WorkflowNodeEventDTO;
import com.wangziyang.mes.workflow.entity.SpWorkflowCategory;
import com.wangziyang.mes.workflow.entity.SpWorkflowDefinition;
import com.wangziyang.mes.workflow.entity.SpWorkflowModel;
import com.wangziyang.mes.workflow.mapper.SpWorkflowDefinitionMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowCategoryService;
import com.wangziyang.mes.workflow.service.ISpWorkflowDefinitionService;
import com.wangziyang.mes.workflow.service.ISpWorkflowEventService;
import com.wangziyang.mes.workflow.service.ISpWorkflowModelService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class SpWorkflowDefinitionServiceImpl extends ServiceImpl<SpWorkflowDefinitionMapper, SpWorkflowDefinition>
        implements ISpWorkflowDefinitionService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private ISpWorkflowModelService modelService;

    @Autowired
    private ISpWorkflowCategoryService categoryService;

    @Autowired
    private ISpWorkflowEventService eventService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result publish(String modelId) {
        if (StringUtils.isBlank(modelId)) {
            return Result.failure("请选择要发布的流程模型");
        }
        SpWorkflowModel model = modelService.getById(modelId);
        if (model == null) {
            return Result.failure("流程模型不存在");
        }
        if ("published".equals(model.getStatus())) {
            return Result.failure("流程模型已发布，不允许再次发布");
        }
        Result valid = validateNodes(model.getNodeJson());
        if (valid != null) {
            return valid;
        }

        int nextVersion = nextVersion(model.getModelCode());
        SpWorkflowDefinition definition = new SpWorkflowDefinition();
        definition.setModelId(model.getId());
        definition.setCategoryId(model.getCategoryId());
        definition.setDefinitionCode(model.getModelCode());
        definition.setDefinitionName(model.getModelName());
        definition.setBusinessType(model.getBusinessType());
        definition.setVersionNo(nextVersion);
        definition.setNodeJson(model.getNodeJson());
        definition.setStatus(WorkflowConstants.DEFINITION_ACTIVE);
        definition.setPublishTime(now());
        definition.setRemark(model.getRemark());

        List<SpWorkflowDefinition> activeDefs = list(new QueryWrapper<SpWorkflowDefinition>()
                .eq("business_type", model.getBusinessType())
                .eq("status", WorkflowConstants.DEFINITION_ACTIVE));
        for (SpWorkflowDefinition active : activeDefs) {
            active.setStatus(WorkflowConstants.DEFINITION_INACTIVE);
        }
        if (!activeDefs.isEmpty()) {
            updateBatchById(activeDefs);
        }
        save(definition);
        eventService.rebuildDefinitionEvents(definition.getId(), definition.getNodeJson());

        model.setStatus("published");
        modelService.updateById(model);
        return Result.success(definition);
    }

    @Override
    public Result changeStatus(String id, String status) {
        SpWorkflowDefinition definition = getById(id);
        if (definition == null) {
            return Result.failure("流程定义不存在");
        }
        if (!WorkflowConstants.DEFINITION_ACTIVE.equals(status)
                && !WorkflowConstants.DEFINITION_INACTIVE.equals(status)) {
            return Result.failure("定义状态不正确");
        }
        definition.setStatus(status);
        updateById(definition);
        return Result.success();
    }

    @Override
    public SpWorkflowDefinition activeDefinition(String businessType) {
        return getOne(new QueryWrapper<SpWorkflowDefinition>()
                .eq("business_type", businessType)
                .eq("status", WorkflowConstants.DEFINITION_ACTIVE)
                .orderByDesc("version_no")
                .last("limit 1"));
    }

    @Override
    public SpWorkflowDefinition ensureDefaultOrderApprovalDefinition() {
        SpWorkflowDefinition definition = activeDefinition(WorkflowConstants.BUSINESS_ORDER_APPROVAL);
        if (definition != null) {
            return definition;
        }
        SpWorkflowModel model = ensureDefaultOrderApprovalModel();
        Result result = publish(model.getId());
        Object data = result.get("data");
        if (data instanceof SpWorkflowDefinition) {
            return (SpWorkflowDefinition) data;
        }
        return activeDefinition(WorkflowConstants.BUSINESS_ORDER_APPROVAL);
    }

    @Override
    public SpWorkflowModel ensureDefaultOrderApprovalModel() {
        SpWorkflowCategory category = categoryService.getOne(new QueryWrapper<SpWorkflowCategory>()
                .eq("category_code", WorkflowConstants.DEFAULT_CATEGORY_CODE)
                .last("limit 1"));
        if (category == null) {
            category = new SpWorkflowCategory();
            category.setParentId("0");
            category.setCategoryName("生产流程");
            category.setCategoryCode(WorkflowConstants.DEFAULT_CATEGORY_CODE);
            category.setSortNum(30);
            category.setStatus(WorkflowConstants.STATUS_NORMAL);
            category.setRemark("生产订单审批与生产流程管控默认分类");
            categoryService.save(category);
        }

        SpWorkflowModel model = modelService.getOne(new QueryWrapper<SpWorkflowModel>()
                .eq("model_code", WorkflowConstants.DEFAULT_MODEL_CODE)
                .last("limit 1"));
        if (model != null) {
            return model;
        }
        model = new SpWorkflowModel();
        model.setCategoryId(category.getId());
        model.setModelCode(WorkflowConstants.DEFAULT_MODEL_CODE);
        model.setModelName("生产订单审批流程");
        model.setBusinessType(WorkflowConstants.BUSINESS_ORDER_APPROVAL);
        model.setNodeJson(defaultOrderApprovalNodeJson());
        model.setStatus("draft");
        model.setRemark("订单创建后由生产/仓储管理角色审批，审批通过后工单进入已审批状态");
        modelService.save(model);
        return model;
    }

    @Override
    public SpWorkflowDefinition ensureDefaultWorkOrderChangeDefinition() {
        SpWorkflowDefinition definition = activeDefinition(WorkflowConstants.BUSINESS_WORK_ORDER_CHANGE);
        if (definition != null) {
            return definition;
        }
        SpWorkflowModel model = ensureDefaultWorkOrderChangeModel();
        Result result = publish(model.getId());
        Object data = result.get("data");
        if (data instanceof SpWorkflowDefinition) {
            return (SpWorkflowDefinition) data;
        }
        return activeDefinition(WorkflowConstants.BUSINESS_WORK_ORDER_CHANGE);
    }

    @Override
    public SpWorkflowModel ensureDefaultWorkOrderChangeModel() {
        SpWorkflowCategory category = categoryService.getOne(new QueryWrapper<SpWorkflowCategory>()
                .eq("category_code", WorkflowConstants.DEFAULT_CATEGORY_CODE)
                .last("limit 1"));
        if (category == null) {
            category = new SpWorkflowCategory();
            category.setParentId("0");
            category.setCategoryName("生产流程");
            category.setCategoryCode(WorkflowConstants.DEFAULT_CATEGORY_CODE);
            category.setSortNum(30);
            category.setStatus(WorkflowConstants.STATUS_NORMAL);
            category.setRemark("生产流程默认分类");
            categoryService.save(category);
        }

        SpWorkflowModel model = modelService.getOne(new QueryWrapper<SpWorkflowModel>()
                .eq("model_code", WorkflowConstants.WORK_ORDER_CHANGE_MODEL_CODE)
                .last("limit 1"));
        if (model != null) {
            return model;
        }
        model = new SpWorkflowModel();
        model.setCategoryId(category.getId());
        model.setModelCode(WorkflowConstants.WORK_ORDER_CHANGE_MODEL_CODE);
        model.setModelName("已下达工单变更审批流程");
        model.setBusinessType(WorkflowConstants.BUSINESS_WORK_ORDER_CHANGE);
        model.setNodeJson(defaultWorkOrderChangeNodeJson());
        model.setStatus("draft");
        model.setRemark("已动工工单修改时由生产主管审批，审批通过后自动应用变更");
        modelService.save(model);
        return model;
    }

    private int nextVersion(String definitionCode) {
        SpWorkflowDefinition last = getOne(new QueryWrapper<SpWorkflowDefinition>()
                .eq("definition_code", definitionCode)
                .orderByDesc("version_no")
                .last("limit 1"));
        return last == null || last.getVersionNo() == null ? 1 : last.getVersionNo() + 1;
    }

    private Result validateNodes(String nodeJson) {
        try {
            List<WorkflowNodeDTO> nodes = objectMapper.readValue(nodeJson, new TypeReference<List<WorkflowNodeDTO>>() {});
            int approvalCount = 0;
            for (WorkflowNodeDTO node : nodes) {
                if (WorkflowConstants.NODE_APPROVAL.equals(node.getNodeType())) {
                    approvalCount++;
                }
            }
            return approvalCount > 0 ? null : Result.failure("流程至少需要一个审批节点");
        } catch (Exception e) {
            return Result.failure("流程节点 JSON 格式不正确");
        }
    }

    private String defaultOrderApprovalNodeJson() {
        try {
            List<WorkflowNodeDTO> nodes = new ArrayList<>();
            WorkflowNodeDTO start = new WorkflowNodeDTO();
            start.setNodeKey("start");
            start.setNodeName("订单提交");
            start.setNodeType(WorkflowConstants.NODE_START);
            nodes.add(start);

            WorkflowNodeDTO approval = new WorkflowNodeDTO();
            approval.setNodeKey("order_approve");
            approval.setNodeName("生产订单审批");
            approval.setNodeType(WorkflowConstants.NODE_APPROVAL);
            approval.setAssigneeType(WorkflowConstants.ASSIGNEE_ROLE);
            approval.setAssigneeId(WorkflowConstants.ROLE_PRODUCTION_MANAGER);
            approval.setAssigneeName("生产主管");
            WorkflowNodeEventDTO event = new WorkflowNodeEventDTO();
            event.setEventType(WorkflowConstants.EVENT_COMPLETE);
            event.setActionCode(WorkflowConstants.ACTION_ORDER_APPROVE);
            event.setActionName("订单审批通过");
            approval.getEvents().add(event);
            nodes.add(approval);

            WorkflowNodeDTO end = new WorkflowNodeDTO();
            end.setNodeKey("end");
            end.setNodeName("审批完成");
            end.setNodeType(WorkflowConstants.NODE_END);
            nodes.add(end);
            return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(nodes);
        } catch (Exception e) {
            return "[]";
        }
    }

    private String defaultWorkOrderChangeNodeJson() {
        try {
            List<WorkflowNodeDTO> nodes = new ArrayList<>();
            WorkflowNodeDTO start = new WorkflowNodeDTO();
            start.setNodeKey("start");
            start.setNodeName("提交变更");
            start.setNodeType(WorkflowConstants.NODE_START);
            nodes.add(start);

            WorkflowNodeDTO approval = new WorkflowNodeDTO();
            approval.setNodeKey("work_order_change_approve");
            approval.setNodeName("工单变更审批");
            approval.setNodeType(WorkflowConstants.NODE_APPROVAL);
            approval.setAssigneeType(WorkflowConstants.ASSIGNEE_ROLE);
            approval.setAssigneeId(WorkflowConstants.ROLE_PRODUCTION_MANAGER);
            approval.setAssigneeName("生产主管");
            WorkflowNodeEventDTO event = new WorkflowNodeEventDTO();
            event.setEventType(WorkflowConstants.EVENT_COMPLETE);
            event.setActionCode(WorkflowConstants.ACTION_WORK_ORDER_CHANGE_APPLY);
            event.setActionName("工单变更审批通过并生效");
            approval.getEvents().add(event);
            nodes.add(approval);

            WorkflowNodeDTO end = new WorkflowNodeDTO();
            end.setNodeKey("end");
            end.setNodeName("审批完成");
            end.setNodeType(WorkflowConstants.NODE_END);
            nodes.add(end);
            return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(nodes);
        } catch (Exception e) {
            return "[]";
        }
    }

    private String now() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
}
