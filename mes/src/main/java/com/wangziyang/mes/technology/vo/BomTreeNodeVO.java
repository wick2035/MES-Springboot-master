package com.wangziyang.mes.technology.vo;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * BOM树节点展示对象，用于前端 treeTable 渲染
 * 字段名 id/pid/children/haveChild/open 与 treeTable.js 默认配置一致
 */
public class BomTreeNodeVO {

    private String id;
    private String pid;
    /** 物料编码 */
    private String materielCode;
    /** 节点名称（物料描述） */
    private String materielDesc;
    /** 原始物料类型 FG/PG/COMP/PART */
    private String matType;
    /** 节点编号：根节点="0"，零部件=BOM编码，物料=物料编码 */
    private String nodeCode;
    /** 节点类型：产品/零部件/物料 */
    private String nodeType;
    /** 节点层级（绝对层级，根=0） */
    private Integer level;
    /** 用量 */
    private BigDecimal itemNum;
    /** 单位 */
    private String itemUnit;
    /** 工序 */
    private String operTyper;
    /** 行号 */
    private String lineNo;
    /** 关联子BOM的id */
    private String childBomId;
    /** 更新时间（格式化后的字符串） */
    private String updateTime;
    /** treeTable是否默认展开 */
    private boolean open = true;
    /** treeTable是否有子节点 */
    private boolean haveChild;
    /** 子节点列表 */
    private List<BomTreeNodeVO> children = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPid() { return pid; }
    public void setPid(String pid) { this.pid = pid; }

    public String getMaterielCode() { return materielCode; }
    public void setMaterielCode(String materielCode) { this.materielCode = materielCode; }

    public String getMaterielDesc() { return materielDesc; }
    public void setMaterielDesc(String materielDesc) { this.materielDesc = materielDesc; }

    public String getMatType() { return matType; }
    public void setMatType(String matType) { this.matType = matType; }

    public String getNodeCode() { return nodeCode; }
    public void setNodeCode(String nodeCode) { this.nodeCode = nodeCode; }

    public String getNodeType() { return nodeType; }
    public void setNodeType(String nodeType) { this.nodeType = nodeType; }

    public Integer getLevel() { return level; }
    public void setLevel(Integer level) { this.level = level; }

    public BigDecimal getItemNum() { return itemNum; }
    public void setItemNum(BigDecimal itemNum) { this.itemNum = itemNum; }

    public String getItemUnit() { return itemUnit; }
    public void setItemUnit(String itemUnit) { this.itemUnit = itemUnit; }

    public String getOperTyper() { return operTyper; }
    public void setOperTyper(String operTyper) { this.operTyper = operTyper; }

    public String getLineNo() { return lineNo; }
    public void setLineNo(String lineNo) { this.lineNo = lineNo; }

    public String getChildBomId() { return childBomId; }
    public void setChildBomId(String childBomId) { this.childBomId = childBomId; }

    public String getUpdateTime() { return updateTime; }
    public void setUpdateTime(String updateTime) { this.updateTime = updateTime; }

    public boolean isOpen() { return open; }
    public void setOpen(boolean open) { this.open = open; }

    public boolean isHaveChild() { return haveChild; }
    public void setHaveChild(boolean haveChild) { this.haveChild = haveChild; }

    public List<BomTreeNodeVO> getChildren() { return children; }
    public void setChildren(List<BomTreeNodeVO> children) { this.children = children; }
}
