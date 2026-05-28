package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 工艺-备料清单
 *
 * @author Claude
 * @since 2026-05-28
 */
@TableName(value = "sp_process_material_rel")
public class SpProcessMaterialRel implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.ID_WORKER_STR)
    private String id;

    private String routeId;
    private String materielId;
    private BigDecimal reqQty;
    private String remark;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT)
    private String createUsername;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public String getMaterielId() { return materielId; }
    public void setMaterielId(String materielId) { this.materielId = materielId; }

    public BigDecimal getReqQty() { return reqQty; }
    public void setReqQty(BigDecimal reqQty) { this.reqQty = reqQty; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }

    public String getCreateUsername() { return createUsername; }
    public void setCreateUsername(String createUsername) { this.createUsername = createUsername; }
}
