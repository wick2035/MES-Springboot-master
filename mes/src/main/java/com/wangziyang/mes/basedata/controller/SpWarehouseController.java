package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import com.wangziyang.mes.basedata.request.SpWarehouseReq;
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

/**
 * <p>
 * 库房 / 库位 控制器（资源分配管理 - 库房库位定义）
 * </p>
 *
 * @author Claude
 * @since 2026-06-05
 */
@Controller
@RequestMapping("/basedata/warehouse")
public class SpWarehouseController extends BaseController {

    @Autowired
    private ISpWarehouseService spWarehouseService;

    @Autowired
    private ISpWarehouseLocationService spWarehouseLocationService;

    // ============================ 库房管理 ============================

    @ApiOperation("库房库位定义主页（主从布局）")
    @GetMapping("/list-ui")
    public String listUI() {
        return "basedata/warehouse/list";
    }

    @ApiOperation("库房新增/编辑界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpWarehouse record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpWarehouse result = spWarehouseService.getById(record.getId());
            model.addAttribute("result", result);
        }
        return "basedata/warehouse/addOrUpdate";
    }

    @ApiOperation("库房分页查询")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpWarehouseReq req) {
        QueryWrapper<SpWarehouse> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getWarehouseCodeLike())) {
            qw.likeRight("warehouse_code", req.getWarehouseCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getWarehouseNameLike())) {
            qw.likeRight("warehouse_name", req.getWarehouseNameLike());
        }
        if (StringUtils.isNotEmpty(req.getWarehouseType())) {
            qw.eq("warehouse_type", req.getWarehouseType());
        }
        // 不显示已删除
        qw.ne("is_deleted", "1");
        qw.orderByDesc(req.getOrderBy());
        IPage result = spWarehouseService.page(req, qw);
        return Result.success(result);
    }

    @ApiOperation("库房新增/编辑（保存后按规格重新生成库位）")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWarehouse record) {
        // 库房编码唯一校验
        if (spWarehouseService.isWarehouseCodeDuplicate(record.getWarehouseCode(), record.getId())) {
            return Result.failure("库房编码已存在，请更换编码");
        }
        if (StringUtils.isEmpty(record.getDeleted())) {
            record.setDeleted("0");
        }
        spWarehouseService.saveOrUpdateWithLocations(record);
        return Result.success(record.getId());
    }

    @ApiOperation("启用/禁用库房")
    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        SpWarehouse record = new SpWarehouse();
        record.setId(id);
        record.setDeleted(status);
        spWarehouseService.updateById(record);
        return Result.success();
    }

    @ApiOperation("删除库房（软删，连同库位）")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        spWarehouseService.deleteWithLocations(id);
        return Result.success();
    }

    // ============================ 库位管理 ============================

    @ApiOperation("某库房库位分页查询")
    @PostMapping("/location/page")
    @ResponseBody
    public Result locationPage(SpWarehouseReq req, @RequestParam(required = false) String warehouseId) {
        if (StringUtils.isEmpty(warehouseId)) {
            // 未选择库房，返回空分页
            return Result.success(new Page<SpWarehouseLocation>(req.getCurrent(), req.getSize()));
        }
        IPage<SpWarehouseLocation> page = new Page<>(req.getCurrent(), req.getSize());
        IPage<SpWarehouseLocation> result = spWarehouseLocationService.pageByWarehouse(page, warehouseId);
        return Result.success(result);
    }

    @ApiOperation("启用/禁用单个库位")
    @PostMapping("/location/disable")
    @ResponseBody
    public Result locationDisable(@RequestParam String id, @RequestParam String status) {
        SpWarehouseLocation record = new SpWarehouseLocation();
        record.setId(id);
        record.setStatus(status);
        spWarehouseLocationService.updateById(record);
        return Result.success();
    }
}
