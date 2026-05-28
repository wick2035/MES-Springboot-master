package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpBomItem;
import com.wangziyang.mes.technology.mapper.SpBomItemMapper;
import com.wangziyang.mes.technology.mapper.SpBomMapper;
import com.wangziyang.mes.technology.service.ISpBomItemService;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.vo.BomTreeNodeVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
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

            if (!isPart && hasChildBom && !visitedIds.contains(item.getChildBomId())) {
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
    public List<SpBom> listSelectableBoms(String itemMatType) {
        Integer bomLevel = null;
        if ("PG".equals(itemMatType)) {
            bomLevel = 1;
        } else if ("COMP".equals(itemMatType)) {
            bomLevel = 2;
        }
        return baseMapper.listAvailableBoms(bomLevel);
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

        saveOrUpdate(spBom);

        bomItemService.remove(
                new QueryWrapper<SpBomItem>().eq("bom_head_id", spBom.getId())
        );

        if (StringUtils.isNotEmpty(itemsJson) && !"[]".equals(itemsJson.trim())) {
            try {
                List<SpBomItem> items = objectMapper.readValue(
                        itemsJson, new TypeReference<List<SpBomItem>>() {}
                );
                for (SpBomItem item : items) {
                    item.setId(null);
                    item.setBomHeadId(spBom.getId());
                }
                if (!items.isEmpty()) {
                    bomItemService.saveBatch(items);
                }
            } catch (Exception e) {
                throw new RuntimeException("BOM子项JSON解析失败: " + e.getMessage(), e);
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void lockBom(String bomId) {
        SpBom bom = getById(bomId);
        if (bom == null) throw new RuntimeException("BOM不存在");
        if ("locked".equals(bom.getLockStatus())) throw new RuntimeException("该BOM已定版，无法重复操作");
        bom.setLockStatus("locked");
        updateById(bom);
    }

    private String fmt(LocalDateTime dt) {
        return dt != null ? dt.format(DT_FMT) : "";
    }
}
