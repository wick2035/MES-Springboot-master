package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroup;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroupDevice;
import com.wangziyang.mes.basedata.request.SpEquipmentGroupReq;
import com.wangziyang.mes.basedata.request.SpEquipmentReq;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupDeviceService;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupService;
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
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 设备编组 / 编组设备 控制器（资源分配管理）
 * </p>
 *
 * @author Claude
 * @since 2026-06-04
 */
@Controller
@RequestMapping("/basedata/equipment-group")
public class SpEquipmentGroupController extends BaseController {

    @Autowired
    private ISpEquipmentGroupService spEquipmentGroupService;

    @Autowired
    private ISpEquipmentGroupDeviceService spEquipmentGroupDeviceService;

    // ============================ 编组管理 ============================

    @ApiOperation("编组设备定义主页（主从布局）")
    @GetMapping("/list-ui")
    public String listUI() {
        return "basedata/equipment-group/list";
    }

    @ApiOperation("编组新增/编辑界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpEquipmentGroup record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpEquipmentGroup result = spEquipmentGroupService.getById(record.getId());
            model.addAttribute("result", result);
        }
        return "basedata/equipment-group/addOrUpdate";
    }

    @ApiOperation("编组分页查询")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpEquipmentGroupReq req) {
        QueryWrapper<SpEquipmentGroup> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getGroupCodeLike())) {
            qw.likeRight("group_code", req.getGroupCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getGroupNameLike())) {
            qw.likeRight("group_name", req.getGroupNameLike());
        }
        // 不显示已删除
        qw.ne("is_deleted", "1");
        qw.orderByDesc(req.getOrderBy());
        IPage result = spEquipmentGroupService.page(req, qw);
        return Result.success(result);
    }

    @ApiOperation("编组新增/编辑")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpEquipmentGroup record) {
        // 编组编号唯一校验（小结第1点）
        if (spEquipmentGroupService.isGroupCodeDuplicate(record.getGroupCode(), record.getId())) {
            return Result.failure("编组编号已存在，请更换编码");
        }
        if (StringUtils.isEmpty(record.getDeleted())) {
            record.setDeleted("0");
        }
        spEquipmentGroupService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @ApiOperation("启用/禁用编组")
    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        if (!"0".equals(status) && !"2".equals(status)) {
            return Result.failure("状态参数不正确");
        }
        spEquipmentGroupService.updateGroupStatus(id, status);
        return Result.success();
    }

    @ApiOperation("删除编组（软删）")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        SpEquipmentGroup record = new SpEquipmentGroup();
        record.setId(id);
        record.setDeleted("1");
        spEquipmentGroupService.updateById(record);
        return Result.success();
    }

    // ============================ 编组设备管理 ============================

    @ApiOperation("某编组设备分页查询")
    @PostMapping("/device/page")
    @ResponseBody
    public Result devicePage(SpEquipmentGroupReq req, @RequestParam(required = false) String groupId) {
        if (StringUtils.isEmpty(groupId)) {
            // 未选择编组，返回空分页
            return Result.success(new Page<SpEquipmentGroupDevice>(req.getCurrent(), req.getSize()));
        }
        IPage<SpEquipmentGroupDevice> page = new Page<>(req.getCurrent(), req.getSize());
        IPage<SpEquipmentGroupDevice> result = spEquipmentGroupDeviceService.pageByGroup(page, groupId);
        return Result.success(result);
    }

    @ApiOperation("生产设备选择弹窗")
    @GetMapping("/device-select-ui")
    public String deviceSelectUI() {
        return "basedata/equipment-group/deviceSelect";
    }

    @ApiOperation("生产设备选择弹窗数据源（含生产工艺）")
    @PostMapping("/device-select/page")
    @ResponseBody
    public Result deviceSelectPage(SpEquipmentReq req) {
        IPage<Map<String, Object>> page = new Page<>(req.getCurrent(), req.getSize());
        IPage<Map<String, Object>> result = spEquipmentGroupDeviceService.pageEquipmentForSelect(
                page, req.getEquipmentCodeLike(), req.getEquipmentNameLike());
        return Result.success(result);
    }

    @ApiOperation("批量把设备加入编组（同编组去重）")
    @PostMapping("/device/add")
    @ResponseBody
    public Result deviceAdd(@RequestParam String groupId, @RequestParam String equipmentIds) {
        if (StringUtils.isEmpty(groupId)) {
            return Result.failure("请先选择编组");
        }
        List<String> equipmentIdList = new ArrayList<>();
        if (StringUtils.isNotEmpty(equipmentIds)) {
            for (String eid : Arrays.asList(equipmentIds.split(","))) {
                if (StringUtils.isNotEmpty(eid.trim())) {
                    equipmentIdList.add(eid.trim());
                }
            }
        }
        if (equipmentIdList.isEmpty()) {
            return Result.failure("请选择要添加的设备");
        }
        int added = spEquipmentGroupDeviceService.addDevices(groupId, equipmentIdList);
        return Result.success(added, "成功添加 " + added + " 台设备");
    }

    @ApiOperation("从编组移除设备（软删）")
    @PostMapping("/device/delete")
    @ResponseBody
    public Result deviceDelete(@RequestParam String id) {
        SpEquipmentGroupDevice record = new SpEquipmentGroupDevice();
        record.setId(id);
        record.setDeleted("1");
        spEquipmentGroupDeviceService.updateById(record);
        return Result.success();
    }
}
