<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:#eef2f7;}
        .wh-page{padding:14px;color:#172033;}
        .wh-hero{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:12px;padding:18px 20px;background:linear-gradient(135deg,#ffffff 0%,#f7fbff 100%);border:1px solid #dde7f2;border-radius:8px;box-shadow:0 8px 24px rgba(35,56,86,.07);}
        .wh-title h2{margin:0;font-size:22px;font-weight:800;letter-spacing:0;color:#152238;}
        .wh-title p{margin:7px 0 0;color:#667085;line-height:1.55;}
        .wh-actions{display:flex;align-items:center;gap:8px;white-space:nowrap;}
        .wh-chip{height:30px;line-height:30px;padding:0 12px;border-radius:999px;background:#edf4ff;color:#2463eb;font-weight:700;border:1px solid #cfe0ff;}
        .wh-grid{display:grid;grid-template-columns:41% 1fr;gap:12px;min-height:calc(100vh - 132px);}
        .wh-panel{background:#fff;border:1px solid #e1e7ef;border-radius:8px;box-shadow:0 1px 2px rgba(16,24,40,.04);overflow:hidden;}
        .wh-search{padding:12px 12px 0;background:#f8fafc;border-bottom:1px solid #e1e7ef;}
        .wh-search .layui-form-label{width:64px;}
        .wh-search .layui-input-inline{width:142px;}
        .wh-detail-head{display:flex;align-items:center;justify-content:space-between;gap:10px;padding:14px 16px;border-bottom:1px solid #e1e7ef;background:#fff;}
        .wh-detail-title{font-weight:800;color:#172033;}
        .wh-detail-actions{display:flex;align-items:center;justify-content:flex-end;gap:8px;flex-wrap:wrap;}
        .wh-kitting{display:none;padding:14px 16px 0;border-bottom:1px solid #e1e7ef;background:#fbfdff;}
        .wh-kpis{display:grid;grid-template-columns:repeat(4,1fr);gap:8px;margin-bottom:12px;}
        .wh-kpi{padding:10px 12px;border:1px solid #e1e7ef;border-radius:8px;background:#fff;}
        .wh-kpi span{display:block;font-size:12px;color:#667085;}
        .wh-kpi b{display:block;margin-top:5px;font-size:20px;color:#172033;}
        .wh-kpi.ready b{color:#16a34a}.wh-kpi.warn b{color:#dc2626}
        .wh-shortage{display:none;margin-bottom:12px;padding:10px 12px;border:1px solid #fecaca;border-radius:8px;background:#fff5f5;color:#b42318;line-height:1.65;}
        .wh-alloc-title{display:flex;align-items:center;justify-content:space-between;margin:8px 0 8px;font-weight:800;color:#344054;}
        .sp-badge{display:inline-block;padding:1px 9px;font-size:12px;line-height:20px;border-radius:999px;font-weight:700;white-space:nowrap;}
        .sp-badge-wait{background:#fff7ed;color:#c2410c;}
        .sp-badge-ok{background:#ecfdf3;color:#16a34a;}
        .sp-badge-short{background:#fef3f2;color:#dc2626;}
        .progress{height:6px;background:#eef2f6;border-radius:999px;overflow:hidden;}
        .progress i{display:block;height:100%;background:#2563eb;}
        .material-main{font-weight:800;color:#1d4ed8;}
        .muted{color:#98a2b3;}
        .shortage-dialog{padding:16px 18px 8px;color:#172033;}
        .shortage-summary{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:12px;}
        .shortage-summary div{padding:10px 12px;border:1px solid #e1e7ef;border-radius:8px;background:#f8fafc;}
        .shortage-summary span{display:block;color:#667085;font-size:12px;}
        .shortage-summary b{display:block;margin-top:4px;font-size:18px;color:#dc2626;}
        .shortage-table-wrap{max-height:300px;overflow:auto;border:1px solid #e1e7ef;border-radius:8px;}
        .shortage-table{width:100%;border-collapse:collapse;background:#fff;}
        .shortage-table th,.shortage-table td{padding:9px 10px;border-bottom:1px solid #edf2f7;text-align:left;white-space:nowrap;}
        .shortage-table th{position:sticky;top:0;background:#f8fafc;color:#475467;font-weight:700;}
        .shortage-material{min-width:190px;font-weight:800;color:#1d4ed8;}
        @media(max-width:1120px){.wh-grid{grid-template-columns:1fr}.wh-kpis{grid-template-columns:repeat(2,1fr)}}
        @media(max-width:720px){
            .wh-page{padding:8px;}
            .wh-hero,.wh-detail-head{align-items:flex-start;flex-direction:column;}
            .wh-actions,.wh-detail-actions{width:100%;justify-content:flex-start;white-space:normal;}
            .wh-search .layui-inline,.wh-search .layui-input-inline{width:100%;}
            .wh-kpis,.shortage-summary{grid-template-columns:1fr;}
        }
    </style>
</head>
<body>
<div class="wh-page">
    <div class="wh-hero">
        <div class="wh-title">
            <h2>${pageTitle}</h2>
            <p id="pageHint">确认后写入库存与出入库流水；配套出库按整单校验库存，库存不足时不会扣减任何库存。</p>
        </div>
        <div class="wh-actions">
            <span class="wh-chip">${businessType}</span>
            <button class="layui-btn layui-btn-primary" id="syncBtn" style="display:none;"><i class="fa fa-refresh"></i> 同步来源单</button>
        </div>
    </div>

    <div class="wh-grid">
        <div class="wh-panel">
            <form class="layui-form wh-search" lay-filter="requestQuery">
                <input type="hidden" name="businessType" value="${businessType}">
                <div class="layui-form-item">
                    <div class="layui-inline"><label class="layui-form-label">单号</label><div class="layui-input-inline"><input name="requestNoLike" class="layui-input" autocomplete="off"></div></div>
                    <div class="layui-inline"><label class="layui-form-label">状态</label><div class="layui-input-inline"><select name="status"><option value="">全部</option><option value="WAIT_CONFIRM">待确认</option><option value="CONFIRMED">已登账</option></select></div></div>
                    <button class="layui-btn" lay-submit lay-filter="searchReq"><i class="layui-icon layui-icon-search"></i> 查询</button>
                </div>
            </form>
            <table class="layui-hide" id="requestTable" lay-filter="requestTable"></table>
        </div>

        <div class="wh-panel">
            <div class="wh-detail-head">
                <div class="wh-detail-title" id="detailTitle">请选择左侧单据</div>
                <div class="wh-detail-actions">
                    <button class="layui-btn layui-btn-primary layui-btn-sm" id="precheckBtn" style="display:none;"><i class="fa fa-search"></i> 库存预检</button>
                    <button class="layui-btn layui-btn-sm" id="confirmRequestBtn" style="display:none;"><i class="fa fa-check"></i> 整单出库登账</button>
                    <button class="layui-btn layui-btn-primary layui-btn-sm" id="reloadItems"><i class="fa fa-refresh"></i> 刷新明细</button>
                </div>
            </div>
            <div class="wh-kitting" id="kittingPanel">
                <div class="wh-kpis">
                    <div class="wh-kpi"><span>明细数</span><b id="kpItems">0</b></div>
                    <div class="wh-kpi ready"><span>可出库</span><b id="kpReady">0</b></div>
                    <div class="wh-kpi warn"><span>缺料数</span><b id="kpShort">0</b></div>
                    <div class="wh-kpi"><span>FIFO分配</span><b id="kpAlloc">0</b></div>
                </div>
                <div class="wh-shortage" id="shortageBox"></div>
                <div class="wh-alloc-title"><span>FIFO 分配预览</span><span class="muted">按入库时间、批次、库位顺序</span></div>
                <table class="layui-hide" id="allocationTable" lay-filter="allocationTable"></table>
            </div>
            <table class="layui-hide" id="itemTable" lay-filter="itemTable"></table>
        </div>
    </div>
</div>

<script type="text/html" id="requestStatusTpl">
{{# if(d.status==='CONFIRMED'){ }}<span class="sp-badge sp-badge-ok">已登账</span>{{# } else { }}<span class="sp-badge sp-badge-wait">待确认</span>{{# } }}
</script>
<script type="text/html" id="itemStatusTpl">
{{# if(d.status==='CONFIRMED'){ }}<span class="sp-badge sp-badge-ok">已登账</span>{{# } else { }}<span class="sp-badge sp-badge-wait">待确认</span>{{# } }}
</script>
<script type="text/html" id="progressTpl">
{{# var total=d.itemCount||0, done=d.confirmedCount||0, pct=total?Math.round(done*100/total):0; }}
<div>{{done}}/{{total}}</div><div class="progress"><i style="width:{{pct}}%"></i></div>
</script>
<script type="text/html" id="itemOpTpl">
{{# if(window.__kittingMode){ }}
  <span class="muted">整单处理</span>
{{# } else if(d.status==='CONFIRMED'){ }}
  <span class="muted">已完成</span>
{{# } else { }}
  <a class="layui-btn layui-btn-xs" lay-event="confirm"><i class="fa fa-check"></i> 登账</a>
{{# } }}
</script>
<script type="text/html" id="materialTpl">
<div class="material-main">{{d.materialCode||'-'}}</div><div>{{d.materialName||'-'}}</div>
</script>

<script>
layui.use(['form','table','layer','spTable'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spTable=layui.spTable;
    var contextPath='${request.contextPath}', businessType='${businessType}', direction='${direction}', currentReq=null;
    window.__kittingMode = businessType === 'KITTING_OUT';
    if(window.__kittingMode){
        $('#kittingPanel,#precheckBtn,#confirmRequestBtn').show();
        $('#pageHint').text('配套出库按整单预检，库存不足时整单阻止；库存满足后按 FIFO 自动分配库位和批次。');
    } else if(businessType==='PLAN_IN'){
        $('#syncBtn').show();
    }

    var requestTable=spTable.render({
        elem:'#requestTable',url:contextPath + '/warehouse/request/page',height:'full-205',where:{businessType:businessType},
        cols:[[
            {field:'requestNo',title:'单号',width:154,style:'font-weight:800;color:#1d4ed8;'},
            {field:'sourceNo',title:'来源单',width:136},
            {field:'totalQty',title:'总量',width:90},
            {field:'status',title:'状态',width:92,templet:'#requestStatusTpl'},
            {field:'confirmedCount',title:'进度',width:120,templet:'#progressTpl'},
            {field:'applyTime',title:'申请时间',width:150}
        ]]
    });
    var itemTable=spTable.render({
        elem:'#itemTable',url:contextPath + '/warehouse/request/items',height:'full-405',where:{businessType:businessType,requestNoLike:'__NO_DATA__'},
        cols:[[
            {field:'materialCode',title:'物料',minWidth:210,templet:'#materialTpl'},
            {field:'requestQty',title:'申请数',width:92},
            {field:'confirmedQty',title:'登账数',width:92},
            {field:'unit',title:'单位',width:70},
            {field:'batchNo',title:'批号',width:128},
            {field:'warehouseName',title:'库房',width:130,templet:function(d){return d.warehouseName||d.warehouseCode||'';}},
            {field:'locationCode',title:'库位',width:140},
            {field:'status',title:'状态',width:90,templet:'#itemStatusTpl'},
            {fixed:'right',title:'操作',toolbar:'#itemOpTpl',width:96}
        ]]
    });
    table.render({elem:'#allocationTable',data:[],height:188,cols:[[
        {field:'materialCode',title:'物料',width:128},
        {field:'warehouseName',title:'库房',width:135,templet:function(d){return (d.warehouseCode||'')+' '+(d.warehouseName||'');}},
        {field:'locationCode',title:'库位',width:130},
        {field:'batchNo',title:'批号',width:130},
        {field:'qty',title:'出库数',width:90,style:'font-weight:800;color:#16a34a;'},
        {field:'beforeQty',title:'出库前',width:90},
        {field:'afterQty',title:'出库后',width:90}
    ]],done:function(){
        $('#allocationTable').next('.layui-table-view').addClass('sp-production-table-view');
    }});

    if(businessType==='PLAN_IN'){sync('/warehouse/plan-inbound/sync',false);}
    $('#syncBtn').on('click',function(){sync('/warehouse/plan-inbound/sync',true);});
    function sync(url,tip){$.post(contextPath+url,{},function(res){if(tip){layer.msg(res.msg||'同步完成');} requestTable.reload();});}
    function reqQuery(){return $.extend({businessType:businessType},form.val('requestQuery')||{});}
    form.on('submit(searchReq)',function(){requestTable.reload({where:reqQuery(),page:{curr:1}});return false;});
    table.on('row(requestTable)',function(obj){
        currentReq=obj.data; obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
        $('#detailTitle').text('明细 - '+currentReq.requestNo);
        itemTable.reload({where:{businessType:businessType,requestNoLike:currentReq.requestNo},page:{curr:1}});
        if(window.__kittingMode){loadPrecheck(false);}
    });
    $('#reloadItems').on('click',function(){ if(currentReq){itemTable.reload(); if(window.__kittingMode){loadPrecheck(false);} } });
    $('#precheckBtn').on('click',function(){
        loadPrecheck(true,function(data){
            if(data && data.ready===false && (data.shortages||[]).length){
                confirmPlanInbound(data);
            }
        });
    });
    $('#confirmRequestBtn').on('click',function(){
        if(!currentReq){layer.msg('请先选择配套出库单');return;}
        loadPrecheck(false,function(data){
            if(!data.ready){renderPrecheck(data);layer.alert('库存不足，不能整单出库');return;}
            layer.confirm('确认按 FIFO 规则完成整张配套出库单登账？',function(index){
                layer.close(index);
                $.post(contextPath + '/warehouse/kitting-outbound/confirm-request',{requestId:currentReq.id},function(res){
                    if(res.code===0){layer.msg(res.msg||'整单登账完成');requestTable.reload();itemTable.reload();loadPrecheck(false);}
                    else{renderPrecheck(res.data||{});layer.alert(res.msg||'整单登账失败');}
                });
            });
        });
    });
    table.on('tool(itemTable)',function(obj){ if(obj.event==='confirm'){openConfirm(obj.data);} });

    function loadPrecheck(showMsg,done){
        if(!currentReq){ if(showMsg){layer.msg('请先选择配套出库单');} return; }
        if(currentReq.status==='CONFIRMED'){
            renderPrecheck({ready:true,itemCount:currentReq.itemCount||0,shortageCount:0,items:[],shortages:[],allocations:[]});
            if(showMsg){layer.msg('该单已登账');}
            return;
        }
        $.post(contextPath + '/warehouse/kitting-outbound/precheck',{requestId:currentReq.id},function(res){
            var data=res.data||{};
            renderPrecheck(data);
            if(showMsg && !(data.ready===false && (data.shortages||[]).length)){layer.msg(res.msg||'预检完成');}
            if(done){done(data);}
        });
    }
    function renderPrecheck(data){
        var items=data.items||[], shortages=data.shortages||[], allocations=data.allocations||[];
        $('#kpItems').text(data.itemCount||items.length||0);
        $('#kpReady').text(Math.max((data.itemCount||items.length||0)-shortages.length,0));
        $('#kpShort').text(shortages.length);
        $('#kpAlloc').text(allocations.length);
        if(shortages.length){
            var html=''; $.each(shortages,function(_,s){html += esc(s.materialCode)+' '+esc(s.materialName)+'：需求 '+esc(s.requestQty)+'，可用 '+esc(s.availableQty)+'，缺口 '+esc(s.shortageQty)+'<br>';});
            $('#shortageBox').html(html).show();
        } else { $('#shortageBox').hide().empty(); }
        table.reload('allocationTable',{data:allocations});
    }

    function confirmPlanInbound(data){
        var shortages=data.shortages||[];
        if(!shortages.length){return;}
        var total=0;
        $.each(shortages,function(_,s){total += parseFloat(s.shortageQty||0)||0;});
        var html='<div class="shortage-dialog">'
            + '<div class="shortage-summary">'
            + '<div><span>缺料明细</span><b>'+shortages.length+'</b></div>'
            + '<div><span>缺口总数</span><b>'+esc(total.toFixed(4).replace(/\\.?(0+)$/,''))+'</b></div>'
            + '<div><span>来源出库单</span><b style="font-size:14px;color:#172033;">'+esc(data.requestNo||currentReq.requestNo)+'</b></div>'
            + '</div>'
            + '<div class="shortage-table-wrap"><table class="shortage-table"><thead><tr><th>物料</th><th>需求</th><th>可用</th><th>缺口</th><th>单位</th></tr></thead><tbody>';
        $.each(shortages,function(_,s){
            html+='<tr><td class="shortage-material">'+esc(s.materialCode)+'<div style="font-weight:400;color:#475467;">'+esc(s.materialName)+'</div></td>'
                + '<td>'+esc(s.requestQty)+'</td><td>'+esc(s.availableQty)+'</td><td style="font-weight:800;color:#dc2626;">'+esc(s.shortageQty)+'</td><td>'+esc(s.unit)+'</td></tr>';
        });
        html+='</tbody></table></div>'
            + '<p style="margin:12px 0 0;color:#667085;line-height:1.6;">库存不足时不会扣减库存。选择“是”后会生成计划入库确认单，数量按当前缺口计算。</p>'
            + '</div>';
        layer.open({
            type:1,
            title:'库存不足，是否计划入库这些材料？',
            area:[dialogWidth(720),'auto'],
            content:html,
            btn:['是，生成计划入库','否'],
            yes:function(index){
                var loading=layer.load(2);
                $.post(contextPath + '/warehouse/kitting-outbound/plan-inbound-shortage',{requestId:currentReq.id},function(res){
                    layer.close(loading);
                    if(res.code===0){
                        layer.close(index);
                        requestTable.reload();
                        itemTable.reload();
                        loadPrecheck(false);
                        showPlanInboundResult(res.data||{},res.msg||'缺料计划入库单已生成');
                    } else {
                        layer.alert(res.msg||'生成计划入库单失败');
                    }
                });
            }
        });
    }

    function showPlanInboundResult(data,msg){
        var text=msg + (data.requestNo ? '<br>计划入库单：<b>'+esc(data.requestNo)+'</b>' : '');
        layer.open({
            title:'计划入库已准备',
            content:text,
            btn:['打开计划入库确认','留在当前页'],
            yes:function(index){
                layer.close(index);
                window.location.href=contextPath + '/warehouse/plan-inbound/confirm/list-ui';
            }
        });
    }

    function dialogWidth(max){
        var width=Math.min(max,$(window).width()-28);
        return Math.max(width,320)+'px';
    }

    function openConfirm(row){
        var html='<div style="padding:18px 22px 8px;"><form class="layui-form" lay-filter="confirmForm">'
            + '<input type="hidden" name="itemId" value="'+esc(row.id)+'">'
            + '<div class="layui-form-item"><label class="layui-form-label">物料</label><div class="layui-input-block"><input class="layui-input" readonly value="'+esc(row.materialCode)+' '+esc(row.materialName)+'"></div></div>'
            + '<div class="layui-form-item"><label class="layui-form-label">库房</label><div class="layui-input-block"><select name="warehouseId" id="cWarehouse" lay-filter="cWarehouse" lay-verify="required"><option value="">请选择库房</option></select></div></div>'
            + '<div class="layui-form-item"><label class="layui-form-label">库位</label><div class="layui-input-block"><select name="locationId" id="cLocation" lay-verify="required"><option value="">请先选择库房</option></select></div></div>'
            + '<div class="layui-form-item"><label class="layui-form-label">数量</label><div class="layui-input-block"><input name="qty" type="number" step="0.0001" min="0" class="layui-input" value="'+esc(row.requestQty)+'"></div></div>'
            + '</form></div>';
        layer.open({type:1,title:'库房登账',area:['560px','430px'],content:html,btn:['确认登账','取消'],success:function(){
            loadWarehouses(row); form.render();
            form.on('select(cWarehouse)',function(data){loadLocations(data.value,row.materialId,row.locationId);});
        },yes:function(index){
            var data=form.val('confirmForm');
            $.ajax({url:contextPath + '/warehouse/request/confirm-item',type:'POST',contentType:'application/json;charset=UTF-8',data:JSON.stringify(data),success:function(res){
                if(res.code===0){layer.close(index);layer.msg('登账完成');itemTable.reload();requestTable.reload();}
                else{layer.alert(res.msg||'登账失败');}
            }});
        }});
    }
    function loadWarehouses(row){
        $.post(contextPath + '/digital/simulation/warehouse-list',{},function(res){
            var html='<option value="">请选择库房</option>';
            $.each((res.data||[]),function(_,w){html+='<option value="'+w.id+'" '+(w.id===row.warehouseId?'selected':'')+'>'+esc(w.warehouseCode)+' '+esc(w.warehouseName)+'</option>';});
            $('#cWarehouse').html(html);form.render('select');
            if(row.warehouseId){loadLocations(row.warehouseId,row.materialId,row.locationId);}
        });
    }
    function loadLocations(warehouseId,materialId,selected){
        $.post(contextPath + '/warehouse/common/available-locations',{warehouseId:warehouseId,materialId:materialId,direction:direction},function(res){
            var html='<option value="">请选择库位</option>';
            $.each((res.data||[]),function(_,l){html+='<option value="'+l.id+'" '+(l.id===selected?'selected':'')+'>'+esc(l.locationCode)+(l.empty?' 空位':' 同物料')+'</option>';});
            $('#cLocation').html(html);form.render('select');
        });
    }
    function esc(v){return $('<div/>').text(v==null?'':v).html();}
    form.render();
});
</script>
</body>
</html>
