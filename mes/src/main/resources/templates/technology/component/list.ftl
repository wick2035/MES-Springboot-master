<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>零部件定义</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">产品名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="productNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">零部件编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="componentCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">零部件名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="componentNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">类型</label>
                    <div class="layui-input-inline">
                        <select name="componentType">
                            <option value="">全部</option>
                            <option value="PG">半成品</option>
                            <option value="COMP">组件</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                        <i class="layui-icon layui-icon-search"></i>查询
                    </a>
                </div>
            </div>
        </form>

        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon">&#xe61f;</i>新增
        </button>
    </div>
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit" title="编辑">
        <i class="layui-icon layui-icon-edit"></i>
    </a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="disable" title="启用/禁用">
        <i class="layui-icon">&#xe690;</i>
    </a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete" title="删除">
        <i class="layui-icon layui-icon-delete"></i>
    </a>
</script>

<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            spLayer = layui.spLayer,
            spTable = layui.spTable;

        var contextPath = '${request.contextPath}';
        var typeLabels = { PG: '半成品', COMP: '组件' };

        function statusTemplet(d) {
            if (d.deleted === '0') return '<span style="color:green;">正常</span>';
            if (d.deleted === '2') return '<span style="color:orange;">禁用</span>';
            return '<span style="color:red;">删除</span>';
        }

        var tableIns = spTable.render({
            elem: '#js-record-table',
            url: contextPath + '/technology/component/page',
            toolbar: '#js-record-table-toolbar-top',
            cols: [[
                { type: 'radio' },
                { field: 'componentCode', title: '零部件编号', width: 140 },
                { field: 'productName', title: '产品名称', width: 180 },
                { field: 'componentName', title: '零部件名称', width: 190 },
                { field: 'componentType', title: '类型', width: 90, align: 'center',
                    templet: function (d) { return typeLabels[d.componentType] || '-'; } },
                { field: 'deleted', title: '状态', width: 90, align: 'center', templet: statusTemplet },
                { field: 'remark', title: '备注' },
                { field: 'updateTime', title: '更新时间', width: 160 },
                { fixed: 'right', field: 'operate', title: '操作',
                    toolbar: '#js-record-table-toolbar-right', unresize: true, width: 150 }
            ]]
        });

        $(function () { form.render(); });

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({ where: data.field, page: { curr: 1 } });
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增零部件',
                    area: ['760px', '500px'],
                    content: contextPath + '/technology/component/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) tableIns.reload();
                    }
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑零部件',
                    area: ['760px', '500px'],
                    spWhere: { id: data.id },
                    content: contextPath + '/technology/component/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) tableIns.reload();
                    }
                });
            }
            if (obj.event === 'disable') {
                var newStatus = data.deleted === '0' ? '2' : '0';
                var action = newStatus === '2' ? '禁用' : '启用';
                layer.confirm('确认要' + action + '零部件【' + data.componentName + '】吗？', function (index) {
                    $.post(contextPath + '/technology/component/disable',
                        { id: data.id, status: newStatus },
                        function (res) {
                            if (res.code === 0) {
                                layer.msg(action + '成功');
                                tableIns.reload();
                            } else {
                                layer.msg(res.msg || (action + '失败'));
                            }
                        });
                    layer.close(index);
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除零部件【' + data.componentName + '】吗？', function (index) {
                    $.post(contextPath + '/technology/component/delete', { id: data.id }, function (res) {
                        if (res.code === 0) {
                            layer.msg('删除成功');
                            tableIns.reload();
                        } else {
                            layer.msg(res.msg || '删除失败');
                        }
                    });
                    layer.close(index);
                });
            }
        });
    });
</script>
</body>
</html>
