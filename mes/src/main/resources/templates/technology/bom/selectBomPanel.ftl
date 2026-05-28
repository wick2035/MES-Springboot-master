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
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
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

        var itemMatType = '${(itemMatType)!''}';

        var levelLabels = { '0': '成品BOM', '1': '半成品BOM', '2': '组件BOM' };

        table.render({
            elem: '#js-record-table',
            url: '${request.contextPath}/technology/bom/selectable-boms',
            method: 'GET',
            where: { itemMatType: itemMatType },
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
                { field: 'bomCode',       title: 'BOM编码',  width: 130 },
                { field: 'materielDesc',  title: '物料名称', width: 180 },
                { field: 'versionNumber', title: '版本号',   width: 70  },
                { field: 'bomLevel',      title: '层级',     width: 80,
                  templet: function (d) {
                      return levelLabels[String(d.bomLevel)] || '-';
                  }}
            ]],
            done: function () {}
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
