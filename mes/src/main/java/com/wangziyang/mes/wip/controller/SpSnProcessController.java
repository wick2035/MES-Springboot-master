package com.wangziyang.mes.wip.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.request.SpSnProcessRecordReq;
import com.wangziyang.mes.wip.request.SpSnScanReq;
import com.wangziyang.mes.wip.service.ISpSnProcessRecordService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/wip/sn-process")
public class SpSnProcessController extends BaseController {

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpSnProcessRecordService recordService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "wip/sn-process/list";
    }

    @GetMapping("/orders")
    @ResponseBody
    public Result orders() {
        QueryWrapper<SpOrder> qw = new QueryWrapper<>();
        qw.ne("statue", 4).isNotNull("flow_id").ne("flow_id", "").orderByDesc("update_time").last("limit 200");
        return Result.success(orderService.list(qw));
    }

    @GetMapping("/route")
    @ResponseBody
    public Result route(String orderId, String sn) {
        return Result.success(recordService.routeStatus(orderId, sn));
    }

    @PostMapping("/scan")
    @ResponseBody
    public Result scan(SpSnScanReq req) {
        return recordService.scan(req);
    }

    @PostMapping("/records")
    @ResponseBody
    public Result records(SpSnProcessRecordReq req) {
        QueryWrapper<SpSnProcessRecord> qw = new QueryWrapper<>();
        if (StringUtils.isNotBlank(req.getSnLike())) {
            qw.like("sn", req.getSnLike());
        }
        if (StringUtils.isNotBlank(req.getOrderId())) {
            qw.eq("order_id", req.getOrderId());
        }
        if (StringUtils.isNotBlank(req.getOrderCodeLike())) {
            qw.like("order_code", req.getOrderCodeLike());
        }
        if (StringUtils.isNotBlank(req.getStatus())) {
            qw.eq("status", req.getStatus());
        }
        qw.orderByDesc("create_time");
        IPage<SpSnProcessRecord> result = recordService.page(req, qw);
        return Result.success(result);
    }
}
