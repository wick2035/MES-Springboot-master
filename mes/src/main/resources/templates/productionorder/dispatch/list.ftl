<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生产计划下发</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:#fff;color:#111827;font-family:"SimHei","Microsoft YaHei","PingFang SC",sans-serif;letter-spacing:0}
        .page{padding:16px}.hero{margin-bottom:12px}.main{display:block}
        .card,.panel{border:1px solid #d8e5ee;border-radius:8px;background:rgba(255,255,255,.96);box-shadow:0 14px 34px rgba(31,65,92,.08)}
        .card{padding:18px 20px}.card h1{margin:0 0 9px;font-size:25px;color:#111827;font-family:"SimHei","Microsoft YaHei","PingFang SC",sans-serif;font-weight:700}.card p{margin:0;color:#374151;font-size:13px;line-height:1.75}
        .panel{overflow:hidden}.search{padding:12px 12px 0;background:#f8fbfd;border-bottom:1px solid #e4edf4}.search .layui-form-label{width:76px;color:#536b7f}.search .layui-input-inline{width:168px}
        .chip{display:inline-flex;align-items:center;height:23px;padding:0 8px;border-radius:999px;font-size:12px;font-weight:800;white-space:nowrap}.orange{color:#8b5700;background:#fff1c7}.green{color:#0c684c;background:#ddf7e9}.blue{color:#1456a0;background:#e5f0ff}
        .task-table{width:100%;border-collapse:collapse}.task-table th{height:36px;padding:0 8px;border-bottom:1px solid #dfe8ef;background:#f7fafc;color:#617385;text-align:left}.task-table td{padding:9px 8px;border-bottom:1px solid #edf2f6;color:#263b4e}
    </style>
</head>
<body>
<div class="page">
    <div class="hero">
        <div class="card">
            <h1>生产计划下发</h1>
            <p>只展示“工单已审批、设备与员工派工均已完成、等待下发”的生产计划。计划员按订单、产品或工序查询，确认由 BOM/工艺路线拆出的任务后执行最终下发。</p>
        </div>
    </div>
    <div class="main">
        <div class="panel">
            <form class="layui-form search" lay-filter="queryForm">
                <div class="layui-form-item">
                    <div class="layui-inline"><label class="layui-form-label">订单编号</label><div class="layui-input-inline"><input name="orderNoLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><label class="layui-form-label">产品</label><div class="layui-input-inline"><input name="productLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><label class="layui-form-label">工序</label><div class="layui-input-inline"><input name="operLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button><button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button></div>
                </div>
            </form>
            <table class="layui-hide" id="recordTable" lay-filter="recordTable"></table>
        </div>
    </div>
</div>

<script type="text/html" id="statusTpl"><span class="chip orange">待下发</span></script>
<script type="text/html" id="productTpl"><b>{{d.firstProductMateriel || '-'}}</b> / {{d.firstProductName || '-'}}</script>
<script type="text/html" id="opTpl"><a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">拆分任务</a><a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="dispatch">下发</a></script>

<script>
layui.use(['form','table','layer','spTable'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spTable=layui.spTable;
    var tableIns=spTable.render({elem:'#recordTable',url:'${request.contextPath}/production-order/dispatch/page',height:'full-260',cols:[[
        {field:'orderNo',title:'订单编号',width:170,style:'color:#1456a0;font-weight:900;'},
        {field:'firstProductName',title:'产品物料',minWidth:230,templet:'#productTpl'},
        {field:'totalQty',title:'需求数量',width:90},
        {field:'firstPlanStartDate',title:'计划开工',width:120},
        {field:'firstPlanDeliveryDate',title:'计划完工',width:120},
        {field:'operationStatus',title:'计划状态',width:100,templet:'#statusTpl'},
        {fixed:'right',title:'操作',toolbar:'#opTpl',width:150}
    ]]});
    function query(){return form.val('queryForm')||{};}
    function reload(){tableIns.reload({where:query(),page:{curr:1}});}
    function esc(v){return $('<div/>').text(v==null?'':v).html();}
    function openDetail(row){
        $.post('${request.contextPath}/production-order/plan/dispatch-detail',{id:row.id},function(res){
            var tasks=(res.data||{}).tasks||[],html='<div class="sp-production-detail-table"><table class="task-table"><thead><tr><th>产品序列号</th><th>任务序列号</th><th>产品物料名称</th><th>工序名称</th><th>计划开工/完工</th></tr></thead><tbody>';
            $.each(tasks,function(_,t){html+='<tr><td>'+esc(t.productSerialNo)+'</td><td><b>'+esc(t.taskSerialNo)+'</b></td><td>'+esc(t.productName||t.productMateriel)+'</td><td>'+esc(t.operDesc||t.oper)+'</td><td>'+esc(t.planStartTime||'-')+' 至 '+esc(t.planEndTime||'-')+'</td></tr>';});
            if(!tasks.length)html+='<tr><td colspan="5" style="text-align:center;color:#718396;">暂无任务，请检查 BOM 与工艺路线。</td></tr>';
            html+='</tbody></table></div>';
            layer.open({type:1,title:'计划拆分任务 - '+row.orderNo,area:['1050px','560px'],content:html,
                btn:['确认下发','关闭'],
                yes:function(idx){postDispatch(row,function(){layer.close(idx);});},
                btn2:function(idx){layer.close(idx);}});
        });
    }
    function postDispatch(row,onSuccess){
        $.post('${request.contextPath}/production-order/plan/dispatch',{id:row.id},function(res){
            if(res.code===0){layer.msg(res.msg||'已下发');reload();if(onSuccess)onSuccess();}
            else{layer.msg(res.msg||'下发失败');}
        });
    }
    form.on('submit(search)',function(){reload();return false;});
    $('#resetBtn').on('click',function(){setTimeout(reload,0);});
    table.on('tool(recordTable)',function(obj){
        var data=obj.data;
        if(obj.event==='detail')openDetail(data);
        if(obj.event==='dispatch'){
            layer.confirm('确认下发生产计划【'+data.orderNo+'】？下发后工单进入车间执行。',function(idx){
                layer.close(idx);
                postDispatch(data);
            });
        }
    });
    form.render();
});
</script>
</body>
</html>
