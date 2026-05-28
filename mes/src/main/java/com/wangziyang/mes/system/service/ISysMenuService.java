package com.wangziyang.mes.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.system.dto.SysMenuDTO;
import com.wangziyang.mes.system.entity.SysMenu;
import com.wangziyang.mes.system.vo.TreeVO;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author SongPeng
 * @since 2019-10-16
 */
public interface ISysMenuService extends IService<SysMenu> {


    /**
     * 根据角色id查询菜单列表
     *
     * @param roleId
     * @return
     * @throws Exception
     */
    List<SysMenuDTO> listByRoleId(String roleId) throws Exception;

    /**
     * 系统首页初始化菜单树数据
     *
     * @return 系统首页初始化菜单树数据
     * @throws Exception 异常
     */
    Map<String, Object> listIndexMenuTree() throws Exception;


    /**
     * 用户搜索系统首页初始化菜单树数据
     *
     * @return 系统首页初始化菜单树数据
     * @throws Exception 异常
     */
    Map<String, Object> listIndexMenuSearchTree(String menuName) throws Exception;


    /**
     * 获取系统菜单树
     *
     * @return 系统菜单树
     * @throws Exception 异常
     */
    List<TreeVO<SysMenu>> listMenuTree() throws Exception;

    /**
     * 获取带角色勾选状态的菜单树（用于授权菜单弹窗）
     *
     * @param roleId 角色ID
     * @return 所有菜单树，已授权菜单 checked=true
     * @throws Exception 异常
     */
    List<TreeVO<SysMenu>> listMenuTreeWithRoleCheck(String roleId) throws Exception;

    /**
     * 根据允许的菜单ID集合构建导航菜单树（用于角色菜单过滤）
     *
     * @param allowedMenuIds 当前用户有权的菜单ID集合
     * @return 过滤后的导航菜单树数据
     * @throws Exception 异常
     */
    Map<String, Object> listIndexMenuTreeByRoleMenuIds(Set<String> allowedMenuIds) throws Exception;
}
