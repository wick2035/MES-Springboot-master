package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.entity.SpWorkflowForm;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;
import com.wangziyang.mes.workflow.mapper.SpWorkflowFormMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowFormService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class SpWorkflowFormServiceImpl extends ServiceImpl<SpWorkflowFormMapper, SpWorkflowForm>
        implements ISpWorkflowFormService {

    private static final String CURRENT_ORDER_URL = "/order/release/add-or-update-ui?id=${task.procIns.bizKey}";
    private static final String DEFAULT_TITLE = "生产订单审批-${task.businessCode}";
    private static final Set<String> ALLOWED_EVENTS = new HashSet<>(Arrays.asList(
            WorkflowConstants.ACTION_ORDER_APPROVE
    ));

    @Override
    public Result saveForm(SpWorkflowForm record) {
        if (record == null) {
            return Result.failure("流程表单不能为空");
        }
        normalize(record);
        Result valid = validate(record);
        if (valid != null) {
            return valid;
        }
        QueryWrapper<SpWorkflowForm> keyQw = new QueryWrapper<>();
        keyQw.eq("form_key", record.getFormKey());
        if (StringUtils.isNotBlank(record.getId())) {
            keyQw.ne("id", record.getId());
        }
        if (count(keyQw) > 0) {
            return Result.failure("表单Key已存在");
        }
        QueryWrapper<SpWorkflowForm> bizQw = new QueryWrapper<>();
        bizQw.eq("business_type", record.getBusinessType()).eq("status", WorkflowConstants.STATUS_NORMAL);
        if (StringUtils.isNotBlank(record.getId())) {
            bizQw.ne("id", record.getId());
        }
        if (WorkflowConstants.STATUS_NORMAL.equals(record.getStatus()) && count(bizQw) > 0) {
            return Result.failure("同一业务类型只能启用一个流程表单");
        }
        saveOrUpdate(record);
        return Result.success(record);
    }

    @Override
    public SpWorkflowForm activeByBusinessType(String businessType) {
        if (StringUtils.isBlank(businessType)) {
            return null;
        }
        return getOne(new QueryWrapper<SpWorkflowForm>()
                .eq("business_type", businessType)
                .eq("status", WorkflowConstants.STATUS_NORMAL)
                .orderByAsc("sort_num")
                .orderByDesc("update_time")
                .last("limit 1"));
    }

    @Override
    public void ensureDefaultOrderApprovalForm() {
        SpWorkflowForm existing = getOne(new QueryWrapper<SpWorkflowForm>()
                .eq("form_key", "orderRecord")
                .last("limit 1"));
        if (existing != null) {
            return;
        }
        SpWorkflowForm form = new SpWorkflowForm();
        form.setFormName("生产订单审批流程");
        form.setFormKey("orderRecord");
        form.setBusinessType(WorkflowConstants.BUSINESS_ORDER_APPROVAL);
        form.setDefinitionCode(WorkflowConstants.DEFAULT_DEFINITION_CODE);
        form.setFormType("url");
        form.setPcFormUrl(CURRENT_ORDER_URL);
        form.setMobileFormUrl(CURRENT_ORDER_URL);
        form.setTitleTemplate(DEFAULT_TITLE);
        form.setEventTemplate(WorkflowConstants.ACTION_ORDER_APPROVE);
        form.setSkipFirstNode(1);
        form.setSkipSameHandler(0);
        form.setAllowReturn(1);
        form.setAllowTransfer(1);
        form.setAllowEntrust(1);
        form.setAllowRevoke(1);
        form.setStatus(WorkflowConstants.STATUS_NORMAL);
        form.setSortNum(30);
        form.setRemark("默认生产订单审批表单，审批通过后同步工单状态。");
        save(form);
    }

    @Override
    public String renderUrl(String template, SpWorkflowTask task, SysUser user) {
        return renderTemplate(template, task, user);
    }

    @Override
    public String renderTitle(String template, SpWorkflowTask task, SysUser user) {
        return StringUtils.defaultIfBlank(renderTemplate(template, task, user),
                task == null ? "" : task.getBusinessCode());
    }

    @Override
    public void fillTaskFormMeta(List<SpWorkflowTask> tasks, SysUser user) {
        if (tasks == null || tasks.isEmpty()) {
            return;
        }
        for (SpWorkflowTask task : tasks) {
            SpWorkflowForm form = activeByBusinessType(task.getBusinessType());
            if (form == null) {
                continue;
            }
            task.setFormName(form.getFormName());
            task.setFormTitle(renderTitle(form.getTitleTemplate(), task, user));
            task.setPcFormUrl(renderUrl(form.getPcFormUrl(), task, user));
            task.setMobileFormUrl(renderUrl(form.getMobileFormUrl(), task, user));
            task.setAllowReturn(one(form.getAllowReturn()));
            task.setAllowTransfer(one(form.getAllowTransfer()));
            task.setAllowEntrust(one(form.getAllowEntrust()));
            task.setAllowRevoke(one(form.getAllowRevoke()));
        }
    }

    private void normalize(SpWorkflowForm record) {
        record.setFormName(StringUtils.trimToEmpty(record.getFormName()));
        record.setFormKey(StringUtils.trimToEmpty(record.getFormKey()));
        record.setBusinessType(StringUtils.trimToEmpty(record.getBusinessType()));
        record.setDefinitionCode(StringUtils.defaultIfBlank(StringUtils.trimToEmpty(record.getDefinitionCode()),
                WorkflowConstants.DEFAULT_DEFINITION_CODE));
        record.setFormType(StringUtils.defaultIfBlank(StringUtils.trimToEmpty(record.getFormType()), "url"));
        record.setPcFormUrl(StringUtils.trimToEmpty(record.getPcFormUrl()));
        record.setMobileFormUrl(StringUtils.defaultIfBlank(StringUtils.trimToEmpty(record.getMobileFormUrl()), record.getPcFormUrl()));
        record.setTitleTemplate(StringUtils.defaultIfBlank(StringUtils.trimToEmpty(record.getTitleTemplate()), DEFAULT_TITLE));
        record.setEventTemplate(StringUtils.defaultIfBlank(StringUtils.trimToEmpty(record.getEventTemplate()),
                WorkflowConstants.ACTION_ORDER_APPROVE));
        record.setSkipFirstNode(one(record.getSkipFirstNode()));
        record.setSkipSameHandler(0);
        record.setAllowReturn(one(record.getAllowReturn()));
        record.setAllowTransfer(one(record.getAllowTransfer()));
        record.setAllowEntrust(one(record.getAllowEntrust()));
        record.setAllowRevoke(one(record.getAllowRevoke()));
        record.setStatus(StringUtils.defaultIfBlank(record.getStatus(), WorkflowConstants.STATUS_NORMAL));
        record.setSortNum(record.getSortNum() == null ? 30 : record.getSortNum());
        record.setRemark(StringUtils.trimToEmpty(record.getRemark()));
    }

    private Result validate(SpWorkflowForm record) {
        if (StringUtils.isBlank(record.getFormName())) {
            return Result.failure("请填写表单名称");
        }
        if (StringUtils.isBlank(record.getFormKey())) {
            return Result.failure("请填写表单Key");
        }
        if (!record.getFormKey().matches("^[A-Za-z][A-Za-z0-9_]{2,63}$")) {
            return Result.failure("表单Key需以字母开头，可包含字母、数字、下划线，长度3-64位");
        }
        if (StringUtils.isBlank(record.getBusinessType())) {
            return Result.failure("请填写业务类型");
        }
        if (!"url".equals(record.getFormType())) {
            return Result.failure("当前版本仅支持URL表单");
        }
        if (StringUtils.isBlank(record.getPcFormUrl())) {
            return Result.failure("请填写PC表单地址");
        }
        if (!isSafeTemplate(record.getPcFormUrl()) || !isSafeTemplate(record.getMobileFormUrl())
                || !isSafeTemplate(record.getTitleTemplate())) {
            return Result.failure("模板变量仅支持 task.procIns.bizKey、task.businessId、task.businessCode、form.currentUser.userName 和 date(),'yyyy-MM-dd'");
        }
        for (String action : StringUtils.split(record.getEventTemplate(), ",")) {
            String event = StringUtils.trimToEmpty(action);
            if (StringUtils.isNotBlank(event) && !ALLOWED_EVENTS.contains(event)) {
                return Result.failure("事件模板只允许：" + WorkflowConstants.ACTION_ORDER_APPROVE);
            }
        }
        if (!WorkflowConstants.STATUS_NORMAL.equals(record.getStatus())
                && !WorkflowConstants.STATUS_DISABLED.equals(record.getStatus())) {
            return Result.failure("状态不正确");
        }
        return null;
    }

    private boolean isSafeTemplate(String value) {
        String clean = StringUtils.defaultString(value)
                .replace("${task.procIns.bizKey}", "")
                .replace("${task.businessId}", "")
                .replace("${task.businessCode}", "")
                .replace("${form.currentUser.userName}", "")
                .replace("${date(),'yyyy-MM-dd'}", "");
        return !clean.contains("${");
    }

    private String renderTemplate(String template, SpWorkflowTask task, SysUser user) {
        String result = StringUtils.defaultString(template);
        if (task != null) {
            result = result.replace("${task.procIns.bizKey}", StringUtils.defaultString(task.getBusinessId()));
            result = result.replace("${task.businessId}", StringUtils.defaultString(task.getBusinessId()));
            result = result.replace("${task.businessCode}", StringUtils.defaultString(task.getBusinessCode()));
        }
        result = result.replace("${form.currentUser.userName}", displayUsername(user));
        result = result.replace("${date(),'yyyy-MM-dd'}", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        return result;
    }

    private String displayUsername(SysUser user) {
        if (user == null) {
            return "";
        }
        return StringUtils.defaultIfBlank(user.getName(), user.getUsername());
    }

    private Integer one(Integer value) {
        return value != null && value == 1 ? 1 : 0;
    }
}
