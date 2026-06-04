package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroupDevice;
import com.wangziyang.mes.basedata.mapper.SpEquipmentGroupDeviceMapper;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupDeviceService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class SpEquipmentGroupDeviceServiceImpl extends ServiceImpl<SpEquipmentGroupDeviceMapper, SpEquipmentGroupDevice>
        implements ISpEquipmentGroupDeviceService {

    @Override
    public IPage<SpEquipmentGroupDevice> pageByGroup(IPage<SpEquipmentGroupDevice> page, String groupId) {
        return baseMapper.pageByGroup(page, groupId);
    }

    @Override
    public IPage<Map<String, Object>> pageEquipmentForSelect(IPage<Map<String, Object>> page, String codeLike, String nameLike) {
        return baseMapper.pageEquipmentForSelect(page, codeLike, nameLike);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addDevices(String groupId, List<String> equipmentIds) {
        if (StringUtils.isEmpty(groupId) || equipmentIds == null || equipmentIds.isEmpty()) {
            return 0;
        }
        // 该编组下已存在（未删除）的设备，用于去重——满足「同编组不重复」
        QueryWrapper<SpEquipmentGroupDevice> qw = new QueryWrapper<>();
        qw.eq("group_id", groupId).eq("is_deleted", "0");
        List<SpEquipmentGroupDevice> exists = list(qw);
        Set<String> existEquipmentIds = new HashSet<>();
        for (SpEquipmentGroupDevice e : exists) {
            existEquipmentIds.add(e.getEquipmentId());
        }

        List<SpEquipmentGroupDevice> toAdd = new ArrayList<>();
        Set<String> batchSeen = new HashSet<>();
        for (String equipmentId : equipmentIds) {
            if (StringUtils.isEmpty(equipmentId) || existEquipmentIds.contains(equipmentId) || batchSeen.contains(equipmentId)) {
                continue;
            }
            batchSeen.add(equipmentId);
            SpEquipmentGroupDevice record = new SpEquipmentGroupDevice();
            record.setGroupId(groupId);
            record.setEquipmentId(equipmentId);
            record.setDeleted("0");
            toAdd.add(record);
        }
        if (!toAdd.isEmpty()) {
            saveBatch(toAdd);
        }
        return toAdd.size();
    }
}
