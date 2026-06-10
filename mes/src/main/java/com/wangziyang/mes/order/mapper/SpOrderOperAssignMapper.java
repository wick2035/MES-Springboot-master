package com.wangziyang.mes.order.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wangziyang.mes.order.entity.SpOrderOperAssign;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 工单工序人员分配 Mapper
 *
 * @since 2026-06-10
 */
public interface SpOrderOperAssignMapper extends BaseMapper<SpOrderOperAssign> {

    /**
     * 查询指定加工单元下的可分配员工候选（班组→员工→当前未完成任务数），按负载升序。
     *
     * @param unitId 加工单元ID
     * @return 候选列表：userId / userName / teamId / teamName / currentLoad
     */
    List<Map<String, Object>> pickCandidatesByUnit(@Param("unitId") String unitId);
}
