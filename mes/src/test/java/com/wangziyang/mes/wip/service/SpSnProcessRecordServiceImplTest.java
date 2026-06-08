package com.wangziyang.mes.wip.service;

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
import com.wangziyang.mes.wip.service.impl.SpSnProcessRecordServiceImpl;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Arrays;
import java.util.Collections;

import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class SpSnProcessRecordServiceImplTest {

    private SpSnProcessRecordServiceImpl service;
    private SpSnProcessRecordMapper recordMapper;
    private ISpOrderService orderService;
    private ISpOperService operService;
    private SpFlowOperRelationMapper relationMapper;

    @Before
    public void setUp() {
        service = new SpSnProcessRecordServiceImpl();
        recordMapper = mock(SpSnProcessRecordMapper.class);
        orderService = mock(ISpOrderService.class);
        operService = mock(ISpOperService.class);
        relationMapper = mock(SpFlowOperRelationMapper.class);

        ReflectionTestUtils.setField(service, "baseMapper", recordMapper);
        ReflectionTestUtils.setField(service, "orderService", orderService);
        ReflectionTestUtils.setField(service, "operService", operService);
        ReflectionTestUtils.setField(service, "flowOperRelationMapper", relationMapper);

        SpOrder order = new SpOrder();
        order.setId("order-1");
        order.setOrderCode("WO001");
        order.setFlowId("flow-1");
        when(orderService.getById("order-1")).thenReturn(order);
        when(relationMapper.selectList(any())).thenReturn(Arrays.asList(relation("op-1", "GX001", 1), relation("op-2", "GX002", 2)));
        when(operService.getById("op-1")).thenReturn(oper("Assemble"));
        when(operService.getById("op-2")).thenReturn(oper("Test"));
        when(recordMapper.selectList(any())).thenReturn(Collections.emptyList());
        when(recordMapper.selectCount(any())).thenReturn(0);
        when(recordMapper.insert(any())).thenReturn(1);
    }

    @Test
    public void scanOkCreatesRecordAndAdvancesToNextOperation() {
        Result result = service.scan(scanReq("SN001", "OK"));

        assertEquals(0, result.get("code"));
        ArgumentCaptor<SpSnProcessRecord> captor = ArgumentCaptor.forClass(SpSnProcessRecord.class);
        verify(recordMapper).insert(captor.capture());
        assertEquals("SN001", captor.getValue().getSn());
        assertEquals("op-1", captor.getValue().getOperId());
        assertEquals("OK", captor.getValue().getStatus());
    }

    @Test
    public void scanNgRecordsCurrentOperationButDoesNotCompleteIt() {
        Result result = service.scan(scanReq("SN002", "NG"));

        assertEquals(0, result.get("code"));
        ArgumentCaptor<SpSnProcessRecord> captor = ArgumentCaptor.forClass(SpSnProcessRecord.class);
        verify(recordMapper).insert(captor.capture());
        assertEquals("op-1", captor.getValue().getOperId());
        assertEquals("NG", captor.getValue().getStatus());
    }

    @Test
    public void scanFailsWhenAllOperationsAlreadyCompleted() {
        SpSnProcessRecord first = new SpSnProcessRecord();
        first.setOperId("op-1");
        SpSnProcessRecord second = new SpSnProcessRecord();
        second.setOperId("op-2");
        when(recordMapper.selectList(any())).thenReturn(Arrays.asList(first, second));

        Result result = service.scan(scanReq("SN003", "OK"));

        assertEquals(1, result.get("code"));
        verify(recordMapper, never()).insert(any());
    }

    private SpSnScanReq scanReq(String sn, String status) {
        SpSnScanReq req = new SpSnScanReq();
        req.setOrderId("order-1");
        req.setSn(sn);
        req.setStatus(status);
        return req;
    }

    private SpFlowOperRelation relation(String operId, String oper, int sortNum) {
        SpFlowOperRelation relation = new SpFlowOperRelation();
        relation.setFlowId("flow-1");
        relation.setOperId(operId);
        relation.setOper(oper);
        relation.setSortNum(sortNum);
        return relation;
    }

    private SpOper oper(String desc) {
        SpOper oper = new SpOper();
        oper.setOperDesc(desc);
        return oper;
    }
}
