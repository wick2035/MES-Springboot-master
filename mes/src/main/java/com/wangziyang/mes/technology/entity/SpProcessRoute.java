package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 产品工艺流程实体（按BOM节点）
 *
 * @author Claude
 * @since 2026-05-28
 */
@TableName(value = "sp_process_route")
public class SpProcessRoute extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 所属BOM */
    private String bomId;
    /** BOM节点ID（空表示根产品节点） */
    private String bomItemId;
    /** 工艺编号 NGY_3_M000003_001_001 */
    private String routeCode;
    /** 上级工艺ID */
    private String parentRouteId;
    /** 节点名称（冗余） */
    private String nodeName;
    /** 物料编码（冗余） */
    private String materielCode;
    /** 绑定的工序ID */
    private String operId;
    /** 排序号 */
    private Integer seqNo;
    /** draft草稿 locked已锁定 */
    private String lockStatus;
    /** pending未编制 editing编制中 completed已完成 */
    private String editStatus;

    @TableField(value = "is_deleted")
    private String deleted;

    public String getBomId() { return bomId; }
    public void setBomId(String bomId) { this.bomId = bomId; }

    public String getBomItemId() { return bomItemId; }
    public void setBomItemId(String bomItemId) { this.bomItemId = bomItemId; }

    public String getRouteCode() { return routeCode; }
    public void setRouteCode(String routeCode) { this.routeCode = routeCode; }

    public String getParentRouteId() { return parentRouteId; }
    public void setParentRouteId(String parentRouteId) { this.parentRouteId = parentRouteId; }

    public String getNodeName() { return nodeName; }
    public void setNodeName(String nodeName) { this.nodeName = nodeName; }

    public String getMaterielCode() { return materielCode; }
    public void setMaterielCode(String materielCode) { this.materielCode = materielCode; }

    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }

    public Integer getSeqNo() { return seqNo; }
    public void setSeqNo(Integer seqNo) { this.seqNo = seqNo; }

    public String getLockStatus() { return lockStatus; }
    public void setLockStatus(String lockStatus) { this.lockStatus = lockStatus; }

    public String getEditStatus() { return editStatus; }
    public void setEditStatus(String editStatus) { this.editStatus = editStatus; }

    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
