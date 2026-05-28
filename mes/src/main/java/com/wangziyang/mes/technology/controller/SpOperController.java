package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.request.SpOperReq;
import com.wangziyang.mes.technology.service.ISpOperService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 工序信息定义控制器
 *
 * @author Claude
 * @since 2026-05-28
 */
@Controller
@RequestMapping("/technology/oper")
public class SpOperController extends BaseController {

    @Autowired
    private ISpOperService operService;

    @Autowired
    private ISpProcessingUnitService unitService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "technology/oper/list";
    }

    @GetMapping("/select-ui")
    public String selectUI() {
        return "technology/oper/select";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpOper record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpOper o = operService.getById(record.getId());
            model.addAttribute("result", o);
            String unitName = "";
            if (o != null && StringUtils.isNotEmpty(o.getUnitId())) {
                SpProcessingUnit u = unitService.getById(o.getUnitId());
                if (u != null) unitName = u.getUnitName();
            }
            model.addAttribute("unitName", unitName);
        } else {
            SpOper init = new SpOper();
            init.setOper(operService.nextOperCode());
            init.setGenPlan("Y");
            model.addAttribute("result", init);
            model.addAttribute("unitName", "");
        }
        return "technology/oper/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpOperReq req) {
        QueryWrapper<SpOper> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getOperLike())) qw.like("oper", req.getOperLike());
        if (StringUtils.isNotEmpty(req.getOperDescLike())) qw.like("oper_desc", req.getOperDescLike());
        if (StringUtils.isNotEmpty(req.getUnitId())) qw.eq("unit_id", req.getUnitId());
        qw.orderByDesc("update_time");
        IPage<SpOper> result = operService.page(req, qw);

        List<SpOper> records = result.getRecords();
        if (records == null || records.isEmpty()) return Result.success(result);

        List<String> unitIds = records.stream()
                .map(SpOper::getUnitId).filter(StringUtils::isNotEmpty).distinct().collect(Collectors.toList());
        Map<String, SpProcessingUnit> unitMap = new HashMap<>();
        if (!unitIds.isEmpty()) {
            for (SpProcessingUnit u : unitService.listByIds(unitIds)) {
                unitMap.put(u.getId(), u);
            }
        }

        List<Map<String, Object>> rows = records.stream().map(o -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", o.getId());
            m.put("oper", o.getOper());
            m.put("operDesc", o.getOperDesc());
            m.put("unitId", o.getUnitId());
            m.put("operHours", o.getOperHours());
            m.put("manuCycle", o.getManuCycle());
            m.put("genPlan", o.getGenPlan());
            m.put("remark", o.getRemark());
            m.put("updateTime", o.getUpdateTime());
            SpProcessingUnit unit = unitMap.get(o.getUnitId());
            m.put("unitName", unit != null ? unit.getUnitName() : "");
            m.put("unitTypeName", unit == null ? "" :
                    ("device".equals(unit.getUnitType()) ? "设备作业单元" : "人员作业单元"));
            return m;
        }).collect(Collectors.toList());

        Map<String, Object> data = new HashMap<>();
        data.put("records", rows);
        data.put("total", result.getTotal());
        data.put("size", result.getSize());
        data.put("current", result.getCurrent());
        return Result.success(data);
    }

    @GetMapping("/list")
    @ResponseBody
    public Result list() {
        return Result.success(operService.list(new QueryWrapper<SpOper>().orderByAsc("oper")));
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpOper record) {
        if (record.getOperHours() != null && record.getManuCycle() != null
                && record.getManuCycle().compareTo(record.getOperHours()) < 0) {
            return Result.failure("制造周期应大于等于工序工时");
        }
        if (StringUtils.isEmpty(record.getId()) && StringUtils.isEmpty(record.getOper())) {
            record.setOper(operService.nextOperCode());
        }
        if (record.getOperHours() == null) record.setOperHours(BigDecimal.ZERO);
        if (record.getManuCycle() == null) record.setManuCycle(BigDecimal.ZERO);
        if (StringUtils.isEmpty(record.getGenPlan())) record.setGenPlan("Y");
        operService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpOper req) {
        operService.removeById(req.getId());
        return Result.success();
    }

    @GetMapping("/getInfo")
    @ResponseBody
    public Result getInfo(String id) {
        SpOper o = operService.getById(id);
        Map<String, Object> data = new HashMap<>();
        if (o == null) return Result.success(data);
        data.put("oper", o);
        if (StringUtils.isNotEmpty(o.getUnitId())) {
            SpProcessingUnit u = unitService.getById(o.getUnitId());
            if (u != null) {
                data.put("unitName", u.getUnitName());
                data.put("unitType", u.getUnitType());
                data.put("unitTypeName", "device".equals(u.getUnitType()) ? "设备作业单元" : "人员作业单元");
            }
        }
        return Result.success(data);
    }
}
