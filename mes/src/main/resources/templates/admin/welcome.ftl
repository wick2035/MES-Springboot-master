<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>首页</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        html, body { height: 100%; }
        body { background: var(--sp-bg); }

        .home-wrap {
            padding: 16px;
            min-height: 100%;
        }

        /* 顶部品牌 Hero */
        .home-hero {
            position: relative;
            overflow: hidden;
            border-radius: 12px;
            padding: 30px 32px;
            color: #fff;
            background: linear-gradient(120deg, #2563EB 0%, #1D4ED8 58%, #1E3A8A 100%);
            box-shadow: 0 14px 34px rgba(37, 99, 235, .22);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            flex-wrap: wrap;
        }
        .home-hero:after {
            content: "";
            position: absolute;
            right: -60px;
            top: -80px;
            width: 280px;
            height: 280px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, .16), transparent 62%);
            pointer-events: none;
        }
        .home-hero:before {
            content: "";
            position: absolute;
            inset: 0;
            background-image:
                linear-gradient(rgba(255, 255, 255, .06) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 255, 255, .06) 1px, transparent 1px);
            background-size: 44px 44px;
            mask-image: linear-gradient(90deg, #000, transparent 70%);
            -webkit-mask-image: linear-gradient(90deg, #000, transparent 70%);
            pointer-events: none;
        }
        .hero-text { position: relative; z-index: 1; }
        .hero-eyebrow {
            display: inline-block;
            font-size: 12px;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: rgba(255, 255, 255, .82);
            margin-bottom: 8px;
        }
        .hero-title { margin: 0; font-size: 28px; font-weight: 750; letter-spacing: .3px; }
        .hero-sub { margin: 10px 0 0; font-size: 14px; line-height: 1.7; color: rgba(255, 255, 255, .88); max-width: 560px; }

        .hero-clock {
            position: relative;
            z-index: 1;
            text-align: right;
            min-width: 200px;
        }
        .hero-clock .clk-time { font-size: 34px; font-weight: 700; letter-spacing: 1px; line-height: 1.1; }
        .hero-clock .clk-date { margin-top: 6px; font-size: 13px; color: rgba(255, 255, 255, .85); }

        /* 模块卡片 */
        .home-section-title {
            margin: 22px 2px 12px;
            font-size: 14px;
            font-weight: 600;
            color: var(--sp-text);
            position: relative;
            padding-left: 12px;
        }
        .home-section-title:before {
            content: "";
            position: absolute;
            left: 0; top: 2px;
            width: 3px; height: 15px;
            border-radius: 2px;
            background: var(--sp-primary);
        }

        .home-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }
        .home-card {
            background: var(--sp-surface);
            border: 1px solid var(--sp-border);
            border-radius: 10px;
            padding: 18px;
            box-shadow: var(--sp-shadow-sm);
            transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
        }
        .home-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--sp-shadow-lg);
            border-color: var(--sp-primary-border);
        }
        .home-card .card-ico {
            width: 44px; height: 44px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px;
            margin-bottom: 14px;
            background: var(--sp-primary-tint);
            color: var(--sp-primary);
        }
        .home-card.tone-green .card-ico { background: var(--sp-success-tint); color: var(--sp-success); }
        .home-card.tone-amber .card-ico { background: var(--sp-warning-tint); color: var(--sp-warning); }
        .home-card.tone-slate .card-ico { background: #EEF1F5; color: var(--sp-text-secondary); }
        .home-card h3 { margin: 0 0 6px; font-size: 15px; font-weight: 600; color: var(--sp-text); }
        .home-card p { margin: 0; font-size: 12.5px; line-height: 1.7; color: var(--sp-text-secondary); }

        /* 系统信息条 */
        .home-info {
            margin-top: 18px;
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 0;
            background: var(--sp-surface);
            border: 1px solid var(--sp-border);
            border-radius: 10px;
            box-shadow: var(--sp-shadow-sm);
            overflow: hidden;
        }
        .home-info .info-item {
            padding: 16px 18px;
            border-right: 1px solid var(--sp-border);
        }
        .home-info .info-item:last-child { border-right: none; }
        .home-info .info-item .lbl { font-size: 12px; color: var(--sp-text-muted); }
        .home-info .info-item .val { margin-top: 6px; font-size: 15px; font-weight: 600; color: var(--sp-text); }

        @media screen and (max-width: 1100px) {
            .home-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .home-info { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .home-info .info-item:nth-child(2) { border-right: none; }
        }
        @media screen and (max-width: 600px) {
            .home-grid, .home-info { grid-template-columns: 1fr; }
            .home-info .info-item { border-right: none; border-bottom: 1px solid var(--sp-border); }
            .hero-clock { text-align: left; }
        }
    </style>
</head>
<body>
<div class="home-wrap">
    <div class="home-hero">
        <div class="hero-text">
            <span class="hero-eyebrow">Manufacturing Execution System</span>
            <h1 class="hero-title">欢迎回来，开启今天的智造工作</h1>
            <p class="hero-sub">黑科制造 MES —— 统一管理基础数据、工艺设计、生产工单与现场执行，让制造过程清晰可控、数据可追溯。</p>
        </div>
        <div class="hero-clock">
            <div class="clk-time" id="clk-time">--:--:--</div>
            <div class="clk-date" id="clk-date">--</div>
        </div>
    </div>

    <div class="home-section-title">核心模块</div>
    <div class="home-grid">
        <div class="home-card">
            <div class="card-ico"><i class="fa fa-database"></i></div>
            <h3>基础数据</h3>
            <p>物料、仓库、设备、班组与加工单元等主数据的统一维护。</p>
        </div>
        <div class="home-card tone-green">
            <div class="card-ico"><i class="fa fa-sitemap"></i></div>
            <h3>工艺设计</h3>
            <p>BOM 层级、工序工艺、工艺路线与流程内容的设计管理。</p>
        </div>
        <div class="home-card tone-amber">
            <div class="card-ico"><i class="fa fa-list-alt"></i></div>
            <h3>生产工单</h3>
            <p>生产订单的下达、进度跟踪与现场执行闭环管控。</p>
        </div>
        <div class="home-card tone-slate">
            <div class="card-ico"><i class="fa fa-cogs"></i></div>
            <h3>系统管理</h3>
            <p>用户、角色、菜单、部门与数据字典的权限化配置。</p>
        </div>
    </div>

    <div class="home-section-title">系统信息</div>
    <div class="home-info">
        <div class="info-item">
            <div class="lbl">系统名称</div>
            <div class="val">黑科制造 MES</div>
        </div>
        <div class="info-item">
            <div class="lbl">技术栈</div>
            <div class="val">Spring Boot · MyBatis-Plus</div>
        </div>
        <div class="info-item">
            <div class="lbl">前端框架</div>
            <div class="val">layui · sp 组件</div>
        </div>
        <div class="info-item">
            <div class="lbl">当前日期</div>
            <div class="val" id="info-date">--</div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var WEEK = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    function p(s) { return s < 10 ? '0' + s : s; }
    function showTime() {
        var n = new Date();
        var time = p(n.getHours()) + ':' + p(n.getMinutes()) + ':' + p(n.getSeconds());
        var date = n.getFullYear() + '年' + p(n.getMonth() + 1) + '月' + p(n.getDate()) + '日 ' + WEEK[n.getDay()];
        document.getElementById('clk-time').innerText = time;
        document.getElementById('clk-date').innerText = date;
        document.getElementById('info-date').innerText = date;
    }
    showTime();
    setInterval(showTime, 1000);
</script>
</body>
</html>
