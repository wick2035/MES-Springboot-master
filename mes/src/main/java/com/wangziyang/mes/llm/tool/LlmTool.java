package com.wangziyang.mes.llm.tool;

import cn.hutool.json.JSONObject;

/**
 * 大模型可调用的「只读」查询工具。所有实现必须保证不写库、不产生副作用。
 * 每个实现以 Spring Bean 注册，由 {@link LlmToolRegistry} 汇总成 DashScope tools 定义。
 */
public interface LlmTool {

    /** 工具名（function name），需符合 [a-zA-Z0-9_]，全局唯一 */
    String name();

    /** 工具用途说明，供模型理解何时调用 */
    String description();

    /** 参数 JSON Schema（OpenAI function parameters 规范，type=object） */
    JSONObject parametersSchema();

    /**
     * 执行查询。
     *
     * @param args 模型给出的参数（已解析为 JSON 对象，可能为空对象）
     * @return 查询结果的 JSON 字符串（将作为 role=tool 消息回灌给模型）
     */
    String execute(JSONObject args);
}
