package com.wangziyang.mes.order.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.order.entity.SpOrderOperAssign;
import com.wangziyang.mes.order.mapper.SpOrderOperAssignMapper;
import com.wangziyang.mes.order.service.ISpOrderOperAssignService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 工单工序人员分配服务实现
 *
 * @since 2026-06-10
 */
@Service
public class SpOrderOperAssignServiceImpl extends ServiceImpl<SpOrderOperAssignMapper, SpOrderOperAssign>
        implements ISpOrderOperAssignService {

    @Override
    public List<Map<String, Object>> pickCandidatesByUnit(String unitId) {
        return baseMapper.pickCandidatesByUnit(unitId);
    }
}
