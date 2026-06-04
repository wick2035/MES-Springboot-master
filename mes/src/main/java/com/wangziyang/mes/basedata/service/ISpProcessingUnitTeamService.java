package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpProcessingUnitTeam;

import java.util.List;

public interface ISpProcessingUnitTeamService extends IService<SpProcessingUnitTeam> {

    /**
     * 按加工单元分页查询已绑定班组（联表回显班组代码/名称）
     */
    IPage<SpProcessingUnitTeam> pageByUnit(IPage<SpProcessingUnitTeam> page, String unitId);

    /**
     * 批量把班组绑定到加工单元，跳过该单元已存在（未删除）的班组，实现「同单元不重复」
     *
     * @param unitId  加工单元ID
     * @param teamIds 班组ID集合
     * @return 实际新增数量
     */
    int addTeams(String unitId, List<String> teamIds);
}
