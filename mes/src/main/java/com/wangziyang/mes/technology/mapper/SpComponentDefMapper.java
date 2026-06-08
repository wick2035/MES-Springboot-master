package com.wangziyang.mes.technology.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wangziyang.mes.technology.entity.SpComponentDef;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Component definition mapper.
 */
public interface SpComponentDefMapper extends BaseMapper<SpComponentDef> {

    List<SpComponentDef> listEnabledByProductName(@Param("productName") String productName,
                                                  @Param("componentType") String componentType);
}
