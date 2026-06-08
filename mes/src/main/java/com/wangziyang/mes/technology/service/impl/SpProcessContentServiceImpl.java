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

import java.util.ArrayList;
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
        ensureRouteBoundOper(routeId);
        SpProcessContent existing = getOne(new QueryWrapper<SpProcessContent>().eq("route_id", routeId));
        if (existing != null) return existing;
        SpProcessContent c = new SpProcessContent();
        c.setRouteId(routeId);
        c.setNeedCheck("Y");
        save(c);
        return c;
    }

    private SpProcessRoute ensureRouteBoundOper(String routeId) {
        SpProcessRoute r = routeMapper.selectById(routeId);
        if (r == null) throw new RuntimeException("工艺记录不存在");
        if (StringUtils.isEmpty(r.getOperId())) {
            throw new RuntimeException("请先在工艺路线中绑定工序，再编制工艺内容");
        }
        return r;
    }

    private void checkNotLocked(String routeId) {
        SpProcessRoute r = ensureRouteBoundOper(routeId);
        if ("completed".equals(r.getEditStatus())) {
            throw new RuntimeException("当前工序已完成编制并锁定，不能再编辑");
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
        validateBeforeComplete(routeId);
        SpProcessRoute r = routeMapper.selectById(routeId);
        r.setEditStatus("completed");
        routeMapper.updateById(r);
    }

    private void validateBeforeComplete(String routeId) {
        SpProcessRoute r = ensureRouteBoundOper(routeId);
        if ("completed".equals(r.getEditStatus())) {
            throw new RuntimeException("当前工序已完成编制并锁定，不能重复提交");
        }

        SpProcessContent content = getOne(new QueryWrapper<SpProcessContent>().eq("route_id", routeId));
        List<String> missing = new ArrayList<>();
        if (content == null) {
            missing.add("工序内容");
            missing.add("工序要求");
            missing.add("注意事项");
            missing.add("技术文档");
        } else {
            if (StringUtils.isBlank(content.getContentText())) missing.add("工序内容");
            if (StringUtils.isBlank(content.getRequireText())) missing.add("工序要求");
            if (StringUtils.isBlank(content.getPrecautionText())) missing.add("注意事项");
            if (StringUtils.isBlank(content.getTechDocDesc())) missing.add("技术文档描述");
            if ("Y".equals(content.getNeedCheck()) && countFiles(routeId, "REQ_IMG") == 0) {
                missing.add("检验标准图片");
            }
        }
        if (countFiles(routeId, "CONTENT_IMG") == 0) missing.add("工序图片");
        if (countFiles(routeId, "PREC_IMG") == 0) missing.add("注意事项图示");
        if (countFiles(routeId, "TECH_IMG") == 0) missing.add("技术文档图片");
        if (countFiles(routeId, "TECH_ATTACH") == 0) missing.add("技术文件附件");
        if (listEquipments(routeId).isEmpty()) missing.add("工装设备");
        if (listMaterials(routeId).isEmpty()) missing.add("备料清单");

        if (!missing.isEmpty()) {
            throw new RuntimeException("请先补全以下信息：" + StringUtils.join(missing, "、"));
        }
    }

    private int countFiles(String routeId, String fileType) {
        return fileMapper.selectCount(new QueryWrapper<SpProcessFile>()
                .eq("route_id", routeId)
                .eq("file_type", fileType));
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
        SpProcessFile file = fileMapper.selectById(fileId);
        if (file != null) {
            checkNotLocked(file.getRouteId());
        }
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
