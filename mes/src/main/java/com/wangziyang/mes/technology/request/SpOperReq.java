package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 工序分页对象
 *
 * @author wangziyang
 * @since 2020/03/15
 */
public class SpOperReq extends BasePageReq {

    private String operLike;
    private String operDescLike;
    private String unitId;

    public String getOperLike() { return operLike; }
    public void setOperLike(String operLike) { this.operLike = operLike; }

    public String getOperDescLike() { return operDescLike; }
    public void setOperDescLike(String operDescLike) { this.operDescLike = operDescLike; }

    public String getUnitId() { return unitId; }
    public void setUnitId(String unitId) { this.unitId = unitId; }
}
