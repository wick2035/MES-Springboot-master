<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺流程管理</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .pr-toolbar { padding: 8px 12px; background: #f8f8f8; border-bottom: 1px solid #e2e2e2; }
        .pr-lock-badge { display: inline-block; padding: 2px 10px; border-radius: 10px; font-size: 12px; color: #fff; }
        .lock-draft { background: #9E9E9E; }
        .lock-locked { background: #FF7200; }
        .gen-yes { color: #16BAAA; font-weight: bold; }
        .layui-table .lock-icon { color: #FF7200; font-size: 16px; cursor: pointer; }
        .layui-table .edit-icon { color: #16BAAA; font-size: 16px; cursor: pointer; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="pr-toolbar">
        <button class="layui-btn layui-btn-sm" id="js-btn-select-bom">
            <i class="layui-icon layui-icon-list"></i> 选择BOM
        </button>
        <span id="js-bom-info" style="margin-left:16px; color:#555;">请先选择已锁定的BOM</span>
        <span id="js-lock-status" style="margin-left:16px;"></span>
        <span style="float:right;">
            <button class="layui-btn layui-btn-sm layui-btn-warm layui-btn-disabled" id="js-btn-init">
                <i class="layui-icon">&#xe609;</i> 初始化工艺流程
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-danger layui-btn-disabled" id="js-btn-lock">
                <i class="layui-icon">&#xe61b;</i> 锁定产品工艺规划
            </button>
        </span>
    </div>

    <div class="splayui-main" style="padding-top:10px;">
        <table id="js-route-table" lay-filter="js-route-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-route-table-toolbar-right">
    {{# if (d.lockStatus !== 'locked') { }}
    <a class="layui-icon edit-icon" lay-event="edit" title="编辑工艺规划">&#xe642;</a>
    {{# } else { }}
    <i class="layui-icon lock-icon" title="已锁定">&#xe673;</i>
    {{# } }}
</script>

<script>
    var currentBomId = '${bomId!''}';
    var currentBomCode = '';
    var currentBomDesc = '';
    var treeTableIns = null;

    window.__bomSelectCallback = function (row) {
        currentBomId = row.id;
        currentBomCode = row.bomCode;
        currentBomDesc = (row.materielCode || '') + ' ' + (row.materielDesc || '');
        $('#js-bom-info').html('<strong>BOM:</strong> ' + currentBomCode + ' (' + currentBomDesc + ')');
        loadTree();
    };

    layui.use(['table', 'treeTable'], function () {
        var table = layui.table, treeTable = layui.treeTable;

        $('#js-btn-select-bom').on('click', function () {
            layer.open({
                type: 2, title: '选择BOM', area: ['80%', '70%'],
                content: '${request.contextPath}/technology/process-route/select-bom-ui'
            });
        });

        $('#js-btn-init').on('click', function () {
            if (!currentBomId) { layer.msg('请先选择BOM'); return; }
            layer.confirm('确认初始化（将覆盖未锁定的旧工艺记录）？', function (idx) {
                spUtil.ajax({
                    url: '${request.contextPath}/technology/process-route/init',
                    type: 'POST', serializable: false, data: {bomId: currentBomId},
                    success: function (data) {
                        layer.close(idx);
                        layer.msg(data.msg || '初始化成功');
                        loadTree();
                    }
                });
            });
        });

        $('#js-btn-lock').on('click', function () {
            if (!currentBomId) { layer.msg('请先选择BOM'); return; }
            layer.confirm('确认要锁定该产品工艺规划吗？<br/>锁定后将无法再对该产品工艺及其工序进行新增、编辑、删除操作。', function (idx) {
                spUtil.ajax({
                    url: '${request.contextPath}/technology/process-route/lock',
                    type: 'POST', serializable: false, data: {bomId: currentBomId},
                    success: function (data) {
                        layer.close(idx);
                        layer.msg(data.msg || '锁定成功');
                        loadTree();
                    }
                });
            });
        });

        function loadTree() {
            if (!currentBomId) return;
            spUtil.ajax({
                url: '${request.contextPath}/technology/process-route/tree',
                type: 'GET', serializable: false, data: {bomId: currentBomId},
                success: function (resp) {
                    var d = resp.data || {};
                    var locked = d.locked;
                    if (locked) {
                        $('#js-lock-status').html('<span class="pr-lock-badge lock-locked">已锁定</span>');
                        $('#js-btn-lock').addClass('layui-btn-disabled').attr('disabled', true);
                    } else {
                        $('#js-lock-status').html('<span class="pr-lock-badge lock-draft">草稿</span>');
                        $('#js-btn-lock').removeClass('layui-btn-disabled').removeAttr('disabled');
                    }
                    $('#js-btn-init').removeClass('layui-btn-disabled').removeAttr('disabled');

                    var rows = d.tree ? [d.tree] : [];
                    renderTable(rows);
                }
            });
        }

        function renderTable(rows) {
            if (treeTableIns) {
                try { layui.treeTable.reload('js-route-table', {data: rows}); return; } catch (e) {}
            }
            treeTableIns = treeTable.render({
                elem: '#js-route-table',
                data: rows,
                tree: {
                    iconIndex: 1,
                    isPidData: false,
                    idName: 'id',
                    childName: 'children',
                    openName: 'open'
                },
                cols: [[
                    {type: 'numbers', width: 50},
                    {field: 'nodeName', title: '工序名称', minWidth: 380},
                    {field: 'operCode', title: '工序编号', width: 110},
                    {field: 'operName', title: '绑定工序', width: 160},
                    {field: 'unitName', title: '加工单元', width: 130},
                    {field: 'unitTypeName', title: '加工单元类型', width: 130},
                    {field: 'operHours', title: '工时(h)', width: 80},
                    {field: 'manuCycle', title: '周期(h)', width: 80},
                    {
                        field: 'genPlan', title: '是否生成生产计划', width: 130, templet: function (d) {
                            return d.genPlan === 'Y' ? '<span class="gen-yes">是</span>' : (d.genPlan === 'N' ? '否' : '');
                        }
                    },
                    {field: 'seqNo', title: '排序号', width: 80},
                    {title: '操作', toolbar: '#js-route-table-toolbar-right', width: 110}
                ]]
            });
        }

        // 行操作
        $(document).on('click', '#js-route-table .edit-icon', function () {
            // treeTable 行事件需要通过 toolbar 触发；为简单起见这里取最近一行的数据
        });

        treeTable.on('tool(js-route-table-filter)', function (obj) {
            if (obj.event === 'edit') {
                var routeId = obj.data.routeId;
                layer.open({
                    type: 2, title: '编辑工艺规划', area: ['80%', '80%'],
                    content: '${request.contextPath}/technology/process-route/edit-ui?routeId=' + routeId,
                    end: function () { loadTree(); }
                });
            }
        });

        if (currentBomId) {
            // 已经带入bomId，直接加载（需要先拿到BOM信息显示）
            loadTree();
        }
    });
</script>
</body>
</html>
