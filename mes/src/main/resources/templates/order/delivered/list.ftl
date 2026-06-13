<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>已交付工单</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body { background:#eef3f8; }
        .delivered-shell { min-height:calc(100vh - 24px); padding:18px; background:linear-gradient(180deg,#f8fafc 0%,#eef5fb 100%); }
        .delivered-head { display:flex; justify-content:space-between; gap:18px; margin-bottom:14px; color:#0f172a; }
        .delivered-head h1 { margin:0; font-size:24px; font-weight:800; letter-spacing:0; }
        .delivered-head p { margin:8px 0 0; color:#64748b; line-height:1.7; }
        .delivered-badge { align-self:flex-start; display:inline-flex; align-items:center; height:34px; padding:0 12px; border-radius:999px; background:#e0f2fe; color:#075985; border:1px solid #bae6fd; font-size:12px; font-weight:700; }
        .delivered-panel { border:1px solid #dbe5ef; border-radius:8px; background:rgba(255,255,255,.96); padding:14px; box-shadow:0 14px 36px rgba(15,23,42,.08); }
        .delivered-search { padding:12px 12px 2px; margin-bottom:12px; border-radius:8px; background:#f8fafc; border:1px solid #e5edf5; }
        .order-status { display:inline-flex; align-items:center; height:24px; padding:0 9px; border-radius:999px; font-size:12px; font-weight:700; white-space:nowrap; }
        .order-status.complete-done { color:#166534; background:#dcfce7; }
        .order-status.delivery-done { color:#075985; background:#e0f2fe; }
        .order-status.work-started { color:#047857; background:#dcfce7; }
        .order-status.work-wait { color:#8b5700; background:#fff1c7; }
        @media (max-width:980px) {
            .delivered-head { flex-direction:column; }
        }
    </style>
</head>
<body>
<div class="delivered-shell">
    <div class="delivered-head">
        <div>
            <h1>已交付工单</h1>
            <p>这里展示已经交付成功的历史工单，用于交付追溯和生产闭环查询。</p>
        </div>
        <div class="delivered-badge"><i class="fa fa-check-square-o"></i>&nbsp;历史只读</div>
    </div>
    <div class="delivered-panel">
        <form id="js-search-form" class="layui-form delivered-search" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">工单编号</label>
                    <div class="layui-input-inline"><input type="text" name="orderCodeLike" autocomplete="off" class="layui-input"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料编码</label>
                    <div class="layui-input-inline"><input type="text" name="materielLike" autocomplete="off" class="layui-input"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料名称</label>
                    <div class="layui-input-inline"><input type="text" name="materielDescLike" autocomplete="off" class="layui-input"></div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i>查询</button>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-work-status-tpl">
    {{# if(d.workStatus === 'STARTED'){ }}<span class="order-status work-started">已动工</span>{{# } else { }}<span class="order-status work-wait">未动工</span>{{# } }}
</script>
<script type="text/html" id="js-complete-status-tpl">
    <span class="order-status complete-done">已完工</span>
</script>
<script type="text/html" id="js-delivery-status-tpl">
    <span class="order-status delivery-done">已交付</span>
</script>

<script>
    layui.use(['form', 'table', 'spTable'], function () {
        var form = layui.form, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/order/delivered/page',
            height: 'full-190',
            cols: [[
                {field:'orderCode', title:'工单编号', width:150, style:'color:#0f62fe;font-weight:700;'},
                {field:'sourceOrderNo', title:'来源订单', width:150},
                {field:'orderDescription', title:'工单描述', minWidth:180},
                {field:'sourceBomCode', title:'BOM', width:130},
                {field:'materiel', title:'物料编码', width:140},
                {field:'materielDesc', title:'物料名称', width:170},
                {field:'qty', title:'数量', width:80},
                {field:'orderType', title:'类型', width:80},
                {field:'workStatusName', title:'动工状态', width:100, templet:'#js-work-status-tpl'},
                {field:'completeStatusName', title:'完工状态', width:100, templet:'#js-complete-status-tpl'},
                {field:'deliveryStatusName', title:'交付状态', width:100, templet:'#js-delivery-status-tpl'},
                {field:'workStartTime', title:'动工时间', width:170},
                {field:'completeTime', title:'完工时间', width:170},
                {field:'completeUsername', title:'完工人', width:110},
                {field:'deliveryTime', title:'交付时间', width:170},
                {field:'deliveryUsername', title:'交付人', width:110}
            ]]
        });
        form.on('submit(js-search-filter)', function(data){
            tableIns.reload({where:data.field, page:{curr:1}});
            return false;
        });
        form.render();
    });
</script>
</body>
</html>
