package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.entity.SpProcessingUnitTeam;
import com.wangziyang.mes.basedata.request.SpProcessingUnitReq;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitTeamService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 加工单元管理控制器
 *
 * @author Claude
 * @since 2026-05-28
 */
@Controller
@RequestMapping("/basedata/processing-unit")
public class SpProcessingUnitController extends BaseController {

    @Autowired
    private ISpProcessingUnitService unitService;

    @Autowired
    private ISpProcessingUnitTeamService unitTeamService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "basedata/processing-unit/list";
    }

    @GetMapping("/select-ui")
    public String selectUI() {
        return "basedata/processing-unit/select";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpProcessingUnit record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpProcessingUnit u = unitService.getById(record.getId());
            model.addAttribute("result", u);
        } else {
            SpProcessingUnit init = new SpProcessingUnit();
            init.setUnitCode(unitService.nextUnitCode());
            init.setUnitType("person");
            init.setStatus("0");
            model.addAttribute("result", init);
        }
        return "basedata/processing-unit/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpProcessingUnitReq req) {
        QueryWrapper<SpProcessingUnit> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (StringUtils.isNotEmpty(req.getUnitCodeLike())) qw.like("unit_code", req.getUnitCodeLike());
        if (StringUtils.isNotEmpty(req.getUnitNameLike())) qw.like("unit_name", req.getUnitNameLike());
        if (StringUtils.isNotEmpty(req.getUnitType())) qw.eq("unit_type", req.getUnitType());
        if (StringUtils.isNotEmpty(req.getStatus())) qw.eq("status", req.getStatus());
        qw.orderByDesc("update_time");
        IPage<SpProcessingUnit> result = unitService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        QueryWrapper<SpProcessingUnit> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0").eq("status", "0").orderByAsc("unit_code");
        return Result.success(unitService.list(qw));
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpProcessingUnit record) {
        if (StringUtils.isEmpty(record.getId()) && StringUtils.isEmpty(record.getUnitCode())) {
            record.setUnitCode(unitService.nextUnitCode());
        }
        // 编码唯一校验（小结第1点：编码唯一，重复需更换）
        if (unitService.isUnitCodeDuplicate(record.getUnitCode(), record.getId())) {
            return Result.failure("加工单元编码已存在，请更换编码");
        }
        if (!"2".equals(record.getStatus())) {
            record.setStatus("0");
        }
        unitService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpProcessingUnit req) {
        SpProcessingUnit exist = unitService.getById(req.getId());
        if (exist == null) return Result.failure("数据不存在");
        exist.setDeleted("1");
        unitService.updateById(exist);
        return Result.success();
    }

    // ============================ 加工单元班组管理 ============================

    /** 某加工单元已绑定班组分页查询 */
    @PostMapping("/team/page")
    @ResponseBody
    public Result teamPage(SpProcessingUnitReq req, @RequestParam(required = false) String unitId) {
        if (StringUtils.isEmpty(unitId)) {
            // 未选择加工单元，返回空分页
            return Result.success(new Page<SpProcessingUnitTeam>(req.getCurrent(), req.getSize()));
        }
        IPage<SpProcessingUnitTeam> page = new Page<>(req.getCurrent(), req.getSize());
        IPage<SpProcessingUnitTeam> result = unitTeamService.pageByUnit(page, unitId);
        return Result.success(result);
    }

    /** 班组多选弹窗页面 */
    @GetMapping("/team-select-ui")
    public String teamSelectUI() {
        return "basedata/processing-unit/team-select";
    }

    /** 批量把班组绑定到加工单元（同单元去重） */
    @PostMapping("/team/add")
    @ResponseBody
    public Result teamAdd(@RequestParam String unitId, @RequestParam String teamIds) {
        if (StringUtils.isEmpty(unitId)) {
            return Result.failure("请先选择加工单元");
        }
        List<String> teamIdList = new ArrayList<>();
        if (StringUtils.isNotEmpty(teamIds)) {
            for (String tid : Arrays.asList(teamIds.split(","))) {
                if (StringUtils.isNotEmpty(tid.trim())) {
                    teamIdList.add(tid.trim());
                }
            }
        }
        if (teamIdList.isEmpty()) {
            return Result.failure("请选择要绑定的班组");
        }
        int added = unitTeamService.addTeams(unitId, teamIdList);
        return Result.success(added, "成功绑定 " + added + " 个班组");
    }

    /** 解绑班组（软删） */
    @PostMapping("/team/delete")
    @ResponseBody
    public Result teamDelete(@RequestParam String id) {
        SpProcessingUnitTeam record = new SpProcessingUnitTeam();
        record.setId(id);
        record.setDeleted("1");
        unitTeamService.updateById(record);
        return Result.success();
    }
}
