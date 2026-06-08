package com.wangziyang.mes.technology.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.basedata.entity.SpEquipment;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.service.ISpEquipmentService;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
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
 * 工艺内容编制控制器（7步向导）
 *
 * @author Claude
 * @since 2026-05-28
 */
@Controller
@RequestMapping("/technology/process-content")
public class SpProcessContentController extends BaseController {

    @Autowired
    private ISpProcessContentService contentService;
    @Autowired
    private ISpProcessRouteService routeService;
    @Autowired
    private ISpOperService operService;
    @Autowired
    private ISpProcessingUnitService unitService;
    @Autowired
    private ISpEquipmentService equipmentService;
    @Autowired
    private ISpMaterileService materileService;
    @Autowired
    private ObjectMapper objectMapper;

    /** 主页：左侧产品树，右侧"开始编制"按钮 */
    @GetMapping("/tree-ui")
    public String treeUI(Model model, String bomId) {
        model.addAttribute("bomId", bomId != null ? bomId : "");
        return "technology/process-content/tree";
    }

    /** 进入向导 */
    @GetMapping("/wizard-ui")
    public String wizardUI(Model model, String routeId) {
        SpProcessRoute r = routeService.getById(routeId);
        if (r == null) return "redirect:/technology/process-content/tree-ui";

        SpProcessContent content = contentService.getOrCreateByRoute(routeId);
        model.addAttribute("route", r);
        model.addAttribute("content", content);
        model.addAttribute("contentLocked", "completed".equals(r.getEditStatus()));

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

        return "technology/process-content/wizard";
    }

    @GetMapping("/files")
    @ResponseBody
    public Result files(@RequestParam String routeId, @RequestParam(required = false) String fileType) {
        return Result.success(contentService.listFiles(routeId, fileType));
    }

    @GetMapping("/equipments")
    @ResponseBody
    public Result equipments(@RequestParam String routeId) {
        List<SpProcessEquipmentRel> rels = contentService.listEquipments(routeId);
        return Result.success(enrichEquipments(rels));
    }

    @GetMapping("/materials")
    @ResponseBody
    public Result materials(@RequestParam String routeId) {
        List<SpProcessMaterialRel> rels = contentService.listMaterials(routeId);
        return Result.success(enrichMaterials(rels));
    }

    private List<Map<String, Object>> enrichEquipments(List<SpProcessEquipmentRel> rels) {
        List<Map<String, Object>> rows = new ArrayList<>();
        if (rels == null || rels.isEmpty()) return rows;
        Set<String> ids = new HashSet<>();
        for (SpProcessEquipmentRel r : rels) ids.add(r.getEquipmentId());
        Map<String, SpEquipment> eqMap = new HashMap<>();
        if (!ids.isEmpty()) {
            for (SpEquipment e : equipmentService.listByIds(ids)) eqMap.put(e.getId(), e);
        }
        for (SpProcessEquipmentRel r : rels) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", r.getId());
            m.put("equipmentId", r.getEquipmentId());
            m.put("reqQty", r.getReqQty());
            m.put("remark", r.getRemark());
            SpEquipment e = eqMap.get(r.getEquipmentId());
            if (e != null) {
                m.put("equipmentCode", e.getEquipmentCode());
                m.put("equipmentName", e.getEquipmentName());
                m.put("equipmentModel", e.getEquipmentModel());
                m.put("purpose", e.getPurpose());
            }
            rows.add(m);
        }
        return rows;
    }

    private List<Map<String, Object>> enrichMaterials(List<SpProcessMaterialRel> rels) {
        List<Map<String, Object>> rows = new ArrayList<>();
        if (rels == null || rels.isEmpty()) return rows;
        Set<String> ids = new HashSet<>();
        for (SpProcessMaterialRel r : rels) ids.add(r.getMaterielId());
        Map<String, SpMaterile> matMap = new HashMap<>();
        if (!ids.isEmpty()) {
            for (SpMaterile m : materileService.listByIds(ids)) matMap.put(m.getId(), m);
        }
        for (SpProcessMaterialRel r : rels) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", r.getId());
            m.put("materielId", r.getMaterielId());
            m.put("reqQty", r.getReqQty());
            m.put("remark", r.getRemark());
            SpMaterile mat = matMap.get(r.getMaterielId());
            if (mat != null) {
                m.put("materielCode", mat.getMateriel());
                m.put("materielDesc", mat.getMaterielDesc());
                m.put("matType", mat.getMatType());
                m.put("model", mat.getModel());
            }
            rows.add(m);
        }
        return rows;
    }

    @PostMapping("/save-step2")
    @ResponseBody
    public Result saveStep2(@RequestParam String routeId,
                            @RequestParam(required = false) String contentText,
                            @RequestParam(required = false, defaultValue = "[]") String imgsJson) {
        try {
            contentService.saveStep2Content(routeId, contentText, parseList(imgsJson));
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/save-step3")
    @ResponseBody
    public Result saveStep3(@RequestParam String routeId,
                            @RequestParam(required = false) String requireText,
                            @RequestParam(required = false, defaultValue = "Y") String needCheck,
                            @RequestParam(required = false, defaultValue = "[]") String imgsJson) {
        try {
            contentService.saveStep3Require(routeId, requireText, needCheck, parseList(imgsJson));
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/save-step4")
    @ResponseBody
    public Result saveStep4(@RequestParam String routeId,
                            @RequestParam(required = false) String precautionText,
                            @RequestParam(required = false, defaultValue = "[]") String imgsJson) {
        try {
            contentService.saveStep4Precaution(routeId, precautionText, parseList(imgsJson));
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/save-step5")
    @ResponseBody
    public Result saveStep5(@RequestParam String routeId,
                            @RequestParam(required = false, defaultValue = "[]") String equipmentsJson) {
        try {
            List<SpProcessEquipmentRel> rels = objectMapper.readValue(
                    equipmentsJson, new TypeReference<List<SpProcessEquipmentRel>>() {});
            contentService.saveStep5Equipments(routeId, rels);
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/save-step6")
    @ResponseBody
    public Result saveStep6(@RequestParam String routeId,
                            @RequestParam(required = false) String techDocDesc,
                            @RequestParam(required = false, defaultValue = "[]") String imgsJson,
                            @RequestParam(required = false, defaultValue = "[]") String attachsJson) {
        try {
            contentService.saveStep6TechDoc(routeId, techDocDesc, parseList(imgsJson), parseList(attachsJson));
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/save-step7")
    @ResponseBody
    public Result saveStep7(@RequestParam String routeId,
                            @RequestParam(required = false, defaultValue = "[]") String materialsJson) {
        try {
            List<SpProcessMaterialRel> rels = objectMapper.readValue(
                    materialsJson, new TypeReference<List<SpProcessMaterialRel>>() {});
            contentService.saveStep7Materials(routeId, rels);
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/complete")
    @ResponseBody
    public Result complete(@RequestParam String routeId) {
        try {
            contentService.completeEdit(routeId);
            return Result.success("工序编制完成并锁定");
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/delete-file")
    @ResponseBody
    public Result deleteFile(@RequestParam String fileId) {
        contentService.deleteFile(fileId);
        return Result.success();
    }

    /** 给前端选择工艺：根据BOM返回路由树（复用工艺流程tree） */
    @GetMapping("/route-tree")
    @ResponseBody
    public Result routeTree(@RequestParam String bomId) {
        ProcessRouteNodeVO tree = routeService.getRouteTree(bomId);
        return Result.success(tree);
    }

    private List<Map<String, Object>> parseList(String json) throws Exception {
        if (StringUtils.isEmpty(json)) return Collections.emptyList();
        return objectMapper.readValue(json, new TypeReference<List<Map<String, Object>>>() {});
    }
}
