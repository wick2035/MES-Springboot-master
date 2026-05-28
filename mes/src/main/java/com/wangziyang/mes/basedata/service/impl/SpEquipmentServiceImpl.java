package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpEquipment;
import com.wangziyang.mes.basedata.mapper.SpEquipmentMapper;
import com.wangziyang.mes.basedata.service.ISpEquipmentService;
import org.springframework.stereotype.Service;

@Service
public class SpEquipmentServiceImpl extends ServiceImpl<SpEquipmentMapper, SpEquipment>
        implements ISpEquipmentService {

    private static final String PREFIX = "EQ";

    @Override
    public String nextEquipmentCode() {
        QueryWrapper<SpEquipment> qw = new QueryWrapper<>();
        qw.likeRight("equipment_code", PREFIX).orderByDesc("equipment_code").last("limit 1");
        SpEquipment last = getOne(qw);
        int next = 1;
        if (last != null && last.getEquipmentCode() != null && last.getEquipmentCode().length() > PREFIX.length()) {
            try {
                next = Integer.parseInt(last.getEquipmentCode().substring(PREFIX.length())) + 1;
            } catch (NumberFormatException ignore) {
            }
        }
        return PREFIX + String.format("%06d", next);
    }
}
