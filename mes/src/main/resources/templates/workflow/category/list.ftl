<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程分类管理</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-shell">
    <div class="wf-hero">
        <div>
            <h1 class="wf-title">流程分类管理</h1>
            <div class="wf-subtitle">把生产审批、质量检验、出入库等流程按业务域归档，保持模型查找和复用清晰。</div>
        </div>
        <div class="wf-pill"><i class="fa fa-tags"></i> 流程管控</div>
    </div>
    <div class="wf-panel">
        <form id="js-search-form" class="layui-form wf-search" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">关键词</label>
                    <div class="layui-input-inline">
                        <input type="text" name="keyword" placeholder="分类名称 / 编码" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部</option>
                            <option value="0">正常</option>
                            <option value="2">停用</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i>查询</button>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增分类</button>
    </div>
</script>
<script type="text/html" id="js-status-tpl">
    {{# if(d.status === '0'){ }}<span class="wf-badge ok">正常</span>{{# } else { }}<span class="wf-badge gray">停用</span>{{# } }}
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/workflow/category/page',
            cols: [[
                {field: 'categoryCode', title: '分类编码', width: 140, style: 'color:#2563eb;font-weight:600;'},
                {field: 'categoryName', title: '分类名称', minWidth: 170},
                {field: 'parentId', title: '上级分类', width: 120, templet: function(d){ return d.parentId === '0' ? '根分类' : d.parentId; }},
                {field: 'sortNum', title: '排序', width: 90},
                {field: 'status', title: '状态', width: 90, templet: '#js-status-tpl'},
                {field: 'remark', title: '备注', minWidth: 220},
                {fixed: 'right', title: '操作', toolbar: '#js-record-table-toolbar-right', width: 150}
            ]]
        });
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') openEdit();
        });
        table.on('tool(js-record-table-filter)', function (obj) {
            if (obj.event === 'edit') openEdit(obj.data.id);
            if (obj.event === 'delete') {
                layer.confirm('确认删除该流程分类吗？', function (index) {
                    spUtil.ajax({url: '${request.contextPath}/workflow/category/delete', type: 'POST', serializable: false, data: {id: obj.data.id}, success: function(){ tableIns.reload(); layer.close(index); }});
                });
            }
        });
        function openEdit(id) {
            spLayer.open({title: id ? '编辑流程分类' : '新增流程分类', area: ['720px', '520px'], spWhere: id ? {id: id} : {}, content: '${request.contextPath}/workflow/category/add-or-update-ui'});
        }
        form.render();
    });
</script>
</body>
</html>
