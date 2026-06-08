package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * 加工单元实体
 *
 * @author Claude
 * @since 2026-05-28
 */
@TableName(value = "sp_processing_unit")
public class SpProcessingUnit extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 加工单元编号 JG000001（默认自动生成，可手动修改，唯一） */
    private String unitCode;
    /** 加工单元名称 */
    private String unitName;
    /** 加工单元类型 person/device */
    private String unitType;
    /** 描述 */
    private String description;
    /** 日标准产能(小时) */
    private BigDecimal stdCapacity;
    /** 是否有线边库 Y是 N否 */
    private String hasEdgeWarehouse;
    /** 状态 0正常 2异常 */
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

    public BigDecimal getStdCapacity() { return stdCapacity; }
    public void setStdCapacity(BigDecimal stdCapacity) { this.stdCapacity = stdCapacity; }

    public String getHasEdgeWarehouse() { return hasEdgeWarehouse; }
    public void setHasEdgeWarehouse(String hasEdgeWarehouse) { this.hasEdgeWarehouse = hasEdgeWarehouse; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
