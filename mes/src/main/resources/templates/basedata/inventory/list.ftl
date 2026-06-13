<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存管理</title>
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
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="sp-panel-title">库存管理（库位 + 物料 + 数量）</div>
        <!--查询参数-->
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">库房</label>
                    <div class="layui-input-inline">
                        <select name="warehouseId" id="js-warehouse-select">
                            <option value="">全部库房</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materielLike" placeholder="编码/名称" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">库位编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="locationCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                        <i class="layui-icon layui-icon-search"></i>查询
                    </a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-inventory-table" lay-filter="inventory-table-filter"></table>
    </div>
</div>

<!--表头操作模板-->
<script type="text/html" id="js-inventory-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon">&#xe61f;</i>入库
        </button>
    </div>
</script>

<!--行操作模板-->
<script type="text/html" id="js-inventory-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit" title="编辑">
        <i class="layui-icon layui-icon-edit"></i>
    </a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete" title="出库(删除)">
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

        // 加载库房下拉
        $.post(contextPath + '/digital/simulation/warehouse-list', {}, function (res) {
            if (res.code === 0 && res.data) {
                var html = '<option value="">全部库房</option>';
                $.each(res.data, function (i, w) {
                    html += '<option value="' + w.id + '">' + w.warehouseCode + ' ' + w.warehouseName + '</option>';
                });
                $('#js-warehouse-select').html(html);
                form.render('select');
            }
        });

        var inventoryTableIns = spTable.render({
            elem: '#js-inventory-table',
            url: contextPath + '/basedata/inventory/page',
            toolbar: '#js-inventory-toolbar-top',
            cols: [
                [{
                    field: 'warehouseCode', title: '库房', width: 160,
                    templet: function (d) {
                        return (d.warehouseCode || '') + ' ' + (d.warehouseName || '');
                    }
                }, {
                    field: 'locationCode', title: '库位编码', width: 200
                }, {
                    field: 'materielCode', title: '物料编码', width: 130
                }, {
                    field: 'materielDesc', title: '物料名称', width: 180
                }, {
                    field: 'batchNo', title: '批号', width: 140,
                    templet: function (d) { return d.batchNo || ''; }
                }, {
                    field: 'qty', title: '数量', width: 110
                }, {
                    field: 'unit', title: '单位', width: 80,
                    templet: function (d) { return d.unit || ''; }
                }, {
                    field: 'stockStatus', title: '库存状态', width: 100,
                    templet: function (d) {
                        return d.stockStatus === 'AVAILABLE'
                            ? '<span class="sp-badge sp-badge-success">可用</span>'
                            : (d.stockStatus || '');
                    }
                }, {
                    field: 'updateTime', title: '更新时间', width: 170
                }, {
                    fixed: 'right', field: 'operate', title: '操作',
                    toolbar: '#js-inventory-toolbar-right', unresize: true, width: 130
                }]
            ]
        });

        $(function () { form.render(); });

        // 搜索
        form.on('submit(js-search-filter)', function (data) {
            inventoryTableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // 头工具栏：入库
        table.on('toolbar(inventory-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '入库',
                    area: ['720px', '520px'],
                    content: contextPath + '/basedata/inventory/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            inventoryTableIns.reload();
                        }
                    }
                });
            }
        });

        // 行工具：编辑/出库(删除)
        table.on('tool(inventory-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑库存',
                    area: ['720px', '520px'],
                    spWhere: {id: data.id},
                    content: contextPath + '/basedata/inventory/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            inventoryTableIns.reload();
                        }
                    }
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要出库（删除）该库存记录吗？', function (index) {
                    $.post(contextPath + '/basedata/inventory/delete', {id: data.id}, function (res) {
                        if (res.code === 0) {
                            layer.msg('出库成功');
                            inventoryTableIns.reload();
                        } else {
                            layer.msg(res.msg || '出库失败');
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
