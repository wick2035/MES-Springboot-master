package com.wangziyang.mes.workflow;

public final class WorkflowConstants {

    private WorkflowConstants() {
    }

    public static final String BUSINESS_ORDER_APPROVAL = "ORDER_APPROVAL";
    public static final String BUSINESS_WORK_ORDER_CHANGE = "WORK_ORDER_CHANGE";
    public static final String DEFAULT_CATEGORY_CODE = "prod";
    public static final String DEFAULT_MODEL_CODE = "order_approval";
    public static final String DEFAULT_DEFINITION_CODE = "order_approval";
    public static final String WORK_ORDER_CHANGE_MODEL_CODE = "work_order_change";
    public static final String WORK_ORDER_CHANGE_DEFINITION_CODE = "work_order_change";

    public static final String STATUS_NORMAL = "0";
    public static final String STATUS_DISABLED = "2";

    public static final String DEFINITION_ACTIVE = "active";
    public static final String DEFINITION_INACTIVE = "inactive";

    public static final String INSTANCE_RUNNING = "running";
    public static final String INSTANCE_COMPLETED = "completed";
    public static final String INSTANCE_REJECTED = "rejected";
    public static final String INSTANCE_REVOKED = "revoked";

    public static final String TASK_TODO = "todo";
    public static final String TASK_DONE = "done";
    public static final String TASK_REJECTED = "rejected";
    public static final String TASK_REVOKED = "revoked";

    public static final String NODE_START = "start";
    public static final String NODE_APPROVAL = "approval";
    public static final String NODE_END = "end";

    public static final String ASSIGNEE_USER = "user";
    public static final String ASSIGNEE_ROLE = "role";
    public static final String ASSIGNEE_INITIATOR = "initiator";

    public static final String ACTION_ORDER_APPROVE = "ORDER_APPROVE";
    public static final String ACTION_WORK_ORDER_CHANGE_APPLY = "WORK_ORDER_CHANGE_APPLY";
    public static final String EVENT_COMPLETE = "complete";

    public static final String ROLE_ADMIN = "admin";
    public static final String ROLE_SUPER_ADMIN = "888888";
    public static final String ROLE_PRODUCTION_MANAGER = "productionManagerRole";
    public static final String ROLE_WAREHOUSE_MANAGER = "warehouseManagerRole";
}
