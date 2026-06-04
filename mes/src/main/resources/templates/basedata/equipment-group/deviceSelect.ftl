<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生产设备选择</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">生产设备编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="equipmentCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">设备名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="equipmentNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                        <i class="layui-icon layui-icon-search"></i>查询
                    </a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-device-select-table" lay-filter="js-device-select-filter"></table>

        <!-- spLayer「确定」会触发此隐藏按钮 -->
        <form class="layui-form layui-hide">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'table', 'layer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            spTable = layui.spTable;

        var TABLE_ID = 'device-select-table';

        var tableIns = spTable.render({
            id: TABLE_ID,
            elem: '#js-device-select-table',
            url: '${request.contextPath}/basedata/equipment-group/device-select/page',
            height: 480,
            cols: [[
                {type: 'checkbox'},
                {field: 'equipmentCode', title: '生产设备编号', width: 200},
                {field: 'processNames', title: '生产工艺', width: 220,
                    templet: function (d) { return d.processNames || ''; }},
                {field: 'status', title: '状态', width: 120,
                    templet: function (d) {
                        return d.status === '1' ? '<span style="color:green;">正常</span>' : '<span style="color:red;">停用</span>';
                    }}
            ]]
        });

        // 搜索
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // spLayer 点「确定」时触发，收集勾选设备 equipmentId 回传父页面
        form.on('submit(js-submit-filter)', function () {
            var checked = table.checkStatus(TABLE_ID);
            var equipmentIds = [];
            (checked.data || []).forEach(function (row) {
                if (row.equipmentId) {
                    equipmentIds.push(row.equipmentId);
                }
            });
            window.spChildFrameResult = {
                code: 0,
                msg: '操作成功',
                data: equipmentIds
            };
            return false;
        });
    });
</script>
</body>
</html>
