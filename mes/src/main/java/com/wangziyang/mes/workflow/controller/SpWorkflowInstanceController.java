package com.wangziyang.mes.workflow.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.entity.SpWorkflowInstance;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;
import com.wangziyang.mes.workflow.request.WorkflowPageReq;
import com.wangziyang.mes.workflow.service.ISpWorkflowInstanceService;
import com.wangziyang.mes.workflow.service.ISpWorkflowTaskService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/workflow/instance")
public class SpWorkflowInstanceController extends WorkflowBaseController {

    @Autowired
    private ISpWorkflowInstanceService instanceService;

    @Autowired
    private ISpWorkflowTaskService taskService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "workflow/instance/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(WorkflowPageReq req) {
        QueryWrapper<SpWorkflowInstance> qw = buildQuery(req);
        if (StringUtils.isNotBlank(req.getStatus())) {
            qw.eq("status", req.getStatus());
        }
        qw.orderByDesc("start_time").orderByDesc("update_time");
        IPage<SpWorkflowInstance> page = instanceService.page(req, qw);
        return Result.success(page);
    }

    @GetMapping("/summary")
    @ResponseBody
    public Result summary(WorkflowPageReq req) {
        Map<String, Object> data = new HashMap<>();
        data.put("total", countByStatus(req, null));
        data.put("running", countByStatus(req, WorkflowConstants.INSTANCE_RUNNING));
        data.put("completed", countByStatus(req, WorkflowConstants.INSTANCE_COMPLETED));
        data.put("rejected", countByStatus(req, WorkflowConstants.INSTANCE_REJECTED));
        data.put("revoked", countByStatus(req, WorkflowConstants.INSTANCE_REVOKED));
        data.put("longRunning", instanceService.count(buildQuery(req)
                .eq("status", WorkflowConstants.INSTANCE_RUNNING)
                .le("start_time", LocalDateTime.now().minusHours(24)
                        .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))));
        return Result.success(data);
    }

    @GetMapping("/tasks")
    @ResponseBody
    public Result tasks(String instanceId) {
        return Result.success(taskService.list(new QueryWrapper<SpWorkflowTask>()
                .eq("instance_id", instanceId)
                .orderByAsc("create_time")));
    }

    private int countByStatus(WorkflowPageReq req, String status) {
        QueryWrapper<SpWorkflowInstance> qw = buildQuery(req);
        if (StringUtils.isNotBlank(status)) {
            qw.eq("status", status);
        }
        return instanceService.count(qw);
    }

    private QueryWrapper<SpWorkflowInstance> buildQuery(WorkflowPageReq req) {
        QueryWrapper<SpWorkflowInstance> qw = new QueryWrapper<>();
        if (req == null) {
            return qw;
        }
        if (StringUtils.isNotBlank(req.getKeyword())) {
            qw.and(w -> w.like("title", req.getKeyword()).or().like("business_code", req.getKeyword()));
        }
        if (StringUtils.isNotBlank(req.getBusinessType())) {
            qw.eq("business_type", req.getBusinessType());
        }
        return qw;
    }
}
