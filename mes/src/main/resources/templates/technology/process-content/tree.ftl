<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺内容编制</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .pc-toolbar { padding: 8px 12px; background: #f8f8f8; border-bottom: 1px solid #e2e2e2; }
        .edit-completed { color: #16BAAA; font-weight: bold; }
        .edit-pending { color: #999; }
        .edit-editing { color: #1E9FFF; }
        .edit-btn { background-color: #2563EB; color: #fff; padding: 4px 12px; border: none; border-radius: 3px; cursor: pointer; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="pc-toolbar">
        <button class="layui-btn layui-btn-sm" id="js-btn-select-bom">
            <i class="layui-icon layui-icon-list"></i> 选择BOM
        </button>
        <span id="js-bom-info" style="margin-left:16px; color:#555;">请先选择BOM</span>
    </div>
    <div class="splayui-main" id="js-route-table-wrap" style="padding-top:10px;">
        <table id="js-route-table" lay-filter="js-route-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-route-toolbar">
    {{# if (d.operId && d.editStatus === 'completed') { }}
    <a class="layui-btn layui-btn-sm layui-btn-normal" lay-event="view">查看详情</a>
    {{# } else if (d.operId) { }}
    <a class="layui-btn layui-btn-sm layui-btn-warm" lay-event="edit">工艺内容编制</a>
    {{# } else { }}
    <span style="color:#999;">未绑定工序</span>
    {{# } }}
</script>

<script>
    var currentBomId = '${bomId!''}';
    var treeTableIns = null;
    var loadTree = function () {};

    window.__bomSelectCallback = function (row) {
        currentBomId = row.id;
        $('#js-bom-info').html('<strong>BOM:</strong> ' + row.bomCode + ' (' + (row.materielCode || '') + ' ' + (row.materielDesc || '') + ')');
        loadTree();
    };

    layui.use(['treeTable'], function () {
        var treeTable = layui.treeTable;

        $('#js-btn-select-bom').on('click', function () {
            layer.open({
                type: 2, title: '选择BOM', area: ['80%', '70%'],
                content: '${request.contextPath}/technology/process-route/select-bom-ui'
            });
        });

        loadTree = function () {
            if (!currentBomId) return;
            spUtil.ajax({
                url: '${request.contextPath}/technology/process-content/route-tree',
                type: 'GET', serializable: false, data: {bomId: currentBomId},
                success: function (resp) {
                    var rows = resp.data ? [resp.data] : [];
                    renderTable(rows);
                }
            });
        };

        function renderTable(rows) {
            $('#js-route-table-wrap').html('<table id="js-route-table"></table>');
            treeTableIns = treeTable.render({
                elem: '#js-route-table',
                data: rows,
                tree: {iconIndex: 1, isPidData: false, idName: 'id', pidName: 'pid', childName: 'children', haveChildName: 'haveChild', openName: 'open'},
                cols: [
                    {type: 'numbers', width: 50},
                    {field: 'nodeName', title: '工序名称', minWidth: 360},
                    {field: 'operCode', title: '工序编号', width: 110},
                    {field: 'operName', title: '绑定工序', width: 160},
                    {field: 'unitName', title: '加工单元', width: 130},
                    {
                        field: 'editStatus', title: '编制状态', width: 100, templet: function (d) {
                            if (d.editStatus === 'completed') return '<span class="edit-completed">已完成锁定 ✓</span>';
                            if (d.editStatus === 'editing') return '<span class="edit-editing">编制中</span>';
                            return '<span class="edit-pending">未编制</span>';
                        }
                    },
                    {title: '操作', toolbar: '#js-route-toolbar', width: 160}
                ]
            });
        }

        treeTable.on('tool(js-route-table)', function (obj) {
            if (obj.event === 'edit') {
                var routeId = obj.data.routeId;
                layer.open({
                    type: 2, title: '工艺内容编制', area: ['95%', '92%'],
                    content: '${request.contextPath}/technology/process-content/wizard-ui?routeId=' + routeId,
                    end: function () { loadTree(); }
                });
            }
            if (obj.event === 'view') {
                layer.open({
                    type: 2, title: '工艺详情', area: ['95%', '92%'],
                    content: '${request.contextPath}/technology/process-query/detail-ui?routeId=' + obj.data.routeId
                });
            }
        });

        if (currentBomId) loadTree();
    });
</script>
</body>
</html>
