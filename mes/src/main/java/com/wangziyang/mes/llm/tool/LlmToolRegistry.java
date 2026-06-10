package com.wangziyang.mes.llm.tool;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 工具注册表：收集所有 {@link LlmTool} Bean，生成 DashScope tools 定义，并按名称分发执行。
 * 模型只能调用注册表内的工具（白名单），未知工具一律拒绝。
 */
@Component
public class LlmToolRegistry {

    private final Map<String, LlmTool> tools = new LinkedHashMap<>();

    public LlmToolRegistry(List<LlmTool> toolBeans) {
        if (toolBeans != null) {
            for (LlmTool t : toolBeans) {
                tools.put(t.name(), t);
            }
        }
    }

    /** 构建 OpenAI 兼容的 tools 数组 */
    public JSONArray toolSpecs() {
        JSONArray arr = new JSONArray();
        for (LlmTool t : tools.values()) {
            JSONObject fn = new JSONObject();
            fn.put("name", t.name());
            fn.put("description", t.description());
            fn.put("parameters", t.parametersSchema());
            JSONObject wrap = new JSONObject();
            wrap.put("type", "function");
            wrap.put("function", fn);
            arr.add(wrap);
        }
        return arr;
    }

    /** 按名称执行工具；未注册或执行异常时返回带 error 字段的 JSON 字符串，保证流程不中断 */
    public String invoke(String name, JSONObject args) {
        LlmTool tool = tools.get(name);
        if (tool == null) {
            return "{\"error\":\"未知工具: " + name + "\"}";
        }
        try {
            return tool.execute(args == null ? new JSONObject() : args);
        } catch (Exception e) {
            return "{\"error\":\"工具执行失败: " + e.getMessage() + "\"}";
        }
    }

    public Collection<LlmTool> all() {
        return tools.values();
    }
}
