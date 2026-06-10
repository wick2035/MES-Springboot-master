package com.wangziyang.mes.llm.service;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;

/**
 * AI 辅助 BOM 生成服务。仅产出草稿，不落库；落库复用 /technology/bom/save-with-items。
 */
public interface ILlmBomGenService {

    /**
     * 根据产品信息生成 BOM 草稿（含子项物料属性建议与工序序列建议）。
     *
     * @param productName   产品名称
     * @param productDesc   产品描述
     * @param structureHint 结构/工艺提示，可空
     * @param bomLevel      目标 BOM 层级 0/1/2
     * @return 含 header / items / opers 的草稿 JSON，items 与 opers 中带 matched 标记
     */
    JSONObject generateDraft(String productName, String productDesc, String structureHint, Integer bomLevel);

    /**
     * 工序匹配：按工序名称（oper_desc）精确匹配现有工序主数据，
     * 命中则在元素上回填 matched/operId/oper/unitId/unitName 等字段。
     *
     * @param opers 工序草稿数组（就地修改）
     * @return 匹配命中数量
     */
    int matchOpers(JSONArray opers);
}
