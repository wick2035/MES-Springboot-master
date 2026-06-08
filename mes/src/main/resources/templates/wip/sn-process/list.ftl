<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SN通用过程采集</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sn-workbench {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 14px;
        }
        .sn-panel {
            border: 1px solid #e6e6e6;
            padding: 14px;
            background: #fff;
        }
        .sn-panel-title {
            font-weight: 600;
            margin-bottom: 12px;
        }
        .sn-records {
            margin-top: 14px;
        }
        @media (max-width: 900px) {
            .sn-workbench {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="sn-workbench">
            <div class="sn-panel">
                <div class="sn-panel-title">过站采集</div>
                <form id="js-scan-form" class="layui-form" lay-filter="js-scan-form-filter">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工单</label>
                        <div class="layui-input-block">
                            <select id="js-order-id" name="orderId" lay-verify="required" lay-filter="js-order-filter">
                                <option value="">请选择工单</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">SN</label>
                        <div class="layui-input-block">
                            <input id="js-sn" type="text" name="sn" lay-verify="required" autocomplete="off"
                                   class="layui-input" placeholder="扫描或输入 SN">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">结果</label>
                        <div class="layui-input-block">
                            <input type="radio" name="status" value="OK" title="OK" checked>
                            <input type="radio" name="status" value="NG" title="NG">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注</label>
                        <div class="layui-input-block">
                            <textarea name="remark" class="layui-textarea" placeholder="异常原因或补充说明"></textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" lay-submit lay-filter="js-scan-submit">采集</button>
                            <button type="button" class="layui-btn layui-btn-primary" id="js-refresh-route">刷新路线</button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="sn-panel">
                <div class="sn-panel-title">当前工艺路线</div>
                <table class="layui-hide" id="js-route-table" lay-filter="js-route-table-filter"></table>
            </div>
        </div>

        <div class="sn-panel sn-records">
            <div class="sn-panel-title">采集记录</div>
            <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">SN</label>
                        <div class="layui-input-inline">
                            <input type="text" name="snLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">工单号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderCodeLike" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">结果</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                <option value="">全部</option>
                                <option value="OK">OK</option>
                                <option value="NG">NG</option>
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
        </div>
    </div>
</div>
<script>
    layui.use(['form', 'table', 'layer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            spTable = layui.spTable;

        var routeTable = table.render({
            elem: '#js-route-table',
            id: 'js-route-table',
            data: [],
            page: false,
            height: 310,
            cols: [[
                {field: 'stepNo', title: '序号', width: 80},
                {field: 'oper', title: '工序编码', width: 140},
                {field: 'operDesc', title: '工序名称', minWidth: 180},
                {field: 'done', title: '状态', width: 100, templet: function (d) {
                    return d.done ? '<span style="color:#16a34a;">已OK</span>' : '<span style="color:#d97706;">待采集</span>';
                }}
            ]]
        });

        var recordTable = spTable.render({
            elem: '#js-record-table',
            toolbar: '',
            url: '${request.contextPath}/wip/sn-process/records',
            cols: [[
                {field: 'sn', title: 'SN', width: 170},
                {field: 'orderCode', title: '工单编号', width: 150},
                {field: 'oper', title: '工序编码', width: 120},
                {field: 'operDesc', title: '工序名称', minWidth: 170},
                {field: 'stepNo', title: '序号', width: 80},
                {field: 'status', title: '结果', width: 90},
                {field: 'remark', title: '备注', minWidth: 160},
                {field: 'createTime', title: '采集时间', width: 180}
            ]]
        });

        function loadOrders() {
            spUtil.ajax({
                url: '${request.contextPath}/wip/sn-process/orders',
                type: 'GET',
                success: function (res) {
                    var html = '<option value="">请选择工单</option>';
                    $.each(res.data || [], function (_, order) {
                        html += '<option value="' + order.id + '">' + order.orderCode + ' ' + (order.materielDesc || '') + '</option>';
                    });
                    $('#js-order-id').html(html);
                    form.render('select');
                }
            });
        }

        function reloadRoute() {
            var scan = form.val('js-scan-form-filter') || {};
            if (!scan.orderId) {
                routeTable.reload({data: []});
                return;
            }
            spUtil.ajax({
                url: '${request.contextPath}/wip/sn-process/route',
                type: 'GET',
                data: {orderId: scan.orderId, sn: scan.sn},
                success: function (res) {
                    routeTable.reload({data: res.data || []});
                }
            });
        }

        form.on('select(js-order-filter)', function () {
            reloadRoute();
        });

        $('#js-sn').on('blur', function () {
            reloadRoute();
        });

        $('#js-refresh-route').on('click', function () {
            reloadRoute();
        });

        form.on('submit(js-scan-submit)', function (data) {
            spUtil.ajax({
                url: '${request.contextPath}/wip/sn-process/scan',
                type: 'POST',
                serializable: false,
                data: data.field,
                success: function (res) {
                    layer.msg(res.msg || '采集成功', {icon: 1});
                    reloadRoute();
                    recordTable.reload({page: {curr: 1}});
                }
            });
            return false;
        });

        form.on('submit(js-search-filter)', function (data) {
            recordTable.reload({
                where: data.field,
                page: {curr: 1}
            });
            return false;
        });

        loadOrders();
        form.render();
    });
</script>
</body>
</html>
