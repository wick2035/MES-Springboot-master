package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpEquipmentReq extends BasePageReq {
    private String equipmentCodeLike;
    private String equipmentNameLike;
    private String purposeLike;

    public String getEquipmentCodeLike() { return equipmentCodeLike; }
    public void setEquipmentCodeLike(String equipmentCodeLike) { this.equipmentCodeLike = equipmentCodeLike; }

    public String getEquipmentNameLike() { return equipmentNameLike; }
    public void setEquipmentNameLike(String equipmentNameLike) { this.equipmentNameLike = equipmentNameLike; }

    public String getPurposeLike() { return purposeLike; }
    public void setPurposeLike(String purposeLike) { this.purposeLike = purposeLike; }
}
