package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroup;

public interface ISpEquipmentGroupService extends IService<SpEquipmentGroup> {

    /**
     * 编组编号是否已存在（仅统计未删除记录，排除自身）
     *
     * @param groupCode 编组编号
     * @param excludeId 编辑时排除的自身ID，可为空
     * @return true 已存在
     */
    boolean isGroupCodeDuplicate(String groupCode, String excludeId);

    /**
     * Update group status. When disabling a group, all active devices managed by
     * the group are stopped together.
     *
     * @param id group id
     * @param status group status: 0 normal, 2 disabled
     */
    void updateGroupStatus(String id, String status);
}
