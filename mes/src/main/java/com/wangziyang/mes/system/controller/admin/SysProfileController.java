package com.wangziyang.mes.system.controller.admin;

import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysDepartmentService;
import com.wangziyang.mes.system.service.ISysUserService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.stream.Collectors;

/**
 * 个人中心：基本资料 / 修改密码
 * <p>
 * 仅作用于「当前登录用户自己」，与后台用户管理（SysUserController）区分开。
 *
 * @author ruiyao
 * @since 2026-06-05
 */
@Controller("adminSysProfileController")
@RequestMapping("/admin/sys/profile")
public class SysProfileController extends BaseController {

    Logger logger = LoggerFactory.getLogger(SysProfileController.class);

    @Autowired
    private ISysUserService sysUserService;

    @Autowired
    private ISysDepartmentService sysDepartmentService;

    /**
     * 基本资料页面
     */
    @GetMapping("/setting-ui")
    public String settingUI(Model model) {
        SysUser principal = getSysUser();
        SysUser user = sysUserService.getById(principal.getId());
        model.addAttribute("result", user);

        // 部门名（仅展示，容错）
        String deptName = "";
        if (user != null && StringUtils.isNotEmpty(user.getDeptId())) {
            SysDepartment dept = sysDepartmentService.getById(user.getDeptId());
            if (dept != null) {
                deptName = dept.getName();
            }
        }
        model.addAttribute("deptName", deptName);

        // 注册时间（仅取日期，避免模板格式化 java.time 的坑）
        String joinDate = "";
        if (user != null && user.getCreateTime() != null) {
            joinDate = user.getCreateTime().toLocalDate().toString();
        }
        model.addAttribute("joinDate", joinDate);

        // 角色名（取自登录态主体，多个用「、」拼接）
        model.addAttribute("roleNames", resolveRoleNames(principal));
        return "admin/system/profile/setting";
    }

    /**
     * 保存基本资料（白名单字段，强制为当前登录用户，禁止越权改用户名/密码/状态/角色）
     */
    @PostMapping("/update")
    @ResponseBody
    public Result update(SysUser record) {
        SysUser current = getSysUser();
        SysUser update = new SysUser();
        update.setId(current.getId());
        update.setName(record.getName());
        update.setEmail(record.getEmail());
        update.setMobile(record.getMobile());
        update.setTel(record.getTel());
        update.setSex(record.getSex());
        // birthday 在库中是 datetime 列：空串会触发 Data truncation，置 null 由 MyBatis-Plus 跳过该列
        update.setBirthday(StringUtils.isBlank(record.getBirthday()) ? null : record.getBirthday());
        update.setDescr(record.getDescr());
        update.setPicId(record.getPicId());
        sysUserService.updateById(update);
        return Result.success(update.getName(), "保存成功");
    }

    /**
     * 修改密码页面
     */
    @GetMapping("/password-ui")
    public String passwordUI() {
        return "admin/system/profile/password";
    }

    /**
     * 修改密码：校验原密码 → 校验新密码 → 写入新哈希 → 注销当前会话（前端跳回登录）
     */
    @PostMapping("/change-password")
    @ResponseBody
    public Result changePassword(@RequestParam String oldPassword, @RequestParam String newPassword) {
        if (StringUtils.isBlank(oldPassword) || StringUtils.isBlank(newPassword)) {
            return Result.failure("请填写完整的密码信息");
        }
        SysUser current = getSysUser();
        // 取库内最新数据进行比对，避免登录态快照过期
        SysUser db = sysUserService.getById(current.getId());
        if (db == null) {
            return Result.failure("账号不存在");
        }
        // 与登录/重置一致：Md5Hash(password, username, 3)
        String oldHash = new Md5Hash(oldPassword, db.getUsername(), 3).toString();
        if (!oldHash.equals(db.getPassword())) {
            return Result.failure("原密码不正确");
        }
        if (newPassword.length() < 6) {
            return Result.failure("新密码长度不能少于 6 位");
        }
        if (newPassword.equals(oldPassword)) {
            return Result.failure("新密码不能与原密码相同");
        }

        SysUser update = new SysUser();
        update.setId(db.getId());
        update.setPassword(new Md5Hash(newPassword, db.getUsername(), 3).toString());
        sysUserService.updateById(update);

        // 密码已变更，注销当前会话，强制重新登录
        try {
            SecurityUtils.getSubject().logout();
        } catch (Exception e) {
            logger.warn("修改密码后注销会话失败", e);
        }
        return Result.success("密码修改成功，请重新登录");
    }

    /**
     * 拼接当前用户的角色名
     */
    private String resolveRoleNames(SysUser principal) {
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
}
