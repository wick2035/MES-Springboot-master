package com.wangziyang.mes.technology.mapper;

import com.wangziyang.mes.technology.entity.SpBomItem;
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
public interface SpBomItemMapper extends BaseMapper<SpBomItem> {

    /**
     * 根据BOM头ID查询所有子项（含新增字段，按行号排序）
     */
    List<SpBomItem> listByBomHeadId(@Param("bomHeadId") String bomHeadId);
}
