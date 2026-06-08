package com.wangziyang.mes.wip.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.technology.entity.SpFlowOperRelation;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.mapper.SpFlowOperRelationMapper;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.mapper.SpSnProcessRecordMapper;
import com.wangziyang.mes.wip.request.SpSnScanReq;
import com.wangziyang.mes.wip.service.ISpSnProcessRecordService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class SpSnProcessRecordServiceImpl extends ServiceImpl<SpSnProcessRecordMapper, SpSnProcessRecord>
        implements ISpSnProcessRecordService {

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpOperService operService;

    @Autowired
    private SpFlowOperRelationMapper flowOperRelationMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result scan(SpSnScanReq req) {
        if (req == null || StringUtils.isBlank(req.getSn())) {
            return Result.failure("请输入 SN");
        }
        if (StringUtils.isBlank(req.getOrderId())) {
            return Result.failure("请选择工单");
        }
        String status = StringUtils.defaultIfBlank(req.getStatus(), "OK").toUpperCase(Locale.ENGLISH);
        if (!"OK".equals(status) && !"NG".equals(status)) {
            return Result.failure("采集结果只能是 OK 或 NG");
        }

        SpOrder order = orderService.getById(req.getOrderId());
        if (order == null) {
            return Result.failure("工单不存在");
        }
        if (StringUtils.isBlank(order.getFlowId())) {
            return Result.failure("工单未绑定工艺路线");
        }

        List<SpFlowOperRelation> route = routeByFlowId(order.getFlowId());
        if (route.isEmpty()) {
            return Result.failure("工单工艺路线没有配置工序");
        }

        String sn = req.getSn().trim();
        Set<String> completedOperIds = completedOperIds(order.getId(), sn);
        SpFlowOperRelation current = route.stream()
                .filter(r -> !completedOperIds.contains(r.getOperId()))
                .findFirst()
                .orElse(null);
        if (current == null) {
            return Result.failure("该 SN 已完成当前工单全部工序");
        }

        if ("OK".equals(status) && hasOkRecord(order.getId(), sn, current.getOperId())) {
            return Result.failure("该 SN 当前工序已采集 OK，不能重复过站");
        }

        SpSnProcessRecord record = new SpSnProcessRecord();
        record.setSn(sn);
        record.setOrderId(order.getId());
        record.setOrderCode(order.getOrderCode());
        record.setFlowId(order.getFlowId());
        record.setOperId(current.getOperId());
        record.setOper(current.getOper());
        record.setOperDesc(operDesc(current));
        record.setStepNo(current.getSortNum());
        record.setStatus(status);
        record.setRemark(StringUtils.trimToEmpty(req.getRemark()));
        save(record);

        if ("OK".equals(status)) {
            completedOperIds.add(current.getOperId());
        }
        SpFlowOperRelation next = route.stream()
                .filter(r -> !completedOperIds.contains(r.getOperId()))
                .findFirst()
                .orElse(null);

        Map<String, Object> data = new HashMap<>();
        data.put("record", record);
        data.put("complete", next == null);
        data.put("nextOper", next);
        data.put("route", routeStatus(order.getId(), sn));
        return Result.success(data, next == null ? "SN 已完成全部工序" : "采集成功");
    }

    @Override
    public List<Map<String, Object>> routeStatus(String orderId, String sn) {
        SpOrder order = orderService.getById(orderId);
        if (order == null || StringUtils.isBlank(order.getFlowId())) {
            return Collections.emptyList();
        }
        List<SpFlowOperRelation> route = routeByFlowId(order.getFlowId());
        Set<String> completedOperIds = StringUtils.isBlank(sn)
                ? Collections.emptySet()
                : completedOperIds(orderId, sn.trim());
        return route.stream().map(r -> {
            Map<String, Object> row = new HashMap<>();
            row.put("operId", r.getOperId());
            row.put("oper", r.getOper());
            row.put("operDesc", operDesc(r));
            row.put("stepNo", r.getSortNum());
            row.put("done", completedOperIds.contains(r.getOperId()));
            return row;
        }).collect(Collectors.toList());
    }

    @Override
    public List<SpFlowOperRelation> route(String orderId) {
        SpOrder order = orderService.getById(orderId);
        if (order == null || StringUtils.isBlank(order.getFlowId())) {
            return Collections.emptyList();
        }
        return routeByFlowId(order.getFlowId());
    }

    private List<SpFlowOperRelation> routeByFlowId(String flowId) {
        QueryWrapper<SpFlowOperRelation> qw = new QueryWrapper<>();
        qw.eq("flow_id", flowId).orderByAsc("sort_num");
        return flowOperRelationMapper.selectList(qw);
    }

    private Set<String> completedOperIds(String orderId, String sn) {
        QueryWrapper<SpSnProcessRecord> qw = new QueryWrapper<>();
        qw.eq("order_id", orderId).eq("sn", sn).eq("status", "OK");
        return list(qw).stream().map(SpSnProcessRecord::getOperId).collect(Collectors.toSet());
    }

    private boolean hasOkRecord(String orderId, String sn, String operId) {
        QueryWrapper<SpSnProcessRecord> qw = new QueryWrapper<>();
        qw.eq("order_id", orderId)
                .eq("sn", sn)
                .eq("oper_id", operId)
                .eq("status", "OK");
        return count(qw) > 0;
    }

    private String operDesc(SpFlowOperRelation relation) {
        if (relation == null || StringUtils.isBlank(relation.getOperId())) {
            return "";
        }
        SpOper oper = operService.getById(relation.getOperId());
        return oper == null ? relation.getOper() : oper.getOperDesc();
    }
}
