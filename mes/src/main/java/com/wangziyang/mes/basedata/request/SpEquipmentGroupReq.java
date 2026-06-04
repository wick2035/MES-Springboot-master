package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 设备编组分页查询参数
 *
 * @author Claude
 * @since 2026-06-04
 */
public class SpEquipmentGroupReq extends BasePageReq {

    private String groupCodeLike;
    private String groupNameLike;

    public String getGroupCodeLike() { return groupCodeLike; }
    public void setGroupCodeLike(String groupCodeLike) { this.groupCodeLike = groupCodeLike; }

    public String getGroupNameLike() { return groupNameLike; }
    public void setGroupNameLike(String groupNameLike) { this.groupNameLike = groupNameLike; }
}
