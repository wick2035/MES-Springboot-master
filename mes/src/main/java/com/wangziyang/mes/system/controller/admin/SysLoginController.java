package com.wangziyang.mes.system.controller.admin;

import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.dto.SysMenuDTO;
import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysMenuService;
import com.wangziyang.mes.system.service.ISysUserService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 系统登录
 *
 * @author SongPeng
 * @date 2019/9/27 16:05
 */
@RequestMapping("/admin")
@Controller("adminSysLoginController")
public class SysLoginController extends BaseController {

    Logger logger = LoggerFactory.getLogger(SysLoginController.class);

    /**
     * 系统菜单 Service
     */
    @Autowired
    private ISysMenuService sysMenuService;

    /**
     * 系统用户 Service
     */
    @Autowired
    private ISysUserService sysUserService;

    /**
     * 后台管理首页
     *
     * @param model
     * @return
     */
    @GetMapping({"", "/index"})
    public String indexUI(Model model) {
        // 顶栏展示真实当前用户（姓名 / 头像 / 角色）
        SysUser principal = getSysUser();
        if (principal != null) {
            SysUser currentUser = sysUserService.getById(principal.getId());
            model.addAttribute("currentUser", currentUser != null ? currentUser : principal);
            model.addAttribute("roleName", resolveRoleName(principal));
        }
        return "admin/index";
    }

    /**
     * 拼接当前用户的角色名（取自登录态主体）
     */
    private String resolveRoleName(SysUser principal) {
        if (principal instanceof SysUserDTO) {
            SysUserDTO dto = (SysUserDTO) principal;
            if (CollectionUtils.isNotEmpty(dto.getSysRoleDTOs())) {
                return dto.getSysRoleDTOs().stream()
                        .map(SysRoleDTO::getName)
                        .filter(StringUtils::isNotEmpty)
                        .collect(Collectors.joining("、"));
            }
        }
        return "";
    }

    /**
     * 后台管理欢迎页
     *
     * @param model
     * @return
     */
    @ApiOperation("后台管理欢迎页")
    @GetMapping("/welcome-ui")
    public String welcomeUI(Model model) {
        return "admin/welcome";
    }

    /**
     * 系统首页初始化菜单树数据
     * @return 菜单树数据
     * @throws Exception 异常
     */
    @ApiOperation("系统首页初始化菜单树数据")
    @GetMapping("/list/index/menu/tree")
    @ResponseBody
    public Result tree() throws Exception {
        SysUserDTO user = (SysUserDTO) SecurityUtils.getSubject().getPrincipal();
        // 超级管理员(admin角色)或无角色分配时，返回全量菜单保持兼容
        if (CollectionUtils.isEmpty(user.getSysRoleDTOs())) {
            return Result.success(sysMenuService.listIndexMenuTree());
        }
        boolean isAdmin = user.getSysRoleDTOs().stream()
                .anyMatch(r -> "admin".equals(r.getCode()));
        if (isAdmin) {
            return Result.success(sysMenuService.listIndexMenuTree());
        }
        // 收集当前用户所有角色下已授权的菜单ID
        Set<String> allowedMenuIds = new HashSet<>();
        for (SysRoleDTO role : user.getSysRoleDTOs()) {
            if (CollectionUtils.isNotEmpty(role.getSysMenuDtos())) {
                for (SysMenuDTO menu : role.getSysMenuDtos()) {
                    allowedMenuIds.add(menu.getId());
                }
            }
        }
        Map<String, Object> result = sysMenuService.listIndexMenuTreeByRoleMenuIds(allowedMenuIds);
        return Result.success(result);
    }

    /**
     * 用户搜索系统首页初始化菜单树数据
     * @param menuName 菜单名字
     * @return 菜单树数据
     * @throws Exception 异常
     */
    @ApiOperation("系统首页初始化菜单树数据")
    @GetMapping("/list/index/menu/search/tree/{menuName}")
    @ResponseBody
    public Result searchTree(@PathVariable String menuName) throws Exception {
        Map<String, Object> result = sysMenuService.listIndexMenuSearchTree(menuName);
        return Result.success(result);
    }

}
