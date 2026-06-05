<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>加工单元定义</title>
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
        #js-current-unit { color: #2563EB; }
        #js-bind-tip { color: #FFB800; font-size: 12px; margin-left: 8px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">

        <!-- ===================== 加工单元管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">加工单元管理</div>
            <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">单元编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="unitCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">单元名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="unitNameLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                            <i class="layui-icon layui-icon-search"></i>查询</a>
                    </div>
                </div>
            </form>
            <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        </div>

        <!-- ===================== 加工单元班组管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">
                加工单元班组管理 <span id="js-current-unit">（请先在上方选择一个加工单元）</span>
                <span id="js-bind-tip"></span>
            </div>
            <table class="layui-hide" id="js-team-table" lay-filter="js-team-table-filter"></table>
        </div>

    </div>
</div>

<!--加工单元表头操作模板-->
<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>添加</button>
    </div>
</script>
<!--加工单元行操作模板-->
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<!--班组表头操作模板-->
<script type="text/html" id="js-team-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="bind"><i class="layui-icon">&#xe61f;</i>新增</button>
    </div>
</script>
<!--班组行操作模板-->
<script type="text/html" id="js-team-toolbar-right">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="unbind"><i class="layui-icon layui-icon-delete"></i>移除</a>
</script>

<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer,
            spLayer = layui.spLayer, spTable = layui.spTable;

        var contextPath = '${request.contextPath}';
        var unitTypeDict = {person: '人员作业单元', device: '设备作业单元'};
        var currentUnitId = '';
        var currentUnitName = '';
        var currentUnitType = '';

        // ---------------- 加工单元表格 ----------------
        var unitTableIns = spTable.render({
            elem: '#js-record-table',
            url: contextPath + '/basedata/processing-unit/page',
            toolbar: '#js-record-table-toolbar-top',
            height: 330,
            cols: [[
                {field: 'unitCode', title: '单元编号', width: 140},
                {field: 'unitName', title: '单元名称'},
                {
                    field: 'stdCapacity', title: '标准产能(小时)', width: 130, templet: function (d) {
                        return d.stdCapacity != null ? d.stdCapacity : '';
                    }
                },
                {
                    field: 'unitType', title: '单元类型', width: 130, templet: function (d) {
                        return unitTypeDict[d.unitType] || d.unitType;
                    }
                },
                {
                    field: 'status', title: '状态', width: 80, templet: function (d) {
                        return d.status === '1' ? '启用' : '停用';
                    }
                },
                {
                    field: 'hasEdgeWarehouse', title: '是否有线边库', width: 120, templet: function (d) {
                        return d.hasEdgeWarehouse === 'Y' ? '是' : '否';
                    }
                },
                {fixed: 'right', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 150}
            ]]
        });

        // ---------------- 加工单元班组表格 ----------------
        var teamTableIns = spTable.render({
            elem: '#js-team-table',
            url: contextPath + '/basedata/processing-unit/team/page',
            toolbar: '#js-team-toolbar-top',
            where: {unitId: ''},
            height: 300,
            cols: [[
                {field: 'teamCode', title: '工作组代码', width: 200},
                {field: 'teamName', title: '工作组名称', width: 240},
                {
                    field: 'deleted', title: '状态', width: 120, templet: function (d) {
                        return d.deleted === '0' ? '<span style="color:green;">正常</span>' : '<span style="color:red;">已移除</span>';
                    }
                },
                {field: 'createTime', title: '绑定时间', width: 170},
                {fixed: 'right', title: '操作', toolbar: '#js-team-toolbar-right', unresize: true, width: 120}
            ]],
            done: function (res) {
                // 软提醒：人员作业单元建议绑定生产班组（不阻断）
                var count = res && res.data ? res.data.length : 0;
                if (currentUnitId && currentUnitType === 'person' && count === 0) {
                    $('#js-bind-tip').text('提示：人员作业单元建议绑定生产班组');
                } else {
                    $('#js-bind-tip').text('');
                }
            }
        });

        $(function () { form.render(); });

        function reloadTeams() {
            teamTableIns.reload({where: {unitId: currentUnitId}, page: {curr: 1}});
        }

        // ---------------- 加工单元：搜索 ----------------
        form.on('submit(js-search-filter)', function (data) {
            unitTableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // ---------------- 加工单元：行点击选中 ----------------
        table.on('row(js-record-table-filter)', function (obj) {
            currentUnitId = obj.data.id;
            currentUnitName = obj.data.unitName;
            currentUnitType = obj.data.unitType;
            $('#js-current-unit').text('（当前加工单元：' + currentUnitName + '）');
            obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
            reloadTeams();
        });

        // ---------------- 加工单元：头工具栏（添加）----------------
        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '添加加工单元', area: ['600px', '600px'],
                    content: contextPath + '/basedata/processing-unit/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) { unitTableIns.reload(); }
                    }
                });
            }
        });

        // ---------------- 加工单元：行工具（编辑/删除）----------------
        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑加工单元', area: ['600px', '600px'],
                    spWhere: {id: data.id},
                    content: contextPath + '/basedata/processing-unit/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) { unitTableIns.reload(); }
                    }
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除加工单元【' + data.unitName + '】吗？', function (index) {
                    spUtil.ajax({
                        url: contextPath + '/basedata/processing-unit/delete',
                        type: 'POST', serializable: false, data: {id: data.id},
                        success: function () {
                            if (currentUnitId === data.id) {
                                currentUnitId = '';
                                currentUnitType = '';
                                $('#js-current-unit').text('（请先在上方选择一个加工单元）');
                                reloadTeams();
                            }
                            unitTableIns.reload();
                            layer.close(index);
                        }
                    });
                });
            }
        });

        // ---------------- 班组：头工具栏（绑定班组）----------------
        table.on('toolbar(js-team-table-filter)', function (obj) {
            if (obj.event === 'bind') {
                if (!currentUnitId) {
                    layer.msg('请先在上方选择一个加工单元');
                    return;
                }
                spLayer.open({
                    title: '选择班组 - ' + currentUnitName,
                    area: ['760px', '560px'],
                    content: contextPath + '/basedata/processing-unit/team-select-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0 && res.data && res.data.length > 0) {
                            $.post(contextPath + '/basedata/processing-unit/team/add',
                                {unitId: currentUnitId, teamIds: res.data.join(',')},
                                function (r) {
                                    layer.msg(r.msg || '操作完成');
                                    reloadTeams();
                                });
                        } else if (res && res.code === 0) {
                            layer.msg('未选择任何班组');
                        }
                    }
                });
            }
        });

        // ---------------- 班组：行工具（移除）----------------
        table.on('tool(js-team-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'unbind') {
                layer.confirm('确认从加工单元【' + currentUnitName + '】移除班组【' + (data.teamName || data.teamCode) + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/processing-unit/team/delete', {id: data.id}, function (res) {
                        if (res.code === 0) {
                            layer.msg('移除成功');
                            reloadTeams();
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
