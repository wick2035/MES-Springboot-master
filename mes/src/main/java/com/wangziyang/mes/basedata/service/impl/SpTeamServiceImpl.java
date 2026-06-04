package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpTeam;
import com.wangziyang.mes.basedata.mapper.SpTeamMapper;
import com.wangziyang.mes.basedata.service.ISpTeamService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class SpTeamServiceImpl extends ServiceImpl<SpTeamMapper, SpTeam>
        implements ISpTeamService {

    @Override
    public boolean isTeamCodeDuplicate(String teamCode, String excludeId) {
        QueryWrapper<SpTeam> qw = new QueryWrapper<>();
        qw.eq("team_code", teamCode);
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }
}
