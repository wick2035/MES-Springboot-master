package com.wangziyang.mes.workflow.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysUserService;
import com.wangziyang.mes.workflow.WorkflowConstants;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;
import com.wangziyang.mes.workflow.request.WorkflowPageReq;
import com.wangziyang.mes.workflow.request.WorkflowTaskCompleteReq;
import com.wangziyang.mes.workflow.service.ISpWorkflowFormService;
import com.wangziyang.mes.workflow.service.ISpWorkflowTaskService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workflow/task")
public class SpWorkflowTaskController extends WorkflowBaseController {

    @Autowired
    private ISpWorkflowTaskService taskService;

    @Autowired
    private ISpWorkflowFormService formService;

    @Autowired
    private ISysUserService userService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "workflow/task/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(WorkflowPageReq req) {
        QueryWrapper<SpWorkflowTask> qw = buildQuery(req);
        if (StringUtils.isNotBlank(req.getStatus())) {
            qw.eq("status", req.getStatus());
        }
        qw.orderByDesc("start_time").orderByDesc("update_time");
        IPage<SpWorkflowTask> page = taskService.page(req, qw);
        formService.fillTaskFormMeta(page.getRecords(), currentUser());
        return Result.success(page);
    }

    @GetMapping("/summary")
    @ResponseBody
    public Result summary(WorkflowPageReq req) {
        Map<String, Object> data = new HashMap<>();
        data.put("total", countByStatus(req, null));
        data.put("todo", countByStatus(req, WorkflowConstants.TASK_TODO));
        data.put("done", countByStatus(req, WorkflowConstants.TASK_DONE));
        data.put("rejected", countByStatus(req, WorkflowConstants.TASK_REJECTED));
        data.put("revoked", countByStatus(req, WorkflowConstants.TASK_REVOKED));
        data.put("overdue", taskService.count(buildQuery(req)
                .eq("status", WorkflowConstants.TASK_TODO)
                .le("start_time", LocalDateTime.now().minusHours(24)
                        .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))));
        return Result.success(data);
    }

    @PostMapping("/complete")
    @ResponseBody
    public Result complete(@RequestBody WorkflowTaskCompleteReq req) {
        SysUser user = currentUser();
        return taskService.complete(req.getTaskId(), req.getOpinion(), user);
    }

    @PostMapping("/reject")
    @ResponseBody
    public Result reject(@RequestBody WorkflowTaskCompleteReq req) {
        SysUser user = currentUser();
        return taskService.reject(req.getTaskId(), req.getOpinion(), user);
    }

    @PostMapping("/transfer")
    @ResponseBody
    public Result transfer(@RequestBody WorkflowTaskCompleteReq req) {
        return taskService.transfer(req.getTaskId(), resolveTargetUserId(req), req.getOpinion(), currentUser());
    }

    @PostMapping("/entrust")
    @ResponseBody
    public Result entrust(@RequestBody WorkflowTaskCompleteReq req) {
        return taskService.entrust(req.getTaskId(), resolveTargetUserId(req), req.getOpinion(), currentUser());
    }

    /**
     * 解析转办/委托的目标用户：优先用 targetUserId，否则按 targetUsername 反查。
     * 查不到时返回空，交给 service 统一报「目标处理人不存在/请选择目标处理人」。
     */
    private String resolveTargetUserId(WorkflowTaskCompleteReq req) {
        if (req == null) {
            return null;
        }
        if (StringUtils.isNotBlank(req.getTargetUserId())) {
            return req.getTargetUserId();
        }
        if (StringUtils.isNotBlank(req.getTargetUsername())) {
            SysUser target = userService.getOne(new QueryWrapper<SysUser>()
                    .eq("username", req.getTargetUsername().trim())
                    .last("limit 1"));
            if (target != null) {
                return target.getId();
            }
        }
        return req.getTargetUserId();
    }

    @PostMapping("/revoke")
    @ResponseBody
    public Result revoke(@RequestBody WorkflowTaskCompleteReq req) {
        return taskService.revoke(req.getTaskId(), req.getOpinion(), currentUser(), currentUserIsAdmin());
    }

    private void applyMineFilter(QueryWrapper<SpWorkflowTask> qw) {
        if (currentUserIsAdmin()) {
            return;
        }
        SysUser user = currentUser();
        List<String> roleCodes = currentRoleCodes();
        qw.and(w -> {
            if (user != null) {
                w.eq("assignee_type", WorkflowConstants.ASSIGNEE_USER).eq("assignee_id", user.getId());
            } else {
                w.eq("assignee_type", WorkflowConstants.ASSIGNEE_USER).eq("assignee_id", "__none__");
            }
            if (!roleCodes.isEmpty()) {
                w.or().eq("assignee_type", WorkflowConstants.ASSIGNEE_ROLE).in("assignee_id", roleCodes);
            }
        });
    }

    private int countByStatus(WorkflowPageReq req, String status) {
        QueryWrapper<SpWorkflowTask> qw = buildQuery(req);
        if (StringUtils.isNotBlank(status)) {
            qw.eq("status", status);
        }
        return taskService.count(qw);
    }

    private QueryWrapper<SpWorkflowTask> buildQuery(WorkflowPageReq req) {
        QueryWrapper<SpWorkflowTask> qw = new QueryWrapper<>();
        if (req != null) {
            if (StringUtils.isNotBlank(req.getKeyword())) {
                qw.and(w -> w.like("task_name", req.getKeyword()).or().like("business_code", req.getKeyword())
                        .or().like("node_name", req.getKeyword()));
            }
            if (StringUtils.isNotBlank(req.getBusinessType())) {
                qw.eq("business_type", req.getBusinessType());
            }
        }
        applyMineFilter(qw);
        return qw;
    }
}
