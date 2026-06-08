package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpEquipment;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroup;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroupDevice;
import com.wangziyang.mes.basedata.mapper.SpEquipmentGroupMapper;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupDeviceService;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupService;
import com.wangziyang.mes.basedata.service.ISpEquipmentService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SpEquipmentGroupServiceImpl extends ServiceImpl<SpEquipmentGroupMapper, SpEquipmentGroup>
        implements ISpEquipmentGroupService {

    @Autowired
    private ISpEquipmentGroupDeviceService spEquipmentGroupDeviceService;

    @Autowired
    private ISpEquipmentService spEquipmentService;

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

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateGroupStatus(String id, String status) {
        SpEquipmentGroup record = new SpEquipmentGroup();
        record.setId(id);
        record.setDeleted(status);
        updateById(record);

        if (!"2".equals(status)) {
            return;
        }

        QueryWrapper<SpEquipmentGroupDevice> gdQw = new QueryWrapper<>();
        gdQw.eq("group_id", id).eq("is_deleted", "0");
        List<SpEquipmentGroupDevice> groupDevices = spEquipmentGroupDeviceService.list(gdQw);
        List<String> equipmentIds = new ArrayList<>();
        for (SpEquipmentGroupDevice groupDevice : groupDevices) {
            if (StringUtils.isNotEmpty(groupDevice.getEquipmentId())) {
                equipmentIds.add(groupDevice.getEquipmentId());
            }
        }
        if (equipmentIds.isEmpty()) {
            return;
        }

        UpdateWrapper<SpEquipment> equipmentUw = new UpdateWrapper<>();
        equipmentUw.set("status", "0")
                .in("id", equipmentIds)
                .eq("is_deleted", "0");
        spEquipmentService.update(equipmentUw);
    }
}
