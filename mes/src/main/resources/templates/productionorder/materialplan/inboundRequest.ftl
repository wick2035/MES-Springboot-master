<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>入库申请单</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:var(--sp-bg);}
        .ir-page{padding:14px;}
        .ir-head{margin-bottom:12px;padding:16px 18px;background:#fff;border:1px solid var(--sp-border);border-radius:6px;box-shadow:var(--sp-shadow-sm);}
        .ir-head h2{margin:0 0 6px;font-size:20px;font-weight:800;}
        .ir-head p{margin:0;color:var(--sp-text-secondary);}
        .ir-panel{background:#fff;border:1px solid var(--sp-border);border-radius:6px;box-shadow:var(--sp-shadow-sm);overflow:hidden;}
        .ir-search{padding:12px 12px 0;background:var(--sp-surface-2);border-bottom:1px solid var(--sp-border);}
        .ir-search .layui-form-label{width:76px;}
        .ir-search .layui-input-inline{width:160px;}
        .sp-badge{display:inline-block;padding:1px 9px;font-size:12px;line-height:20px;border-radius:999px;font-weight:600;white-space:nowrap;}
        .sp-badge-info{background:var(--sp-primary-tint);color:var(--sp-primary);}
        .item-box{padding:12px;}
    </style>
</head>
<body>
<div class="ir-page">
    <div class="ir-head">
        <h2>入库申请单</h2>
        <p>由已下发的物料需求计划批量生成，当前仅作为库房后续确认入库的准备单据。</p>
    </div>
    <div class="ir-panel">
        <form class="layui-form ir-search" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline"><label class="layui-form-label">申请单号</label><div class="layui-input-inline"><input name="requestNoLike" class="layui-input"></div></div>
                <div class="layui-inline"><label class="layui-form-label">订单编号</label><div class="layui-input-inline"><input name="productionOrderNoLike" class="layui-input"></div></div>
                <div class="layui-inline"><label class="layui-form-label">状态</label><div class="layui-input-inline"><select name="status"><option value="">全部</option><option value="GENERATED">已生成</option><option value="CONFIRMED">已确认</option></select></div></div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button>
                    <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="requestTable" lay-filter="requestTable"></table>
    </div>
</div>
<script type="text/html" id="statusTpl"><span class="sp-badge sp-badge-info">{{d.status==='CONFIRMED'?'已确认':'已生成'}}</span></script>
<script type="text/html" id="opTpl"><a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="items">明细</a></script>
<script>
layui.use(['form','table','layer','spTable'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spTable=layui.spTable;
    var contextPath='${request.contextPath}';
    var tableIns=spTable.render({
        elem:'#requestTable',
        url:contextPath + '/production-order/material-plan/inbound-request/page',
        height:'full-190',
        cols:[[
            {field:'requestNo',title:'申请单号',width:170,style:'font-weight:800;color:var(--sp-primary);'},
            {field:'productionOrderNo',title:'生产订单',width:150},
            {field:'sourceBatchNo',title:'MRP批次',width:170},
            {field:'itemCount',title:'明细数量',width:100},
            {field:'totalNetQty',title:'申请总量',width:120,style:'font-weight:800;color:var(--sp-danger);'},
            {field:'status',title:'状态',width:100,templet:'#statusTpl'},
            {field:'createTime',title:'生成时间',width:170},
            {field:'remark',title:'备注'},
            {fixed:'right',title:'操作',toolbar:'#opTpl',width:90}
        ]]
    });
    function query(){return form.val('queryForm')||{};}
    function reload(){tableIns.reload({where:query(),page:{curr:1}});}
    form.on('submit(search)',function(){reload();return false;});
    $('#resetBtn').on('click',function(){setTimeout(reload,0);});
    table.on('tool(requestTable)',function(obj){
        if(obj.event==='items'){
            spUtil.ajax({url:contextPath + '/production-order/material-plan/inbound-request/items',type:'POST',serializable:false,data:{requestId:obj.data.id},success:function(res){
                var rows=res.data||[], html='<div class="item-box sp-production-detail-table"><table class="layui-table"><thead><tr><th>物料编码</th><th>物料名称</th><th>申请数量</th><th>单位</th><th>需求日期</th><th>发布日期</th></tr></thead><tbody>';
                $.each(rows,function(_,r){html+='<tr><td>'+esc(r.materialCode)+'</td><td>'+esc(r.materialName)+'</td><td>'+esc(r.requestQty)+'</td><td>'+esc(r.unit)+'</td><td>'+esc(r.requirementDate)+'</td><td>'+esc(r.releaseDate)+'</td></tr>';});
                html+='</tbody></table></div>';
                layer.open({type:1,title:'入库申请单明细 - '+obj.data.requestNo,area:['820px','520px'],content:html});
            }});
        }
    });
    function esc(v){return $('<div/>').text(v==null?'':v).html();}
    form.render();
});
</script>
</body>
</html>
