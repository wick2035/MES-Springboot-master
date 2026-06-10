/* ===========================================================
 * MES 智能制造数据中心 · 数据大屏逻辑
 * 全部图表数据来自 /digitization/dashboard/data，30s 自动刷新。
 * =========================================================== */
(function () {
    'use strict';

    var COLOR = {
        accent: '#2de2ff',
        blue: '#2f7bff',
        good: '#2effb3',
        warn: '#ffcf5c',
        bad: '#ff5c7a',
        text: '#cfe9ff',
        dim: '#6f8db0'
    };
    var PIE_PALETTE = ['#2de2ff', '#2f7bff', '#2effb3', '#ffcf5c', '#ff5c7a', '#9b7bff'];
    var AXIS_LINE = { lineStyle: { color: 'rgba(111,141,176,.35)' } };
    var SPLIT_LINE = { lineStyle: { color: 'rgba(111,141,176,.12)' } };

    var charts = {};

    function init(id) {
        var el = document.getElementById(id);
        if (!el) { return null; }
        var c = echarts.init(el);
        charts[id] = c;
        return c;
    }

    function gridBox(opt) {
        return Object.assign({ left: '3%', right: '5%', top: '14%', bottom: '6%', containLabel: true }, opt || {});
    }

    /* ---------------- 各图渲染 ---------------- */

    function renderOrderStatus(d) {
        var data = (d || []).filter(function (x) { return x.value > 0; });
        charts.chartOrderStatus.setOption({
            tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
            legend: { bottom: 0, textStyle: { color: COLOR.dim, fontSize: 11 }, itemWidth: 10, itemHeight: 10 },
            color: PIE_PALETTE,
            series: [{
                type: 'pie', radius: ['46%', '68%'], center: ['50%', '44%'],
                avoidLabelOverlap: true,
                itemStyle: { borderColor: 'rgba(3,11,24,.6)', borderWidth: 2 },
                label: { color: COLOR.text, fontSize: 11, formatter: '{b}\n{c}' },
                labelLine: { length: 6, length2: 8 },
                data: data.length ? data : [{ name: '暂无工单', value: 1, itemStyle: { color: 'rgba(111,141,176,.25)' } }]
            }]
        });
    }

    function renderProcessOutput(d) {
        var flow = d || [];
        charts.chartProcessOutput.setOption({
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: gridBox(),
            xAxis: { type: 'category', data: flow.map(function (x) { return x.operDesc; }),
                axisLine: AXIS_LINE, axisLabel: { color: COLOR.dim, fontSize: 10, interval: 0, rotate: flow.length > 4 ? 16 : 0 } },
            yAxis: { type: 'value', axisLine: AXIS_LINE, splitLine: SPLIT_LINE, axisLabel: { color: COLOR.dim } },
            series: [{
                type: 'bar', barWidth: '46%', data: flow.map(function (x) { return x.ok; }),
                itemStyle: {
                    barBorderRadius: [4, 4, 0, 0],
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: COLOR.accent }, { offset: 1, color: 'rgba(47,123,255,.25)' }])
                },
                label: { show: true, position: 'top', color: COLOR.text, fontSize: 11 }
            }]
        });
    }

    function renderInventory(d) {
        var arr = (d || []).slice().sort(function (a, b) { return a.value - b.value; });
        charts.chartInventory.setOption({
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: gridBox({ left: '4%', top: '10%' }),
            xAxis: { type: 'value', axisLine: AXIS_LINE, splitLine: SPLIT_LINE, axisLabel: { color: COLOR.dim } },
            yAxis: { type: 'category', data: arr.map(function (x) { return x.name; }),
                axisLine: AXIS_LINE, axisLabel: { color: COLOR.text, fontSize: 11 } },
            series: [{
                type: 'bar', barWidth: '52%', data: arr.map(function (x) { return Number(x.value); }),
                itemStyle: {
                    barBorderRadius: [0, 4, 4, 0],
                    color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
                        { offset: 0, color: 'rgba(47,123,255,.25)' }, { offset: 1, color: COLOR.good }])
                },
                label: { show: true, position: 'right', color: COLOR.text, fontSize: 11 }
            }]
        });
    }

    /* 实时生产工序流：流水线视图（良率环节点 + 流光连接线 + 在制流转量）
       结构未变化时只滚动更新数字，避免每次刷新整体重绘闪烁 */
    var flowKey = '';
    function renderFlow(d) {
        var flow = d || [];
        var box = document.getElementById('flowStage');
        if (!box) { return; }
        if (!flow.length) {
            box.innerHTML = '<div class="empty">暂无采集数据</div>';
            flowKey = '';
            return;
        }
        var key = flow.map(function (x) { return x.operDesc; }).join('|');
        if (key !== flowKey) {
            flowKey = key;
            var html = '';
            flow.forEach(function (x, i) {
                if (i > 0) {
                    html += '<div class="flow-conn" style="--d:' + (i * 0.45) + 's">'
                        + '<i class="fc-line"></i>'
                        + '<i class="fc-dot"></i><i class="fc-dot d2"></i><i class="fc-dot d3"></i>'
                        + '<span class="fc-wip" data-i="' + i + '"></span></div>';
                }
                html += '<div class="flow-station" style="--d:' + (i * 0.4) + 's; --in:' + (i * 0.09) + 's">'
                    + '<div class="fs-name">' + x.operDesc + '</div>'
                    + '<div class="fs-node"><span class="fs-pct" data-i="' + i + '"></span></div>'
                    + '<div class="fs-ok"><b data-i="' + i + '">0</b><span class="u">件</span></div>'
                    + '<div class="fs-ng" data-i="' + i + '"></div>'
                    + '</div>';
            });
            box.innerHTML = html;
        }
        flow.forEach(function (x, i) {
            var ok = Number(x.ok) || 0, ng = Number(x.ng) || 0;
            var total = ok + ng;
            var pct = total ? Math.round(ok / total * 1000) / 10 : 100;
            var pctEl = box.querySelector('.fs-pct[data-i="' + i + '"]');
            if (pctEl) {
                pctEl.innerHTML = pct + '%';
                pctEl.parentNode.style.setProperty('--p', pct);
                pctEl.parentNode.className = 'fs-node' + (pct < 95 ? ' low' : '');
            }
            countTo(box.querySelector('.fs-ok b[data-i="' + i + '"]'), ok);
            var ngEl = box.querySelector('.fs-ng[data-i="' + i + '"]');
            if (ngEl) {
                if (ng > 0) { ngEl.className = 'fs-ng bad'; ngEl.innerHTML = '不良 ' + ng; }
                else { ngEl.className = 'fs-ng'; ngEl.innerHTML = '零不良'; }
            }
            if (i > 0) {
                var wip = (Number(flow[i - 1].ok) || 0) - ok;
                var wEl = box.querySelector('.fc-wip[data-i="' + i + '"]');
                if (wEl) { wEl.innerHTML = wip > 0 ? '流转中 ' + wip : ''; }
            }
        });
    }

    function renderYield(v) {
        var val = Number(v) || 0;
        var ratio = Math.max(0, Math.min(1, val / 100));
        // ECharts 4 兼容：用 axisLine 颜色分段表现进度弧
        var lineColor = ratio >= 0.999
            ? [[1, COLOR.good]]
            : [[ratio, COLOR.good], [1, 'rgba(111,141,176,.22)']];
        charts.chartYield.setOption({
            series: [{
                type: 'gauge', radius: '80%', center: ['50%', '54%'],
                startAngle: 215, endAngle: -35, min: 0, max: 100, splitNumber: 5,
                axisLine: { lineStyle: { width: 14, color: lineColor } },
                axisTick: { show: false },
                splitLine: { length: 12, lineStyle: { color: 'rgba(111,141,176,.4)', width: 1 } },
                axisLabel: { color: COLOR.dim, fontSize: 10, distance: 16 },
                pointer: { width: 4, length: '62%' },
                itemStyle: { color: COLOR.good },
                detail: { formatter: '{value}%', color: COLOR.good, fontSize: 26, offsetCenter: [0, '58%'] },
                title: { show: false },
                data: [{ value: val }]
            }]
        });
    }

    function renderDefect(d) {
        var arr = d || [];
        charts.chartDefect.setOption({
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' }, formatter: '{b}: {c}%' },
            grid: gridBox({ top: '12%' }),
            xAxis: { type: 'category', data: arr.map(function (x) { return x.operDesc; }),
                axisLine: AXIS_LINE, axisLabel: { color: COLOR.dim, fontSize: 10, interval: 0, rotate: arr.length > 4 ? 16 : 0 } },
            yAxis: { type: 'value', axisLine: AXIS_LINE, splitLine: SPLIT_LINE, axisLabel: { color: COLOR.dim, formatter: '{value}%' } },
            series: [{
                type: 'bar', barWidth: '46%', data: arr.map(function (x) { return x.defectRate; }),
                itemStyle: {
                    barBorderRadius: [4, 4, 0, 0],
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: COLOR.bad }, { offset: 1, color: 'rgba(255,92,122,.18)' }])
                },
                label: { show: true, position: 'top', color: COLOR.text, fontSize: 11, formatter: '{c}%' }
            }]
        });
    }

    function renderPersonnel(d) {
        var data = (d || []).filter(function (x) { return x.value > 0; });
        charts.chartPersonnel.setOption({
            tooltip: { trigger: 'item', formatter: '{b}: {c} 人 ({d}%)' },
            legend: { bottom: 0, textStyle: { color: COLOR.dim, fontSize: 11 }, itemWidth: 10, itemHeight: 10 },
            color: PIE_PALETTE,
            series: [{
                type: 'pie', radius: ['40%', '64%'], center: ['50%', '44%'], roseType: 'radius',
                itemStyle: { borderColor: 'rgba(3,11,24,.6)', borderWidth: 2 },
                label: { color: COLOR.text, fontSize: 11, formatter: '{b} {c}' },
                labelLine: { length: 6, length2: 8 },
                data: data.length ? data : [{ name: '暂无班组', value: 1, itemStyle: { color: 'rgba(111,141,176,.25)' } }]
            }]
        });
    }

    function renderAchievement(list) {
        var box = document.getElementById('achList');
        if (!box) { return; }
        if (!list || !list.length) { box.innerHTML = '<div class="empty">暂无工单数据</div>'; return; }
        var html = '';
        list.forEach(function (it) {
            var rate = Number(it.rate) || 0;
            var w = Math.min(100, rate);
            html += '<div class="ach-row">'
                + '<div class="ach-head"><span class="ach-name">' + (it.desc || it.orderCode) + '</span>'
                + '<span class="ach-code">' + (it.orderCode || '') + '</span>'
                + '<span class="ach-val"><b>' + it.completedQty + '</b> / ' + it.planQty + '　' + rate + '%</span></div>'
                + '<div class="ach-bar"><span style="width:' + w + '%"></span></div></div>';
        });
        box.innerHTML = html;
    }

    /* ---------------- KPI 数字动画 ---------------- */
    function countTo(el, target, suffix) {
        if (!el) { return; }
        var from = parseFloat(el.getAttribute('data-v')) || 0;
        var to = Number(target) || 0;
        el.setAttribute('data-v', to);
        var start = null, dur = 900;
        function step(ts) {
            if (!start) { start = ts; }
            var p = Math.min(1, (ts - start) / dur);
            var val = from + (to - from) * (1 - Math.pow(1 - p, 3));
            var shown = (to % 1 === 0) ? Math.round(val) : val.toFixed(1);
            el.innerHTML = shown + (suffix || '');
            if (p < 1) { requestAnimationFrame(step); }
        }
        requestAnimationFrame(step);
    }

    function renderOverview(o) {
        o = o || {};
        countTo(document.getElementById('kpiOrder'), o.orderCount);
        countTo(document.getElementById('kpiPlan'), o.planQty);
        countTo(document.getElementById('kpiDone'), o.completedQty);
        countTo(document.getElementById('kpiWip'), o.inProcessQty);
        countTo(document.getElementById('kpiYield'), o.yieldRate, '<span class="unit">%</span>');
    }

    /* ---------------- 数据加载 ---------------- */
    // 单个图表渲染异常不应中断其余图表
    function safe(fn) {
        try { fn(); } catch (e) { if (window.console) { console.error('[dashboard]', e); } }
    }

    function load() {
        $.post(window.DASHBOARD_DATA_URL, function (res) {
            if (!res || res.code !== 0 || !res.data) { return; }
            var d = res.data;
            safe(function () { renderOverview(d.overview); });
            safe(function () { renderOrderStatus(d.orderStatus && d.orderStatus.status); });
            safe(function () { renderProcessOutput(d.processFlow); });
            safe(function () { renderInventory(d.inventory && d.inventory.byWarehouse); });
            safe(function () { renderFlow(d.processFlow); });
            safe(function () { renderYield(d.defect && d.defect.overallYield); });
            safe(function () { renderDefect(d.defect && d.defect.perProcess); });
            safe(function () { renderPersonnel(d.personnel); });
            safe(function () { renderAchievement(d.achievement); });
        });
    }

    /* ---------------- 时钟 ---------------- */
    function tick() {
        var dt = new Date();
        var p = function (n) { return n < 10 ? '0' + n : n; };
        var s = dt.getFullYear() + '-' + p(dt.getMonth() + 1) + '-' + p(dt.getDate())
            + '  ' + p(dt.getHours()) + ':' + p(dt.getMinutes()) + ':' + p(dt.getSeconds());
        var el = document.getElementById('clock');
        if (el) { el.innerHTML = s; }
    }

    /* ---------------- 启动 ---------------- */
    $(function () {
        ['chartOrderStatus', 'chartProcessOutput', 'chartInventory',
            'chartYield', 'chartDefect', 'chartPersonnel'].forEach(init);

        tick();
        setInterval(tick, 1000);
        load();
        setInterval(load, 30000);

        $(window).on('resize', function () {
            Object.keys(charts).forEach(function (k) { if (charts[k]) { charts[k].resize(); } });
        });

        // 隐藏加载层
        setTimeout(function () {
            var ld = document.querySelector('.loading');
            if (ld) { ld.style.opacity = '0'; setTimeout(function () { ld.style.display = 'none'; }, 600); }
        }, 700);
    });
})();
