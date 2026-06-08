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

        <!-- 方式一：layer.open 直接使用（如工序内容向导），点此按钮回传 parent.__materileSelectCallback -->
        <div style="text-align:center; margin-top:10px;">
            <button type="button" class="layui-btn" id="js-confirm-btn">确认选择</button>
        </div>

        <!-- 方式二：spLayer.open 使用（如库存入库），spLayer「确定」触发隐藏的 #js-submit，结果走 window.spChildFrameResult -->
        <form class="layui-form layui-hide">
            <button id="js-submit" type="button" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'table', 'layer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer, spTable = layui.spTable;
        var tableIns = spTable.render({
            toolbar: '',
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

        // 方式一：layer.open 场景 —— 内置「确认选择」按钮回传父页面回调
        $('#js-confirm-btn').on('click', function () {
            var checked = table.checkStatus('js-record-table').data;
            if (!checked || checked.length === 0) { layer.msg('请至少选择一个物料'); return; }
            var index = parent.layer.getFrameIndex(window.name);
            if (parent.__materileSelectCallback) parent.__materileSelectCallback(checked);
            parent.layer.close(index);
        });

        // 方式二：spLayer.open 场景 —— spLayer「确定」触发，结果回传 window.spChildFrameResult
        form.on('submit(js-submit-filter)', function () {
            var checked = table.checkStatus('js-record-table').data;
            if (!checked || checked.length === 0) {
                layer.msg('请选择物料');
                window.spChildFrameResult = {code: -1, msg: '请选择物料', data: []};
                return false;
            }
            window.spChildFrameResult = {code: 0, msg: '操作成功', data: checked};
            return false;
        });
    });
</script>
</body>
</html>
