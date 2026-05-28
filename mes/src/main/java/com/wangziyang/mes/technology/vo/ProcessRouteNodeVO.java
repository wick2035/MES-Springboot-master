package com.wangziyang.mes.technology.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * 工艺流程树节点 VO（按BOM树+绑定工序）
 *
 * @author Claude
 * @since 2026-05-28
 */
public class ProcessRouteNodeVO {

    private String id;
    private String pid;
    /** 工艺记录ID（sp_process_route.id），点击编辑使用 */
    private String routeId;
    /** 工艺编号 NGY_3_M000003_001_001 */
    private String routeCode;
    /** 节点名称（含工艺编号前缀） */
    private String nodeName;
    /** 节点物料编码 */
    private String materielCode;
    /** 节点物料类型 FG/PG/COMP/PART */
    private String matType;
    /** BOM节点ID */
    private String bomItemId;
    /** 绑定工序ID */
    private String operId;
    /** 绑定工序编号 */
    private String operCode;
    /** 绑定工序名称（显示） */
    private String operName;
    /** 加工单元名称 */
    private String unitName;
    /** 加工单元类型显示名 */
    private String unitTypeName;
    /** 工时(h) */
    private String operHours;
    /** 制造周期(h) */
    private String manuCycle;
    /** 是否生成生产计划 */
    private String genPlan;
    /** 排序号 */
    private Integer seqNo;
    /** draft/locked */
    private String lockStatus;
    /** pending/editing/completed */
    private String editStatus;
    /** 树层级 */
    private Integer level;
    private boolean open = true;
    private boolean haveChild;
    private List<ProcessRouteNodeVO> children = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public String getRouteCode() { return routeCode; }
    public void setRouteCode(String routeCode) { this.routeCode = routeCode; }

    public String getNodeName() { return nodeName; }
    public void setNodeName(String nodeName) { this.nodeName = nodeName; }

    public String getMaterielCode() { return materielCode; }
    public void setMaterielCode(String materielCode) { this.materielCode = materielCode; }

    public String getMatType() { return matType; }
    public void setMatType(String matType) { this.matType = matType; }

    public String getBomItemId() { return bomItemId; }
    public void setBomItemId(String bomItemId) { this.bomItemId = bomItemId; }

    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }

    public String getOperCode() { return operCode; }
    public void setOperCode(String operCode) { this.operCode = operCode; }

    public String getOperName() { return operName; }
    public void setOperName(String operName) { this.operName = operName; }

    public String getUnitName() { return unitName; }
    public void setUnitName(String unitName) { this.unitName = unitName; }

    public String getUnitTypeName() { return unitTypeName; }
    public void setUnitTypeName(String unitTypeName) { this.unitTypeName = unitTypeName; }

    public String getOperHours() { return operHours; }
    public void setOperHours(String operHours) { this.operHours = operHours; }

    public String getManuCycle() { return manuCycle; }
    public void setManuCycle(String manuCycle) { this.manuCycle = manuCycle; }

    public String getGenPlan() { return genPlan; }
    public void setGenPlan(String genPlan) { this.genPlan = genPlan; }

    public Integer getSeqNo() { return seqNo; }
    public void setSeqNo(Integer seqNo) { this.seqNo = seqNo; }

    public String getLockStatus() { return lockStatus; }
    public void setLockStatus(String lockStatus) { this.lockStatus = lockStatus; }

    public String getEditStatus() { return editStatus; }
    public void setEditStatus(String editStatus) { this.editStatus = editStatus; }

    public Integer getLevel() { return level; }
    public void setLevel(Integer level) { this.level = level; }

    public boolean isOpen() { return open; }
    public void setOpen(boolean open) { this.open = open; }

    public boolean isHaveChild() { return haveChild; }
    public void setHaveChild(boolean haveChild) { this.haveChild = haveChild; }

    public List<ProcessRouteNodeVO> getChildren() { return children; }
    public void setChildren(List<ProcessRouteNodeVO> children) { this.children = children; }
}
