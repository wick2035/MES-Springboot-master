<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>部门管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <!--查询参数-->
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">部门名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                        <i class="layui-icon layui-icon-search"></i>查询
                    </a>
                </div>
            </div>
        </form>

        <!--表格-->
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<!--表格头操作模板-->
<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <@shiro.hasPermission name="user:add">
            <button class="layui-btn layui-btn-sm" lay-event="add">
                <i class="layui-icon">&#xe61f;</i>新增
            </button>
        </@shiro.hasPermission>
    </div>
</script>

<!--行操作模板-->
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit" title="编辑">
        <i class="layui-icon layui-icon-edit"></i>
    </a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="disable" title="禁用/启用">
        <i class="layui-icon">&#xe690;</i>
    </a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete" title="删除">
        <i class="layui-icon layui-icon-delete"></i>
    </a>
</script>

<!--js逻辑-->
<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            spLayer = layui.spLayer,
            spTable = layui.spTable;

        // 表格及数据初始化
        var tableIns = spTable.render({
            url: '${request.contextPath}/admin/sys/department/page',
            toolbar: '#js-record-table-toolbar-top',
            cols: [
                [{
                    type: 'checkbox'
                }, {
                    field: 'name', title: '部门名称', width: 200
                }, {
                    field: 'parentId', title: '上级部门', width: 120,
                    templet: function (d) {
                        return d.parentId === '0' || !d.parentId ? '顶级部门' : d.parentId;
                    }
                }, {
                    field: 'sortNum', title: '排序号', width: 80
                }, {
                    field: 'isDeleted', title: '状态', width: 80,
                    templet: function (d) {
                        if (d.isDeleted === '0') return '<span style="color:green;">正常</span>';
                        if (d.isDeleted === '2') return '<span style="color:orange;">禁用</span>';
                        return '<span style="color:red;">删除</span>';
                    }
                }, {
                    field: 'updateTime', title: '更新时间', width: 160
                }, {
                    fixed: 'right',
                    field: 'operate',
                    title: '操作',
                    toolbar: '#js-record-table-toolbar-right',
                    unresize: true,
                    width: 150
                }]
            ],
            done: function (res, curr, count) {}
        });

        $(function () {
            form.render();
        });

        // 搜索
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({
                where: data.field,
                page: { curr: 1 }
            });
            return false;
        });

        // 头工具栏事件
        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增部门',
                    area: ['600px', '380px'],
                    content: '${request.contextPath}/admin/sys/department/add-or-update-ui'
                });
            }
        });

        // 行工具事件
        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;

            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑部门',
                    area: ['600px', '380px'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/admin/sys/department/add-or-update-ui'
                });
            }

            if (obj.event === 'delete') {
                layer.confirm('确认要删除部门【' + data.name + '】吗？', function (index) {
                    $.post('${request.contextPath}/admin/sys/department/delete', {id: data.id}, function (res) {
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

            if (obj.event === 'disable') {
                var newStatus = data.isDeleted === '0' ? '2' : '0';
                var action = newStatus === '2' ? '禁用' : '启用';
                layer.confirm('确认要' + action + '部门【' + data.name + '】吗？', function (index) {
                    $.post('${request.contextPath}/admin/sys/department/disable', {
                        id: data.id,
                        status: newStatus
                    }, function (res) {
                        if (res.code === 0) {
                            layer.msg(action + '成功');
                            tableIns.reload();
                        } else {
                            layer.msg(res.msg || action + '失败');
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