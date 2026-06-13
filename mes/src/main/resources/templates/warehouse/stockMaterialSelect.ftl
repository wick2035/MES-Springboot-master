<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选择出库物料</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form" lay-filter="stockMaterialQuery">
            <input type="hidden" name="warehouseId" value="${warehouseId}">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">物料</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materialLike" class="layui-input" placeholder="编码/名称">
                    </div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="searchStockMaterial">
                        <i class="layui-icon layui-icon-search"></i>查询
                    </button>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="stockMaterialTable" lay-filter="stockMaterialTable"></table>
        <form class="layui-form layui-hide">
            <button id="js-submit" type="button" class="layui-btn" lay-submit lay-filter="submitStockMaterial">确定</button>
        </form>
    </div>
</div>
<script>
layui.use(['form','table','layer','spTable'],function(){
    var form=layui.form,table=layui.table,layer=layui.layer,spTable=layui.spTable;
    var contextPath='${request.contextPath}', warehouseId='${warehouseId}';
    var tableIns=spTable.render({
        elem:'#stockMaterialTable',
        url:contextPath + '/warehouse/common/available-materials',
        where:{warehouseId:warehouseId},
        height:'full-105',
        cols:[[
            {type:'checkbox'},
            {field:'materiel',title:'物料编码',width:140,style:'font-weight:800;color:var(--sp-primary);'},
            {field:'materielDesc',title:'物料名称',minWidth:180},
            {field:'qty',title:'当前库存',width:110},
            {field:'unit',title:'单位',width:80}
        ]]
    });
    form.on('submit(searchStockMaterial)',function(data){
        tableIns.reload({where:data.field,page:{curr:1}});
        return false;
    });
    form.on('submit(submitStockMaterial)',function(){
        var checked=table.checkStatus('stockMaterialTable').data;
        if(!checked||!checked.length){
            layer.msg('请选择物料');
            window.spChildFrameResult={code:-1,msg:'请选择物料',data:[]};
            return false;
        }
        window.spChildFrameResult={code:0,msg:'操作成功',data:checked};
        return false;
    });
});
</script>
</body>
</html>
