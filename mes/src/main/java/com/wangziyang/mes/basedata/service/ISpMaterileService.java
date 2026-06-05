package com.wangziyang.mes.basedata.service;

import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
public interface ISpMaterileService extends IService<SpMaterile> {

    /**
     * 生成下一个物料编码 M000001、M000002...
     */
    String nextMaterielCode();

    /**
     * 物料编码是否重复（排除已删除，编辑时排除自身）
     */
    boolean isMaterielCodeDuplicate(String materiel, String excludeId);
}
