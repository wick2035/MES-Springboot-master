<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库房库位定义</title>
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
        #js-current-warehouse { color: #2563EB; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">

        <!-- ===================== 库房管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">库房管理</div>
            <!--查询参数-->
            <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">库房编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="warehouseCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">库房名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="warehouseNameLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                            <i class="layui-icon layui-icon-search"></i>查询
                        </a>
                    </div>
                </div>
            </form>
            <table class="layui-hide" id="js-warehouse-table" lay-filter="warehouse-table-filter"></table>
        </div>

        <!-- ===================== 库位管理 ===================== -->
        <div class="sp-section">
            <div class="sp-panel-title">
                库位管理 <span id="js-current-warehouse">（请先在上方选择一个库房）</span>
            </div>
            <table class="layui-hide" id="js-location-table" lay-filter="location-table-filter"></table>
        </div>

    </div>
</div>

<!--库房表头操作模板-->
<script type="text/html" id="js-warehouse-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon">&#xe61f;</i>新增
        </button>
    </div>
</script>

<!--库房行操作模板-->
<script type="text/html" id="js-warehouse-toolbar-right">
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

        var contextPath = '${request.contextPath}';
        var currentWarehouseId = '';
        var currentWarehouseName = '';

        function statusTemplet(d) {
            if (d.deleted === '0') return '<span style="color:green;">正常</span>';
            if (d.deleted === '2') return '<span style="color:orange;">禁用</span>';
            return '<span style="color:red;">删除</span>';
        }

        function typeTemplet(d) {
            if (d.warehouseType === '1') return '原材料库';
            if (d.warehouseType === '2') return '成品库';
            if (d.warehouseType === '3') return '半成品库';
            return '';
        }

        function locStatusTemplet(d) {
            return d.status === '2' ? '<span style="color:orange;">禁用</span>' : '<span style="color:green;">正常</span>';
        }

        // ---------------- 库房表格 ----------------
        var warehouseTableIns = spTable.render({
            elem: '#js-warehouse-table',
            url: contextPath + '/basedata/warehouse/page',
            toolbar: '#js-warehouse-toolbar-top',
            height: 320,
            cols: [
                [{
                    field: 'warehouseCode', title: '库房编码', width: 140,
                    templet: function (d) {
                        return '<a style="color:#2563EB;" href="javascript:void(0);">' + d.warehouseCode + '</a>';
                    }
                }, {
                    field: 'warehouseName', title: '库房名称', width: 180
                }, {
                    field: 'warehouseType', title: '库房类型', width: 100, templet: typeTemplet
                }, {
                    field: 'specGroup', title: '组', width: 70
                }, {
                    field: 'specRow', title: '排', width: 70
                }, {
                    field: 'specLayer', title: '层', width: 70
                }, {
                    field: 'specColumn', title: '列', width: 70
                }, {
                    field: 'warehouseDesc', title: '库房描述',
                    templet: function (d) { return d.warehouseDesc || ''; }
                }, {
                    field: 'deleted', title: '状态', width: 90, templet: statusTemplet
                }, {
                    field: 'updateTime', title: '更新时间', width: 160
                }, {
                    fixed: 'right', field: 'operate', title: '操作',
                    toolbar: '#js-warehouse-toolbar-right', unresize: true, width: 160
                }]
            ]
        });

        // ---------------- 库位表格 ----------------
        var locationTableIns = spTable.render({
            elem: '#js-location-table',
            url: contextPath + '/basedata/warehouse/location/page',
            where: {warehouseId: ''},
            height: 320,
            cols: [
                [{
                    field: 'locationCode', title: '库位编码', width: 220
                }, {
                    field: 'warehouseCode', title: '所属库房编码', width: 180
                }, {
                    field: 'status', title: '状态', width: 120, templet: locStatusTemplet
                }, {
                    field: 'updateTime', title: '更新时间', width: 180
                }]
            ]
        });

        $(function () { form.render(); });

        // 重新加载库位表格
        function reloadLocations() {
            locationTableIns.reload({where: {warehouseId: currentWarehouseId}, page: {curr: 1}});
        }

        // ---------------- 库房：搜索 ----------------
        form.on('submit(js-search-filter)', function (data) {
            warehouseTableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // ---------------- 库房：行点击选中 -> 加载库位 ----------------
        table.on('row(warehouse-table-filter)', function (obj) {
            currentWarehouseId = obj.data.id;
            currentWarehouseName = obj.data.warehouseName;
            $('#js-current-warehouse').text('（当前库房：' + currentWarehouseName + '）');
            // 高亮选中行
            obj.tr.addClass('layui-table-click').siblings().removeClass('layui-table-click');
            reloadLocations();
        });

        // ---------------- 库房：头工具栏（新增）----------------
        table.on('toolbar(warehouse-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增库房',
                    area: ['820px', '560px'],
                    content: contextPath + '/basedata/warehouse/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            warehouseTableIns.reload();
                        }
                    }
                });
            }
        });

        // ---------------- 库房：行工具（编辑/禁用/删除）----------------
        table.on('tool(warehouse-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑库房',
                    area: ['820px', '560px'],
                    spWhere: {id: data.id},
                    content: contextPath + '/basedata/warehouse/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            warehouseTableIns.reload();
                            // 若编辑的是当前选中库房，库位可能已重新生成，刷新库位表
                            if (currentWarehouseId === data.id) {
                                reloadLocations();
                            }
                        }
                    }
                });
            }
            if (obj.event === 'disable') {
                var newStatus = data.deleted === '0' ? '2' : '0';
                var action = newStatus === '2' ? '禁用' : '启用';
                layer.confirm('确认要' + action + '库房【' + data.warehouseName + '】吗？', function (index) {
                    $.post(contextPath + '/basedata/warehouse/disable', {id: data.id, status: newStatus}, function (res) {
                        if (res.code === 0) {
                            layer.msg(action + '成功');
                            warehouseTableIns.reload();
                        } else {
                            layer.msg(res.msg || (action + '失败'));
                        }
                    });
                    layer.close(index);
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除库房【' + data.warehouseName + '】吗？（其库位将一并删除）', function (index) {
                    $.post(contextPath + '/basedata/warehouse/delete', {id: data.id}, function (res) {
                        if (res.code === 0) {
                            layer.msg('删除成功');
                            if (currentWarehouseId === data.id) {
                                currentWarehouseId = '';
                                $('#js-current-warehouse').text('（请先在上方选择一个库房）');
                                reloadLocations();
                            }
                            warehouseTableIns.reload();
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
