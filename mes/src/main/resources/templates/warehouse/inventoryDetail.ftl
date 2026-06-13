<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存明细查询</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:var(--sp-bg);}
        .wh-page{padding:14px;}
        .wh-head{margin-bottom:12px;padding:16px 18px;background:#fff;border:1px solid var(--sp-border);border-radius:8px;box-shadow:var(--sp-shadow-sm);}
        .wh-head h2{margin:0 0 6px;font-size:21px;font-weight:800;color:#172033;}
        .wh-head p{margin:0;color:var(--sp-text-secondary);}
        .wh-panel{background:#fff;border:1px solid var(--sp-border);border-radius:8px;box-shadow:var(--sp-shadow-sm);overflow:hidden;}
        .wh-search{padding:12px 12px 0;background:var(--sp-surface-2);border-bottom:1px solid var(--sp-border);}
        .wh-search .layui-form-label{width:76px;}
        .wh-search .layui-input-inline{width:150px;}
        .sp-badge-ok{display:inline-block;padding:1px 9px;border-radius:999px;background:var(--sp-success-tint);color:var(--sp-success);font-weight:700;font-size:12px;}
    </style>
</head>
<body>
<div class="wh-page">
    <div class="wh-head"><h2>库存明细查询</h2><p>按库房、库位、物料和批号查看当前可用库存，所有数据来自库房确认后的库存登账。</p></div>
    <div class="wh-panel">
        <form class="layui-form wh-search" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline"><label class="layui-form-label">库房</label><div class="layui-input-inline"><select name="warehouseId" id="warehouseId"><option value="">全部库房</option></select></div></div>
                <div class="layui-inline"><label class="layui-form-label">库位</label><div class="layui-input-inline"><input name="locationCodeLike" class="layui-input"></div></div>
                <div class="layui-inline"><label class="layui-form-label">物料</label><div class="layui-input-inline"><input name="materielLike" class="layui-input" placeholder="编码/名称"></div></div>
                <div class="layui-inline"><label class="layui-form-label">批号</label><div class="layui-input-inline"><input name="batchNoLike" class="layui-input"></div></div>
                <button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button>
                <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button>
            </div>
        </form>
        <table class="layui-hide" id="inventoryTable" lay-filter="inventoryTable"></table>
    </div>
</div>
<script type="text/html" id="statusTpl"><span class="sp-badge-ok">可用</span></script>
<script>
layui.use(['form','spTable'],function(){
    var form=layui.form,spTable=layui.spTable,contextPath='${request.contextPath}';
    $.post(contextPath + '/digital/simulation/warehouse-list',{},function(res){
        var html='<option value="">全部库房</option>';
        $.each((res.data||[]),function(_,w){html+='<option value="'+w.id+'">'+esc(w.warehouseCode)+' '+esc(w.warehouseName)+'</option>';});
        $('#warehouseId').html(html);form.render('select');
    });
    var tableIns=spTable.render({elem:'#inventoryTable',url:contextPath + '/warehouse/inventory/detail/page',height:'full-190',cols:[[
        {field:'warehouseCode',title:'库房',width:170,templet:function(d){return (d.warehouseCode||'')+' '+(d.warehouseName||'');}},
        {field:'locationCode',title:'库位编码',width:180,style:'font-weight:800;color:var(--sp-primary);'},
        {field:'materielCode',title:'物料编码',width:130},
        {field:'materielDesc',title:'物料名称',minWidth:180},
        {field:'batchNo',title:'批号',width:150},
        {field:'qty',title:'当前库存',width:110,style:'font-weight:800;color:var(--sp-success);'},
        {field:'unit',title:'单位',width:80},
        {field:'stockStatus',title:'状态',width:90,templet:'#statusTpl'},
        {field:'updateTime',title:'更新时间',width:170}
    ]]});
    form.on('submit(search)',function(){tableIns.reload({where:form.val('queryForm'),page:{curr:1}});return false;});
    $('#resetBtn').on('click',function(){setTimeout(function(){tableIns.reload({where:{},page:{curr:1}});},0);});
    function esc(v){return $('<div/>').text(v==null?'':v).html();}
});
</script>
</body>
</html>
