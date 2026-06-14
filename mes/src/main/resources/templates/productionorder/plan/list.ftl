<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生产订单录入</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:#f3f7fb;color:#111827;font-family:"Microsoft YaHei","PingFang SC",Arial,sans-serif;letter-spacing:0}
        .plan-page{padding:16px;box-sizing:border-box}
        .plan-hero{margin-bottom:12px}
        .hero-card,.panel{border:1px solid #d8e5ee;border-radius:8px;background:#fff;box-shadow:0 14px 34px rgba(31,65,92,.08)}
        .hero-card{padding:18px 20px;border-left:5px solid #1c75a3}
        .hero-card h1{margin:0 0 9px;font-size:25px;line-height:1.2;color:#111827;font-weight:700}
        .hero-card p{margin:0;color:#374151;font-size:13px;line-height:1.75}
        .kpis{display:grid;grid-template-columns:repeat(6,minmax(100px,1fr));gap:10px;margin-bottom:12px}
        .kpi{padding:12px;border:1px solid #d8e5ee;border-radius:8px;background:#fff;box-shadow:0 10px 26px rgba(31,65,92,.06)}
        .kpi span{display:block;color:#718396;font-size:12px}
        .kpi b{display:block;margin-top:7px;font-size:24px;color:#123b5d}
        .panel{overflow:hidden}
        .search{padding:12px 12px 0;background:#f8fbfd;border-bottom:1px solid #e4edf4}
        .search .layui-form-label{width:76px;color:#536b7f}
        .search .layui-input-inline{width:168px}
        .chip{display:inline-flex;align-items:center;height:23px;padding:0 8px;border-radius:999px;font-size:12px;font-weight:800;white-space:nowrap}
        .blue{color:#1456a0;background:#e5f0ff}
        .green{color:#0c684c;background:#ddf7e9}
        .orange{color:#8b5700;background:#fff1c7}
        .red{color:#a32222;background:#ffe1df}
        .gray{color:#596779;background:#eef2f6}
        .purple{color:#5b3aa4;background:#eee8ff}
        .product-cell b{color:#123b5d}
        .product-cell span{display:block;color:#718396;font-size:12px;margin-top:3px}
        .source-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;padding:18px;background:#f3f8fb}
        .source-card{cursor:pointer;border:1px solid #d7e5ee;border-radius:8px;background:#fff;padding:16px;min-height:126px;transition:.18s;box-sizing:border-box}
        .source-card:hover{border-color:#1c75a3;box-shadow:0 12px 26px rgba(28,117,163,.15);transform:translateY(-1px)}
        .source-card i{font-size:24px;color:#1c75a3}
        .source-card b{display:block;margin:12px 0 6px;font-size:16px;color:#123b5d}
        .source-card span{font-size:12px;color:#64788a;line-height:1.6}
        .erp-box{padding:14px;background:#f3f8fb}
        .erp-box textarea{width:100%;height:300px;box-sizing:border-box;resize:none;font-family:Consolas,monospace}
        .plan-page th[data-field="operate"] .layui-table-cell,
        .plan-page td[data-field="operate"] .layui-table-cell{padding:0 8px;overflow:visible;text-overflow:clip}
        .op-actions{display:flex;align-items:center;justify-content:center;gap:6px;white-space:nowrap}
        @media(max-width:1180px){.kpis{grid-template-columns:repeat(2,minmax(120px,1fr))}.source-grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="plan-page">
    <div class="plan-hero">
        <div class="hero-card">
            <h1>生产订单录入</h1>
            <p>承接客户需求、预测计划或 ERP 订单，锁定 BOM、产品物料、数量与交期，形成 MES 可排产的生产计划源头。订单提交审核通过后，可进行设备与员工作业派工，并在物料配套出库完成后进入生产计划下发。</p>
        </div>
    </div>

    <div class="kpis">
        <div class="kpi"><span>生产订单总数</span><b id="kpi-total">0</b></div>
        <div class="kpi"><span>需求订单</span><b id="kpi-demand">0</b></div>
        <div class="kpi"><span>预测订单</span><b id="kpi-forecast">0</b></div>
        <div class="kpi"><span>审核中</span><b id="kpi-approving">0</b></div>
        <div class="kpi"><span>待下发</span><b id="kpi-wait">0</b></div>
        <div class="kpi"><span>已下发</span><b id="kpi-dispatched">0</b></div>
    </div>

    <div class="panel">
        <form class="layui-form search" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline"><label class="layui-form-label">关键字</label><div class="layui-input-inline"><input type="text" name="keyword" placeholder="订单 / BOM / 产品" autocomplete="off" class="layui-input"></div></div>
                <div class="layui-inline"><label class="layui-form-label">订单类型</label><div class="layui-input-inline"><select name="sourceType"><option value="">全部</option><option value="DEMAND">需求订单</option><option value="FORECAST">预测订单</option></select></div></div>
                <div class="layui-inline"><label class="layui-form-label">审核状态</label><div class="layui-input-inline"><select name="approvalStatus"><option value="">全部</option><option value="DRAFT">未审核</option><option value="APPROVING">审核中</option><option value="APPROVED">已完成</option><option value="REJECTED">已驳回</option></select></div></div>
                <div class="layui-inline"><label class="layui-form-label">下发状态</label><div class="layui-input-inline"><select name="operationStatus"><option value="">全部</option><option value="NONE">未下发</option><option value="WAIT_CALC">未下发</option><option value="WAIT_ASSIGN">未下发</option><option value="ASSIGNED">未下发</option><option value="DISPATCHED">已下发</option></select></div></div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i> 查询</button>
                    <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="recordTable" lay-filter="recordTable"></table>
    </div>
</div>

<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="addDemand"><i class="layui-icon">&#xe61f;</i> 新增需求订单</button>
        <button class="layui-btn layui-btn-primary layui-btn-sm" lay-event="addForecast"><i class="fa fa-line-chart"></i> 新增预测订单</button>
        <button class="layui-btn layui-btn-normal layui-btn-sm" lay-event="export"><i class="fa fa-download"></i> 导出</button>
    </div>
</script>
<script type="text/html" id="sourceTpl">{{# if(d.sourceType === 'FORECAST'){ }}<span class="chip purple">预测订单</span>{{# } else { }}<span class="chip blue">需求订单</span>{{# } }}</script>
<script type="text/html" id="approvalTpl">{{# var m={DRAFT:['未审核','gray'],APPROVING:['审核中','orange'],APPROVED:['已完成','green'],REJECTED:['已驳回','red'],CANCELLED:['已撤销','gray']}; var x=m[d.approvalStatus]||m.DRAFT; }}<span class="chip {{x[1]}}">{{x[0]}}</span></script>
<script type="text/html" id="operationTpl">{{# var m={NONE:['未下发','gray'],WAIT_CALC:['未下发','gray'],WAIT_ASSIGN:['未下发','gray'],ASSIGNED:['未下发','blue'],DISPATCHED:['已下发','green']}; var x=m[d.operationStatus]||m.NONE; }}<span class="chip {{x[1]}}">{{x[0]}}</span></script>
<script type="text/html" id="mrpTpl">{{# var m={NONE:['未运算','gray'],CALCULATED:['已运算','blue'],COMPLETED:['已完成','green']}; var x=m[d.mrpStatus]||m.NONE; }}<span class="chip {{x[1]}}">{{x[0]}}</span>{{# if(d.mrpPlanCount){ }}<span style="margin-left:5px;color:#718396;">{{d.mrpPlanCount}}项</span>{{# } }}</script>
<script type="text/html" id="productTpl"><div class="product-cell"><b>{{d.firstProductMateriel || '-'}}</b> / {{d.firstProductName || '-'}}<span>BOM: {{d.firstBomCode || '-'}}　版本: {{d.firstBomVersion || '-'}}</span></div></script>
<script type="text/html" id="opTpl">
    <div class="op-actions">
        {{# if(d.approvalStatus !== 'APPROVING' && d.operationStatus !== 'DISPATCHED'){ }}<a class="layui-btn layui-btn-xs" lay-event="edit"><i class="fa fa-pencil"></i>修改</a>{{# } }}
        {{# if(d.approvalStatus === 'DRAFT' || d.approvalStatus === 'REJECTED' || !d.approvalStatus){ }}<a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="submit"><i class="fa fa-check-square-o"></i>提交</a>{{# } }}
        {{# if(d.mrpStatus !== 'COMPLETED'){ }}<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="mrp" title="{{d.mrpPlanCount ? '重新运算并作废旧批次' : '生成物料需求计划'}}"><i class="fa fa-calculator"></i>运算</a>{{# } }}
        {{# if(d.operationStatus !== 'DISPATCHED'){ }}<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="dispatch" title="生产计划下发"><i class="fa fa-paper-plane"></i>下发</a>{{# } }}
    </div>
</script>

<script>
layui.use(['form','table','layer','spLayer','spTable','upload'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spLayer=layui.spLayer,spTable=layui.spTable,upload=layui.upload;
    var contextPath='${request.contextPath}';
    var tableIns=spTable.render({
        elem:'#recordTable',
        url:contextPath + '/production-order/plan/page',
        height:'full-315',
        toolbar:'#toolbar',
        cols:[[
            {field:'orderNo',title:'订单编号',width:165,style:'color:#1456a0;font-weight:900;'},
            {field:'sourceType',title:'类型',width:96,templet:'#sourceTpl'},
            {field:'firstProductName',title:'BOM 信息 / 产品物料',minWidth:260,templet:'#productTpl'},
            {field:'totalQty',title:'需求数量',width:90},
            {field:'firstPlanDeliveryDate',title:'计划交付日期',width:130},
            {field:'approvalStatus',title:'审核状态',width:105,templet:'#approvalTpl'},
            {field:'mrpStatus',title:'MRP状态',width:130,templet:'#mrpTpl'},
            {field:'mrpCalcTime',title:'MRP运算时间',width:165},
            {field:'operationStatus',title:'下发状态',width:105,templet:'#operationTpl'},
            {field:'creationMethod',title:'来源方式',width:96},
            {field:'operate',fixed:'right',title:'操作',toolbar:'#opTpl',width:290}
        ]],
        done:function(){loadDashboard();}
    });

    $('body').append('<button id="hiddenUpload" type="button" style="display:none"></button>');
    upload.render({
        elem:'#hiddenUpload',
        url:contextPath + '/production-order/plan/import',
        accept:'file',
        exts:'xlsx|xls',
        field:'file',
        done:function(res){if(res.code===0){layer.msg(res.msg||'导入完成');reload();}else{layer.alert(res.msg||'导入失败');}},
        error:function(){layer.alert('导入失败，请检查文件格式');}
    });

    function query(){return form.val('queryForm')||{};}
    function reload(){tableIns.reload({where:query(),page:{curr:1}});}
    function openEditor(type,id){spLayer.open({title:id?'修改生产订单':(type==='FORECAST'?'新增预测订单':'新增需求订单'),area:['1120px','760px'],reload:false,spWhere:id?{id:id}:{sourceType:type},content:contextPath + '/production-order/plan/add-or-update-ui',spCallback:function(result){if(result&&result.code===0)reload();}});}
    function sourceChooser(type){
        var title=type==='FORECAST'?'新增预测订单':'新增需求订单';
        var html='<div class="source-grid">'
            +'<div class="source-card" data-mode="manual"><i class="fa fa-pencil"></i><b>人工手动录入</b><span>适合临时需求、样机和小批量试制。</span></div>'
            +'<div class="source-card" data-mode="excel"><i class="fa fa-file-excel-o"></i><b>Excel 导入</b><span>适合批量导入多条订单明细。</span></div>'
            +'<div class="source-card" data-mode="erp"><i class="fa fa-exchange"></i><b>ERP 集成</b><span>适合承接外部销售订单或预测计划。</span></div>'
            +'</div>';
        layer.open({type:1,title:title + ' - 选择来源',area:['720px','260px'],content:html,success:function(layero,index){
            layero.find('.source-card').on('click',function(){
                var mode=$(this).data('mode');
                layer.close(index);
                if(mode==='manual'){openEditor(type);}
                if(mode==='excel'){$('#hiddenUpload').trigger('click');}
                if(mode==='erp'){openErpSync(type);}
            });
        }});
    }
    function openErpSync(type){
        var sample={orders:[{erpSourceNo:'ERP-DEMO-001',sourceType:type,customerName:'示例客户',salesContractNo:'HT-DEMO-001',schedulingMethod:type==='FORECAST'?'FORWARD':'REVERSE',items:[{bomCode:'BOM-PC-001',productMateriel:'PC-HOST',qty:10,planDeliveryDate:'2026-06-18',leadTimeDays:1,targetCapacity:5}]}]};
        var html='<div class="erp-box"><textarea id="erpJson" class="layui-textarea">'+escapeHtml(JSON.stringify(sample,null,2))+'</textarea></div>';
        layer.open({type:1,title:'ERP 集成同步',area:['720px','520px'],content:html,btn:['同步','取消'],yes:function(index){
            var payload;
            try{payload=JSON.parse($('#erpJson').val());}catch(e){layer.msg('JSON 格式不正确');return;}
            spUtil.ajax({url:contextPath + '/production-order/plan/erp/sync',type:'POST',serializable:true,data:payload,showLoading:true,success:function(res){layer.close(index);layer.msg(res.msg||'同步完成');reload();}});
        }});
    }
    function loadDashboard(){spUtil.ajax({url:contextPath + '/production-order/plan/dashboard',type:'POST',serializable:false,success:function(res){var d=res.data||{};$('#kpi-total').text(d.total||0);$('#kpi-demand').text(d.demand||0);$('#kpi-forecast').text(d.forecast||0);$('#kpi-approving').text(d.approving||0);$('#kpi-wait').text(d.waitCalc||0);$('#kpi-dispatched').text(d.dispatched||0);}});}
    function escapeHtml(v){return $('<div/>').text(v==null?'':v).html();}

    form.on('submit(search)',function(){reload();return false;});
    $('#resetBtn').on('click',function(){setTimeout(reload,0);});
    table.on('toolbar(recordTable)',function(obj){
        if(obj.event==='addDemand')sourceChooser('DEMAND');
        if(obj.event==='addForecast')sourceChooser('FORECAST');
        if(obj.event==='export')window.location.href=contextPath + '/production-order/plan/export?' + $.param(query());
    });
    table.on('tool(recordTable)',function(obj){
        var data=obj.data;
        if(obj.event==='edit')openEditor(data.sourceType,data.id);
        if(obj.event==='submit'){
            layer.confirm('提交后将进入生产主管审批流程，确认继续？',function(index){
                spUtil.ajax({url:contextPath + '/production-order/plan/create-work-order',type:'POST',serializable:false,data:{id:data.id},showLoading:true,success:function(){layer.close(index);reload();}});
            });
        }
        if(obj.event==='mrp'){
            var msg = data.mrpPlanCount
                ? '该生产订单已有物料需求计划，确认重新执行 MRP 运算？系统会作废旧批次并生成新的物料需求计划。'
                : '确认对该生产订单执行 MRP 运算？系统会生成对应的物料需求计划。';
            layer.confirm(msg,function(index){
                spUtil.ajax({url:contextPath + '/production-order/material-plan/calculate',type:'POST',serializable:false,data:{id:data.id},showLoading:true,success:function(res){
                    layer.close(index);
                    layer.msg(res.msg || 'MRP 运算完成');
                    reload();
                }});
            });
        }
        if(obj.event==='dispatch'){
            layer.confirm('确认下发生产计划【'+data.orderNo+'】？下发后工单进入车间执行。',function(index){
                spUtil.ajax({url:contextPath + '/production-order/plan/dispatch',type:'POST',serializable:false,data:{id:data.id},showLoading:true,success:function(res){
                    layer.close(index);
                    layer.msg(res.msg || '已下发');
                    reload();
                }});
            });
        }
    });
    form.render();
    loadDashboard();
});
</script>
</body>
</html>
