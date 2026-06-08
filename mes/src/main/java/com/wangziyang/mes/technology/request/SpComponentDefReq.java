package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * Component definition page request.
 */
public class SpComponentDefReq extends BasePageReq {

    private String productNameLike;
    private String componentCodeLike;
    private String componentNameLike;
    private String componentType;
    private String deleted;

    public String getProductNameLike() {
        return productNameLike;
    }

    public void setProductNameLike(String productNameLike) {
        this.productNameLike = productNameLike;
    }

    public String getComponentCodeLike() {
        return componentCodeLike;
    }

    public void setComponentCodeLike(String componentCodeLike) {
        this.componentCodeLike = componentCodeLike;
    }

    public String getComponentNameLike() {
        return componentNameLike;
    }

    public void setComponentNameLike(String componentNameLike) {
        this.componentNameLike = componentNameLike;
    }

    public String getComponentType() {
        return componentType;
    }

    public void setComponentType(String componentType) {
        this.componentType = componentType;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
