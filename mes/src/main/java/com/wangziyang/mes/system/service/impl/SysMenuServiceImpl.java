package com.wangziyang.mes.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.common.util.TreeUtil;
import com.wangziyang.mes.system.dto.SysMenuDTO;
import com.wangziyang.mes.system.entity.SysMenu;
import com.wangziyang.mes.system.mapper.SysMenuMapper;
import com.wangziyang.mes.system.service.ISysMenuService;
import com.wangziyang.mes.system.vo.TreeVO;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author SongPeng
 * @since 2019-10-16
 */
@Service
public class SysMenuServiceImpl extends ServiceImpl<SysMenuMapper, SysMenu> implements ISysMenuService {

    @Autowired
    private SysMenuMapper sysMenuMapper;

    /**
     * 根据角色id查询菜单列表
     *
     * @param roleId
     * @return
     * @throws Exception
     */
    @Override
    public List<SysMenuDTO> listByRoleId(String roleId) throws Exception {
        return sysMenuMapper.listByRoleId(roleId);
    }

    /**
     * 系统首页初始化菜单树数据
     *
     * @return 系统首页初始化菜单树数据
     * @throws Exception 异常
     */
    @Override
    public Map<String, Object> listIndexMenuTree() throws Exception {
        Map<String, Object> result = new LinkedHashMap<>(4);
        QueryWrapper queryWrapper = new QueryWrapper();
        queryWrapper.orderBy(true, true, "sort_num");
        List<SysMenu> sysMenus = sysMenuMapper.selectList(queryWrapper);

        Map<String, String> clearInfo = new HashMap<>(2);
        clearInfo.put("clearUrl", "json/clear.json");

        Map<String, String> homeInfo = new HashMap<>(4);
        homeInfo.put("name", "首页");
        homeInfo.put("icon", "fa fa-home");
        homeInfo.put("url", "admin/welcome-ui");

        Map<String, String> logoInfo = new HashMap<>(4);
        logoInfo.put("name", "");
        logoInfo.put("image", "/image/mes-logo1.png");
        logoInfo.put("textImage", "/image/mes-logo2.png");
        logoInfo.put("url", "");

        Map<String, Object> menuInfo = new LinkedHashMap<>(8);

        List<TreeVO<SysMenu>> menus = new ArrayList<>();
        for (SysMenu m : sysMenus) {
            TreeVO<SysMenu> tree = new TreeVO<>();
            tree.setId(m.getId());
            tree.setPid(m.getParentId());
            tree.setCode(m.getCode());
            tree.setName(m.getName());
            tree.setUrl(m.getUrl());
            tree.setIcon(m.getIcon());
            tree.setType(m.getType());
            tree.setPermission(m.getPermission());
            // TODO 是否需要更改？
            tree.setTarget("_self");
            menus.add(tree);
        }
        List<TreeVO<SysMenu>> treeVOS = TreeUtil.buildList(menus, "0");
        for (TreeVO<SysMenu> mTree : treeVOS) {
            menuInfo.put(mTree.getCode(), mTree);
        }

        result.put("clearInfo", clearInfo);
        result.put("homeInfo", homeInfo);
        result.put("logoInfo", logoInfo);
        result.put("menuInfo", menuInfo);

        return result;
    }

    /**
     * 用户搜索系统首页初始化菜单树数据
     * @param menuName 菜单名字
     * @return 菜单树数据
     * @throws Exception 异常
     */
    @Override
    public Map<String, Object> listIndexMenuSearchTree(String menuName) throws Exception {
        Map<String, Object> result = new LinkedHashMap<>(4);
        Map<String, Object> menuInfo = new LinkedHashMap<>(8);
        List<SysMenu> sysMenus = sysMenuMapper.listBySearchByName(menuName);
        List<TreeVO<SysMenu>> menus = new ArrayList<>();
        for (SysMenu m : sysMenus) {
            TreeVO<SysMenu> tree = new TreeVO<>();
            tree.setId(m.getId());
            tree.setPid(m.getParentId());
            tree.setCode(m.getCode());
            tree.setName(m.getName());
            tree.setUrl(m.getUrl());
            tree.setIcon(m.getIcon());
            tree.setType(m.getType());
            tree.setPermission(m.getPermission());
            // TODO 是否需要更改？
            tree.setTarget("_self");
            menus.add(tree);
        }
        List<TreeVO<SysMenu>> treeVOS = TreeUtil.buildList(menus, "0");
        for (TreeVO<SysMenu> mTree : treeVOS) {
            menuInfo.put(mTree.getCode(), mTree);
        }
        result.put("menuInfo", menuInfo);
        return result;
    }

    /**
     * 获取系统菜单树
     *
     * @return 系统菜单树
     * @throws Exception 异常
     */
    @Override
    public List<TreeVO<SysMenu>> listMenuTree() throws Exception {
        List<TreeVO<SysMenu>> menus = new ArrayList<>();
        List<SysMenu> sysMenus = sysMenuMapper.selectList(null);
        for (SysMenu m : sysMenus) {
            TreeVO<SysMenu> tree = new TreeVO<>();
            tree.setId(m.getId());
            tree.setPid(m.getParentId());
            tree.setCode(m.getCode());
            tree.setName(m.getName());
            tree.setUrl(m.getUrl());
            tree.setIcon(m.getIcon());
            tree.setType(m.getType());
            tree.setPermission(m.getPermission());
            menus.add(tree);
        }
        return TreeUtil.buildList(menus, "0");
    }

    @Override
    public List<TreeVO<SysMenu>> listMenuTreeWithRoleCheck(String roleId) throws Exception {
        List<SysMenuDTO> assignedMenus = sysMenuMapper.listByRoleId(roleId);
        Set<String> assignedIds = assignedMenus.stream()
                .map(SysMenuDTO::getId)
                .collect(Collectors.toSet());

        QueryWrapper<SysMenu> qw = new QueryWrapper<>();
        qw.orderByAsc("grade", "sort_num");
        List<SysMenu> allMenus = sysMenuMapper.selectList(qw);

        List<TreeVO<SysMenu>> menus = new ArrayList<>();
        for (SysMenu m : allMenus) {
            TreeVO<SysMenu> tree = new TreeVO<>();
            tree.setId(m.getId());
            tree.setPid(m.getParentId());
            tree.setCode(m.getCode());
            tree.setName(m.getName());
            tree.setUrl(m.getUrl());
            tree.setIcon(m.getIcon());
            tree.setType(m.getType());
            tree.setPermission(m.getPermission());
            tree.setChecked(assignedIds.contains(m.getId()));
            menus.add(tree);
        }
        return TreeUtil.buildList(menus, "0");
    }

    @Override
    public Map<String, Object> listIndexMenuTreeByRoleMenuIds(Set<String> allowedMenuIds) throws Exception {
        Map<String, Object> result = new LinkedHashMap<>(4);

        Map<String, String> clearInfo = new HashMap<>(2);
        clearInfo.put("clearUrl", "json/clear.json");

        Map<String, String> homeInfo = new HashMap<>(4);
        homeInfo.put("name", "首页");
        homeInfo.put("icon", "fa fa-home");
        homeInfo.put("url", "admin/welcome-ui");

        Map<String, String> logoInfo = new HashMap<>(4);
        logoInfo.put("name", "");
        logoInfo.put("image", "/image/mes-logo1.png");
        logoInfo.put("textImage", "/image/mes-logo2.png");
        logoInfo.put("url", "");

        QueryWrapper<SysMenu> qw = new QueryWrapper<>();
        qw.orderByAsc("sort_num");
        List<SysMenu> allMenus = sysMenuMapper.selectList(qw);

        // 只保留目录节点(url为'#'或空)或已授权的菜单
        List<SysMenu> filteredMenus = new ArrayList<>();
        for (SysMenu m : allMenus) {
            String url = m.getUrl();
            boolean isDir = url == null || url.isEmpty() || "#".equals(url);
            if (isDir || allowedMenuIds.contains(m.getId())) {
                filteredMenus.add(m);
            }
        }

        Map<String, Object> menuInfo = new LinkedHashMap<>(8);
        List<TreeVO<SysMenu>> menus = new ArrayList<>();
        for (SysMenu m : filteredMenus) {
            TreeVO<SysMenu> tree = new TreeVO<>();
            tree.setId(m.getId());
            tree.setPid(m.getParentId());
            tree.setCode(m.getCode());
            tree.setName(m.getName());
            tree.setUrl(m.getUrl());
            tree.setIcon(m.getIcon());
            tree.setType(m.getType());
            tree.setPermission(m.getPermission());
            tree.setTarget("_self");
            menus.add(tree);
        }
        List<TreeVO<SysMenu>> treeVOS = TreeUtil.buildList(menus, "0");
        for (TreeVO<SysMenu> mTree : treeVOS) {
            // 递归剔除"没有任何已授权叶子菜单"的空目录分支：
            // 目录节点(url='#')会因 isDir 始终通过上面的过滤，若其子菜单
            // 全部被权限过滤掉，就会沦为可点击的空叶子，点击后 iframe 加载
            // '#'(即当前首页)从而导致整页递归嵌套。这里递归裁掉这类分支。
            if (pruneEmptyDirs(mTree) && CollectionUtils.isNotEmpty(mTree.getChildren())) {
                menuInfo.put(mTree.getCode(), mTree);
            }
        }

        result.put("clearInfo", clearInfo);
        result.put("homeInfo", homeInfo);
        result.put("logoInfo", logoInfo);
        result.put("menuInfo", menuInfo);
        return result;
    }

    /**
     * 递归剔除空目录分支。
     * <p>
     * 目录节点(url 为空或'#')若过滤后没有任何子节点则应被移除；
     * 真实菜单(带 url 的叶子)始终保留。
     *
     * @param node 当前节点
     * @return 该节点是否应保留
     */
    private boolean pruneEmptyDirs(TreeVO<SysMenu> node) {
        List<TreeVO<SysMenu>> children = node.getChildren();
        if (CollectionUtils.isNotEmpty(children)) {
            Iterator<TreeVO<SysMenu>> it = children.iterator();
            while (it.hasNext()) {
                if (!pruneEmptyDirs(it.next())) {
                    it.remove();
                }
            }
        }
        String url = node.getUrl();
        boolean isDir = url == null || url.isEmpty() || "#".equals(url);
        if (isDir) {
            return CollectionUtils.isNotEmpty(node.getChildren());
        }
        return true;
    }
}
