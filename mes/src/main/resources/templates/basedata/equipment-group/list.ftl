<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编组设备定义</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sp-panel-title {
            font-weight: bold;
            font-size: 14px;
            padding: 8px 4px;
            border-left: 3px solid #FF5722;
            padding-left: 8px;
            margin: 6px 0;
            background: #f7f7f7;
        }
        .sp-section { margin-bottom: 10px; }
        #js-current-group { color: #FF5722; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">

        <!-- ===================== 编组管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">编组管理</div>
            <!--查询参数-->
            <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">编组代码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="groupCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">编组名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="groupNameLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                            <i class="layui-icon layui-icon-search"></i>查询
                        </a>
                    </div>
                </div>
            </form>
            <table class="layui-hide" id="js-group-table" lay-filter="group-table-filter"></table>
        </div>

        <!-- ===================== 设备管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">
                设备管理 <span id="js-current-group">（请先在上方选择一个编组）</span>
            </div>
            <table class="layui-hide" id="js-device-table" lay-filter="device-table-filter"></table>
        </div>

    </div>
</div>

<!--编组表头操作模板-->
<script type="text/html" id="js-group-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon">&#xe61f;</i>新增
        </button>
    </div>
</script>

<!--编组行操作模板-->
<script type="text/html" id="js-group-toolbar-right">
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

<!--设备表头操作模板-->
<script type="text/html" id="js-device-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="addDevice">
            <i class="layui-icon">&#xe61f;</i>新增
        </button>
    </div>
</script>

<!--设备行操作模板-->
<script type="text/html" id="js-device-toolbar-right">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="removeDevice" title="移除">
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
        var currentGroupId = '';
        var currentGroupName = '';

        function statusTemplet(d) {
            if (d.deleted === '0') return '<span style="color:green;">正常</span>';
            if (d.deleted === '2') return '<span style="color:orange;">禁用</span>';
            return '<span style="color:red;">删除</span>';
        }

        // ---------------- 编组表格 ----------------
        var groupTableIns = spTable.render({
            elem: '#js-group-table',
            url: contextPath + '/basedata/equipment-group/page',
            toolbar: '#js-group-toolbar-top',
            height: 320,
            cols: [
                [{
                    field: 'groupCode', title: '编组代码', width: 160,
                    templet: function (d) {
                        return '<a style="color:#FF5722;" href="javascript:void(0);">' + d.groupCode + '</a>';
                    }
                }, {
                    field: 'groupName', title: '编组组名称', width: 200
                }, {
                    field: 'groupDesc', title: '编组描述',
                    templet: function (d) { return d.groupDesc || ''; }
                }, {
                    field: 'deleted', title: '状态', width: 90, templet: statusTemplet
                }, {
                    field: 'updateTime', title: '更新时间', width: 160
                }, {
                    fixed: 'right', field: 'operate', title: '操作',
                    toolbar: '#js-group-toolbar-right', unresize: true, width: 160
                }]
            ]
        });

        // ---------------- 设备表格 ----------------
        var deviceTableIns = spTable.render({
            elem: '#js-device-table',
            url: contextPath + '/basedata/equipment-group/device/page',
            toolbar: '#js-device-toolbar-top',
            where: {groupId: ''},
            height: 320,
            cols: [
                [{
                    field: 'equipmentCode', title: '设备编码', width: 200
                }, {
                    field: 'equipmentName', title: '设备名称', width: 200
                }, {
                    field: 'equipmentStatus', title: '状态', width: 100,
                    templet: function (d) {
                        return d.equipmentStatus === '1' ? '<span style="color:green;">正常</span>' : '<span style="color:red;">停用</span>';
                    }
                }, {
                    field: 'remark', title: '备注信息',
                    templet: function (d) { return d.remark || ''; }
                }, {
                    fixed: 'right', field: 'operate', title: '操作',
                    toolbar: '#js-device-toolbar-right', unresize: true, width: 120
                }]
            ]
        });

        $(function () { form.render(); });

        // 重新加载设备表格
        function reloadDevices() {
            deviceTableIns.reload({where: {groupId: currentGroupId}, page: {curr: 1}});
        }

        // ---------------- 编组：搜索 ----------------
        form.on('submit(js-search-filter)', function (data) {
            groupTableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // ---------------- 编组：行点击选中 -> 加载设备 ----------------
        table.on('row(group-table-filter)', function (obj) {
            currentGroupId = obj.data.id;
            currentGroupName = obj.data.groupName;
            $('#js-current-group').text('（当前编组：' + currentGroupName + '）');
            // 高亮选中行
            obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
            reloadDevices();
        });

        // ---------------- 编组：头工具栏（新增）----------------
        table.on('toolbar(group-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增设备编组',
                    area: ['760px', '460px'],
                    content: contextPath + '/basedata/equipment-group/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            groupTableIns.reload();
                        }
                    }
                });
            }
        });

        // ---------------- 编组：行工具（编辑/禁用/删除）----------------
        table.on('tool(group-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑设备编组',
                    area: ['760px', '460px'],
                    spWhere: {id: data.id},
                    content: contextPath + '/basedata/equipment-group/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            groupTableIns.reload();
                        }
                    }
                });
            }
            if (obj.event === 'disable') {
                var newStatus = data.deleted === '0' ? '2' : '0';
                var action = newStatus === '2' ? '禁用' : '启用';
                layer.confirm('确认要' + action + '编组【' + data.groupName + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/equipment-group/disable', {id: data.id, status: newStatus}, function (res) {
                        if (res.code === 0) {
                            layer.msg(action + '成功');
                            groupTableIns.reload();
                        } else {
                            layer.msg(res.msg || (action + '失败'));
                        }
                    });
                    layer.close(index);
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除编组【' + data.groupName + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/equipment-group/delete', {id: data.id}, function (res) {
                        if (res.code === 0) {
                            layer.msg('删除成功');
                            if (currentGroupId === data.id) {
                                currentGroupId = '';
                                $('#js-current-group').text('（请先在上方选择一个编组）');
                                reloadDevices();
                            }
                            groupTableIns.reload();
                        } else {
                            layer.msg(res.msg || '删除失败');
                        }
                    });
                    layer.close(index);
                });
            }
        });

        // ---------------- 设备：头工具栏（新增）----------------
        table.on('toolbar(device-table-filter)', function (obj) {
            if (obj.event === 'addDevice') {
                if (!currentGroupId) {
                    layer.msg('请先在上方选择一个编组');
                    return;
                }
                spLayer.open({
                    title: '生产设备选择 - ' + currentGroupName,
                    area: ['760px', '600px'],
                    content: contextPath + '/basedata/equipment-group/device-select-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0 && res.data && res.data.length > 0) {
                            $.post(contextPath + '/basedata/equipment-group/device/add',
                                {groupId: currentGroupId, equipmentIds: res.data.join(',')},
                                function (r) {
                                    layer.msg(r.msg || '操作完成');
                                    reloadDevices();
                                });
                        } else if (res && res.code === 0) {
                            layer.msg('未选择任何设备');
                        }
                    }
                });
            }
        });

        // ---------------- 设备：行工具（移除）----------------
        table.on('tool(device-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'removeDevice') {
                layer.confirm('确认从编组【' + currentGroupName + '】移除设备【' + (data.equipmentCode || '') + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/equipment-group/device/delete', {id: data.id}, function (res) {
                        if (res.code === 0) {
                            layer.msg('移除成功');
                            reloadDevices();
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
