package com.wangziyang.mes.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.common.util.TreeUtil;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.mapper.SysDepartmentMapper;
import com.wangziyang.mes.system.service.ISysDepartmentService;
import com.wangziyang.mes.system.vo.TreeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 部门管理 服务实现类
 *
 * @author SongPeng
 * @since 2020-03-03
 */
@Service
public class SysDepartmentServiceImpl extends ServiceImpl<SysDepartmentMapper, SysDepartment>
        implements ISysDepartmentService {

    @Override
    public boolean isNameDuplicate(String name, String excludeId) {
        QueryWrapper<SysDepartment> qw = new QueryWrapper<>();
        qw.eq("name", name);
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }

    @Override
    public List<TreeVO<SysDepartment>> listDepartmentTree() {
        QueryWrapper<SysDepartment> qw = new QueryWrapper<>();
        qw.ne("is_deleted", "1");
        qw.orderByAsc("sort_num");
        List<SysDepartment> departments = list(qw);

        List<TreeVO<SysDepartment>> nodes = new ArrayList<>();
        for (SysDepartment dept : departments) {
            TreeVO<SysDepartment> tree = new TreeVO<>();
            tree.setId(dept.getId());
            tree.setPid(dept.getParentId());
            tree.setName(dept.getName());
            nodes.add(tree);
        }
        return TreeUtil.buildList(nodes, "0");
    }
}