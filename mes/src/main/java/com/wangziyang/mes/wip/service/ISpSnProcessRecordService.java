package com.wangziyang.mes.wip.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpFlowOperRelation;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.request.SpSnScanReq;

import java.util.List;
import java.util.Map;

public interface ISpSnProcessRecordService extends IService<SpSnProcessRecord> {

    Result scan(SpSnScanReq req);

    List<Map<String, Object>> routeStatus(String orderId, String sn);

    List<SpFlowOperRelation> route(String orderId);
}
