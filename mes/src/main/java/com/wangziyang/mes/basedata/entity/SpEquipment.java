package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 设备实体
 *
 * @author Claude
 * @since 2026-05-28
 */
@TableName(value = "sp_equipment")
public class SpEquipment extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 设备编号 EQ000001 */
    private String equipmentCode;
    /** 设备名称 */
    private String equipmentName;
    /** 设备规格/型号 */
    private String equipmentModel;
    /** 设备用途 */
    private String purpose;
    /** 设定条件 */
    private String spec;
    /** 状态 1启用 0停用 */
    private String status;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getEquipmentCode() { return equipmentCode; }
    public void setEquipmentCode(String equipmentCode) { this.equipmentCode = equipmentCode; }

    public String getEquipmentName() { return equipmentName; }
    public void setEquipmentName(String equipmentName) { this.equipmentName = equipmentName; }

    public String getEquipmentModel() { return equipmentModel; }
    public void setEquipmentModel(String equipmentModel) { this.equipmentModel = equipmentModel; }

    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }

    public String getSpec() { return spec; }
    public void setSpec(String spec) { this.spec = spec; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
