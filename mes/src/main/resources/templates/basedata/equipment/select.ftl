<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备选择</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">设备编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="equipmentCodeLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">设备名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="equipmentNameLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i></a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        <div style="text-align: center; margin-top: 10px;">
            <button class="layui-btn" id="js-confirm-btn">确认选择</button>
        </div>
    </div>
</div>
<script>
    layui.use(['form', 'table', 'spTable'], function () {
        var form = layui.form, table = layui.table, spTable = layui.spTable;
        var tableIns = spTable.render({
            id: 'equipment-select-table',
            url: '${request.contextPath}/basedata/equipment/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'equipmentCode', title: '设备编号', width: 130},
                {field: 'equipmentName', title: '设备名称'},
                {field: 'equipmentModel', title: '设备规格/型号'},
                {field: 'purpose', title: '设备用途'}
            ]]
        });
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        $('#js-confirm-btn').on('click', function () {
            var checked = table.checkStatus('equipment-select-table');
            if (checked.data.length === 0) {
                layer.msg('请至少选择一个设备');
                return;
            }
            var index = parent.layer.getFrameIndex(window.name);
            if (parent.__equipmentSelectCallback) {
                parent.__equipmentSelectCallback(checked.data);
            }
            parent.layer.close(index);
        });
    });
</script>
</body>
</html>
