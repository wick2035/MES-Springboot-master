package com.wangziyang.mes.workflow.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

@TableName("sp_workflow_task")
public class SpWorkflowTask extends BaseEntity {

    private String instanceId;
    private String definitionId;
    private String businessType;
    private String businessId;
    private String businessCode;
    private String taskName;
    private String nodeKey;
    private String nodeName;
    private String assigneeType;
    private String assigneeId;
    private String assigneeName;
    private String status;
    private String action;
    private String opinion;
    private String startTime;
    private String completeTime;
    @TableField(exist = false)
    private String formName;
    @TableField(exist = false)
    private String formTitle;
    @TableField(exist = false)
    private String pcFormUrl;
    @TableField(exist = false)
    private String mobileFormUrl;
    @TableField(exist = false)
    private Integer allowReturn;
    @TableField(exist = false)
    private Integer allowTransfer;
    @TableField(exist = false)
    private Integer allowEntrust;
    @TableField(exist = false)
    private Integer allowRevoke;

    public String getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(String instanceId) {
        this.instanceId = instanceId;
    }

    public String getDefinitionId() {
        return definitionId;
    }

    public void setDefinitionId(String definitionId) {
        this.definitionId = definitionId;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getBusinessId() {
        return businessId;
    }

    public void setBusinessId(String businessId) {
        this.businessId = businessId;
    }

    public String getBusinessCode() {
        return businessCode;
    }

    public void setBusinessCode(String businessCode) {
        this.businessCode = businessCode;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getNodeKey() {
        return nodeKey;
    }

    public void setNodeKey(String nodeKey) {
        this.nodeKey = nodeKey;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    public String getAssigneeType() {
        return assigneeType;
    }

    public void setAssigneeType(String assigneeType) {
        this.assigneeType = assigneeType;
    }

    public String getAssigneeId() {
        return assigneeId;
    }

    public void setAssigneeId(String assigneeId) {
        this.assigneeId = assigneeId;
    }

    public String getAssigneeName() {
        return assigneeName;
    }

    public void setAssigneeName(String assigneeName) {
        this.assigneeName = assigneeName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getOpinion() {
        return opinion;
    }

    public void setOpinion(String opinion) {
        this.opinion = opinion;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getCompleteTime() {
        return completeTime;
    }

    public void setCompleteTime(String completeTime) {
        this.completeTime = completeTime;
    }

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public String getFormTitle() {
        return formTitle;
    }

    public void setFormTitle(String formTitle) {
        this.formTitle = formTitle;
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
}
