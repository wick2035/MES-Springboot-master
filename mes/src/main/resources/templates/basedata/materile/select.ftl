<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料选择</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">物料编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materielLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materielDescLike" class="layui-input">
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
            id: 'materile-select-table',
            url: '${request.contextPath}/basedata/materile/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'materiel', title: '物料编码', width: 130},
                {field: 'materielDesc', title: '物料名称'},
                {field: 'matType', title: '物料类型', width: 100},
                {field: 'model', title: '规格/型号'},
                {field: 'unit', title: '单位', width: 70}
            ]]
        });
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        $('#js-confirm-btn').on('click', function () {
            var checked = table.checkStatus('materile-select-table');
            if (checked.data.length === 0) { layer.msg('请至少选择一个物料'); return; }
            var index = parent.layer.getFrameIndex(window.name);
            if (parent.__materileSelectCallback) parent.__materileSelectCallback(checked.data);
            parent.layer.close(index);
        });
    });
</script>
</body>
</html>
