package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.mapper.SpInventoryMapper;
import com.wangziyang.mes.basedata.request.SpInventoryReq;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.warehouse.WarehouseConstants;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * 库存服务实现
 *
 * @author Claude
 * @since 2026-06-08
 */
@Service
public class SpInventoryServiceImpl extends ServiceImpl<SpInventoryMapper, SpInventory>
        implements ISpInventoryService {

    @Autowired
    private ISpMaterileService spMaterileService;

    @Override
    public IPage<SpInventory> pageList(SpInventoryReq req) {
        IPage<SpInventory> page = new Page<>(req.getCurrent(), req.getSize());
        return baseMapper.pageList(page, req);
    }

    @Override
    public List<SpInventory> listByWarehouse(String warehouseId) {
        return baseMapper.listByWarehouse(warehouseId);
    }

    @Override
    public void inbound(SpInventory record) {
        // 从物料带出单位
        if (StringUtils.isNotEmpty(record.getMaterielId())) {
            SpMaterile materile = spMaterileService.getById(record.getMaterielId());
            if (materile != null) {
                record.setUnit(materile.getUnit());
            }
        }
        if (record.getQty() == null) {
            record.setQty(BigDecimal.ZERO);
        }
        record.setDeleted("0");
        if (StringUtils.isBlank(record.getStockStatus())) {
            record.setStockStatus(WarehouseConstants.STOCK_AVAILABLE);
        }

        // 编辑场景：直接更新
        if (StringUtils.isNotEmpty(record.getId())) {
            updateById(record);
            return;
        }

        // 新增场景：同一(库位+物料+批号)已存在则累加数量
        QueryWrapper<SpInventory> qw = new QueryWrapper<>();
        qw.eq("location_id", record.getLocationId());
        qw.eq("materiel_id", record.getMaterielId());
        qw.eq("is_deleted", "0");
        if (StringUtils.isNotEmpty(record.getBatchNo())) {
            qw.eq("batch_no", record.getBatchNo());
        } else {
            qw.and(w -> w.isNull("batch_no").or().eq("batch_no", ""));
        }
        SpInventory exist = getOne(qw, false);
        if (exist != null) {
            exist.setQty(exist.getQty() == null ? record.getQty() : exist.getQty().add(record.getQty()));
            exist.setUnit(record.getUnit());
            exist.setStockStatus(record.getStockStatus());
            updateById(exist);
        } else {
            save(record);
        }
    }
}
