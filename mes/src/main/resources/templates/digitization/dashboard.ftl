<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>MES 智能制造数据中心</title>
    <script type="text/javascript" src="${request.contextPath}/lib/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/echarts/echarts.min.js"></script>
    <link rel="stylesheet" href="${request.contextPath}/css/dashboard.css?v=20260610">
</head>
<body>

<div class="loading">
    <span class="ld-text">智能制造数据中心 加载中</span><span class="ld-dot"></span>
</div>

<div class="head">
    <div class="live"><i></i>实时数据 · 30s 刷新</div>
    <h1>MES 智能制造数据中心<span class="dot">.</span></h1>
    <div class="clock" id="clock"></div>
</div>

<div class="main">
    <!-- 左列 -->
    <div class="col col-side">
        <div class="panel">
            <div class="p-title"><i></i>生产订单状态<span class="p-sub">按工单状态</span></div>
            <div class="p-body"><div class="chart" id="chartOrderStatus"></div></div>
        </div>
        <div class="panel">
            <div class="p-title"><i></i>工序产出分布<span class="p-sub">各工序合格产出</span></div>
            <div class="p-body"><div class="chart" id="chartProcessOutput"></div></div>
        </div>
        <div class="panel">
            <div class="p-title"><i></i>库房库存分布<span class="p-sub">实时库存量</span></div>
            <div class="p-body"><div class="chart" id="chartInventory"></div></div>
        </div>
    </div>

    <!-- 中列 -->
    <div class="col col-center">
        <div class="kpi">
            <div class="kpi-card"><div class="kpi-num" id="kpiOrder">0</div><div class="kpi-label">生产工单</div></div>
            <div class="kpi-card"><div class="kpi-num" id="kpiPlan">0</div><div class="kpi-label">计划总产量</div></div>
            <div class="kpi-card"><div class="kpi-num" id="kpiDone">0</div><div class="kpi-label">已完成</div></div>
            <div class="kpi-card"><div class="kpi-num" id="kpiWip">0</div><div class="kpi-label">在制中</div></div>
            <div class="kpi-card good"><div class="kpi-num" id="kpiYield">0<span class="unit">%</span></div><div class="kpi-label">综合良率</div></div>
        </div>
        <div class="panel">
            <div class="p-title"><i></i>实时生产工序流<span class="p-sub">SN 过程采集 · 实时流转</span></div>
            <div class="p-body"><div class="flow-stage" id="flowStage"></div></div>
        </div>
        <div class="panel">
            <div class="p-title"><i></i>工单达成率<span class="p-sub">完成数 / 计划数</span></div>
            <div class="p-body"><div class="ach-list" id="achList"></div></div>
        </div>
    </div>

    <!-- 右列 -->
    <div class="col col-side">
        <div class="panel">
            <div class="p-title"><i></i>综合良率<span class="p-sub">OK / (OK+NG)</span></div>
            <div class="p-body"><div class="chart" id="chartYield"></div></div>
        </div>
        <div class="panel">
            <div class="p-title"><i></i>工序不良分析<span class="p-sub">各工序不良率</span></div>
            <div class="p-body"><div class="chart" id="chartDefect"></div></div>
        </div>
        <div class="panel">
            <div class="p-title"><i></i>班组人员分布<span class="p-sub">在册人数</span></div>
            <div class="p-body"><div class="chart" id="chartPersonnel"></div></div>
        </div>
    </div>
</div>

<script>
    window.DASHBOARD_DATA_URL = '${request.contextPath}/digitization/dashboard/data';
</script>
<script type="text/javascript" src="${request.contextPath}/js/mes/digitization/dashboard.js?v=20260610"></script>
</body>
</html>
