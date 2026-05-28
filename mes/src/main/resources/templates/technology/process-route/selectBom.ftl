<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选择BOM</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div style="padding:6px 0 10px 0; color:#999;">只显示已锁定的 BOM</div>
        <table id="js-bom-select-table" lay-filter="js-bom-select-table-filter"></table>
        <div style="text-align:center; margin-top:10px;">
            <button class="layui-btn" id="js-confirm-btn">确认选择</button>
        </div>
    </div>
</div>
<script>
    layui.use(['table'], function () {
        var table = layui.table;
        table.render({
            elem: '#js-bom-select-table',
            url: '${request.contextPath}/technology/process-route/locked-bom-page',
            method: 'get',
            parseData: function (res) {
                return {code: 0, msg: '', count: (res.data || []).length, data: res.data || []};
            },
            cols: [[
                {type: 'radio'},
                {field: 'bomCode', title: 'BOM编码', width: 180},
                {field: 'materielCode', title: '物料编码', width: 130},
                {field: 'materielDesc', title: '物料名称'},
                {field: 'versionNumber', title: '版本', width: 80},
                {
                    field: 'bomLevel', title: '层级', width: 100, templet: function (d) {
                        return d.bomLevel === 0 ? '成品' : (d.bomLevel === 1 ? '半成品' : '组件');
                    }
                }
            ]]
        });
        $('#js-confirm-btn').on('click', function () {
            var checked = table.checkStatus('js-bom-select-table');
            if (checked.data.length === 0) { layer.msg('请选择一个BOM'); return; }
            var row = checked.data[0];
            var index = parent.layer.getFrameIndex(window.name);
            if (parent.__bomSelectCallback) parent.__bomSelectCallback(row);
            parent.layer.close(index);
        });
    });
</script>
</body>
</html>
