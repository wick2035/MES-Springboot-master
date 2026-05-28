package com.wangziyang.mes.system.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysRole;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.entity.SysUserRole;
import com.wangziyang.mes.system.request.SysUserPageReq;
import com.wangziyang.mes.system.service.ISysRoleService;
import com.wangziyang.mes.system.service.ISysUserRoleService;
import com.wangziyang.mes.system.service.ISysUserService;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 系统用户管理控制器
 *
 * @author SongPeng
 * @since 2019-10-15
 */
@Controller("adminSysUserController")
@RequestMapping("/admin/sys/user")
public class SysUserController extends BaseController {

    Logger logger = LoggerFactory.getLogger(SysUserController.class);

    @Autowired
    private ISysUserService sysUserService;

    @Autowired
    private ISysRoleService sysRoleService;

    @Autowired
    private ISysUserRoleService sysUserRoleService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/user/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SysUserPageReq req) throws Exception {
        QueryWrapper<SysUser> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getNameLike())) qw.likeRight("name", req.getNameLike());
        if (StringUtils.isNotEmpty(req.getUsernameLike())) qw.likeRight("username", req.getUsernameLike());
        qw.orderByDesc(req.getOrderBy());
        IPage<SysUser> page = sysUserService.page(req, qw);

        List<SysUser> records = page.getRecords();
        if (records == null || records.isEmpty()) return Result.success(page);

        // 一次性查询所有用户的角色关联，再按用户分组
        List<String> userIds = records.stream().map(SysUser::getId).collect(Collectors.toList());
        List<SysUserRole> userRoles = sysUserRoleService.list(
                new QueryWrapper<SysUserRole>().in("user_id", userIds));
        Set<String> roleIds = userRoles.stream().map(SysUserRole::getRoleId).collect(Collectors.toSet());
        Map<String, String> roleNameMap = new HashMap<>();
        if (!roleIds.isEmpty()) {
            for (SysRole r : sysRoleService.listByIds(roleIds)) {
                roleNameMap.put(r.getId(), r.getName());
            }
        }
        Map<String, List<String>> userRolesMap = new HashMap<>();
        for (SysUserRole ur : userRoles) {
            String name = roleNameMap.get(ur.getRoleId());
            if (name == null) continue;
            userRolesMap.computeIfAbsent(ur.getUserId(), k -> new ArrayList<>()).add(name);
        }

        List<Map<String, Object>> rows = new ArrayList<>();
        for (SysUser u : records) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", u.getId());
            m.put("name", u.getName());
            m.put("username", u.getUsername());
            m.put("deptId", u.getDeptId());
            m.put("email", u.getEmail());
            m.put("mobile", u.getMobile());
            m.put("sex", u.getSex());
            m.put("deleted", u.getDeleted());
            m.put("updateTime", u.getUpdateTime());
            List<String> roleNames = userRolesMap.getOrDefault(u.getId(), Collections.emptyList());
            m.put("roleNames", String.join("、", roleNames));
            rows.add(m);
        }
        Map<String, Object> data = new HashMap<>();
        data.put("records", rows);
        data.put("total", page.getTotal());
        data.put("size", page.getSize());
        data.put("current", page.getCurrent());
        return Result.success(data);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(SysUser record, Model model) throws Exception {
        if (StringUtils.isNotEmpty(record.getId())) {
            SysUser result = sysUserService.getById(record.getId());
            model.addAttribute("result", result);
        }
        List<SysRoleDTO> sysRoles = sysRoleService.listByUserId(record.getId());
        model.addAttribute("sysRoles", sysRoles);
        return "admin/system/user/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysUserDTO record) throws Exception {
        if (StringUtils.isEmpty(record.getId())) {
            sysUserService.save(record);
        } else {
            sysUserService.update(record);
        }
        return Result.success(record.getId());
    }

    // ========== 分配角色 ==========

    @GetMapping("/assign-role-ui")
    public String assignRoleUI(@RequestParam String userId, Model model) throws Exception {
        SysUser user = sysUserService.getById(userId);
        model.addAttribute("user", user);
        // 全部角色
        List<SysRole> allRoles = sysRoleService.list(
                new QueryWrapper<SysRole>().ne("is_deleted", "1").orderByAsc("sort_num"));
        // 已选角色ID
        Set<String> checkedIds = sysUserRoleService.list(
                new QueryWrapper<SysUserRole>().eq("user_id", userId))
                .stream().map(SysUserRole::getRoleId).collect(Collectors.toSet());
        model.addAttribute("allRoles", allRoles);
        model.addAttribute("checkedIds", checkedIds);
        return "admin/system/user/assignRole";
    }

    @PostMapping("/assign-role")
    @ResponseBody
    public Result assignRole(@RequestParam String userId,
                             @RequestParam(required = false) String[] roleIds) {
        sysUserRoleService.remove(new QueryWrapper<SysUserRole>().eq("user_id", userId));
        if (roleIds != null) {
            for (String roleId : roleIds) {
                if (StringUtils.isEmpty(roleId)) continue;
                SysUserRole ur = new SysUserRole();
                ur.setUserId(userId);
                ur.setRoleId(roleId);
                sysUserRoleService.save(ur);
            }
        }
        return Result.success("分配角色成功");
    }

    // ========== 重置密码 ==========

    @PostMapping("/reset-password")
    @ResponseBody
    public Result resetPassword(@RequestParam String id,
                                @RequestParam(defaultValue = "123456") String newPassword) {
        SysUser user = sysUserService.getById(id);
        if (user == null) return Result.failure("用户不存在");
        // 与 SysUserServiceImpl.save 使用同一算法：Md5Hash(password, username, 3)
        String hashed = new Md5Hash(newPassword, user.getUsername(), 3).toString();
        SysUser update = new SysUser();
        update.setId(id);
        update.setPassword(hashed);
        sysUserService.updateById(update);
        return Result.success("密码已重置为 " + newPassword);
    }

    // ========== 启用/禁用 ==========

    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        SysUser update = new SysUser();
        update.setId(id);
        update.setDeleted(status);
        sysUserService.updateById(update);
        return Result.success();
    }

    // ========== 软删除 ==========

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        SysUser update = new SysUser();
        update.setId(id);
        update.setDeleted("1");
        sysUserService.updateById(update);
        return Result.success();
    }
}
