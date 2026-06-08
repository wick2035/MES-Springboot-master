<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选择零部件</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div style="padding:6px 0 10px 0; color:#666;">
            <#if (productName!'') != ''>
                产品名称：<strong>${(productName)!''}</strong>
            <#else>
                选择启用的零部件定义
            </#if>
            <#if (componentType!'') == 'PG'>
                <span style="margin-left:12px;color:#D97706;">当前仅显示：半成品</span>
            <#elseif (componentType!'') == 'COMP'>
                <span style="margin-left:12px;color:#D97706;">当前仅显示：组件</span>
            </#if>
        </div>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>

        <form class="layui-form splayui-form">
            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
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

        var productName = '${((productName)!'')?js_string}';
        var componentType = '${((componentType)!'')?js_string}';
        var typeLabels = { PG: '半成品', COMP: '组件', '半成品': '半成品', '组件': '组件' };

        table.render({
            elem: '#js-record-table',
            url: '${request.contextPath}/technology/component/selectable',
            method: 'GET',
            where: { productName: productName, componentType: componentType },
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
                { field: 'componentCode', title: '零部件编号', width: 140 },
                { field: 'productName', title: '所属产品名称', width: 160 },
                { field: 'componentName', title: '零部件名称', width: 190 },
                { field: 'componentType', title: '类型', width: 90,
                    templet: function (d) { return typeLabels[d.componentType] || '-'; } },
                { field: 'remark', title: '备注' }
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
