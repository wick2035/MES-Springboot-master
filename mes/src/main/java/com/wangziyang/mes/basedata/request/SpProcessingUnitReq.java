package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpProcessingUnitReq extends BasePageReq {
    private String unitCodeLike;
    private String unitNameLike;
    private String unitType;

    public String getUnitCodeLike() { return unitCodeLike; }
    public void setUnitCodeLike(String unitCodeLike) { this.unitCodeLike = unitCodeLike; }

    public String getUnitNameLike() { return unitNameLike; }
    public void setUnitNameLike(String unitNameLike) { this.unitNameLike = unitNameLike; }

    public String getUnitType() { return unitType; }
    public void setUnitType(String unitType) { this.unitType = unitType; }
}
