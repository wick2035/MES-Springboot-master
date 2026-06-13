<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>出入流水查询</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:var(--sp-bg);}
        .wh-page{padding:14px;}
        .wh-head{margin-bottom:12px;padding:16px 18px;background:#fff;border:1px solid var(--sp-border);border-radius:8px;box-shadow:var(--sp-shadow-sm);}
        .wh-head h2{margin:0 0 6px;font-size:21px;font-weight:800;color:#172033;}
        .wh-panel{background:#fff;border:1px solid var(--sp-border);border-radius:8px;box-shadow:var(--sp-shadow-sm);overflow:hidden;}
        .wh-search{padding:12px 12px 0;background:var(--sp-surface-2);border-bottom:1px solid var(--sp-border);}
        .wh-search .layui-form-label{width:76px;}
        .wh-search .layui-input-inline{width:150px;}
        .tag-in{color:var(--sp-success);font-weight:800}.tag-out{color:var(--sp-danger);font-weight:800}
    </style>
</head>
<body>
<div class="wh-page">
    <div class="wh-head"><h2>出入流水查询</h2><p>每一次入库和出库确认都会沉淀为不可跳过的库存流水，可追溯来源单据、库位、批号和操作人。</p></div>
    <div class="wh-panel">
        <form class="layui-form wh-search" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline"><label class="layui-form-label">单号</label><div class="layui-input-inline"><input name="requestNoLike" class="layui-input"></div></div>
                <div class="layui-inline"><label class="layui-form-label">方向</label><div class="layui-input-inline"><select name="direction"><option value="">全部</option><option value="IN">入库</option><option value="OUT">出库</option></select></div></div>
                <div class="layui-inline"><label class="layui-form-label">业务</label><div class="layui-input-inline"><select name="businessType"><option value="">全部</option><option value="MANUAL_IN">手工入库</option><option value="PLAN_IN">计划入库</option><option value="MANUAL_OUT">手工出库</option><option value="KITTING_OUT">配套出库</option></select></div></div>
                <div class="layui-inline"><label class="layui-form-label">物料</label><div class="layui-input-inline"><input name="materialLike" class="layui-input"></div></div>
                <button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button>
            </div>
        </form>
        <table class="layui-hide" id="txTable"></table>
    </div>
</div>
<script>
layui.use(['form','spTable'],function(){
    var form=layui.form,spTable=layui.spTable,contextPath='${request.contextPath}';
    var tableIns=spTable.render({elem:'#txTable',url:contextPath + '/warehouse/transaction/page',height:'full-190',cols:[[
        {field:'transaction_no',title:'流水号',width:160,style:'font-weight:800;color:var(--sp-primary);'},
        {field:'request_no',title:'来源单号',width:150},
        {field:'direction',title:'方向',width:80,templet:function(d){return d.direction==='IN'?'<span class="tag-in">入库</span>':'<span class="tag-out">出库</span>';}},
        {field:'business_type',title:'业务类型',width:120,templet:function(d){return label(d.business_type);}},
        {field:'warehouseName',title:'库房',width:140},
        {field:'locationCode',title:'库位',width:160},
        {field:'materialCode',title:'物料编码',width:130},
        {field:'materialName',title:'物料名称',minWidth:170},
        {field:'batch_no',title:'批号',width:130},
        {field:'qty',title:'数量',width:90},
        {field:'before_qty',title:'变动前',width:90},
        {field:'after_qty',title:'变动后',width:90},
        {field:'operator_username',title:'操作人',width:100},
        {field:'operate_time',title:'操作时间',width:170}
    ]]});
    form.on('submit(search)',function(){tableIns.reload({where:form.val('queryForm'),page:{curr:1}});return false;});
    function label(v){return {MANUAL_IN:'手工入库',PLAN_IN:'计划入库',MANUAL_OUT:'手工出库',KITTING_OUT:'配套出库'}[v]||v||'';}
});
</script>
</body>
</html>
