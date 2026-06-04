package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroupDevice;

import java.util.List;
import java.util.Map;

public interface ISpEquipmentGroupDeviceService extends IService<SpEquipmentGroupDevice> {

    /**
     * 按编组分页查询设备（联表回显设备编号/名称/状态）
     */
    IPage<SpEquipmentGroupDevice> pageByGroup(IPage<SpEquipmentGroupDevice> page, String groupId);

    /**
     * 设备选择弹窗数据源：分页查询生产设备（含关联工艺路线编号）
     */
    IPage<Map<String, Object>> pageEquipmentForSelect(IPage<Map<String, Object>> page, String codeLike, String nameLike);

    /**
     * 批量把设备加入编组，跳过该编组已存在（未删除）的设备，实现「同编组不重复」
     *
     * @param groupId      编组ID
     * @param equipmentIds 设备ID集合
     * @return 实际新增数量
     */
    int addDevices(String groupId, List<String> equipmentIds);
}
