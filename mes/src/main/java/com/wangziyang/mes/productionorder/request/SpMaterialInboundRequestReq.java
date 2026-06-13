package com.wangziyang.mes.productionorder.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * Material inbound request query.
 */
public class SpMaterialInboundRequestReq extends BasePageReq {

    private String requestNoLike;

    private String productionOrderNoLike;

    private String status;

    public String getRequestNoLike() { return requestNoLike; }
    public void setRequestNoLike(String requestNoLike) { this.requestNoLike = requestNoLike; }

    public String getProductionOrderNoLike() { return productionOrderNoLike; }
    public void setProductionOrderNoLike(String productionOrderNoLike) { this.productionOrderNoLike = productionOrderNoLike; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
