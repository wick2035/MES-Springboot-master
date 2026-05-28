package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.*;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.service.ISpProcessContentService;
import com.wangziyang.mes.technology.service.ISpProcessRouteService;
import com.wangziyang.mes.technology.vo.ProcessRouteNodeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 产品工艺查询控制器（只读）
 *
 * @author Claude
 * @since 2026-05-28
 */
@Controller
@RequestMapping("/technology/process-query")
public class SpProcessQueryController extends BaseController {

    @Autowired
    private ISpProcessRouteService routeService;
    @Autowired
    private ISpProcessContentService contentService;
    @Autowired
    private ISpOperService operService;
    @Autowired
    private ISpProcessingUnitService unitService;

    @GetMapping("/tree-ui")
    public String treeUI(Model model, String bomId) {
        model.addAttribute("bomId", bomId != null ? bomId : "");
        return "technology/process-query/tree";
    }

    @GetMapping("/detail-ui")
    public String detailUI(Model model, String routeId) {
        SpProcessRoute r = routeService.getById(routeId);
        if (r == null) return "redirect:/technology/process-query/tree-ui";

        SpProcessContent content = contentService.getOne(
                new QueryWrapper<SpProcessContent>().eq("route_id", routeId));
        model.addAttribute("route", r);
        model.addAttribute("content", content != null ? content : new SpProcessContent());

        // 工序主信息
        Map<String, Object> mainInfo = new HashMap<>();
        if (StringUtils.isNotEmpty(r.getOperId())) {
            SpOper o = operService.getById(r.getOperId());
            if (o != null) {
                mainInfo.put("operCode", o.getOper());
                mainInfo.put("operName", o.getOperDesc());
                mainInfo.put("operHours", o.getOperHours());
                mainInfo.put("manuCycle", o.getManuCycle());
                mainInfo.put("genPlan", o.getGenPlan());
                if (StringUtils.isNotEmpty(o.getUnitId())) {
                    SpProcessingUnit u = unitService.getById(o.getUnitId());
                    if (u != null) {
                        mainInfo.put("unitName", u.getUnitName());
                        mainInfo.put("unitTypeName", "device".equals(u.getUnitType()) ? "设备作业单元" : "人员作业单元");
                    }
                }
            }
        }
        model.addAttribute("mainInfo", mainInfo);
        return "technology/process-query/detail";
    }

    @GetMapping("/route-tree")
    @ResponseBody
    public Result routeTree(@RequestParam String bomId) {
        ProcessRouteNodeVO tree = routeService.getRouteTree(bomId);
        return Result.success(tree);
    }

    @GetMapping("/detail-data")
    @ResponseBody
    public Result detailData(@RequestParam String routeId) {
        Map<String, Object> data = new HashMap<>();
        SpProcessRoute r = routeService.getById(routeId);
        if (r == null) return Result.failure("工艺记录不存在");
        data.put("route", r);

        SpProcessContent c = contentService.getOne(new QueryWrapper<SpProcessContent>().eq("route_id", routeId));
        data.put("content", c);

        // 各类文件
        data.put("contentImgs", contentService.listFiles(routeId, "CONTENT_IMG"));
        data.put("reqImgs", contentService.listFiles(routeId, "REQ_IMG"));
        data.put("precImgs", contentService.listFiles(routeId, "PREC_IMG"));
        data.put("techImgs", contentService.listFiles(routeId, "TECH_IMG"));
        data.put("techAttachs", contentService.listFiles(routeId, "TECH_ATTACH"));

        return Result.success(data);
    }
}
