package com.wangziyang.mes.workflow.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysRole;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysRoleService;
import com.wangziyang.mes.system.service.ISysUserService;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.entity.SpWorkflowCategory;
import com.wangziyang.mes.workflow.entity.SpWorkflowModel;
import com.wangziyang.mes.workflow.request.WorkflowPageReq;
import com.wangziyang.mes.workflow.service.ISpWorkflowCategoryService;
import com.wangziyang.mes.workflow.service.ISpWorkflowDefinitionService;
import com.wangziyang.mes.workflow.service.ISpWorkflowModelService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/workflow/model")
public class SpWorkflowModelController extends WorkflowBaseController {

    @Autowired
    private ISpWorkflowModelService modelService;

    @Autowired
    private ISpWorkflowCategoryService categoryService;

    @Autowired
    private ISpWorkflowDefinitionService definitionService;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysRoleService roleService;

    @GetMapping("/list-ui")
    public String listUI() {
        definitionService.ensureDefaultOrderApprovalModel();
        return "workflow/model/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpWorkflowModel record) {
        SpWorkflowModel result = StringUtils.isNotEmpty(record.getId())
                ? modelService.getById(record.getId()) : new SpWorkflowModel();
        if (StringUtils.isBlank(result.getBusinessType())) {
            result.setBusinessType(WorkflowConstants.BUSINESS_ORDER_APPROVAL);
        }
        if (StringUtils.isBlank(result.getStatus())) {
            result.setStatus("draft");
        }
        model.addAttribute("result", result);
        List<SpWorkflowCategory> categories = categoryService.list(new QueryWrapper<SpWorkflowCategory>().orderByAsc("sort_num"));
        model.addAttribute("categories", categories);
        List<SysUser> users = userService.list(new QueryWrapper<SysUser>()
                .ne("is_deleted", "1")
                .ne("is_deleted", "2")
                .orderByAsc("username"));
        model.addAttribute("users", users);
        List<SysRole> roles = roleService.list(new QueryWrapper<SysRole>()
                .ne("is_deleted", "1")
                .ne("is_deleted", "2")
                .isNotNull("code")
                .ne("code", "")
                .orderByAsc("sort_num")
                .orderByAsc("name"));
        model.addAttribute("roles", roles);
        return "workflow/model/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(WorkflowPageReq req) {
        QueryWrapper<SpWorkflowModel> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getKeyword())) {
            qw.and(w -> w.like("model_name", req.getKeyword()).or().like("model_code", req.getKeyword()));
        }
        if (StringUtils.isNotEmpty(req.getCategoryId())) {
            qw.eq("category_id", req.getCategoryId());
        }
        if (StringUtils.isNotEmpty(req.getBusinessType())) {
            qw.eq("business_type", req.getBusinessType());
        }
        qw.orderByDesc("update_time");
        IPage<SpWorkflowModel> page = modelService.page(req, qw);
        return Result.success(page);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWorkflowModel record) {
        return modelService.saveModel(record);
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpWorkflowModel record) {
        modelService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/publish")
    @ResponseBody
    public Result publish(String id) {
        return definitionService.publish(id);
    }
}
