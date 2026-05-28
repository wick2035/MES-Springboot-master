package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpBomItem;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.entity.SpProcessRoute;
import com.wangziyang.mes.technology.mapper.SpBomItemMapper;
import com.wangziyang.mes.technology.mapper.SpBomMapper;
import com.wangziyang.mes.technology.mapper.SpProcessRouteMapper;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.service.ISpProcessRouteService;
import com.wangziyang.mes.technology.vo.ProcessRouteNodeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 工艺流程服务实现
 *
 * @author Claude
 * @since 2026-05-28
 */
@Service
public class SpProcessRouteServiceImpl extends ServiceImpl<SpProcessRouteMapper, SpProcessRoute>
        implements ISpProcessRouteService {

    private static final String NGY_PREFIX = "NGY_3_";

    @Autowired
    private SpBomMapper bomMapper;
    @Autowired
    private SpBomItemMapper bomItemMapper;
    @Autowired
    private ISpOperService operService;
    @Autowired
    private ISpProcessingUnitService unitService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int initRoutes(String bomId) {
        SpBom bom = bomMapper.selectById(bomId);
        if (bom == null) throw new RuntimeException("BOM不存在");
        if (!"locked".equals(bom.getLockStatus())) {
            throw new RuntimeException("请先锁定BOM再初始化工艺流程");
        }
        if (isLocked(bomId)) {
            throw new RuntimeException("该BOM的工艺规划已锁定，不能重新初始化");
        }

        // 清空旧的非锁定记录
        remove(new QueryWrapper<SpProcessRoute>().eq("bom_id", bomId));

        // 根节点
        String rootCode = NGY_PREFIX + bom.getMaterielCode();
        SpProcessRoute rootRoute = newRoute(bomId, null, rootCode, null,
                bom.getMaterielDesc(), bom.getMaterielCode(), 30);
        save(rootRoute);

        // 递归子节点
        int created = 1 + expand(bomId, rootRoute.getId(), rootCode, new HashSet<>(Collections.singleton(bomId)));
        return created;
    }

    /** 递归生成 bom 的所有子项 route */
    private int expand(String bomId, String parentRouteId, String parentCode, Set<String> visited) {
        List<SpBomItem> items = bomItemMapper.listByBomHeadId(bomId);
        int count = 0;
        int seq = 1;
        for (SpBomItem item : items) {
            boolean isPart = "PART".equals(item.getItemMatType());
            boolean hasChildBom = StringUtils.isNotEmpty(item.getChildBomId());
            // 只对非PART(有子BOM)节点生成 route，因为PART是直接物料叶子，无装配工序
            if (isPart || !hasChildBom) {
                continue;
            }
            String code = parentCode + "_" + String.format("%03d", seq);
            SpProcessRoute r = newRoute(bomId, item.getId(), code, parentRouteId,
                    item.getMaterielItemDesc(), item.getMaterielItemCode(), seq * 30);
            save(r);
            count++;
            seq++;

            // 递归子BOM
            if (!visited.contains(item.getChildBomId())) {
                Set<String> nextVisited = new HashSet<>(visited);
                nextVisited.add(item.getChildBomId());
                count += expand(item.getChildBomId(), r.getId(), code, nextVisited);
            }
        }
        return count;
    }

    private SpProcessRoute newRoute(String bomId, String bomItemId, String code,
                                    String parentRouteId, String nodeName, String materielCode, int seq) {
        SpProcessRoute r = new SpProcessRoute();
        r.setBomId(bomId);
        r.setBomItemId(bomItemId);
        r.setRouteCode(code);
        r.setParentRouteId(parentRouteId);
        r.setNodeName(nodeName);
        r.setMaterielCode(materielCode);
        r.setSeqNo(seq);
        r.setLockStatus("draft");
        r.setEditStatus("pending");
        r.setDeleted("0");
        return r;
    }

    @Override
    public ProcessRouteNodeVO getRouteTree(String bomId) {
        List<SpProcessRoute> routes = listByBomId(bomId);
        if (routes.isEmpty()) return null;

        // 工序缓存
        Set<String> operIds = new HashSet<>();
        for (SpProcessRoute r : routes) {
            if (StringUtils.isNotEmpty(r.getOperId())) operIds.add(r.getOperId());
        }
        Map<String, SpOper> operMap = new HashMap<>();
        Map<String, SpProcessingUnit> unitMap = new HashMap<>();
        if (!operIds.isEmpty()) {
            for (SpOper o : operService.listByIds(operIds)) operMap.put(o.getId(), o);
            Set<String> unitIds = new HashSet<>();
            for (SpOper o : operMap.values()) {
                if (StringUtils.isNotEmpty(o.getUnitId())) unitIds.add(o.getUnitId());
            }
            if (!unitIds.isEmpty()) {
                for (SpProcessingUnit u : unitService.listByIds(unitIds)) unitMap.put(u.getId(), u);
            }
        }

        Map<String, ProcessRouteNodeVO> idMap = new HashMap<>();
        ProcessRouteNodeVO root = null;
        for (SpProcessRoute r : routes) {
            ProcessRouteNodeVO vo = toVO(r, operMap, unitMap);
            idMap.put(r.getId(), vo);
            if (r.getParentRouteId() == null) root = vo;
        }
        for (SpProcessRoute r : routes) {
            if (r.getParentRouteId() != null) {
                ProcessRouteNodeVO parent = idMap.get(r.getParentRouteId());
                if (parent != null) {
                    parent.getChildren().add(idMap.get(r.getId()));
                    parent.setHaveChild(true);
                }
            }
        }
        // 同级按 seq_no 排序
        for (ProcessRouteNodeVO vo : idMap.values()) {
            if (!vo.getChildren().isEmpty()) {
                vo.getChildren().sort(Comparator.comparing(ProcessRouteNodeVO::getSeqNo));
            }
        }
        return root;
    }

    private ProcessRouteNodeVO toVO(SpProcessRoute r,
                                    Map<String, SpOper> operMap,
                                    Map<String, SpProcessingUnit> unitMap) {
        ProcessRouteNodeVO vo = new ProcessRouteNodeVO();
        vo.setId(r.getId());
        vo.setPid(r.getParentRouteId());
        vo.setRouteId(r.getId());
        vo.setRouteCode(r.getRouteCode());
        vo.setNodeName("(" + r.getRouteCode() + ") " + (r.getNodeName() != null ? r.getNodeName() : ""));
        vo.setMaterielCode(r.getMaterielCode());
        vo.setBomItemId(r.getBomItemId());
        vo.setOperId(r.getOperId());
        vo.setSeqNo(r.getSeqNo());
        vo.setLockStatus(r.getLockStatus());
        vo.setEditStatus(r.getEditStatus());
        if (StringUtils.isNotEmpty(r.getOperId())) {
            SpOper o = operMap.get(r.getOperId());
            if (o != null) {
                vo.setOperCode(o.getOper());
                vo.setOperName(o.getOperDesc());
                vo.setOperHours(o.getOperHours() != null ? o.getOperHours().toPlainString() : "");
                vo.setManuCycle(o.getManuCycle() != null ? o.getManuCycle().toPlainString() : "");
                vo.setGenPlan(o.getGenPlan());
                if (StringUtils.isNotEmpty(o.getUnitId())) {
                    SpProcessingUnit u = unitMap.get(o.getUnitId());
                    if (u != null) {
                        vo.setUnitName(u.getUnitName());
                        vo.setUnitTypeName("device".equals(u.getUnitType()) ? "设备作业单元" : "人员作业单元");
                    }
                }
            }
        }
        return vo;
    }

    @Override
    public List<SpProcessRoute> listByBomId(String bomId) {
        QueryWrapper<SpProcessRoute> qw = new QueryWrapper<>();
        qw.eq("bom_id", bomId).eq("is_deleted", "0").orderByAsc("seq_no");
        return list(qw);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void bindOper(String routeId, String operId) {
        SpProcessRoute r = getById(routeId);
        if (r == null) throw new RuntimeException("工艺记录不存在");
        if ("locked".equals(r.getLockStatus())) throw new RuntimeException("该工艺已锁定，不能修改");
        r.setOperId(operId);
        updateById(r);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void lockAll(String bomId) {
        List<SpProcessRoute> routes = listByBomId(bomId);
        if (routes.isEmpty()) throw new RuntimeException("尚未初始化工艺流程");
        for (SpProcessRoute r : routes) {
            // 允许工序为空也可锁定（PDF未明确要求全部绑定）
            r.setLockStatus("locked");
        }
        updateBatchById(routes);
    }

    @Override
    public boolean isLocked(String bomId) {
        QueryWrapper<SpProcessRoute> qw = new QueryWrapper<>();
        qw.eq("bom_id", bomId).eq("lock_status", "locked").last("limit 1");
        return getOne(qw) != null;
    }

}
