package com.wangziyang.mes.order.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.request.SpOrderReq;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderItemService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Delivered work order history.
 */
@Controller
@RequestMapping("/order/delivered")
public class SpDeliveredOrderController extends BaseController {

    private static final String COMPLETE_STATUS_COMPLETED = "COMPLETED";

    private static final String DELIVERY_STATUS_DELIVERED = "DELIVERED";

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpProductionOrderItemService productionOrderItemService;

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "/order/delivered/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = buildQuery(req);
        queryWrapper.eq("delivery_status", DELIVERY_STATUS_DELIVERED).orderByDesc("delivery_time");
        IPage<SpOrder> result = orderService.page(req, queryWrapper);
        enrichOrders(result.getRecords());
        return Result.success(result);
    }

    private QueryWrapper<SpOrder> buildQuery(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = new QueryWrapper<>();
        if (req == null) {
            return queryWrapper;
        }
        if (StringUtils.isNotEmpty(req.getOrderCodeLike())) {
            queryWrapper.like("order_code", req.getOrderCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getOrderDescriptionLike())) {
            queryWrapper.like("order_description", req.getOrderDescriptionLike());
        }
        if (StringUtils.isNotEmpty(req.getMaterielLike())) {
            queryWrapper.like("materiel", req.getMaterielLike());
        }
        if (StringUtils.isNotEmpty(req.getMaterielDescLike())) {
            queryWrapper.like("materiel_desc", req.getMaterielDescLike());
        }
        if (req.getStatue() != null) {
            queryWrapper.eq("statue", req.getStatue());
        }
        if (StringUtils.isNotEmpty(req.getWorkStatus())) {
            queryWrapper.eq("work_status", req.getWorkStatus());
        }
        if (StringUtils.isNotEmpty(req.getCompleteStatus())) {
            queryWrapper.eq("complete_status", req.getCompleteStatus());
        }
        return queryWrapper;
    }

    private void enrichOrders(List<SpOrder> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }
        for (SpOrder order : orders) {
            order.setCompleteStatusName(COMPLETE_STATUS_COMPLETED.equals(order.getCompleteStatus()) ? "已完工" : "待完工");
            order.setDeliveryStatusName(DELIVERY_STATUS_DELIVERED.equals(order.getDeliveryStatus()) ? "已交付" : "待交付");
            order.setWorkStatusName("STARTED".equals(order.getWorkStatus()) ? "已动工" : "未动工");
            SpProductionOrderItem item = productionOrderItemService.getOne(new QueryWrapper<SpProductionOrderItem>()
                    .eq("work_order_id", order.getId())
                    .last("limit 1"), false);
            if (item == null) {
                order.setSourceOrderNo("异常/手工工单");
                continue;
            }
            order.setSourceOrderItemId(item.getId());
            order.setSourceBomCode(item.getBomCode());
            order.setSourceBomVersion(item.getBomVersion());
            SpProductionOrder productionOrder = productionOrderService.getById(item.getOrderId());
            if (productionOrder != null) {
                order.setSourceOrderNo(productionOrder.getOrderNo());
            }
        }
    }
}
