<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI 智能建模</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body { background: #f2f4f7; }
        .sp-card { background: #fff; border-radius: 8px; padding: 16px 18px; margin: 12px; box-shadow: 0 1px 3px rgba(0,0,0,.05); }
        .sp-card-title { font-weight: bold; font-size: 14px; border-left: 3px solid #2563EB; padding-left: 8px; margin-bottom: 14px; }
        .sp-tip { color: #a0a8b5; font-size: 12px; margin-left: 6px; }
        .bom-table { width: 100%; border-collapse: collapse; }
        .bom-table th, .bom-table td { border: 1px solid #e6e9ef; padding: 4px 6px; font-size: 13px; }
        .bom-table th { background: #f5f7fa; white-space: nowrap; }
        .bom-table input, .bom-table select { width: 100%; border: none; outline: none; background: transparent; font-size: 13px; }
        .bom-table tr.unmatched { background: #fff7f0; }
        .bom-table tr.warnrow { background: #fdecea; }
        .badge { display: inline-block; padding: 1px 7px; border-radius: 10px; font-size: 12px; white-space: nowrap; }
        .badge.ok { background: #e8f5e9; color: #2e7d32; }
        .badge.no { background: #fdecea; color: #c0392b; }
        .badge.adj { background: #fff8e1; color: #b8860b; }
        .row-del { color: #e54d42; cursor: pointer; }
        .row-move { color: #2563EB; cursor: pointer; margin-right: 6px; }
        .loading { color: #2563EB; font-size: 13px; }
        /* 步骤条 */
        .wz-steps { display: flex; align-items: center; margin: 12px 12px 0 12px; }
        .wz-step { display: flex; align-items: center; cursor: default; }
        .wz-step .num { width: 26px; height: 26px; line-height: 26px; text-align: center; border-radius: 50%;
            background: #e6e9ef; color: #8a93a3; font-weight: bold; font-size: 13px; }
        .wz-step .txt { margin: 0 10px 0 8px; color: #8a93a3; font-size: 13px; }
        .wz-step.active .num { background: #2563EB; color: #fff; }
        .wz-step.active .txt { color: #2563EB; font-weight: bold; }
        .wz-step.done .num { background: #e8f5e9; color: #2e7d32; }
        .wz-step.done .txt { color: #2e7d32; }
        .wz-step.done { cursor: pointer; }
        .wz-line { flex: 1; height: 2px; background: #e6e9ef; margin-right: 10px; min-width: 30px; }
        .step-panel { display: none; }
        .wz-summary { font-size: 13px; line-height: 26px; color: #444; }
        .wz-summary b { color: #2563EB; }
        .cand-item { padding: 6px 10px; border-bottom: 1px solid #f0f0f0; cursor: pointer; font-size: 13px; }
        .cand-item:hover { background: #f5f7fa; }
        .cand-item.sel { background: #e8f0fe; }
        .cand-load { float: right; color: #a0a8b5; }
    </style>
</head>
<body>

<!-- 步骤条 -->
<div class="wz-steps" id="js-steps">
    <div class="wz-step" data-step="1"><span class="num">1</span><span class="txt">产品信息</span></div>
    <div class="wz-line"></div>
    <div class="wz-step" data-step="2"><span class="num">2</span><span class="txt">BOM审核</span></div>
    <div class="wz-line"></div>
    <div class="wz-step" data-step="3"><span class="num">3</span><span class="txt">工艺审核</span></div>
    <div class="wz-line"></div>
    <div class="wz-step" data-step="4"><span class="num">4</span><span class="txt">工单与排人</span></div>
</div>
<div style="margin: 4px 12px 0 12px;"><span class="sp-tip">向导状态保存在页面内存中，刷新页面将从头开始</span></div>

<!-- ====================== 步骤① 产品信息 ====================== -->
<div class="sp-card step-panel" id="step-1">
    <div class="sp-card-title"><i class="fa fa-magic"></i> AI 辅助生成 BOM <span class="sp-tip">输入产品信息，AI 生成 BOM 草稿与工序序列，逐步审核后建立工单</span></div>
    <form class="layui-form" lay-filter="gen-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">产品名称</label>
                <div class="layui-input-inline"><input type="text" name="productName" class="layui-input" placeholder="如：台式电脑主机"></div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">BOM层级</label>
                <div class="layui-input-inline">
                    <select name="bomLevel">
                        <option value="0">0 成品</option>
                        <option value="1">1 半成品</option>
                        <option value="2">2 组件</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">产品描述</label>
            <div class="layui-input-block"><input type="text" name="productDesc" class="layui-input" placeholder="可选，补充产品用途、规格等"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">结构/工艺提示</label>
            <div class="layui-input-block"><textarea name="structureHint" class="layui-textarea" placeholder="可选，例如：包含主板、CPU、内存、电源、机箱、硬盘等"></textarea></div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="button" class="layui-btn" id="js-gen">生成 BOM 草稿</button>
                <span id="js-loading" class="loading" style="display:none;"><i class="fa fa-spinner fa-spin"></i> AI 正在生成，请稍候...</span>
            </div>
        </div>
    </form>
</div>

<!-- ====================== 步骤② BOM审核 ====================== -->
<div class="sp-card step-panel" id="step-2">
    <div class="sp-card-title"><i class="fa fa-list"></i> BOM 草稿审核（可编辑）<span class="sp-tip" id="js-match-tip"></span></div>
    <form class="layui-form" lay-filter="head-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">BOM编码</label>
                <div class="layui-input-inline"><input type="text" id="h-bomCode" class="layui-input"></div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">物料编码</label>
                <div class="layui-input-inline"><input type="text" id="h-materielCode" class="layui-input" placeholder="一键补建物料后自动填充"></div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">版本号</label>
                <div class="layui-input-inline"><input type="text" id="h-version" class="layui-input" value="1"></div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">物料描述</label>
                <div class="layui-input-inline"><input type="text" id="h-materielDesc" class="layui-input"></div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">工厂</label>
                <div class="layui-input-inline"><input type="text" id="h-factory" class="layui-input"></div>
            </div>
            <input type="hidden" id="h-bomLevel">
        </div>
    </form>

    <table class="bom-table" style="margin-top:8px;">
        <thead>
        <tr>
            <th style="width:13%">子项名称</th>
            <th style="width:9%">物料编码</th>
            <th style="width:8%">BOM子项类型</th>
            <th style="width:5%">用量</th>
            <th style="width:5%">单位</th>
            <th style="width:9%">所属工序</th>
            <th style="width:8%">物料类型</th>
            <th style="width:6%">来源</th>
            <th style="width:7%">提前期(天)</th>
            <th style="width:7%">安全库存</th>
            <th style="width:6%">子件</th>
            <th style="width:9%">匹配</th>
            <th style="width:4%">操作</th>
        </tr>
        </thead>
        <tbody id="js-items"></tbody>
    </table>
    <div style="margin-top:12px;">
        <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-add-row"><i class="fa fa-plus"></i> 添加子项</button>
        <button type="button" class="layui-btn layui-btn-warm layui-btn-sm" id="js-create-mat"><i class="fa fa-cubes"></i> 一键增加未匹配物料</button>
        <button type="button" class="layui-btn layui-btn-sm" id="js-save-bom"><i class="fa fa-save"></i> 保存BOM并定版，下一步</button>
        <span class="sp-tip">将自动补建未匹配物料（含期初库存）、零部件定义，并按子件清单生成下层BOM后整体定版</span>
    </div>
</div>

<!-- ====================== 步骤③ 工艺审核 ====================== -->
<div class="sp-card step-panel" id="step-3">
    <div class="sp-card-title"><i class="fa fa-cogs"></i> 工序 / 工艺路线审核 <span class="sp-tip" id="js-oper-tip"></span></div>
    <table class="bom-table">
        <thead>
        <tr>
            <th style="width:6%">顺序</th>
            <th style="width:18%">工序名称</th>
            <th style="width:10%">工序编码</th>
            <th style="width:20%">加工单元</th>
            <th style="width:10%">工时(h)</th>
            <th style="width:10%">制造周期(h)</th>
            <th style="width:14%">匹配</th>
            <th style="width:12%">操作</th>
        </tr>
        </thead>
        <tbody id="js-opers"></tbody>
    </table>
    <div style="margin-top:12px;">
        <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-add-oper"><i class="fa fa-plus"></i> 添加工序</button>
        <button type="button" class="layui-btn layui-btn-sm" id="js-create-flow"><i class="fa fa-random"></i> 创建工序与工艺路线并下一步</button>
        <span class="sp-tip">未匹配工序将自动新建（需确认加工单元），按顺序生成工艺路线，至少两道工序</span>
    </div>
</div>

<!-- ====================== 步骤④ 工单与排人 ====================== -->
<div class="sp-card step-panel" id="step-4">
    <div class="sp-card-title"><i class="fa fa-file-text-o"></i> 工单建立 <span class="sp-tip">工单创建后进入现有审批流（待审批）</span></div>
    <div class="wz-summary" id="js-flow-summary" style="margin-bottom:10px;"></div>
    <form class="layui-form" lay-filter="order-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">工单物料</label>
                <div class="layui-input-inline"><input type="text" id="o-materiel" class="layui-input" readonly style="background:#f5f7fa;"></div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">物料描述</label>
                <div class="layui-input-inline"><input type="text" id="o-materielDesc" class="layui-input" readonly style="background:#f5f7fa;"></div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">工单数量</label>
                <div class="layui-input-inline"><input type="number" id="o-qty" class="layui-input" min="1" value="1"></div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">计划开始</label>
                <div class="layui-input-inline"><input type="text" id="o-planStart" class="layui-input" placeholder="yyyy-MM-dd HH:mm:ss" readonly></div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">计划结束</label>
                <div class="layui-input-inline"><input type="text" id="o-planEnd" class="layui-input" placeholder="yyyy-MM-dd HH:mm:ss" readonly></div>
            </div>
            <div class="layui-inline" style="width:38%;">
                <label class="layui-form-label">工单描述</label>
                <div class="layui-input-inline" style="width:70%;"><input type="text" id="o-desc" class="layui-input" placeholder="可选"></div>
            </div>
        </div>
    </form>

    <div class="sp-card-title" style="margin-top:6px;"><i class="fa fa-users"></i> 工序人员分配 <span class="sp-tip">按「加工单元→班组→员工」自动负载均衡，可手动改人</span></div>
    <table class="bom-table">
        <thead>
        <tr>
            <th style="width:6%">顺序</th>
            <th style="width:16%">工序</th>
            <th style="width:16%">加工单元</th>
            <th style="width:14%">班组</th>
            <th style="width:14%">执行人</th>
            <th style="width:8%">当前负载</th>
            <th style="width:18%">提示</th>
            <th style="width:8%">操作</th>
        </tr>
        </thead>
        <tbody id="js-assigns"></tbody>
    </table>
    <div style="margin-top:12px;">
        <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-refresh-assign"><i class="fa fa-refresh"></i> 重新自动分配</button>
        <button type="button" class="layui-btn layui-btn-sm" id="js-create-order"><i class="fa fa-check"></i> 创建工单并完成</button>
    </div>
</div>

<!-- ====================== 完成页 ====================== -->
<div class="sp-card step-panel" id="step-5">
    <div class="sp-card-title"><i class="fa fa-check-circle" style="color:#2e7d32;"></i> 全链路建模完成</div>
    <div class="wz-summary" id="js-done-summary"></div>
    <div style="margin-top:14px;">
        <button type="button" class="layui-btn layui-btn-primary" id="js-restart"><i class="fa fa-repeat"></i> 再来一单</button>
    </div>
</div>

<script>
    var ctx = '${request.contextPath}';
    layui.use(['form', 'layer', 'laydate'], function () {
        var $ = layui.jquery;
        var form = layui.form;
        var layer = layui.layer;
        var laydate = layui.laydate;

        laydate.render({ elem: '#o-planStart', type: 'datetime' });
        laydate.render({ elem: '#o-planEnd', type: 'datetime' });

        // ==================== 向导状态（内存） ====================
        var wizard = {
            step: 1,
            done: {},                       // 已完成步骤标记
            gen: {},                        // 步骤① 输入
            draft: { items: [], opers: [] },// AI 草稿
            bom: {},                        // {bomCode, headerMaterielCode}
            flow: {},                       // {flowId, flow, process}
            assigns: [],                    // 步骤④ 分配行
            units: []                       // 加工单元列表
        };

        function esc(s) { return (s == null ? '' : String(s)).replace(/"/g, '&quot;'); }
        function postJson(url, data, cb) {
            $.ajax({
                url: ctx + url, type: 'POST', contentType: 'application/json',
                data: JSON.stringify(data), dataType: 'json',
                success: cb,
                error: function () { layer.closeAll('loading'); layer.msg('请求失败'); }
            });
        }
        function lockBtn($btn) { $btn.addClass('layui-btn-disabled').attr('disabled', true); }
        function unlockBtn($btn) { $btn.removeClass('layui-btn-disabled').removeAttr('disabled'); }

        // ==================== 步骤条 ====================
        function renderStep(n) {
            wizard.step = n;
            $('#js-steps .wz-step').each(function () {
                var s = parseInt($(this).data('step'));
                $(this).removeClass('active done');
                if (s === Math.min(n, 4)) $(this).addClass('active');
                else if (wizard.done[s]) $(this).addClass('done');
            });
            $('.step-panel').hide();
            $('#step-' + n).show();
        }
        // 已完成步骤可点回看（只读：其提交按钮已置灰）
        $('#js-steps').on('click', '.wz-step.done', function () {
            renderStep(parseInt($(this).data('step')));
        });

        // ==================== 步骤①：生成草稿 ====================
        $('#js-gen').on('click', function () {
            var data = {
                productName: $.trim($('input[name=productName]').val()),
                productDesc: $('input[name=productDesc]').val(),
                structureHint: $('textarea[name=structureHint]').val(),
                bomLevel: $('select[name=bomLevel]').val()
            };
            if (!data.productName) { layer.msg('请输入产品名称'); return; }
            $('#js-loading').show();
            lockBtn($('#js-gen'));
            $.post(ctx + '/llm/bom-gen/generate', data, function (res) {
                $('#js-loading').hide();
                unlockBtn($('#js-gen'));
                if (res.code !== 0) { layer.msg(res.msg || '生成失败'); return; }
                wizard.gen = data;
                wizard.draft = res.data || {};
                wizard.done[1] = true;
                renderDraft();
                renderStep(2);
            }).fail(function () {
                $('#js-loading').hide();
                unlockBtn($('#js-gen'));
                layer.msg('请求失败');
            });
        });

        // ==================== 步骤②：BOM 审核 ====================
        function itemTypeOptions(sel) {
            var level = String(wizard.gen.bomLevel || '0');
            var opts = level === '0'
                ? [['COMP', '组件'], ['PG', '半成品']]
                : [['PART', '零件'], ['COMP', '组件'], ['PG', '半成品']];
            var h = '';
            opts.forEach(function (o) {
                h += '<option value="' + o[0] + '"' + (o[0] === sel ? ' selected' : '') + '>' + o[1] + '</option>';
            });
            return h;
        }
        function matTypeOptions(sel) {
            var opts = [['PART', '零件'], ['COMP', '组件'], ['PG', '半成品'], ['FG', '成品']];
            var h = '';
            opts.forEach(function (o) {
                h += '<option value="' + o[0] + '"' + (o[0] === sel ? ' selected' : '') + '>' + o[1] + '</option>';
            });
            return h;
        }
        function sourceOptions(sel) {
            var opts = [['OUT', '外购'], ['SELF', '自制']];
            var h = '';
            opts.forEach(function (o) {
                h += '<option value="' + o[0] + '"' + (o[0] === sel ? ' selected' : '') + '>' + o[1] + '</option>';
            });
            return h;
        }
        function itemRowHtml(it) {
            var matched = it.matched === true;
            var badge = matched
                ? '<span class="badge ok">已匹配</span>'
                : '<span class="badge no">未匹配</span>';
            if (it.created === true) badge = '<span class="badge ok">已创建</span>';
            if (it.typeAdjusted === true) badge += ' <span class="badge adj" title="AI建议为零件/成品，已按产品BOM规则调整为组件">已纠偏</span>';
            var subParts = it.subParts || [];
            var subNames = subParts.map(function (p) { return p.name; }).join('、');
            var subCell = '<a href="javascript:;" class="sub-edit" style="color:#2563EB;" title="'
                + (subParts.length ? esc(subNames) : '点击编辑下层BOM子件清单（为空时定版将自动补一条基础件）') + '">'
                + (subParts.length ? subParts.length + ' 件' : '编辑') + '</a>';
            return '<tr class="' + (matched ? '' : 'unmatched') + '" data-mid="' + esc(it.materielId || '')
                + '" data-subparts="' + esc(JSON.stringify(subParts)) + '">'
                + '<td><input class="i-desc" value="' + esc(it.materielItemDesc) + '"></td>'
                + '<td><input class="i-code" value="' + esc(it.materielItemCode) + '"></td>'
                + '<td><select class="i-type">' + itemTypeOptions(it.itemMatType) + '</select></td>'
                + '<td><input class="i-num" value="' + esc(it.itemNum != null ? it.itemNum : 1) + '"></td>'
                + '<td><input class="i-unit" value="' + esc(it.itemUnit) + '"></td>'
                + '<td><input class="i-oper" value="' + esc(it.operTyper) + '"></td>'
                + '<td><select class="i-mattype">' + matTypeOptions(it.matType || it.itemMatType) + '</select></td>'
                + '<td><select class="i-source">' + sourceOptions(it.matSource) + '</select></td>'
                + '<td><input class="i-lead" type="number" min="1" value="' + esc(it.leadTime != null ? it.leadTime : 1) + '"></td>'
                + '<td><input class="i-safety" type="number" min="0" value="' + esc(it.safetyStock != null ? it.safetyStock : 0) + '"></td>'
                + '<td style="text-align:center;">' + subCell + '</td>'
                + '<td>' + badge + '</td>'
                + '<td><i class="fa fa-trash-o row-del"></i></td>'
                + '</tr>';
        }
        function renderDraft() {
            var draft = wizard.draft;
            var header = draft.header || {};
            $('#h-bomCode').val('BOM' + new Date().getTime());
            $('#h-materielCode').val(header.materielCode || '');
            $('#h-materielDesc').val(header.materielDesc || wizard.gen.productName);
            $('#h-version').val(header.versionNumber || '1');
            $('#h-bomLevel').val(wizard.gen.bomLevel);
            $('#h-factory').val(header.factory || '');

            var items = draft.items || [];
            var html = '';
            items.forEach(function (it) { html += itemRowHtml(it); });
            $('#js-items').html(html);
            $('#js-match-tip').text('共 ' + (draft.totalItems || items.length) + ' 项，已匹配 ' + (draft.matchedCount || 0)
                + ' 项；工序建议 ' + (draft.totalOpers || 0) + ' 道。未匹配物料可一键补建。');
            form.render();
        }
        $('#js-add-row').on('click', function () {
            $('#js-items').append(itemRowHtml({ matched: false, itemNum: 1, leadTime: 1, safetyStock: 0 }));
            form.render('select');
        });
        $('#js-items').on('click', '.row-del', function () { $(this).closest('tr').remove(); });

        // ===== 子件清单（下层BOM内容）审核/编辑弹层 =====
        function subPartRowHtml(p) {
            p = p || {};
            return '<tr>'
                + '<td><input class="sp-name" style="width:100%;border:1px solid #e6e9ef;padding:3px 5px;" value="' + esc(p.name || '') + '"></td>'
                + '<td><input class="sp-num" type="number" min="1" style="width:100%;border:1px solid #e6e9ef;padding:3px 5px;" value="' + esc(p.num != null ? p.num : 1) + '"></td>'
                + '<td><input class="sp-unit" style="width:100%;border:1px solid #e6e9ef;padding:3px 5px;" value="' + esc(p.unit || '个') + '"></td>'
                + '<td style="text-align:center;"><i class="fa fa-trash-o row-del" style="color:#e54d42;cursor:pointer;"></i></td>'
                + '</tr>';
        }
        $('#js-items').on('click', '.sub-edit', function () {
            var $tr = $(this).closest('tr');
            var itemType = $tr.find('.i-type').val();
            if (itemType !== 'PG' && itemType !== 'COMP') {
                layer.msg('只有组件/半成品子项需要维护下层BOM子件');
                return;
            }
            var itemDesc = $.trim($tr.find('.i-desc').val()) || '未命名子项';
            var subParts = [];
            try { subParts = JSON.parse($tr.attr('data-subparts') || '[]'); } catch (e) { subParts = []; }
            var rowsHtml = '';
            subParts.forEach(function (p) { rowsHtml += subPartRowHtml(p); });
            var html = '<div style="padding:12px;">'
                + '<div class="sp-tip" style="margin-bottom:8px;">该清单将作为【' + esc(itemDesc) + '】的下层BOM子项（零件），保存定版时自动建料入库</div>'
                + '<table class="bom-table"><thead><tr>'
                + '<th style="width:50%">子件名称</th><th style="width:20%">数量</th><th style="width:20%">单位</th><th style="width:10%">删除</th>'
                + '</tr></thead><tbody id="js-subparts">' + rowsHtml + '</tbody></table>'
                + '<button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-add-subpart" style="margin-top:8px;"><i class="fa fa-plus"></i> 添加子件</button>'
                + '</div>';
            layer.open({
                type: 1,
                title: '下层BOM子件清单 - ' + itemDesc,
                area: ['560px', '420px'],
                content: html,
                btn: ['确定', '取消'],
                success: function () {
                    $('#js-add-subpart').on('click', function () {
                        $('#js-subparts').append(subPartRowHtml());
                    });
                    $('#js-subparts').on('click', '.row-del', function () { $(this).closest('tr').remove(); });
                },
                yes: function (idx) {
                    var list = [];
                    var names = {};
                    var dup = '';
                    $('#js-subparts tr').each(function () {
                        var name = $.trim($(this).find('.sp-name').val());
                        if (!name) return;
                        if (names[name]) { dup = name; return; }
                        names[name] = true;
                        list.push({
                            name: name,
                            num: parseFloat($(this).find('.sp-num').val()) || 1,
                            unit: $.trim($(this).find('.sp-unit').val()) || '个'
                        });
                    });
                    if (dup) { layer.msg('子件【' + dup + '】重复，请合并'); return; }
                    $tr.attr('data-subparts', JSON.stringify(list));
                    var names2 = list.map(function (p) { return p.name; }).join('、');
                    $tr.find('.sub-edit')
                        .text(list.length ? list.length + ' 件' : '编辑')
                        .attr('title', list.length ? names2 : '点击编辑下层BOM子件清单（为空时定版将自动补一条基础件）');
                    layer.close(idx);
                }
            });
        });

        function collectMaterials() {
            var rows = [];
            $('#js-items tr').each(function () {
                var $t = $(this);
                rows.push({
                    materielItemDesc: $.trim($t.find('.i-desc').val()),
                    materielItemCode: $.trim($t.find('.i-code').val()),
                    itemMatType: $t.find('.i-type').val(),
                    itemUnit: $t.find('.i-unit').val(),
                    matType: $t.find('.i-mattype').val(),
                    matSource: $t.find('.i-source').val(),
                    leadTime: parseInt($t.find('.i-lead').val()) || 1,
                    safetyStock: parseInt($t.find('.i-safety').val()) || 0,
                    materielId: $t.data('mid') || ''
                });
            });
            return rows;
        }
        function applyMaterialResult(data) {
            // 按行序回填编码与ID
            var materials = data.materials || [];
            $('#js-items tr').each(function (idx) {
                if (idx >= materials.length) return;
                var m = materials[idx];
                var $t = $(this);
                $t.find('.i-code').val(m.materielItemCode || '');
                $t.attr('data-mid', m.materielId || '').data('mid', m.materielId || '');
                if (m.matched === true) {
                    $t.removeClass('unmatched');
                    $t.find('.badge.no').removeClass('no').addClass('ok').text(m.created === true ? '已创建' : '已匹配');
                }
            });
            if (data.headerMaterielCode && !$.trim($('#h-materielCode').val())) {
                $('#h-materielCode').val(data.headerMaterielCode);
            }
        }
        function batchCreateMaterials(cb) {
            var materials = collectMaterials();
            for (var i = 0; i < materials.length; i++) {
                if (!materials[i].materielItemDesc) { layer.msg('第 ' + (i + 1) + ' 行子项名称未填写'); return; }
            }
            var loadIdx = layer.load(2);
            postJson('/llm/bom-wizard/material/batch-create', {
                productName: wizard.gen.productName,
                bomLevel: parseInt(wizard.gen.bomLevel || '0'),
                materials: materials
            }, function (res) {
                layer.close(loadIdx);
                if (res.code !== 0) { layer.alert(res.msg || '物料补建失败', { icon: 2, title: '物料补建未通过' }); return; }
                applyMaterialResult(res.data || {});
                var c1 = (res.data && res.data.createdMaterialCount) || 0;
                var c2 = (res.data && res.data.createdComponentCount) || 0;
                var c3 = (res.data && res.data.createdInventoryCount) || 0;
                if (c1 + c2 > 0) layer.msg('新建物料 ' + c1 + ' 条、零部件定义 ' + c2 + ' 条、期初库存 ' + c3 + ' 条', { icon: 1 });
                if (cb) cb();
            });
        }
        $('#js-create-mat').on('click', function () { batchCreateMaterials(); });

        $('#js-save-bom').on('click', function () {
            var $btn = $(this);
            if (!$('#js-items tr').length) { layer.msg('请至少保留一个子项'); return; }
            // 先自动补建物料/前置数据（幂等），再全链保存并定版
            batchCreateMaterials(function () {
                var items = [];
                var valid = true;
                $('#js-items tr').each(function (idx) {
                    var $t = $(this);
                    var desc = $.trim($t.find('.i-desc').val());
                    var code = $.trim($t.find('.i-code').val());
                    if (!desc || !code) valid = false;
                    var subParts = [];
                    try { subParts = JSON.parse($t.attr('data-subparts') || '[]'); } catch (e) { subParts = []; }
                    items.push({
                        materielItemDesc: desc,
                        materielItemCode: code,
                        itemMatType: $t.find('.i-type').val(),
                        itemNum: parseFloat($t.find('.i-num').val()) || 0,
                        itemUnit: $t.find('.i-unit').val(),
                        operTyper: $t.find('.i-oper').val(),
                        lineNo: String(idx + 1),
                        subParts: subParts
                    });
                });
                if (!valid) { layer.msg('存在未填写名称或编码的子项'); return; }
                if (!$('#h-bomCode').val() || !$('#h-materielCode').val() || !$('#h-materielDesc').val()) {
                    layer.msg('请完善 BOM 编码 / 物料编码 / 物料描述'); return;
                }
                var payload = {
                    header: {
                        bomCode: $('#h-bomCode').val(),
                        materielCode: $('#h-materielCode').val(),
                        materielDesc: $('#h-materielDesc').val(),
                        versionNumber: $('#h-version').val(),
                        bomLevel: parseInt($('#h-bomLevel').val() || '0'),
                        factory: $('#h-factory').val()
                    },
                    items: items
                };
                var loadIdx = layer.load(2);
                lockBtn($btn);
                postJson('/llm/bom-wizard/bom/save-full', payload, function (res) {
                    layer.close(loadIdx);
                    if (res.code !== 0) {
                        unlockBtn($btn);
                        layer.alert(res.msg || '保存失败', { icon: 2, title: 'BOM保存校验未通过' });
                        return;
                    }
                    var d = res.data || {};
                    wizard.bom = { bomCode: d.bomCode, headerMaterielCode: payload.header.materielCode, materielDesc: payload.header.materielDesc };
                    wizard.done[2] = true;
                    layer.msg('BOM 已保存并定版' + (d.childBomCount ? '，自动生成子BOM ' + d.childBomCount + ' 个' : ''), { icon: 1 });
                    renderOpers();
                    renderStep(3);
                });
            });
        });

        // ==================== 步骤③：工艺审核 ====================
        function loadUnits(cb) {
            if (wizard.units.length) { if (cb) cb(); return; }
            $.get(ctx + '/basedata/processing-unit/list', function (res) {
                if (res.code === 0) wizard.units = res.data || [];
                if (cb) cb();
            }, 'json');
        }
        function defaultUnitId() {
            for (var i = 0; i < wizard.units.length; i++) {
                var u = wizard.units[i];
                if (u.unitType === 'person' && u.status === '0') return u.id;
            }
            return wizard.units.length ? wizard.units[0].id : '';
        }
        function unitOptions(sel) {
            var h = '<option value="">请选择加工单元</option>';
            wizard.units.forEach(function (u) {
                h += '<option value="' + u.id + '"' + (u.id === sel ? ' selected' : '') + '>'
                    + esc(u.unitName) + '（' + ('device' === u.unitType ? '设备' : '人员') + '）</option>';
            });
            return h;
        }
        function operRowHtml(op) {
            var matched = op.matched === true && op.operId;
            var unitCell;
            if (matched) {
                unitCell = '<span data-unitid="' + esc(op.unitId || '') + '">' + esc(op.unitName || '') + '</span>';
            } else {
                unitCell = '<select class="p-unit">' + unitOptions(op.unitId || defaultUnitId()) + '</select>';
            }
            return '<tr class="' + (matched ? '' : 'unmatched') + '" data-operid="' + esc(op.operId || '') + '">'
                + '<td style="text-align:center;"><i class="fa fa-arrow-up row-move mv-up"></i><i class="fa fa-arrow-down row-move mv-down"></i></td>'
                + '<td><input class="p-desc" value="' + esc(op.operDesc) + '"' + (matched ? ' readonly style="color:#888;"' : '') + '></td>'
                + '<td>' + esc(op.oper || '自动生成') + '</td>'
                + '<td>' + unitCell + '</td>'
                + '<td><input class="p-hours" type="number" min="1" value="' + esc(op.operHours != null ? op.operHours : 1) + '"' + (matched ? ' readonly style="color:#888;"' : '') + '></td>'
                + '<td><input class="p-cycle" type="number" min="1" value="' + esc(op.manuCycle != null ? op.manuCycle : 2) + '"' + (matched ? ' readonly style="color:#888;"' : '') + '></td>'
                + '<td><span class="badge ' + (matched ? 'ok' : 'no') + '">' + (matched ? '已匹配' : '将新建，请确认加工单元') + '</span></td>'
                + '<td><i class="fa fa-trash-o row-del"></i></td>'
                + '</tr>';
        }
        function renderOpers() {
            loadUnits(function () {
                var opers = wizard.draft.opers || [];
                var html = '';
                opers.forEach(function (op) { html += operRowHtml(op); });
                $('#js-opers').html(html);
                $('#js-oper-tip').text('AI 建议 ' + opers.length + ' 道工序，已匹配 ' + (wizard.draft.operMatchedCount || 0)
                    + ' 道；未匹配工序保存时将自动新建。');
                form.render('select');
            });
        }
        $('#js-add-oper').on('click', function () {
            loadUnits(function () {
                $('#js-opers').append(operRowHtml({ matched: false, operHours: 1, manuCycle: 2 }));
                form.render('select');
            });
        });
        $('#js-opers').on('click', '.row-del', function () { $(this).closest('tr').remove(); });
        $('#js-opers').on('click', '.mv-up', function () {
            var $tr = $(this).closest('tr');
            $tr.prev().before($tr);
        });
        $('#js-opers').on('click', '.mv-down', function () {
            var $tr = $(this).closest('tr');
            $tr.next().after($tr);
        });

        $('#js-create-flow').on('click', function () {
            var $btn = $(this);
            var opers = [];
            var valid = true;
            $('#js-opers tr').each(function (idx) {
                var $t = $(this);
                var operId = $t.data('operid') || '';
                var unitId = operId ? ($t.find('span[data-unitid]').data('unitid') || '') : ($t.find('.p-unit').val() || '');
                var desc = $.trim($t.find('.p-desc').val());
                if (!desc) valid = false;
                if (!operId && !unitId) valid = false;
                opers.push({
                    operId: operId,
                    operDesc: desc,
                    unitId: unitId,
                    operHours: parseInt($t.find('.p-hours').val()) || 1,
                    manuCycle: parseInt($t.find('.p-cycle').val()) || 1,
                    sortNum: idx + 1
                });
            });
            if (opers.length < 2) { layer.msg('工艺路线至少需要两道工序'); return; }
            if (!valid) { layer.msg('存在未填写名称或未选择加工单元的工序行'); return; }
            var loadIdx = layer.load(2);
            lockBtn($btn);
            postJson('/llm/bom-wizard/flow/create', {
                productName: wizard.gen.productName,
                opers: opers
            }, function (res) {
                layer.close(loadIdx);
                if (res.code !== 0) {
                    unlockBtn($btn);
                    layer.alert(res.msg || '工艺路线创建失败', { icon: 2, title: '工艺创建未通过' });
                    return;
                }
                wizard.flow = res.data || {};
                wizard.done[3] = true;
                layer.msg('工艺路线创建成功' + ((res.data && res.data.createdOperCount) ? '，新建工序 ' + res.data.createdOperCount + ' 道' : ''), { icon: 1 });
                initOrderStep();
                renderStep(4);
            });
        });

        // ==================== 步骤④：工单与排人 ====================
        function initOrderStep() {
            $('#o-materiel').val(wizard.bom.headerMaterielCode || '');
            $('#o-materielDesc').val(wizard.bom.materielDesc || wizard.gen.productName);
            $('#o-desc').val((wizard.gen.productName || '') + ' AI智能建模工单');
            $('#js-flow-summary').html('工艺路线：<b>' + esc(wizard.flow.flow || '') + '</b>　时序：<b>' + esc(wizard.flow.process || '') + '</b>');
            previewAssign();
        }
        function assignRowHtml(a, idx) {
            var warn = a.warn || '';
            var userCell = a.userName ? esc(a.userName) : '<span style="color:#c0392b;">未分配</span>';
            return '<tr class="' + (warn ? 'warnrow' : '') + '" data-idx="' + idx + '">'
                + '<td style="text-align:center;">' + esc(a.sortNum) + '</td>'
                + '<td>' + esc(a.operDesc || a.oper) + '</td>'
                + '<td>' + esc(a.unitName) + '</td>'
                + '<td class="a-team">' + esc(a.teamName || '') + '</td>'
                + '<td class="a-user">' + userCell + '</td>'
                + '<td style="text-align:center;" class="a-load">' + (a.currentLoad != null ? esc(a.currentLoad) : '-') + '</td>'
                + '<td style="color:#c0392b;font-size:12px;">' + esc(warn) + '</td>'
                + '<td>' + (a.unitId ? '<a href="javascript:;" class="a-change" style="color:#2563EB;">改人</a>' : '') + '</td>'
                + '</tr>';
        }
        function previewAssign() {
            if (!wizard.flow.flowId) { layer.msg('缺少工艺路线'); return; }
            var loadIdx = layer.load(2);
            postJson('/llm/bom-wizard/order/preview-assign', { flowId: wizard.flow.flowId }, function (res) {
                layer.close(loadIdx);
                if (res.code !== 0) { layer.msg(res.msg || '分配预览失败'); return; }
                wizard.assigns = res.data || [];
                var html = '';
                wizard.assigns.forEach(function (a, idx) { html += assignRowHtml(a, idx); });
                $('#js-assigns').html(html);
            });
        }
        $('#js-refresh-assign').on('click', previewAssign);

        // 改人：弹层展示该工序加工单元的候选员工（含当前负载）
        $('#js-assigns').on('click', '.a-change', function () {
            var idx = parseInt($(this).closest('tr').data('idx'));
            var a = wizard.assigns[idx];
            if (!a || !a.unitId) return;
            $.get(ctx + '/llm/bom-wizard/assign/candidates', { unitId: a.unitId }, function (res) {
                if (res.code !== 0) { layer.msg(res.msg || '查询候选失败'); return; }
                var cands = res.data || [];
                if (!cands.length) { layer.msg('该加工单元未绑定班组或班组无人'); return; }
                var html = '<div style="max-height:300px;overflow:auto;">';
                cands.forEach(function (c, i) {
                    html += '<div class="cand-item' + (c.userId === a.userId ? ' sel' : '') + '" data-i="' + i + '">'
                        + esc(c.userName) + '　<span class="sp-tip">' + esc(c.teamName) + '</span>'
                        + '<span class="cand-load">负载 ' + esc(c.currentLoad) + '</span></div>';
                });
                html += '</div>';
                var layerIdx = layer.open({
                    type: 1, title: '选择执行人 - ' + (a.operDesc || a.oper),
                    area: ['360px', '380px'], content: html
                });
                $('.cand-item').off('click').on('click', function () {
                    var c = cands[parseInt($(this).data('i'))];
                    a.teamId = c.teamId; a.teamName = c.teamName;
                    a.userId = c.userId; a.userName = c.userName;
                    a.currentLoad = c.currentLoad;
                    a.warn = '';
                    var $tr = $('#js-assigns tr[data-idx=' + idx + ']');
                    $tr.removeClass('warnrow');
                    $tr.find('.a-team').text(c.teamName || '');
                    $tr.find('.a-user').text(c.userName || '');
                    $tr.find('.a-load').text(c.currentLoad != null ? c.currentLoad : '-');
                    layer.close(layerIdx);
                });
            }, 'json');
        });

        $('#js-create-order').on('click', function () {
            var $btn = $(this);
            var qty = parseInt($('#o-qty').val());
            if (!qty || qty <= 0) { layer.msg('工单数量必须大于 0'); return; }
            if (!$('#o-planStart').val() || !$('#o-planEnd').val()) { layer.msg('请选择计划开始和结束时间'); return; }
            for (var i = 0; i < wizard.assigns.length; i++) {
                if (!wizard.assigns[i].userId) {
                    layer.alert('工序【' + (wizard.assigns[i].operDesc || wizard.assigns[i].oper) + '】未指定执行人，'
                        + '请先在「加工单元定义」绑定班组、「班组员工定义」维护成员，或点击改人手动指定。',
                        { icon: 2, title: '人员分配不完整' });
                    return;
                }
            }
            var payload = {
                order: {
                    orderDescription: $('#o-desc').val(),
                    qty: qty,
                    materiel: $('#o-materiel').val(),
                    materielDesc: $('#o-materielDesc').val(),
                    flowId: wizard.flow.flowId,
                    planStartTime: $('#o-planStart').val(),
                    planEndTime: $('#o-planEnd').val()
                },
                assigns: wizard.assigns
            };
            var loadIdx = layer.load(2);
            lockBtn($btn);
            postJson('/llm/bom-wizard/order/create-with-assign', payload, function (res) {
                layer.close(loadIdx);
                if (res.code !== 0) {
                    unlockBtn($btn);
                    layer.alert(res.msg || '工单创建失败', { icon: 2, title: '工单创建未通过' });
                    return;
                }
                wizard.done[4] = true;
                var d = res.data || {};
                $('#js-done-summary').html(
                    'BOM编码：<b>' + esc(wizard.bom.bomCode) + '</b>（物料 ' + esc(wizard.bom.headerMaterielCode) + '）<br>'
                    + '工艺路线：<b>' + esc(wizard.flow.flow) + '</b>　' + esc(wizard.flow.process || '') + '<br>'
                    + '工单编号：<b>' + esc(d.orderCode) + '</b>（待审批，可在「工单下达」中审批）<br>'
                    + '工序人员分配：<b>' + esc(d.assignCount) + '</b> 条');
                renderStep(5);
            });
        });

        // ==================== 完成页 ====================
        $('#js-restart').on('click', function () {
            window.location.reload();
        });

        renderStep(1);
    });
</script>
</body>
</html>
