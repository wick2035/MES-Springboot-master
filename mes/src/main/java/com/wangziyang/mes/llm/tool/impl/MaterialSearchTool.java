package com.wangziyang.mes.llm.tool.impl;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.llm.tool.LlmTool;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 工具：按关键字模糊查询物料主数据。
 */
@Component
public class MaterialSearchTool implements LlmTool {

    @Autowired
    private ISpMaterileService materileService;

    @Override
    public String name() {
        return "queryMaterialByKeyword";
    }

    @Override
    public String description() {
        return "按关键字模糊查询物料主数据，返回物料编码、描述、类型(FG成品/PG半成品/COMP组件/PART零件)、单位、来源。回答物料是否存在、物料编码、物料属性相关问题时使用。";
    }

    @Override
    public JSONObject parametersSchema() {
        JSONObject props = new JSONObject();
        props.put("keyword", new JSONObject()
                .put("type", "string")
                .put("description", "物料编码或描述关键字（必填）"));
        props.put("matType", new JSONObject()
                .put("type", "string")
                .put("description", "物料类型过滤：FG/PG/COMP/PART，可选"));
        JSONObject schema = new JSONObject();
        schema.put("type", "object");
        schema.put("properties", props);
        JSONArray required = new JSONArray();
        required.add("keyword");
        schema.put("required", required);
        return schema;
    }

    @Override
    public String execute(JSONObject args) {
        String keyword = args.getStr("keyword");
        String matType = args.getStr("matType");
        if (StringUtils.isBlank(keyword)) {
            return "{\"error\":\"缺少参数 keyword\"}";
        }
        QueryWrapper<SpMaterile> qw = new QueryWrapper<SpMaterile>()
                .ne("is_deleted", "1")
                .and(w -> w.like("materiel", keyword).or().like("materiel_desc", keyword));
        if (StringUtils.isNotBlank(matType)) {
            qw.eq("mat_type", matType);
        }
        qw.last("limit 50");
        List<SpMaterile> materiles = materileService.list(qw);

        JSONArray list = new JSONArray();
        for (SpMaterile m : materiles) {
            list.add(new JSONObject()
                    .put("materiel", m.getMateriel())
                    .put("materielDesc", m.getMaterielDesc())
                    .put("matType", m.getMatType())
                    .put("unit", m.getUnit())
                    .put("matSource", m.getMatSource()));
        }

        JSONObject result = new JSONObject();
        result.put("count", list.size());
        result.put("materials", list);
        return result.toString();
    }
}
