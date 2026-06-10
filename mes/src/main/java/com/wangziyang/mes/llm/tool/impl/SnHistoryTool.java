package com.wangziyang.mes.llm.tool.impl;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.llm.tool.LlmTool;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.service.ISpSnProcessRecordService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 工具：按 SN 追溯单个产品的全过程采集记录。
 */
@Component
public class SnHistoryTool implements LlmTool {

    @Autowired
    private ISpSnProcessRecordService snService;

    @Override
    public String name() {
        return "querySnHistory";
    }

    @Override
    public String description() {
        return "按序列号(SN)追溯单个产品的过程采集历史，按步骤顺序返回每道工序的 OK/NG 结果与备注。回答某个 SN/产品的生产履历、质量追溯问题时使用。";
    }

    @Override
    public JSONObject parametersSchema() {
        JSONObject props = new JSONObject();
        props.put("sn", new JSONObject()
                .put("type", "string")
                .put("description", "产品序列号 SN（必填）"));
        JSONObject schema = new JSONObject();
        schema.put("type", "object");
        schema.put("properties", props);
        JSONArray required = new JSONArray();
        required.add("sn");
        schema.put("required", required);
        return schema;
    }

    @Override
    public String execute(JSONObject args) {
        String sn = args.getStr("sn");
        if (StringUtils.isBlank(sn)) {
            return "{\"error\":\"缺少参数 sn\"}";
        }
        List<SpSnProcessRecord> records = snService.list(new QueryWrapper<SpSnProcessRecord>()
                .eq("sn", sn)
                .orderByAsc("step_no")
                .last("limit 200"));

        JSONArray steps = new JSONArray();
        for (SpSnProcessRecord r : records) {
            steps.add(new JSONObject()
                    .put("stepNo", r.getStepNo())
                    .put("oper", r.getOper())
                    .put("operDesc", r.getOperDesc())
                    .put("status", r.getStatus())
                    .put("remark", r.getRemark())
                    .put("orderCode", r.getOrderCode()));
        }

        JSONObject result = new JSONObject();
        result.put("sn", sn);
        result.put("stepCount", steps.size());
        result.put("steps", steps);
        return result.toString();
    }
}
