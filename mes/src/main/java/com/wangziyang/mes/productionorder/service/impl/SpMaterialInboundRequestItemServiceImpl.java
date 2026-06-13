package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequestItem;
import com.wangziyang.mes.productionorder.mapper.SpMaterialInboundRequestItemMapper;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestItemService;
import org.springframework.stereotype.Service;

/**
 * Material inbound request item service implementation.
 */
@Service
public class SpMaterialInboundRequestItemServiceImpl
        extends ServiceImpl<SpMaterialInboundRequestItemMapper, SpMaterialInboundRequestItem>
        implements ISpMaterialInboundRequestItemService {
}
