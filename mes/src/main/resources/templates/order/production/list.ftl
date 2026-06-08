<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单下达</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <link rel="stylesheet" href="${request.contextPath}/lib/gantt/css/style.css" media="all">
    <style>
        .order-gantt-wrap {
            margin-top: 14px;
            border-top: 1px solid #e6e6e6;
            padding-top: 12px;
        }
        .order-gantt-title {
            height: 30px;
            line-height: 30px;
            font-weight: 600;
            color: #333;
        }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">工单编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="orderCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materielLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="statue">
                            <option value="">全部</option>
                            <option value="1">已创建/待审批</option>
                            <option value="2">已审批</option>
                            <option value="3">已结束</option>
                            <option value="4">已终结</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                        <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                    </a>
                </div>
            </div>
        </form>

        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>

        <div class="order-gantt-wrap">
            <div class="order-gantt-title">工单计划甘特图</div>
            <div id="js-gantt" class="gantt"></div>
        </div>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增工单</button>
    </div>
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    {{# if(${canApprove?c} && d.statue === 1){ }}
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="approve"><i class="layui-icon layui-icon-ok"></i>审批通过</a>
    {{# } }}
    {{# if(d.statue !== 2){ }}
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    {{# } }}
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<script src="${request.contextPath}/lib/gantt/js/jquery.fn.gantt.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table', 'layer', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            spLayer = layui.spLayer,
            spTable = layui.spTable;
        var canApprove = ${canApprove?c};

        function statueText(value) {
            var map = {1: '已创建/待审批', 2: '已审批', 3: '已结束', 4: '已终结'};
            return map[value] || '-';
        }

        var tableIns = spTable.render({
            url: '${request.contextPath}/order/release/page',
            height: 300,
            cols: [[
                {type: 'checkbox'},
                {field: 'orderCode', title: '工单编号', width: 150},
                {field: 'orderDescription', title: '工单描述', minWidth: 160},
                {field: 'materiel', title: '物料编码', width: 140},
                {field: 'materielDesc', title: '物料名称', width: 160},
                {field: 'qty', title: '数量', width: 80},
                {field: 'orderType', title: '类型', width: 80},
                {field: 'designerName', title: '设计人', width: 110},
                {field: 'planStartTime', title: '计划开始', width: 170},
                {field: 'planEndTime', title: '计划结束', width: 170},
                {field: 'statue', title: '状态', width: 95, templet: function (d) { return statueText(d.statue); }},
                {field: 'approveUsername', title: '审批人', width: 110},
                {field: 'approveTime', title: '审批时间', width: 170},
                {fixed: 'right', title: '操作', toolbar: '#js-record-table-toolbar-right', width: canApprove ? 220 : 140}
            ]],
            done: function () {
                reloadGantt();
            }
        });

        function currentFilter() {
            return form.val('js-q-form-filter') || {};
        }

        function reloadGantt() {
            spUtil.ajax({
                url: '${request.contextPath}/order/release/gantt/list',
                type: 'POST',
                serializable: false,
                data: currentFilter(),
                success: function (res) {
                    $('#js-gantt').empty();
                    $('#js-gantt').gantt({
                        source: res.data || [],
                        navigate: 'scroll',
                        scale: 'days',
                        maxScale: 'months',
                        minScale: 'days',
                        waitText: '加载中...',
                        itemsPerPage: 8,
                        tnTitle1: '物料/工单',
                        tnTitle2: '计划',
                        onItemClick: function (dataObj) {
                            if (dataObj && typeof dataObj === 'object' && dataObj.statue === 2) {
                                layer.msg('已审批工单不能编辑');
                                return;
                            }
                            openEdit(dataObj);
                        }
                    });
                }
            });
        }

        function openEdit(id) {
            if (id && typeof id === 'object') {
                if (id.statue === 2) {
                    layer.msg('已审批工单不能编辑');
                    return;
                }
                id = id.id || id.dataObj || '';
            }
            spLayer.open({
                title: id ? '编辑工单' : '新增工单',
                area: ['820px', '620px'],
                spWhere: id ? {id: id} : {},
                content: '${request.contextPath}/order/release/add-or-update-ui'
            });
        }

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({
                where: data.field,
                page: {curr: 1}
            });
            reloadGantt();
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                openEdit();
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                if (data.statue === 2) {
                    layer.msg('已审批工单不能编辑');
                    return;
                }
                openEdit(data.id);
            }
            if (obj.event === 'approve') {
                layer.confirm('确认审批通过该工单吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/order/release/approve',
                        type: 'POST',
                        serializable: false,
                        data: {id: data.id},
                        success: function () {
                            tableIns.reload();
                            reloadGantt();
                            layer.close(index);
                        }
                    });
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认删除该工单吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/order/release/delete',
                        type: 'POST',
                        serializable: false,
                        data: {id: data.id},
                        success: function () {
                            tableIns.reload();
                            reloadGantt();
                            layer.close(index);
                        }
                    });
                });
            }
        });

        form.render();
    });
</script>
</body>
</html>
