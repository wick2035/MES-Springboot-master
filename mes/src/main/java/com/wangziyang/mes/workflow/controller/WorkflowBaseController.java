package com.wangziyang.mes.workflow.controller;

import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.workflow.WorkflowPermissionUtil;
import org.apache.commons.lang3.StringUtils;

import java.util.List;

public class WorkflowBaseController extends BaseController {

    protected SysUser currentUser() {
        try {
            return getSysUser();
        } catch (Exception ignore) {
            return null;
        }
    }

    protected boolean currentUserIsAdmin() {
        return WorkflowPermissionUtil.isSuperAdmin(currentUser());
    }

    protected boolean hasRole(String roleCode) {
        if (StringUtils.isBlank(roleCode)) {
            return false;
        }
        for (String code : currentRoleCodes()) {
            if (StringUtils.equals(code, roleCode)) {
                return true;
            }
        }
        return false;
    }

    protected List<String> currentRoleCodes() {
        return WorkflowPermissionUtil.roleCodes(currentUser());
    }
}
