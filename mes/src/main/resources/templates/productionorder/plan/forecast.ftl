<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>生成预测订单明细</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body { background:#f5f7fa; }
        .fc-shell { padding:16px 18px; }
        .fc-head { margin-bottom:12px; padding:14px 16px; border:1px solid #dbe5ef; border-radius:8px; background:#fff; box-shadow:0 10px 24px rgba(15,23,42,.06); }
        .fc-head h2 { margin:0; font-size:18px; font-weight:800; color:#17212b; }
        .fc-head p { margin:7px 0 0; color:#607184; line-height:1.6; }
        .fc-card { border:1px solid #d9e3ec; border-radius:8px; background:#fff; box-shadow:0 8px 20px rgba(15,23,42,.05); }
        .fc-body { padding:14px 16px 4px; }
        .fc-pick { display:flex; gap:6px; }
        .fc-pick .layui-input { flex:1; }
        .fc-pick .layui-btn { width:40px; padding:0; border-radius:6px; }
        .fc-preview { padding:14px 16px 16px; background:#f5f7fa; }
        .fc-preview table { width:100%; border-collapse:separate; border-spacing:0; }
        .fc-preview th { height:34px; background:#f8fafc; color:#64748b; border-bottom:1px solid #e5edf5; }
        .fc-preview td { padding:8px 6px; border-bottom:1px solid #eef3f7; }
        .fc-preview b { color:#1456a0; }
    </style>
</head>
<body>
<div class="fc-shell">
    <div class="fc-head">
        <h2>规则版销售预测</h2>
        <p>按产品和客户读取近6个月需求订单，结合趋势系数、季节系数和目标产能，生成未来月度预测明细。</p>
    </div>
    <form class="layui-form fc-card" lay-filter="js-fc-form">
        <div class="fc-body">
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">产品物料</label>
                <div class="layui-input-block fc-pick">
                    <input id="js-product-materiel" name="productMateriel" readonly lay-verify="required" class="layui-input">
                    <button type="button" id="js-pick-product" class="layui-btn"><i class="layui-icon layui-icon-search"></i></button>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">产品名称</label>
                <div class="layui-input-block"><input id="js-product-name" name="productName" lay-verify="required" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">客户名称</label>
                <div class="layui-input-block"><input name="customerName" lay-verify="required" class="layui-input"></div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">首月开工</label>
                    <div class="layui-input-inline"><input id="js-first-start" name="firstPlanStartDate" class="layui-input"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">预测周期</label>
                    <div class="layui-input-inline">
                        <select name="months">
                            <option value="3">3个月</option>
                            <option value="6" selected>6个月</option>
                            <option value="12">12个月</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">趋势系数</label>
                    <div class="layui-input-inline"><input name="trendFactor" type="number" step="0.01" min="0.01" class="layui-input" value="1.00"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">季节系数</label>
                    <div class="layui-input-inline"><input name="seasonFactor" type="number" step="0.01" min="0.01" class="layui-input" value="1.00"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">提前期</label>
                    <div class="layui-input-inline"><input id="js-lead" name="leadTimeDays" type="number" min="1" class="layui-input" value="1"></div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">产能/日</label>
                    <div class="layui-input-inline"><input name="targetCapacity" type="number" step="0.01" min="0.01" class="layui-input" value="5"></div>
                </div>
                <div class="layui-inline">
                    <button type="button" id="js-preview" class="layui-btn"><i class="fa fa-line-chart"></i>生成预览</button>
                </div>
            </div>
        </div>
        <div class="fc-preview sp-production-detail-table">
            <table>
                <thead><tr><th>月份开工</th><th>预测数量</th><th>预计交付</th><th>说明</th></tr></thead>
                <tbody id="js-preview-body"><tr><td colspan="4" style="text-align:center;color:#94a3b8;">尚未生成</td></tr></tbody>
            </table>
        </div>
        <div class="layui-hide"><button id="js-submit" lay-submit lay-filter="js-submit-filter">确定</button></div>
    </form>
</div>
<script>
    layui.use(['form', 'laydate', 'layer', 'spLayer'], function(){
        var form = layui.form, laydate = layui.laydate, spLayer = layui.spLayer;
        var previewRows = [];
        laydate.render({elem:'#js-first-start', trigger:'click', format:'yyyy-MM-dd', zIndex:99999999});
        $('#js-first-start').val(new Date().toISOString().slice(0, 10));
        $('#js-pick-product').on('click', function(){
            spLayer.open({
                type:2,
                title:'选择预测产品',
                area:['760px','520px'],
                reload:false,
                content:'${request.contextPath}/admin/common/ui/searchPanelMaterile',
                spCallback:function(result){
                    if (result && result.code === 0 && result.data && result.data.length) {
                        var mat = result.data[0];
                        $('#js-product-materiel').val(mat.materiel || '');
                        $('#js-product-name').val(mat.materielDesc || '');
                        $('#js-lead').val(mat.leadTime || 1);
                    }
                }
            });
        });
        $('#js-preview').on('click', function(){ generate(false); });
        form.on('submit(js-submit-filter)', function(){
            if (!previewRows.length) generate(true);
            window.spChildFrameResult = {code:0, msg:'操作成功', data:previewRows};
            return false;
        });
        function generate(sync) {
            var data = form.val('js-fc-form');
            spUtil.ajax({
                url:'${request.contextPath}/production-order/plan/forecast/generate',
                type:'POST',
                async: sync ? false : true,
                serializable:true,
                data:data,
                showLoading:!sync,
                success:function(res){
                    previewRows = res.data || [];
                    renderPreview();
                }
            });
        }
        function renderPreview() {
            var html = [];
            $.each(previewRows, function(_, row){
                html.push('<tr><td><b>' + esc(row.planStartDate) + '</b></td><td>' + esc(row.qty) + '</td><td>' + esc(row.computedDeliveryDate || row.planDeliveryDate) + '</td><td>' + esc(row.configuration) + '</td></tr>');
            });
            if (!html.length) html.push('<tr><td colspan="4" style="text-align:center;color:#94a3b8;">没有生成结果</td></tr>');
            $('#js-preview-body').html(html.join(''));
        }
        function esc(v) { return $('<div/>').text(v == null ? '' : v).html(); }
        form.render();
    });
</script>
</body>
</html>
