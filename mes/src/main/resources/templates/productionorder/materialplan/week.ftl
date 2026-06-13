<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料需求计划查询</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:var(--sp-bg);}
        .wk-page{padding:14px;}
        .wk-head{margin-bottom:12px;padding:16px 18px;background:#fff;border:1px solid var(--sp-border);border-radius:6px;box-shadow:var(--sp-shadow-sm);}
        .wk-head h2{margin:0 0 6px;font-size:20px;font-weight:800;}
        .wk-head p{margin:0;color:var(--sp-text-secondary);}
        .wk-panel{background:#fff;border:1px solid var(--sp-border);border-radius:6px;box-shadow:var(--sp-shadow-sm);overflow:hidden;}
        .wk-search{padding:12px 12px 0;background:var(--sp-surface-2);border-bottom:1px solid var(--sp-border);}
        .wk-search .layui-form-label{width:76px;}
        .wk-search .layui-input-inline{width:160px;}
        .wk-table-wrap{padding:14px 18px 18px;background:#fff;}
        .wk-table-wrap .layui-table-view{margin:0;border-color:var(--sp-border);}
        .wk-table-wrap .layui-table-cell{padding-left:16px;padding-right:16px;}
        .wk-table-wrap .layui-table th:first-child .layui-table-cell,
        .wk-table-wrap .layui-table td:first-child .layui-table-cell{padding-left:20px;}
        .week-key-cell{display:inline-flex;align-items:center;justify-content:center;min-width:72px;padding:3px 10px;border-radius:4px;background:var(--sp-primary-tint);color:var(--sp-primary);font-weight:800;line-height:20px;}
    </style>
</head>
<body>
<div class="wk-page">
    <div class="wk-head">
        <h2>物料需求计划（查询）</h2>
        <p>汇总查询毛需求、净需求、下发和入库申请状态，方便计划员查看采购/备料节奏。</p>
    </div>
    <div class="wk-panel">
        <form class="layui-form wk-search" lay-filter="queryForm">
            <div class="layui-form-item">
                <div class="layui-inline"><label class="layui-form-label">订单编号</label><div class="layui-input-inline"><input name="productionOrderNoLike" class="layui-input"></div></div>
                <div class="layui-inline"><label class="layui-form-label">物料</label><div class="layui-input-inline"><input name="materialLike" class="layui-input"></div></div>
                <div class="layui-inline"><label class="layui-form-label">配送状态</label><div class="layui-input-inline"><select name="deliveryStatus"><option value="">全部</option><option value="WAIT">待下发</option><option value="RELEASED">已下发</option></select></div></div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="search"><i class="layui-icon layui-icon-search"></i>查询</button>
                    <button type="reset" class="layui-btn layui-btn-primary" id="resetBtn">重置</button>
                </div>
            </div>
        </form>
        <div class="wk-table-wrap">
            <table class="layui-hide" id="weekTable" lay-filter="weekTable"></table>
        </div>
    </div>
</div>
<script type="text/html" id="weekKeyTpl"><span class="week-key-cell">{{d.weekKey||'-'}}</span></script>
<script type="text/html" id="opTpl"><a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="detail">查看明细</a></script>
<script>
layui.use(['form','table','spTable'],function(){
    var form=layui.form,table=layui.table,spTable=layui.spTable;
    var contextPath='${request.contextPath}';
    var tableIns=spTable.render({
        elem:'#weekTable',
        url:contextPath + '/production-order/material-plan/week-summary',
        height:'full-190',
        cols:[[
            {field:'weekKey',title:'需求周',width:150,templet:'#weekKeyTpl'},
            {field:'weekStartDate',title:'周内最早需求',width:130},
            {field:'weekEndDate',title:'周内最晚需求',width:130},
            {field:'orderCount',title:'关联订单',width:100},
            {field:'lineCount',title:'计划行数',width:100},
            {field:'grossRequirement',title:'毛需求合计',width:130},
            {field:'netRequirement',title:'净需求合计',width:130,style:'font-weight:800;color:var(--sp-danger);'},
            {field:'waitReleaseQty',title:'待下发数量',width:130},
            {field:'releasedQty',title:'已下发数量',width:130},
            {field:'generatedInboundQty',title:'已生成入库',width:130},
            {fixed:'right',title:'操作',toolbar:'#opTpl',width:100}
        ]]
    });
    function query(){return form.val('queryForm')||{};}
    function reload(){tableIns.reload({where:query(),page:{curr:1}});}
    function currentTabId(){
        try{
            return parent.$('#top_tabs .layui-this').attr('lay-id') || '';
        }catch(e){
            return '';
        }
    }
    function encodeQuery(data){
        var arr=[];
        $.each(data,function(key,value){
            if(value!==undefined && value!==null && value!==''){
                arr.push(encodeURIComponent(key)+'='+encodeURIComponent(value));
            }
        });
        return arr.join('&');
    }
    function detailParams(row){
        var filters=query();
        return {
            requirementDateBegin:row.weekStartDate,
            requirementDateEnd:row.weekEndDate,
            productionOrderNoLike:filters.productionOrderNoLike,
            materialLike:filters.materialLike,
            deliveryStatus:filters.deliveryStatus,
            from:'week',
            returnTabId:currentTabId()
        };
    }
    function detailUrl(row){
        var qs=encodeQuery(detailParams(row));
        return contextPath+'/production-order/material-plan/list-ui'+(qs?'?'+qs:'');
    }
    form.on('submit(search)',function(){reload();return false;});
    $('#resetBtn').on('click',function(){setTimeout(reload,0);});
    table.on('tool(weekTable)',function(obj){
        if(obj.event==='detail'){
            var detailTabId='material-plan-detail-'+(obj.data.weekKey||'all')+'-'+encodeQuery(detailParams(obj.data));
            var detailOpened=parent.spLayui && parent.spLayui.checkTab && parent.spLayui.checkTab(detailTabId,true);
            if(!detailOpened){
            var splayuiTabInfo=JSON.parse(parent.sessionStorage.getItem('splayuiTabInfo'));
            if(splayuiTabInfo==null){splayuiTabInfo={};}
            splayuiTabInfo[detailTabId]={href:detailUrl(obj.data),title:'\u7269\u6599\u9700\u6c42\u660e\u7ec6'};
            parent.sessionStorage.setItem('splayuiTabInfo',JSON.stringify(splayuiTabInfo));
            parent.layui.element.tabAdd('splayuiTab',{
                title:'物料需求明细',
                content:'<iframe width="100%" height="100%" frameborder="0" src="'+detailUrl(obj.data)+'"></iframe>',
                id:detailTabId
            });
            }
            parent.layui.element.tabChange('splayuiTab',detailTabId);
        }
    });
    form.render();
});
</script>
</body>
</html>
