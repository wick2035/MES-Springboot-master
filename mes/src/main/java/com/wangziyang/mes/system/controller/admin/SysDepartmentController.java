package com.wangziyang.mes.system.controller.admin;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.request.SysDepartmentPageReq;
import com.wangziyang.mes.system.service.ISysDepartmentService;
import com.wangziyang.mes.system.vo.TreeVO;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 系统部门管理控制器
 *
 * @author SongPeng
 * @since 2020-03-03
 */
@Controller
@RequestMapping("/admin/sys/department")
public class SysDepartmentController extends BaseController {

    Logger logger = LoggerFactory.getLogger(SysDepartmentController.class);

    @Autowired
    private ISysDepartmentService sysDepartmentService;

    @ApiOperation("系统部门列表页面")
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/department/list";
    }

    @ApiOperation("系统部门分页列表")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SysDepartmentPageReq req) {
        QueryWrapper<SysDepartment> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.likeRight("name", req.getNameLike());
        }
        qw.ne("is_deleted", "1");
        qw.orderByAsc("sort_num");
        qw.orderByDesc(req.getOrderBy());
        IPage result = sysDepartmentService.page(req, qw);
        return Result.success(result);
    }

    @ApiOperation("新增/编辑部门页面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysDepartment record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SysDepartment result = sysDepartmentService.getById(record.getId());
            model.addAttribute("result", result);
        }
        return "admin/system/department/addOrUpdate";
    }

    @ApiOperation("新增/编辑保存部门")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysDepartment record) {
        if (StringUtils.isEmpty(record.getName())) {
            return Result.failure("部门名称不能为空");
        }
        if (record.getSortNum() == null) {
            record.setSortNum(0);
        }
        if (StringUtils.isEmpty(record.getIsDeleted())) {
            record.setIsDeleted("0");
        }
        // 顶级部门的 parentId 设为 "0"
        if (StringUtils.isEmpty(record.getParentId())) {
            record.setParentId("0");
        }
        // 名称唯一性校验
        if (sysDepartmentService.isNameDuplicate(record.getName(), record.getId())) {
            return Result.failure("部门名称已存在，请更换名称");
        }
        // 不能将自己设为上级部门
        if (StringUtils.isNotEmpty(record.getId()) && record.getId().equals(record.getParentId())) {
            return Result.failure("不能将自己设为上级部门");
        }
        sysDepartmentService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @ApiOperation("软删除部门")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        // 检查是否有子部门
        QueryWrapper<SysDepartment> childQw = new QueryWrapper<>();
        childQw.eq("parent_id", id).ne("is_deleted", "1");
        if (sysDepartmentService.count(childQw) > 0) {
            return Result.failure("该部门下存在子部门，请先删除子部门");
        }
        SysDepartment record = new SysDepartment();
        record.setId(id);
        record.setIsDeleted("1");
        sysDepartmentService.updateById(record);
        return Result.success();
    }

    @ApiOperation("启用/禁用部门")
    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        SysDepartment record = new SysDepartment();
        record.setId(id);
        record.setIsDeleted(status);
        sysDepartmentService.updateById(record);
        return Result.success();
    }

    @ApiOperation("获取部门树")
    @GetMapping("/tree")
    @ResponseBody
    public Result tree() {
        List<TreeVO<SysDepartment>> tree = sysDepartmentService.listDepartmentTree();
        return Result.success(tree);
    }
}