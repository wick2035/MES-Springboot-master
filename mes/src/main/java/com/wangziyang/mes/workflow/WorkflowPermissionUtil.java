package com.wangziyang.mes.workflow;

import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysUser;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;

public final class WorkflowPermissionUtil {

    private WorkflowPermissionUtil() {
    }

    public static boolean isSuperAdmin(SysUser user) {
        if (user == null) {
            return false;
        }
        if (StringUtils.equalsIgnoreCase(user.getUsername(), "admin")) {
            return true;
        }
        for (SysRoleDTO role : roles(user)) {
            String code = role.getCode();
            String name = role.getName();
            if (StringUtils.equals(code, WorkflowConstants.ROLE_ADMIN)
                    || StringUtils.equals(code, WorkflowConstants.ROLE_SUPER_ADMIN)
                    || StringUtils.equals(name, "超级管理员")
                    || StringUtils.equals(name, "系统管理员")) {
                return true;
            }
        }
        return false;
    }

    public static boolean hasRole(SysUser user, String roleCode) {
        if (StringUtils.isBlank(roleCode)) {
            return false;
        }
        for (SysRoleDTO role : roles(user)) {
            if (role != null && StringUtils.equals(roleCode, role.getCode())) {
                return true;
            }
        }
        return false;
    }

    public static List<String> roleCodes(SysUser user) {
        List<String> roleCodes = new ArrayList<>();
        for (SysRoleDTO role : roles(user)) {
            if (role != null && StringUtils.isNotBlank(role.getCode())) {
                roleCodes.add(role.getCode());
            }
        }
        return roleCodes;
    }

    public static boolean canApproveProduction(SysUser user) {
        return isSuperAdmin(user)
                || hasRole(user, WorkflowConstants.ROLE_PRODUCTION_MANAGER)
                || hasRole(user, WorkflowConstants.ROLE_WAREHOUSE_MANAGER);
    }

    private static List<SysRoleDTO> roles(SysUser user) {
        if (!(user instanceof SysUserDTO)) {
            return new ArrayList<>();
        }
        SysUserDTO dto = (SysUserDTO) user;
        return dto.getSysRoleDTOs() == null ? new ArrayList<>() : dto.getSysRoleDTOs();
    }
}
