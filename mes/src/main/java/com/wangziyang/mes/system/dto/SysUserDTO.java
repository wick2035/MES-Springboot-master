package com.wangziyang.mes.system.dto;

import com.wangziyang.mes.system.entity.SysUser;

import java.util.List;

/**
 * @author SongPeng
 * @date 2019/9/30 9:49
 */
public class SysUserDTO extends SysUser {

    private static final long serialVersionUID = 1L;

    /**
     * 角色ID列表
     */
    private String[] sysRoleIds;

    /**
     * 确认密码，仅用于表单校验
     */
    private String repassword;

    /**
     * 角色列表
     */
    private List<SysRoleDTO> sysRoleDTOs;

    public List<SysRoleDTO> getSysRoleDTOs() {
        return sysRoleDTOs;
    }

    public void setSysRoleDTOs(List<SysRoleDTO> sysRoleDTOs) {
        this.sysRoleDTOs = sysRoleDTOs;
    }

    public String[] getSysRoleIds() {
        return sysRoleIds;
    }

    public void setSysRoleIds(String[] sysRoleIds) {
        this.sysRoleIds = sysRoleIds;
    }

    public String getRepassword() {
        return repassword;
    }

    public void setRepassword(String repassword) {
        this.repassword = repassword;
    }
}
