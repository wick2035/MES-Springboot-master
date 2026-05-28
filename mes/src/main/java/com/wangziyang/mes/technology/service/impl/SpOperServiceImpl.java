package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.mapper.SpOperMapper;
import com.wangziyang.mes.technology.service.ISpOperService;
import org.springframework.stereotype.Service;

@Service
public class SpOperServiceImpl extends ServiceImpl<SpOperMapper, SpOper> implements ISpOperService {

    private static final String PREFIX = "GX";

    @Override
    public String nextOperCode() {
        QueryWrapper<SpOper> qw = new QueryWrapper<>();
        qw.likeRight("oper", PREFIX).orderByDesc("oper").last("limit 1");
        SpOper last = getOne(qw);
        int next = 1;
        if (last != null && last.getOper() != null && last.getOper().length() > PREFIX.length()) {
            try {
                next = Integer.parseInt(last.getOper().substring(PREFIX.length())) + 1;
            } catch (NumberFormatException ignore) {
            }
        }
        return PREFIX + String.format("%06d", next);
    }
}
