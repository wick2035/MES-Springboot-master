package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.mapper.SpWarehouseMapper;
import com.wangziyang.mes.basedata.service.ISpWarehouseLocationService;
import com.wangziyang.mes.basedata.service.ISpWarehouseService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SpWarehouseServiceImpl extends ServiceImpl<SpWarehouseMapper, SpWarehouse>
        implements ISpWarehouseService {

    @Autowired
    private ISpWarehouseLocationService spWarehouseLocationService;

    @Override
    public boolean isWarehouseCodeDuplicate(String warehouseCode, String excludeId) {
        QueryWrapper<SpWarehouse> qw = new QueryWrapper<>();
        qw.eq("warehouse_code", warehouseCode);
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveOrUpdateWithLocations(SpWarehouse record) {
        saveOrUpdate(record);
        // 按规格全部重新生成库位
        spWarehouseLocationService.regenerateLocations(record);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteWithLocations(String id) {
        SpWarehouse record = new SpWarehouse();
        record.setId(id);
        record.setDeleted("1");
        updateById(record);
        // 一并软删其库位
        spWarehouseLocationService.deleteByWarehouse(id);
    }
}
