package com.wangziyang.mes.llm.tool.impl;

import cn.hutool.core.util.NumberUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.llm.tool.LlmTool;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.service.ISpSnProcessRecordService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 工具：基于 SN 过程采集记录，按工序统计报工合格率（OK/NG）。
 */
@Component
public class YieldByOperationTool implements LlmTool {

    @Autowired
    private ISpSnProcessRecordService snService;

    @Autowired
    private ISpOrderService orderService;

    @Override
    public String name() {
        return "queryYieldByOperation";
    }

    @Override
    public String description() {
        return "统计报工/过程采集合格率：基于 SN 过程采集记录，按工序汇总 OK/NG 数量并计算合格率。可按工单编号或物料关键字过滤。回答合格率、良率、不良率、各工序质量相关问题时使用。";
    }

    @Override
    public JSONObject parametersSchema() {
        JSONObject props = new JSONObject();
        props.put("orderCode", new JSONObject()
                .put("type", "string")
                .put("description", "工单编号，可选"));
        props.put("materielKeyword", new JSONObject()
                .put("type", "string")
                .put("description", "物料编码或描述关键字，可选（将先匹配工单再统计）"));
        JSONObject schema = new JSONObject();
        schema.put("type", "object");
        schema.put("properties", props);
        return schema;
    }

    @Override
    public String execute(JSONObject args) {
        String orderCode = args.getStr("orderCode");
        String kw = args.getStr("materielKeyword");

        QueryWrapper<SpSnProcessRecord> qw = new QueryWrapper<>();
        qw.select("oper", "status", "count(*) as cnt");
        if (StringUtils.isNotBlank(orderCode)) {
            qw.eq("order_code", orderCode);
        } else if (StringUtils.isNotBlank(kw)) {
            List<SpOrder> orders = orderService.list(new QueryWrapper<SpOrder>()
                    .and(w -> w.like("materiel", kw).or().like("materiel_desc", kw))
                    .last("limit 500"));
            List<String> codes = new ArrayList<>();
            for (SpOrder o : orders) {
                if (StringUtils.isNotBlank(o.getOrderCode())) {
                    codes.add(o.getOrderCode());
                }
            }
            if (codes.isEmpty()) {
                return "{\"message\":\"未找到匹配该物料关键字的工单\"}";
            }
            qw.in("order_code", codes);
        }
        qw.groupBy("oper", "status");
        List<Map<String, Object>> rows = snService.listMaps(qw);

        // 按工序聚合 ok / ng
        Map<String, long[]> perOper = new LinkedHashMap<>();
        long totalOk = 0;
        long totalNg = 0;
        for (Map<String, Object> row : rows) {
            String oper = row.get("oper") == null ? "未知工序" : String.valueOf(row.get("oper"));
            String status = row.get("status") == null ? "" : String.valueOf(row.get("status"));
            long cnt = row.get("cnt") == null ? 0L : Long.parseLong(String.valueOf(row.get("cnt")));
            long[] okng = perOper.computeIfAbsent(oper, k -> new long[2]);
            if ("OK".equalsIgnoreCase(status)) {
                okng[0] += cnt;
                totalOk += cnt;
            } else if ("NG".equalsIgnoreCase(status)) {
                okng[1] += cnt;
                totalNg += cnt;
            }
        }

        JSONArray byOper = new JSONArray();
        for (Map.Entry<String, long[]> e : perOper.entrySet()) {
            long ok = e.getValue()[0];
            long ng = e.getValue()[1];
            long total = ok + ng;
            byOper.add(new JSONObject()
                    .put("oper", e.getKey())
                    .put("ok", ok)
                    .put("ng", ng)
                    .put("total", total)
                    .put("passRate", total == 0 ? "0%" : NumberUtil.formatPercent((double) ok / total, 2)));
        }

        long grandTotal = totalOk + totalNg;
        JSONObject result = new JSONObject();
        result.put("totalRecords", grandTotal);
        result.put("totalOk", totalOk);
        result.put("totalNg", totalNg);
        result.put("overallPassRate", grandTotal == 0 ? "0%" : NumberUtil.formatPercent((double) totalOk / grandTotal, 2));
        result.put("byOperation", byOper);
        return result.toString();
    }
}
