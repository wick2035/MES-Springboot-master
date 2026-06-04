package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpProcessingUnitTeam;
import com.wangziyang.mes.basedata.mapper.SpProcessingUnitTeamMapper;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitTeamService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class SpProcessingUnitTeamServiceImpl extends ServiceImpl<SpProcessingUnitTeamMapper, SpProcessingUnitTeam>
        implements ISpProcessingUnitTeamService {

    @Override
    public IPage<SpProcessingUnitTeam> pageByUnit(IPage<SpProcessingUnitTeam> page, String unitId) {
        return baseMapper.pageByUnit(page, unitId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addTeams(String unitId, List<String> teamIds) {
        if (StringUtils.isEmpty(unitId) || teamIds == null || teamIds.isEmpty()) {
            return 0;
        }
        // 该加工单元下已存在（未删除）的班组，用于去重——满足「同单元不重复」
        QueryWrapper<SpProcessingUnitTeam> qw = new QueryWrapper<>();
        qw.eq("unit_id", unitId).eq("is_deleted", "0");
        List<SpProcessingUnitTeam> exists = list(qw);
        Set<String> existTeamIds = new HashSet<>();
        for (SpProcessingUnitTeam e : exists) {
            existTeamIds.add(e.getTeamId());
        }

        List<SpProcessingUnitTeam> toAdd = new ArrayList<>();
        Set<String> batchSeen = new HashSet<>();
        for (String teamId : teamIds) {
            if (StringUtils.isEmpty(teamId) || existTeamIds.contains(teamId) || batchSeen.contains(teamId)) {
                continue;
            }
            batchSeen.add(teamId);
            SpProcessingUnitTeam record = new SpProcessingUnitTeam();
            record.setUnitId(unitId);
            record.setTeamId(teamId);
            record.setDeleted("0");
            toAdd.add(record);
        }
        if (!toAdd.isEmpty()) {
            saveBatch(toAdd);
        }
        return toAdd.size();
    }
}
