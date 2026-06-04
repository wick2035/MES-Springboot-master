package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpTeamEmployee;

import java.util.List;
import java.util.Map;

public interface ISpTeamEmployeeService extends IService<SpTeamEmployee> {

    /**
     * 按班组分页查询成员（联表回显用户姓名/用户名）
     */
    IPage<SpTeamEmployee> pageByTeam(IPage<SpTeamEmployee> page, String teamId);

    /**
     * 批量把用户加入班组，跳过该班组已存在（未删除）的用户，实现「同班组不重复」
     *
     * @param teamId  班组ID
     * @param userIds 用户ID集合
     * @return 实际新增数量
     */
    int addMembers(String teamId, List<String> userIds);

    /**
     * 构建「部门 → 用户」树（layui tree 结构），用于用户选择弹窗
     */
    List<Map<String, Object>> buildUserDeptTree();
}
