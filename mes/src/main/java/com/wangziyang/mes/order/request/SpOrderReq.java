package com.wangziyang.mes.order.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * Production order page query request.
 */
public class SpOrderReq extends BasePageReq {

    private String orderCodeLike;

    private String orderDescriptionLike;

    private String materielLike;

    private String materielDescLike;

    private Integer statue;

    private String workStatus;

    private String completeStatus;

    private String deliveryStatus;

    public String getOrderCodeLike() {
        return orderCodeLike;
    }

    public void setOrderCodeLike(String orderCodeLike) {
        this.orderCodeLike = orderCodeLike;
    }

    public String getOrderDescriptionLike() {
        return orderDescriptionLike;
    }

    public void setOrderDescriptionLike(String orderDescriptionLike) {
        this.orderDescriptionLike = orderDescriptionLike;
    }

    public String getMaterielLike() {
        return materielLike;
    }

    public void setMaterielLike(String materielLike) {
        this.materielLike = materielLike;
    }

    public String getMaterielDescLike() {
        return materielDescLike;
    }

    public void setMaterielDescLike(String materielDescLike) {
        this.materielDescLike = materielDescLike;
    }

    public Integer getStatue() {
        return statue;
    }

    public void setStatue(Integer statue) {
        this.statue = statue;
    }

    public String getWorkStatus() {
        return workStatus;
    }

    public void setWorkStatus(String workStatus) {
        this.workStatus = workStatus;
    }

    public String getCompleteStatus() {
        return completeStatus;
    }

    public void setCompleteStatus(String completeStatus) {
        this.completeStatus = completeStatus;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }
}
