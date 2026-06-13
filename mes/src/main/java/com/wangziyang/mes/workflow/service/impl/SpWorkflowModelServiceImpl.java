package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.dto.WorkflowNodeDTO;
import com.wangziyang.mes.workflow.entity.SpWorkflowModel;
import com.wangziyang.mes.workflow.mapper.SpWorkflowModelMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowModelService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SpWorkflowModelServiceImpl extends ServiceImpl<SpWorkflowModelMapper, SpWorkflowModel>
        implements ISpWorkflowModelService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public Result saveModel(SpWorkflowModel record) {
        if (record == null) {
            return Result.failure("流程模型不能为空");
        }
        record.setModelName(StringUtils.trimToEmpty(record.getModelName()));
        record.setModelCode(StringUtils.trimToEmpty(record.getModelCode()));
        record.setBusinessType(StringUtils.trimToEmpty(record.getBusinessType()));
        record.setStatus(StringUtils.defaultIfBlank(record.getStatus(), "draft"));
        if (StringUtils.isNotEmpty(record.getId())) {
            SpWorkflowModel db = getById(record.getId());
            if (db != null && "published".equals(db.getStatus())) {
                return Result.failure("流程模型已发布，不允许再次设计");
            }
        }
        if (StringUtils.isEmpty(record.getCategoryId())) {
            return Result.failure("请选择流程分类");
        }
        if (StringUtils.isEmpty(record.getModelName())) {
            return Result.failure("请填写模型名称");
        }
        if (StringUtils.isEmpty(record.getModelCode())) {
            return Result.failure("请填写模型编码");
        }
        if (StringUtils.isEmpty(record.getBusinessType())) {
            return Result.failure("请填写业务类型");
        }
        Result nodeResult = validateNodeJson(record.getNodeJson());
        if (nodeResult != null) {
            return nodeResult;
        }
        QueryWrapper<SpWorkflowModel> qw = new QueryWrapper<>();
        qw.eq("model_code", record.getModelCode());
        if (StringUtils.isNotEmpty(record.getId())) {
            qw.ne("id", record.getId());
        }
        if (count(qw) > 0) {
            return Result.failure("模型编码已存在");
        }
        saveOrUpdate(record);
        return Result.success();
    }

    private Result validateNodeJson(String nodeJson) {
        if (StringUtils.isBlank(nodeJson)) {
            return Result.failure("请配置流程节点");
        }
        try {
            List<WorkflowNodeDTO> nodes = objectMapper.readValue(nodeJson, new TypeReference<List<WorkflowNodeDTO>>() {});
            int approvalCount = 0;
            for (WorkflowNodeDTO node : nodes) {
                if (node == null || StringUtils.isBlank(node.getNodeKey()) || StringUtils.isBlank(node.getNodeType())) {
                    return Result.failure("节点必须包含 nodeKey 和 nodeType");
                }
                if (WorkflowConstants.NODE_APPROVAL.equals(node.getNodeType())) {
                    approvalCount++;
                    if (StringUtils.isBlank(node.getAssigneeType()) || StringUtils.isBlank(node.getAssigneeId())) {
                        return Result.failure("审批节点必须配置处理人或角色");
                    }
                }
            }
            if (approvalCount < 1) {
                return Result.failure("流程至少需要一个审批节点");
            }
            return null;
        } catch (Exception e) {
            return Result.failure("流程节点 JSON 格式不正确");
        }
    }
}
