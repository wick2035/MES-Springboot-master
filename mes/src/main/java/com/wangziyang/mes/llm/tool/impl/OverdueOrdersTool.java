package com.wangziyang.mes.llm.tool.impl;

import cn.hutool.core.date.DateUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.llm.tool.LlmTool;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 工具：查询已超期（计划结束时间早于当前且尚未结束）的工单。
 */
@Component
public class OverdueOrdersTool implements LlmTool {

    @Autowired
    private ISpOrderService orderService;

    @Override
    public String name() {
        return "queryOverdueOrders";
    }

    @Override
    public String description() {
        return "查询超期工单：计划结束时间早于当前时间、且状态仍为创建(1)或进行中(2)的工单。回答哪些工单延期/超期/进度落后时使用。";
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
        String now = DateUtil.now();
        QueryWrapper<SpOrder> qw = new QueryWrapper<>();
        qw.isNotNull("plan_end_time")
                .ne("plan_end_time", "")
                .lt("plan_end_time", now)
                .in("statue", 1, 2)
                .orderByAsc("plan_end_time")
                .last("limit 200");
        List<SpOrder> orders = orderService.list(qw);

        JSONArray list = new JSONArray();
        for (SpOrder o : orders) {
            list.add(new JSONObject()
                    .put("orderCode", o.getOrderCode())
                    .put("materielDesc", o.getMaterielDesc())
                    .put("qty", o.getQty())
                    .put("status", o.getStatue())
                    .put("planEndTime", o.getPlanEndTime()));
        }

        JSONObject result = new JSONObject();
        result.put("now", now);
        result.put("overdueCount", list.size());
        result.put("orders", list);
        return result.toString();
    }
}
