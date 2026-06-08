<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>维护产品BOM</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .bom-form-grid { display:flex; flex-wrap:wrap; gap:10px 30px; }
        .bom-items-wrap { margin-top: 20px; }
        .bom-items-title { font-weight: bold; font-size: 13px; margin-bottom: 8px; display: flex; align-items: center; }
        .bom-items-table { width: 100%; border-collapse: collapse; font-size: 12px; }
        .bom-items-table th, .bom-items-table td { border: 1px solid var(--sp-border-color, #e2e2e2); padding: 4px 6px; vertical-align: middle; }
        .bom-items-table th { background: var(--sp-bg-gray, #f2f2f2); text-align: center; white-space: nowrap; }
        .bom-items-table input.layui-input { height: 28px; font-size: 12px; padding: 0 4px; }
        .bom-badge { display: inline-block; padding: 1px 6px; border-radius: 3px; font-size: 11px; color: #fff; }
        .badge-FG, .badge-PRODUCT { background: #D97706; }
        .badge-PG { background: #1E9FFF; }
        .badge-COMP { background: #16BAAA; }
        .badge-PART, .badge-STD, .badge-OTHER { background: #98A2B3; }
        .bom-items-table .btn-xs { padding: 0 6px; height: 24px; line-height: 24px; font-size: 11px; }
        .pick-btn { padding: 0 6px; height: 26px; line-height: 26px; font-size: 11px; margin-right: 2px; }
        .item-cell-flex { display: flex; align-items: center; gap: 2px; }
        .bom-readonly-tip { margin-top:12px; padding:10px 16px; background:#FFFAEB; border:1px solid #D97706; border-radius:4px; color:#D97706; font-size:13px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main" style="padding: 10px 16px;">
        <form class="layui-form" id="js-bom-form">
            <div class="sp-section-title">基本信息</div>
            <div class="bom-form-grid">
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:90px;">BOM编码</label>
                    <div class="layui-input-inline" style="width:160px;">
                        <input type="text" id="js-bom-code" name="bomCode" lay-verify="required" autocomplete="off"
                               class="layui-input" value="${(result.bomCode)!''}">
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:90px;">BOM层级</label>
                    <div class="layui-input-inline" style="width:130px;">
                        <select name="bomLevel" id="js-bomLevel" lay-filter="js-bomLevel-filter" lay-verify="required">
                            <option value="0" <#if !(result??) || !(result.bomLevel??) || result.bomLevel == 0>selected</#if>>0 - 产品BOM</option>
                            <option value="1" <#if (result.bomLevel)?? && result.bomLevel == 1>selected</#if>>1 - 半成品BOM</option>
                            <option value="2" <#if (result.bomLevel)?? && result.bomLevel == 2>selected</#if>>2 - 组件BOM</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:90px;">产品/零部件</label>
                    <div style="display:flex; align-items:center;">
                        <button type="button" id="js-pick-head-btn" class="layui-btn pick-btn">
                            <i class="layui-icon layui-icon-search"></i>
                        </button>
                        <input id="js-materiel-code" name="materielCode" readonly lay-verify="required"
                               placeholder="请选择" autocomplete="off"
                               value="${(result.materielCode)!''}"
                               class="layui-input sp-readonly" style="width:140px;">
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label" style="width:90px;">名称</label>
                    <div class="layui-input-inline" style="width:170px;">
                        <input id="js-materiel-name" readonly name="materielDesc" autocomplete="off"
                               class="layui-input sp-readonly" value="${(result.materielDesc)!''}">
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label sp-required" style="width:90px;">版本号</label>
                    <div style="display:flex; align-items:center;">
                        <input type="text" id="js-versionNumber" readonly name="versionNumber"
                               lay-verify="required" autocomplete="off" class="layui-input sp-readonly"
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
                    <label class="layui-form-label" style="width:90px;">状态</label>
                    <div style="display:flex; align-items:center; padding-top:4px;">
                        <input type="radio" name="deleted" value="0" title="正常"
                               <#if !(result??) || result.deleted == "0">checked</#if>>
                        <input type="radio" name="deleted" value="2" title="禁用"
                               <#if (result?? && result.deleted == "2")>checked</#if>>
                    </div>
                </div>
                <div class="layui-form-item" style="margin-bottom:8px;">
                    <label class="layui-form-label" style="width:90px;">备注说明</label>
                    <div class="layui-input-inline" style="width:300px;">
                        <textarea name="remark" placeholder="BOM备注" class="layui-textarea"
                                  style="height:50px; resize:vertical;">${(result.remark)!''}</textarea>
                    </div>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <input id="js-id" name="id" value="${(result.id)!''}"/>
                <input id="js-lock-status" value="${(result.lockStatus)!'draft'}"/>
                <input id="js-items-json" name="itemsJson" value="[]"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
            </div>
        </form>

        <#if (result??) && (result.lockStatus)?? && result.lockStatus == 'locked'>
        <div class="bom-readonly-tip">
            <i class="layui-icon layui-icon-about"></i>
            该BOM已定版，处于只读状态，无法修改。如需更新请创建新版本BOM。
        </div>
        </#if>

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
                        <th style="width:185px;">节点编号</th>
                        <th style="width:170px;">节点名称</th>
                        <th style="width:70px;">类型</th>
                        <th style="width:70px;">数量</th>
                        <th style="width:55px;">单位</th>
                        <th style="width:110px;">装配工序</th>
                        <th style="width:190px;">关联子BOM</th>
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

        var MAT_TYPE_LABELS = { FG: '成品', PRODUCT: '产品', PG: '半成品', COMP: '组件', PART: '零件', STD: '标准件', OTHER: '其他' };
        var locked = $('#js-lock-status').val() === 'locked';

        function isProductBom() {
            return $('#js-bomLevel').val() === '0';
        }

        function getBomLevelType() {
            var level = $('#js-bomLevel').val();
            if (level === '1') return 'PG';
            if (level === '2') return 'COMP';
            return '';
        }

        function getProductName() {
            return normalizeProductName($('#js-materiel-name').val());
        }

        function normalizeProductName(name) {
            return $.trim(String(name || '').replace(/[?？]+$/g, ''));
        }

        function escapeHtml(text) {
            return String(text || '').replace(/[&<>"']/g, function (c) {
                return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c];
            });
        }

        function setHead(code, name, autoBomCode) {
            $('#js-materiel-code').val(code || '');
            $('#js-materiel-name').val(name || '');
            if (autoBomCode) $('#js-bom-code').val(code || '');
            $('#js-items-tbody').empty();
        }

        function applyItemToRow($row, code, desc, unit, matType) {
            matType = matType || '';
            $row.find('.item-matCode').val(code || '');
            $row.find('.item-matDesc').val(desc || '');
            $row.find('.item-unit').val(unit || '');
            $row.find('.item-matType').val(matType);
            $row.find('.item-childBomId').val('');
            $row.find('.item-childBomCode').val('');

            var label = MAT_TYPE_LABELS[matType] || '-';
            var badge = $row.find('.item-matTypeBadge');
            badge.attr('class', 'bom-badge badge-' + (matType || 'PART') + ' item-matTypeBadge');
            badge.text(label);

            refreshRowButtons($row);
        }

        function refreshRowButtons($row) {
            var matType = $row.find('.item-matType').val();
            var canPickBom = (matType === 'PG' || matType === 'COMP');
            $row.find('.btn-pick-bom').prop('disabled', locked || !canPickBom);
            $row.find('.btn-pick-component').toggle(!isProductBom());
            $row.find('.btn-pick-mat').text(isProductBom() ? '零部件' : '物料');
            if (locked) {
                $row.find('input,button').prop('disabled', true);
            }
        }

        function refreshAllRows() {
            $('#js-items-tbody tr').each(function () { refreshRowButtons($(this)); });
        }

        function buildItemRow(item, index) {
            var matType = item.itemMatType || '';
            var label = MAT_TYPE_LABELS[matType] || '-';
            var badgeCls = 'badge-' + (matType || 'PART');
            var childBomText = item.childBomCode || '';
            return '<tr data-index="' + index + '">' +
                '<td><input class="layui-input item-lineNo" value="' + escapeHtml(item.lineNo || '') + '" style="width:44px;"/></td>' +
                '<td><div class="item-cell-flex">' +
                '<button type="button" class="layui-btn layui-btn-xs pick-btn btn-pick-mat">物料</button>' +
                '<button type="button" class="layui-btn layui-btn-xs layui-btn-normal pick-btn btn-pick-component">零部件</button>' +
                '<input class="layui-input item-matCode" readonly value="' + escapeHtml(item.materielItemCode || '') + '" style="width:90px;"/>' +
                '</div></td>' +
                '<td><input class="layui-input item-matDesc" readonly value="' + escapeHtml(item.materielItemDesc || '') + '" style="min-width:120px;"/></td>' +
                '<td style="text-align:center;"><span class="bom-badge ' + badgeCls + ' item-matTypeBadge">' + label + '</span>' +
                '<input type="hidden" class="item-matType" value="' + escapeHtml(matType) + '"/></td>' +
                '<td><input type="number" class="layui-input item-num" min="0" value="' + escapeHtml(item.itemNum || '1') + '" style="width:65px;"/></td>' +
                '<td><input class="layui-input item-unit" value="' + escapeHtml(item.itemUnit || '') + '" style="width:50px;"/></td>' +
                '<td><input class="layui-input item-oper" value="' + escapeHtml(item.operTyper || '') + '" style="width:106px;"/></td>' +
                '<td><div class="item-cell-flex">' +
                '<button type="button" class="layui-btn layui-btn-xs pick-btn btn-pick-bom">选BOM</button>' +
                '<input class="layui-input item-childBomCode" readonly value="' + escapeHtml(childBomText) + '" style="width:108px;" title="' + escapeHtml(childBomText) + '"/>' +
                '<input type="hidden" class="item-childBomId" value="' + escapeHtml(item.childBomId || '') + '"/>' +
                '</div></td>' +
                '<td style="text-align:center;"><button type="button" class="layui-btn layui-btn-danger btn-xs btn-del-row">删</button></td>' +
                '</tr>';
        }

        var rowCounter = 0;

        $('#js-add-item-row').on('click', function () {
            if (locked) return;
            var tbody = $('#js-items-tbody');
            var rowCount = tbody.find('tr').length;
            var newIndex = rowCounter++;
            tbody.append(buildItemRow({ lineNo: String(rowCount + 1), itemNum: '1' }, newIndex));
            refreshAllRows();
            form.render();
        });

        $(document).on('click', '.btn-del-row', function () {
            if (locked) return;
            $(this).closest('tr').remove();
        });

        $(document).on('click', '.btn-pick-mat', function () {
            if (locked) return;
            var $row = $(this).closest('tr');
            if (isProductBom()) {
                var productName = getProductName();
                if (!productName) {
                    layer.msg('请先选择产品BOM头的产品物料');
                    return;
                }
                openComponentPanel(productName, '', function (component) {
                    applyItemToRow($row, component.componentCode || '', component.componentName || '', '', component.componentType || 'COMP');
                });
                return;
            }
            openMaterialPanel('', function (mat) {
                applyItemToRow($row, mat.materiel || '', mat.materielDesc || '', mat.unit || '', mat.matType || 'PART');
            });
        });

        $(document).on('click', '.btn-pick-component', function () {
            if (locked) return;
            var $row = $(this).closest('tr');
            openComponentPanel('', '', function (component) {
                applyItemToRow($row, component.componentCode || '', component.componentName || '', '', component.componentType || 'COMP');
            });
        });

        $(document).on('click', '.btn-pick-bom', function () {
            if (locked || $(this).prop('disabled')) return;
            var $row = $(this).closest('tr');
            var matType = $row.find('.item-matType').val();
            var itemCode = $row.find('.item-matCode').val();
            spLayer.open({
                type: 2,
                area: ['720px', '480px'],
                reload: false,
                content: '${request.contextPath}/technology/bom/select-bom-panel-ui?itemMatType=' + encodeURIComponent(matType) + '&itemCode=' + encodeURIComponent(itemCode),
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        var bom = result.data[0];
                        var text = (bom.bomCode || '') + ' ' + (bom.materielDesc || '');
                        $row.find('.item-childBomId').val(bom.id || '');
                        $row.find('.item-childBomCode').val(text).attr('title', text);
                    }
                }
            });
        });

        function serializeItems() {
            var items = [];
            $('#js-items-tbody tr').each(function () {
                var $tr = $(this);
                items.push({
                    lineNo: $tr.find('.item-lineNo').val(),
                    materielItemCode: $tr.find('.item-matCode').val(),
                    materielItemDesc: $tr.find('.item-matDesc').val(),
                    itemMatType: $tr.find('.item-matType').val(),
                    itemNum: $tr.find('.item-num').val() || null,
                    itemUnit: $tr.find('.item-unit').val(),
                    operTyper: $tr.find('.item-oper').val(),
                    childBomId: $tr.find('.item-childBomId').val() || null
                });
            });
            $('#js-items-json').val(JSON.stringify(items));
        }

        form.on('submit(js-submit-filter)', function (data) {
            if (locked) {
                layer.msg('该BOM已定版，无法保存', { icon: 2 });
                return false;
            }
            serializeItems();
            data.field.itemsJson = $('#js-items-json').val();
            if ($('#js-items-tbody tr').length > 0 && data.field.itemsJson === '[]') {
                layer.alert('BOM子项没有正确序列化，请刷新页面后重试', { icon: 2 });
                return false;
            }
            spUtil.submitForm({
                url: '${request.contextPath}/technology/bom/save-with-items',
                data: $.extend({}, data.field)
            });
            return false;
        });

        $('#js-pick-head-btn').on('click', function () {
            if (locked) return;
            if (isProductBom()) {
                openMaterialPanel('FG,PRODUCT', function (mat) {
                    setHead(mat.materiel || '', normalizeProductName(mat.materielDesc), false);
                });
                return;
            }
            openComponentPanel('', '', function (component) {
                setHead(component.componentCode || '', component.componentName || '', true);
            });
        });

        form.on('select(js-bomLevel-filter)', function () {
            if (locked) return;
            setHead('', '', false);
            refreshAllRows();
        });

        function openMaterialPanel(matTypes, callback) {
            var url = '${request.contextPath}/admin/common/ui/searchPanelMaterile';
            if (matTypes) url += '?matTypes=' + encodeURIComponent(matTypes);
            spLayer.open({
                type: 2,
                area: ['720px', '500px'],
                reload: false,
                content: url,
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) callback(result.data[0]);
                }
            });
        }

        function openComponentPanel(productName, componentType, callback) {
            var url = '${request.contextPath}/technology/component/select-ui?productName=' + encodeURIComponent(productName || '');
            if (componentType) url += '&componentType=' + encodeURIComponent(componentType);
            spLayer.open({
                type: 2,
                title: componentType ? '选择零部件定义' : '选择产品零部件',
                area: ['760px', '500px'],
                reload: false,
                content: url,
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) callback(result.data[0]);
                }
            });
        }

        window.FN = function (btnType) {
            if (locked) return;
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
                        refreshAllRows();
                        form.render();
                    }
                }
            });
        }

        if (locked) {
            $('#js-bom-form').find('input,select,textarea,button').prop('disabled', true);
            $('#js-add-item-row').prop('disabled', true);
        }
        refreshAllRows();
        form.render();
    });
</script>
</body>
</html>
