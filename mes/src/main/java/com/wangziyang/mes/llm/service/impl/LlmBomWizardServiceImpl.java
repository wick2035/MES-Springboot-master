package com.wangziyang.mes.llm.service.impl;

import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.basedata.service.ISpWarehouseLocationService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.llm.service.ILlmBomWizardService;
import com.wangziyang.mes.order.service.ISpOrderOperAssignService;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.request.SpProductionOrderSaveReq;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.technology.dto.SpFlowDto;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpBomItem;
import com.wangziyang.mes.technology.entity.SpComponentDef;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.entity.SpFlowOperRelation;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.entity.SpProcessMaterialRel;
import com.wangziyang.mes.technology.entity.SpProcessRoute;
import com.wangziyang.mes.technology.mapper.SpBomItemMapper;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.service.ISpComponentDefService;
import com.wangziyang.mes.technology.service.ISpFlowOperRelationService;
import com.wangziyang.mes.technology.service.ISpFlowService;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.service.ISpProcessContentService;
import com.wangziyang.mes.technology.service.ISpProcessRouteService;
import com.wangziyang.mes.technology.vo.SpOperVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * AI 智能建模分步向导服务实现。
 *
 * 事务策略：每个步骤一个独立事务，步间不做跨步回滚——
 * 物料/工序/工艺路线均为可复用主数据，失败重试时靠匹配逻辑自动复用，不会重复创建。
 */
@Service
public class LlmBomWizardServiceImpl implements ILlmBomWizardService {

    private static final Logger log = LoggerFactory.getLogger(LlmBomWizardServiceImpl.class);

    @Autowired
    private ISpMaterileService materileService;

    @Autowired
    private ISpComponentDefService componentDefService;

    @Autowired
    private ISpOperService operService;

    @Autowired
    private ISpProcessingUnitService unitService;

    @Autowired
    private ISpFlowService flowService;

    @Autowired
    private ISpFlowOperRelationService flowOperRelationService;

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @Autowired
    private ISpOrderOperAssignService assignService;

    @Autowired
    private ISpBomService bomService;

    @Autowired
    private ISpInventoryService inventoryService;

    @Autowired
    private ISpWarehouseLocationService warehouseLocationService;

    @Autowired
    private ISpProcessRouteService processRouteService;

    @Autowired
    private ISpProcessContentService processContentService;

    @Autowired
    private SpBomItemMapper bomItemMapper;

    // ==================== 步骤②：物料一键补建 ====================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public JSONObject batchCreateMaterials(String productName, Integer bomLevel, JSONArray materials) {
        productName = StrUtil.trimToEmpty(productName);
        if (StrUtil.isBlank(productName)) {
            throw new RuntimeException("请先填写产品名称");
        }
        int level = bomLevel == null ? 0 : bomLevel;
        if (materials == null) {
            materials = new JSONArray();
        }

        int createdMaterialCount = 0;
        int createdInventoryCount = 0;
        for (Object o : materials) {
            JSONObject m = (JSONObject) o;
            String desc = StrUtil.trimToEmpty(m.getStr("materielItemDesc"));
            if (StrUtil.isBlank(desc)) {
                throw new RuntimeException("存在未填写名称的物料行，请补全后再提交");
            }
            String code = StrUtil.trimToEmpty(m.getStr("materielItemCode"));

            // 先按编码/描述匹配现有物料，命中直接复用（防止重复创建）
            SpMaterile exist = findMaterile(code, desc);
            if (exist != null) {
                m.put("materielItemCode", exist.getMateriel());
                m.put("materielId", exist.getId());
                m.put("matched", true);
                continue;
            }

            String matType = StrUtil.blankToDefault(m.getStr("matType"), m.getStr("itemMatType"));
            SpMaterile nm = createMaterial(desc, code, StrUtil.blankToDefault(matType, "PART"),
                    m.getStr("itemUnit"), m.getStr("matSource"), m.getInt("leadTime"), m.getInt("safetyStock"));
            createdMaterialCount++;
            if (createInitInventory(nm)) {
                createdInventoryCount++;
            }

            m.put("materielItemCode", nm.getMateriel());
            m.put("materielId", nm.getId());
            m.put("matched", true);
            m.put("created", true);
        }

        // 自动补齐 BOM 保存前置条件
        String headerMaterielCode;
        int createdComponentCount = 0;
        if (level == 0) {
            headerMaterielCode = ensureProductMateriel(productName);
            createdComponentCount = ensureComponentDefs(productName, materials);
        } else {
            headerMaterielCode = ensureHeaderComponentDef(productName, level);
        }

        JSONObject result = new JSONObject();
        result.put("materials", materials);
        result.put("headerMaterielCode", headerMaterielCode);
        result.put("createdMaterialCount", createdMaterialCount);
        result.put("createdComponentCount", createdComponentCount);
        result.put("createdInventoryCount", createdInventoryCount);
        return result;
    }

    /**
     * 创建物料主数据（编码空/重复时自动取号；循环内逐条保存保证编码连续）。
     */
    private SpMaterile createMaterial(String desc, String code, String matType,
                                      String unit, String matSource, Integer leadTime, Integer safetyStock) {
        SpMaterile nm = new SpMaterile();
        if (StrUtil.isBlank(code) || materileService.isMaterielCodeDuplicate(code, null)) {
            code = materileService.nextMaterielCode();
        }
        nm.setMateriel(code);
        nm.setMaterielDesc(desc);
        nm.setMatType(StrUtil.blankToDefault(matType, "PART"));
        nm.setUnit(StrUtil.blankToDefault(unit, "个"));
        nm.setMatSource("SELF".equals(matSource) ? "SELF" : "OUT");
        nm.setLeadTime(leadTime == null || leadTime < 1 ? 1 : leadTime);
        nm.setSafetyStock(safetyStock == null || safetyStock < 0 ? 0 : safetyStock);
        nm.setDeleted("0");
        materileService.save(nm);
        return nm;
    }

    /**
     * 为新建物料写一条期初库存（优先选无库存记录的空闲库位，每个物料独占一格，
     * 3D 仓库展示更直观；数量=安全库存），使其在「库存管理」与数字仿真3D仓库中可见。
     * 系统尚无库房库位时跳过。
     *
     * @return 是否成功写入
     */
    private boolean createInitInventory(SpMaterile m) {
        if (m == null || "FG".equals(m.getMatType()) || "PRODUCT".equals(m.getMatType())) {
            return false;
        }
        // 优先：状态正常且尚无库存记录的空闲库位
        SpWarehouseLocation location = warehouseLocationService.getOne(new QueryWrapper<SpWarehouseLocation>()
                .eq("is_deleted", "0").eq("status", "0")
                .notExists("SELECT 1 FROM sp_inventory i WHERE i.location_id = sp_warehouse_location.id AND i.is_deleted = '0'")
                .orderByAsc("location_code").last("limit 1"), false);
        if (location == null) {
            location = warehouseLocationService.getOne(new QueryWrapper<SpWarehouseLocation>()
                    .eq("is_deleted", "0").eq("status", "0")
                    .orderByAsc("location_code").last("limit 1"), false);
        }
        if (location == null) {
            location = warehouseLocationService.getOne(new QueryWrapper<SpWarehouseLocation>()
                    .eq("is_deleted", "0").orderByAsc("location_code").last("limit 1"), false);
        }
        if (location == null) {
            log.warn("系统未维护库房库位，物料【{}】跳过期初库存", m.getMateriel());
            return false;
        }
        SpInventory inv = new SpInventory();
        inv.setWarehouseId(location.getWarehouseId());
        inv.setLocationId(location.getId());
        inv.setMaterielId(m.getId());
        inv.setBatchNo("AI期初");
        inv.setQty(BigDecimal.valueOf(m.getSafetyStock() == null ? 0 : m.getSafetyStock()));
        inventoryService.inbound(inv);
        return true;
    }

    /** 按编码/描述匹配现有物料 */
    private SpMaterile findMaterile(String code, String desc) {
        if (StrUtil.isNotBlank(code)) {
            SpMaterile byCode = materileService.getOne(new QueryWrapper<SpMaterile>()
                    .eq("materiel", code).ne("is_deleted", "1").last("limit 1"), false);
            if (byCode != null) {
                return byCode;
            }
        }
        if (StrUtil.isNotBlank(desc)) {
            return materileService.getOne(new QueryWrapper<SpMaterile>()
                    .eq("materiel_desc", desc).ne("is_deleted", "1").last("limit 1"), false);
        }
        return null;
    }

    /** level=0：确保产品本身存在成品物料（FG），返回成品物料编码作为 BOM 表头物料 */
    private String ensureProductMateriel(String productName) {
        SpMaterile product = materileService.getOne(new QueryWrapper<SpMaterile>()
                .eq("materiel_desc", productName)
                .in("mat_type", "FG", "PRODUCT")
                .ne("is_deleted", "1").last("limit 1"), false);
        if (product == null) {
            product = new SpMaterile();
            product.setMateriel(materileService.nextMaterielCode());
            product.setMaterielDesc(productName);
            product.setMatType("FG");
            product.setUnit("台");
            product.setMatSource("SELF");
            product.setLeadTime(1);
            product.setSafetyStock(0);
            product.setDeleted("0");
            materileService.save(product);
            log.info("AI向导自动创建成品物料：{} {}", product.getMateriel(), productName);
        }
        return product.getMateriel();
    }

    /** level=0：为 PG/COMP 子项自动补零部件定义，返回新建数量 */
    private int ensureComponentDefs(String productName, JSONArray materials) {
        int created = 0;
        for (Object o : materials) {
            JSONObject m = (JSONObject) o;
            String itemType = m.getStr("itemMatType");
            if (!"PG".equals(itemType) && !"COMP".equals(itemType)) {
                continue;
            }
            String code = m.getStr("materielItemCode");
            String name = StrUtil.trimToEmpty(m.getStr("materielItemDesc"));
            if (componentDefService.isEnabledForProduct(productName, code, name)) {
                continue;
            }
            if (componentDefService.isComponentNameDuplicate(productName, name, null)) {
                continue;
            }
            SpComponentDef def = new SpComponentDef();
            def.setProductName(productName);
            def.setComponentCode(componentDefService.nextComponentCode());
            def.setComponentName(name);
            def.setComponentType(itemType);
            def.setRemark("AI智能建模向导自动创建");
            def.setDeleted("0");
            componentDefService.save(def);
            created++;
        }
        return created;
    }

    /** level=1/2：确保表头产品名本身有启用的零部件定义，返回零部件编码作为 BOM 表头编码 */
    private String ensureHeaderComponentDef(String productName, int level) {
        String expectedType = level == 1 ? "PG" : "COMP";
        SpComponentDef def = componentDefService.getOne(new QueryWrapper<SpComponentDef>()
                .eq("component_name", productName)
                .eq("component_type", expectedType)
                .eq("is_deleted", "0").last("limit 1"), false);
        if (def == null) {
            def = new SpComponentDef();
            def.setProductName(productName);
            def.setComponentCode(componentDefService.nextComponentCode());
            def.setComponentName(productName);
            def.setComponentType(expectedType);
            def.setRemark("AI智能建模向导自动创建");
            def.setDeleted("0");
            componentDefService.save(def);
            log.info("AI向导自动创建零部件定义：{} {}", def.getComponentCode(), productName);
        }
        return def.getComponentCode();
    }

    /**
     * 确保子 BOM（PG/COMP 子项）存在「类型一致且启用」的零部件定义。
     * 匹配口径与 SpBomServiceImpl.getEnabledComponent 完全一致：
     * is_deleted='0' 且 component_type 精确匹配 且（component_code 或 component_name 命中）；
     * 命中则跳过，缺失则按正确类型补建。
     *
     * 注意：ensureComponentDefs 会因「同产品同名（不论类型）已存在」而跳过创建，
     * 当历史/演示数据中存在同名但不同类型（含中文「半成品/组件」）的定义时，
     * 子BOM定版会因类型不匹配而报「半成品/组件BOM必须对应已启用的零部件定义」，故在此兜底补建。
     */
    private void ensureChildComponentDef(String productName, String itemCode, String itemDesc, String componentType) {
        if (StrUtil.isBlank(itemDesc) && StrUtil.isBlank(itemCode)) {
            return;
        }
        long matched = componentDefService.count(new QueryWrapper<SpComponentDef>()
                .eq("is_deleted", "0")
                .eq("component_type", componentType)
                .and(w -> w.eq("component_code", itemCode).or().eq("component_name", itemDesc)));
        if (matched > 0) {
            return;
        }
        SpComponentDef def = new SpComponentDef();
        def.setProductName(StrUtil.blankToDefault(productName, itemDesc));
        def.setComponentCode(componentDefService.nextComponentCode());
        def.setComponentName(itemDesc);
        def.setComponentType(componentType);
        def.setRemark("AI智能建模向导自动创建（子BOM零部件）");
        def.setDeleted("0");
        componentDefService.save(def);
    }

    // ==================== 步骤②：BOM 全链保存并定版 ====================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public JSONObject saveBomFullChain(JSONObject header, JSONArray items) {
        if (header == null) {
            throw new RuntimeException("缺少 BOM 表头信息");
        }
        if (items == null || items.isEmpty()) {
            throw new RuntimeException("请至少保留一个 BOM 子项");
        }
        String productName = StrUtil.blankToDefault(header.getStr("productName"),
                StrUtil.trimToEmpty(header.getStr("materielDesc")));

        int childBomCount = 0;
        int createdMaterialCount = 0;
        int childSeq = 0;
        String childBomCodeBase = "BOM" + System.currentTimeMillis();

        // 对每个 PG/COMP 子项：复用已定版子BOM，或用 subParts 自动创建并定版
        for (Object o : items) {
            JSONObject item = (JSONObject) o;
            String itemType = item.getStr("itemMatType");
            if (!"PG".equals(itemType) && !"COMP".equals(itemType)) {
                continue;
            }
            String itemCode = StrUtil.trimToEmpty(item.getStr("materielItemCode"));
            String itemDesc = StrUtil.trimToEmpty(item.getStr("materielItemDesc"));
            int expectedLevel = "PG".equals(itemType) ? 1 : 2;

            // 已有可用（已定版且有效）的同物料子BOM则直接复用
            SpBom existing = bomService.getOne(new QueryWrapper<SpBom>()
                    .eq("materiel_code", itemCode)
                    .eq("bom_level", expectedLevel)
                    .eq("lock_status", "locked")
                    .eq("validity", "有效")
                    .ne("is_deleted", "1")
                    .orderByDesc("version_number").last("limit 1"), false);
            if (existing != null) {
                item.put("childBomId", existing.getId());
                continue;
            }

            // 用 AI 给出的子件清单生成下层 BOM 子项；缺失时自动补一条基础件
            // 注意：AI 可能在同一组件下给出重名子件，须按物料编码去重合并数量，否则触发「子项重复」校验
            JSONArray subParts = item.getJSONArray("subParts");
            Map<String, JSONObject> childItemMap = new LinkedHashMap<>();
            if (subParts != null) {
                for (Object sp : subParts) {
                    JSONObject part = (JSONObject) sp;
                    String partName = StrUtil.trimToEmpty(part.getStr("name"));
                    if (StrUtil.isBlank(partName)) {
                        continue;
                    }
                    SpMaterile pm = findMaterile(null, partName);
                    if (pm == null) {
                        pm = createMaterial(partName, null, "PART", part.getStr("unit"), "OUT", 1, 0);
                        createdMaterialCount++;
                        createInitInventory(pm);
                    }
                    BigDecimal num = part.getBigDecimal("num");
                    if (num == null || num.compareTo(BigDecimal.ZERO) <= 0) {
                        num = BigDecimal.ONE;
                    }
                    JSONObject ci = childItemMap.get(pm.getMateriel());
                    if (ci != null) {
                        ci.put("itemNum", ci.getBigDecimal("itemNum").add(num));
                        continue;
                    }
                    ci = new JSONObject();
                    ci.put("materielItemCode", pm.getMateriel());
                    ci.put("materielItemDesc", pm.getMaterielDesc());
                    ci.put("itemMatType", "PART");
                    ci.put("itemNum", num);
                    ci.put("itemUnit", StrUtil.blankToDefault(part.getStr("unit"), pm.getUnit()));
                    childItemMap.put(pm.getMateriel(), ci);
                }
            }
            JSONArray childItems = new JSONArray();
            int lineNo = 1;
            for (JSONObject ci : childItemMap.values()) {
                ci.put("lineNo", String.valueOf(lineNo++));
                childItems.add(ci);
            }
            if (childItems.isEmpty()) {
                SpMaterile base = findMaterile(null, itemDesc + "基础件");
                if (base == null) {
                    base = createMaterial(itemDesc + "基础件", null, "PART", item.getStr("itemUnit"), "OUT", 1, 0);
                    createdMaterialCount++;
                    createInitInventory(base);
                }
                JSONObject ci = new JSONObject();
                ci.put("materielItemCode", base.getMateriel());
                ci.put("materielItemDesc", base.getMaterielDesc());
                ci.put("itemMatType", "PART");
                ci.put("itemNum", BigDecimal.ONE);
                ci.put("itemUnit", base.getUnit());
                ci.put("lineNo", "1");
                childItems.add(ci);
            }

            // 确保该 PG/COMP 子项存在「类型一致且启用」的零部件定义，否则子BOM定版校验
            // （getEnabledComponent 按 名称+精确类型 匹配）会报「半成品/组件BOM必须对应已启用的零部件定义」。
            ensureChildComponentDef(productName, itemCode, itemDesc, itemType);

            SpBom childBom = new SpBom();
            childBom.setBomCode(childBomCodeBase + "-C" + String.format("%02d", ++childSeq));
            childBom.setMaterielCode(itemCode);
            childBom.setMaterielDesc(itemDesc);
            childBom.setVersionNumber("1");
            childBom.setBomLevel(expectedLevel);
            childBom.setFactory(header.getStr("factory"));
            childBom.setRemark("AI智能建模向导自动创建");
            bomService.saveBomWithItems(childBom, childItems.toString());
            bomService.lockBom(childBom.getId());
            childBomCount++;

            item.put("childBomId", childBom.getId());
        }

        // 保存产品/上层 BOM（子项已带 childBomId）并定版；仅保留 SpBomItem 实体字段，
        // 并按「编码#类型」去重合并用量（两行可能匹配到同一物料）
        Map<String, JSONObject> productItemMap = new LinkedHashMap<>();
        for (Object o : items) {
            JSONObject item = (JSONObject) o;
            String key = StrUtil.trimToEmpty(item.getStr("materielItemCode")) + "#" + item.getStr("itemMatType");
            BigDecimal num = item.getBigDecimal("itemNum");
            JSONObject pi = productItemMap.get(key);
            if (pi != null) {
                BigDecimal old = pi.getBigDecimal("itemNum");
                pi.put("itemNum", (old == null ? BigDecimal.ZERO : old).add(num == null ? BigDecimal.ZERO : num));
                continue;
            }
            pi = new JSONObject();
            pi.put("materielItemCode", item.getStr("materielItemCode"));
            pi.put("materielItemDesc", item.getStr("materielItemDesc"));
            pi.put("itemMatType", item.getStr("itemMatType"));
            pi.put("itemNum", num);
            pi.put("itemUnit", item.getStr("itemUnit"));
            pi.put("operTyper", item.getStr("operTyper"));
            pi.put("childBomId", item.getStr("childBomId"));
            productItemMap.put(key, pi);
        }
        JSONArray productItems = new JSONArray();
        int lineSeq = 1;
        for (JSONObject pi : productItemMap.values()) {
            pi.put("lineNo", String.valueOf(lineSeq++));
            productItems.add(pi);
        }
        // 表头物料权威化：成品BOM(level0)的表头必须是成品(FG)物料，且与零部件定义同名，
        // 否则 saveBomWithItems 的 validateBomHeader 会因「产品BOM必须对应成品或产品物料」失败。
        // ensureProductMateriel 幂等，会复用步骤②已建好的同名 FG 物料，不会重复建料。
        String headerCode = StrUtil.trimToEmpty(header.getStr("materielCode"));
        String headerDesc = StrUtil.trimToEmpty(header.getStr("materielDesc"));
        Integer headerLevel = header.getInt("bomLevel");
        if (headerLevel != null && headerLevel == 0 && StrUtil.isNotBlank(productName)) {
            headerCode = ensureProductMateriel(productName);
            headerDesc = productName;
        }
        SpBom bom = new SpBom();
        bom.setBomCode(StrUtil.trimToEmpty(header.getStr("bomCode")));
        bom.setMaterielCode(headerCode);
        bom.setMaterielDesc(headerDesc);
        bom.setVersionNumber(StrUtil.blankToDefault(header.getStr("versionNumber"), "1"));
        bom.setBomLevel(header.getInt("bomLevel"));
        bom.setFactory(header.getStr("factory"));
        bomService.saveBomWithItems(bom, productItems.toString());
        bomService.lockBom(bom.getId());

        JSONObject result = new JSONObject();
        result.put("bomId", bom.getId());
        result.put("bomCode", bom.getBomCode());
        result.put("childBomCount", childBomCount);
        result.put("createdMaterialCount", createdMaterialCount);
        result.put("locked", true);
        return result;
    }

    // ==================== 步骤③：工序补建 + 工艺路线创建 ====================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public JSONObject createOpersAndFlow(String productName, JSONArray opers, String bomId) throws Exception {
        productName = StrUtil.trimToEmpty(productName);
        if (opers == null || opers.size() < 2) {
            throw new RuntimeException("工艺路线至少需要两道工序");
        }

        // 按 sortNum 排序，保证工序链顺序正确
        List<JSONObject> operList = new ArrayList<>();
        for (Object o : opers) {
            operList.add((JSONObject) o);
        }
        operList.sort(Comparator.comparingInt(op -> {
            Integer s = op.getInt("sortNum");
            return s == null ? Integer.MAX_VALUE : s;
        }));

        int createdOperCount = 0;
        for (JSONObject op : operList) {
            String operId = op.getStr("operId");
            if (StrUtil.isNotBlank(operId)) {
                SpOper exist = operService.getById(operId);
                if (exist == null) {
                    throw new RuntimeException("工序【" + op.getStr("operDesc") + "】不存在，请刷新匹配后重试");
                }
                op.put("oper", exist.getOper());
                continue;
            }
            String desc = StrUtil.trimToEmpty(op.getStr("operDesc"));
            if (StrUtil.isBlank(desc)) {
                throw new RuntimeException("存在未填写名称的工序行，请补全后再提交");
            }
            // 再按名称匹配一次，防止两步之间他人已创建同名工序
            SpOper byDesc = operService.getOne(new QueryWrapper<SpOper>()
                    .eq("oper_desc", desc).last("limit 1"), false);
            if (byDesc != null) {
                op.put("operId", byDesc.getId());
                op.put("oper", byDesc.getOper());
                op.put("unitId", byDesc.getUnitId());
                continue;
            }
            String unitId = StrUtil.trimToEmpty(op.getStr("unitId"));
            if (StrUtil.isBlank(unitId)) {
                throw new RuntimeException("工序【" + desc + "】未绑定加工单元，请先选择");
            }
            SpProcessingUnit unit = unitService.getById(unitId);
            if (unit == null) {
                throw new RuntimeException("工序【" + desc + "】绑定的加工单元不存在，请重新选择");
            }
            BigDecimal hours = positiveOrDefault(op.getBigDecimal("operHours"), BigDecimal.ONE);
            BigDecimal cycle = positiveOrDefault(op.getBigDecimal("manuCycle"), hours);
            if (cycle.compareTo(hours) < 0) {
                cycle = hours;
            }
            SpOper n = new SpOper();
            // 循环内逐条保存，保证 nextOperCode 编码连续
            n.setOper(operService.nextOperCode());
            n.setOperDesc(desc);
            n.setUnitId(unitId);
            n.setOperHours(hours);
            n.setManuCycle(cycle);
            n.setGenPlan("Y");
            n.setRemark(StrUtil.trimToEmpty(op.getStr("remark")));
            operService.save(n);
            createdOperCount++;

            op.put("operId", n.getId());
            op.put("oper", n.getOper());
            op.put("matched", true);
        }

        // 生成唯一流程编码
        String flowCode = "FL" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        if (flowService.count(new QueryWrapper<SpFlow>().eq("flow", flowCode)) > 0) {
            flowCode = flowCode + RandomUtil.randomNumbers(2);
        }

        SpFlowDto dto = new SpFlowDto();
        dto.setFlow(flowCode);
        dto.setFlowDesc(productName + "工艺路线(AI向导)");
        List<SpOperVo> vos = new ArrayList<>();
        for (JSONObject op : operList) {
            SpOperVo vo = new SpOperVo();
            vo.setValue(op.getStr("operId"));
            vo.setTitle(op.getStr("oper"));
            vos.add(vo);
        }
        dto.setSpOperVoList(vos);

        Result<?> r = flowOperRelationService.addOrUpdate(dto);
        Object codeObj = r.get("code");
        if (!(codeObj instanceof Integer) || (Integer) codeObj != 0) {
            throw new RuntimeException("工艺路线创建失败：" + r.get("msg"));
        }

        // addOrUpdate 内部用拷贝对象保存，dto 不会回填 id，需按流程编码反查
        SpFlow saved = flowService.getOne(new QueryWrapper<SpFlow>()
                .eq("flow", flowCode).last("limit 1"), false);
        if (saved == null) {
            throw new RuntimeException("工艺路线创建后未找到，请重试");
        }

        JSONObject result = new JSONObject();
        result.put("flowId", saved.getId());
        result.put("flow", saved.getFlow());
        result.put("process", saved.getProcess());
        result.put("createdOperCount", createdOperCount);
        result.put("opers", new JSONArray(operList));

        // ===== 关联物料工艺路线 + 初始化工艺规划树 + 绑定工序 + 锁定 + 预填工艺内容 =====
        if (StrUtil.isNotBlank(bomId)) {
            buildProcessRouteAndContent(bomId, saved, operList, result);
        } else {
            result.put("routeCount", 0);
            result.put("contentFilledCount", 0);
        }
        return result;
    }

    /**
     * 为已定版 BOM 构建工艺规划与工艺内容，让三个工艺页面（流程管理/内容编制/产品工艺查询）
     * 对 AI 生成的 BOM 有完整数据。整段处于 createOpersAndFlow 的同一事务内。
     */
    private void buildProcessRouteAndContent(String bomId, SpFlow flow, List<JSONObject> operList, JSONObject result) {
        // 物料关联工艺路线（sp_materile.flow_id/flow_desc）
        SpBom bom = bomService.getById(bomId);
        if (bom != null) {
            SpMaterile material = materileService.getOne(new QueryWrapper<SpMaterile>()
                    .eq("materiel", bom.getMaterielCode()).ne("is_deleted", "1").last("limit 1"), false);
            if (material != null) {
                material.setFlowId(flow.getId());
                material.setFlowDesc(flow.getFlowDesc());
                materileService.updateById(material);
            }
        }

        // 跳过条件（避免 initRoutes 抛异常污染整个事务，导致 flow 一起回滚）：
        // ① 本 BOM 已有锁定规划（重试场景）；② 同产品编码已存在他单的锁定规划（同名产品重跑）
        String rootCode = bom == null ? null : "NGY_3_" + bom.getMaterielCode();
        boolean conflict = bom != null && processRouteService.count(new QueryWrapper<SpProcessRoute>()
                .ne("bom_id", bomId)
                .eq("lock_status", "locked")
                .and(w -> w.eq("route_code", rootCode).or().likeRight("route_code", rootCode + "_"))) > 0;
        if (processRouteService.isLocked(bomId) || conflict) {
            result.put("routeCount", 0);
            result.put("contentFilledCount", 0);
            result.put("routesSkipped", true);
            return;
        }

        // 初始化工艺规划树：根节点 + 各 PG/COMP 节点
        int routeCount = processRouteService.initRoutes(bomId);

        // operId → 工序内容字段映射（用于预填）；同时准备工序列表供失配兜底轮转
        Map<String, JSONObject> operContentMap = new LinkedHashMap<>();
        List<String> flowOperIds = new ArrayList<>();
        for (JSONObject op : operList) {
            String oid = op.getStr("operId");
            if (StrUtil.isNotBlank(oid)) {
                operContentMap.put(oid, op);
                flowOperIds.add(oid);
            }
        }
        String lastOperId = flowOperIds.isEmpty() ? null : flowOperIds.get(flowOperIds.size() - 1);

        // 为每个 route 节点绑定工序（按 BOM 子项 operTyper 匹配；失配轮转兜底）
        List<SpProcessRoute> routes = processRouteService.listByBomId(bomId);
        int rotate = 0;
        for (SpProcessRoute route : routes) {
            String operId;
            if (StrUtil.isBlank(route.getParentRouteId())) {
                // 根节点（产品本身）：绑总装/最后一道工序
                operId = lastOperId;
            } else {
                operId = resolveOperForNode(route, flowOperIds, rotate++);
            }
            if (StrUtil.isNotBlank(operId)) {
                processRouteService.bindOper(route.getId(), operId);
            }
        }

        // 锁定整棵工艺规划（非根节点均已绑定工序）
        processRouteService.lockAll(bomId);

        // 逐节点预填工艺内容（状态自动变为「编制中」）
        int contentFilled = 0;
        for (SpProcessRoute route : processRouteService.listByBomId(bomId)) {
            if (StrUtil.isBlank(route.getOperId())) {
                continue;
            }
            fillProcessContent(route, operContentMap.get(route.getOperId()));
            contentFilled++;
        }

        result.put("routeCount", routeCount);
        result.put("contentFilledCount", contentFilled);
    }

    /**
     * 为工艺节点选工序：先按 BOM 子项 operTyper 匹配工序名（oper_desc，且须在本次工艺路线内），
     * 失配则轮转取本次工艺路线的工序，保证每个非根节点都有工序可绑。
     */
    private String resolveOperForNode(SpProcessRoute route, List<String> flowOperIds, int rotate) {
        if (StrUtil.isNotBlank(route.getBomItemId())) {
            SpBomItem item = bomItemMapper.selectById(route.getBomItemId());
            if (item != null && StrUtil.isNotBlank(item.getOperTyper())) {
                SpOper oper = operService.getOne(new QueryWrapper<SpOper>()
                        .eq("oper_desc", StrUtil.trim(item.getOperTyper())).last("limit 1"), false);
                if (oper != null && flowOperIds.contains(oper.getId())) {
                    return oper.getId();
                }
            }
        }
        if (flowOperIds.isEmpty()) {
            return null;
        }
        return flowOperIds.get(rotate % flowOperIds.size());
    }

    /** 用 AI 给出的工艺内容字段预填一个工艺节点；缺失字段用模板兜底，并写入备料清单 */
    private void fillProcessContent(SpProcessRoute route, JSONObject opContent) {
        String routeId = route.getId();
        String operName = StrUtil.blankToDefault(route.getNodeName(), "本工序");
        String contentText = contentOrDefault(opContent, "contentText",
                "按照标准作业指导书完成【" + operName + "】的加工/装配作业，作业完成后自检合格再流转下道工序。");
        String requireText = contentOrDefault(opContent, "requireText",
                "外观无损伤、装配到位、尺寸与规格符合图纸要求，关键参数检验合格。");
        String precautionText = contentOrDefault(opContent, "precautionText",
                "规范佩戴劳保用品，按工艺参数操作，注意设备与人身安全，防止物料磕碰污染。");
        String techDocDesc = contentOrDefault(opContent, "techDocDesc",
                "参见该工序对应的作业指导书与技术图纸。");

        processContentService.saveStep2Content(routeId, contentText, null);
        processContentService.saveStep3Require(routeId, requireText, "Y", null);
        processContentService.saveStep4Precaution(routeId, precautionText, null);
        processContentService.saveStep6TechDoc(routeId, techDocDesc, null, null);

        // 备料清单：根节点取顶层 BOM 一级子项，零部件节点取其子 BOM 的 PART 子项
        List<SpProcessMaterialRel> rels = buildMaterialRels(routeId, route);
        if (!rels.isEmpty()) {
            processContentService.saveStep7Materials(routeId, rels);
        }
    }

    private String contentOrDefault(JSONObject opContent, String key, String def) {
        if (opContent == null) {
            return def;
        }
        return StrUtil.blankToDefault(opContent.getStr(key), def);
    }

    /** 构建工艺节点的备料清单：从对应 BOM 头的子项物料汇总 */
    private List<SpProcessMaterialRel> buildMaterialRels(String routeId, SpProcessRoute route) {
        String bomHeadId = null;
        if (StrUtil.isBlank(route.getParentRouteId())) {
            // 根节点：备料 = 顶层产品 BOM 的一级子项
            bomHeadId = route.getBomId();
        } else if (StrUtil.isNotBlank(route.getBomItemId())) {
            // 零部件节点：备料 = 该子项关联子 BOM 的子项（基础零件）
            SpBomItem item = bomItemMapper.selectById(route.getBomItemId());
            if (item != null) {
                bomHeadId = item.getChildBomId();
            }
        }
        List<SpProcessMaterialRel> rels = new ArrayList<>();
        if (StrUtil.isBlank(bomHeadId)) {
            return rels;
        }
        for (SpBomItem child : bomItemMapper.listByBomHeadId(bomHeadId)) {
            SpMaterile m = materileService.getOne(new QueryWrapper<SpMaterile>()
                    .eq("materiel", child.getMaterielItemCode()).ne("is_deleted", "1").last("limit 1"), false);
            if (m == null) {
                continue;
            }
            SpProcessMaterialRel rel = new SpProcessMaterialRel();
            rel.setRouteId(routeId);
            rel.setMaterielId(m.getId());
            rel.setReqQty(child.getItemNum() == null ? BigDecimal.ONE : child.getItemNum());
            rels.add(rel);
        }
        return rels;
    }

    private BigDecimal positiveOrDefault(BigDecimal value, BigDecimal def) {
        return value == null || value.compareTo(BigDecimal.ZERO) <= 0 ? def : value;
    }

    // ==================== 步骤④：分配预览 / 工单创建 ====================

    @Override
    public JSONArray previewAssign(String flowId) {
        if (StrUtil.isBlank(flowId)) {
            throw new RuntimeException("缺少工艺路线，请先完成上一步");
        }
        List<SpFlowOperRelation> relations = flowOperRelationService.list(
                new QueryWrapper<SpFlowOperRelation>().eq("flow_id", flowId).orderByAsc("sort_num"));
        if (relations.isEmpty()) {
            throw new RuntimeException("工艺路线下没有工序，请先完成上一步");
        }

        // 同一次预览内已选中者负载 +1，避免所有工序压给同一人
        Map<String, Integer> sessionLoad = new HashMap<>();
        JSONArray result = new JSONArray();
        for (SpFlowOperRelation rel : relations) {
            JSONObject row = new JSONObject();
            row.put("operId", rel.getOperId());
            row.put("oper", rel.getOper());
            row.put("sortNum", rel.getSortNum());

            SpOper oper = operService.getById(rel.getOperId());
            row.put("operDesc", oper == null ? "" : oper.getOperDesc());
            String unitId = oper == null ? null : oper.getUnitId();
            row.put("unitId", StrUtil.nullToEmpty(unitId));
            String unitName = "";
            if (StrUtil.isNotBlank(unitId)) {
                SpProcessingUnit unit = unitService.getById(unitId);
                unitName = unit == null ? "" : unit.getUnitName();
            }
            row.put("unitName", unitName);

            if (StrUtil.isBlank(unitId)) {
                row.put("warn", "该工序未绑定加工单元，无法自动分配");
                result.add(row);
                continue;
            }
            List<Map<String, Object>> candidates = assignService.pickCandidatesByUnit(unitId);
            if (candidates.isEmpty()) {
                row.put("warn", "该工序加工单元未绑定班组或班组无人，请先维护「加工单元定义/班组员工定义」");
                result.add(row);
                continue;
            }
            // 叠加本次预览的临时负载后取最小者（候选列表已按库内负载升序）
            Map<String, Object> best = null;
            long bestLoad = Long.MAX_VALUE;
            for (Map<String, Object> c : candidates) {
                String uid = String.valueOf(c.get("userId"));
                long load = toLong(c.get("currentLoad")) + sessionLoad.getOrDefault(uid, 0);
                if (load < bestLoad) {
                    bestLoad = load;
                    best = c;
                }
            }
            String userId = String.valueOf(best.get("userId"));
            row.put("teamId", best.get("teamId"));
            row.put("teamName", best.get("teamName"));
            row.put("userId", userId);
            row.put("userName", best.get("userName"));
            row.put("currentLoad", bestLoad);
            sessionLoad.put(userId, sessionLoad.getOrDefault(userId, 0) + 1);
            result.add(row);
        }
        return result;
    }

    private long toLong(Object value) {
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        try {
            return Long.parseLong(String.valueOf(value));
        } catch (NumberFormatException e) {
            return 0L;
        }
    }

    @Override
    public JSONArray assignCandidates(String unitId) {
        if (StrUtil.isBlank(unitId)) {
            throw new RuntimeException("缺少加工单元");
        }
        return new JSONArray(assignService.pickCandidatesByUnit(unitId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public JSONObject createProductionOrder(JSONObject orderJson) {
        if (orderJson == null) {
            throw new RuntimeException("生产订单信息不能为空");
        }
        Integer qty = orderJson.getInt("qty");
        if (qty == null || qty <= 0) {
            throw new RuntimeException("订单数量必须大于 0");
        }
        String bomId = StrUtil.trimToEmpty(orderJson.getStr("bomId"));
        String materiel = StrUtil.trimToEmpty(orderJson.getStr("materiel"));
        if (StrUtil.isBlank(bomId) && StrUtil.isBlank(materiel)) {
            throw new RuntimeException("缺少产品BOM，请先完成上一步的 BOM 保存定版");
        }
        boolean forecast = "FORECAST".equalsIgnoreCase(orderJson.getStr("sourceType"));

        // 组装生产订单表头（草稿）：预测订单走正向排产，需求订单走逆向排产
        SpProductionOrder order = new SpProductionOrder();
        order.setSourceType(forecast ? "FORECAST" : "DEMAND");
        order.setSchedulingMethod(forecast ? "FORWARD" : "REVERSE");
        order.setCreationMethod("MANUAL");
        order.setBusinessType("普通销售");
        order.setOrderDate(LocalDate.now().toString());
        order.setRemark(StrUtil.blankToDefault(orderJson.getStr("remark"), "AI智能建模向导生成"));
        if (!forecast) {
            String customer = StrUtil.trimToEmpty(orderJson.getStr("customerName"));
            if (StrUtil.isBlank(customer)) {
                throw new RuntimeException("需求订单必须填写客户名称");
            }
            order.setCustomerName(customer);
        }

        // 单条产品明细：复用步骤②定版的产品 BOM（saveOrder 会校验为最新定版有效BOM）
        SpProductionOrderItem item = new SpProductionOrderItem();
        item.setBomId(bomId);
        item.setBomCode(StrUtil.trimToEmpty(orderJson.getStr("bomCode")));
        item.setProductMateriel(materiel);
        item.setProductName(StrUtil.trimToEmpty(orderJson.getStr("materielDesc")));
        item.setQty(qty);
        item.setConfiguration(StrUtil.trimToEmpty(orderJson.getStr("configuration")));
        if (forecast) {
            String startDate = trimDate(orderJson.getStr("planStartDate"));
            if (StrUtil.isBlank(startDate)) {
                throw new RuntimeException("预测订单请填写计划开工日期");
            }
            item.setPlanStartDate(startDate);
        } else {
            String deliveryDate = trimDate(orderJson.getStr("planDeliveryDate"));
            if (StrUtil.isBlank(deliveryDate)) {
                throw new RuntimeException("需求订单请填写计划交付日期");
            }
            item.setPlanDeliveryDate(deliveryDate);
        }
        BigDecimal capacity = orderJson.getBigDecimal("targetCapacity");
        if (capacity != null && capacity.compareTo(BigDecimal.ZERO) > 0) {
            item.setTargetCapacity(capacity);
        }
        Integer leadTime = orderJson.getInt("leadTimeDays");
        if (leadTime != null && leadTime > 0) {
            item.setLeadTimeDays(leadTime);
        }

        SpProductionOrderSaveReq req = new SpProductionOrderSaveReq();
        req.setOrder(order);
        req.getItems().add(item);

        // 复用生产计划中心的保存逻辑：校验BOM/排产、生成工序排产明细（sp_production_order_oper_plan）
        Result<?> saved = productionOrderService.saveOrder(req);
        Object codeObj = saved.get("code");
        if (!(codeObj instanceof Integer) || (Integer) codeObj != 0) {
            throw new RuntimeException(String.valueOf(saved.get("msg")));
        }
        String productionOrderId = String.valueOf(saved.get("data"));
        SpProductionOrder persisted = productionOrderService.getById(productionOrderId);

        JSONObject result = new JSONObject();
        result.put("productionOrderId", productionOrderId);
        result.put("orderNo", persisted == null ? "" : persisted.getOrderNo());
        result.put("sourceType", order.getSourceType());
        return result;
    }

    /** 截取日期为 yyyy-MM-dd（laydate 通常已是该格式，兼容带时间的输入） */
    private String trimDate(String value) {
        if (StrUtil.isBlank(value)) {
            return "";
        }
        String v = value.trim();
        return v.length() > 10 ? v.substring(0, 10) : v;
    }
}
