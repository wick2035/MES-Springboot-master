package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import com.wangziyang.mes.basedata.mapper.SpWarehouseLocationMapper;
import com.wangziyang.mes.basedata.service.ISpWarehouseLocationService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class SpWarehouseLocationServiceImpl extends ServiceImpl<SpWarehouseLocationMapper, SpWarehouseLocation>
        implements ISpWarehouseLocationService {

    @Override
    public IPage<SpWarehouseLocation> pageByWarehouse(IPage<SpWarehouseLocation> page, String warehouseId) {
        return baseMapper.pageByWarehouse(page, warehouseId);
    }

    @Override
    public void regenerateLocations(SpWarehouse warehouse) {
        // 1. 软删该库房现存全部库位
        deleteByWarehouse(warehouse.getId());

        // 2. 按规格（组×排×层×列）生成全部库位，缺省/非正数按 1 处理
        int groups = normalize(warehouse.getSpecGroup());
        int rows = normalize(warehouse.getSpecRow());
        int layers = normalize(warehouse.getSpecLayer());
        int columns = normalize(warehouse.getSpecColumn());

        List<SpWarehouseLocation> locations = new ArrayList<>();
        for (int g = 1; g <= groups; g++) {
            for (int r = 1; r <= rows; r++) {
                for (int l = 1; l <= layers; l++) {
                    for (int c = 1; c <= columns; c++) {
                        SpWarehouseLocation loc = new SpWarehouseLocation();
                        loc.setWarehouseId(warehouse.getId());
                        loc.setLocationCode(warehouse.getWarehouseCode() + "-" + g + "-" + r + "-" + l + "-" + c);
                        loc.setGroupNo(g);
                        loc.setRowNo(r);
                        loc.setLayerNo(l);
                        loc.setColumnNo(c);
                        loc.setStatus("0");
                        loc.setDeleted("0");
                        locations.add(loc);
                    }
                }
            }
        }
        if (!locations.isEmpty()) {
            saveBatch(locations);
        }
    }

    @Override
    public void deleteByWarehouse(String warehouseId) {
        UpdateWrapper<SpWarehouseLocation> uw = new UpdateWrapper<>();
        uw.eq("warehouse_id", warehouseId);
        uw.ne("is_deleted", "1");
        uw.set("is_deleted", "1");
        update(uw);
    }

    private int normalize(Integer value) {
        return (value == null || value < 1) ? 1 : value;
    }
}
