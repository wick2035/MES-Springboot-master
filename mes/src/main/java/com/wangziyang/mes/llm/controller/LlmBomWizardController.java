package com.wangziyang.mes.llm.controller;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.llm.service.ILlmBomGenService;
import com.wangziyang.mes.llm.service.ILlmBomWizardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * AI 智能建模分步向导控制器。
 *
 * 步骤① 复用 /llm/bom-gen/generate 生成草稿；
 * 步骤② 物料一键补建后复用 /technology/bom/save-with-items 保存 BOM；
 * 步骤③④ 由本控制器承接：工序/工艺路线创建、人员分配建议预览与生产订单生成。
 */
@Controller
@RequestMapping("/llm/bom-wizard")
public class LlmBomWizardController extends BaseController {

    @Autowired
    private ILlmBomWizardService wizardService;

    @Autowired
    private ILlmBomGenService bomGenService;

    /** 步骤②：未匹配物料一键入库（含 BOM 前置条件自动补齐） */
    @PostMapping("/material/batch-create")
    @ResponseBody
    public Result batchCreateMaterials(@RequestBody String body) {
        try {
            JSONObject req = JSONUtil.parseObj(body);
            return Result.success(wizardService.batchCreateMaterials(
                    req.getStr("productName"), req.getInt("bomLevel"), req.getJSONArray("materials")));
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    /** 步骤②：BOM 全链保存并定版（自动补建/定版子BOM，子件作 PART 物料入库） */
    @PostMapping("/bom/save-full")
    @ResponseBody
    public Result saveBomFullChain(@RequestBody String body) {
        try {
            JSONObject req = JSONUtil.parseObj(body);
            return Result.success(wizardService.saveBomFullChain(
                    req.getJSONObject("header"), req.getJSONArray("items")));
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    /** 步骤③：重新按工序名称匹配现有工序（防止步骤之间他人新建工序） */
    @PostMapping("/oper/match")
    @ResponseBody
    public Result matchOpers(@RequestBody String body) {
        try {
            JSONObject req = JSONUtil.parseObj(body);
            JSONArray opers = req.getJSONArray("opers");
            if (opers == null) {
                opers = new JSONArray();
            }
            int matched = bomGenService.matchOpers(opers);
            JSONObject data = new JSONObject();
            data.put("opers", opers);
            data.put("operMatchedCount", matched);
            data.put("totalOpers", opers.size());
            return Result.success(data);
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    /** 步骤③：缺失工序补建 + 工艺路线创建 */
    @PostMapping("/flow/create")
    @ResponseBody
    public Result createOpersAndFlow(@RequestBody String body) {
        try {
            JSONObject req = JSONUtil.parseObj(body);
            return Result.success(wizardService.createOpersAndFlow(
                    req.getStr("productName"), req.getJSONArray("opers"), req.getStr("bomId")));
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    /** 步骤④：人员负载均衡分配预览（只读） */
    @PostMapping("/order/preview-assign")
    @ResponseBody
    public Result previewAssign(@RequestBody String body) {
        try {
            JSONObject req = JSONUtil.parseObj(body);
            return Result.success(wizardService.previewAssign(req.getStr("flowId")));
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    /** 步骤④：改人弹层候选列表（限定加工单元绑定班组的成员，含当前负载） */
    @GetMapping("/assign/candidates")
    @ResponseBody
    public Result assignCandidates(String unitId) {
        try {
            if (StrUtil.isBlank(unitId)) {
                return Result.failure("缺少加工单元");
            }
            return Result.success(wizardService.assignCandidates(unitId));
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    /** 步骤④：生成生产订单草稿（进入生产计划中心后续确认/工单/派工/下发） */
    @PostMapping("/production-order/create")
    @ResponseBody
    public Result createProductionOrder(@RequestBody String body) {
        try {
            JSONObject req = JSONUtil.parseObj(body);
            return Result.success(wizardService.createProductionOrder(req.getJSONObject("order")));
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }
}
