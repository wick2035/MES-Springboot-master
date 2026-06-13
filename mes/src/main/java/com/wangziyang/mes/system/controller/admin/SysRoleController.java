package com.wangziyang.mes.system.controller.admin;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysRole;
import com.wangziyang.mes.system.entity.SysUserRole;
import com.wangziyang.mes.system.request.SysRolePageReq;
import com.wangziyang.mes.system.service.ISysMenuService;
import com.wangziyang.mes.system.service.ISysRoleMenuService;
import com.wangziyang.mes.system.service.ISysRoleService;
import com.wangziyang.mes.system.service.ISysUserRoleService;
import com.wangziyang.mes.system.service.ISysUserService;
import com.wangziyang.mes.system.vo.TreeVO;
import com.wangziyang.mes.system.entity.SysMenu;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 角色管理控制器
 */
@Controller("adminSysRoleController")
@RequestMapping("/admin/sys/role")
public class SysRoleController extends BaseController {

    @Autowired
    private ISysRoleService sysRoleService;

    @Autowired
    private ISysMenuService sysMenuService;

    @Autowired
    private ISysRoleMenuService sysRoleMenuService;

    @Autowired
    private ISysUserRoleService sysUserRoleService;

    @Autowired
    private ISysUserService sysUserService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/role/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SysRolePageReq req) {
        QueryWrapper<SysRole> qw = new QueryWrapper<>();
        // 已删除的角色不再展示（is_deleted: 0正常 / 1删除 / 2禁用）
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.likeRight("name", req.getNameLike());
        }
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.likeRight("code", req.getCodeLike());
        }
        qw.orderByAsc("sort_num");
        qw.orderByDesc(req.getOrderBy());
        IPage result = sysRoleService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysRole record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SysRole result = sysRoleService.getById(record.getId());
            model.addAttribute("result", result);
        }
        return "admin/system/role/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysRole record) {
        sysRoleService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    /** 软删除 */
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        SysRole role = new SysRole();
        role.setId(id);
        role.setDeleted("1");
        sysRoleService.updateById(role);
        return Result.success();
    }

    /** 禁用/启用切换 */
    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        SysRole role = new SysRole();
        role.setId(id);
        role.setDeleted(status);
        sysRoleService.updateById(role);
        return Result.success();
    }

    // ========== 授权菜单 ==========

    @GetMapping("/auth-menu-ui")
    public String authMenuUI(@RequestParam String roleId, Model model) throws Exception {
        List<TreeVO<SysMenu>> menuTree = sysMenuService.listMenuTreeWithRoleCheck(roleId);
        model.addAttribute("roleId", roleId);
        model.addAttribute("menuTree", menuTree);
        return "admin/system/role/authMenu";
    }

    @PostMapping("/auth-menu")
    @ResponseBody
    public Result authMenu(@RequestParam String roleId,
                           @RequestParam(required = false) String[] menuIds) throws Exception {
        sysRoleMenuService.rebuildByRoleId(roleId, menuIds);
        return Result.success();
    }

    // ========== 数据权限 ==========

    @GetMapping("/data-scope-ui")
    public String dataScopeUI(@RequestParam String roleId, Model model) {
        SysRole role = sysRoleService.getById(roleId);
        model.addAttribute("result", role);
        return "admin/system/role/dataScope";
    }

    @PostMapping("/data-scope")
    @ResponseBody
    public Result dataScope(SysRole record) {
        SysRole update = new SysRole();
        update.setId(record.getId());
        update.setDataScope(record.getDataScope());
        update.setBusinessScope(record.getBusinessScope());
        sysRoleService.updateById(update);
        return Result.success();
    }

    // ========== 分配用户 ==========

    @GetMapping("/assign-user-ui")
    public String assignUserUI(@RequestParam String roleId, Model model) {
        model.addAttribute("roleId", roleId);
        return "admin/system/role/assignUser";
    }

    /** 查询已分配该角色的用户（分页） */
    @PostMapping("/assign-user/page")
    @ResponseBody
    public Result assignUserPage(@RequestParam String roleId,
                                 @RequestParam(defaultValue = "1") Integer current,
                                 @RequestParam(defaultValue = "10") Integer size) {
        QueryWrapper<SysUserRole> qw = new QueryWrapper<>();
        qw.eq("role_id", roleId);
        List<SysUserRole> userRoles = sysUserRoleService.list(qw);
        return Result.success(userRoles);
    }

    /** 批量给角色分配用户 */
    @PostMapping("/assign-user")
    @ResponseBody
    public Result assignUser(@RequestParam String roleId,
                             @RequestParam(required = false) String[] userIds) throws Exception {
        // 删除该角色的所有用户关联，再重建
        QueryWrapper<SysUserRole> delWrapper = new QueryWrapper<>();
        delWrapper.eq("role_id", roleId);
        sysUserRoleService.remove(delWrapper);

        if (userIds != null) {
            for (String userId : userIds) {
                if (StringUtils.isEmpty(userId)) continue;
                SysUserRole ur = new SysUserRole();
                ur.setUserId(userId);
                ur.setRoleId(roleId);
                sysUserRoleService.save(ur);
            }
        }
        return Result.success();
    }

    /** 给角色添加单个用户 */
    @PostMapping("/assign-user/add")
    @ResponseBody
    public Result assignUserAdd(@RequestParam String roleId, @RequestParam String userId) {
        QueryWrapper<SysUserRole> check = new QueryWrapper<>();
        check.eq("role_id", roleId).eq("user_id", userId);
        if (sysUserRoleService.count(check) == 0) {
            SysUserRole ur = new SysUserRole();
            ur.setUserId(userId);
            ur.setRoleId(roleId);
            sysUserRoleService.save(ur);
        }
        return Result.success();
    }

    /** 从角色移除单个用户 */
    @PostMapping("/assign-user/remove")
    @ResponseBody
    public Result assignUserRemove(@RequestParam String roleId, @RequestParam String userId) {
        QueryWrapper<SysUserRole> delWrapper = new QueryWrapper<>();
        delWrapper.eq("role_id", roleId).eq("user_id", userId);
        sysUserRoleService.remove(delWrapper);
        return Result.success();
    }
}
