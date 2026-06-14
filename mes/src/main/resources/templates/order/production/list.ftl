<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <link rel="stylesheet" href="${request.contextPath}/lib/gantt/css/style.css" media="all">
    <style>
        body { background:#eef3f8; }
        .order-command { min-height:calc(100vh - 24px); padding:18px; background:linear-gradient(180deg,#f8fafc 0%,#f7fbff 45%,#e9f0f6 100%); }
        .order-hero { display:flex; justify-content:space-between; gap:18px; color:#0f172a; margin-bottom:14px; }
        .order-hero h1 { margin:0; font-size:24px; font-weight:800; letter-spacing:0; }
        .order-hero p { margin:8px 0 0; color:#64748b; line-height:1.7; }
        .order-flow-line { display:flex; align-items:center; gap:8px; min-width:430px; justify-content:flex-end; flex-wrap:wrap; }
        .order-flow-line span { height:34px; display:inline-flex; align-items:center; padding:0 12px; border-radius:999px; border:1px solid #dbe5ef; background:#fff; font-size:12px; }
        .order-flow-line i { color:#4d7894; }
        .order-kpis { display:grid; grid-template-columns:repeat(4,minmax(140px,1fr)); gap:10px; margin-bottom:14px; }
        .order-kpi { border:1px solid #d9e6f2; border-radius:8px; background:rgba(255,255,255,.94); padding:13px 14px; box-shadow:0 10px 28px rgba(15,23,42,.08); }
        .order-kpi b { display:block; color:#0f172a; font-size:20px; line-height:1; }
        .order-kpi span { display:block; margin-top:8px; color:#64748b; font-size:12px; }
        .order-panel { border:1px solid #dbe5ef; border-radius:8px; background:rgba(255,255,255,.96); padding:14px; box-shadow:0 14px 36px rgba(15,23,42,.08); }
        .order-search { padding:12px 12px 2px; margin-bottom:12px; border-radius:8px; background:#f8fafc; border:1px solid #e5edf5; }
        .order-status { display:inline-flex; align-items:center; height:24px; padding:0 9px; border-radius:999px; font-size:12px; font-weight:700; white-space:nowrap; }
        .order-status.s1 { color:#b45309; background:#fef3c7; }
        .order-status.s2 { color:#047857; background:#dcfce7; }
        .order-status.s3 { color:#1d4ed8; background:#dbeafe; }
        .order-status.s4 { color:#b91c1c; background:#fee2e2; }
        .order-status.s5 { color:#1456a0; background:#e5f0ff; }
        .order-status.work-wait { color:#8b5700; background:#fff1c7; }
        .order-status.work-started { color:#047857; background:#dcfce7; }
        .order-status.complete-wait { color:#92400e; background:#ffedd5; }
        .order-status.complete-done { color:#166534; background:#dcfce7; }
        .order-status.delivery-wait { color:#475569; background:#e2e8f0; }
        .order-status.delivery-done { color:#075985; background:#e0f2fe; }
        .order-btn-disabled { opacity:.45; cursor:not-allowed; }
        .order-gantt-wrap { margin-top:14px; padding-top:14px; border-top:1px solid #e2e8f0; }
        .order-gantt-title { display:flex; align-items:center; justify-content:space-between; height:32px; color:#0f172a; font-weight:800; }
        .order-gantt-title span { color:#64748b; font-size:12px; font-weight:400; }
        @media (max-width:980px) {
            .order-command { background:linear-gradient(180deg,#f7fbff,#e9f0f6); }
            .order-hero { color:#0f172a; flex-direction:column; }
            .order-hero p { color:#64748b; }
            .order-flow-line { min-width:0; justify-content:flex-start; }
            .order-flow-line span { color:#0f172a; background:#fff; border-color:#dbe5ef; }
            .order-kpis { grid-template-columns:repeat(2,minmax(120px,1fr)); }
        }
    </style>
</head>
<body>
<div class="order-command">
    <div class="order-hero">
        <div>
            <h1>工单管理</h1>
            <p>集中查看生产工单的审批、动工、完工与交付状态；交付成功后的工单会进入“已交付工单”历史列表。</p>
        </div>
        <div class="order-flow-line">
            <span><i class="fa fa-pencil-square-o"></i>&nbsp;订单生成工单</span>
            <i class="fa fa-angle-right"></i>
            <span><i class="fa fa-play"></i>&nbsp;动工采集</span>
            <i class="fa fa-angle-right"></i>
            <span><i class="fa fa-check"></i>&nbsp;完工交付</span>
        </div>
    </div>
    <div class="order-kpis">
        <div class="order-kpi"><b id="js-kpi-total">-</b><span>当前筛选工单</span></div>
        <div class="order-kpi"><b id="js-kpi-started">-</b><span>已动工</span></div>
        <div class="order-kpi"><b id="js-kpi-completed">-</b><span>已完工</span></div>
        <div class="order-kpi"><b id="js-kpi-wait-delivery">-</b><span>待交付</span></div>
    </div>
    <div class="order-panel">
        <form id="js-search-form" class="layui-form order-search" lay-filter="js-q-form-filter">
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
                    <label class="layui-form-label">主状态</label>
                    <div class="layui-input-inline">
                        <select name="statue">
                            <option value="">全部</option>
                            <option value="1">待审批</option>
                            <option value="2">已审批</option>
                            <option value="3">已结束</option>
                            <option value="4">已终止</option>
                            <option value="5">已下发</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">动工状态</label>
                    <div class="layui-input-inline">
                        <select name="workStatus">
                            <option value="">全部</option>
                            <option value="NOT_STARTED">未动工</option>
                            <option value="STARTED">已动工</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">完工状态</label>
                    <div class="layui-input-inline">
                        <select name="completeStatus">
                            <option value="">全部</option>
                            <option value="WAIT">待完工</option>
                            <option value="COMPLETED">已完工</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i>查询</button>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        <div class="order-gantt-wrap">
            <div class="order-gantt-title">工单计划甘特图<span>已交付工单不在当前视图展示，可在“已交付工单”菜单中查看。</span></div>
            <div id="js-gantt" class="gantt"></div>
        </div>
    </div>
</div>

<script type="text/html" id="js-status-tpl">
    {{# var status = Number(d.statue); }}
    {{# if(status === 5){ }}<span class="order-status s5">已下发</span>{{# } else if(status === 2){ }}<span class="order-status s2">已审批</span>{{# } else if(status === 3){ }}<span class="order-status s3">已结束</span>{{# } else if(status === 4){ }}<span class="order-status s4">已终止</span>{{# } else { }}<span class="order-status s1">待审批</span>{{# } }}
</script>
<script type="text/html" id="js-work-status-tpl">
    {{# if(d.workStatus === 'STARTED'){ }}<span class="order-status work-started">已动工</span>{{# } else { }}<span class="order-status work-wait">未动工</span>{{# } }}
</script>
<script type="text/html" id="js-complete-status-tpl">
    {{# if(d.completeStatus === 'COMPLETED'){ }}<span class="order-status complete-done">已完工</span>{{# } else { }}<span class="order-status complete-wait">待完工</span>{{# } }}
</script>
<script type="text/html" id="js-delivery-status-tpl">
    {{# if(d.deliveryStatus === 'DELIVERED'){ }}<span class="order-status delivery-done">已交付</span>{{# } else { }}<span class="order-status delivery-wait">待交付</span>{{# } }}
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    {{# if(d.workStatus !== 'STARTED'){ }}
    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="startWork"><i class="fa fa-play"></i> 动工</a>
    {{# } }}
    {{# if(d.completeStatus !== 'COMPLETED' && d.deliveryStatus !== 'DELIVERED'){ }}
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="complete"><i class="fa fa-check"></i> 完工</a>
    {{# } }}
    {{# if(d.canDeliver === true){ }}
    <a class="layui-btn layui-btn-xs" lay-event="deliver"><i class="fa fa-send"></i> 交付</a>
    {{# } else { }}
    <a class="layui-btn layui-btn-primary layui-btn-xs order-btn-disabled" lay-event="deliverBlocked"><i class="fa fa-send"></i> 交付</a>
    {{# } }}
    {{# if(${canApprove?c} && Number(d.statue) === 1){ }}
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="approve"><i class="layui-icon layui-icon-ok"></i>审批</a>
    {{# } }}
    {{# if(Number(d.statue) === 1){ }}
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
    {{# } }}
</script>

<script src="${request.contextPath}/lib/gantt/js/jquery.fn.gantt.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer, spLayer = layui.spLayer, spTable = layui.spTable;
        var canApprove = ${canApprove?c};

        var tableIns = spTable.render({
            url: '${request.contextPath}/order/release/page',
            height: 390,
            cols: [[
                {type:'checkbox'},
                {field:'orderCode', title:'工单编号', width:150, style:'color:#0f62fe;font-weight:700;'},
                {field:'sourceOrderNo', title:'来源订单', width:150},
                {field:'orderDescription', title:'工单描述', minWidth:170},
                {field:'sourceBomCode', title:'BOM', width:130},
                {field:'materiel', title:'物料编码', width:140},
                {field:'materielDesc', title:'物料名称', width:160},
                {field:'qty', title:'数量', width:80},
                {field:'orderType', title:'类型', width:80},
                {field:'completeStatus', title:'完工状态', width:105, templet:'#js-complete-status-tpl'},
                {field:'deliveryStatus', title:'交付状态', width:105, templet:'#js-delivery-status-tpl'},
                {field:'statue', title:'主状态', width:100, templet:'#js-status-tpl'},
                {field:'equipmentAssignStatusName', title:'设备派工', width:130},
                {field:'employeeAssignStatusName', title:'员工派工', width:130},
                {field:'dispatchStatusName', title:'下发状态', width:100},
                {field:'workStatusName', title:'动工状态', width:100, templet:'#js-work-status-tpl'},
                {field:'workStartTime', title:'动工时间', width:170},
                {field:'completeTime', title:'完工时间', width:170},
                {field:'deliveryTime', title:'交付时间', width:170},
                {field:'approveUsername', title:'审批人', width:110},
                {field:'approveTime', title:'审批时间', width:170},
                {fixed:'right', title:'操作', toolbar:'#js-record-table-toolbar-right', width: canApprove ? 330 : 280}
            ]],
            done:function(res){
                refreshKpis(res);
                reloadGantt();
            }
        });

        function currentFilter() { return form.val('js-q-form-filter') || {}; }
        function refreshKpis(res) {
            var rows = (res && res.data) ? res.data : [];
            if (res && res.data && res.data.records) rows = res.data.records;
            var total = rows.length, started = 0, completed = 0, waitDelivery = 0;
            $.each(rows, function(_, row){
                if (row.workStatus === 'STARTED') started++;
                if (row.completeStatus === 'COMPLETED') completed++;
                if (row.completeStatus === 'COMPLETED' && row.deliveryStatus !== 'DELIVERED') waitDelivery++;
            });
            $('#js-kpi-total').text(total);
            $('#js-kpi-started').text(started);
            $('#js-kpi-completed').text(completed);
            $('#js-kpi-wait-delivery').text(waitDelivery);
        }
        function reloadGantt() {
            spUtil.ajax({
                url:'${request.contextPath}/order/release/gantt/list',
                type:'POST',
                serializable:false,
                data:currentFilter(),
                success:function(res){
                    $('#js-gantt').empty();
                    $('#js-gantt').gantt({
                        source: res.data || [],
                        navigate:'scroll',
                        scale:'days',
                        maxScale:'months',
                        minScale:'days',
                        waitText:'加载中...',
                        itemsPerPage:8,
                        tnTitle1:'物料/工单',
                        tnTitle2:'计划',
                        onItemClick:function(dataObj){
                            if (dataObj && typeof dataObj === 'object' && Number(dataObj.statue) !== 1) {
                                layer.msg('只有待审批工单可以编辑');
                                return;
                            }
                            openEdit(dataObj);
                        }
                    });
                }
            });
        }
        function openEdit(id) {
            if (id && typeof id === 'object') {
                if (Number(id.statue) !== 1) { layer.msg('只有待审批工单可以编辑'); return; }
                id = id.id || id.dataObj || '';
            }
            spLayer.open({
                title:id ? '编辑工单' : '新增异常工单',
                area:['860px','650px'],
                spWhere:id ? {id:id} : {},
                content:'${request.contextPath}/order/release/add-or-update-ui'
            });
        }
        function reloadAll() {
            tableIns.reload();
            reloadGantt();
        }
        form.on('submit(js-search-filter)', function(data){ tableIns.reload({where:data.field, page:{curr:1}}); reloadGantt(); return false; });
        table.on('tool(js-record-table-filter)', function(obj){
            var data = obj.data;
            if (obj.event === 'edit') openEdit(data.id);
            if (obj.event === 'deliverBlocked') layer.msg(data.deliveryBlockReason || '当前工单暂不可交付');
            if (obj.event === 'startWork') {
                layer.confirm('确认该工单开始动工吗？', function(index){
                    spUtil.ajax({url:'${request.contextPath}/order/release/start-work', type:'POST', serializable:false, data:{id:data.id}, success:function(){ layer.close(index); reloadAll(); }});
                });
            }
            if (obj.event === 'complete') {
                layer.confirm('确认该工单已完工吗？', function(index){
                    spUtil.ajax({url:'${request.contextPath}/order/release/complete', type:'POST', serializable:false, data:{id:data.id}, success:function(){ layer.close(index); reloadAll(); }});
                });
            }
            if (obj.event === 'deliver') {
                layer.confirm('确认交付该工单吗？交付后将进入已交付工单历史列表。', function(index){
                    spUtil.ajax({url:'${request.contextPath}/order/release/deliver', type:'POST', serializable:false, data:{id:data.id}, success:function(){ layer.close(index); reloadAll(); }});
                });
            }
            if (obj.event === 'approve') {
                layer.confirm('确认审批通过该工单吗？', function(index){
                    spUtil.ajax({url:'${request.contextPath}/order/release/approve', type:'POST', serializable:false, data:{id:data.id}, success:function(){ layer.close(index); reloadAll(); }});
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认删除该工单吗？', function(index){
                    spUtil.ajax({url:'${request.contextPath}/order/release/delete', type:'POST', serializable:false, data:{id:data.id}, success:function(){ layer.close(index); reloadAll(); }});
                });
            }
        });
        form.render();
    });
</script>
</body>
</html>
