<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>员工作业派工</title>
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
        .candidate-layer .layui-layer-title{height:48px;line-height:48px;border-bottom:1px solid #e4edf4;background:#fbfdff;color:#123b5d;font-size:15px;font-weight:900}
        .candidate-layer .layui-layer-content{background:#eef5f9}
        .candidate-wrap{display:flex;flex-direction:column;min-height:512px;background:#eef5f9}
        .candidate-head{padding:14px 16px 12px;background:#fff;border-bottom:1px solid #e2edf5}
        .candidate-head-main{display:flex;align-items:center;justify-content:space-between;gap:14px}
        .candidate-head h3{margin:0;color:#123b5d;font-size:16px;font-weight:900}
        .candidate-head p{margin:6px 0 0;color:#5f7285;font-size:12px;line-height:1.6}
        .candidate-meta{display:flex;flex-wrap:wrap;gap:6px;margin-top:10px}
        .candidate-meta span{display:inline-flex;align-items:center;height:24px;padding:0 9px;border-radius:999px;background:#f2f7fb;color:#536b7f;border:1px solid #dbe8f0;font-size:12px}
        .candidate-count-pill{flex:none;height:30px;line-height:30px;padding:0 12px;border-radius:999px;background:#e5f0ff;color:#1456a0;font-weight:900;border:1px solid #c9ddfb}
        .candidate-list{display:grid;gap:10px;max-height:390px;overflow:auto;padding:12px 14px 14px}
        .candidate-list::-webkit-scrollbar{width:8px}.candidate-list::-webkit-scrollbar-thumb{background:#c9d8e4;border-radius:999px}.candidate-list::-webkit-scrollbar-track{background:transparent}
        .candidate-team{border:1px solid #dbe8f0;border-radius:8px;background:#fff;overflow:hidden;box-shadow:0 8px 20px rgba(31,65,92,.06)}
        .candidate-team-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:11px 12px;background:#f8fbfd;border-bottom:1px solid #e5edf3}
        .candidate-team-title{display:flex;align-items:center;gap:8px;font-weight:900;color:#123b5d}
        .candidate-team-title span{color:#718396;font-size:12px;font-weight:400}
        .team-dot{width:8px;height:8px;border-radius:50%;background:#1c75a3;box-shadow:0 0 0 4px #e5f0ff}
        .team-check{display:flex;align-items:center;gap:6px;color:#536b7f;font-size:12px}
        .candidate{display:grid;grid-template-columns:30px 38px 1fr 92px;gap:10px;align-items:center;padding:11px 12px;border-bottom:1px solid #eef3f7;cursor:pointer;transition:background .15s ease,box-shadow .15s ease}
        .candidate:last-child{border-bottom:0}.candidate:hover{background:#fbfdff}.candidate.is-selected{background:#f0f7ff;box-shadow:inset 3px 0 0 #1e9fff}
        .candidate-avatar{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:#e5f0ff;color:#1456a0;font-weight:900}
        .candidate b{color:#123b5d}.candidate span{display:block;margin-top:3px;color:#718396;font-size:12px}
        .candidate em{justify-self:end;font-style:normal;height:26px;line-height:26px;padding:0 9px;border-radius:999px;background:#eef8ff;color:#1c75a3;font-weight:900}
        .candidate em.is-idle{background:#e8f8ee;color:#0c684c}.candidate em.is-busy{background:#fff1c7;color:#8b5700}
        .candidate-empty{padding:38px 18px;text-align:center;color:#718396;background:#fff;border:1px dashed #c9d8e4;border-radius:8px}
        .candidate-empty b{display:block;margin-bottom:7px;color:#123b5d;font-size:15px}
        .candidate-actions{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:auto;padding:12px 14px;background:#fff;border-top:1px solid #dbe8f0;box-shadow:0 -8px 18px rgba(31,65,92,.04)}
        .selected-count{color:#1456a0;font-weight:900}.selected-hint{margin-left:8px;color:#718396;font-size:12px}.js-save-candidates{min-width:112px}
        /* Bring the custom chooser back into the shared MES theme. */
        body{background:var(--sp-bg);color:var(--sp-text);font-family:var(--sp-font)}
        .page{padding:12px}
        .card,.panel{border-color:var(--sp-border);border-radius:var(--sp-radius);background:var(--sp-surface);box-shadow:var(--sp-shadow-sm)}
        .card h1{color:var(--sp-text);font-family:var(--sp-font)}
        .card p{color:var(--sp-text-secondary)}
        .search{background:var(--sp-surface-2);border-bottom-color:var(--sp-border)}
        .search .layui-form-label{color:var(--sp-text-secondary)}
        .candidate-layer{border-radius:var(--sp-radius-lg);overflow:hidden}
        .candidate-layer .layui-layer-title{height:48px;line-height:48px;border-bottom-color:var(--sp-border);background:var(--sp-surface);color:var(--sp-text);font-weight:600}
        .candidate-layer .layui-layer-content{height:calc(100% - 49px)!important;overflow:hidden;background:var(--sp-bg)}
        .candidate-wrap{height:100%;min-height:0;background:var(--sp-bg)}
        .candidate-head{flex:none;background:var(--sp-surface);border-bottom-color:var(--sp-border)}
        .candidate-head h3,.candidate-team-title,.candidate b,.candidate-empty b{color:var(--sp-text)}
        .candidate-head p,.candidate-team-title span,.candidate span,.selected-hint{color:var(--sp-text-secondary)}
        .candidate-meta span{background:var(--sp-surface-2);color:var(--sp-text-secondary);border-color:var(--sp-border)}
        .candidate-count-pill{background:var(--sp-primary-tint);color:var(--sp-primary);border-color:var(--sp-primary-border)}
        .candidate-list{flex:1;min-height:0;max-height:none;overflow:auto;padding:12px}
        .candidate-team{border-color:var(--sp-border);border-radius:var(--sp-radius);box-shadow:var(--sp-shadow-sm)}
        .candidate-team-head{background:var(--sp-surface-2);border-bottom-color:var(--sp-border)}
        .team-dot{background:var(--sp-primary);box-shadow:0 0 0 4px var(--sp-primary-tint)}
        .candidate{grid-template-columns:30px 38px minmax(0,1fr) 92px;border-bottom-color:var(--sp-border);transition:background-color .15s ease,box-shadow .15s ease}
        .candidate:hover{background:var(--sp-surface-2)}
        .candidate.is-selected{background:var(--sp-primary-tint);box-shadow:inset 3px 0 0 var(--sp-primary)}
        .candidate-avatar{background:var(--sp-primary-tint);color:var(--sp-primary);border:1px solid var(--sp-primary-border)}
        .candidate em{background:var(--sp-primary-tint);color:var(--sp-primary)}
        .candidate-empty{border-color:var(--sp-border-strong);background:var(--sp-surface)}
        .candidate-actions{position:sticky;bottom:0;z-index:2;flex:none;background:var(--sp-surface);border-top-color:var(--sp-border);box-shadow:0 -8px 18px rgba(16,24,40,.06)}
        .selected-count{color:var(--sp-primary)}
    </style>
</head>
<body>
<div class="page">
    <div class="hero">
        <div class="card">
            <h1>员工作业派工</h1>
            <p>把已审批且尚未下发的工序任务分配到具体班组与员工。候选员工来自加工单元绑定班组、班组员工和当前未完成任务负载排序，保存后形成“工序任务 -> 人员责任”的执行前置条件。</p>
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
<script type="text/html" id="assignTpl">{{# if(d.userId){ }}<span class="chip green">已派工</span>{{# } else { }}<span class="chip orange">待派工</span>{{# } }}</script>
<script type="text/html" id="employeeTpl">{{# if(d.userId){ }}<b>{{d.userName || d.userId}}</b><span style="color:#718396;">{{d.teamName || d.teamId || ''}}</span>{{# } else { }}<span style="color:#8b5700;">未分配人员</span>{{# } }}</script>
<script type="text/html" id="opTpl"><a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="assign">选择员工</a></script>
<script>
layui.use(['form','table','layer','spTable'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spTable=layui.spTable;
    var tableIns=spTable.render({elem:'#recordTable',url:'${request.contextPath}/production-order/employee-dispatch/page',height:'full-255',cols:[[
        {field:'orderNo',title:'订单编号',width:150},
        {field:'workOrderCode',title:'工单编号',width:165,style:'color:#1456a0;font-weight:900;'},
        {field:'productName',title:'产品物料',minWidth:190,templet:function(d){return (d.productMateriel||'-')+' / '+(d.productName||'-');}},
        {field:'operDesc',title:'工序',minWidth:170,templet:function(d){return (d.sortNum||'-')+'. '+(d.operDesc||d.oper||'-');}},
        {field:'unitName',title:'加工单元',width:130,templet:function(d){return esc(d.unitName||d.unitId||'-');}},
        {field:'planStartTime',title:'计划开始',width:160},
        {field:'userName',title:'员工',minWidth:150,templet:'#employeeTpl'},
        {field:'employeeStatus',title:'派工状态',width:100,templet:'#assignTpl'},
        {fixed:'right',title:'操作',toolbar:'#opTpl',width:100}
    ]]});
    function query(){return form.val('queryForm')||{};}
    function reload(){tableIns.reload({where:query(),page:{curr:1}});}
    function esc(v){return $('<div/>').text(v==null?'':v).html();}
    function initials(v){v=$.trim(v||'');return esc(v ? v.substring(0,1) : '?');}
    function openCandidates(row){
        if(!row.unitId){layer.alert('该工序尚未绑定加工单元，无法按班组推荐员工。');return;}
        $.post('${request.contextPath}/production-order/employee-dispatch/candidates',{unitId:row.unitId},function(res){
            var list=res.data||[],groups={},order=[],existing=(row.userId||'').split(',');
            $.each(list,function(_,c){
                var key=c.teamId||'__none__';
                if(!groups[key]){groups[key]={teamId:c.teamId||'',teamName:c.teamName||'未分组',items:[]};order.push(key);}
                groups[key].items.push(c);
            });
            var html='<div class="candidate-wrap"><div class="candidate-head"><div class="candidate-head-main"><div>'
                +'<h3>选择作业人员</h3><p>可勾选整组，也可在同一班组内选择多名员工；保存后会覆盖当前工序的人员派工。</p></div>'
                +'<div class="candidate-count-pill">'+list.length+' 人可选</div></div>'
                +'<div class="candidate-meta"><span>工序：'+esc(row.operDesc||row.oper||'-')+'</span><span>加工单元：'+esc(row.unitName||row.unitId||'-')+'</span><span>工单：'+esc(row.workOrderCode||'-')+'</span></div></div>'
                +'<div class="candidate-list">';
            $.each(order,function(_,key){
                var g=groups[key],allChecked=true;
                $.each(g.items,function(_,c){if(existing.indexOf(String(c.userId||''))<0)allChecked=false;});
                html+='<div class="candidate-team" data-team-id="'+esc(g.teamId)+'">'
                    +'<div class="candidate-team-head"><div class="candidate-team-title"><i class="team-dot"></i>'+esc(g.teamName||g.teamId||'未分组')+'<span>'+g.items.length+' 人</span></div>'
                    +'<label class="team-check"><input type="checkbox" class="js-team-check" title="整组选中" '+(allChecked&&g.items.length?'checked':'')+'></label></div>';
                $.each(g.items,function(_,c){
                    var checked=existing.indexOf(String(c.userId||''))>=0?'checked':'';
                    var load=parseInt(c.currentLoad||0,10),loadClass=load===0?'is-idle':(load>=3?'is-busy':'');
                    html+='<label class="candidate"><input type="checkbox" class="js-user-check" '+checked
                        +' data-user-id="'+esc(c.userId)+'" data-user-name="'+esc(c.userName||c.userId)+'" data-team-id="'+esc(c.teamId)+'" data-team-name="'+esc(c.teamName)+'">'
                        +'<div class="candidate-avatar">'+initials(c.userName||c.userId)+'</div>'
                        +'<div><b>'+esc(c.userName||c.userId)+'</b><span>班组：'+esc(c.teamName||c.teamId||'-')+'</span></div><em class="'+loadClass+'">'+esc(c.currentLoad||0)+' 单</em></label>';
                });
                html+='</div>';
            });
            if(!list.length)html+='<div class="candidate-empty"><b>暂无候选员工</b>请先在加工单元中绑定班组与员工。</div>';
            html+='</div><div class="candidate-actions"><div><span class="selected-count">已选 0 人</span><span class="selected-hint">同一工序可选择多人协作</span></div><button type="button" class="layui-btn layui-btn-normal js-save-candidates">保存派工</button></div></div>';
            layer.open({type:1,title:'选择作业人员 - '+(row.operDesc||row.oper||''),area:['720px','620px'],skin:'candidate-layer',shade:.18,resize:false,content:html,success:function(layero,index){
                function syncCount(){
                    var count=layero.find('.js-user-check:checked').length;
                    layero.find('.selected-count').text('已选 '+count+' 人');
                    layero.find('.candidate').each(function(){
                        $(this).toggleClass('is-selected',$(this).find('.js-user-check').prop('checked'));
                    });
                    layero.find('.candidate-team').each(function(){
                        var $team=$(this),total=$team.find('.js-user-check').length,checked=$team.find('.js-user-check:checked').length;
                        $team.find('.js-team-check').prop('checked',total>0&&total===checked);
                    });
                    layero.find('.js-save-candidates').toggleClass('layui-btn-disabled',count===0).prop('disabled',count===0);
                    form.render('checkbox');
                }
                layero.find('.js-team-check').on('change',function(){
                    var checked=$(this).prop('checked');
                    $(this).closest('.candidate-team').find('.js-user-check').prop('checked',checked);
                    syncCount();
                });
                layero.find('.js-user-check').on('change',syncCount);
                layero.find('.js-save-candidates').on('click',function(){
                    var selected=[];
                    layero.find('.js-user-check:checked').each(function(){
                        var $t=$(this);
                        selected.push({userId:$t.data('user-id'),userName:$t.data('user-name'),teamId:$t.data('team-id'),teamName:$t.data('team-name')});
                    });
                    if(!selected.length){layer.msg('请至少选择 1 名员工');return;}
                    var payload={operPlanId:row.operPlanId,
                        userId:$.map(selected,function(x){return x.userId;}).join(','),
                        userName:$.map(selected,function(x){return x.userName;}).join(','),
                        teamId:$.map(selected,function(x){return x.teamId;}).join(','),
                        teamName:$.map(selected,function(x){return x.teamName;}).join(',')};
                    $.post('${request.contextPath}/production-order/employee-dispatch/save',payload,function(r){
                        if(r.code===0){layer.close(index);layer.msg(r.msg||'员工作业派工已保存');reload();}else{layer.alert(r.msg||'保存失败');}
                    });
                });
                form.render('checkbox');
                syncCount();
            }});
        });
    }
    table.on('tool(recordTable)',function(obj){if(obj.event==='assign')openCandidates(obj.data);});
    form.on('submit(search)',function(){reload();return false;});
    $('#resetBtn').on('click',function(){setTimeout(reload,0);});
    form.render();
});
</script>
</body>
</html>
