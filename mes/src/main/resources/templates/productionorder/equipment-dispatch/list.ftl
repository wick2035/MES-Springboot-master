<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备作业派工</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:#fff;color:#111827;font-family:"SimHei","Microsoft YaHei","PingFang SC",sans-serif;letter-spacing:0}
        .page{padding:16px}.hero{margin-bottom:12px}.main{display:block}
        .card,.panel{border:1px solid #d8e5ee;border-radius:8px;background:rgba(255,255,255,.96);box-shadow:0 14px 34px rgba(31,65,92,.08)}
        .card{padding:18px 20px}.card h1{margin:0 0 9px;font-size:25px;color:#111827;font-family:"SimHei","Microsoft YaHei","PingFang SC",sans-serif;font-weight:700}.card p{margin:0;color:#374151;font-size:13px;line-height:1.75}
        .panel{overflow:hidden}.search{padding:12px 12px 0;background:#f8fbfd;border-bottom:1px solid #e4edf4}.search .layui-form-label{width:76px;color:#536b7f}.search .layui-input-inline{width:160px}
        .chip{display:inline-flex;align-items:center;height:23px;padding:0 8px;border-radius:999px;font-size:12px;font-weight:800;white-space:nowrap}.green{color:#0c684c;background:#ddf7e9}.orange{color:#8b5700;background:#fff1c7}.gray{color:#596779;background:#eef2f6}.blue{color:#1456a0;background:#e5f0ff}
    </style>
</head>
<body>
<div class="page">
    <div class="hero">
        <div class="card">
            <h1>设备作业派工</h1>
            <p>面向已审批且尚未下发的工序任务，将每道工序绑定到具体设备或设备组。候选资源来自设备主数据、设备编组以及工艺-设备关联，保存后形成设备级执行责任，为后续生产订单下发提供前置条件。</p>
        </div>
    </div>
    <div class="main">
        <div class="panel">
            <form class="layui-form search" lay-filter="queryForm">
                <div class="layui-form-item">
                    <div class="layui-inline"><label class="layui-form-label">订单编号</label><div class="layui-input-inline"><input name="orderNoLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><label class="layui-form-label">产品</label><div class="layui-input-inline"><input name="productLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><label class="layui-form-label">工序</label><div class="layui-input-inline"><input name="operLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><label class="layui-form-label">派工状态</label><div class="layui-input-inline"><select name="assignStatus"><option value="">全部</option><option value="WAIT">待派工</option><option value="ASSIGNED">已派工</option></select></div></div>
                    <div class="layui-inline"><button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button><button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button></div>
                </div>
            </form>
            <table class="layui-hide" id="recordTable" lay-filter="recordTable"></table>
        </div>
    </div>
</div>
<script type="text/html" id="assignTpl">{{# if(d.equipmentId){ }}<span class="chip green">已派工</span>{{# } else { }}<span class="chip orange">待派工</span>{{# } }}</script>
<script type="text/html" id="equipmentTpl">{{# if(d.equipmentId){ }}<b>{{d.equipmentCode || '-'}}</b> / {{d.equipmentName || '-'}}{{# } else { }}<span style="color:#8b5700;">未分配设备</span>{{# } }}</script>
<script type="text/html" id="opTpl"><a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="assign">选择设备</a></script>
<script>
layui.use(['form','table','layer','spLayer','spTable'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spLayer=layui.spLayer,spTable=layui.spTable;
    var tableIns=spTable.render({elem:'#recordTable',url:'${request.contextPath}/production-order/equipment-dispatch/page',height:'full-255',cols:[[
        {field:'orderNo',title:'订单编号',width:150},
        {field:'workOrderCode',title:'工单编号',width:165,style:'color:#1456a0;font-weight:900;'},
        {field:'productName',title:'产品物料',minWidth:190,templet:function(d){return (d.productMateriel||'-')+' / '+(d.productName||'-');}},
        {field:'operDesc',title:'工序',minWidth:170,templet:function(d){return (d.sortNum||'-')+'. '+(d.operDesc||d.oper||'-');}},
        {field:'planStartTime',title:'计划开始',width:160},
        {field:'planEndTime',title:'计划结束',width:160},
        {field:'equipmentName',title:'设备',minWidth:190,templet:'#equipmentTpl'},
        {field:'equipmentStatus',title:'派工状态',width:100,templet:'#assignTpl'},
        {fixed:'right',title:'操作',toolbar:'#opTpl',width:100}
    ]]});
    function query(){return form.val('queryForm')||{};}
    function reload(){tableIns.reload({where:query(),page:{curr:1}});}
    table.on('tool(recordTable)',function(obj){
        if(obj.event==='assign'){
            var row=obj.data;
            spLayer.open({title:'选择生产设备 - '+(row.operDesc||row.oper||''),area:['900px','620px'],content:'${request.contextPath}/basedata/equipment-group/device-select-ui',spCallback:function(result){
                var ids=(result&&result.data)||[];
                if(!ids.length){layer.msg('请选择一台设备');return;}
                $.post('${request.contextPath}/production-order/equipment-dispatch/save',{operPlanId:row.operPlanId,equipmentId:ids[0]},function(res){
                    if(res.code===0){layer.msg(res.msg||'设备派工已保存');reload();}else{layer.alert(res.msg||'保存失败');}
                });
            }});
        }
    });
    form.on('submit(search)',function(){reload();return false;});
    $('#resetBtn').on('click',function(){setTimeout(reload,0);});
    form.render();
});
</script>
</body>
</html>
