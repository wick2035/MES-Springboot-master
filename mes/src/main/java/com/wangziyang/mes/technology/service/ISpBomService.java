package com.wangziyang.mes.technology.service;

import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.vo.BomTreeNodeVO;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import java.util.Set;

/**
 * <p>
 *  bom服务类
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-28
 */
public interface ISpBomService extends IService<SpBom> {

    /**
     * 递归构建完整BOM树，零件(PART)不再向下展开
     * @param bomId      BOM头ID
     * @param visitedIds 已访问BOM集合，用于检测循环引用
     * @return 根节点（含完整子树）
     */
    BomTreeNodeVO buildBomTree(String bomId, Set<String> visitedIds);

    /**
     * 查询可选子BOM列表（供编辑时选择子BOM用）
     * @param itemMatType 子项物料类型 PG→level1 COMP→level2
     */
    List<SpBom> listSelectableBoms(String itemMatType, String materielCode);

    /**
     * 事务性保存BOM头及其全部子项（先删旧子项再插入新子项）
     * @param spBom     BOM头实体
     * @param itemsJson 前端序列化的子项JSON字符串
     */
    void saveBomWithItems(SpBom spBom, String itemsJson);

    /**
     * BOM定版操作（锁定后不可编辑）
     */
    void lockBom(String bomId);

    /**
     * 产品BOM软删除，已定版数据不可删除
     */
    void deleteBom(String bomId);
}
