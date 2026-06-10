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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工具：查询库存低于安全库存的物料。
 */
@Component
public class LowStockTool implements LlmTool {

    @Autowired
    private ISpMaterileService materileService;

    @Autowired
    private ISpInventoryService inventoryService;

    @Override
    public String name() {
        return "queryLowStockMaterials";
    }

    @Override
    public String description() {
        return "查询库存预警：返回当前在手总量低于其安全库存的物料清单（含在手量、安全库存、缺口）。回答哪些物料缺货/低于安全库存/需要补货时使用。";
    }

    @Override
    public JSONObject parametersSchema() {
        JSONObject schema = new JSONObject();
        schema.put("type", "object");
        schema.put("properties", new JSONObject());
        return schema;
    }

    @Override
    public String execute(JSONObject args) {
        // 设置了安全库存(>0)的物料
        List<SpMaterile> materiles = materileService.list(new QueryWrapper<SpMaterile>()
                .ne("is_deleted", "1")
                .isNotNull("safety_stock")
                .gt("safety_stock", 0));

        // 各物料在手总量（按 materiel_id 聚合）
        List<Map<String, Object>> invRows = inventoryService.listMaps(new QueryWrapper<SpInventory>()
                .select("materiel_id", "sum(qty) as total")
                .ne("is_deleted", "1")
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
            BigDecimal onHand = onHandMap.getOrDefault(m.getId(), BigDecimal.ZERO);
            BigDecimal safety = new BigDecimal(m.getSafetyStock());
            if (onHand.compareTo(safety) < 0) {
                list.add(new JSONObject()
                        .put("materiel", m.getMateriel())
                        .put("materielDesc", m.getMaterielDesc())
                        .put("unit", m.getUnit())
                        .put("onHand", onHand)
                        .put("safetyStock", m.getSafetyStock())
                        .put("shortage", safety.subtract(onHand))
                        .put("leadTime", m.getLeadTime()));
            }
        }

        JSONObject result = new JSONObject();
        result.put("lowStockCount", list.size());
        result.put("materials", list);
        return result.toString();
    }
}
