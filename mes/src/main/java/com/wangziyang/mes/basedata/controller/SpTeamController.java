package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.basedata.entity.SpTeam;
import com.wangziyang.mes.basedata.entity.SpTeamEmployee;
import com.wangziyang.mes.basedata.request.SpTeamReq;
import com.wangziyang.mes.basedata.service.ISpTeamEmployeeService;
import com.wangziyang.mes.basedata.service.ISpTeamService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 班组 / 班组员工 控制器（资源分配管理）
 * </p>
 *
 * @author Claude
 * @since 2026-06-04
 */
@Controller
@RequestMapping("/basedata/team")
public class SpTeamController extends BaseController {

    @Autowired
    private ISpTeamService spTeamService;

    @Autowired
    private ISpTeamEmployeeService spTeamEmployeeService;

    // ============================ 班组管理 ============================

    @ApiOperation("班组员工定义主页（主从布局）")
    @GetMapping("/list-ui")
    public String listUI() {
        return "basedata/team/list";
    }

    @ApiOperation("班组新增/编辑界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTeam record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpTeam result = spTeamService.getById(record.getId());
            model.addAttribute("result", result);
        }
        return "basedata/team/addOrUpdate";
    }

    @ApiOperation("班组分页查询")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpTeamReq req) {
        QueryWrapper<SpTeam> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getTeamCodeLike())) {
            qw.likeRight("team_code", req.getTeamCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getTeamNameLike())) {
            qw.likeRight("team_name", req.getTeamNameLike());
        }
        // 不显示已删除
        qw.ne("is_deleted", "1");
        qw.orderByDesc(req.getOrderBy());
        IPage result = spTeamService.page(req, qw);
        return Result.success(result);
    }

    @ApiOperation("班组新增/编辑")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpTeam record) {
        // 班组代码唯一校验（小结第2点）
        if (spTeamService.isTeamCodeDuplicate(record.getTeamCode(), record.getId())) {
            return Result.failure("班组代码已存在，请更换编码");
        }
        if (StringUtils.isEmpty(record.getDeleted())) {
            record.setDeleted("0");
        }
        spTeamService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @ApiOperation("启用/禁用班组")
    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        SpTeam record = new SpTeam();
        record.setId(id);
        record.setDeleted(status);
        spTeamService.updateById(record);
        return Result.success();
    }

    @ApiOperation("删除班组（软删）")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        SpTeam record = new SpTeam();
        record.setId(id);
        record.setDeleted("1");
        spTeamService.updateById(record);
        return Result.success();
    }

    // ============================ 班组员工管理 ============================

    @ApiOperation("某班组成员分页查询")
    @PostMapping("/employee/page")
    @ResponseBody
    public Result employeePage(SpTeamReq req, @RequestParam(required = false) String teamId) {
        if (StringUtils.isEmpty(teamId)) {
            // 未选择班组，返回空分页
            return Result.success(new Page<SpTeamEmployee>(req.getCurrent(), req.getSize()));
        }
        IPage<SpTeamEmployee> page = new Page<>(req.getCurrent(), req.getSize());
        IPage<SpTeamEmployee> result = spTeamEmployeeService.pageByTeam(page, teamId);
        return Result.success(result);
    }

    @ApiOperation("用户选择弹窗（部门树）")
    @GetMapping("/employee-select-ui")
    public String employeeSelectUI() {
        return "basedata/team/employeeSelect";
    }

    @ApiOperation("部门+用户树数据")
    @GetMapping("/user-dept-tree")
    @ResponseBody
    public Result userDeptTree() {
        List<Map<String, Object>> tree = spTeamEmployeeService.buildUserDeptTree();
        return Result.success(tree);
    }

    @ApiOperation("批量把用户加入班组（同班组去重）")
    @PostMapping("/employee/add")
    @ResponseBody
    public Result employeeAdd(@RequestParam String teamId, @RequestParam String userIds) {
        if (StringUtils.isEmpty(teamId)) {
            return Result.failure("请先选择班组");
        }
        List<String> userIdList = new ArrayList<>();
        if (StringUtils.isNotEmpty(userIds)) {
            for (String uid : Arrays.asList(userIds.split(","))) {
                if (StringUtils.isNotEmpty(uid.trim())) {
                    userIdList.add(uid.trim());
                }
            }
        }
        if (userIdList.isEmpty()) {
            return Result.failure("请选择要添加的员工");
        }
        int added = spTeamEmployeeService.addMembers(teamId, userIdList);
        return Result.success(added, "成功添加 " + added + " 名员工");
    }

    @ApiOperation("从班组移除员工（软删）")
    @PostMapping("/employee/delete")
    @ResponseBody
    public Result employeeDelete(@RequestParam String id) {
        SpTeamEmployee record = new SpTeamEmployee();
        record.setId(id);
        record.setDeleted("1");
        spTeamEmployeeService.updateById(record);
        return Result.success();
    }
}
