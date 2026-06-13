<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:var(--sp-bg);}
        .wh-page{padding:14px;}
        .wh-hero{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;padding:18px 20px;background:#fff;border:1px solid var(--sp-border);border-radius:8px;box-shadow:var(--sp-shadow-sm);}
        .wh-hero h2{margin:0;font-size:21px;font-weight:800;color:#172033;letter-spacing:0;}
        .wh-hero p{margin:6px 0 0;color:var(--sp-text-secondary);}
        .wh-code{font-size:12px;color:var(--sp-text-muted);background:var(--sp-surface-2);border:1px solid var(--sp-border);border-radius:999px;padding:6px 10px;}
        .wh-shell{display:grid;grid-template-columns:minmax(420px,640px) 1fr;gap:12px;}
        .wh-panel{background:#fff;border:1px solid var(--sp-border);border-radius:8px;box-shadow:var(--sp-shadow-sm);overflow:hidden;}
        .wh-panel-head{padding:14px 16px;border-bottom:1px solid var(--sp-border);font-weight:800;color:var(--sp-text);}
        .wh-form{padding:18px 18px 10px;}
        .wh-form .layui-form-label{width:96px;}
        .wh-form .layui-input-inline{width:300px;}
        .wh-preview{padding:18px;background:linear-gradient(180deg,#FAFBFC 0%,#FFFFFF 100%);}
        .wh-step{display:flex;gap:12px;align-items:flex-start;margin-bottom:16px;}
        .wh-step b{width:26px;height:26px;line-height:26px;text-align:center;border-radius:50%;background:var(--sp-primary);color:#fff;}
        .wh-step span{display:block;font-weight:700;color:var(--sp-text);}
        .wh-step small{display:block;margin-top:3px;color:var(--sp-text-muted);line-height:1.5;}
        @media(max-width:1040px){.wh-shell{grid-template-columns:1fr}.wh-form .layui-input-inline{width:calc(100% - 122px)}}
    </style>
</head>
<body>
<div class="wh-page">
    <div class="wh-hero">
        <div>
            <h2>${pageTitle}</h2>
            <p>所有申请必须绑定库房、库位、物料和数量，确认后才会改变库存并生成出入流水。</p>
        </div>
        <div class="wh-code">${businessType}</div>
    </div>
    <div class="wh-shell">
        <div class="wh-panel">
            <div class="wh-panel-head">申请信息</div>
            <form class="layui-form wh-form" lay-filter="applyForm">
                <input type="hidden" name="businessType" value="${businessType}">
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">库房</label>
                    <div class="layui-input-inline">
                        <select name="warehouseId" id="warehouseId" lay-verify="required" lay-filter="warehouseFilter">
                            <option value="">请选择库房</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">库位</label>
                    <div class="layui-input-inline">
                        <select name="locationId" id="locationId" lay-verify="required">
                            <option value="">请先选择库房</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">物料</label>
                    <div class="layui-input-inline" style="width:216px;">
                        <input type="text" id="materialText" class="layui-input" readonly placeholder="请选择物料">
                    </div>
                    <button type="button" class="layui-btn" id="pickMaterial"><i class="fa fa-search"></i>选择</button>
                    <input type="hidden" name="materialId" id="materialId" lay-verify="required">
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">批号</label>
                    <div class="layui-input-inline">
                        <input name="batchNo" class="layui-input" placeholder="${(direction == 'IN')?string('可不填，确认后按单号追溯','出库建议填写库存批号')}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">数量</label>
                    <div class="layui-input-inline">
                        <input name="qty" type="number" step="0.0001" min="0" lay-verify="required|number" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-inline">
                        <textarea name="remark" class="layui-textarea" placeholder="填写供应商、领用原因或其他交接信息"></textarea>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-submit lay-filter="submitApply"><i class="fa fa-paper-plane"></i>提交申请</button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    </div>
                </div>
            </form>
        </div>
        <div class="wh-panel wh-preview">
            <div class="wh-step"><b>1</b><div><span>绑定库房与库位</span><small>申请端只登记意图，确认端负责最终登账。</small></div></div>
            <div class="wh-step"><b>2</b><div><span>校验物料与库存</span><small>入库库位不能混放不同物料；出库不能超过现有库存。</small></div></div>
            <div class="wh-step"><b>3</b><div><span>进入确认队列</span><small>${pageTitle}提交后会进入对应确认菜单，库房确认后才写库存流水。</small></div></div>
        </div>
    </div>
</div>
<script>
layui.use(['form','layer','spLayer'],function(){
    var form=layui.form,layer=layui.layer,spLayer=layui.spLayer;
    var contextPath='${request.contextPath}', materialId='', direction='${direction}';
    loadWarehouses();
    function loadWarehouses(){
        $.post(contextPath + '/digital/simulation/warehouse-list',{},function(res){
            var html='<option value="">请选择库房</option>';
            $.each((res.data||[]),function(_,w){html+='<option value="'+w.id+'">'+esc(w.warehouseCode)+' '+esc(w.warehouseName)+'</option>';});
            $('#warehouseId').html(html);form.render('select');
        });
    }
    function resetMaterialAndLocation(){
        materialId='';
        $('#materialId').val('');
        $('#materialText').val('');
        $('#locationId').html('<option value="">请先选择物料</option>');
        form.render('select');
    }
    function loadLocations(warehouseId){
        var url=contextPath + '/warehouse/common/available-locations';
        if(direction==='OUT' && !materialId){
            $('#locationId').html('<option value="">请先选择物料</option>');
            form.render('select');
            return;
        }
        $.post(url,{warehouseId:warehouseId,materialId:materialId,direction:direction},function(res){
            var html='<option value="">请选择库位</option>';
            $.each((res.data||[]),function(_,l){
                html+='<option value="'+l.id+'">'+esc(l.locationCode)+(l.empty?' 空位':' 同物料')+'</option>';
            });
            $('#locationId').html(html);form.render('select');
        });
    }
    form.on('select(warehouseFilter)',function(data){
        resetMaterialAndLocation();
        if(data.value && direction==='IN'){loadLocations(data.value);}
    });
    $('#pickMaterial').on('click',function(){
        var wh=$('#warehouseId').val();
        if(direction==='OUT' && !wh){
            layer.msg('请先选择库房');
            return;
        }
        var content = direction==='OUT'
            ? contextPath + '/warehouse/common/stock-material-select-ui?warehouseId=' + encodeURIComponent(wh)
            : contextPath + '/basedata/materile/select-ui';
        spLayer.open({type:2,title:'选择物料',area:['860px','600px'],content:content,reload:false,spCallback:function(res){
            if(res&&res.code===0&&res.data&&res.data.length){
                var m=res.data[0]; materialId=m.id; $('#materialId').val(m.id);
                $('#materialText').val((m.materiel||'')+' '+(m.materielDesc||''));
                if(wh){loadLocations(wh);}
            }
        }});
    });
    form.on('submit(submitApply)',function(data){
        $.post(contextPath + '/warehouse/request/apply',data.field,function(res){
            if(res.code===0){layer.alert('申请已提交：'+esc(res.data||''),function(i){layer.close(i);$('form')[0].reset();$('#materialText').val('');$('#materialId').val('');materialId='';form.render();});}
            else{layer.alert(res.msg||'提交失败');}
        });
        return false;
    });
    function esc(v){return $('<div/>').text(v==null?'':v).html();}
});
</script>
</body>
</html>
