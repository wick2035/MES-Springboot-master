package com.wangziyang.mes.basedata.dto;

import com.alibaba.excel.annotation.ExcelProperty;

/**
 * 物料 Excel 导入行对象。
 * 列名与导入模板表头一致；物料类型/计量单位/材质/物料来源填中文名，导入时按字典反查 value。
 *
 * @author Claude
 * @since 2026-06-05
 */
public class SpMaterileImportDTO {

    @ExcelProperty("物料名称")
    private String materielDesc;

    @ExcelProperty("物料类型")
    private String matType;

    @ExcelProperty("计量单位")
    private String unit;

    @ExcelProperty("规格/型号")
    private String model;

    @ExcelProperty("材质")
    private String texture;

    @ExcelProperty("物料需求提前期(天)")
    private Integer leadTime;

    @ExcelProperty("安全库存")
    private Integer safetyStock;

    @ExcelProperty("物料来源")
    private String matSource;

    @ExcelProperty("备注信息")
    private String remark;

    public String getMaterielDesc() {
        return materielDesc;
    }

    public void setMaterielDesc(String materielDesc) {
        this.materielDesc = materielDesc;
    }

    public String getMatType() {
        return matType;
    }

    public void setMatType(String matType) {
        this.matType = matType;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getTexture() {
        return texture;
    }

    public void setTexture(String texture) {
        this.texture = texture;
    }

    public Integer getLeadTime() {
        return leadTime;
    }

    public void setLeadTime(Integer leadTime) {
        this.leadTime = leadTime;
    }

    public Integer getSafetyStock() {
        return safetyStock;
    }

    public void setSafetyStock(Integer safetyStock) {
        this.safetyStock = safetyStock;
    }

    public String getMatSource() {
        return matSource;
    }

    public void setMatSource(String matSource) {
        this.matSource = matSource;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}
