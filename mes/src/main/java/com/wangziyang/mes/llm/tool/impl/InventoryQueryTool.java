package com.wangziyang.mes.llm.tool.impl;

import cn.hutool.core.convert.Convert;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.llm.tool.LlmTool;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工具：按物料关键字查询在手库存总量。
 */
@Component
public class InventoryQueryTool implements LlmTool {

    @Autowired
    private ISpMaterileService materileService;

    @Autowired
    private ISpInventoryService inventoryService;

    @Override
    public String name() {
        return "queryInventory";
    }

    @Override
    public String description() {
        return "查询物料库存：按物料编码或描述关键字返回匹配物料的在手总量与安全库存。回答某物料还有多少库存、在手量相关问题时使用。";
    }

    @Override
    public JSONObject parametersSchema() {
        JSONObject props = new JSONObject();
        props.put("materielKeyword", new JSONObject()
                .put("type", "string")
                .put("description", "物料编码或描述关键字；不填则返回部分物料"));
        JSONObject schema = new JSONObject();
        schema.put("type", "object");
        schema.put("properties", props);
        return schema;
    }

    @Override
    public String execute(JSONObject args) {
        String kw = args.getStr("materielKeyword");

        QueryWrapper<SpMaterile> mqw = new QueryWrapper<SpMaterile>().ne("is_deleted", "1");
        if (StringUtils.isNotBlank(kw)) {
            mqw.and(w -> w.like("materiel", kw).or().like("materiel_desc", kw));
        }
        mqw.last("limit 50");
        List<SpMaterile> materiles = materileService.list(mqw);
        if (materiles.isEmpty()) {
            return "{\"message\":\"未找到匹配的物料\"}";
        }

        List<String> ids = new ArrayList<>();
        for (SpMaterile m : materiles) {
            ids.add(m.getId());
        }

        List<Map<String, Object>> invRows = inventoryService.listMaps(new QueryWrapper<SpInventory>()
                .select("materiel_id", "sum(qty) as total")
                .ne("is_deleted", "1")
                .in("materiel_id", ids)
                .groupBy("materiel_id"));
        Map<String, BigDecimal> onHandMap = new HashMap<>();
        for (Map<String, Object> row : invRows) {
            String mid = row.get("materiel_id") == null ? null : String.valueOf(row.get("materiel_id"));
            if (mid != null) {
                onHandMap.put(mid, Convert.toBigDecimal(row.get("total"), BigDecimal.ZERO));
            }
        }

        JSONArray list = new JSONArray();
        for (SpMaterile m : materiles) {
            list.add(new JSONObject()
                    .put("materiel", m.getMateriel())
                    .put("materielDesc", m.getMaterielDesc())
                    .put("unit", m.getUnit())
                    .put("onHand", onHandMap.getOrDefault(m.getId(), BigDecimal.ZERO))
                    .put("safetyStock", m.getSafetyStock()));
        }

        JSONObject result = new JSONObject();
        result.put("count", list.size());
        result.put("materials", list);
        return result.toString();
    }
}
