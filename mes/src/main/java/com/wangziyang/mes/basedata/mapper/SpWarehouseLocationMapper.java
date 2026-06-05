package com.wangziyang.mes.basedata.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import org.apache.ibatis.annotations.Param;

public interface SpWarehouseLocationMapper extends BaseMapper<SpWarehouseLocation> {

    /**
     * 按库房分页查询库位，联表回显所属库房编码
     *
     * @param page        分页对象
     * @param warehouseId 库房ID
     * @return 库位分页
     */
    IPage<SpWarehouseLocation> pageByWarehouse(IPage<SpWarehouseLocation> page, @Param("warehouseId") String warehouseId);
}
