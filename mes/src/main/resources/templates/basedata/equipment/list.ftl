<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备列表</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">设备编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="equipmentCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">设备名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="equipmentNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">设备用途</label>
                    <div class="layui-input-inline">
                        <input type="text" name="purposeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i></a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/basedata/equipment/page',
            toolbar: '#js-record-table-toolbar-top',
            cols: [[
                {field: 'equipmentCode', title: '设备编号', width: 130},
                {field: 'equipmentName', title: '设备名称'},
                {field: 'equipmentModel', title: '设备规格/型号'},
                {field: 'purpose', title: '设备用途'},
                {field: 'spec', title: '设定条件', width: 120},
                {
                    field: 'status', title: '状态', width: 80, templet: function (d) {
                        return d.status === '1' ? '启用' : '停用';
                    }
                },
                {fixed: 'right', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 150}
            ]]
        });
        $(function () { form.render(); });
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增设备', area: ['700px', '550px'],
                    content: '${request.contextPath}/basedata/equipment/add-or-update-ui'
                });
            }
        });
        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑设备', area: ['700px', '550px'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/basedata/equipment/add-or-update-ui'
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/basedata/equipment/delete',
                        type: 'POST', serializable: false, data: {id: data.id},
                        success: function () { tableIns.reload(); layer.close(index); }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
