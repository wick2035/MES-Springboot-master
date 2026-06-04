package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.mapper.SpProcessingUnitMapper;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class SpProcessingUnitServiceImpl extends ServiceImpl<SpProcessingUnitMapper, SpProcessingUnit>
        implements ISpProcessingUnitService {

    private static final String PREFIX = "JG";

    @Override
    public String nextUnitCode() {
        QueryWrapper<SpProcessingUnit> qw = new QueryWrapper<>();
        qw.likeRight("unit_code", PREFIX).orderByDesc("unit_code").last("limit 1");
        SpProcessingUnit last = getOne(qw);
        int next = 1;
        if (last != null && last.getUnitCode() != null && last.getUnitCode().length() > PREFIX.length()) {
            try {
                next = Integer.parseInt(last.getUnitCode().substring(PREFIX.length())) + 1;
            } catch (NumberFormatException ignore) {
            }
        }
        return PREFIX + String.format("%06d", next);
    }

    @Override
    public boolean isUnitCodeDuplicate(String unitCode, String excludeId) {
        if (StringUtils.isEmpty(unitCode)) {
            return false;
        }
        QueryWrapper<SpProcessingUnit> qw = new QueryWrapper<>();
        qw.eq("unit_code", unitCode);
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }
}
