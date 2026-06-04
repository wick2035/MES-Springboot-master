package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroup;
import com.wangziyang.mes.basedata.mapper.SpEquipmentGroupMapper;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class SpEquipmentGroupServiceImpl extends ServiceImpl<SpEquipmentGroupMapper, SpEquipmentGroup>
        implements ISpEquipmentGroupService {

    @Override
    public boolean isGroupCodeDuplicate(String groupCode, String excludeId) {
        QueryWrapper<SpEquipmentGroup> qw = new QueryWrapper<>();
        qw.eq("group_code", groupCode);
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }
}
