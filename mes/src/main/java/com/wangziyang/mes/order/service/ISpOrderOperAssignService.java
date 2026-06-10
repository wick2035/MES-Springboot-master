package com.wangziyang.mes.order.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.order.entity.SpOrderOperAssign;

import java.util.List;
import java.util.Map;

/**
 * 工单工序人员分配服务
 *
 * @since 2026-06-10
 */
public interface ISpOrderOperAssignService extends IService<SpOrderOperAssign> {

    /**
     * 查询指定加工单元下的可分配员工候选（按未完成任务数升序）。
     *
     * @param unitId 加工单元ID
     * @return 候选列表：userId / userName / teamId / teamName / currentLoad
     */
    List<Map<String, Object>> pickCandidatesByUnit(String unitId);
}
