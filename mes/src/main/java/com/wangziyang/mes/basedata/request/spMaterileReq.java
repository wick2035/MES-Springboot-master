package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;
/**
 * 物料分页对象
 * @author wangziyang
 * @since 2020/04/01
 */
public class spMaterileReq  extends BasePageReq {
    /**
     *模糊查询物料编号
     */
    private String materielLike;
    /**
     *模糊查询物料描述
     */
    private String materielDescLike;

    /**
     * 物料类型（精确）
     */
    private String matType;

    /**
     * 物料类型集合（逗号分隔）
     */
    private String matTypes;

    /**
     * 物料来源（精确）
     */
    private String matSource;

    /**
     * 状态（精确）0正常 1删除 2禁用
     */
    private String deleted;

    public String getMatType() {
        return this.matType;
    }

    public void setMatType(String matType) {
        this.matType = matType;
    }

    public String getMatTypes() {
        return this.matTypes;
    }

    public void setMatTypes(String matTypes) {
        this.matTypes = matTypes;
    }

    public String getMatSource() {
        return this.matSource;
    }

    public void setMatSource(String matSource) {
        this.matSource = matSource;
    }

    public String getDeleted() {
        return this.deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }

    /**
     * 获取 模糊查询物料编号
     *
     * @return materielLike 模糊查询物料编号
     */
    public String getMaterielLike() {
        return this.materielLike;
    }

    /**
     * 设置 模糊查询物料编号
     *
     * @param materielLike 模糊查询物料编号
     */
    public void setMaterielLike(String materielLike) {
        this.materielLike = materielLike;
    }

    /**
     * 获取 模糊查询物料描述
     *
     * @return materielDescLike 模糊查询物料描述
     */
    public String getMaterielDescLike() {
        return this.materielDescLike;
    }

    /**
     * 设置 模糊查询物料描述
     *
     * @param materielDescLike 模糊查询物料描述
     */
    public void setMaterielDescLike(String materielDescLike) {
        this.materielDescLike = materielDescLike;
    }
}
