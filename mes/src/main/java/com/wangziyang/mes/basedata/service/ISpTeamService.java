package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpTeam;

public interface ISpTeamService extends IService<SpTeam> {

    /**
     * 班组代码是否已存在（仅统计未删除记录，排除自身）
     *
     * @param teamCode  班组代码
     * @param excludeId 编辑时排除的自身ID，可为空
     * @return true 已存在
     */
    boolean isTeamCodeDuplicate(String teamCode, String excludeId);
}
