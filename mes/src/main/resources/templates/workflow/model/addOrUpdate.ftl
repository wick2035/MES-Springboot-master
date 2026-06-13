<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程模型设计</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-form-wrap wf-designer">
    <form class="layui-form splayui-form">
        <input type="hidden" name="id" value="${(result.id)!}">
        <div class="wf-editor-grid">
            <section class="wf-editor-section">
                <h3>模型档案</h3>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">流程分类</label>
                    <div class="layui-input-block">
                        <select name="categoryId" lay-verify="required">
                            <#list categories as category>
                                <option value="${category.id}" <#if ((result.categoryId)!'') == category.id>selected</#if>>${category.categoryName} / ${category.categoryCode}</option>
                            </#list>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">业务类型</label>
                    <div class="layui-input-block"><input name="businessType" lay-verify="required" class="layui-input" value="${(result.businessType)!'ORDER_APPROVAL'}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">模型名称</label>
                    <div class="layui-input-block"><input name="modelName" lay-verify="required" class="layui-input" value="${(result.modelName)!}" placeholder="生产订单审批流程"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">模型编码</label>
                    <div class="layui-input-block"><input name="modelCode" lay-verify="required" class="layui-input" value="${(result.modelCode)!}" placeholder="order_approval"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">处理角色</label>
                    <div class="layui-input-block">
                        <select id="js-role" lay-filter="js-role-filter">
                            <option value="">请选择</option>
                            <#list roles as role>
                                <option value="${role.code}" data-name="${role.name}">${role.name} / ${role.code}</option>
                            </#list>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-block"><textarea name="remark" class="layui-textarea">${(result.remark)!}</textarea></div>
                </div>
            </section>
            <section class="wf-editor-section">
                <h3>流程预览</h3>
                <div id="js-flow-preview" class="wf-flow-preview"></div>
                <div class="wf-preset-row" style="margin-top:12px;">
                    <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-default-json"><i class="fa fa-magic"></i>生成订单审批模型</button>
                    <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-preview-json"><i class="fa fa-eye"></i>刷新预览</button>
                </div>
                <div class="wf-form-tip">事件模板只生成 ORDER_APPROVE，审批通过后由安全事件服务同步订单状态。</div>
            </section>
        </div>
        <section class="wf-editor-section wf-editor-wide">
            <h3>节点 JSON</h3>
            <textarea id="js-node-json" name="nodeJson" lay-verify="required" class="layui-textarea wf-json">${(result.nodeJson)!}</textarea>
        </section>
        <div class="layui-hide">
            <input type="hidden" name="status" value="${(result.status)!'draft'}">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">保存</button>
        </div>
    </form>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;
        function buildDefaultJson() {
            var role = $('#js-role').val() || 'warehouseManagerRole';
            var roleName = $('#js-role option:selected').data('name') || '生产/仓储管理角色';
            return JSON.stringify([
                {nodeKey:'start', nodeName:'订单提交', nodeType:'start'},
                {nodeKey:'order_approve', nodeName:'生产订单审批', nodeType:'approval', assigneeType:'role', assigneeId:role, assigneeName:roleName, events:[{eventType:'complete', actionCode:'ORDER_APPROVE', actionName:'订单审批通过'}]},
                {nodeKey:'end', nodeName:'审批完成', nodeType:'end'}
            ], null, 2);
        }
        if (!$('#js-node-json').val()) $('#js-node-json').val(buildDefaultJson());
        renderPreview();
        $('#js-default-json').on('click', function(){ $('#js-node-json').val(buildDefaultJson()); renderPreview(); });
        $('#js-preview-json').on('click', renderPreview);
        form.on('select(js-role-filter)', function(data){
            applySelectedRoleToJson(data.value, $(data.elem).find('option:selected').data('name'));
        });
        function applySelectedRoleToJson(role, roleName) {
            if (!role) return;
            try {
                var nodes = JSON.parse($('#js-node-json').val() || '[]');
                $.each(nodes, function(i, n){
                    if (n && n.nodeType === 'approval') {
                        n.assigneeType = 'role';
                        n.assigneeId = role;
                        n.assigneeName = roleName || role;
                        return false;
                    }
                });
                $('#js-node-json').val(JSON.stringify(nodes, null, 2));
                renderPreview();
            } catch(e) {
                $('#js-node-json').val(buildDefaultJson());
                renderPreview();
            }
        }
        function renderPreview() {
            var $wrap = $('#js-flow-preview').empty();
            try {
                var nodes = JSON.parse($('#js-node-json').val() || '[]');
                $.each(nodes, function(i, n){
                    if (i > 0) $wrap.append('<span class="wf-arrow">→</span>');
                    var cls = n.nodeType === 'approval' ? 'approval' : (n.nodeType === 'end' ? 'end' : '');
                    $wrap.append('<div class="wf-node '+cls+'"><b>'+ escapeHtml(n.nodeName || n.nodeKey) +'</b><br><span>'+ escapeHtml(n.nodeType || '') +'</span></div>');
                });
            } catch(e) {
                $wrap.append('<span class="wf-badge danger">节点 JSON 无法解析</span>');
            }
        }
        function escapeHtml(s) {
            return String(s || '').replace(/[&<>"']/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]; });
        }
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({url:'${request.contextPath}/workflow/model/add-or-update', data:data.field});
            return false;
        });
        form.render();
    });
</script>
</body>
</html>
