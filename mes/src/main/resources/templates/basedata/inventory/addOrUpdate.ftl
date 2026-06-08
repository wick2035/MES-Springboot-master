<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存入库</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
                <legend style="font-size:14px;">入库信息</legend>
            </fieldset>

            <div class="layui-form-item">
                <label class="layui-form-label sp-required">库房</label>
                <div class="layui-input-inline" style="width: 320px;">
                    <select name="warehouseId" id="js-warehouse" lay-verify="required" lay-filter="js-warehouse-filter">
                        <option value="">请选择库房</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label sp-required">库位</label>
                <div class="layui-input-inline" style="width: 320px;">
                    <select name="locationId" id="js-location" lay-verify="required">
                        <option value="">请先选择库房</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label sp-required">物料</label>
                <div class="layui-input-inline" style="width: 220px;">
                    <input type="text" id="js-materiel-show" readonly autocomplete="off" class="layui-input"
                           placeholder="请选择物料" value="${(result.materielCode)!''}">
                </div>
                <div class="layui-input-inline" style="width: 90px;">
                    <button type="button" class="layui-btn" id="js-pick-materiel">选择</button>
                </div>
                <input type="hidden" name="materielId" id="js-materielId" value="${(result.materielId)!''}">
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">批号</label>
                <div class="layui-input-inline" style="width: 220px;">
                    <input type="text" name="batchNo" autocomplete="off" class="layui-input"
                           placeholder="可选" value="${(result.batchNo)!''}">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label sp-required">数量</label>
                <div class="layui-input-inline" style="width: 160px;">
                    <input type="number" name="qty" step="0.0001" min="0" lay-verify="required|number"
                           autocomplete="off" class="layui-input" value="${(result.qty)!''}">
                </div>
                <div class="layui-input-inline" style="width: 120px;">
                    <input type="text" id="js-unit-show" readonly autocomplete="off" class="layui-input"
                           placeholder="单位" value="${(result.unit)!''}">
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input id="js-id" name="id" value="${(result.id)!''}"/>
                    <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'layer', 'spLayer'], function () {
        var form = layui.form, layer = layui.layer, spLayer = layui.spLayer;
        var contextPath = '${request.contextPath}';

        var editWarehouseId = '${(result.warehouseId)!''}';
        var editLocationId = '${(result.locationId)!''}';

        // 加载库房下拉
        $.post(contextPath + '/digital/simulation/warehouse-list', {}, function (res) {
            if (res.code === 0 && res.data) {
                var html = '<option value="">请选择库房</option>';
                $.each(res.data, function (i, w) {
                    var sel = (w.id === editWarehouseId) ? ' selected' : '';
                    html += '<option value="' + w.id + '"' + sel + '>' + w.warehouseCode + ' ' + w.warehouseName + '</option>';
                });
                $('#js-warehouse').html(html);
                form.render('select');
                if (editWarehouseId) {
                    loadLocations(editWarehouseId, editLocationId);
                }
            }
        });

        // 加载某库房库位下拉
        function loadLocations(warehouseId, selectedId) {
            $.post(contextPath + '/basedata/warehouse/location/page',
                {warehouseId: warehouseId, current: 1, size: 100000}, function (res) {
                    var html = '<option value="">请选择库位</option>';
                    if (res.code === 0 && res.data && res.data.records) {
                        $.each(res.data.records, function (i, loc) {
                            var sel = (loc.id === selectedId) ? ' selected' : '';
                            var label = loc.locationCode + (loc.status === '2' ? '（禁用）' : '');
                            html += '<option value="' + loc.id + '"' + sel + '>' + label + '</option>';
                        });
                    }
                    $('#js-location').html(html);
                    form.render('select');
                });
        }

        // 库房切换 -> 重载库位
        form.on('select(js-warehouse-filter)', function (data) {
            if (data.value) {
                loadLocations(data.value, '');
            } else {
                $('#js-location').html('<option value="">请先选择库房</option>');
                form.render('select');
            }
        });

        // 打开物料选择弹窗（spLayer「确定」回传 spChildFrameResult）
        $('#js-pick-materiel').on('click', function () {
            spLayer.open({
                type: 2,
                title: '选择物料',
                area: ['800px', '560px'],
                reload: false,
                content: contextPath + '/basedata/materile/select-ui',
                spCallback: function (res) {
                    if (res && res.code === 0 && res.data && res.data.length > 0) {
                        var m = res.data[0];
                        $('#js-materielId').val(m.id);
                        $('#js-materiel-show').val((m.materiel || '') + ' ' + (m.materielDesc || ''));
                        $('#js-unit-show').val(m.unit || '');
                    }
                }
            });
        });

        // 提交
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: contextPath + '/basedata/inventory/add-or-update',
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
