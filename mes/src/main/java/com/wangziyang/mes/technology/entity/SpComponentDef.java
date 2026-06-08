package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * Product component definition.
 *
 * Components must be defined before a product BOM can use them.
 */
@TableName(value = "sp_component_def")
public class SpComponentDef extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** Product name typed by the user. */
    private String productName;

    /** Unique component code, for example BOM000001. */
    private String componentCode;

    /** Component name. */
    private String componentName;

    /** BOM item type: PG=semi-finished, COMP=component. */
    private String componentType;

    /** Remark. */
    private String remark;

    /** Status 0=normal, 1=deleted, 2=disabled. */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getComponentCode() {
        return componentCode;
    }

    public void setComponentCode(String componentCode) {
        this.componentCode = componentCode;
    }

    public String getComponentName() {
        return componentName;
    }

    public void setComponentName(String componentName) {
        this.componentName = componentName;
    }

    public String getComponentType() {
        return componentType;
    }

    public void setComponentType(String componentType) {
        this.componentType = componentType;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }
}
