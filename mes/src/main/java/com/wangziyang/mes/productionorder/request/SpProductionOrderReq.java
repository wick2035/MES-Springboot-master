package com.wangziyang.mes.productionorder.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * Production order page query request.
 */
public class SpProductionOrderReq extends BasePageReq {

    private String orderNoLike;

    private String sourceType;

    private String customerNameLike;

    private String productLike;

    private String status;

    private String keyword;

    private String approvalStatus;

    private String operationStatus;

    public String getOrderNoLike() {
        return orderNoLike;
    }

    public void setOrderNoLike(String orderNoLike) {
        this.orderNoLike = orderNoLike;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public String getCustomerNameLike() {
        return customerNameLike;
    }

    public void setCustomerNameLike(String customerNameLike) {
        this.customerNameLike = customerNameLike;
    }

    public String getProductLike() {
        return productLike;
    }

    public void setProductLike(String productLike) {
        this.productLike = productLike;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public String getOperationStatus() {
        return operationStatus;
    }

    public void setOperationStatus(String operationStatus) {
        this.operationStatus = operationStatus;
    }
}
