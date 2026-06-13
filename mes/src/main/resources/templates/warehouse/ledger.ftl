<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库房台账查询</title>
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
        .wh-kpis{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-bottom:12px;}
        .wh-kpi{padding:12px 14px;background:#fff;border:1px solid var(--sp-border);border-radius:8px;box-shadow:var(--sp-shadow-sm);}
        .wh-kpi span{display:block;color:var(--sp-text-muted);font-size:12px;}
        .wh-kpi b{display:block;margin-top:5px;font-size:22px;color:var(--sp-primary);}
    </style>
</head>
<body>
<div class="wh-page">
    <div class="wh-head"><h2>库房台账查询</h2><p>按库房和物料汇总入库、出库与当前结存，结果由库存流水和库存明细共同校验。</p></div>
    <div class="wh-kpis">
        <div class="wh-kpi"><span>入库合计</span><b id="inQty">0</b></div>
        <div class="wh-kpi"><span>出库合计</span><b id="outQty">0</b></div>
        <div class="wh-kpi"><span>结存合计</span><b id="balQty">0</b></div>
    </div>
    <div class="wh-panel">
        <form class="layui-form wh-search" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline"><label class="layui-form-label">库房</label><div class="layui-input-inline"><select name="warehouseId" id="warehouseId"><option value="">全部库房</option></select></div></div>
                <div class="layui-inline"><label class="layui-form-label">物料</label><div class="layui-input-inline"><input name="materialLike" class="layui-input"></div></div>
                <button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button>
            </div>
        </form>
        <table class="layui-hide" id="ledgerTable"></table>
    </div>
</div>
<script>
layui.use(['form','table'],function(){
    var form=layui.form,table=layui.table,contextPath='${request.contextPath}';
    $.post(contextPath + '/digital/simulation/warehouse-list',{},function(res){
        var html='<option value="">全部库房</option>';
        $.each((res.data||[]),function(_,w){html+='<option value="'+w.id+'">'+esc(w.warehouseCode)+' '+esc(w.warehouseName)+'</option>';});
        $('#warehouseId').html(html);form.render('select');
    });
    function load(){
        $.post(contextPath + '/warehouse/ledger/list',form.val('queryForm'),function(res){
            var rows=res.data||[], inQty=0,outQty=0,balQty=0;
            $.each(rows,function(_,r){inQty+=Number(r.inboundQty||0);outQty+=Number(r.outboundQty||0);balQty+=Number(r.balanceQty||0);});
            $('#inQty').text(inQty.toFixed(2));$('#outQty').text(outQty.toFixed(2));$('#balQty').text(balQty.toFixed(2));
            table.render({elem:'#ledgerTable',data:rows,height:'full-260',page:true,cols:[[
                {field:'warehouseCode',title:'库房编码',width:130},
                {field:'warehouseName',title:'库房名称',width:170},
                {field:'materialCode',title:'物料编码',width:140},
                {field:'materialName',title:'物料名称',minWidth:180},
                {field:'inboundQty',title:'入库',width:110},
                {field:'outboundQty',title:'出库',width:110},
                {field:'balanceQty',title:'结存',width:110,style:'font-weight:800;color:var(--sp-primary);'},
                {field:'lastOperateTime',title:'最后流水时间',width:170}
            ]],done:function(){
                $('#ledgerTable').next('.layui-table-view').addClass('sp-production-table-view');
            }});
        });
    }
    form.on('submit(search)',function(){load();return false;});
    load();
    function esc(v){return $('<div/>').text(v==null?'':v).html();}
});
</script>
</body>
</html>
