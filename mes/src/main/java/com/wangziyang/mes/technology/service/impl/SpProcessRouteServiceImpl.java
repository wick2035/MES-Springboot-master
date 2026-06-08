package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpBomItem;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.entity.SpProcessContent;
import com.wangziyang.mes.technology.entity.SpProcessEquipmentRel;
import com.wangziyang.mes.technology.entity.SpProcessFile;
import com.wangziyang.mes.technology.entity.SpProcessMaterialRel;
import com.wangziyang.mes.technology.entity.SpProcessRoute;
import com.wangziyang.mes.technology.mapper.SpBomItemMapper;
import com.wangziyang.mes.technology.mapper.SpBomMapper;
import com.wangziyang.mes.technology.mapper.SpProcessContentMapper;
import com.wangziyang.mes.technology.mapper.SpProcessEquipmentRelMapper;
import com.wangziyang.mes.technology.mapper.SpProcessFileMapper;
import com.wangziyang.mes.technology.mapper.SpProcessMaterialRelMapper;
import com.wangziyang.mes.technology.mapper.SpProcessRouteMapper;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.service.ISpProcessRouteService;
import com.wangziyang.mes.technology.vo.ProcessRouteNodeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 产品工艺流程服务实现。
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
    @Autowired
    private SpProcessContentMapper contentMapper;
    @Autowired
    private SpProcessFileMapper fileMapper;
    @Autowired
    private SpProcessEquipmentRelMapper equipmentRelMapper;
    @Autowired
    private SpProcessMaterialRelMapper materialRelMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int initRoutes(String bomId) {
        SpBom bom = bomMapper.selectById(bomId);
        if (bom == null) {
            throw new RuntimeException("BOM不存在");
        }
        if (!"locked".equals(bom.getLockStatus())) {
            throw new RuntimeException("请先锁定BOM再初始化工艺流程");
        }
        if (isLocked(bomId)) {
            throw new RuntimeException("该BOM的工艺规划已锁定，不能重新初始化");
        }

        String rootCode = NGY_PREFIX + bom.getMaterielCode();
        ensureNoLockedRouteCodeConflict(rootCode, bomId);
        clearDraftRoutes(bomId, rootCode);

        SpProcessRoute rootRoute = newRoute(bomId, null, rootCode, null,
                bom.getMaterielDesc(), bom.getMaterielCode(), 30);
        save(rootRoute);

        return 1 + expand(bomId, bomId, rootRoute.getId(), rootCode,
                new HashSet<>(Collections.singleton(bomId)));
    }

    private void ensureNoLockedRouteCodeConflict(String rootCode, String bomId) {
        int lockedCount = count(new QueryWrapper<SpProcessRoute>()
                .ne("bom_id", bomId)
                .eq("lock_status", "locked")
                .and(w -> w.eq("route_code", rootCode)
                        .or()
                        .likeRight("route_code", rootCode + "_")));
        if (lockedCount > 0) {
            throw new RuntimeException("已存在相同产品编码的锁定工艺规划，无法覆盖初始化");
        }
    }

    private void clearDraftRoutes(String bomId, String rootCode) {
        List<SpProcessRoute> oldRoutes = list(new QueryWrapper<SpProcessRoute>()
                .and(status -> status.ne("lock_status", "locked")
                        .or()
                        .isNull("lock_status")
                        .or()
                        .eq("lock_status", ""))
                .and(w -> w.eq("bom_id", bomId)
                        .or()
                        .eq("route_code", rootCode)
                        .or()
                        .likeRight("route_code", rootCode + "_")));
        if (oldRoutes.isEmpty()) {
            return;
        }

        List<String> routeIds = oldRoutes.stream().map(SpProcessRoute::getId).collect(Collectors.toList());
        contentMapper.delete(new QueryWrapper<SpProcessContent>().in("route_id", routeIds));
        fileMapper.delete(new QueryWrapper<SpProcessFile>().in("route_id", routeIds));
        equipmentRelMapper.delete(new QueryWrapper<SpProcessEquipmentRel>().in("route_id", routeIds));
        materialRelMapper.delete(new QueryWrapper<SpProcessMaterialRel>().in("route_id", routeIds));
        removeByIds(routeIds);
    }

    /**
     * 递归生成子BOM的可装配节点。所有节点的 bom_id 均保存为顶层产品BOM，便于一棵树查询。
     */
    private int expand(String ownerBomId, String currentBomId, String parentRouteId, String parentCode, Set<String> visited) {
        List<SpBomItem> items = bomItemMapper.listByBomHeadId(currentBomId);
        int count = 0;
        int seq = 1;
        for (SpBomItem item : items) {
            boolean isPart = "PART".equals(item.getItemMatType());
            boolean hasChildBom = StringUtils.isNotEmpty(item.getChildBomId());
            if (isPart) {
                continue;
            }

            String code = parentCode + "_" + String.format("%03d", seq);
            SpProcessRoute route = newRoute(ownerBomId, item.getId(), code, parentRouteId,
                    item.getMaterielItemDesc(), item.getMaterielItemCode(), seq * 30);
            save(route);
            count++;
            seq++;

            if (hasChildBom && !visited.contains(item.getChildBomId())) {
                Set<String> nextVisited = new HashSet<>(visited);
                nextVisited.add(item.getChildBomId());
                count += expand(ownerBomId, item.getChildBomId(), route.getId(), code, nextVisited);
            }
        }
        return count;
    }

    private SpProcessRoute newRoute(String bomId, String bomItemId, String code,
                                    String parentRouteId, String nodeName, String materielCode, int seq) {
        SpProcessRoute route = new SpProcessRoute();
        route.setBomId(bomId);
        route.setBomItemId(bomItemId);
        route.setRouteCode(code);
        route.setParentRouteId(parentRouteId);
        route.setNodeName(nodeName);
        route.setMaterielCode(materielCode);
        route.setSeqNo(seq);
        route.setLockStatus("draft");
        route.setEditStatus("pending");
        route.setDeleted("0");
        return route;
    }

    @Override
    public ProcessRouteNodeVO getRouteTree(String bomId) {
        List<SpProcessRoute> routes = listByBomId(bomId);
        if (routes.isEmpty()) {
            return null;
        }

        Set<String> operIds = new HashSet<>();
        for (SpProcessRoute route : routes) {
            if (StringUtils.isNotEmpty(route.getOperId())) {
                operIds.add(route.getOperId());
            }
        }

        Map<String, SpOper> operMap = new HashMap<>();
        Map<String, SpProcessingUnit> unitMap = new HashMap<>();
        if (!operIds.isEmpty()) {
            for (SpOper oper : operService.listByIds(operIds)) {
                operMap.put(oper.getId(), oper);
            }
            Set<String> unitIds = new HashSet<>();
            for (SpOper oper : operMap.values()) {
                if (StringUtils.isNotEmpty(oper.getUnitId())) {
                    unitIds.add(oper.getUnitId());
                }
            }
            if (!unitIds.isEmpty()) {
                for (SpProcessingUnit unit : unitService.listByIds(unitIds)) {
                    unitMap.put(unit.getId(), unit);
                }
            }
        }

        Map<String, ProcessRouteNodeVO> idMap = new HashMap<>();
        ProcessRouteNodeVO root = null;
        for (SpProcessRoute route : routes) {
            ProcessRouteNodeVO vo = toVO(route, operMap, unitMap);
            idMap.put(route.getId(), vo);
            if (StringUtils.isEmpty(route.getParentRouteId())) {
                root = vo;
            }
        }
        for (SpProcessRoute route : routes) {
            if (StringUtils.isNotEmpty(route.getParentRouteId())) {
                ProcessRouteNodeVO parent = idMap.get(route.getParentRouteId());
                ProcessRouteNodeVO child = idMap.get(route.getId());
                if (parent != null && child != null) {
                    parent.getChildren().add(child);
                    parent.setHaveChild(true);
                }
            }
        }
        for (ProcessRouteNodeVO vo : idMap.values()) {
            if (!vo.getChildren().isEmpty()) {
                vo.getChildren().sort(Comparator.comparing(ProcessRouteNodeVO::getSeqNo));
            }
        }
        return root;
    }

    private ProcessRouteNodeVO toVO(SpProcessRoute route,
                                    Map<String, SpOper> operMap,
                                    Map<String, SpProcessingUnit> unitMap) {
        ProcessRouteNodeVO vo = new ProcessRouteNodeVO();
        vo.setId(route.getId());
        vo.setPid(route.getParentRouteId());
        vo.setRouteId(route.getId());
        vo.setRouteCode(route.getRouteCode());
        vo.setNodeName("(" + route.getRouteCode() + ") " + StringUtils.defaultString(route.getNodeName()));
        vo.setMaterielCode(route.getMaterielCode());
        vo.setBomItemId(route.getBomItemId());
        vo.setOperId(route.getOperId());
        vo.setSeqNo(route.getSeqNo());
        vo.setLockStatus(route.getLockStatus());
        vo.setEditStatus(route.getEditStatus());

        if (StringUtils.isNotEmpty(route.getOperId())) {
            SpOper oper = operMap.get(route.getOperId());
            if (oper != null) {
                vo.setOperCode(oper.getOper());
                vo.setOperName(oper.getOperDesc());
                vo.setOperHours(oper.getOperHours() != null ? oper.getOperHours().toPlainString() : "");
                vo.setManuCycle(oper.getManuCycle() != null ? oper.getManuCycle().toPlainString() : "");
                vo.setGenPlan(oper.getGenPlan());
                if (StringUtils.isNotEmpty(oper.getUnitId())) {
                    SpProcessingUnit unit = unitMap.get(oper.getUnitId());
                    if (unit != null) {
                        vo.setUnitName(unit.getUnitName());
                        vo.setUnitTypeName("device".equals(unit.getUnitType()) ? "设备作业单元" : "人员作业单元");
                    }
                }
            }
        }
        return vo;
    }

    @Override
    public List<SpProcessRoute> listByBomId(String bomId) {
        QueryWrapper<SpProcessRoute> qw = new QueryWrapper<>();
        qw.eq("bom_id", bomId).eq("is_deleted", "0").orderByAsc("route_code");
        return list(qw);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void bindOper(String routeId, String operId) {
        SpProcessRoute route = getById(routeId);
        if (route == null) {
            throw new RuntimeException("工艺记录不存在");
        }
        if ("locked".equals(route.getLockStatus())) {
            throw new RuntimeException("该工艺已锁定，不能修改");
        }
        if (StringUtils.isEmpty(operId)) {
            throw new RuntimeException("请选择要绑定的工序");
        }
        if (operService.getById(operId) == null) {
            throw new RuntimeException("工序记录不存在");
        }
        route.setOperId(operId);
        updateById(route);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void lockAll(String bomId) {
        List<SpProcessRoute> routes = listByBomId(bomId);
        if (routes.isEmpty()) {
            throw new RuntimeException("尚未初始化工艺流程");
        }
        if (routes.stream().anyMatch(route -> "locked".equals(route.getLockStatus()))) {
            throw new RuntimeException("该BOM的工艺规划已锁定，不能重复锁定");
        }

        List<String> missingNodes = new ArrayList<>();
        for (SpProcessRoute route : routes) {
            if (StringUtils.isNotEmpty(route.getParentRouteId()) && StringUtils.isEmpty(route.getOperId())) {
                missingNodes.add(route.getNodeName());
            }
        }
        if (!missingNodes.isEmpty()) {
            throw new RuntimeException("以下工艺节点尚未绑定工序，无法锁定：" + StringUtils.join(missingNodes, "、"));
        }

        for (SpProcessRoute route : routes) {
            route.setLockStatus("locked");
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
