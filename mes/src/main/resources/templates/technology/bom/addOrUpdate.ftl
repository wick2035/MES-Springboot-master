<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>维护BOM信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .bom-items-wrap { margin-top: 20px; }
        .bom-items-title { font-weight: bold; font-size: 13px; margin-bottom: 8px; display: flex; align-items: center; }
        .bom-items-table { width: 100%; border-collapse: collapse; font-size: 12px; }
        .bom-items-table th, .bom-items-table td { border: 1px solid #e2e2e2; padding: 4px 6px; vertical-align: middle; }
        .bom-items-table th { background: #f2f2f2; text-align: center; white-space: nowrap; }
        .bom-items-table input.layui-input { height: 28px; font-size: 12px; padding: 0 4px; }
        .bom-items-table select { height: 28px; font-size: 12px; border: 1px solid #d2d2d2; border-radius: 2px; width: 100%; }
        .bom-badge { display: inline-block; padding: 1px 6px; border-radius: 3px; font-size: 11px; color: #fff; }
        .badge-FG   { background: #FF7200; }
        .badge-PG   { background: #1E9FFF; }
        .badge-COMP { background: #16BAAA; }
        .badge-PART { background: #9E9E9E; }
        .bom-items-table .btn-xs { padding: 0 6px; height: 24px; line-height: 24px; font-size: 11px; }
        .pick-btn { padding: 0 6px; height: 26px; line-height: 26px; font-size: 11px; margin-right: 2px; }
        .item-cell-flex { display: flex; align-items: center; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main" style="padding: 10px 16px;">
        <form class="layui-form" id="js-bom-form">
            <!-- ===== BOM头信息 ===== -->
            <div style="display:flex; flex-wrap:wrap; gap:10px 30px;">
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:80px;">BOM编码</label>
                    <div class="layui-input-inline" style="width:160px;">
                        <input type="text" name="bomCode" lay-verify="required" autocomplete="off"
                               class="layui-input" value="${(result.bomCode)!''}">
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:80px;">BOM层级</label>
                    <div class="layui-input-inline" style="width:120px;">
                        <select name="bomLevel" id="js-bomLevel" lay-verify="required">
                            <option value="0" <#if (result.bomLevel)?? && result.bomLevel == 0>selected</#if>>0 - 成品BOM</option>
                            <option value="1" <#if (result.bomLevel)?? && result.bomLevel == 1>selected</#if>>1 - 半成品BOM</option>
                            <option value="2" <#if (result.bomLevel)?? && result.bomLevel == 2>selected</#if>>2 - 组件BOM</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:80px;">物料编码</label>
                    <div style="display:flex; align-items:center;">
                        <button type="button" id="js-pick-mat-btn" class="layui-btn pick-btn">
                            <i class="layui-icon layui-icon-search"></i>
                        </button>
                        <input id="js-materiel-code" name="materielCode" readonly lay-verify="required"
                               placeholder="搜索物料" autocomplete="off"
                               value="${(result.materielCode)!''}"
                               class="layui-input" style="width:130px;">
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label" style="width:80px;">物料名称</label>
                    <div class="layui-input-inline" style="width:160px;">
                        <input id="js-materiel-name" readonly name="materielDesc" autocomplete="off"
                               class="layui-input" value="${(result.materielDesc)!''}">
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:80px;">版本号</label>
                    <div style="display:flex; align-items:center;">
                        <input type="text" id="js-versionNumber" readonly name="versionNumber"
                               lay-verify="required" autocomplete="off" class="layui-input"
                               style="width:90px;"
                               value="${(result.versionNumber)!'1'}">
                        <div style="display:flex; flex-direction:column; margin-left:2px;">
                            <button onclick="FN('plus')" type="button" style="height:18px; padding:0 6px;"
                                    class="layui-btn layui-btn-xs">
                                <i class="layui-icon layui-icon-up"></i>
                            </button>
                            <button onclick="FN('minus')" type="button" style="height:18px; padding:0 6px;"
                                    class="layui-btn layui-btn-xs">
                                <i class="layui-icon layui-icon-down"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label" style="width:80px;">状态</label>
                    <div style="display:flex; align-items:center; padding-top:4px;">
                        <input type="radio" name="deleted" value="0" title="正常"
                               <#if !(result??) || result.deleted == "0">checked</#if>>
                        <input type="radio" name="deleted" value="1" title="已删除"
                               <#if (result??  && result.deleted == "1")>checked</#if>>
                        <input type="radio" name="deleted" value="2" title="已禁用"
                               <#if (result?? && result.deleted == "2")>checked</#if>>
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label" style="width:80px;">备注说明</label>
                    <div class="layui-input-inline" style="width:260px;">
                        <textarea name="remark" placeholder="BOM备注" class="layui-textarea"
                                  style="height:50px; resize:vertical;">${(result.remark)!''}</textarea>
                    </div>
                </div>
            </div>

            <!-- 隐藏字段 -->
            <div class="layui-form-item layui-hide">
                <input id="js-id" name="id" value="${(result.id)!''}"/>
                <input id="js-lock-status" value="${(result.lockStatus)!'draft'}"/>
                <input id="js-items-json" name="itemsJson" value="[]"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
            </div>
        </form>

        <!-- 已定版提示 -->
        <#if (result??) && (result.lockStatus)?? && result.lockStatus == 'locked'>
        <div style="margin-top:12px; padding:10px 16px; background:#fff3e0; border:1px solid #FF7200; border-radius:4px; color:#FF7200; font-size:13px;">
            <i class="layui-icon layui-icon-about"></i>
            该BOM已定版，处于只读状态，无法修改。如需更新请创建新版本BOM。
        </div>
        </#if>

        <!-- ===== BOM子项明细 ===== -->
        <div class="bom-items-wrap">
            <div class="bom-items-title">
                BOM子项明细
                <button type="button" id="js-add-item-row" class="layui-btn layui-btn-sm layui-btn-normal"
                        style="margin-left:12px; height:26px; line-height:26px; padding:0 10px; font-size:12px;">
                    + 添加行
                </button>
            </div>
            <div style="overflow-x:auto;">
                <table class="bom-items-table" id="js-items-table">
                    <thead>
                    <tr>
                        <th style="width:50px;">行号</th>
                        <th style="width:145px;">物料编码</th>
                        <th style="width:160px;">物料名称</th>
                        <th style="width:70px;">类型</th>
                        <th style="width:70px;">用量</th>
                        <th style="width:55px;">单位</th>
                        <th style="width:110px;">工序</th>
                        <th style="width:175px;">关联子BOM</th>
                        <th style="width:45px;">操作</th>
                    </tr>
                    </thead>
                    <tbody id="js-items-tbody"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    layui.use(['form', 'layer', 'spLayer'], function () {
        var form = layui.form,
            layer = layui.layer,
            spLayer = layui.spLayer;

        var MAT_TYPE_LABELS = { FG: '成品', PG: '半成品', COMP: '组件', PART: '零件' };

        // 当前编辑的行索引（用于物料/BOM选择回调定位）
        var currentRowIndex = -1;

        // ===== 行模板 =====
        function buildItemRow(item, index) {
            var matType = item.itemMatType || '';
            var label = MAT_TYPE_LABELS[matType] || '-';
            var badgeCls = 'badge-' + (matType || 'PART');
            var canPickBom = (matType === 'PG' || matType === 'COMP');
            var childBomCode = item.childBomCode || '';
            var childBomId   = item.childBomId   || '';
            return '<tr data-index="' + index + '">' +
                '<td><input class="layui-input item-lineNo" value="' + (item.lineNo || '') + '" style="width:44px;"/></td>' +
                '<td>' +
                '  <div class="item-cell-flex">' +
                '    <button type="button" class="layui-btn layui-btn-xs pick-btn btn-pick-mat" data-index="' + index + '">选</button>' +
                '    <input class="layui-input item-matCode" readonly value="' + (item.materielItemCode || '') + '" style="width:90px;"/>' +
                '  </div>' +
                '</td>' +
                '<td><input class="layui-input item-matDesc" readonly value="' + (item.materielItemDesc || '') + '" style="min-width:120px;"/></td>' +
                '<td style="text-align:center;">' +
                '  <span class="bom-badge ' + badgeCls + ' item-matTypeBadge">' + label + '</span>' +
                '  <input type="hidden" class="item-matType" value="' + matType + '"/>' +
                '</td>' +
                '<td><input type="number" class="layui-input item-num" min="0" value="' + (item.itemNum || '') + '" style="width:65px;"/></td>' +
                '<td><input class="layui-input item-unit" value="' + (item.itemUnit || '') + '" style="width:50px;"/></td>' +
                '<td><input class="layui-input item-oper" value="' + (item.operTyper || '') + '" style="width:106px;"/></td>' +
                '<td>' +
                '  <div class="item-cell-flex">' +
                '    <button type="button" class="layui-btn layui-btn-xs pick-btn btn-pick-bom" data-index="' + index + '"' +
                       (canPickBom ? '' : ' disabled') + '>选BOM</button>' +
                '    <input class="layui-input item-childBomCode" readonly value="' + childBomCode + '" style="width:100px;" title="' + childBomCode + '"/>' +
                '    <input type="hidden" class="item-childBomId" value="' + childBomId + '"/>' +
                '  </div>' +
                '</td>' +
                '<td style="text-align:center;">' +
                '  <button type="button" class="layui-btn layui-btn-danger btn-xs btn-del-row">删</button>' +
                '</td>' +
                '</tr>';
        }

        var rowCounter = 0;

        // ===== 添加空行 =====
        $('#js-add-item-row').on('click', function () {
            var tbody = $('#js-items-tbody');
            var rowCount = tbody.find('tr').length;
            var newIndex = rowCounter++;
            tbody.append(buildItemRow({ lineNo: String(rowCount + 1) }, newIndex));
            form.render();
        });

        // ===== 删除行 =====
        $(document).on('click', '.btn-del-row', function () {
            $(this).closest('tr').remove();
        });

        // ===== 选物料（每行独立） =====
        $(document).on('click', '.btn-pick-mat', function () {
            currentRowIndex = $(this).data('index');
            var $row = $(this).closest('tr');
            spLayer.open({
                type: 2,
                area: ['680px', '500px'],
                reload: false,
                content: '${request.contextPath}/admin/common/ui/searchPanelMaterile',
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        var mat = result.data[0];
                        var matType = mat.matType || '';
                        $row.find('.item-matCode').val(mat.materiel || '');
                        $row.find('.item-matDesc').val(mat.materielDesc || '');
                        $row.find('.item-unit').val(mat.unit || '');
                        $row.find('.item-matType').val(matType);

                        var label = MAT_TYPE_LABELS[matType] || '-';
                        var badge = $row.find('.item-matTypeBadge');
                        badge.attr('class', 'bom-badge badge-' + (matType || 'PART') + ' item-matTypeBadge');
                        badge.text(label);

                        // 控制"选BOM"按钮
                        var canPickBom = (matType === 'PG' || matType === 'COMP');
                        var bomBtn = $row.find('.btn-pick-bom');
                        bomBtn.prop('disabled', !canPickBom);

                        // 若类型变为不可选BOM，清空已选子BOM
                        if (!canPickBom) {
                            $row.find('.item-childBomId').val('');
                            $row.find('.item-childBomCode').val('');
                        }
                    }
                }
            });
        });

        // ===== 选子BOM =====
        $(document).on('click', '.btn-pick-bom', function () {
            if ($(this).prop('disabled')) return;
            var $row = $(this).closest('tr');
            var matType = $row.find('.item-matType').val();
            spLayer.open({
                type: 2,
                area: ['680px', '480px'],
                reload: false,
                content: '${request.contextPath}/technology/bom/select-bom-panel-ui?itemMatType=' + encodeURIComponent(matType),
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        var bom = result.data[0];
                        $row.find('.item-childBomId').val(bom.id || '');
                        $row.find('.item-childBomCode').val((bom.bomCode || '') + ' ' + (bom.materielDesc || ''));
                        $row.find('.item-childBomCode').attr('title', (bom.bomCode || '') + ' ' + (bom.materielDesc || ''));
                    }
                }
            });
        });

        // ===== 序列化子项 =====
        function serializeItems() {
            var items = [];
            $('#js-items-tbody tr').each(function () {
                var $tr = $(this);
                items.push({
                    lineNo:            $tr.find('.item-lineNo').val(),
                    materielItemCode:  $tr.find('.item-matCode').val(),
                    materielItemDesc:  $tr.find('.item-matDesc').val(),
                    itemMatType:       $tr.find('.item-matType').val(),
                    itemNum:           $tr.find('.item-num').val() || null,
                    itemUnit:          $tr.find('.item-unit').val(),
                    operTyper:         $tr.find('.item-oper').val(),
                    childBomId:        $tr.find('.item-childBomId').val() || null
                });
            });
            $('#js-items-json').val(JSON.stringify(items));
        }

        // ===== 表单提交（定版保护） =====
        form.on('submit(js-submit-filter)', function (data) {
            if ($('#js-lock-status').val() === 'locked') {
                layer.msg('该BOM已定版，无法保存', { icon: 2 });
                return false;
            }
            serializeItems();
            var payload = $.extend({}, data.field);
            spUtil.submitForm({
                url: '${request.contextPath}/technology/bom/save-with-items',
                data: payload
            });
            return false;
        });

        // ===== 物料主数据搜索弹框（BOM头） =====
        $('#js-pick-mat-btn').on('click', function () {
            spLayer.open({
                type: 2,
                area: ['680px', '500px'],
                reload: false,
                content: '${request.contextPath}/admin/common/ui/searchPanelMaterile',
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        $('#js-materiel-code').val(result.data[0].materiel);
                        $('#js-materiel-name').val(result.data[0].materielDesc);
                    }
                }
            });
        });

        // ===== 版本号加减 =====
        window.FN = function (btnType) {
            var vn = $('#js-versionNumber');
            if (btnType === 'plus') {
                vn.val(parseInt(vn.val() || '0') + 1);
            } else {
                var v = parseInt(vn.val() || '1') - 1;
                if (v < 1) {
                    layer.alert('版本号最小为1', { icon: 2 });
                    v = 1;
                }
                vn.val(v);
            }
        };

        // ===== 编辑时加载已有子项 =====
        var editId = '${(result.id)!''}';
        if (editId) {
            spUtil.ajax({
                url: '${request.contextPath}/technology/sp-bom-item/list-by-bom',
                type: 'GET',
                data: { bomHeadId: editId },
                showLoading: false,
                success: function (res) {
                    if (res.code === 0 && res.data && res.data.length > 0) {
                        var tbody = $('#js-items-tbody');
                        $.each(res.data, function (i, item) {
                            tbody.append(buildItemRow(item, rowCounter++));
                        });
                        form.render();
                    }
                }
            });
        }

        form.render();
    });
</script>
</body>
</html>
