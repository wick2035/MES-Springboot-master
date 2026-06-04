package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpTeamEmployee;
import com.wangziyang.mes.basedata.mapper.SpTeamEmployeeMapper;
import com.wangziyang.mes.basedata.service.ISpTeamEmployeeService;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysDepartmentService;
import com.wangziyang.mes.system.service.ISysUserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class SpTeamEmployeeServiceImpl extends ServiceImpl<SpTeamEmployeeMapper, SpTeamEmployee>
        implements ISpTeamEmployeeService {

    @Autowired
    private ISysDepartmentService sysDepartmentService;

    @Autowired
    private ISysUserService sysUserService;

    @Override
    public IPage<SpTeamEmployee> pageByTeam(IPage<SpTeamEmployee> page, String teamId) {
        return baseMapper.pageByTeam(page, teamId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addMembers(String teamId, List<String> userIds) {
        if (StringUtils.isEmpty(teamId) || userIds == null || userIds.isEmpty()) {
            return 0;
        }
        // 该班组下已存在（未删除）的用户，用于去重——满足「同班组不重复」
        QueryWrapper<SpTeamEmployee> qw = new QueryWrapper<>();
        qw.eq("team_id", teamId).eq("is_deleted", "0");
        List<SpTeamEmployee> exists = list(qw);
        Set<String> existUserIds = new HashSet<>();
        for (SpTeamEmployee e : exists) {
            existUserIds.add(e.getUserId());
        }

        List<SpTeamEmployee> toAdd = new ArrayList<>();
        Set<String> batchSeen = new HashSet<>();
        for (String userId : userIds) {
            if (StringUtils.isEmpty(userId) || existUserIds.contains(userId) || batchSeen.contains(userId)) {
                continue;
            }
            batchSeen.add(userId);
            SpTeamEmployee record = new SpTeamEmployee();
            record.setTeamId(teamId);
            record.setUserId(userId);
            record.setDeleted("0");
            toAdd.add(record);
        }
        if (!toAdd.isEmpty()) {
            saveBatch(toAdd);
        }
        return toAdd.size();
    }

    @Override
    public List<Map<String, Object>> buildUserDeptTree() {
        // 1. 加载未删除部门（按 sort_num）
        QueryWrapper<SysDepartment> deptQw = new QueryWrapper<>();
        deptQw.eq("is_deleted", "0").orderByAsc("sort_num");
        List<SysDepartment> depts = sysDepartmentService.list(deptQw);

        // 2. 加载未删除用户
        QueryWrapper<SysUser> userQw = new QueryWrapper<>();
        userQw.eq("is_deleted", "0").orderByAsc("username");
        List<SysUser> users = sysUserService.list(userQw);

        // 3. 部门节点，保持加载顺序
        Map<String, Map<String, Object>> deptNodeMap = new LinkedHashMap<>();
        for (SysDepartment d : depts) {
            Map<String, Object> node = new LinkedHashMap<>();
            node.put("id", d.getId());
            node.put("title", d.getName());
            node.put("isUser", false);
            node.put("spread", true);
            node.put("children", new ArrayList<Map<String, Object>>());
            deptNodeMap.put(d.getId(), node);
        }

        // 4. 用户挂到所属部门；无法匹配部门的用户收集到「未分配部门」
        List<Map<String, Object>> orphanUsers = new ArrayList<>();
        for (SysUser u : users) {
            Map<String, Object> userNode = buildUserNode(u);
            Map<String, Object> deptNode = StringUtils.isNotEmpty(u.getDeptId()) ? deptNodeMap.get(u.getDeptId()) : null;
            if (deptNode != null) {
                childrenOf(deptNode).add(userNode);
            } else {
                orphanUsers.add(userNode);
            }
        }

        // 5. 组装部门层级（root：parentId 为空/'0'，或父部门不存在）
        List<Map<String, Object>> roots = new ArrayList<>();
        for (SysDepartment d : depts) {
            Map<String, Object> node = deptNodeMap.get(d.getId());
            String parentId = d.getParentId();
            Map<String, Object> parentNode = StringUtils.isNotEmpty(parentId) ? deptNodeMap.get(parentId) : null;
            if (parentNode != null && !parentNode.equals(node)) {
                childrenOf(parentNode).add(node);
            } else {
                roots.add(node);
            }
        }

        // 6. 未分配部门
        if (!orphanUsers.isEmpty()) {
            Map<String, Object> orphanNode = new LinkedHashMap<>();
            orphanNode.put("id", "dept_unassigned");
            orphanNode.put("title", "未分配部门");
            orphanNode.put("isUser", false);
            orphanNode.put("spread", true);
            orphanNode.put("children", orphanUsers);
            roots.add(orphanNode);
        }

        return roots;
    }

    private Map<String, Object> buildUserNode(SysUser u) {
        Map<String, Object> node = new LinkedHashMap<>();
        // 用户节点 id 前缀避免与部门 id 冲突
        node.put("id", "u_" + u.getId());
        String title = StringUtils.isNotEmpty(u.getName()) ? u.getName() : u.getUsername();
        node.put("title", title);
        node.put("isUser", true);
        node.put("userId", u.getId());
        node.put("username", u.getUsername());
        node.put("name", u.getName());
        return node;
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> childrenOf(Map<String, Object> node) {
        return (List<Map<String, Object>>) node.get("children");
    }
}
