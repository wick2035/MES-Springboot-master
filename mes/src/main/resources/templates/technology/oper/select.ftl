<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工序选择</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">工序编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">工序名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operDescLike" class="layui-input">
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
            id: 'oper-select-table',
            url: '${request.contextPath}/technology/oper/page',
            cols: [[
                {type: 'radio'},
                {field: 'oper', title: '工序编号', width: 130},
                {field: 'operDesc', title: '工序名称'},
                {field: 'unitName', title: '加工单元名称'},
                {field: 'operHours', title: '工序工时(h)', width: 110},
                {field: 'manuCycle', title: '制造周期(h)', width: 110}
            ]]
        });
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        $('#js-confirm-btn').on('click', function () {
            var checked = table.checkStatus('oper-select-table');
            if (checked.data.length === 0) { layer.msg('请选择一个工序'); return; }
            var row = checked.data[0];
            var index = parent.layer.getFrameIndex(window.name);
            if (parent.__operSelectCallback) {
                parent.__operSelectCallback(row);
            }
            parent.layer.close(index);
        });
    });
</script>
</body>
</html>
