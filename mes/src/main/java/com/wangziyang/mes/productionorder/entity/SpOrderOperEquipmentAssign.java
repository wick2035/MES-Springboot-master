package com.wangziyang.mes.productionorder.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * Equipment assignment for a released operation task.
 */
@TableName("sp_order_oper_equipment_assign")
public class SpOrderOperEquipmentAssign extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String orderId;

    private String orderCode;

    private String productionOrderId;

    private String orderItemId;

    private String operPlanId;

    private String operId;

    private String oper;

    private String operDesc;

    private Integer sortNum;

    private String unitId;

    private String equipmentId;

    private String equipmentCode;

    private String equipmentName;

    private String status;

    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }

    public String getProductionOrderId() { return productionOrderId; }
    public void setProductionOrderId(String productionOrderId) { this.productionOrderId = productionOrderId; }

    public String getOrderItemId() { return orderItemId; }
    public void setOrderItemId(String orderItemId) { this.orderItemId = orderItemId; }

    public String getOperPlanId() { return operPlanId; }
    public void setOperPlanId(String operPlanId) { this.operPlanId = operPlanId; }

    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }

    public String getOper() { return oper; }
    public void setOper(String oper) { this.oper = oper; }

    public String getOperDesc() { return operDesc; }
    public void setOperDesc(String operDesc) { this.operDesc = operDesc; }

    public Integer getSortNum() { return sortNum; }
    public void setSortNum(Integer sortNum) { this.sortNum = sortNum; }

    public String getUnitId() { return unitId; }
    public void setUnitId(String unitId) { this.unitId = unitId; }

    public String getEquipmentId() { return equipmentId; }
    public void setEquipmentId(String equipmentId) { this.equipmentId = equipmentId; }

    public String getEquipmentCode() { return equipmentCode; }
    public void setEquipmentCode(String equipmentCode) { this.equipmentCode = equipmentCode; }

    public String getEquipmentName() { return equipmentName; }
    public void setEquipmentName(String equipmentName) { this.equipmentName = equipmentName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
