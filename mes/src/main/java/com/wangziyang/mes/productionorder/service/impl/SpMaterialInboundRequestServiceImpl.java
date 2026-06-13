package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequest;
import com.wangziyang.mes.productionorder.mapper.SpMaterialInboundRequestMapper;
import com.wangziyang.mes.productionorder.request.SpMaterialInboundRequestReq;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestService;
import org.springframework.stereotype.Service;

/**
 * Material inbound request service implementation.
 */
@Service
public class SpMaterialInboundRequestServiceImpl
        extends ServiceImpl<SpMaterialInboundRequestMapper, SpMaterialInboundRequest>
        implements ISpMaterialInboundRequestService {

    @Override
    public IPage<SpMaterialInboundRequest> pageList(SpMaterialInboundRequestReq req) {
        if (req == null) {
            req = new SpMaterialInboundRequestReq();
        }
        return baseMapper.pageList(new Page<SpMaterialInboundRequest>(req.getCurrent(), req.getSize()), req);
    }
}
