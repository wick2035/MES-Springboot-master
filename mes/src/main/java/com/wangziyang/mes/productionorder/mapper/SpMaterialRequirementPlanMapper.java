package com.wangziyang.mes.productionorder.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.productionorder.entity.SpMaterialRequirementPlan;
import com.wangziyang.mes.productionorder.request.SpMaterialRequirementPlanReq;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Material requirement plan mapper.
 */
public interface SpMaterialRequirementPlanMapper extends BaseMapper<SpMaterialRequirementPlan> {

    IPage<SpMaterialRequirementPlan> pageList(IPage<SpMaterialRequirementPlan> page,
                                              @Param("req") SpMaterialRequirementPlanReq req);

    List<Map<String, Object>> weekSummary(@Param("req") SpMaterialRequirementPlanReq req);
}
