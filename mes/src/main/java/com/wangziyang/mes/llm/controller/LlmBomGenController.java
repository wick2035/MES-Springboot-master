package com.wangziyang.mes.llm.controller;

import cn.hutool.json.JSONObject;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.llm.service.ILlmBomGenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * AI 辅助 BOM 生成控制器。仅生成草稿，落库走 /technology/bom/save-with-items。
 */
@Controller
@RequestMapping("/llm/bom-gen")
public class LlmBomGenController extends BaseController {

    @Autowired
    private ILlmBomGenService bomGenService;

    @GetMapping("/gen-ui")
    public String genUI() {
        return "llm/bomgen/index";
    }

    @PostMapping("/generate")
    @ResponseBody
    public Result generate(String productName, String productDesc, String structureHint, Integer bomLevel) {
        try {
            JSONObject draft = bomGenService.generateDraft(productName, productDesc, structureHint, bomLevel);
            return Result.success(draft);
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }
}
