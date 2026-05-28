package com.wangziyang.mes.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

/**
 * Web 静态资源映射：把本地上传目录暴露给 /upload/** 访问。
 *
 * @author Claude
 * @since 2026-05-28
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${mes.file.upload-path:D:/mes/upload}")
    private String uploadPath;

    @Value("${mes.file.access-prefix:/upload}")
    private String accessPrefix;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        File dir = new File(uploadPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String location = dir.getAbsolutePath().replace("\\", "/");
        if (!location.endsWith("/")) location += "/";
        registry.addResourceHandler(accessPrefix + "/**")
                .addResourceLocations("file:" + location);
    }
}
