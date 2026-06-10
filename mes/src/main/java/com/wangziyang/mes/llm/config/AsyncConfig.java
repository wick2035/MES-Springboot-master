package com.wangziyang.mes.llm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * 大模型对话使用的异步线程池配置。
 * SSE 流式响应需要在独立线程中调用大模型并逐块推送，避免阻塞 Web 容器线程。
 */
@Configuration
@EnableAsync
public class AsyncConfig {

    /** 供 SSE 流式对话使用的线程池 */
    @Bean("llmExecutor")
    public Executor llmExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(4);
        executor.setMaxPoolSize(16);
        executor.setQueueCapacity(50);
        executor.setThreadNamePrefix("llm-stream-");
        executor.initialize();
        return executor;
    }
}
