package com.wangziyang.mes.productionorder.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * Material requirement plan query request.
 */
public class SpMaterialRequirementPlanReq extends BasePageReq {

    private String productionOrderNoLike;

    private String productLike;

    private String materialLike;

    private String deliveryStatus;

    private String inboundStatus;

    private String outboundStatus;

    private String requirementDateBegin;

    private String requirementDateEnd;

    private String materialSource;

    public String getProductionOrderNoLike() { return productionOrderNoLike; }
    public void setProductionOrderNoLike(String productionOrderNoLike) { this.productionOrderNoLike = productionOrderNoLike; }

    public String getProductLike() { return productLike; }
    public void setProductLike(String productLike) { this.productLike = productLike; }

    public String getMaterialLike() { return materialLike; }
    public void setMaterialLike(String materialLike) { this.materialLike = materialLike; }

    public String getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(String deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public String getInboundStatus() { return inboundStatus; }
    public void setInboundStatus(String inboundStatus) { this.inboundStatus = inboundStatus; }

    public String getOutboundStatus() { return outboundStatus; }
    public void setOutboundStatus(String outboundStatus) { this.outboundStatus = outboundStatus; }

    public String getRequirementDateBegin() { return requirementDateBegin; }
    public void setRequirementDateBegin(String requirementDateBegin) { this.requirementDateBegin = requirementDateBegin; }

    public String getRequirementDateEnd() { return requirementDateEnd; }
    public void setRequirementDateEnd(String requirementDateEnd) { this.requirementDateEnd = requirementDateEnd; }

    public String getMaterialSource() { return materialSource; }
    public void setMaterialSource(String materialSource) { this.materialSource = materialSource; }
}
