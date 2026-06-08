<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选择子BOM</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .bom-select-tip {
            margin-bottom: 10px;
            padding: 8px 12px;
            border: 1px solid #E2E8F0;
            background: #F8FAFC;
            color: #475569;
            line-height: 1.7;
            border-radius: 3px;
        }
        .bom-select-tip strong { color: #D97706; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="bom-select-tip">
            只显示与当前子项匹配的已定版子BOM：
            <strong>层级匹配</strong>、<strong>节点编号一致</strong>、<strong>已定版</strong>、<strong>有效且正常</strong>。
            若这里无数据，请先为该零部件建立对应的半成品/组件BOM，并完成定版。
        </div>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>

        <form class="layui-form splayui-form">
            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input id="js-id" name="id" value=""/>
                    <button id="js-submit" type="button" class="layui-btn" lay-submit
                            lay-filter="js-submit-filter">确定
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'table'], function () {
        var form = layui.form,
            table = layui.table;

        var itemMatType = '${((itemMatType)!'')?js_string}';
        var itemCode = '${((itemCode)!'')?js_string}';

        var levelLabels = { '0': '产品BOM', '1': '半成品BOM', '2': '组件BOM' };

        table.render({
            elem: '#js-record-table',
            url: '${request.contextPath}/technology/bom/selectable-boms',
            method: 'GET',
            where: { itemMatType: itemMatType, itemCode: itemCode },
            parseData: function (res) {
                return {
                    code: res.code,
                    msg: res.msg,
                    count: (res.data && res.data.length) ? res.data.length : 0,
                    data: res.data || []
                };
            },
            cols: [[
                { type: 'radio' },
                { field: 'bomCode',       title: 'BOM编码',  width: 150 },
                { field: 'materielCode',  title: '节点编号', width: 150 },
                { field: 'materielDesc',  title: '物料名称', minWidth: 180 },
                { field: 'versionNumber', title: '版本号',   width: 80  },
                { field: 'bomLevel',      title: '层级',     width: 100,
                  templet: function (d) {
                      return levelLabels[String(d.bomLevel)] || '-';
                  }}
            ]]
        });

        form.on('submit(js-submit-filter)', function () {
            window.spChildFrameResult = {
                msg: '操作成功',
                code: 0,
                data: table.checkStatus('js-record-table').data,
                isAll: table.checkStatus('js-record-table').isAll
            };
            return false;
        });

        table.on('rowDouble(js-record-table-filter)', function (obj) {
            obj.tr.find('i[class="layui-anim layui-icon"]').trigger('click');
            parent.layui.$('.layui-layer-btn0').click();
        });
    });
</script>
</body>
</html>
