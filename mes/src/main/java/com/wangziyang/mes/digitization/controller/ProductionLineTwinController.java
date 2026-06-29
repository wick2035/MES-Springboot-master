package com.wangziyang.mes.digitization.controller;

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
 * 数字孪生生产线（3D 浅色大屏）数据接口。
 * 工位序列与指标均来自真实业务表：生产订单 sp_order、SN 工序采集 sp_sn_process_record。
 * 工位 = 真实工序按步号(stepNo)升序聚合；当现场暂无在制采集记录时，回退到内置演示数据，
 * 保证数字孪生大屏始终饱满好看（返回体含 demo=true 标记）。
 *
 * @since 2026-06-24
 */
@Controller("ProductionLineTwinController")
@RequestMapping("/digital/production-line")
public class ProductionLineTwinController extends BaseController {

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpSnProcessRecordService snProcessRecordService;

    @ApiOperation("数字孪生生产线 3D 大屏 UI")
    @GetMapping("/line-ui")
    public String lineUI() {
        return "digitization/productionLine";
    }

    @ApiOperation("数字孪生生产线数据（真实工序聚合，空数据回退演示）")
    @PostMapping("/data")
    @ResponseBody
    public Result data() {
        List<SpOrder> orders = orderService.list();
        List<SpSnProcessRecord> records = snProcessRecordService.list();

        List<Map<String, Object>> stations = buildStations(records);
        if (stations.isEmpty()) {
            return Result.success(demoData());
        }

        Map<String, Object> data = new HashMap<>();
        data.put("demo", false);
        data.put("lineName", "智能制造 · 数字孪生生产线");
        data.put("stations", stations);
        data.put("kpis", buildKpis(orders, records, stations));
        data.put("orders", buildOrders(orders, records));
        return Result.success(data);
    }

    /* ============================ 工位（工序）============================ */

    /** 由 SN 工序采集记录按 oper 聚合为产线工位，stepNo 升序。 */
    private List<Map<String, Object>> buildStations(List<SpSnProcessRecord> records) {
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

        List<Map<String, Object>> stations = new ArrayList<>();
        for (Map.Entry<String, int[]> e : okNg.entrySet()) {
            int ok = e.getValue()[0];
            int ng = e.getValue()[1];
            Map<String, Object> item = new HashMap<>();
            item.put("oper", e.getKey());
            item.put("name", desc.get(e.getKey()));
            item.put("stepNo", stepNo.getOrDefault(e.getKey(), 0));
            item.put("ok", ok);
            item.put("ng", ng);
            item.put("total", ok + ng);
            item.put("yield", percent(ok, ok + ng));
            stations.add(item);
        }
        stations.sort(Comparator.comparingInt(m -> ((Number) m.get("stepNo")).intValue()));
        int seq = 1;
        for (Map<String, Object> s : stations) {
            s.put("seq", seq++);
        }
        return stations;
    }

    /* ============================ KPI ============================ */

    private Map<String, Object> buildKpis(List<SpOrder> orders, List<SpSnProcessRecord> records,
                                          List<Map<String, Object>> stations) {
        long ok = records.stream().filter(r -> "OK".equals(r.getStatus())).count();
        long ng = records.stream().filter(r -> "NG".equals(r.getStatus())).count();

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
        int wip = Math.max(0, allSn.size() - completedQty - scrapped.size());

        int planQty = 0;
        for (SpOrder o : orders) {
            if (o.getQty() != null) {
                planQty += o.getQty();
            }
        }

        // 日产以末道工序合格产出近似；节拍 = 8h / 日产（夹在合理范围）
        int dayOutput = completedQty > 0 ? completedQty : (int) ok;
        int takt = dayOutput > 0 ? (int) Math.min(600, Math.max(6, Math.round(28800.0 / dayOutput))) : 0;

        Map<String, Object> kpis = new HashMap<>();
        kpis.put("yieldRate", percent(ok, ok + ng));
        kpis.put("wip", wip);
        kpis.put("planQty", planQty);
        kpis.put("completedQty", completedQty);
        kpis.put("dayOutput", dayOutput);
        kpis.put("takt", takt);
        kpis.put("stationCount", stations.size());
        return kpis;
    }

    /* ============================ 工单达成 ============================ */

    private List<Map<String, Object>> buildOrders(List<SpOrder> orders, List<SpSnProcessRecord> records) {
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
        list.sort(Comparator.comparingInt(m -> -((Number) m.get("planQty")).intValue()));
        return list.size() > 6 ? list.subList(0, 6) : list;
    }

    /* ============================ 演示兜底 ============================ */

    /** 现场暂无在制采集记录时的内置演示数据，保证大屏不空荡。 */
    private Map<String, Object> demoData() {
        String[][] demo = {
                {"下料", "128", "2"},
                {"加工", "126", "3"},
                {"检测", "124", "1"},
                {"装配", "122", "2"},
                {"包装", "120", "0"},
                {"入库", "120", "0"}
        };
        List<Map<String, Object>> stations = new ArrayList<>();
        int seq = 1;
        for (String[] d : demo) {
            int ok = Integer.parseInt(d[1]);
            int ng = Integer.parseInt(d[2]);
            Map<String, Object> item = new HashMap<>();
            item.put("seq", seq);
            item.put("oper", "DEMO" + seq);
            item.put("name", d[0]);
            item.put("stepNo", seq);
            item.put("ok", ok);
            item.put("ng", ng);
            item.put("total", ok + ng);
            item.put("yield", percent(ok, ok + ng));
            stations.add(item);
            seq++;
        }

        Map<String, Object> kpis = new LinkedHashMap<>();
        kpis.put("yieldRate", 98.6);
        kpis.put("wip", 36);
        kpis.put("planQty", 1800);
        kpis.put("completedQty", 1240);
        kpis.put("dayOutput", 1240);
        kpis.put("takt", 12);
        kpis.put("stationCount", stations.size());

        String[][] od = {
                {"WO-A1024", "智能网关主板", "600", "528"},
                {"WO-A1025", "驱动控制模组", "500", "446"},
                {"WO-A1026", "传感采集单元", "400", "266"},
                {"WO-A1027", "电源管理板", "300", "180"}
        };
        List<Map<String, Object>> orders = new ArrayList<>();
        for (String[] o : od) {
            int plan = Integer.parseInt(o[2]);
            int done = Integer.parseInt(o[3]);
            Map<String, Object> item = new HashMap<>();
            item.put("orderCode", o[0]);
            item.put("desc", o[1]);
            item.put("planQty", plan);
            item.put("completedQty", done);
            item.put("rate", percent(done, plan));
            orders.add(item);
        }

        Map<String, Object> data = new HashMap<>();
        data.put("demo", true);
        data.put("lineName", "智能制造 · 数字孪生生产线（演示）");
        data.put("stations", stations);
        data.put("kpis", kpis);
        data.put("orders", orders);
        return data;
    }

    /* ============================ 公共方法 ============================ */

    private int maxStep(List<SpSnProcessRecord> records) {
        int max = 0;
        for (SpSnProcessRecord r : records) {
            if (r.getStepNo() != null && r.getStepNo() > max) {
                max = r.getStepNo();
            }
        }
        return max;
    }

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

    private Set<String> scrappedSn(List<SpSnProcessRecord> records) {
        Set<String> set = new HashSet<>();
        for (SpSnProcessRecord r : records) {
            if ("NG".equals(r.getStatus()) && r.getSn() != null) {
                set.add(r.getSn());
            }
        }
        return set;
    }

    private double percent(long part, long total) {
        if (total <= 0) {
            return 0d;
        }
        return BigDecimal.valueOf(part * 100.0 / total)
                .setScale(1, RoundingMode.HALF_UP)
                .doubleValue();
    }
}
