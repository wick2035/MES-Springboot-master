package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 设备编组-设备关系实体（多对多）
 *
 * @author Claude
 * @since 2026-06-04
 */
@TableName(value = "sp_equipment_group_device")
public class SpEquipmentGroupDevice extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 编组ID */
    private String groupId;
    /** 设备ID */
    private String equipmentId;
    /** 备注信息 */
    private String remark;

    /** 状态 0正常 1删除 */
    @TableField(value = "is_deleted")
    private String deleted;

    /** 展示字段：设备编号（联表 sp_equipment.equipment_code 回显，不存库） */
    @TableField(exist = false)
    private String equipmentCode;
    /** 展示字段：设备名称（联表 sp_equipment.equipment_name 回显，不存库） */
    @TableField(exist = false)
    private String equipmentName;
    /** 展示字段：设备状态（联表 sp_equipment.status 回显，不存库） */
    @TableField(exist = false)
    private String equipmentStatus;

    public String getGroupId() { return groupId; }
    public void setGroupId(String groupId) { this.groupId = groupId; }

    public String getEquipmentId() { return equipmentId; }
    public void setEquipmentId(String equipmentId) { this.equipmentId = equipmentId; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }

    public String getEquipmentCode() { return equipmentCode; }
    public void setEquipmentCode(String equipmentCode) { this.equipmentCode = equipmentCode; }

    public String getEquipmentName() { return equipmentName; }
    public void setEquipmentName(String equipmentName) { this.equipmentName = equipmentName; }

    public String getEquipmentStatus() { return equipmentStatus; }
    public void setEquipmentStatus(String equipmentStatus) { this.equipmentStatus = equipmentStatus; }
}
