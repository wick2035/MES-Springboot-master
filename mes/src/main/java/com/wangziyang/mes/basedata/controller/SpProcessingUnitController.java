package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.request.SpProcessingUnitReq;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
            init.setStatus("1");
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
        qw.orderByDesc("update_time");
        IPage<SpProcessingUnit> result = unitService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        QueryWrapper<SpProcessingUnit> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0").eq("status", "1").orderByAsc("unit_code");
        return Result.success(unitService.list(qw));
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpProcessingUnit record) {
        if (StringUtils.isEmpty(record.getId()) && StringUtils.isEmpty(record.getUnitCode())) {
            record.setUnitCode(unitService.nextUnitCode());
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
}
