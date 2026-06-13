<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程模型设计</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-shell">
    <div class="wf-hero wf-hero-command">
        <div>
            <h1 class="wf-title">流程模型设计</h1>
            <div class="wf-subtitle">定义流程草稿、审批节点、处理角色和安全事件模板，发布后形成不可变定义版本。</div>
        </div>
        <div class="wf-metric-strip">
            <span><b>DRAFT</b> 草稿设计</span>
            <span><b>NODE</b> 审批节点</span>
            <span><b>PUBLISH</b> 版本发布</span>
        </div>
    </div>
    <div class="wf-panel">
        <form id="js-search-form" class="layui-form wf-search" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">关键词</label>
                    <div class="layui-input-inline"><input type="text" name="keyword" placeholder="模型名称 / 编码" autocomplete="off" class="layui-input"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">业务类型</label>
                    <div class="layui-input-inline"><input type="text" name="businessType" placeholder="ORDER_APPROVAL" autocomplete="off" class="layui-input"></div>
                </div>
                <div class="layui-inline"><button class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i>查询</button></div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>
<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增模型</button>
    </div>
</script>
<script type="text/html" id="js-status-tpl">
    {{# if(d.status === 'published'){ }}<span class="wf-badge ok">已发布</span>{{# } else { }}<span class="wf-badge warn">草稿</span>{{# } }}
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    {{# if(d.status === 'published'){ }}
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="view"><i class="layui-icon layui-icon-search"></i>查看</a>
    {{# } else { }}
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>设计</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="publish"><i class="fa fa-rocket"></i>发布</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
    {{# } }}
</script>
<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url:'${request.contextPath}/workflow/model/page',
            cols:[[
                {field:'modelCode', title:'模型编码', width:160, style:'color:#0f62fe;font-weight:700;'},
                {field:'modelName', title:'模型名称', minWidth:190},
                {field:'businessType', title:'业务类型', width:160},
                {field:'status', title:'状态', width:90, templet:'#js-status-tpl'},
                {field:'remark', title:'备注', minWidth:240},
                {fixed:'right', title:'操作', toolbar:'#js-record-table-toolbar-right', width:230}
            ]]
        });
        form.on('submit(js-search-filter)', function(data){ tableIns.reload({where:data.field, page:{curr:1}}); return false; });
        table.on('toolbar(js-record-table-filter)', function(obj){ if (obj.event === 'add') openEdit(); });
        table.on('tool(js-record-table-filter)', function(obj){
            if (obj.event === 'edit') openEdit(obj.data.id);
            if (obj.event === 'view') openView(obj.data.id);
            if (obj.event === 'publish') {
                layer.confirm('发布后会生成新的流程定义版本，并启用为当前业务流程。确认发布？', function(index){
                    spUtil.ajax({url:'${request.contextPath}/workflow/model/publish', type:'POST', serializable:false, data:{id:obj.data.id}, success:function(){ tableIns.reload(); layer.close(index); }});
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认删除该流程模型吗？', function(index){
                    spUtil.ajax({url:'${request.contextPath}/workflow/model/delete', type:'POST', serializable:false, data:{id:obj.data.id}, success:function(){ tableIns.reload(); layer.close(index); }});
                });
            }
        });
        function openEdit(id) {
            spLayer.open({title:id ? '流程模型设计' : '新增流程模型', area:['980px','760px'], spWhere:id ? {id:id} : {}, content:'${request.contextPath}/workflow/model/add-or-update-ui'});
        }
        function openView(id) {
            layer.open({type:2, title:'流程模型查看', area:['980px','760px'], btn:['关闭'], content:'${request.contextPath}/workflow/model/add-or-update-ui?id=' + encodeURIComponent(id)});
        }
        form.render();
    });
</script>
</body>
</html>
