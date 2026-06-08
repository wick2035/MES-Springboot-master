package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpEquipment;
import com.wangziyang.mes.basedata.request.SpEquipmentReq;
import com.wangziyang.mes.basedata.service.ISpEquipmentService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * 设备管理控制器
 *
 * @author Claude
 * @since 2026-05-28
 */
@Controller
@RequestMapping("/basedata/equipment")
public class SpEquipmentController extends BaseController {

    @Autowired
    private ISpEquipmentService equipmentService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "basedata/equipment/list";
    }

    @GetMapping("/select-ui")
    public String selectUI() {
        return "basedata/equipment/select";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpEquipment record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpEquipment e = equipmentService.getById(record.getId());
            model.addAttribute("result", e);
        } else {
            SpEquipment init = new SpEquipment();
            init.setEquipmentCode(equipmentService.nextEquipmentCode());
            init.setStatus("1");
            model.addAttribute("result", init);
        }
        return "basedata/equipment/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpEquipmentReq req) {
        QueryWrapper<SpEquipment> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (StringUtils.isNotEmpty(req.getEquipmentCodeLike())) qw.like("equipment_code", req.getEquipmentCodeLike());
        if (StringUtils.isNotEmpty(req.getEquipmentNameLike())) qw.like("equipment_name", req.getEquipmentNameLike());
        if (StringUtils.isNotEmpty(req.getPurposeLike())) qw.like("purpose", req.getPurposeLike());
        qw.orderByDesc("update_time");
        IPage<SpEquipment> result = equipmentService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        QueryWrapper<SpEquipment> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0").eq("status", "1").orderByAsc("equipment_code");
        return Result.success(equipmentService.list(qw));
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpEquipment record) {
        if (StringUtils.isEmpty(record.getId()) && StringUtils.isEmpty(record.getEquipmentCode())) {
            record.setEquipmentCode(equipmentService.nextEquipmentCode());
        }
        equipmentService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        if (!"0".equals(status) && !"1".equals(status)) {
            return Result.failure("状态参数不正确");
        }
        SpEquipment exist = equipmentService.getById(id);
        if (exist == null || "1".equals(exist.getDeleted())) return Result.failure("数据不存在");
        exist.setStatus(status);
        equipmentService.updateById(exist);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpEquipment req) {
        SpEquipment exist = equipmentService.getById(req.getId());
        if (exist == null) return Result.failure("数据不存在");
        exist.setDeleted("1");
        equipmentService.updateById(exist);
        return Result.success();
    }
}
