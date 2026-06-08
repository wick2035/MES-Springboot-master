package com.wangziyang.mes.system.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.entity.SysRole;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.entity.SysUserRole;
import com.wangziyang.mes.system.request.SysUserPageReq;
import com.wangziyang.mes.system.service.ISysDepartmentService;
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
import java.util.regex.Pattern;

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

    @Autowired
    private ISysDepartmentService sysDepartmentService;

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9_.@-]{3,32}$");
    private static final Pattern MOBILE_PATTERN = Pattern.compile("^1[3-9]\\d{9}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$");
    private static final Pattern TEL_PATTERN = Pattern.compile("^[0-9+\\-()]{6,20}$");
    private static final Pattern ID_CARD_PATTERN = Pattern.compile("(^\\d{15}$)|(^\\d{17}[\\dXx]$)");
    private static final Pattern BIRTHDAY_PATTERN = Pattern.compile("^\\d{4}-\\d{2}-\\d{2}$");

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

        // 一次性查询所有用户的部门名称
        Set<String> deptIds = records.stream()
                .map(SysUser::getDeptId).filter(StringUtils::isNotEmpty).collect(Collectors.toSet());
        Map<String, String> deptNameMap = new HashMap<>();
        if (!deptIds.isEmpty()) {
            for (SysDepartment dept : sysDepartmentService.listByIds(deptIds)) {
                deptNameMap.put(dept.getId(), dept.getName());
            }
        }

        List<Map<String, Object>> rows = new ArrayList<>();
        for (SysUser u : records) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", u.getId());
            m.put("name", u.getName());
            m.put("username", u.getUsername());
            m.put("deptId", u.getDeptId());
            m.put("deptName", deptNameMap.getOrDefault(u.getDeptId(), ""));
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
        List<SysDepartment> departments = sysDepartmentService.list(
                new QueryWrapper<SysDepartment>().ne("is_deleted", "1").orderByAsc("sort_num"));
        List<SysRoleDTO> sysRoles = sysRoleService.listByUserId(record.getId());
        model.addAttribute("departments", departments);
        model.addAttribute("sysRoles", sysRoles);
        return "admin/system/user/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysUserDTO record) throws Exception {
        String error = validateAndNormalize(record);
        if (StringUtils.isNotEmpty(error)) {
            return Result.failure(error);
        }

        error = validateDuplicate(record);
        if (StringUtils.isNotEmpty(error)) {
            return Result.failure(error);
        }

        if (StringUtils.isEmpty(record.getId())) {
            sysUserService.save(record);
        } else {
            sysUserService.update(record);
        }
        return Result.success(record.getId());
    }

    private String validateAndNormalize(SysUserDTO record) {
        record.setId(StringUtils.trimToNull(record.getId()));
        record.setName(StringUtils.trimToEmpty(record.getName()));
        record.setUsername(StringUtils.trimToEmpty(record.getUsername()));
        record.setPassword(StringUtils.trimToEmpty(record.getPassword()));
        record.setRepassword(StringUtils.trimToEmpty(record.getRepassword()));
        record.setDeptId(StringUtils.trimToEmpty(record.getDeptId()));
        record.setEmail(StringUtils.trimToEmpty(record.getEmail()));
        record.setMobile(StringUtils.trimToEmpty(record.getMobile()));
        record.setTel(StringUtils.trimToEmpty(record.getTel()));
        record.setSex(StringUtils.trimToEmpty(record.getSex()));
        record.setBirthday(StringUtils.trimToNull(record.getBirthday()));
        record.setPicId(StringUtils.trimToEmpty(record.getPicId()));
        record.setIdCard(StringUtils.trimToEmpty(record.getIdCard()));
        record.setHobby(StringUtils.trimToEmpty(record.getHobby()));
        record.setProvince(StringUtils.trimToEmpty(record.getProvince()));
        record.setCity(StringUtils.trimToEmpty(record.getCity()));
        record.setDistrict(StringUtils.trimToEmpty(record.getDistrict()));
        record.setStreet(StringUtils.trimToEmpty(record.getStreet()));
        record.setStreetNumber(StringUtils.trimToEmpty(record.getStreetNumber()));
        record.setDescr(StringUtils.trimToEmpty(record.getDescr()));
        record.setDeleted(StringUtils.defaultIfBlank(record.getDeleted(), "0"));

        if (StringUtils.isEmpty(record.getName())) return "姓名不能为空";
        if (StringUtils.length(record.getName()) > 64) return "姓名不能超过64位";
        if (!USERNAME_PATTERN.matcher(record.getUsername()).matches()) {
            return "用户名需为3-32位，可包含字母、数字、下划线、点、@或-";
        }
        if (record.getPassword().length() < 6 || record.getPassword().length() > 64) return "密码长度需为6-64位";
        if (!StringUtils.equals(record.getPassword(), record.getRepassword())) return "两次输入的密码不一致";
        if (!MOBILE_PATTERN.matcher(record.getMobile()).matches()) return "手机号必须是11位中国大陆手机号";
        if (StringUtils.isNotEmpty(record.getEmail()) && !EMAIL_PATTERN.matcher(record.getEmail()).matches()) {
            return "邮箱格式不正确";
        }
        if (StringUtils.isNotEmpty(record.getTel()) && !TEL_PATTERN.matcher(record.getTel()).matches()) {
            return "固定电话格式不正确";
        }
        if (StringUtils.isNotEmpty(record.getBirthday()) && !BIRTHDAY_PATTERN.matcher(record.getBirthday()).matches()) {
            return "出生日期格式应为 yyyy-MM-dd";
        }
        if (StringUtils.isNotEmpty(record.getIdCard()) && !ID_CARD_PATTERN.matcher(record.getIdCard()).matches()) {
            return "身份证号需为15位或18位，18位末位可为X";
        }
        if (!Arrays.asList("0", "1", "2").contains(record.getSex())) return "请选择正确的性别";
        if (!Arrays.asList("0", "2").contains(record.getDeleted())) return "请选择正确的用户状态";
        if (StringUtils.isNotEmpty(record.getDeptId())) {
            SysDepartment department = sysDepartmentService.getById(record.getDeptId());
            if (department == null || StringUtils.equals(department.getIsDeleted(), "1")) return "请选择有效的部门";
        }
        return null;
    }

    private String validateDuplicate(SysUserDTO record) {
        QueryWrapper<SysUser> usernameQw = new QueryWrapper<SysUser>().eq("username", record.getUsername());
        if (StringUtils.isNotEmpty(record.getId())) usernameQw.ne("id", record.getId());
        if (sysUserService.count(usernameQw) > 0) return "用户名已存在";

        QueryWrapper<SysUser> mobileQw = new QueryWrapper<SysUser>().eq("mobile", record.getMobile());
        if (StringUtils.isNotEmpty(record.getId())) mobileQw.ne("id", record.getId());
        if (sysUserService.count(mobileQw) > 0) return "手机号已存在";

        return null;
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
