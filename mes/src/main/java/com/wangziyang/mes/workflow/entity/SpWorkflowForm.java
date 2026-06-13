package com.wangziyang.mes.workflow.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName("sp_workflow_form")
public class SpWorkflowForm extends BaseEntity {

    private String formName;
    private String formKey;
    private String businessType;
    private String definitionCode;
    private String formType;
    private String pcFormUrl;
    private String mobileFormUrl;
    private String titleTemplate;
    private String eventTemplate;
    private Integer skipFirstNode;
    private Integer skipSameHandler;
    private Integer allowReturn;
    private Integer allowTransfer;
    private Integer allowEntrust;
    private Integer allowRevoke;
    private String status;
    private Integer sortNum;
    private String remark;

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public String getFormKey() {
        return formKey;
    }

    public void setFormKey(String formKey) {
        this.formKey = formKey;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getDefinitionCode() {
        return definitionCode;
    }

    public void setDefinitionCode(String definitionCode) {
        this.definitionCode = definitionCode;
    }

    public String getFormType() {
        return formType;
    }

    public void setFormType(String formType) {
        this.formType = formType;
    }

    public String getPcFormUrl() {
        return pcFormUrl;
    }

    public void setPcFormUrl(String pcFormUrl) {
        this.pcFormUrl = pcFormUrl;
    }

    public String getMobileFormUrl() {
        return mobileFormUrl;
    }

    public void setMobileFormUrl(String mobileFormUrl) {
        this.mobileFormUrl = mobileFormUrl;
    }

    public String getTitleTemplate() {
        return titleTemplate;
    }

    public void setTitleTemplate(String titleTemplate) {
        this.titleTemplate = titleTemplate;
    }

    public String getEventTemplate() {
        return eventTemplate;
    }

    public void setEventTemplate(String eventTemplate) {
        this.eventTemplate = eventTemplate;
    }

    public Integer getSkipFirstNode() {
        return skipFirstNode;
    }

    public void setSkipFirstNode(Integer skipFirstNode) {
        this.skipFirstNode = skipFirstNode;
    }

    public Integer getSkipSameHandler() {
        return skipSameHandler;
    }

    public void setSkipSameHandler(Integer skipSameHandler) {
        this.skipSameHandler = skipSameHandler;
    }

    public Integer getAllowReturn() {
        return allowReturn;
    }

    public void setAllowReturn(Integer allowReturn) {
        this.allowReturn = allowReturn;
    }

    public Integer getAllowTransfer() {
        return allowTransfer;
    }

    public void setAllowTransfer(Integer allowTransfer) {
        this.allowTransfer = allowTransfer;
    }

    public Integer getAllowEntrust() {
        return allowEntrust;
    }

    public void setAllowEntrust(Integer allowEntrust) {
        this.allowEntrust = allowEntrust;
    }

    public Integer getAllowRevoke() {
        return allowRevoke;
    }

    public void setAllowRevoke(Integer allowRevoke) {
        this.allowRevoke = allowRevoke;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getSortNum() {
        return sortNum;
    }

    public void setSortNum(Integer sortNum) {
        this.sortNum = sortNum;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}
