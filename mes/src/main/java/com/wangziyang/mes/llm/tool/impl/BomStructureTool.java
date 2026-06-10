package com.wangziyang.mes.llm.tool.impl;

import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.llm.tool.LlmTool;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.vo.BomTreeNodeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashSet;

/**
 * 工具：按物料编码/关键字查询多级 BOM 结构。
 */
@Component
public class BomStructureTool implements LlmTool {

    @Autowired
    private ISpBomService bomService;

    @Override
    public String name() {
        return "queryBomStructure";
    }

    @Override
    public String description() {
        return "查询产品的多级 BOM 结构：按物料编码或物料描述关键字定位 BOM，返回其完整层级子项树（含用量、单位、物料类型）。回答某产品由哪些零部件/物料组成、BOM 展开相关问题时使用。";
    }

    @Override
    public JSONObject parametersSchema() {
        JSONObject props = new JSONObject();
        props.put("materielKeyword", new JSONObject()
                .put("type", "string")
                .put("description", "物料编码或物料描述关键字（必填）"));
        JSONObject schema = new JSONObject();
        schema.put("type", "object");
        schema.put("properties", props);
        return schema;
    }

    @Override
    public String execute(JSONObject args) {
        String kw = args.getStr("materielKeyword");
        if (StringUtils.isBlank(kw)) {
            return "{\"error\":\"缺少参数 materielKeyword\"}";
        }
        SpBom bom = bomService.getOne(new QueryWrapper<SpBom>()
                .ne("is_deleted", "1")
                .and(w -> w.like("materiel_code", kw).or().like("materiel_desc", kw))
                .orderByDesc("update_time")
                .last("limit 1"), false);
        if (bom == null) {
            return "{\"message\":\"未找到匹配的 BOM\"}";
        }

        BomTreeNodeVO tree = bomService.buildBomTree(bom.getId(), new HashSet<>());

        JSONObject result = new JSONObject();
        result.put("bomCode", bom.getBomCode());
        result.put("materielCode", bom.getMaterielCode());
        result.put("materielDesc", bom.getMaterielDesc());
        result.put("versionNumber", bom.getVersionNumber());
        result.put("tree", JSONUtil.parse(tree));
        return result.toString();
    }
}
