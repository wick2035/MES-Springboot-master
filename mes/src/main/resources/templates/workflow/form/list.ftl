<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程表单管理</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-shell">
    <div class="wf-hero wf-hero-command">
        <div>
            <h1 class="wf-title">流程表单管理</h1>
            <div class="wf-subtitle">把流程定义、业务表单、审批事件和按钮权限收束到同一个配置台，生产订单审批在这里完成最后一公里。</div>
        </div>
        <div class="wf-metric-strip">
            <span><b>ORDER</b> 订单审批</span>
            <span><b>URL</b> 双端表单</span>
            <span><b>SAFE</b> 安全事件</span>
        </div>
    </div>
    <div class="wf-panel">
        <form id="js-search-form" class="layui-form wf-search" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">关键词</label>
                    <div class="layui-input-inline"><input type="text" name="keyword" placeholder="表单名称 / Key / 定义编码" class="layui-input"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">业务类型</label>
                    <div class="layui-input-inline"><input type="text" name="businessType" placeholder="ORDER_APPROVAL" class="layui-input"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status"><option value="">全部</option><option value="0">启用</option><option value="2">停用</option></select>
                    </div>
                </div>
                <div class="layui-inline"><button class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i>查询</button></div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增流程表单</button>
    </div>
</script>
<script type="text/html" id="js-status-tpl">
    {{# if(d.status === '0'){ }}<span class="wf-badge ok">启用</span>{{# } else { }}<span class="wf-badge gray">停用</span>{{# } }}
</script>
<script type="text/html" id="js-options-tpl">
    <span class="wf-mini-chip {{ d.allowReturn === 1 ? 'on' : '' }}">退回</span>
    <span class="wf-mini-chip {{ d.allowTransfer === 1 ? 'on' : '' }}">转办</span>
    <span class="wf-mini-chip {{ d.allowEntrust === 1 ? 'on' : '' }}">委托</span>
    <span class="wf-mini-chip {{ d.allowRevoke === 1 ? 'on' : '' }}">撤回</span>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/workflow/form/page',
            cols: [[
                {field:'formKey', title:'表单Key', width:150, style:'color:#0f62fe;font-weight:700;'},
                {field:'formName', title:'表单名称', minWidth:170},
                {field:'businessType', title:'业务类型', width:150},
                {field:'definitionCode', title:'流程定义', width:130},
                {field:'formType', title:'类型', width:80, templet:function(){ return '<span class="wf-badge info">URL</span>'; }},
                {field:'pcFormUrl', title:'PC表单地址', minWidth:260},
                {field:'eventTemplate', title:'安全事件', width:130, templet:function(d){ return '<span class="wf-badge warn">'+ escapeHtml(d.eventTemplate || '-') +'</span>'; }},
                {field:'allowReturn', title:'按钮选项', width:210, templet:'#js-options-tpl'},
                {field:'status', title:'状态', width:80, templet:'#js-status-tpl'},
                {fixed:'right', title:'操作', toolbar:'#js-record-table-toolbar-right', width:140}
            ]]
        });

        form.on('submit(js-search-filter)', function(data){ tableIns.reload({where:data.field, page:{curr:1}}); return false; });
        table.on('toolbar(js-record-table-filter)', function(obj){ if (obj.event === 'add') openEdit(); });
        table.on('tool(js-record-table-filter)', function(obj){
            if (obj.event === 'edit') openEdit(obj.data.id);
            if (obj.event === 'delete') {
                layer.confirm('确认删除该流程表单吗？', function(index){
                    spUtil.ajax({url:'${request.contextPath}/workflow/form/delete', type:'POST', serializable:false, data:{id:obj.data.id}, success:function(){ tableIns.reload(); layer.close(index); }});
                });
            }
        });
        function openEdit(id) {
            spLayer.open({
                title: id ? '编辑流程表单' : '新增流程表单',
                area: ['980px', '760px'],
                spWhere: id ? {id:id} : {},
                content: '${request.contextPath}/workflow/form/add-or-update-ui'
            });
        }
        function escapeHtml(value) {
            return String(value || '').replace(/[&<>"']/g, function(c){
                return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c];
            });
        }
        form.render();
    });
</script>
</body>
</html>
