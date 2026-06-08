package com.wangziyang.mes.wip.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpSnProcessRecordReq extends BasePageReq {

    private String snLike;

    private String orderId;

    private String orderCodeLike;

    private String status;

    public String getSnLike() {
        return snLike;
    }

    public void setSnLike(String snLike) {
        this.snLike = snLike;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderCodeLike() {
        return orderCodeLike;
    }

    public void setOrderCodeLike(String orderCodeLike) {
        this.orderCodeLike = orderCodeLike;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
