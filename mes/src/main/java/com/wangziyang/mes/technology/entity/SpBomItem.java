package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * <p>
 *
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-28
 */
@TableName(value = "sp_bom_item")
public class SpBomItem extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * bom编号
     */
    private String bomHeadId;

    /**
     * 物料ID
     */
    private String materielItemCode;

    /**
     * 物料描述
     */
    private String materielItemDesc;

    /**
     * 行号
     */
    private String lineNo;

    /**
     * 用量
     */
    private BigDecimal itemNum;

    /**
     * 子项基本单位
     */
    private String itemUnit;

    /**
     * 所属工序类型
     */
    private String operTyper;

    /**
     * 关联子BOM的id（子项为组件/半成品时指向sp_bom.id）
     */
    private String childBomId;

    /**
     * 子项物料类型 FG/PG/COMP/PART
     */
    private String itemMatType;

    /**
     * 关联子BOM编码，仅用于页面展示
     */
    @TableField(exist = false)
    private String childBomCode;

    public String getBomHeadId() {
        return bomHeadId;
    }

    public void setBomHeadId(String bomHeadId) {
        this.bomHeadId = bomHeadId;
    }

    public String getMaterielItemCode() {
        return materielItemCode;
    }

    public void setMaterielItemCode(String materielItemCode) {
        this.materielItemCode = materielItemCode;
    }

    public String getMaterielItemDesc() {
        return materielItemDesc;
    }

    public void setMaterielItemDesc(String materielItemDesc) {
        this.materielItemDesc = materielItemDesc;
    }

    public String getLineNo() {
        return lineNo;
    }

    public void setLineNo(String lineNo) {
        this.lineNo = lineNo;
    }

    public BigDecimal getItemNum() {
        return itemNum;
    }

    public void setItemNum(BigDecimal itemNum) {
        this.itemNum = itemNum;
    }

    public String getItemUnit() {
        return itemUnit;
    }

    public void setItemUnit(String itemUnit) {
        this.itemUnit = itemUnit;
    }

    public String getOperTyper() {
        return operTyper;
    }

    public void setOperTyper(String operTyper) {
        this.operTyper = operTyper;
    }

    public String getChildBomId() {
        return childBomId;
    }

    public void setChildBomId(String childBomId) {
        this.childBomId = childBomId;
    }

    public String getItemMatType() {
        return itemMatType;
    }

    public void setItemMatType(String itemMatType) {
        this.itemMatType = itemMatType;
    }

    public String getChildBomCode() {
        return childBomCode;
    }

    public void setChildBomCode(String childBomCode) {
        this.childBomCode = childBomCode;
    }

    @Override
    public String toString() {
        return "SpBomItem{" +
                "bomHeadId=" + bomHeadId +
                ", materielItemCode=" + materielItemCode +
                ", materielItemDesc=" + materielItemDesc +
                ", lineNo=" + lineNo +
                ", itemNum=" + itemNum +
                ", itemUnit=" + itemUnit +
                ", operTyper=" + operTyper +
                ", childBomId=" + childBomId +
                ", itemMatType=" + itemMatType +
                ", childBomCode=" + childBomCode +
                "}";
    }
}
