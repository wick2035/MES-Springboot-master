package com.wangziyang.mes.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.system.entity.SysRoleMenu;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author SongPeng
 * @since 2020-03-05
 */
public interface ISysRoleMenuService extends IService<SysRoleMenu> {

    /**
     * 重建角色菜单关联关系：先清除旧关联，再批量插入新关联
     *
     * @param roleId  角色ID
     * @param menuIds 菜单ID数组
     */
    void rebuildByRoleId(String roleId, String[] menuIds) throws Exception;
}
