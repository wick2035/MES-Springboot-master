package com.wangziyang.mes.productionorder.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequest;
import com.wangziyang.mes.productionorder.request.SpMaterialInboundRequestReq;

/**
 * Material inbound request service.
 */
public interface ISpMaterialInboundRequestService extends IService<SpMaterialInboundRequest> {

    IPage<SpMaterialInboundRequest> pageList(SpMaterialInboundRequestReq req);
}
