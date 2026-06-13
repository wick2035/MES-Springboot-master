<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>班组员工定义</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sp-panel-title {
            font-weight: bold;
            font-size: 14px;
            padding: 8px 4px;
            border-left: 3px solid #2563EB;
            padding-left: 8px;
            margin: 6px 0;
            background: #f7f7f7;
        }
        .sp-section { margin-bottom: 10px; }
        #js-current-team { color: #2563EB; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">

        <!-- ===================== 班组管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">班组管理</div>
            <!--查询参数-->
            <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">班组代码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="teamCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">班组名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="teamNameLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                            <i class="layui-icon layui-icon-search"></i>查询
                        </a>
                    </div>
                </div>
            </form>
            <table class="layui-hide" id="js-team-table" lay-filter="team-table-filter"></table>
        </div>

        <!-- ===================== 班组员工管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">
                班组员工管理 <span id="js-current-team">（请先在上方选择一个班组）</span>
            </div>
            <table class="layui-hide" id="js-employee-table" lay-filter="employee-table-filter"></table>
        </div>

    </div>
</div>

<!--班组表头操作模板-->
<script type="text/html" id="js-team-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon">&#xe61f;</i>新增
        </button>
    </div>
</script>

<!--班组行操作模板-->
<script type="text/html" id="js-team-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit" title="编辑">
        <i class="layui-icon layui-icon-edit"></i>编辑
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

<!--班组员工表头操作模板-->
<script type="text/html" id="js-employee-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="addEmp">
            <i class="layui-icon">&#xe61f;</i>新增员工
        </button>
    </div>
</script>

<!--班组员工行操作模板-->
<script type="text/html" id="js-employee-toolbar-right">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="removeEmp" title="移除">
        <i class="layui-icon layui-icon-delete"></i>移除
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

        var contextPath = '${request.contextPath}';
        var currentTeamId = '';
        var currentTeamName = '';

        function statusTemplet(d) {
            if (d.deleted === '0') return '<span style="color:green;">正常</span>';
            if (d.deleted === '2') return '<span style="color:orange;">禁用</span>';
            return '<span style="color:red;">删除</span>';
        }

        // ---------------- 班组表格 ----------------
        var teamTableIns = spTable.render({
            elem: '#js-team-table',
            url: contextPath + '/basedata/team/page',
            toolbar: '#js-team-toolbar-top',
            height: 320,
            cols: [
                [{
                    field: 'teamCode', title: '班组代码', width: 160,
                    templet: function (d) {
                        return '<a style="color:#2563EB;" href="javascript:void(0);">' + d.teamCode + '</a>';
                    }
                }, {
                    field: 'teamName', title: '班组名称', width: 200
                }, {
                    field: 'teamDesc', title: '班组描述',
                    templet: function (d) { return d.teamDesc || ''; }
                }, {
                    field: 'deleted', title: '状态', width: 90, templet: statusTemplet
                }, {
                    field: 'updateTime', title: '更新时间', width: 160
                }, {
                    fixed: 'right', field: 'operate', title: '操作',
                    toolbar: '#js-team-toolbar-right', unresize: true, width: 300
                }]
            ]
        });

        // ---------------- 班组员工表格 ----------------
        var employeeTableIns = spTable.render({
            elem: '#js-employee-table',
            url: contextPath + '/basedata/team/employee/page',
            toolbar: '#js-employee-toolbar-top',
            where: {teamId: ''},
            height: 320,
            cols: [
                [{
                    field: 'username', title: '用户编码', width: 200
                }, {
                    field: 'userName', title: '姓名', width: 200
                }, {
                    field: 'deleted', title: '状态', width: 100,
                    templet: function (d) {
                        return d.deleted === '0' ? '<span style="color:green;">正常</span>' : '<span style="color:red;">已移除</span>';
                    }
                }, {
                    field: 'createTime', title: '加入时间', width: 160
                }, {
                    fixed: 'right', field: 'operate', title: '操作',
                    toolbar: '#js-employee-toolbar-right', unresize: true, width: 120
                }]
            ]
        });

        $(function () { form.render(); });

        // 重新加载员工表格
        function reloadEmployees() {
            employeeTableIns.reload({where: {teamId: currentTeamId}, page: {curr: 1}});
        }

        // ---------------- 班组：搜索 ----------------
        form.on('submit(js-search-filter)', function (data) {
            teamTableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // ---------------- 班组：行点击选中 -> 加载员工 ----------------
        table.on('row(team-table-filter)', function (obj) {
            currentTeamId = obj.data.id;
            currentTeamName = obj.data.teamName;
            $('#js-current-team').text('（当前班组：' + currentTeamName + '）');
            // 高亮选中行
            obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
            reloadEmployees();
        });

        // ---------------- 班组：头工具栏（新增）----------------
        table.on('toolbar(team-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增班组',
                    area: ['760px', '460px'],
                    content: contextPath + '/basedata/team/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            teamTableIns.reload();
                        }
                    }
                });
            }
        });

        // ---------------- 班组：行工具（编辑/禁用/删除）----------------
        table.on('tool(team-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑班组',
                    area: ['760px', '460px'],
                    spWhere: {id: data.id},
                    content: contextPath + '/basedata/team/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            teamTableIns.reload();
                        }
                    }
                });
            }
            if (obj.event === 'disable') {
                var newStatus = data.deleted === '0' ? '2' : '0';
                var action = newStatus === '2' ? '禁用' : '启用';
                layer.confirm('确认要' + action + '班组【' + data.teamName + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/team/disable', {id: data.id, status: newStatus}, function (res) {
                        if (res.code === 0) {
                            layer.msg(action + '成功');
                            teamTableIns.reload();
                        } else {
                            layer.msg(res.msg || (action + '失败'));
                        }
                    });
                    layer.close(index);
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除班组【' + data.teamName + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/team/delete', {id: data.id}, function (res) {
                        if (res.code === 0) {
                            layer.msg('删除成功');
                            if (currentTeamId === data.id) {
                                currentTeamId = '';
                                $('#js-current-team').text('（请先在上方选择一个班组）');
                                reloadEmployees();
                            }
                            teamTableIns.reload();
                        } else {
                            layer.msg(res.msg || '删除失败');
                        }
                    });
                    layer.close(index);
                });
            }
        });

        // ---------------- 员工：头工具栏（新增员工）----------------
        table.on('toolbar(employee-table-filter)', function (obj) {
            if (obj.event === 'addEmp') {
                if (!currentTeamId) {
                    layer.msg('请先在上方选择一个班组');
                    return;
                }
                spLayer.open({
                    title: '用户选择 - ' + currentTeamName,
                    area: ['520px', '600px'],
                    content: contextPath + '/basedata/team/employee-select-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0 && res.data && res.data.length > 0) {
                            $.post(contextPath + '/basedata/team/employee/add',
                                {teamId: currentTeamId, userIds: res.data.join(',')},
                                function (r) {
                                    layer.msg(r.msg || '操作完成');
                                    reloadEmployees();
                                });
                        } else if (res && res.code === 0) {
                            layer.msg('未选择任何员工');
                        }
                    }
                });
            }
        });

        // ---------------- 员工：行工具（移除）----------------
        table.on('tool(employee-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'removeEmp') {
                layer.confirm('确认从班组【' + currentTeamName + '】移除员工【' + (data.userName || data.username) + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/team/employee/delete', {id: data.id}, function (res) {
                        if (res.code === 0) {
                            layer.msg('移除成功');
                            reloadEmployees();
                        } else {
                            layer.msg(res.msg || '移除失败');
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
