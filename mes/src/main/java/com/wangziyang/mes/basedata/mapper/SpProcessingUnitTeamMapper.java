package com.wangziyang.mes.basedata.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wangziyang.mes.basedata.entity.SpProcessingUnitTeam;
import org.apache.ibatis.annotations.Param;

public interface SpProcessingUnitTeamMapper extends BaseMapper<SpProcessingUnitTeam> {

    /**
     * 按加工单元分页查询已绑定班组，联表回显班组代码 / 名称
     *
     * @param page   分页对象
     * @param unitId 加工单元ID
     * @return 绑定班组分页
     */
    IPage<SpProcessingUnitTeam> pageByUnit(IPage<SpProcessingUnitTeam> page, @Param("unitId") String unitId);
}
