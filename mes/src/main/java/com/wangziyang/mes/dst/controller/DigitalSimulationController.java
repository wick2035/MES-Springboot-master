package com.wangziyang.mes.dst.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.basedata.service.ISpWarehouseLocationService;
import com.wangziyang.mes.basedata.service.ISpWarehouseService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 数字仿真控制器 基于three.js
 * </p>
 *
 * @author WangZiYang
 * @since 2020-08-18
 */
@Controller
@RequestMapping("/digital/simulation")
public class DigitalSimulationController extends BaseController {

    @Autowired
    private ISpWarehouseService spWarehouseService;

    @Autowired
    private ISpWarehouseLocationService spWarehouseLocationService;

    @Autowired
    private ISpInventoryService spInventoryService;

    /**
     * 数字仿真界面
     *
     * @return 数字仿真界面
     */
    @ApiOperation("数字仿真3D教学UI")
    @GetMapping("/list-ui")
    public String listUI(Model model, @RequestParam(required = false) String warehouseId) {
        model.addAttribute("warehouseId", warehouseId == null ? "" : warehouseId);
        return "digitization/3DProject";
    }

    @ApiOperation("可选库房列表（供3D页面下拉）")
    @PostMapping("/warehouse-list")
    @ResponseBody
    public Result warehouseList() {
        QueryWrapper<SpWarehouse> qw = new QueryWrapper<>();
        qw.ne("is_deleted", "1");
        qw.orderByAsc("warehouse_code");
        List<SpWarehouse> list = spWarehouseService.list(qw);
        List<Map<String, Object>> result = new ArrayList<>();
        for (SpWarehouse w : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", w.getId());
            item.put("warehouseCode", w.getWarehouseCode());
            item.put("warehouseName", w.getWarehouseName());
            result.add(item);
        }
        return Result.success(result);
    }

    @ApiOperation("某库房的3D场景数据（规格+库位+库存）")
    @PostMapping("/scene")
    @ResponseBody
    public Result scene(@RequestParam(required = false) String warehouseId) {
        Map<String, Object> data = new HashMap<>();
        if (StringUtils.isEmpty(warehouseId)) {
            return Result.success(data);
        }
        SpWarehouse warehouse = spWarehouseService.getById(warehouseId);
        if (warehouse == null) {
            return Result.success(data);
        }

        Map<String, Object> wh = new HashMap<>();
        wh.put("warehouseCode", warehouse.getWarehouseCode());
        wh.put("warehouseName", warehouse.getWarehouseName());
        wh.put("specGroup", warehouse.getSpecGroup());
        wh.put("specRow", warehouse.getSpecRow());
        wh.put("specLayer", warehouse.getSpecLayer());
        wh.put("specColumn", warehouse.getSpecColumn());
        data.put("warehouse", wh);

        // 库位（取全量，分页 size 设大）
        Page<SpWarehouseLocation> page = new Page<>(1, 100000);
        List<SpWarehouseLocation> locations = spWarehouseLocationService.pageByWarehouse(page, warehouseId).getRecords();
        List<Map<String, Object>> locList = new ArrayList<>();
        for (SpWarehouseLocation loc : locations) {
            Map<String, Object> item = new HashMap<>();
            item.put("locationCode", loc.getLocationCode());
            item.put("groupNo", loc.getGroupNo());
            item.put("rowNo", loc.getRowNo());
            item.put("layerNo", loc.getLayerNo());
            item.put("columnNo", loc.getColumnNo());
            item.put("status", loc.getStatus());
            locList.add(item);
        }
        data.put("locations", locList);

        // 库存
        List<SpInventory> inventories = spInventoryService.listByWarehouse(warehouseId);
        List<Map<String, Object>> invList = new ArrayList<>();
        for (SpInventory inv : inventories) {
            Map<String, Object> item = new HashMap<>();
            item.put("groupNo", inv.getGroupNo());
            item.put("rowNo", inv.getRowNo());
            item.put("layerNo", inv.getLayerNo());
            item.put("columnNo", inv.getColumnNo());
            item.put("locationCode", inv.getLocationCode());
            item.put("materielCode", inv.getMaterielCode());
            item.put("materielDesc", inv.getMaterielDesc());
            item.put("batchNo", inv.getBatchNo());
            item.put("qty", inv.getQty());
            item.put("unit", inv.getUnit());
            invList.add(item);
        }
        data.put("inventories", invList);

        return Result.success(data);
    }

}
