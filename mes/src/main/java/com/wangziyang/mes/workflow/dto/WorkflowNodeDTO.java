package com.wangziyang.mes.workflow.dto;

import java.util.ArrayList;
import java.util.List;

public class WorkflowNodeDTO {

    private String nodeKey;
    private String nodeName;
    private String nodeType;
    private String assigneeType;
    private String assigneeId;
    private String assigneeName;
    private List<WorkflowNodeEventDTO> events = new ArrayList<>();

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

    public String getNodeType() {
        return nodeType;
    }

    public void setNodeType(String nodeType) {
        this.nodeType = nodeType;
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

    public List<WorkflowNodeEventDTO> getEvents() {
        return events;
    }

    public void setEvents(List<WorkflowNodeEventDTO> events) {
        this.events = events;
    }
}
