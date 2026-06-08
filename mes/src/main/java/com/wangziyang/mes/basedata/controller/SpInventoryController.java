package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.request.SpInventoryReq;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
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

/**
 * <p>
 * 库存管理控制器（库位 + 物料 + 数量）
 * </p>
 *
 * @author Claude
 * @since 2026-06-08
 */
@Controller
@RequestMapping("/basedata/inventory")
public class SpInventoryController extends BaseController {

    @Autowired
    private ISpInventoryService spInventoryService;

    @ApiOperation("库存管理主页")
    @GetMapping("/list-ui")
    public String listUI() {
        return "basedata/inventory/list";
    }

    @ApiOperation("入库/编辑界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpInventory record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpInventory result = spInventoryService.getById(record.getId());
            model.addAttribute("result", result);
        }
        return "basedata/inventory/addOrUpdate";
    }

    @ApiOperation("库存分页查询")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpInventoryReq req) {
        IPage<SpInventory> result = spInventoryService.pageList(req);
        return Result.success(result);
    }

    @ApiOperation("入库（同库位+物料+批号累加数量）")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpInventory record) {
        if (StringUtils.isEmpty(record.getWarehouseId())) {
            return Result.failure("请选择库房");
        }
        if (StringUtils.isEmpty(record.getLocationId())) {
            return Result.failure("请选择库位");
        }
        if (StringUtils.isEmpty(record.getMaterielId())) {
            return Result.failure("请选择物料");
        }
        if (record.getQty() == null) {
            return Result.failure("请输入数量");
        }
        spInventoryService.inbound(record);
        return Result.success();
    }

    @ApiOperation("出库（软删一条库存记录）")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        SpInventory record = new SpInventory();
        record.setId(id);
        record.setDeleted("1");
        spInventoryService.updateById(record);
        return Result.success();
    }
}
