package com.wangziyang.mes.productionorder.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequest;
import com.wangziyang.mes.productionorder.request.SpMaterialInboundRequestReq;
import org.apache.ibatis.annotations.Param;

/**
 * Material inbound request mapper.
 */
public interface SpMaterialInboundRequestMapper extends BaseMapper<SpMaterialInboundRequest> {

    IPage<SpMaterialInboundRequest> pageList(IPage<SpMaterialInboundRequest> page,
                                             @Param("req") SpMaterialInboundRequestReq req);
}
