<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>维护生产订单</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body { background:#f4f7fa; color:#17212b; }
        .po-form { padding:16px 18px 8px; }
        .po-head { display:flex; justify-content:space-between; align-items:flex-start; gap:14px; margin-bottom:14px; padding:14px 16px; border:1px solid #dbe5ef; border-radius:8px; background:#fff; box-shadow:0 10px 24px rgba(15,23,42,.06); }
        .po-head h2 { margin:0; font-size:19px; font-weight:800; letter-spacing:0; }
        .po-head p { margin:7px 0 0; color:#607184; line-height:1.6; }
        .po-badge { display:inline-flex; align-items:center; height:30px; padding:0 12px; border-radius:999px; border:1px solid #dce6ef; background:#f8fafc; color:#173a5e; font-weight:800; white-space:nowrap; }
        .po-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
        .po-card { border:1px solid #d9e3ec; border-radius:8px; background:#fff; box-shadow:0 8px 20px rgba(15,23,42,.05); overflow:hidden; }
        .po-card h3 { margin:0; padding:11px 14px; border-bottom:1px solid #edf2f7; font-size:14px; font-weight:800; background:#fbfcfe; }
        .po-card-body { padding:13px 14px 2px; }
        .po-wide { grid-column:1 / -1; }
        .po-line-actions { display:flex; justify-content:space-between; align-items:center; gap:10px; padding:11px 14px; border-bottom:1px solid #edf2f7; background:#fbfcfe; }
        .po-items-wrap { overflow:auto; }
        .po-items { width:100%; border-collapse:separate; border-spacing:0; table-layout:fixed; }
        .po-items th { height:36px; color:#65758a; font-weight:700; background:#f7fafc; border-bottom:1px solid #e4ebf2; font-size:12px; }
        .po-items td { padding:7px 6px; border-bottom:1px solid #eef3f7; vertical-align:top; }
        .po-items input, .po-items select { height:32px; border-radius:6px; }
        .po-pick { display:flex; gap:5px; }
        .po-pick input { flex:1; }
        .po-pick .layui-btn { width:34px; padding:0; border-radius:6px; }
        .po-read { min-height:32px; line-height:32px; padding:0 9px; border-radius:6px; color:#1456a0; background:#edf5ff; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .po-plan-preview { padding:12px 14px; color:#607184; background:#fbfcfe; border-top:1px solid #edf2f7; line-height:1.7; }
        .po-plan-preview b { color:#16202a; }
        .po-del { width:30px; padding:0; }
        .po-forecast-only { display:none; }
        .is-forecast .po-forecast-only { display:inline-block; }
        .is-forecast .po-demand-copy { display:none; }
        @media (max-width: 880px) {
            .po-grid { grid-template-columns:1fr; }
            .po-head { flex-direction:column; }
        }
    </style>
</head>
<body>
<#assign sourceType=(result.sourceType)!'DEMAND'>
<#assign schedulingMethod=(result.schedulingMethod)!''>
<#if schedulingMethod == ''>
    <#if sourceType == 'FORECAST'>
        <#assign schedulingMethod='FORWARD'>
    <#else>
        <#assign schedulingMethod='REVERSE'>
    </#if>
</#if>
<div class="po-form <#if sourceType == 'FORECAST'>is-forecast</#if>">
    <div class="po-head">
        <div>
            <h2><#if sourceType == 'FORECAST'>预测订单<#else>需求订单</#if> - ${(result.orderNo)!''}</h2>
            <p class="po-demand-copy">需求订单默认按交付日期逆向排产，倒推最早开工时间，并生成工序级时间线。</p>
            <p class="po-forecast-only">预测订单默认按计划开工日期正向排产，适合滚动预测和资源预占。</p>
        </div>
        <span class="po-badge"><#if sourceType == 'FORECAST'>FORECAST<#else>DEMAND</#if></span>
    </div>
    <form class="layui-form" lay-filter="js-po-form">
        <input type="hidden" name="id" value="${(result.id)!}">
        <input type="hidden" name="orderNo" value="${(result.orderNo)!}">
        <input type="hidden" name="sourceType" value="${sourceType}">
        <div class="po-grid">
            <section class="po-card">
                <h3>订单信息</h3>
                <div class="po-card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">订单编号</label>
                        <div class="layui-input-block"><input readonly class="layui-input" value="${(result.orderNo)!}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">客户名称</label>
                        <div class="layui-input-block"><input name="customerName" lay-verify="required" autocomplete="off" class="layui-input" value="${(result.customerName)!}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">客户分组</label>
                        <div class="layui-input-block"><input name="customerGroup" autocomplete="off" class="layui-input" value="${(result.customerGroup)!}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">外部订单号</label>
                        <div class="layui-input-block"><input name="externalNo" autocomplete="off" class="layui-input" value="${(result.externalNo)!}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">销售合同号</label>
                        <div class="layui-input-block"><input name="salesContractNo" autocomplete="off" class="layui-input" value="${(result.salesContractNo)!}"></div>
                    </div>
                </div>
            </section>
            <section class="po-card">
                <h3>排产控制</h3>
                <div class="po-card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">业务类型</label>
                        <div class="layui-input-block"><input name="businessType" autocomplete="off" class="layui-input" value="${(result.businessType)!'普通销售'}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">订单日期</label>
                        <div class="layui-input-block"><input id="js-order-date" name="orderDate" autocomplete="off" class="layui-input" value="${(result.orderDate)!}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">排产方式</label>
                        <div class="layui-input-block">
                            <select name="schedulingMethod" id="js-scheduling-method" lay-filter="js-scheduling-method">
                                <option value="REVERSE" <#if schedulingMethod == 'REVERSE'>selected</#if>>逆向排产</option>
                                <option value="FORWARD" <#if schedulingMethod == 'FORWARD'>selected</#if>>正向排产</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">结算币种</label>
                        <div class="layui-input-block"><input name="settlementCurrency" autocomplete="off" class="layui-input" value="${(result.settlementCurrency)!'人民币'}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">税率</label>
                        <div class="layui-input-block"><input name="taxRate" autocomplete="off" class="layui-input" value="${(result.taxRate)!'不含税'}"></div>
                    </div>
                </div>
            </section>
            <section class="po-card po-wide">
                <div class="po-line-actions">
                    <h3 style="padding:0;border:0;background:transparent;">产品BOM与计划明细</h3>
                    <div>
                        <button type="button" class="layui-btn layui-btn-primary layui-btn-sm po-forecast-only" id="js-generate-forecast"><i class="fa fa-line-chart"></i>生成预测明细</button>
                        <button type="button" class="layui-btn layui-btn-sm" id="js-add-item"><i class="layui-icon">&#xe61f;</i>新增明细</button>
                    </div>
                </div>
                <div class="po-items-wrap sp-production-detail-table">
                    <table class="po-items">
                        <thead>
                        <tr>
                            <th style="width:190px;">产品BOM</th>
                            <th style="width:130px;">产品物料</th>
                            <th style="width:140px;">产品名称</th>
                            <th style="width:82px;">BOM版本</th>
                            <th style="width:72px;">数量</th>
                            <th style="width:82px;">单价</th>
                            <th style="width:118px;">计划交付</th>
                            <th style="width:118px;">计划开工</th>
                            <th style="width:78px;">提前期</th>
                            <th style="width:85px;">产能/日</th>
                            <th style="width:118px;">建议开工</th>
                            <th style="width:118px;">预计交付</th>
                            <th style="width:118px;">建议备料</th>
                            <th style="width:150px;">配置要求</th>
                            <th style="width:44px;"></th>
                        </tr>
                        </thead>
                        <tbody id="js-items"></tbody>
                    </table>
                </div>
                <div class="po-plan-preview" id="js-plan-preview">请选择产品BOM并填写数量、日期、提前期和目标产能。</div>
            </section>
            <section class="po-card po-wide">
                <h3>收货与备注</h3>
                <div class="po-card-body">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">运输方式</label>
                            <div class="layui-input-inline"><input name="transportMode" autocomplete="off" class="layui-input" value="${(result.transportMode)!}"></div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">收货人</label>
                            <div class="layui-input-inline"><input name="receiverName" autocomplete="off" class="layui-input" value="${(result.receiverName)!}"></div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">电话</label>
                            <div class="layui-input-inline"><input name="receiverPhone" autocomplete="off" class="layui-input" value="${(result.receiverPhone)!}"></div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">收货地址</label>
                        <div class="layui-input-block"><input name="receiverAddress" autocomplete="off" class="layui-input" value="${(result.receiverAddress)!}"></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注</label>
                        <div class="layui-input-block"><textarea name="remark" class="layui-textarea">${(result.remark)!}</textarea></div>
                    </div>
                </div>
            </section>
        </div>
        <div class="layui-hide"><button id="js-submit" lay-submit lay-filter="js-submit-filter">提交</button></div>
    </form>
</div>

<script>
    layui.use(['form', 'laydate', 'layer', 'spLayer'], function () {
        var form = layui.form, laydate = layui.laydate, layer = layui.layer, spLayer = layui.spLayer;
        var sourceType = '${sourceType}';
        var items = ${itemsJson!'[]'};
        var rowSeq = 0;

        laydate.render({elem:'#js-order-date', trigger:'click', format:'yyyy-MM-dd', zIndex:99999999});
        if (!items || !items.length) items = [emptyItem()];
        $.each(items, function(_, item){ appendRow(item); });
        refreshPreview();

        $('#js-add-item').on('click', function(){ appendRow(emptyItem()); refreshPreview(); });
        $('#js-items').on('click', '.js-del', function(){
            if ($('#js-items tr').length <= 1) { layer.msg('至少保留一条明细'); return; }
            $(this).closest('tr').remove();
            refreshPreview();
        });
        $('#js-items').on('input change', 'input', refreshPreview);
        form.on('select(js-scheduling-method)', function(){ refreshPreview(); });
        $('#js-items').on('click', '.js-pick-bom', function(){
            var $tr = $(this).closest('tr');
            spLayer.open({
                type:2,
                title:'选择最新定版产品BOM',
                area:['820px','560px'],
                reload:false,
                content:'${request.contextPath}/technology/bom/select-bom-panel-ui',
                spCallback:function(result){
                    if (result && result.code === 0 && result.data && result.data.length) {
                        var bom = result.data[0];
                        $tr.find('.i-bom-id').val(bom.id || '');
                        $tr.find('.i-bom-code').val(bom.bomCode || '');
                        $tr.find('.i-bom-version').val(bom.versionNumber || '');
                        $tr.find('.i-product-materiel').val(bom.materielCode || '');
                        $tr.find('.i-product-name').val(bom.materielDesc || '');
                        refreshPreview();
                    }
                }
            });
        });
        $('#js-generate-forecast').on('click', function(){
            spLayer.open({
                type:2,
                title:'生成预测明细',
                area:['780px','560px'],
                reload:false,
                content:'${request.contextPath}/production-order/plan/forecast-ui',
                spCallback:function(result){
                    if (result && result.code === 0 && result.data && result.data.length) {
                        $('#js-items').empty();
                        $.each(result.data, function(_, item){ appendRow(item); });
                        refreshPreview();
                    }
                }
            });
        });

        function emptyItem() {
            var today = new Date();
            return {qty:1, leadTimeDays:1, targetCapacity:5, planStartDate: fmt(today), planDeliveryDate: fmt(addDays(today, 5))};
        }
        function appendRow(item) {
            rowSeq++;
            item = item || emptyItem();
            var idp = 'po-date-' + rowSeq + '-';
            var html = '<tr>' +
                '<td><input type="hidden" class="i-bom-id" value="' + esc(item.bomId) + '"><div class="po-pick"><input readonly class="layui-input i-bom-code" value="' + esc(item.bomCode) + '"><button type="button" class="layui-btn js-pick-bom"><i class="layui-icon layui-icon-search"></i></button></div></td>' +
                '<td><input readonly class="layui-input i-product-materiel" value="' + esc(item.productMateriel) + '"></td>' +
                '<td><input readonly class="layui-input i-product-name" value="' + esc(item.productName) + '"></td>' +
                '<td><input readonly class="layui-input i-bom-version" value="' + esc(item.bomVersion) + '"></td>' +
                '<td><input type="number" min="1" class="layui-input i-qty" value="' + esc(item.qty || 1) + '"></td>' +
                '<td><input type="number" min="0" step="0.01" class="layui-input i-price" value="' + esc(item.unitPrice) + '"></td>' +
                '<td><input id="' + idp + 'delivery" class="layui-input i-delivery" value="' + esc(item.planDeliveryDate) + '"></td>' +
                '<td><input id="' + idp + 'start" class="layui-input i-start" value="' + esc(item.planStartDate) + '"></td>' +
                '<td><input type="number" min="0" class="layui-input i-lead" value="' + esc(item.leadTimeDays == null ? 1 : item.leadTimeDays) + '"></td>' +
                '<td><input type="number" min="0.01" step="0.01" class="layui-input i-capacity" value="' + esc(item.targetCapacity || 5) + '"></td>' +
                '<td><div class="po-read i-computed-start">' + esc(item.computedStartDate) + '</div></td>' +
                '<td><div class="po-read i-computed-delivery">' + esc(item.computedDeliveryDate) + '</div></td>' +
                '<td><div class="po-read i-material-ready">' + esc(item.materialReadyDate) + '</div></td>' +
                '<td><input class="layui-input i-configuration" value="' + esc(item.configuration) + '"></td>' +
                '<td><button type="button" class="layui-btn layui-btn-danger layui-btn-xs po-del js-del"><i class="layui-icon layui-icon-delete"></i></button></td>' +
                '</tr>';
            $('#js-items').append(html);
            laydate.render({elem:'#' + idp + 'delivery', trigger:'click', format:'yyyy-MM-dd', zIndex:99999999, done:refreshPreview});
            laydate.render({elem:'#' + idp + 'start', trigger:'click', format:'yyyy-MM-dd', zIndex:99999999, done:refreshPreview});
        }
        function refreshPreview() {
            var method = $('#js-scheduling-method').val();
            var fragments = [];
            $('#js-items tr').each(function(i){
                var $tr = $(this);
                var qty = parseInt($tr.find('.i-qty').val(), 10) || 0;
                var capacity = parseFloat($tr.find('.i-capacity').val()) || 5;
                var lead = parseInt($tr.find('.i-lead').val(), 10) || 0;
                var prodDays = Math.max(1, Math.ceil(qty / Math.max(capacity, 0.01)));
                var start = parseDate($tr.find('.i-start').val());
                var delivery = parseDate($tr.find('.i-delivery').val());
                var computedStart = '';
                var computedDelivery = '';
                var materialReady = '';
                // 口径与后端一致：生产跨度=prodDays(不含备料)，备料提前期在开工日之前。
                if (method === 'FORWARD') {
                    if (start) {
                        computedStart = fmt(start);
                        computedDelivery = fmt(addWorkDays(start, prodDays));
                        materialReady = fmt(addWorkDays(start, -lead));
                    }
                } else {
                    if (delivery) {
                        computedDelivery = fmt(delivery);
                        var s = addWorkDays(delivery, -prodDays);
                        computedStart = fmt(s);
                        materialReady = fmt(addWorkDays(s, -lead));
                    }
                }
                $tr.find('.i-computed-start').text(computedStart || '-');
                $tr.find('.i-computed-delivery').text(computedDelivery || '-');
                $tr.find('.i-material-ready').text(materialReady || '-');
                fragments.push('第' + (i + 1) + '行：' + (method === 'FORWARD' ? '正向' : '逆向') + '，约' + prodDays + '个工作日生产，备料提前期' + lead + '天，建议备料 ' + (materialReady || '-') + '，建议开工 ' + (computedStart || '-') + '，预计交付 ' + (computedDelivery || '-'));
            });
            $('#js-plan-preview').html('<b>排产预览：</b>' + fragments.join('；'));
        }
        function collectItems() {
            var rows = [];
            $('#js-items tr').each(function(){
                var $tr = $(this);
                rows.push({
                    bomId: $tr.find('.i-bom-id').val(),
                    bomCode: $tr.find('.i-bom-code').val(),
                    bomVersion: $tr.find('.i-bom-version').val(),
                    productMateriel: $tr.find('.i-product-materiel').val(),
                    productName: $tr.find('.i-product-name').val(),
                    qty: parseInt($tr.find('.i-qty').val(), 10) || 0,
                    unitPrice: $tr.find('.i-price').val(),
                    planDeliveryDate: $tr.find('.i-delivery').val(),
                    planStartDate: $tr.find('.i-start').val(),
                    leadTimeDays: parseInt($tr.find('.i-lead').val(), 10) || 0,
                    targetCapacity: $tr.find('.i-capacity').val() || 5,
                    computedStartDate: $tr.find('.i-computed-start').text(),
                    computedDeliveryDate: $tr.find('.i-computed-delivery').text(),
                    materialReadyDate: $tr.find('.i-material-ready').text(),
                    configuration: $tr.find('.i-configuration').val()
                });
            });
            return rows;
        }
        form.on('submit(js-submit-filter)', function(data){
            refreshPreview();
            var order = data.field;
            if (sourceType === 'DEMAND' && order.schedulingMethod === 'REVERSE') {
                var missingDelivery = false;
                $('#js-items .i-delivery').each(function(){ if (!$(this).val()) missingDelivery = true; });
                if (missingDelivery) { layer.msg('需求订单逆向排产必须填写计划交付日期'); return false; }
            }
            if (sourceType === 'FORECAST' && order.schedulingMethod === 'FORWARD') {
                var missingStart = false;
                $('#js-items .i-start').each(function(){ if (!$(this).val()) missingStart = true; });
                if (missingStart) { layer.msg('预测订单正向排产必须填写计划开工日期'); return false; }
            }
            var payload = {order:order, items:collectItems()};
            spUtil.ajax({
                url:'${request.contextPath}/production-order/plan/add-or-update',
                type:'POST',
                async:false,
                serializable:true,
                data:payload,
                success:function(res){ window.spChildFrameResult = res; }
            });
            return false;
        });
        function parseDate(v) {
            if (!v) return null;
            var d = new Date(v.replace(/-/g, '/'));
            return isNaN(d.getTime()) ? null : d;
        }
        function addDays(date, days) {
            var d = new Date(date.getTime());
            d.setDate(d.getDate() + days);
            return d;
        }
        function addWorkDays(date, days) {
            var d = new Date(date.getTime());
            var step = days >= 0 ? 1 : -1;
            var left = Math.abs(days);
            while (left > 0) {
                d.setDate(d.getDate() + step);
                if (d.getDay() !== 0 && d.getDay() !== 6) left--;
            }
            return d;
        }
        function fmt(date) {
            var m = date.getMonth() + 1, day = date.getDate();
            return date.getFullYear() + '-' + (m < 10 ? '0' + m : m) + '-' + (day < 10 ? '0' + day : day);
        }
        function esc(v) { return $('<div/>').text(v == null ? '' : v).html(); }
        form.render();
    });
</script>
</body>
</html>
