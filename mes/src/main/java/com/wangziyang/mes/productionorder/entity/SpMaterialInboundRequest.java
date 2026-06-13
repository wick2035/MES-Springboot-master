package com.wangziyang.mes.productionorder.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * Inbound request generated from released material plans.
 */
@TableName("sp_material_inbound_request")
public class SpMaterialInboundRequest extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String requestNo;

    private String productionOrderId;

    private String productionOrderNo;

    private String sourceBatchNo;

    private String status;

    private Integer itemCount;

    private BigDecimal totalNetQty;

    private String remark;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getRequestNo() { return requestNo; }
    public void setRequestNo(String requestNo) { this.requestNo = requestNo; }

    public String getProductionOrderId() { return productionOrderId; }
    public void setProductionOrderId(String productionOrderId) { this.productionOrderId = productionOrderId; }

    public String getProductionOrderNo() { return productionOrderNo; }
    public void setProductionOrderNo(String productionOrderNo) { this.productionOrderNo = productionOrderNo; }

    public String getSourceBatchNo() { return sourceBatchNo; }
    public void setSourceBatchNo(String sourceBatchNo) { this.sourceBatchNo = sourceBatchNo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getItemCount() { return itemCount; }
    public void setItemCount(Integer itemCount) { this.itemCount = itemCount; }

    public BigDecimal getTotalNetQty() { return totalNetQty; }
    public void setTotalNetQty(BigDecimal totalNetQty) { this.totalNetQty = totalNetQty; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
