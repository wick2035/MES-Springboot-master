package com.wangziyang.mes.llm.config;

import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 通义千问 DashScope（OpenAI 兼容模式）客户端封装。
 * 仅负责 HTTP 协议层，业务编排在 service 层完成。
 */
@Component
public class DashScopeClient {

    private static final Logger log = LoggerFactory.getLogger(DashScopeClient.class);

    @Autowired
    private LlmProperties props;

    /** 是否已配置 API Key */
    public boolean isConfigured() {
        return StrUtil.isNotBlank(props.getApiKey());
    }

    /**
     * 非流式对话补全（用于第 1 轮工具规划）。
     *
     * @param messages OpenAI 格式消息数组
     * @param tools    工具定义数组，可为 null
     * @return 完整响应 JSON
     */
    public JSONObject chat(JSONArray messages, JSONArray tools) {
        JSONObject body = buildBody(messages, tools, false);
        HttpResponse resp = HttpRequest.post(endpoint())
                .header("Authorization", "Bearer " + props.getApiKey())
                .header("Content-Type", "application/json")
                .timeout(props.getTimeout())
                .body(body.toString())
                .execute();
        try {
            String text = resp.body();
            if (!resp.isOk()) {
                log.error("DashScope 调用失败 status={} body={}", resp.getStatus(), text);
                throw new RuntimeException("大模型调用失败(HTTP " + resp.getStatus() + ")");
            }
            return JSONUtil.parseObj(text);
        } finally {
            resp.close();
        }
    }

    /**
     * 流式对话补全（用于第 2 轮最终作答）。调用方负责读取 {@link HttpResponse#bodyStream()} 并在结束后关闭。
     *
     * @param messages OpenAI 格式消息数组
     * @return 异步 HttpResponse，body 为 text/event-stream
     */
    public HttpResponse chatStream(JSONArray messages) {
        JSONObject body = buildBody(messages, null, true);
        return HttpRequest.post(endpoint())
                .header("Authorization", "Bearer " + props.getApiKey())
                .header("Content-Type", "application/json")
                .header("Accept", "text/event-stream")
                .timeout(props.getTimeout())
                .body(body.toString())
                .executeAsync();
    }

    private JSONObject buildBody(JSONArray messages, JSONArray tools, boolean stream) {
        JSONObject body = new JSONObject();
        body.put("model", props.getModel());
        body.put("messages", messages);
        body.put("stream", stream);
        if (tools != null && !tools.isEmpty()) {
            body.put("tools", tools);
            body.put("tool_choice", "auto");
        }
        return body;
    }

    private String endpoint() {
        return StrUtil.removeSuffix(props.getBaseUrl(), "/") + "/chat/completions";
    }
}
