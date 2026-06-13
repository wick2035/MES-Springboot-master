package com.wangziyang.mes.workflow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workflow/handle")
public class SpWorkflowHandleController extends WorkflowBaseController {

    @GetMapping("/list-ui")
    public String listUI() {
        return "workflow/handle/list";
    }
}
