<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>系统用户列表</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        /* 当前角色——精致药丸标签 */
        .role-chip {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            height: 22px;
            padding: 0 10px 0 9px;
            margin: 2px 4px 2px 0;
            font-size: 12px;
            line-height: 22px;
            color: #0a5ec2;
            background: #eef4ff;
            border-radius: 11px;
            white-space: nowrap;
            transition: background .15s ease;
        }
        .role-chip:hover { background: #e2edff; }
        .role-chip i {
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background: #0a84ff;
            flex: 0 0 5px;
        }
        .role-chip-empty {
            color: #b0b0b8;
            background: #f3f3f5;
        }
        .role-chip-empty::before { content: none; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="usernameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i
                                class="layui-icon layui-icon-search"></i>查询</a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <@shiro.hasPermission name="user:add">
            <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增</button>
        </@shiro.hasPermission>
    </div>
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit" title="编辑"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="assignRole" title="分配角色">
        <i class="layui-icon layui-icon-username"></i>分配角色
    </a>
    <a class="layui-btn layui-btn-xs" lay-event="resetPassword" title="重置密码">
        <i class="layui-icon layui-icon-password"></i>重置密码
    </a>
    {{# if(d.deleted === '0'){ }}
    <a class="layui-btn layui-btn-xs sp-toggle-btn sp-toggle-btn-disable" lay-event="disable" title="禁用" aria-label="禁用">
        <i class="fa fa-ban"></i>禁用
    </a>
    {{# } else { }}
    <a class="layui-btn layui-btn-xs sp-toggle-btn sp-toggle-btn-enable" lay-event="disable" title="启用" aria-label="启用">
        <i class="fa fa-check-circle"></i>启用
    </a>
    {{# } }}
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete" title="删除">
        <i class="layui-icon layui-icon-delete"></i>删除
    </a>
</script>

<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer,
            spLayer = layui.spLayer, spTable = layui.spTable;

        var sexDict = {'0': '女', '1': '男', '2': '其他'};

        var tableIns = spTable.render({
            url: '${request.contextPath}/admin/sys/user/page',
            toolbar: '#js-record-table-toolbar-top',
            cols: [[
                {field: 'name', title: '姓名', width: 110},
                {field: 'username', title: '用户名', width: 130},
                {
                    field: 'roleNames', title: '当前角色', minWidth: 220, templet: function (d) {
                        if (!d.roleNames) return '<span class="role-chip role-chip-empty">未分配</span>';
                        return d.roleNames.split('、').map(function (n) {
                            return '<span class="role-chip"><i></i>' + n + '</span>';
                        }).join('');
                    }
                },
                {field: 'mobile', title: '手机号', width: 120},
                {field: 'deptName', title: '部门', width: 140,
                    templet: function (d) { return d.deptName || '<span style="color:#bbb;">未分配</span>'; }
                },
                {field: 'email', title: '邮箱', width: 160},
                {
                    field: 'sex', title: '性别', width: 70, templet: function (d) { return sexDict[d.sex] || '-'; }
                },
                {
                    field: 'deleted', title: '状态', width: 80, templet: function (d) {
                        if (d.deleted === '0') return '<span style="color:green;">正常</span>';
                        if (d.deleted === '2') return '<span style="color:orange;">禁用</span>';
                        return '<span style="color:red;">删除</span>';
                    }
                },
                {field: 'updateTime', title: '更新时间', width: 160},
                {
                    fixed: 'right', title: '操作', toolbar: '#js-record-table-toolbar-right',
                    unresize: true, width: 500
                }
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
                    title: '新增用户', area: ['90%', '90%'],
                    content: '${request.contextPath}/admin/sys/user/add-or-update-ui'
                });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;

            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑用户', area: ['90%', '90%'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/admin/sys/user/add-or-update-ui'
                });
            }

            if (obj.event === 'assignRole') {
                spLayer.open({
                    title: '分配角色 - ' + data.name, area: ['680px', '600px'],
                    content: '${request.contextPath}/admin/sys/user/assign-role-ui?userId=' + data.id
                });
            }

            if (obj.event === 'resetPassword') {
                layer.prompt({title: '请输入新密码（默认 123456）', value: '123456'}, function (newPwd, idx) {
                    if (!newPwd) { layer.msg('密码不能为空'); return; }
                    spUtil.ajax({
                        url: '${request.contextPath}/admin/sys/user/reset-password',
                        type: 'POST', serializable: false,
                        data: {id: data.id, newPassword: newPwd},
                        success: function (resp) {
                            layer.close(idx);
                            layer.msg(resp.msg || '重置成功');
                        }
                    });
                });
            }

            if (obj.event === 'disable') {
                var newStatus = data.deleted === '0' ? '2' : '0';
                var action = newStatus === '2' ? '禁用' : '启用';
                layer.confirm('确认要' + action + '用户【' + data.name + '】吗？', function (idx) {
                    spUtil.ajax({
                        url: '${request.contextPath}/admin/sys/user/disable',
                        type: 'POST', serializable: false,
                        data: {id: data.id, status: newStatus},
                        success: function () {
                            layer.close(idx);
                            layer.msg(action + '成功');
                            tableIns.reload();
                        }
                    });
                });
            }

            if (obj.event === 'delete') {
                layer.confirm('确认要删除用户【' + data.name + '】吗？', function (idx) {
                    spUtil.ajax({
                        url: '${request.contextPath}/admin/sys/user/delete',
                        type: 'POST', serializable: false, data: {id: data.id},
                        success: function () {
                            layer.close(idx);
                            layer.msg('删除成功');
                            tableIns.reload();
                        }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
