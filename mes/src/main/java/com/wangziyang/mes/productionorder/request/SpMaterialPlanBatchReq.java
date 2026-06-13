package com.wangziyang.mes.productionorder.request;

import java.util.ArrayList;
import java.util.List;

/**
 * Batch request for selected material plan lines.
 */
public class SpMaterialPlanBatchReq {

    private List<String> ids = new ArrayList<>();

    public List<String> getIds() { return ids; }
    public void setIds(List<String> ids) { this.ids = ids; }
}
