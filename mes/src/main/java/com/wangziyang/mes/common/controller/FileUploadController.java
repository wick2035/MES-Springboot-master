package com.wangziyang.mes.common.controller;

import com.wangziyang.mes.common.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 通用文件上传控制器
 *
 * @author Claude
 * @since 2026-05-28
 */
@Controller
@RequestMapping("/common")
public class FileUploadController {

    @Value("${mes.file.upload-path:D:/mes/upload}")
    private String uploadPath;

    @Value("${mes.file.access-prefix:/upload}")
    private String accessPrefix;

    private static final Set<String> ALLOWED_EXT = new HashSet<>(Arrays.asList(
            "jpg", "jpeg", "png", "gif", "bmp", "webp",
            "doc", "docx", "xls", "xlsx", "ppt", "pptx",
            "pdf", "txt", "zip", "rar"));

    private static final long MAX_SIZE = 20L * 1024 * 1024;

    @PostMapping("/upload")
    @ResponseBody
    public Result upload(@RequestParam("file") MultipartFile file) {
        try {
            Map<String, Object> data = saveOne(file);
            return Result.success(data);
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @PostMapping("/uploads")
    @ResponseBody
    public Result uploads(@RequestParam("files") MultipartFile[] files) {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            for (MultipartFile f : files) {
                list.add(saveOne(f));
            }
            return Result.success(list);
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    private Map<String, Object> saveOne(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) throw new IOException("上传文件为空");
        if (file.getSize() > MAX_SIZE) throw new IOException("文件大小超过限制(20MB)");
        String original = file.getOriginalFilename();
        if (StringUtils.isEmpty(original)) throw new IOException("文件名为空");
        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0) ext = original.substring(dot + 1).toLowerCase();
        if (!ALLOWED_EXT.contains(ext)) throw new IOException("不允许的文件类型: " + ext);

        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        File dir = new File(uploadPath, datePath);
        if (!dir.exists() && !dir.mkdirs()) throw new IOException("创建上传目录失败");

        String newName = UUID.randomUUID().toString().replace("-", "") + "." + ext;
        File dest = new File(dir, newName);
        file.transferTo(dest);

        String relativePath = datePath + "/" + newName;
        Map<String, Object> data = new HashMap<>();
        data.put("originalName", original);
        data.put("filePath", relativePath);
        data.put("url", accessPrefix + "/" + relativePath);
        data.put("size", file.getSize());
        return data;
    }
}
