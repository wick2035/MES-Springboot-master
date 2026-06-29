<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <title>数字孪生 · 生产线</title>
    <style>
        * { box-sizing: border-box; }
        html, body { margin: 0; height: 100%; overflow: hidden; }
        body {
            font-family: "PingFang SC", "Microsoft YaHei", "Helvetica Neue", Arial, sans-serif;
            color: #2a3340;
            /* 浅色"棚拍"工作室渐变背景 */
            background:
                radial-gradient(120% 80% at 50% -10%, #ffffff 0%, #eef2f7 48%, #e3e9f1 100%);
        }

        /* 3D 舞台 */
        #stage { position: fixed; inset: 0; z-index: 1; }
        #stage canvas { display: block; }

        /* 叠加层：默认不挡鼠标，保证 3D 可自由旋转 */
        .overlay { position: fixed; inset: 0; z-index: 5; pointer-events: none; }

        /* 顶部标题条 */
        .topbar {
            position: absolute; top: 22px; left: 50%; transform: translateX(-50%);
            display: flex; align-items: center; gap: 14px;
            padding: 10px 22px;
            background: rgba(255, 255, 255, 0.72);
            border: 1px solid rgba(150, 170, 200, 0.35);
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(80, 110, 150, 0.14);
            backdrop-filter: blur(10px);
        }
        .topbar .live {
            display: inline-flex; align-items: center; gap: 7px;
            font-size: 13px; color: #18b88a; font-weight: 600;
        }
        .topbar .live i {
            width: 9px; height: 9px; border-radius: 50%;
            background: #18b88a; box-shadow: 0 0 0 0 rgba(24, 184, 138, .55);
            animation: pulse 1.8s infinite;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(24, 184, 138, .5); }
            70% { box-shadow: 0 0 0 10px rgba(24, 184, 138, 0); }
            100% { box-shadow: 0 0 0 0 rgba(24, 184, 138, 0); }
        }
        .topbar h1 {
            margin: 0; font-size: 21px; font-weight: 700; letter-spacing: .5px;
            background: linear-gradient(90deg, #1c2b3a, #2f6fb0);
            -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;
        }
        .topbar .clock { font-size: 13px; color: #6b7886; font-variant-numeric: tabular-nums; }
        .topbar .demo-badge {
            display: none; font-size: 11px; color: #b9701a; font-weight: 700;
            padding: 3px 9px; border-radius: 999px;
            background: rgba(255, 184, 77, .18); border: 1px solid rgba(255, 184, 77, .5);
        }

        /* 右上 KPI 卡片 */
        .kpis {
            position: absolute; top: 96px; right: 26px;
            display: flex; flex-direction: column; gap: 12px; width: 196px;
        }
        .kpi {
            background: rgba(255, 255, 255, 0.78);
            border: 1px solid rgba(150, 170, 200, 0.3);
            border-radius: 14px; padding: 13px 16px;
            box-shadow: 0 8px 24px rgba(80, 110, 150, 0.12);
            backdrop-filter: blur(8px);
        }
        .kpi .v { font-size: 28px; font-weight: 800; line-height: 1; color: #1c2b3a; font-variant-numeric: tabular-nums; }
        .kpi .v .u { font-size: 14px; font-weight: 700; color: #8a97a6; margin-left: 3px; }
        .kpi .l { margin-top: 7px; font-size: 12.5px; color: #7a879a; letter-spacing: .5px; }
        .kpi.good .v { color: #14a37a; }
        .kpi.accent .v { color: #2f6fb0; }

        /* 左下 工单达成 */
        .orders {
            position: absolute; left: 26px; bottom: 26px; width: 320px;
            background: rgba(255, 255, 255, 0.78);
            border: 1px solid rgba(150, 170, 200, 0.3);
            border-radius: 16px; padding: 14px 16px;
            box-shadow: 0 10px 30px rgba(80, 110, 150, 0.14);
            backdrop-filter: blur(8px);
        }
        .orders .hd { font-size: 14px; font-weight: 700; color: #2a3340; margin-bottom: 10px; display: flex; align-items: center; gap: 8px; }
        .orders .hd::before { content: ''; width: 4px; height: 15px; border-radius: 3px; background: linear-gradient(180deg, #2f6fb0, #18b88a); }
        .orders .row { margin-bottom: 11px; }
        .orders .row:last-child { margin-bottom: 0; }
        .orders .row .t { display: flex; justify-content: space-between; font-size: 12.5px; color: #4a5666; margin-bottom: 5px; }
        .orders .row .t b { color: #1c2b3a; font-weight: 600; }
        .orders .row .t .pct { color: #2f6fb0; font-weight: 700; font-variant-numeric: tabular-nums; }
        .orders .bar { height: 7px; border-radius: 6px; background: rgba(120, 140, 170, .16); overflow: hidden; }
        .orders .bar > i { display: block; height: 100%; border-radius: 6px; background: linear-gradient(90deg, #2f6fb0, #46c2a0); transition: width .8s ease; }

        /* 底部提示 */
        .hint {
            position: absolute; left: 50%; bottom: 18px; transform: translateX(-50%);
            font-size: 12px; color: #93a0b0;
        }

        /* 加载遮罩 */
        #loading {
            position: fixed; inset: 0; z-index: 20;
            display: flex; align-items: center; justify-content: center;
            background: radial-gradient(120% 80% at 50% -10%, #ffffff 0%, #eef2f7 60%, #e3e9f1 100%);
            color: #5b6b7d; font-size: 15px; letter-spacing: 2px;
            transition: opacity .6s ease;
        }
        #loading.hide { opacity: 0; pointer-events: none; }
    </style>
    <script type="text/javascript" src="${request.contextPath}/lib/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/three.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/OrbitControls.js"></script>
</head>
<body>

<div id="stage"></div>

<div class="overlay">
    <div class="topbar">
        <span class="live"><i></i>实时孪生</span>
        <h1 id="lineName">数字孪生 · 生产线</h1>
        <span class="demo-badge" id="demoBadge">演示数据</span>
        <span class="clock" id="clock"></span>
    </div>

    <div class="kpis">
        <div class="kpi good"><div class="v" id="kpiYield">0<span class="u">%</span></div><div class="l">综合良率</div></div>
        <div class="kpi accent"><div class="v" id="kpiWip">0</div><div class="l">在制 WIP</div></div>
        <div class="kpi"><div class="v" id="kpiTakt">0<span class="u">s</span></div><div class="l">节拍 Takt</div></div>
        <div class="kpi"><div class="v" id="kpiOutput">0</div><div class="l">日产出</div></div>
    </div>

    <div class="orders">
        <div class="hd">工单达成</div>
        <div id="orderList"></div>
    </div>

    <div class="hint">拖拽旋转 · 滚轮缩放 · 数据每 30s 刷新</div>
</div>

<div id="loading">数字孪生生产线 加载中 · · ·</div>

<script>
    window.PRODUCTION_LINE_DATA_URL = '${request.contextPath}/digital/production-line/data';
</script>
<script type="text/javascript" src="${request.contextPath}/js/mes/digitization/productionLineTwin.js?v=20260624b"></script>
</body>
</html>
