package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpBomItem;
import com.wangziyang.mes.technology.entity.SpComponentDef;
import com.wangziyang.mes.technology.mapper.SpBomItemMapper;
import com.wangziyang.mes.technology.mapper.SpBomMapper;
import com.wangziyang.mes.technology.service.ISpBomItemService;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.service.ISpComponentDefService;
import com.wangziyang.mes.technology.vo.BomTreeNodeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * <p>
 *  BOM服务实现类
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-28
 */
@Service
public class SpBomServiceImpl extends ServiceImpl<SpBomMapper, SpBom> implements ISpBomService {

    private static final DateTimeFormatter DT_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Autowired
    private SpBomItemMapper bomItemMapper;

    @Autowired
    private ISpBomItemService bomItemService;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ISpComponentDefService componentDefService;

    @Autowired
    private ISpMaterileService materileService;

    // ===== BOM树构建 =====

    @Override
    public BomTreeNodeVO buildBomTree(String bomId, Set<String> visitedIds) {
        if (visitedIds.contains(bomId)) {
            throw new IllegalStateException("BOM循环引用检测: bomId=" + bomId + " 已在当前路径中出现");
        }
        visitedIds.add(bomId);

        SpBom bom = getById(bomId);
        if (bom == null) return null;

        // 根节点：代表BOM对应的产品/组件本身
        BomTreeNodeVO root = new BomTreeNodeVO();
        root.setId("BOM_" + bomId);
        root.setPid(null);
        root.setMaterielCode(bom.getMaterielCode());
        root.setMaterielDesc(bom.getMaterielDesc());
        root.setNodeCode("0");
        root.setNodeType(bom.getBomLevel() != null && bom.getBomLevel() == 0 ? "产品" : "零部件");
        root.setLevel(0);
        root.setUpdateTime(fmt(bom.getUpdateTime()));
        root.setOpen(true);

        expandChildren(root, bomId, "BOM_" + bomId, 1, visitedIds);

        visitedIds.remove(bomId);
        return root;
    }

    /**
     * 递归展开指定BOM的子项，并作为 parentNode 的 children 填充
     * 严格三层限制：PART类型不递归
     */
    private void expandChildren(BomTreeNodeVO parentNode, String bomId,
                                String parentId, int level, Set<String> visitedIds) {
        List<SpBomItem> items = bomItemMapper.listByBomHeadId(bomId);

        for (SpBomItem item : items) {
            BomTreeNodeVO node = new BomTreeNodeVO();
            node.setId(item.getId());
            node.setPid(parentId);
            node.setMaterielCode(item.getMaterielItemCode());
            node.setMaterielDesc(item.getMaterielItemDesc());
            node.setItemNum(item.getItemNum());
            node.setItemUnit(item.getItemUnit());
            node.setOperTyper(item.getOperTyper());
            node.setLineNo(item.getLineNo());
            node.setMatType(item.getItemMatType());
            node.setChildBomId(item.getChildBomId());
            node.setLevel(level);
            node.setUpdateTime(fmt(item.getUpdateTime()));
            node.setOpen(true);

            boolean isPart = "PART".equals(item.getItemMatType());
            boolean hasChildBom = StringUtils.isNotEmpty(item.getChildBomId());

            if (!isPart && hasChildBom && visitedIds.contains(item.getChildBomId())) {
                throw new IllegalStateException("BOM循环引用检测: bomId=" + item.getChildBomId() + " 已在当前路径中出现");
            }

            if (!isPart && hasChildBom) {
                // 零部件节点：取子BOM编码作为节点编号
                SpBom childBom = getById(item.getChildBomId());
                node.setNodeCode(childBom != null ? childBom.getBomCode() : item.getMaterielItemCode());
                node.setNodeType("零部件");

                Set<String> childVisited = new HashSet<>(visitedIds);
                childVisited.add(item.getChildBomId());
                expandChildren(node, item.getChildBomId(), item.getId(), level + 1, childVisited);
                node.setHaveChild(!node.getChildren().isEmpty());
            } else {
                // 物料叶子节点：用物料编码作为节点编号
                node.setNodeCode(item.getMaterielItemCode());
                node.setNodeType("物料");
                node.setHaveChild(false);
            }

            parentNode.getChildren().add(node);
        }
        parentNode.setHaveChild(!parentNode.getChildren().isEmpty());
    }

    // ===== 其他业务方法 =====

    @Override
    public List<SpBom> listSelectableBoms(String itemMatType, String materielCode) {
        Integer bomLevel = null;
        String type = StringUtils.trimToEmpty(itemMatType);
        if ("PG".equals(type) || "半成品".equals(type)) {
            bomLevel = 1;
        } else if ("COMP".equals(type) || "组件".equals(type)) {
            bomLevel = 2;
        }
        String code = StringUtils.trimToNull(materielCode);
        List<SpBom> boms = baseMapper.listAvailableBoms(bomLevel, code);
        if (boms.isEmpty() && code != null) {
            boms = baseMapper.listAvailableBoms(bomLevel, null);
        }
        return boms;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveBomWithItems(SpBom spBom, String itemsJson) {
        // 定版保护
        if (StringUtils.isNotEmpty(spBom.getId())) {
            SpBom existing = getById(spBom.getId());
            if (existing != null && "locked".equals(existing.getLockStatus())) {
                throw new RuntimeException("该BOM已定版，无法修改");
            }
        }

        normalizeBom(spBom);
        List<SpBomItem> items = parseItems(itemsJson);
        validateBomHeader(spBom);
        validateItems(spBom, items, false);

        saveOrUpdate(spBom);

        bomItemService.remove(
                new QueryWrapper<SpBomItem>().eq("bom_head_id", spBom.getId())
        );

        if (!items.isEmpty()) {
            for (SpBomItem item : items) {
                item.setId(null);
                item.setBomHeadId(spBom.getId());
            }
            bomItemService.saveBatch(items);
        }
    }

    private List<SpBomItem> parseItems(String itemsJson) {
        if (StringUtils.isEmpty(itemsJson) || "[]".equals(itemsJson.trim())) {
            return java.util.Collections.emptyList();
        }
        try {
            return objectMapper.readValue(itemsJson, new TypeReference<List<SpBomItem>>() {});
        } catch (Exception e) {
            throw new RuntimeException("BOM子项JSON解析失败: " + e.getMessage(), e);
        }
    }

    private void normalizeBom(SpBom spBom) {
        spBom.setBomCode(StringUtils.trimToEmpty(spBom.getBomCode()));
        spBom.setMaterielCode(StringUtils.trimToEmpty(spBom.getMaterielCode()));
        spBom.setMaterielDesc(StringUtils.trimToEmpty(spBom.getMaterielDesc()));
        if (StringUtils.isEmpty(spBom.getVersionNumber())) {
            spBom.setVersionNumber("1");
        }
        if (StringUtils.isEmpty(spBom.getDeleted())) {
            spBom.setDeleted("0");
        }
        if (StringUtils.isEmpty(spBom.getLockStatus())) {
            spBom.setLockStatus("draft");
        }
        if (StringUtils.isEmpty(spBom.getValidity())) {
            spBom.setValidity("有效");
        }
        if (StringUtils.isEmpty(spBom.getState())) {
            spBom.setState("creat");
        }
    }

    private void validateBomHeader(SpBom spBom) {
        if (StringUtils.isEmpty(spBom.getBomCode())) {
            throw new RuntimeException("请输入BOM编码");
        }
        if (spBom.getBomLevel() == null || spBom.getBomLevel() < 0 || spBom.getBomLevel() > 2) {
            throw new RuntimeException("请选择正确的BOM层级");
        }
        if (StringUtils.isEmpty(spBom.getMaterielCode()) || StringUtils.isEmpty(spBom.getMaterielDesc())) {
            throw new RuntimeException("请选择BOM对应的物料或零部件");
        }
        QueryWrapper<SpBom> duplicateQw = new QueryWrapper<>();
        duplicateQw.eq("bom_code", spBom.getBomCode()).ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(spBom.getId())) {
            duplicateQw.ne("id", spBom.getId());
        }
        if (count(duplicateQw) > 0) {
            throw new RuntimeException("BOM编码已存在，请更换编码或新建版本");
        }
        if (spBom.getBomLevel() == 0) {
            SpMaterile materile = materileService.getOne(
                    new QueryWrapper<SpMaterile>()
                            .eq("materiel", spBom.getMaterielCode())
                            .ne("is_deleted", "1"),
                    false
            );
            if (materile == null || (!"FG".equals(materile.getMatType()) && !"PRODUCT".equals(materile.getMatType()))) {
                throw new RuntimeException("产品BOM必须对应成品或产品物料");
            }
            return;
        }

        String expectedType = spBom.getBomLevel() == 1 ? "PG" : "COMP";
        SpComponentDef component = getEnabledComponent(spBom.getMaterielCode(), spBom.getMaterielDesc(), expectedType);
        if (component == null) {
            throw new RuntimeException("半成品/组件BOM必须对应已启用的零部件定义");
        }
    }

    private void validateItems(SpBom spBom, List<SpBomItem> items, boolean locking) {
        if (items == null || items.isEmpty()) {
            if (locking) {
                throw new RuntimeException("BOM定版前至少需要维护一个子项");
            }
            return;
        }
        validateProductComponents(spBom, items);
        Set<String> itemKeys = new HashSet<>();
        for (SpBomItem item : items) {
            String itemCode = StringUtils.trimToEmpty(item.getMaterielItemCode());
            String itemName = StringUtils.trimToEmpty(item.getMaterielItemDesc());
            String itemType = StringUtils.trimToEmpty(item.getItemMatType());
            if (StringUtils.isEmpty(itemCode) || StringUtils.isEmpty(itemName)) {
                throw new RuntimeException("BOM子项存在未选择的物料或零部件");
            }
            if (StringUtils.isEmpty(itemType)) {
                throw new RuntimeException("BOM子项【" + itemName + "】缺少物料类型");
            }
            if (item.getItemNum() == null || item.getItemNum().compareTo(BigDecimal.ZERO) <= 0) {
                throw new RuntimeException("BOM子项【" + itemName + "】用量必须大于0");
            }
            String key = itemCode + "#" + itemType;
            if (!itemKeys.add(key)) {
                throw new RuntimeException("BOM子项【" + itemName + "】重复，请合并后再保存");
            }
            if (StringUtils.isNotEmpty(item.getChildBomId())) {
                validateChildBomForItem(item);
            }
            if (locking && ("PG".equals(itemType) || "COMP".equals(itemType))
                    && StringUtils.isEmpty(item.getChildBomId())) {
                throw new RuntimeException("零部件子项【" + itemName + "】定版前必须关联已定版的子BOM");
            }
        }
    }

    private void validateProductComponents(SpBom spBom, List<SpBomItem> items) {
        if (spBom.getBomLevel() == null || spBom.getBomLevel() != 0) {
            return;
        }
        String productName = StringUtils.trimToEmpty(spBom.getMaterielDesc());
        if (StringUtils.isEmpty(productName)) {
            throw new RuntimeException("请先填写产品名称，再创建产品BOM");
        }
        if (!componentDefService.hasEnabledComponents(productName)) {
            throw new RuntimeException("产品【" + productName + "】尚未定义启用的零部件，请先在零部件定义中维护");
        }
        if (items == null || items.isEmpty()) {
            throw new RuntimeException("产品BOM至少需要选择一个已定义的零部件");
        }
        for (SpBomItem item : items) {
            String itemType = item.getItemMatType();
            String itemCode = StringUtils.trimToEmpty(item.getMaterielItemCode());
            String itemName = StringUtils.trimToEmpty(item.getMaterielItemDesc());
            if (!"PG".equals(itemType) && !"COMP".equals(itemType)) {
                throw new RuntimeException("产品BOM子项【" + itemName + "】必须是已定义的半成品或组件");
            }
            if (!componentDefService.isEnabledForProduct(productName, itemCode, itemName)) {
                throw new RuntimeException("产品【" + productName + "】的BOM子项【" + itemName + "】尚未在零部件定义中启用");
            }
        }
    }

    private void validateChildBomForItem(SpBomItem item) {
        SpBom childBom = getById(item.getChildBomId());
        String itemName = StringUtils.defaultIfEmpty(item.getMaterielItemDesc(), item.getMaterielItemCode());
        if (childBom == null || "1".equals(childBom.getDeleted())) {
            throw new RuntimeException("子项【" + itemName + "】关联的子BOM不存在");
        }
        if (!"locked".equals(childBom.getLockStatus())
                || !"pass".equals(childBom.getState())
                || !"有效".equals(childBom.getValidity())) {
            throw new RuntimeException("子项【" + itemName + "】只能关联已定版且有效的子BOM");
        }
        Integer expectedLevel = "PG".equals(item.getItemMatType()) ? 1 : ("COMP".equals(item.getItemMatType()) ? 2 : null);
        if (expectedLevel == null) {
            throw new RuntimeException("只有半成品或组件子项可以关联子BOM");
        }
        if (!expectedLevel.equals(childBom.getBomLevel())) {
            throw new RuntimeException("子项【" + itemName + "】关联的子BOM层级不匹配");
        }
        if (!StringUtils.equals(childBom.getMaterielCode(), item.getMaterielItemCode())) {
            throw new RuntimeException("子项【" + itemName + "】关联的子BOM物料编码不一致");
        }
    }

    private SpComponentDef getEnabledComponent(String componentCode, String componentName, String componentType) {
        QueryWrapper<SpComponentDef> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (StringUtils.isNotEmpty(componentType)) {
            qw.eq("component_type", componentType);
        }
        qw.and(w -> {
            if (StringUtils.isNotEmpty(componentCode)) {
                w.eq("component_code", componentCode);
            }
            if (StringUtils.isNotEmpty(componentName)) {
                if (StringUtils.isNotEmpty(componentCode)) {
                    w.or();
                }
                w.eq("component_name", componentName);
            }
        });
        return componentDefService.getOne(qw.last("limit 1"), false);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void lockBom(String bomId) {
        SpBom bom = getById(bomId);
        if (bom == null) throw new RuntimeException("BOM不存在");
        if ("locked".equals(bom.getLockStatus())) throw new RuntimeException("该BOM已定版，无法重复操作");
        if ("1".equals(bom.getDeleted())) throw new RuntimeException("已删除的BOM无法定版");

        List<SpBomItem> items = bomItemMapper.listByBomHeadId(bomId);
        validateBomHeader(bom);
        validateItems(bom, items, true);
        ensureNoCycle(bomId, new HashSet<>());

        bom.setLockStatus("locked");
        bom.setState("pass");
        bom.setValidity("有效");
        if (StringUtils.isEmpty(bom.getDeleted())) {
            bom.setDeleted("0");
        }
        updateById(bom);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteBom(String bomId) {
        SpBom bom = getById(bomId);
        if (bom == null) {
            throw new RuntimeException("BOM不存在");
        }
        if ("locked".equals(bom.getLockStatus())) {
            throw new RuntimeException("该BOM已定版，无法删除");
        }
        bom.setDeleted("1");
        updateById(bom);
    }

    private void ensureNoCycle(String bomId, Set<String> visiting) {
        if (!visiting.add(bomId)) {
            throw new RuntimeException("BOM存在循环引用，无法定版");
        }
        List<SpBomItem> items = bomItemMapper.listByBomHeadId(bomId);
        for (SpBomItem item : items) {
            if (StringUtils.isNotEmpty(item.getChildBomId())) {
                ensureNoCycle(item.getChildBomId(), new HashSet<>(visiting));
            }
        }
    }

    private String fmt(LocalDateTime dt) {
        return dt != null ? dt.format(DT_FMT) : "";
    }
}
