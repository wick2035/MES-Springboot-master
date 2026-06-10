package com.wangziyang.mes.llm.tool.impl;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.llm.tool.LlmTool;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 工具：按物料/状态统计生产工单。
 */
@Component
public class OrderStatsTool implements LlmTool {

    @Autowired
    private ISpOrderService orderService;

    @Override
    public String name() {
        return "queryOrderStats";
    }

    @Override
    public String description() {
        return "统计生产工单：可按物料关键字、工单状态过滤，返回工单总数、各状态(1创建/2进行中/3结束/4终结)数量分布及样本工单。回答工单数量、进度、按物料统计相关问题时使用。";
    }

    @Override
    public JSONObject parametersSchema() {
        JSONObject props = new JSONObject();
        props.put("materielKeyword", new JSONObject()
                .put("type", "string")
                .put("description", "物料编码或物料描述关键字，可选"));
        props.put("status", new JSONObject()
                .put("type", "integer")
                .put("description", "工单状态：1创建 2进行中 3结束 4终结，可选"));
        JSONObject schema = new JSONObject();
        schema.put("type", "object");
        schema.put("properties", props);
        return schema;
    }

    @Override
    public String execute(JSONObject args) {
        String kw = args.getStr("materielKeyword");
        Integer status = args.getInt("status");

        QueryWrapper<SpOrder> qw = new QueryWrapper<>();
        if (StringUtils.isNotBlank(kw)) {
            qw.and(w -> w.like("materiel", kw).or().like("materiel_desc", kw));
        }
        if (status != null) {
            qw.eq("statue", status);
        }
        qw.orderByDesc("update_time").last("limit 200");
        List<SpOrder> orders = orderService.list(qw);

        int[] byStatus = new int[5];
        JSONArray sample = new JSONArray();
        for (SpOrder o : orders) {
            int s = o.getStatue() == null ? 0 : o.getStatue();
            if (s >= 0 && s <= 4) {
                byStatus[s]++;
            }
            if (sample.size() < 20) {
                sample.add(new JSONObject()
                        .put("orderCode", o.getOrderCode())
                        .put("materiel", o.getMateriel())
                        .put("materielDesc", o.getMaterielDesc())
                        .put("qty", o.getQty())
                        .put("status", o.getStatue())
                        .put("planStartTime", o.getPlanStartTime())
                        .put("planEndTime", o.getPlanEndTime()));
            }
        }

        JSONObject statusCount = new JSONObject();
        statusCount.put("1_创建", byStatus[1]);
        statusCount.put("2_进行中", byStatus[2]);
        statusCount.put("3_结束", byStatus[3]);
        statusCount.put("4_终结", byStatus[4]);

        JSONObject result = new JSONObject();
        result.put("total", orders.size());
        result.put("statusCount", statusCount);
        result.put("sample", sample);
        return result.toString();
    }
}
