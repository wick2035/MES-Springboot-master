package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.entity.SpWorkflowCategory;
import com.wangziyang.mes.workflow.mapper.SpWorkflowCategoryMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowCategoryService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class SpWorkflowCategoryServiceImpl extends ServiceImpl<SpWorkflowCategoryMapper, SpWorkflowCategory>
        implements ISpWorkflowCategoryService {

    @Override
    public Result saveCategory(SpWorkflowCategory record) {
        if (record == null) {
            return Result.failure("流程分类不能为空");
        }
        record.setCategoryName(StringUtils.trimToEmpty(record.getCategoryName()));
        record.setCategoryCode(StringUtils.trimToEmpty(record.getCategoryCode()));
        record.setParentId(StringUtils.defaultIfBlank(record.getParentId(), "0"));
        record.setStatus(StringUtils.defaultIfBlank(record.getStatus(), WorkflowConstants.STATUS_NORMAL));
        if (record.getSortNum() == null) {
            record.setSortNum(30);
        }
        if (StringUtils.isEmpty(record.getCategoryName())) {
            return Result.failure("请填写分类名称");
        }
        if (StringUtils.isEmpty(record.getCategoryCode())) {
            return Result.failure("请填写分类编码");
        }
        QueryWrapper<SpWorkflowCategory> qw = new QueryWrapper<>();
        qw.eq("category_code", record.getCategoryCode());
        if (StringUtils.isNotEmpty(record.getId())) {
            qw.ne("id", record.getId());
        }
        if (count(qw) > 0) {
            return Result.failure("分类编码已存在");
        }
        saveOrUpdate(record);
        return Result.success();
    }
}
