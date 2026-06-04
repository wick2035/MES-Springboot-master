package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 班组分页查询参数
 *
 * @author Claude
 * @since 2026-06-04
 */
public class SpTeamReq extends BasePageReq {

    private String teamCodeLike;
    private String teamNameLike;

    public String getTeamCodeLike() { return teamCodeLike; }
    public void setTeamCodeLike(String teamCodeLike) { this.teamCodeLike = teamCodeLike; }

    public String getTeamNameLike() { return teamNameLike; }
    public void setTeamNameLike(String teamNameLike) { this.teamNameLike = teamNameLike; }
}
