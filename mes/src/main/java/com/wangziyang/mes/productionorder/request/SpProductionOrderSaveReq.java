package com.wangziyang.mes.productionorder.request;

import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;

import java.util.ArrayList;
import java.util.List;

/**
 * Production order save request.
 */
public class SpProductionOrderSaveReq {

    private SpProductionOrder order;

    private List<SpProductionOrderItem> items = new ArrayList<>();

    public SpProductionOrder getOrder() {
        return order;
    }

    public void setOrder(SpProductionOrder order) {
        this.order = order;
    }

    public List<SpProductionOrderItem> getItems() {
        return items;
    }

    public void setItems(List<SpProductionOrderItem> items) {
        this.items = items;
    }
}
