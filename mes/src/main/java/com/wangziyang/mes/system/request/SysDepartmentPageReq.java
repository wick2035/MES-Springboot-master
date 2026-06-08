package com.wangziyang.mes.system.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 系统部门分页查询参数
 *
 * @author SongPeng
 * @since 2019-10-15
 */
public class SysDepartmentPageReq extends BasePageReq {

    private String nameLike;

    public String getNameLike() {
        return nameLike;
    }

    public void setNameLike(String nameLike) {
        this.nameLike = nameLike;
    }
}