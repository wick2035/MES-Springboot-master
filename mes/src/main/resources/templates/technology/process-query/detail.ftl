<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺详情</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .step-bar {
            display: flex; padding: 12px 16px; background:#fafafa; border-bottom: 1px solid #eee;
        }
        .step-tab {
            flex: 1; text-align: center; padding: 8px 4px; cursor: pointer; border-bottom: 2px solid transparent;
            font-size: 13px; color: #666;
        }
        .step-tab.active { color:#FF5722; border-bottom-color:#FF5722; font-weight: bold; }
        .panel { padding: 16px 24px; }
        .panel-title { font-size: 14px; color:#FF7200; font-weight: bold; margin-bottom: 12px; border-left: 3px solid #FF7200; padding-left:8px; }
        .img-grid { display:flex; flex-wrap:wrap; gap:10px; }
        .img-grid img { width: 160px; height: 120px; object-fit: cover; border: 1px solid #ddd; cursor: pointer; }
        .ro-input { background: #f5f5f5; }
        .attach-link { padding: 6px 10px; background:#f0f0f0; border-radius:3px; margin: 4px 0; display: block; }
    </style>
</head>
<body>
<div>
    <div class="step-bar">
        <div class="step-tab active" data-step="1">1 工序主信息</div>
        <div class="step-tab" data-step="2">2 工序内容</div>
        <div class="step-tab" data-step="3">3 工序要求</div>
        <div class="step-tab" data-step="4">4 注意事项</div>
        <div class="step-tab" data-step="5">5 工装设备</div>
        <div class="step-tab" data-step="6">6 技术文档</div>
        <div class="step-tab" data-step="7">7 备料清单</div>
    </div>

    <div class="panel" id="panel-1">
        <div class="panel-title">工序主信息</div>
        <table class="layui-table">
            <tr>
                <td style="width:140px;">工序编号</td><td>${route.routeCode!''}</td>
                <td style="width:140px;">工序名称</td><td>${mainInfo.operName!route.nodeName!''}</td>
            </tr>
            <tr>
                <td>工序工时(h)</td><td>${mainInfo.operHours!''}</td>
                <td>制造周期(h)</td><td>${mainInfo.manuCycle!''}</td>
            </tr>
            <tr>
                <td>加工单元</td><td>${mainInfo.unitName!''}</td>
                <td>加工单元类型</td><td>${mainInfo.unitTypeName!''}</td>
            </tr>
            <tr>
                <td>是否生成生产计划</td>
                <td colspan="3"><#if (mainInfo.genPlan!'') == 'Y'>是<#elseif (mainInfo.genPlan!'') == 'N'>否</#if></td>
            </tr>
        </table>
    </div>

    <div class="panel" id="panel-2" style="display:none;">
        <div class="panel-title">工序内容</div>
        <textarea class="layui-textarea ro-input" rows="6" readonly>${content.contentText!''}</textarea>
        <div class="panel-title" style="margin-top:16px;">图片</div>
        <div class="img-grid" id="js-content-imgs"></div>
    </div>

    <div class="panel" id="panel-3" style="display:none;">
        <div class="panel-title">工序要求</div>
        <textarea class="layui-textarea ro-input" rows="6" readonly>${content.requireText!''}</textarea>
        <div style="margin-top:10px;">是否需要检验：<strong><#if (content.needCheck!'') == 'Y'>是<#elseif (content.needCheck!'') == 'N'>否</#if></strong></div>
        <div class="panel-title" style="margin-top:16px;">检验标准图片</div>
        <div class="img-grid" id="js-req-imgs"></div>
    </div>

    <div class="panel" id="panel-4" style="display:none;">
        <div class="panel-title">注意事项</div>
        <textarea class="layui-textarea ro-input" rows="6" readonly>${content.precautionText!''}</textarea>
        <div class="panel-title" style="margin-top:16px;">图片</div>
        <div class="img-grid" id="js-prec-imgs"></div>
    </div>

    <div class="panel" id="panel-5" style="display:none;">
        <div class="panel-title">工装设备</div>
        <table class="layui-table" id="js-equip-table"></table>
    </div>

    <div class="panel" id="panel-6" style="display:none;">
        <div class="panel-title">技术文档</div>
        <div>描述：<strong>${content.techDocDesc!''}</strong></div>
        <div class="panel-title" style="margin-top:16px;">文档图片</div>
        <div class="img-grid" id="js-tech-imgs"></div>
        <div class="panel-title" style="margin-top:16px;">附件</div>
        <div id="js-tech-attachs"></div>
    </div>

    <div class="panel" id="panel-7" style="display:none;">
        <div class="panel-title">备料清单</div>
        <table class="layui-table" id="js-mat-table"></table>
    </div>
</div>

<script>
    var routeId = '${route.id}';

    function activeTab(n) {
        $('.step-tab').removeClass('active');
        $('.step-tab[data-step=' + n + ']').addClass('active');
        for (var i = 1; i <= 7; i++) $('#panel-' + i).hide();
        $('#panel-' + n).show();
    }
    $('.step-tab').on('click', function () { activeTab($(this).data('step')); });

    function renderImgs(elemId, arr) {
        var $el = $('#' + elemId).empty();
        if (!arr || arr.length === 0) { $el.html('<span style="color:#999;">暂无</span>'); return; }
        for (var i = 0; i < arr.length; i++) {
            var f = arr[i];
            var url = '${request.contextPath}/upload/' + f.filePath;
            $el.append('<img src="' + url + '" title="' + (f.originalName || '') + '" onclick="window.open(\'' + url + '\',\'_blank\')">');
        }
    }

    function renderAttachs(elemId, arr) {
        var $el = $('#' + elemId).empty();
        if (!arr || arr.length === 0) { $el.html('<span style="color:#999;">暂无</span>'); return; }
        for (var i = 0; i < arr.length; i++) {
            var f = arr[i];
            var url = '${request.contextPath}/upload/' + f.filePath;
            $el.append('<a class="attach-link" href="' + url + '" target="_blank"><i class="layui-icon layui-icon-file"></i> ' + (f.originalName || '') + ' <span style="color:#999;">(' + Math.round((f.fileSize || 0) / 1024) + 'KB)</span></a>');
        }
    }

    layui.use(['table'], function () {
        var table = layui.table;

        spUtil.ajax({
            url: '${request.contextPath}/technology/process-query/detail-data',
            type: 'GET', serializable: false, data: {routeId: routeId},
            success: function (resp) {
                var d = resp.data || {};
                renderImgs('js-content-imgs', d.contentImgs);
                renderImgs('js-req-imgs', d.reqImgs);
                renderImgs('js-prec-imgs', d.precImgs);
                renderImgs('js-tech-imgs', d.techImgs);
                renderAttachs('js-tech-attachs', d.techAttachs);
            }
        });

        spUtil.ajax({
            url: '${request.contextPath}/technology/process-content/equipments',
            type: 'GET', serializable: false, data: {routeId: routeId},
            success: function (resp) {
                table.render({
                    elem: '#js-equip-table', data: resp.data || [],
                    cols: [[
                        {field: 'equipmentCode', title: '设备编码', width: 130},
                        {field: 'equipmentName', title: '设备名称'},
                        {field: 'equipmentModel', title: '设备规格/型号'},
                        {field: 'purpose', title: '设备用途'},
                        {field: 'reqQty', title: '需求数量', width: 100},
                        {field: 'remark', title: '备注'}
                    ]]
                });
            }
        });

        spUtil.ajax({
            url: '${request.contextPath}/technology/process-content/materials',
            type: 'GET', serializable: false, data: {routeId: routeId},
            success: function (resp) {
                table.render({
                    elem: '#js-mat-table', data: resp.data || [],
                    cols: [[
                        {field: 'materielCode', title: '物料编码', width: 130},
                        {field: 'materielDesc', title: '物料名称'},
                        {field: 'matType', title: '物料类型', width: 100},
                        {field: 'model', title: '规格/型号'},
                        {field: 'reqQty', title: '需求数量', width: 110},
                        {field: 'remark', title: '备注'}
                    ]]
                });
            }
        });
    });
</script>
</body>
</html>
