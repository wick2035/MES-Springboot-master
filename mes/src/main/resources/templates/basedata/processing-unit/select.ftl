<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>加工单元选择</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">单元编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="unitCodeLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">单元名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="unitNameLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i></a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        <div style="text-align:center; margin-top:10px;">
            <button class="layui-btn" id="js-confirm-btn">确认选择</button>
        </div>
    </div>
</div>
<script>
    layui.use(['form', 'table', 'spTable'], function () {
        var form = layui.form, table = layui.table, spTable = layui.spTable;
        var tableIns = spTable.render({
            id: 'unit-select-table',
            url: '${request.contextPath}/basedata/processing-unit/page',
            cols: [[
                {type: 'radio'},
                {field: 'unitCode', title: '单元编号', width: 130},
                {field: 'unitName', title: '单元名称'},
                {
                    field: 'unitType', title: '单元类型', width: 130, templet: function (d) {
                        return d.unitType === 'device' ? '设备作业单元' : '人员作业单元';
                    }
                },
                {field: 'description', title: '描述'}
            ]]
        });
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        $('#js-confirm-btn').on('click', function () {
            var checked = table.checkStatus('unit-select-table');
            if (checked.data.length === 0) { layer.msg('请选择一个加工单元'); return; }
            var row = checked.data[0];
            var index = parent.layer.getFrameIndex(window.name);
            if (parent.__unitSelectCallback) {
                parent.__unitSelectCallback(row);
            }
            parent.layer.close(index);
        });
    });
</script>
</body>
</html>
