package com.wangziyang.mes.basedata.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroupDevice;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

public interface SpEquipmentGroupDeviceMapper extends BaseMapper<SpEquipmentGroupDevice> {

    /**
     * 按编组分页查询设备，联表回显设备编号/名称/状态
     *
     * @param page    分页对象
     * @param groupId 编组ID
     * @return 设备分页
     */
    IPage<SpEquipmentGroupDevice> pageByGroup(IPage<SpEquipmentGroupDevice> page, @Param("groupId") String groupId);

    /**
     * 设备选择弹窗数据源：分页查询生产设备，联表回显关联工艺路线编号（多个逗号拼接）
     *
     * @param page     分页对象
     * @param codeLike 设备编号模糊
     * @param nameLike 设备名称模糊
     * @return 设备分页（含 processNames 列）
     */
    IPage<Map<String, Object>> pageEquipmentForSelect(IPage<Map<String, Object>> page,
                                                      @Param("codeLike") String codeLike,
                                                      @Param("nameLike") String nameLike);
}
