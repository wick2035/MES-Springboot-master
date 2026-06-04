package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 设备编组实体（资源分配管理）
 *
 * @author Claude
 * @since 2026-06-04
 */
@TableName(value = "sp_equipment_group")
public class SpEquipmentGroup extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 编组编号（唯一） */
    private String groupCode;
    /** 编组名称 */
    private String groupName;
    /** 编组描述 */
    private String groupDesc;
    /** 备注信息 */
    private String remark;

    /** 状态 0正常 1删除 2禁用 */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getGroupCode() { return groupCode; }
    public void setGroupCode(String groupCode) { this.groupCode = groupCode; }

    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }

    public String getGroupDesc() { return groupDesc; }
    public void setGroupDesc(String groupDesc) { this.groupDesc = groupDesc; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
