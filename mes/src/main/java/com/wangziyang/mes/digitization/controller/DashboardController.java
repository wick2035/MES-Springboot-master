package com.wangziyang.mes.digitization.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.entity.SpTeam;
import com.wangziyang.mes.basedata.entity.SpTeamEmployee;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.basedata.service.ISpTeamEmployeeService;
import com.wangziyang.mes.basedata.service.ISpTeamService;
import com.wangziyang.mes.basedata.service.ISpWarehouseService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.service.ISpSnProcessRecordService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 智能制造数据中心（数据大屏）数据接口。
 * 全部指标来自真实业务表，不含任何写死数据：
 * 生产订单 sp_order、SN 工序采集 sp_sn_process_record、库存 sp_inventory、班组 sp_team(_employee)。
 *
 * @author ruiyao
 * @since 2026-06-09
 */
@Controller("DashboardController")
@RequestMapping("/digitization/dashboard")
public class DashboardController extends BaseController {

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpSnProcessRecordService snProcessRecordService;

    @Autowired
    private ISpInventoryService inventoryService;

    @Autowired
    private ISpWarehouseService warehouseService;

    @Autowired
    private ISpTeamService teamService;

    @Autowired
    private ISpTeamEmployeeService teamEmployeeService;

    @ApiOperation("智能制造数据中心大屏UI")
    @GetMapping("/screen-ui")
    public String screenUI() {
        return "digitization/dashboard";
    }

    /**
     * 大屏全量数据：一次返回所有分区，前端轮询渲染。
     */
    @ApiOperation("智能制造数据中心大屏数据")
    @PostMapping("/data")
    @ResponseBody
    public Result data() {
        List<SpOrder> orders = orderService.list();
        List<SpSnProcessRecord> records = snProcessRecordService.list();

        Map<String, Object> data = new HashMap<>();
        data.put("overview", buildOverview(orders, records));
        data.put("orderStatus", buildOrderStatus(orders));
        data.put("processFlow", buildProcessFlow(records));
        data.put("achievement", buildAchievement(orders, records));
        data.put("defect", buildDefect(records));
        data.put("inventory", buildInventory());
        data.put("personnel", buildPersonnel());
        return Result.success(data);
    }

    /* ============================ 概览 KPI ============================ */

    private Map<String, Object> buildOverview(List<SpOrder> orders, List<SpSnProcessRecord> records) {
        Map<String, Object> overview = new HashMap<>();
        overview.put("orderCount", orders.size());

        int planQty = 0;
        for (SpOrder o : orders) {
            if (o.getQty() != null) {
                planQty += o.getQty();
            }
        }
        overview.put("planQty", planQty);

        int maxStep = maxStep(records);
        Set<String> completed = completedSn(records, maxStep);
        Set<String> scrapped = scrappedSn(records);
        Set<String> allSn = new HashSet<>();
        for (SpSnProcessRecord r : records) {
            if (r.getSn() != null) {
                allSn.add(r.getSn());
            }
        }
        int completedQty = completed.size();
        int scrappedQty = scrapped.size();
        int inProcessQty = Math.max(0, allSn.size() - completedQty - scrappedQty);
        overview.put("completedQty", completedQty);
        overview.put("inProcessQty", inProcessQty);
        overview.put("scrappedQty", scrappedQty);

        long ok = records.stream().filter(r -> "OK".equals(r.getStatus())).count();
        long ng = records.stream().filter(r -> "NG".equals(r.getStatus())).count();
        long total = ok + ng;
        overview.put("yieldRate", percent(ok, total));
        overview.put("defectRate", percent(ng, total));
        return overview;
    }

    /* ============================ 订单概览 ============================ */

    private Map<String, Object> buildOrderStatus(List<SpOrder> orders) {
        // 状态：1待审批 2已审批 3已结束 4已终结
        Map<Integer, String> statusName = new LinkedHashMap<>();
        statusName.put(1, "待审批");
        statusName.put(2, "已审批");
        statusName.put(3, "已结束");
        statusName.put(4, "已终结");
        Map<Integer, Integer> statusCount = new LinkedHashMap<>();
        for (Integer key : statusName.keySet()) {
            statusCount.put(key, 0);
        }
        // 类型：P量产 A试产 F返工
        Map<String, String> typeName = new LinkedHashMap<>();
        typeName.put("P", "量产");
        typeName.put("A", "试产");
        typeName.put("F", "返工");
        Map<String, Integer> typeCount = new LinkedHashMap<>();
        Map<String, Integer> typeQty = new LinkedHashMap<>();
        for (String key : typeName.keySet()) {
            typeCount.put(key, 0);
            typeQty.put(key, 0);
        }

        for (SpOrder o : orders) {
            if (o.getStatue() != null && statusCount.containsKey(o.getStatue())) {
                statusCount.merge(o.getStatue(), 1, Integer::sum);
            }
            String type = o.getOrderType();
            if (type != null && typeCount.containsKey(type)) {
                typeCount.merge(type, 1, Integer::sum);
                typeQty.merge(type, o.getQty() == null ? 0 : o.getQty(), Integer::sum);
            }
        }

        List<Map<String, Object>> status = new ArrayList<>();
        for (Map.Entry<Integer, String> e : statusName.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", e.getValue());
            item.put("value", statusCount.get(e.getKey()));
            status.add(item);
        }
        List<Map<String, Object>> type = new ArrayList<>();
        for (Map.Entry<String, String> e : typeName.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", e.getValue());
            item.put("value", typeCount.get(e.getKey()));
            item.put("qty", typeQty.get(e.getKey()));
            type.add(item);
        }
        Map<String, Object> result = new HashMap<>();
        result.put("status", status);
        result.put("type", type);
        return result;
    }

    /* ============================ 工序流 ============================ */

    private List<Map<String, Object>> buildProcessFlow(List<SpSnProcessRecord> records) {
        // 按工序聚合 OK / NG，并保留首次出现的 stepNo 与描述用于排序展示
        Map<String, int[]> okNg = new HashMap<>();
        Map<String, Integer> stepNo = new HashMap<>();
        Map<String, String> desc = new HashMap<>();
        for (SpSnProcessRecord r : records) {
            String oper = r.getOper();
            if (oper == null) {
                continue;
            }
            okNg.putIfAbsent(oper, new int[2]);
            if ("NG".equals(r.getStatus())) {
                okNg.get(oper)[1]++;
            } else {
                okNg.get(oper)[0]++;
            }
            if (r.getStepNo() != null) {
                stepNo.merge(oper, r.getStepNo(), Math::min);
            }
            if (!desc.containsKey(oper)) {
                desc.put(oper, r.getOperDesc() != null ? r.getOperDesc() : oper);
            }
        }

        List<Map<String, Object>> flow = new ArrayList<>();
        for (Map.Entry<String, int[]> e : okNg.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            int ok = e.getValue()[0];
            int ng = e.getValue()[1];
            item.put("oper", e.getKey());
            item.put("operDesc", desc.get(e.getKey()));
            item.put("stepNo", stepNo.getOrDefault(e.getKey(), 0));
            item.put("ok", ok);
            item.put("ng", ng);
            item.put("total", ok + ng);
            flow.add(item);
        }
        flow.sort(Comparator.comparingInt(m -> ((Number) m.get("stepNo")).intValue()));
        return flow;
    }

    /* ============================ 工单达成率 ============================ */

    private List<Map<String, Object>> buildAchievement(List<SpOrder> orders, List<SpSnProcessRecord> records) {
        // 按工单分组其 SN 记录
        Map<String, List<SpSnProcessRecord>> byOrder = new HashMap<>();
        for (SpSnProcessRecord r : records) {
            if (r.getOrderId() == null) {
                continue;
            }
            byOrder.computeIfAbsent(r.getOrderId(), k -> new ArrayList<>()).add(r);
        }

        List<Map<String, Object>> list = new ArrayList<>();
        for (SpOrder o : orders) {
            List<SpSnProcessRecord> rs = byOrder.getOrDefault(o.getId(), new ArrayList<>());
            int maxStep = maxStep(rs);
            int completed = completedSn(rs, maxStep).size();
            int planQty = o.getQty() == null ? 0 : o.getQty();
            Map<String, Object> item = new HashMap<>();
            item.put("orderCode", o.getOrderCode());
            item.put("desc", o.getOrderDescription());
            item.put("planQty", planQty);
            item.put("completedQty", completed);
            item.put("rate", percent(completed, planQty));
            list.add(item);
        }
        // 按计划量倒序，最多展示前 8 条
        list.sort(Comparator.comparingInt(m -> -((Number) m.get("planQty")).intValue()));
        return list.size() > 8 ? list.subList(0, 8) : list;
    }

    /* ============================ 不良率 ============================ */

    private Map<String, Object> buildDefect(List<SpSnProcessRecord> records) {
        long ok = records.stream().filter(r -> "OK".equals(r.getStatus())).count();
        long ng = records.stream().filter(r -> "NG".equals(r.getStatus())).count();
        long total = ok + ng;

        Map<String, Object> result = new HashMap<>();
        result.put("overallYield", percent(ok, total));
        result.put("overallDefect", percent(ng, total));

        List<Map<String, Object>> perProcess = new ArrayList<>();
        for (Map<String, Object> p : buildProcessFlow(records)) {
            int pok = ((Number) p.get("ok")).intValue();
            int png = ((Number) p.get("ng")).intValue();
            Map<String, Object> item = new HashMap<>();
            item.put("operDesc", p.get("operDesc"));
            item.put("defectRate", percent(png, pok + png));
            perProcess.add(item);
        }
        result.put("perProcess", perProcess);
        return result;
    }

    /* ============================ 库存 ============================ */

    private Map<String, Object> buildInventory() {
        QueryWrapper<SpWarehouse> wq = new QueryWrapper<>();
        wq.ne("is_deleted", "1");
        wq.orderByAsc("warehouse_code");
        List<SpWarehouse> warehouses = warehouseService.list(wq);

        List<Map<String, Object>> byWarehouse = new ArrayList<>();
        Map<String, BigDecimal> materielQty = new HashMap<>();
        for (SpWarehouse w : warehouses) {
            // listByWarehouse 已联表回填 materielDesc，且仅取正常库存
            List<SpInventory> invs = inventoryService.listByWarehouse(w.getId());
            BigDecimal whTotal = BigDecimal.ZERO;
            for (SpInventory inv : invs) {
                BigDecimal qty = inv.getQty() == null ? BigDecimal.ZERO : inv.getQty();
                whTotal = whTotal.add(qty);
                String mat = inv.getMaterielDesc() != null ? inv.getMaterielDesc() : inv.getMaterielCode();
                if (mat != null) {
                    materielQty.merge(mat, qty, BigDecimal::add);
                }
            }
            Map<String, Object> item = new HashMap<>();
            item.put("name", w.getWarehouseName());
            item.put("value", whTotal);
            byWarehouse.add(item);
        }

        List<Map<String, Object>> topMateriel = new ArrayList<>();
        materielQty.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .limit(5)
                .forEach(e -> {
                    Map<String, Object> item = new HashMap<>();
                    item.put("name", e.getKey());
                    item.put("value", e.getValue());
                    topMateriel.add(item);
                });

        Map<String, Object> result = new HashMap<>();
        result.put("byWarehouse", byWarehouse);
        result.put("topMateriel", topMateriel);
        return result;
    }

    /* ============================ 人员/班组 ============================ */

    private List<Map<String, Object>> buildPersonnel() {
        QueryWrapper<SpTeam> tq = new QueryWrapper<>();
        tq.ne("is_deleted", "1");
        tq.orderByAsc("team_code");
        List<SpTeam> teams = teamService.list(tq);

        QueryWrapper<SpTeamEmployee> eq = new QueryWrapper<>();
        eq.ne("is_deleted", "1");
        List<SpTeamEmployee> emps = teamEmployeeService.list(eq);
        Map<String, Integer> countByTeam = new HashMap<>();
        for (SpTeamEmployee e : emps) {
            if (e.getTeamId() != null) {
                countByTeam.merge(e.getTeamId(), 1, Integer::sum);
            }
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (SpTeam t : teams) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", t.getTeamName());
            item.put("value", countByTeam.getOrDefault(t.getId(), 0));
            result.add(item);
        }
        return result;
    }

    /* ============================ 公共方法 ============================ */

    /** 全部记录中的最大工序步号；无记录返回 0。 */
    private int maxStep(List<SpSnProcessRecord> records) {
        int max = 0;
        for (SpSnProcessRecord r : records) {
            if (r.getStepNo() != null && r.getStepNo() > max) {
                max = r.getStepNo();
            }
        }
        return max;
    }

    /** 完成（走到末道工序且 OK）的 SN 集合。 */
    private Set<String> completedSn(List<SpSnProcessRecord> records, int maxStep) {
        Set<String> set = new HashSet<>();
        if (maxStep <= 0) {
            return set;
        }
        for (SpSnProcessRecord r : records) {
            if (r.getStepNo() != null && r.getStepNo() == maxStep
                    && "OK".equals(r.getStatus()) && r.getSn() != null) {
                set.add(r.getSn());
            }
        }
        return set;
    }

    /** 出现过 NG（报废/返修）的 SN 集合。 */
    private Set<String> scrappedSn(List<SpSnProcessRecord> records) {
        Set<String> set = new HashSet<>();
        for (SpSnProcessRecord r : records) {
            if ("NG".equals(r.getStatus()) && r.getSn() != null) {
                set.add(r.getSn());
            }
        }
        return set;
    }

    /** 百分比（保留一位小数），分母为 0 返回 0。 */
    private double percent(long part, long total) {
        if (total <= 0) {
            return 0d;
        }
        return BigDecimal.valueOf(part * 100.0 / total)
                .setScale(1, RoundingMode.HALF_UP)
                .doubleValue();
    }

}
