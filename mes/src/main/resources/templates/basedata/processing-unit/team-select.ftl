<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>班组选择</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sp-tip { color: #999; font-size: 12px; padding: 4px 6px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">班组代码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="teamCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">班组名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="teamNameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                        <i class="layui-icon layui-icon-search"></i>查询</a>
                </div>
            </div>
        </form>
        <div class="sp-tip">勾选要绑定到加工单元的班组（可多选；已绑定的班组会自动去重）</div>
        <table class="layui-hide" id="js-team-select-table" lay-filter="js-team-select-filter"></table>

        <!-- spLayer「确定」会触发此隐藏按钮 -->
        <form class="layui-form layui-hide">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'table', 'layer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer, spTable = layui.spTable;
        var contextPath = '${request.contextPath}';
        var TABLE_ID = 'js-team-select-table';

        var tableIns = spTable.render({
            elem: '#js-team-select-table',
            id: TABLE_ID,
            url: contextPath + '/basedata/team/page',
            toolbar: false,
            height: 380,
            cols: [[
                {type: 'checkbox', width: 50},
                {field: 'teamCode', title: '班组代码', width: 180},
                {field: 'teamName', title: '班组名称', width: 220},
                {
                    field: 'teamDesc', title: '班组描述', templet: function (d) {
                        return d.teamDesc || '';
                    }
                }
            ]]
        });

        $(function () { form.render(); });

        // 只查询正常状态班组
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // spLayer 点「确定」时触发，收集勾选班组 id 回传父页面
        form.on('submit(js-submit-filter)', function () {
            var checked = table.checkStatus(TABLE_ID).data || [];
            var teamIds = [];
            checked.forEach(function (row) {
                if (row.id && teamIds.indexOf(row.id) < 0) teamIds.push(row.id);
            });
            window.spChildFrameResult = {
                code: 0,
                msg: '操作成功',
                data: teamIds
            };
            return false;
        });
    });
</script>
</body>
</html>
