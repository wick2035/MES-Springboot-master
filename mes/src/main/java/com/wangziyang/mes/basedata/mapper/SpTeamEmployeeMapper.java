package com.wangziyang.mes.basedata.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wangziyang.mes.basedata.entity.SpTeamEmployee;
import org.apache.ibatis.annotations.Param;

public interface SpTeamEmployeeMapper extends BaseMapper<SpTeamEmployee> {

    /**
     * 按班组分页查询成员，联表回显用户姓名 / 用户名
     *
     * @param page   分页对象
     * @param teamId 班组ID
     * @return 成员分页
     */
    IPage<SpTeamEmployee> pageByTeam(IPage<SpTeamEmployee> page, @Param("teamId") String teamId);
}
