package com.wangziyang.mes.productionorder.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * Shared query request for dispatch and assignment pages.
 */
public class SpProductionDispatchReq extends BasePageReq {

    private String orderNoLike;

    private String productLike;

    private String operLike;

    private String equipmentStatus;

    private String assignStatus;

    public String getOrderNoLike() { return orderNoLike; }
    public void setOrderNoLike(String orderNoLike) { this.orderNoLike = orderNoLike; }

    public String getProductLike() { return productLike; }
    public void setProductLike(String productLike) { this.productLike = productLike; }

    public String getOperLike() { return operLike; }
    public void setOperLike(String operLike) { this.operLike = operLike; }

    public String getEquipmentStatus() { return equipmentStatus; }
    public void setEquipmentStatus(String equipmentStatus) { this.equipmentStatus = equipmentStatus; }

    public String getAssignStatus() { return assignStatus; }
    public void setAssignStatus(String assignStatus) { this.assignStatus = assignStatus; }
}
