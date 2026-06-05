<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>角色管理</title>
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
                    <label class="layui-form-label">角色名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">角色编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="codeLike" autocomplete="off" class="layui-input">
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
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon">&#xe61f;</i>新增
        </button>
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
    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="authMenu" title="授权菜单">
        <i class="layui-icon layui-icon-ok-circle"></i>授权菜单
    </a>
    <a class="layui-btn layui-btn-xs" lay-event="dataScope" title="数据权限">
        <i class="layui-icon layui-icon-spread-left"></i>数据权限
    </a>
    <a class="layui-btn layui-btn-xs" lay-event="assignUser" title="分配用户" style="background:#16A34A;">
        <i class="layui-icon layui-icon-username"></i>分配用户
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

        var isSystemRoleDict = {'0': '否', '1': '是'};

        // 表格及数据初始化
        var tableIns = spTable.render({
            url: '${request.contextPath}/admin/sys/role/page',
            toolbar: '#js-record-table-toolbar-top',
            cols: [
                [{
                    type: 'checkbox'
                }, {
                    field: 'name', title: '角色名称', width: 120,
                    templet: function (d) {
                        return '<a style="color:#2563EB;" href="javascript:void(0);">' + d.name + '</a>';
                    }
                }, {
                    field: 'code', title: '角色编码', width: 150
                }, {
                    field: 'sortNum', title: '排序号', width: 70
                }, {
                    field: 'isSystemRole', title: '系统角色', width: 80,
                    templet: function (d) {
                        return isSystemRoleDict[d.isSystemRole] || '否';
                    }
                }, {
                    field: 'userType', title: '用户类型', width: 90,
                    templet: function (d) { return d.userType || '未设置'; }
                }, {
                    field: 'dataScope', title: '数据范围', width: 110,
                    templet: function (d) { return d.dataScope || '未设置'; }
                }, {
                    field: 'businessScope', title: '业务范围', width: 110,
                    templet: function (d) { return d.businessScope || '未设置'; }
                }, {
                    field: 'updateTime', title: '更新时间', width: 140
                }, {
                    field: 'deleted', title: '状态', width: 70,
                    templet: function (d) {
                        if (d.deleted === '0') return '<span style="color:green;">正常</span>';
                        if (d.deleted === '2') return '<span style="color:orange;">禁用</span>';
                        return '<span style="color:red;">删除</span>';
                    }
                }, {
                    fixed: 'right',
                    field: 'operate',
                    title: '操作',
                    toolbar: '#js-record-table-toolbar-right',
                    unresize: true,
                    width: 360
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
                    title: '新增角色',
                    area: ['800px', '480px'],
                    content: '${request.contextPath}/admin/sys/role/add-or-update-ui'
                });
            }
        });

        // 行工具事件
        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;

            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑角色',
                    area: ['800px', '480px'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/admin/sys/role/add-or-update-ui'
                });
            }

            if (obj.event === 'delete') {
                layer.confirm('确认要删除角色【' + data.name + '】吗？', function (index) {
                    $.post('${request.contextPath}/admin/sys/role/delete', {id: data.id}, function (res) {
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
                var newStatus = data.deleted === '0' ? '2' : '0';
                var action = newStatus === '2' ? '禁用' : '启用';
                layer.confirm('确认要' + action + '角色【' + data.name + '】吗？', function (index) {
                    $.post('${request.contextPath}/admin/sys/role/disable', {id: data.id, status: newStatus}, function (res) {
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

            if (obj.event === 'authMenu') {
                spLayer.open({
                    title: '授权菜单 - ' + data.name,
                    area: ['600px', '600px'],
                    content: '${request.contextPath}/admin/sys/role/auth-menu-ui?roleId=' + data.id
                });
            }

            if (obj.event === 'dataScope') {
                spLayer.open({
                    title: '数据权限 - ' + data.name,
                    area: ['500px', '350px'],
                    content: '${request.contextPath}/admin/sys/role/data-scope-ui?roleId=' + data.id
                });
            }

            if (obj.event === 'assignUser') {
                spLayer.open({
                    title: '分配用户 - ' + data.name,
                    area: ['900px', '600px'],
                    content: '${request.contextPath}/admin/sys/role/assign-user-ui?roleId=' + data.id
                });
            }
        });
    });
</script>
</body>
</html>
