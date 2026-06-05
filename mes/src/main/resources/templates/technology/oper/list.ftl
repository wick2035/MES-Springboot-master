<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工序信息定义</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div style="margin-bottom: 10px;">
            <h3 style="display:inline-block; margin-right:20px;">工序定义管理</h3>
        </div>
        <form id="js-search-form" class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">工序编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">工序名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="operDescLike" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter">
                        <i class="layui-icon layui-icon-search"></i>查询</a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>新增</button>
    </div>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/technology/oper/page',
            toolbar: '#js-record-table-toolbar-top',
            cols: [[
                {field: 'oper', title: '工序编号', width: 130, style: 'color:#2563EB'},
                {field: 'operDesc', title: '工序名称'},
                {field: 'unitName', title: '加工单元名称'},
                {field: 'operHours', title: '工序工时(h)', width: 110},
                {field: 'manuCycle', title: '制造周期(h)', width: 110},
                {field: 'unitTypeName', title: '加工单元类型', width: 120},
                {
                    field: 'genPlan', title: '是否生成生产计划', width: 140, templet: function (d) {
                        return d.genPlan === 'Y' ? '是' : '否';
                    }
                },
                {field: 'remark', title: '备注信息'},
                {fixed: 'right', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 150}
            ]]
        });
        $(function () { form.render(); });
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });
        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'add') {
                spLayer.open({
                    title: '新增工序', area: ['750px', '600px'],
                    content: '${request.contextPath}/technology/oper/add-or-update-ui'
                });
            }
        });
        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑工序', area: ['750px', '600px'],
                    spWhere: {id: data.id},
                    content: '${request.contextPath}/technology/oper/add-or-update-ui'
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/technology/oper/delete',
                        type: 'POST', serializable: false, data: {id: data.id},
                        success: function () { tableIns.reload(); layer.close(index); }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
