package com.wangziyang.mes.workflow.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.entity.SpWorkflowForm;
import com.wangziyang.mes.workflow.request.WorkflowPageReq;
import com.wangziyang.mes.workflow.service.ISpWorkflowDefinitionService;
import com.wangziyang.mes.workflow.service.ISpWorkflowFormService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/workflow/form")
public class SpWorkflowFormController extends WorkflowBaseController {

    @Autowired
    private ISpWorkflowFormService formService;

    @Autowired
    private ISpWorkflowDefinitionService definitionService;

    @GetMapping("/list-ui")
    public String listUI() {
        definitionService.ensureDefaultOrderApprovalDefinition();
        formService.ensureDefaultOrderApprovalForm();
        return "workflow/form/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpWorkflowForm record) {
        SpWorkflowForm result = StringUtils.isNotBlank(record.getId())
                ? formService.getById(record.getId()) : new SpWorkflowForm();
        if (StringUtils.isBlank(result.getFormKey())) {
            result.setFormKey("orderRecord");
        }
        if (StringUtils.isBlank(result.getFormName())) {
            result.setFormName("生产订单审批流程");
        }
        if (StringUtils.isBlank(result.getBusinessType())) {
            result.setBusinessType(WorkflowConstants.BUSINESS_ORDER_APPROVAL);
        }
        if (StringUtils.isBlank(result.getDefinitionCode())) {
            result.setDefinitionCode(WorkflowConstants.DEFAULT_DEFINITION_CODE);
        }
        if (StringUtils.isBlank(result.getFormType())) {
            result.setFormType("url");
        }
        if (StringUtils.isBlank(result.getPcFormUrl())) {
            result.setPcFormUrl("/order/release/add-or-update-ui?id=${task.procIns.bizKey}");
        }
        if (StringUtils.isBlank(result.getMobileFormUrl())) {
            result.setMobileFormUrl("/order/release/add-or-update-ui?id=${task.procIns.bizKey}");
        }
        if (StringUtils.isBlank(result.getTitleTemplate())) {
            result.setTitleTemplate("生产订单审批-${task.businessCode}");
        }
        if (StringUtils.isBlank(result.getEventTemplate())) {
            result.setEventTemplate(WorkflowConstants.ACTION_ORDER_APPROVE);
        }
        if (result.getSkipFirstNode() == null) {
            result.setSkipFirstNode(1);
        }
        if (result.getAllowReturn() == null) {
            result.setAllowReturn(1);
        }
        if (result.getAllowTransfer() == null) {
            result.setAllowTransfer(1);
        }
        if (result.getAllowEntrust() == null) {
            result.setAllowEntrust(1);
        }
        if (result.getAllowRevoke() == null) {
            result.setAllowRevoke(1);
        }
        if (StringUtils.isBlank(result.getStatus())) {
            result.setStatus(WorkflowConstants.STATUS_NORMAL);
        }
        if (result.getSortNum() == null) {
            result.setSortNum(30);
        }
        model.addAttribute("result", result);
        return "workflow/form/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(WorkflowPageReq req) {
        QueryWrapper<SpWorkflowForm> qw = new QueryWrapper<>();
        if (StringUtils.isNotBlank(req.getKeyword())) {
            qw.and(w -> w.like("form_name", req.getKeyword()).or().like("form_key", req.getKeyword())
                    .or().like("definition_code", req.getKeyword()));
        }
        if (StringUtils.isNotBlank(req.getBusinessType())) {
            qw.eq("business_type", req.getBusinessType());
        }
        if (StringUtils.isNotBlank(req.getStatus())) {
            qw.eq("status", req.getStatus());
        }
        qw.orderByAsc("sort_num").orderByDesc("update_time");
        IPage<SpWorkflowForm> page = formService.page(req, qw);
        return Result.success(page);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWorkflowForm record) {
        return formService.saveForm(record);
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpWorkflowForm record) {
        if (record == null || StringUtils.isBlank(record.getId())) {
            return Result.failure("请选择要删除的流程表单");
        }
        formService.removeById(record.getId());
        return Result.success();
    }
}
