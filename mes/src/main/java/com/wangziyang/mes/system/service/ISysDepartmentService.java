package com.wangziyang.mes.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.vo.TreeVO;

import java.util.List;

/**
 * 部门管理 服务类
 *
 * @author SongPeng
 * @since 2020-03-03
 */
public interface ISysDepartmentService extends IService<SysDepartment> {

    /**
     * 部门名称唯一性校验
     *
     * @param name      部门名称
     * @param excludeId 排除的部门ID（编辑时排除自身）
     * @return true=重复
     */
    boolean isNameDuplicate(String name, String excludeId);

    /**
     * 获取部门树（用于上级部门下拉选择等场景）
     *
     * @return 部门树列表
     */
    List<TreeVO<SysDepartment>> listDepartmentTree();
}