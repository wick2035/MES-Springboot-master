package com.wangziyang.mes.technology.mapper;

import com.wangziyang.mes.technology.entity.SpBom;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-28
 */
public interface SpBomMapper extends BaseMapper<SpBom> {

    /**
     * 查询可用的子BOM列表（state=pass，is_deleted=0）
     * @param bomLevel BOM层级，null表示不限制
     */
    List<SpBom> listAvailableBoms(@Param("bomLevel") Integer bomLevel,
                                  @Param("materielCode") String materielCode);
}
