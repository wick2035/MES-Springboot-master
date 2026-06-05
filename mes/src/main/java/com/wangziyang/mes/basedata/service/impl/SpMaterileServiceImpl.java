package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.mapper.SpMaterileMapper;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@Service
public class SpMaterileServiceImpl extends ServiceImpl<SpMaterileMapper, SpMaterile> implements ISpMaterileService {

    private static final String PREFIX = "M";

    @Override
    public String nextMaterielCode() {
        QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
        qw.likeRight("materiel", PREFIX).orderByDesc("materiel").last("limit 1");
        SpMaterile last = getOne(qw, false);
        int next = 1;
        if (last != null && StringUtils.isNotEmpty(last.getMateriel())
                && last.getMateriel().length() > PREFIX.length()) {
            try {
                next = Integer.parseInt(last.getMateriel().substring(PREFIX.length())) + 1;
            } catch (NumberFormatException ignore) {
            }
        }
        return PREFIX + String.format("%06d", next);
    }

    @Override
    public boolean isMaterielCodeDuplicate(String materiel, String excludeId) {
        if (StringUtils.isEmpty(materiel)) {
            return false;
        }
        QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
        qw.eq("materiel", materiel);
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }
}
