package com.wangziyang.mes.workflow.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.entity.SpWorkflowCategory;
import com.wangziyang.mes.workflow.request.WorkflowPageReq;
import com.wangziyang.mes.workflow.service.ISpWorkflowCategoryService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/workflow/category")
public class SpWorkflowCategoryController extends WorkflowBaseController {

    @Autowired
    private ISpWorkflowCategoryService categoryService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "workflow/category/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpWorkflowCategory record) {
        SpWorkflowCategory result = StringUtils.isNotEmpty(record.getId())
                ? categoryService.getById(record.getId()) : new SpWorkflowCategory();
        if (result.getSortNum() == null) {
            result.setSortNum(30);
        }
        if (StringUtils.isBlank(result.getStatus())) {
            result.setStatus("0");
        }
        model.addAttribute("result", result);
        return "workflow/category/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(WorkflowPageReq req) {
        QueryWrapper<SpWorkflowCategory> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getKeyword())) {
            qw.and(w -> w.like("category_name", req.getKeyword()).or().like("category_code", req.getKeyword()));
        }
        if (StringUtils.isNotEmpty(req.getStatus())) {
            qw.eq("status", req.getStatus());
        }
        qw.orderByAsc("sort_num").orderByDesc("update_time");
        IPage<SpWorkflowCategory> page = categoryService.page(req, qw);
        return Result.success(page);
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        return Result.success(categoryService.list(new QueryWrapper<SpWorkflowCategory>().orderByAsc("sort_num")));
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWorkflowCategory record) {
        return categoryService.saveCategory(record);
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpWorkflowCategory record) {
        categoryService.removeById(record.getId());
        return Result.success();
    }
}
