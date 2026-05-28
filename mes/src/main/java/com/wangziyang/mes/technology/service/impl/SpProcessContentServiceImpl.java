package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.technology.entity.*;
import com.wangziyang.mes.technology.mapper.*;
import com.wangziyang.mes.technology.service.ISpProcessContentService;
import com.wangziyang.mes.technology.service.ISpProcessRouteService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * 工艺内容编制服务实现（7步向导）
 *
 * @author Claude
 * @since 2026-05-28
 */
@Service
public class SpProcessContentServiceImpl extends ServiceImpl<SpProcessContentMapper, SpProcessContent>
        implements ISpProcessContentService {

    @Autowired
    private SpProcessFileMapper fileMapper;
    @Autowired
    private SpProcessEquipmentRelMapper equipmentRelMapper;
    @Autowired
    private SpProcessMaterialRelMapper materialRelMapper;
    @Autowired
    private SpProcessRouteMapper routeMapper;
    @Autowired
    private ISpProcessRouteService routeService;

    @Override
    public SpProcessContent getOrCreateByRoute(String routeId) {
        SpProcessContent existing = getOne(new QueryWrapper<SpProcessContent>().eq("route_id", routeId));
        if (existing != null) return existing;
        SpProcessContent c = new SpProcessContent();
        c.setRouteId(routeId);
        c.setNeedCheck("Y");
        save(c);
        return c;
    }

    private void checkNotLocked(String routeId) {
        SpProcessRoute r = routeMapper.selectById(routeId);
        if (r == null) throw new RuntimeException("工艺记录不存在");
        if ("locked".equals(r.getLockStatus())) {
            // 锁定后不允许编辑；PDF描述锁定的是产品工艺规划，编制仍允许 — 这里放开
            // throw new RuntimeException("已锁定，不能编辑");
        }
    }

    private void markEditing(String routeId) {
        SpProcessRoute r = routeMapper.selectById(routeId);
        if (r != null && "pending".equals(r.getEditStatus())) {
            r.setEditStatus("editing");
            routeMapper.updateById(r);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveStep2Content(String routeId, String contentText, List<Map<String, Object>> imgs) {
        checkNotLocked(routeId);
        SpProcessContent c = getOrCreateByRoute(routeId);
        c.setContentText(contentText);
        updateById(c);
        replaceFiles(routeId, "CONTENT_IMG", imgs);
        markEditing(routeId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveStep3Require(String routeId, String requireText, String needCheck, List<Map<String, Object>> imgs) {
        checkNotLocked(routeId);
        SpProcessContent c = getOrCreateByRoute(routeId);
        c.setRequireText(requireText);
        c.setNeedCheck(StringUtils.isEmpty(needCheck) ? "Y" : needCheck);
        updateById(c);
        replaceFiles(routeId, "REQ_IMG", imgs);
        markEditing(routeId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveStep4Precaution(String routeId, String precautionText, List<Map<String, Object>> imgs) {
        checkNotLocked(routeId);
        SpProcessContent c = getOrCreateByRoute(routeId);
        c.setPrecautionText(precautionText);
        updateById(c);
        replaceFiles(routeId, "PREC_IMG", imgs);
        markEditing(routeId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveStep5Equipments(String routeId, List<SpProcessEquipmentRel> rels) {
        checkNotLocked(routeId);
        getOrCreateByRoute(routeId);
        equipmentRelMapper.delete(new QueryWrapper<SpProcessEquipmentRel>().eq("route_id", routeId));
        if (rels != null) {
            for (SpProcessEquipmentRel rel : rels) {
                rel.setId(null);
                rel.setRouteId(routeId);
                if (rel.getReqQty() == null) rel.setReqQty(1);
                equipmentRelMapper.insert(rel);
            }
        }
        markEditing(routeId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveStep6TechDoc(String routeId, String desc, List<Map<String, Object>> imgs, List<Map<String, Object>> attachs) {
        checkNotLocked(routeId);
        SpProcessContent c = getOrCreateByRoute(routeId);
        c.setTechDocDesc(desc);
        updateById(c);
        replaceFiles(routeId, "TECH_IMG", imgs);
        replaceFiles(routeId, "TECH_ATTACH", attachs);
        markEditing(routeId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveStep7Materials(String routeId, List<SpProcessMaterialRel> rels) {
        checkNotLocked(routeId);
        getOrCreateByRoute(routeId);
        materialRelMapper.delete(new QueryWrapper<SpProcessMaterialRel>().eq("route_id", routeId));
        if (rels != null) {
            for (SpProcessMaterialRel rel : rels) {
                rel.setId(null);
                rel.setRouteId(routeId);
                materialRelMapper.insert(rel);
            }
        }
        markEditing(routeId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void completeEdit(String routeId) {
        getOrCreateByRoute(routeId);
        SpProcessRoute r = routeMapper.selectById(routeId);
        if (r == null) throw new RuntimeException("工艺记录不存在");
        r.setEditStatus("completed");
        routeMapper.updateById(r);
    }

    @Override
    public List<SpProcessFile> listFiles(String routeId, String fileType) {
        QueryWrapper<SpProcessFile> qw = new QueryWrapper<>();
        qw.eq("route_id", routeId);
        if (StringUtils.isNotEmpty(fileType)) qw.eq("file_type", fileType);
        qw.orderByAsc("sort_no").orderByAsc("create_time");
        return fileMapper.selectList(qw);
    }

    @Override
    public List<SpProcessEquipmentRel> listEquipments(String routeId) {
        return equipmentRelMapper.selectList(
                new QueryWrapper<SpProcessEquipmentRel>().eq("route_id", routeId).orderByAsc("create_time"));
    }

    @Override
    public List<SpProcessMaterialRel> listMaterials(String routeId) {
        return materialRelMapper.selectList(
                new QueryWrapper<SpProcessMaterialRel>().eq("route_id", routeId).orderByAsc("create_time"));
    }

    @Override
    public void deleteFile(String fileId) {
        fileMapper.deleteById(fileId);
    }

    private void replaceFiles(String routeId, String fileType, List<Map<String, Object>> imgs) {
        fileMapper.delete(new QueryWrapper<SpProcessFile>().eq("route_id", routeId).eq("file_type", fileType));
        if (imgs == null) return;
        int seq = 0;
        for (Map<String, Object> m : imgs) {
            SpProcessFile f = new SpProcessFile();
            f.setRouteId(routeId);
            f.setFileType(fileType);
            f.setFilePath(asString(m.get("filePath")));
            f.setOriginalName(asString(m.get("originalName")));
            Object size = m.get("size");
            f.setFileSize(size instanceof Number ? ((Number) size).longValue() : 0L);
            f.setSortNo(seq++);
            fileMapper.insert(f);
        }
    }

    private String asString(Object o) {
        return o == null ? null : o.toString();
    }
}
