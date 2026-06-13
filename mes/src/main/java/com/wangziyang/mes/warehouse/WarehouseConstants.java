package com.wangziyang.mes.warehouse;

public final class WarehouseConstants {

    private WarehouseConstants() {
    }

    public static final String BUSINESS_MANUAL_IN = "MANUAL_IN";
    public static final String BUSINESS_PLAN_IN = "PLAN_IN";
    public static final String BUSINESS_MANUAL_OUT = "MANUAL_OUT";
    public static final String BUSINESS_KITTING_OUT = "KITTING_OUT";

    public static final String DIRECTION_IN = "IN";
    public static final String DIRECTION_OUT = "OUT";

    public static final String STATUS_WAIT_CONFIRM = "WAIT_CONFIRM";
    public static final String STATUS_CONFIRMED = "CONFIRMED";

    public static final String STOCK_AVAILABLE = "AVAILABLE";

    public static final String SOURCE_MANUAL = "MANUAL";
    public static final String SOURCE_PLAN_INBOUND = "PLAN_INBOUND";
    public static final String SOURCE_MRP = "MRP";
}
