package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpProcessRoute;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.service.ISpProcessRouteService;
import com.wangziyang.mes.technology.vo.ProcessRouteNodeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工艺流程管理控制器
 *
 * @author Claude
 * @since 2026-05-28
 */
@Controller
@RequestMapping("/technology/process-route")
public class SpProcessRouteController extends BaseController {

    @Autowired
    private ISpProcessRouteService routeService;

    @Autowired
    private ISpBomService bomService;

    @GetMapping("/tree-ui")
    public String treeUI(Model model, String bomId) {
        model.addAttribute("bomId", bomId != null ? bomId : "");
        return "technology/process-route/tree";
    }

    @GetMapping("/edit-ui")
    public String editUI(Model model, String routeId) {
        SpProcessRoute r = routeService.getById(routeId);
        if (r == null) return "redirect:/technology/process-route/tree-ui";
        model.addAttribute("route", r);
        // 上级工艺
        if (StringUtils.isNotEmpty(r.getParentRouteId())) {
            SpProcessRoute parent = routeService.getById(r.getParentRouteId());
            model.addAttribute("parentRoute", parent);
        }
        return "technology/process-route/edit";
    }

    /** 工艺流程管理选择BOM的弹窗 */
    @GetMapping("/select-bom-ui")
    public String selectBomUI() {
        return "technology/process-route/selectBom";
    }

    @GetMapping("/locked-bom-page")
    @ResponseBody
    public Result lockedBomPage() {
        // 仅返回已锁定的BOM列表，作为工艺流程入口选择
        QueryWrapper<SpBom> qw = new QueryWrapper<>();
        qw.eq("lock_status", "locked")
                .eq("state", "pass")
                .eq("validity", "有效")
                .eq("bom_level", 0)
                .eq("is_deleted", "0")
                .orderByDesc("update_time");
        return Result.success(bomService.list(qw));
    }

    @PostMapping("/init")
    @ResponseBody
    public Result init(String bomId) {
        try {
            int count = routeService.initRoutes(bomId);
            Map<String, Object> data = new HashMap<>();
            data.put("count", count);
            return Result.success(data, "已生成 " + count + " 条工艺记录");
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @GetMapping("/tree")
    @ResponseBody
    public Result tree(@RequestParam String bomId) {
        ProcessRouteNodeVO root = routeService.getRouteTree(bomId);
        Map<String, Object> data = new HashMap<>();
        data.put("tree", root);
        data.put("locked", routeService.isLocked(bomId));
        return Result.success(data);
    }

    @PostMapping("/bind-oper")
    @ResponseBody
    public Result bindOper(String routeId, String operId) {
        try {
            routeService.bindOper(routeId, operId);
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/lock")
    @ResponseBody
    public Result lock(String bomId) {
        try {
            routeService.lockAll(bomId);
            return Result.success("锁定产品工艺规划成功");
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @GetMapping("/list-by-bom")
    @ResponseBody
    public Result listByBom(@RequestParam String bomId) {
        List<SpProcessRoute> routes = routeService.listByBomId(bomId);
        return Result.success(routes);
    }
}
