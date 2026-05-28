package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 加工单元实体
 *
 * @author Claude
 * @since 2026-05-28
 */
@TableName(value = "sp_processing_unit")
public class SpProcessingUnit extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 加工单元编号 JG000001 */
    private String unitCode;
    /** 加工单元名称 */
    private String unitName;
    /** 加工单元类型 person/device */
    private String unitType;
    /** 描述 */
    private String description;
    /** 状态 1启用 0停用 */
    private String status;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getUnitCode() { return unitCode; }
    public void setUnitCode(String unitCode) { this.unitCode = unitCode; }

    public String getUnitName() { return unitName; }
    public void setUnitName(String unitName) { this.unitName = unitName; }

    public String getUnitType() { return unitType; }
    public void setUnitType(String unitType) { this.unitType = unitType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
