<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料需求计划(明细)</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:var(--sp-bg);}
        .mrp-page{padding:14px;}
        .mrp-head{display:flex;align-items:flex-start;justify-content:space-between;gap:16px;margin-bottom:12px;padding:16px 18px;background:#fff;border:1px solid var(--sp-border);border-radius:6px;box-shadow:var(--sp-shadow-sm);}
        .mrp-title h2{margin:0 0 6px;font-size:20px;font-weight:800;color:var(--sp-text);}
        .mrp-title p{margin:0;color:var(--sp-text-secondary);line-height:1.6;}
        .mrp-kpis{display:grid;grid-template-columns:repeat(5,118px);gap:8px;}
        .mrp-kpi{padding:10px 12px;background:var(--sp-surface-2);border:1px solid var(--sp-border);border-radius:6px;}
        .mrp-kpi span{display:block;font-size:12px;color:var(--sp-text-muted);}
        .mrp-kpi b{display:block;margin-top:5px;font-size:20px;color:var(--sp-primary);}
        .mrp-back-btn{align-self:flex-start;white-space:nowrap;}
        .mrp-panel{background:#fff;border:1px solid var(--sp-border);border-radius:6px;box-shadow:var(--sp-shadow-sm);overflow:hidden;}
        .mrp-search{padding:12px 12px 0;background:var(--sp-surface-2);border-bottom:1px solid var(--sp-border);}
        .mrp-search .layui-form-label{width:76px;}
        .mrp-search .layui-input-inline{width:150px;}
        .sp-badge{display:inline-block;padding:1px 9px;font-size:12px;line-height:20px;border-radius:999px;font-weight:600;white-space:nowrap;}
        .sp-badge-info{background:var(--sp-primary-tint);color:var(--sp-primary);}
        .sp-badge-success{background:var(--sp-success-tint);color:var(--sp-success);}
        .sp-badge-muted{background:#eef1f5;color:var(--sp-text-muted);}
        .path-cell{color:var(--sp-text-muted);font-size:12px;line-height:1.5;}
        @media(max-width:1180px){.mrp-head{display:block}.mrp-kpis{grid-template-columns:repeat(2,1fr);margin-top:12px}}
    </style>
</head>
<body>
<div class="mrp-page">
    <div class="mrp-head">
        <div class="mrp-title">
            <h2>物料需求计划(明细)</h2>
            <p>基于生产订单、最新定版 BOM、库存、安全库存和提前期计算净需求。当前流程以配套出库状态作为配送状态，生成配套出库单后进入仓库确认。</p>
        </div>
        <button type="button" class="layui-btn layui-btn-primary mrp-back-btn" id="backToWeekBtn" style="display:none;"><i class="layui-icon layui-icon-return"></i> 返回查询</button>
        <div class="mrp-kpis">
            <div class="mrp-kpi"><span>计划行数</span><b id="kpi-line">0</b></div>
            <div class="mrp-kpi"><span>关联订单</span><b id="kpi-order">0</b></div>
            <div class="mrp-kpi"><span>未申请</span><b id="kpi-wait">0</b></div>
            <div class="mrp-kpi"><span>已申请</span><b id="kpi-released">0</b></div>
            <div class="mrp-kpi"><span>已完成</span><b id="kpi-inbound">0</b></div>
        </div>
    </div>

    <div class="mrp-panel">
        <form class="layui-form mrp-search" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline"><label class="layui-form-label">订单编号</label><div class="layui-input-inline"><input name="productionOrderNoLike" class="layui-input" autocomplete="off"></div></div>
                <div class="layui-inline"><label class="layui-form-label">产品</label><div class="layui-input-inline"><input name="productLike" class="layui-input" placeholder="物料/序列号" autocomplete="off"></div></div>
                <div class="layui-inline"><label class="layui-form-label">物料</label><div class="layui-input-inline"><input name="materialLike" class="layui-input" placeholder="编码/名称" autocomplete="off"></div></div>
                <div class="layui-inline"><label class="layui-form-label">配送状态</label><div class="layui-input-inline"><select name="outboundStatus"><option value="">全部</option><option value="NONE">未申请</option><option value="GENERATED">已申请</option><option value="CONFIRMED">已完成</option></select></div></div>
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
        <button class="layui-btn layui-btn-normal layui-btn-sm" lay-event="applyKitting"><i class="fa fa-paper-plane"></i> 申请</button>
        <button class="layui-btn layui-btn-warm layui-btn-sm" lay-event="kitting"><i class="fa fa-cubes"></i> 生成配套出库单</button>
        <button class="layui-btn layui-btn-primary layui-btn-sm" lay-event="reload"><i class="fa fa-refresh"></i> 刷新</button>
    </div>
</script>
<script type="text/html" id="outboundTpl">
    {{# if(d.outboundStatus==='CONFIRMED'){ }}
    <span class="sp-badge sp-badge-success">已完成</span><div style="color:var(--sp-text-muted);font-size:12px;">{{d.outboundRequestNo||''}}</div>
    {{# } else if(d.outboundStatus==='GENERATED'){ }}
    <span class="sp-badge sp-badge-info">已申请</span><div style="color:var(--sp-text-muted);font-size:12px;">{{d.outboundRequestNo||''}}</div>
    {{# } else { }}
    <span class="sp-badge sp-badge-muted">未申请</span>
    {{# } }}
</script>
<script type="text/html" id="materialTpl"><b style="color:var(--sp-primary);">{{d.materialCode||'-'}}</b><span style="margin-left:6px;">{{d.materialName||'-'}}</span></script>

<script>
layui.use(['form','table','layer','spTable'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spTable=layui.spTable;
    var contextPath='${request.contextPath}';
    function parseQuery(){
        var obj={};
        var search=window.location.search||'';
        if(search.length<=1){return obj;}
        $.each(search.substring(1).split('&'),function(_,item){
            if(!item){return;}
            var parts=item.split('=');
            var key=decodeURIComponent(parts.shift()||'');
            var value=decodeURIComponent(parts.join('=')||'');
            if(key){obj[key]=value;}
        });
        return obj;
    }
    var initialQuery=parseQuery();
    if(initialQuery.from==='week'){
        $('#backToWeekBtn').show().on('click',function(){
            if(initialQuery.returnTabId && parent.layui && parent.layui.element){
                parent.layui.element.tabChange('splayuiTab',initialQuery.returnTabId);
                return;
            }
            try{
                var weekTabId='';
                parent.$('#top_tabs li[lay-id]').each(function(){
                    var layId=parent.$(this).attr('lay-id')||'';
                    if(layId.indexOf('/production-order/material-plan/week-ui')>-1){
                        weekTabId=layId;
                        return false;
                    }
                });
                if(weekTabId && parent.layui && parent.layui.element){
                    parent.layui.element.tabChange('splayuiTab',weekTabId);
                    return;
                }
            }catch(e){}
            if(window.history.length>1){window.history.back();}
        });
    }
    form.val('queryForm',initialQuery);
    var tableIns=spTable.render({
        elem:'#recordTable',
        url:contextPath + '/production-order/material-plan/page',
        where:initialQuery,
        height:'full-245',
        toolbar:'#toolbar',
        cols:[[
            {type:'checkbox',fixed:'left'},
            {field:'productionOrderNo',title:'生产订单',width:150,style:'font-weight:700;color:var(--sp-primary);'},
            {field:'productSerialNo',title:'产品序列号',width:165},
            {field:'productName',title:'产品',width:150},
            {field:'materialCode',title:'需求物料',minWidth:240,templet:'#materialTpl'},
            {field:'grossRequirement',title:'毛需求',width:92},
            {field:'availableStock',title:'可用库存',width:92},
            {field:'safetyStock',title:'安全库存',width:92},
            {field:'netRequirement',title:'净需求',width:92,style:'font-weight:800;color:var(--sp-danger);'},
            {field:'unit',title:'单位',width:70},
            {field:'requirementDate',title:'需求日期',width:112},
            {field:'outboundStatus',title:'配送状态',width:140,templet:'#outboundTpl'}
        ]],
        done:function(){loadDashboard();}
    });
    function query(){return $.extend({},initialQuery,form.val('queryForm')||{});}
    function reload(){tableIns.reload({where:query(),page:{curr:1}});}
    function selectedIds(){
        var rows=table.checkStatus('recordTable').data||[];
        return $.map(rows,function(r){return r.id;});
    }
    function postBatch(url,ids,emptyMsg){
        if(!ids.length){layer.msg(emptyMsg);return;}
        $.ajax({
            url:url,type:'POST',contentType:'application/json;charset=UTF-8',
            data:JSON.stringify({ids:ids}),
            success:function(res){if(res.code===0){layer.msg(res.msg||'操作成功');reload();}else{layer.alert(res.msg||'操作失败');}},
            error:function(){layer.alert('请求失败，请稍后重试');}
        });
    }
    function loadDashboard(){
        spUtil.ajax({url:contextPath + '/production-order/material-plan/dashboard',type:'POST',serializable:false,data:query(),success:function(res){
            var d=res.data||{};
            $('#kpi-line').text(d.lineCount||0);
            $('#kpi-order').text(d.orderCount||0);
            $('#kpi-wait').text(d.outboundPending||0);
            $('#kpi-released').text(d.outboundGenerated||0);
            $('#kpi-inbound').text(d.outboundConfirmed||0);
        }});
    }
    form.on('submit(search)',function(){reload();return false;});
    $('#resetBtn').on('click',function(){setTimeout(reload,0);});
    table.on('toolbar(recordTable)',function(obj){
        var ids=selectedIds();
        if(obj.event==='applyKitting')postBatch(contextPath + '/production-order/material-plan/apply-kitting-outbound-request',ids,'请先勾选要申请配套出库的物料');
        if(obj.event==='kitting')postBatch(contextPath + '/production-order/material-plan/generate-kitting-outbound-request',ids,'请先勾选要生成配套出库单的物料');
        if(obj.event==='reload')reload();
    });
    form.render();
    loadDashboard();
});
</script>
</body>
</html>
