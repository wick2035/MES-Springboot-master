package com.wangziyang.mes.llm.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 大模型（通义千问 DashScope，OpenAI 兼容接口）配置。
 * 对应 application.yml 中的 llm.* 配置项；api-key 建议通过环境变量 DASHSCOPE_API_KEY 注入。
 */
@Component
@ConfigurationProperties(prefix = "llm")
public class LlmProperties {

    /** 供应商标识，目前固定 dashscope */
    private String provider = "dashscope";

    /** OpenAI 兼容接口基地址，末尾不带斜杠 */
    private String baseUrl = "https://dashscope.aliyuncs.com/compatible-mode/v1";

    /** API Key（Bearer Token） */
    private String apiKey;

    /** 模型名称 */
    private String model = "qwen-plus";

    /** 单次请求超时时间（毫秒） */
    private int timeout = 60000;

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public int getTimeout() {
        return timeout;
    }

    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }
}
