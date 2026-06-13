<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生产工单查询</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:#fff;color:#111827;font-family:"SimHei","Microsoft YaHei","PingFang SC",sans-serif;letter-spacing:0}
        .page{padding:16px}.hero{margin-bottom:12px}.main{display:block}
        .card,.panel{border:1px solid #d8e5ee;border-radius:8px;background:rgba(255,255,255,.96);box-shadow:0 14px 34px rgba(31,65,92,.08)}
        .card{padding:18px 20px}.card h1{margin:0 0 9px;font-size:25px;color:#111827;font-family:"SimHei","Microsoft YaHei","PingFang SC",sans-serif;font-weight:700}.card p{margin:0;color:#374151;font-size:13px;line-height:1.75}
        .panel{overflow:hidden}.search{padding:12px 12px 0;background:#f8fbfd;border-bottom:1px solid #e4edf4}.search .layui-form-label{width:76px;color:#536b7f}.search .layui-input-inline{width:170px}
        .chip{display:inline-flex;align-items:center;height:23px;padding:0 8px;border-radius:999px;font-size:12px;font-weight:800;white-space:nowrap}.green{color:#0c684c;background:#ddf7e9}.orange{color:#8b5700;background:#fff1c7}.gray{color:#596779;background:#eef2f6}.blue{color:#1456a0;background:#e5f0ff}
    </style>
</head>
<body>
<div class="page">
    <div class="hero">
        <div class="card">
            <h1>生产工单查询</h1>
            <p>查询生产计划下发后生成的工单，跟踪来源计划、产品、工艺路线、计划时间、派工和现场状态。</p>
        </div>
    </div>
    <div class="main">
        <div class="panel">
            <form class="layui-form search" lay-filter="queryForm">
                <div class="layui-form-item">
                    <div class="layui-inline"><label class="layui-form-label">订单编号</label><div class="layui-input-inline"><input name="orderNoLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><label class="layui-form-label">产品</label><div class="layui-input-inline"><input name="productLike" autocomplete="off" class="layui-input"></div></div>
                    <div class="layui-inline"><button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button><button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button></div>
                </div>
            </form>
            <table class="layui-hide" id="recordTable" lay-filter="recordTable"></table>
        </div>
    </div>
</div>
<script type="text/html" id="approvalTpl"><span class="chip blue">{{d.approvalStatusName || '-'}}</span></script>
<script>
layui.use(['form','spTable'],function(){
    var form=layui.form,spTable=layui.spTable;
    var tableIns=spTable.render({elem:'#recordTable',url:'${request.contextPath}/production-order/work-order/page',height:'full-245',cols:[[
        {field:'workOrderCode',title:'工单编号',width:170,style:'color:#1456a0;font-weight:900;'},
        {field:'orderNo',title:'来源订单',width:160},
        {field:'productMateriel',title:'产品物料',width:150},
        {field:'productName',title:'产品名称',minWidth:170},
        {field:'qty',title:'数量',width:80},
        {field:'flowId',title:'工艺路线',width:160},
        {field:'planStartTime',title:'计划开始',width:165},
        {field:'planEndTime',title:'计划结束',width:165},
        {field:'approvalStatusName',title:'审批状态',width:100,templet:'#approvalTpl'},
        {field:'equipmentAssignStatusName',title:'设备派工',width:130},
        {field:'employeeAssignStatusName',title:'员工派工',width:130},
        {field:'dispatchStatusName',title:'下发状态',width:100},
        {field:'mainStatusName',title:'工单状态',width:100}
    ]]});
    function query(){return form.val('queryForm')||{};}
    form.on('submit(search)',function(){tableIns.reload({where:query(),page:{curr:1}});return false;});
    $('#resetBtn').on('click',function(){setTimeout(function(){tableIns.reload({where:{},page:{curr:1}});},0);});
    form.render();
});
</script>
</body>
</html>
