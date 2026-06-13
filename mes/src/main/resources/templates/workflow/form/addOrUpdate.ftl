<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程表单维护</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-form-wrap wf-designer">
    <div class="wf-form-tip">
        流程表单只保存安全配置：URL地址、白名单变量、事件模板和按钮权限。当前版本不执行任意脚本。
    </div>
    <form class="layui-form splayui-form" lay-filter="js-form-filter">
        <input type="hidden" name="id" value="${(result.id)!}">
        <input type="hidden" name="skipSameHandler" value="0">
        <div class="wf-editor-grid">
            <section class="wf-editor-section">
                <h3>基本信息</h3>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">表单名称</label>
                    <div class="layui-input-block"><input name="formName" lay-verify="required" class="layui-input" value="${(result.formName)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">表单Key</label>
                    <div class="layui-input-block"><input name="formKey" lay-verify="required" class="layui-input" value="${(result.formKey)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">业务类型</label>
                    <div class="layui-input-block"><input name="businessType" lay-verify="required" class="layui-input" value="${(result.businessType)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">流程定义</label>
                    <div class="layui-input-block"><input name="definitionCode" lay-verify="required" class="layui-input" value="${(result.definitionCode)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">排序</label>
                    <div class="layui-input-inline"><input name="sortNum" type="number" class="layui-input" value="${(result.sortNum)!30}"></div>
                    <div class="layui-input-inline" style="width:120px;">
                        <select name="status">
                            <option value="0" <#if (result.status!'0') == '0'>selected</#if>>启用</option>
                            <option value="2" <#if (result.status!'0') == '2'>selected</#if>>停用</option>
                        </select>
                    </div>
                </div>
            </section>
            <section class="wf-editor-section">
                <h3>URL表单</h3>
                <input type="hidden" name="formType" value="url">
                <div class="wf-preset-row">
                    <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-current-url"><i class="fa fa-link"></i>当前项目路径</button>
                    <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-legacy-url"><i class="fa fa-history"></i>旧系统路径</button>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">PC地址</label>
                    <div class="layui-input-block"><input id="js-pc-url" name="pcFormUrl" lay-verify="required" class="layui-input" value="${(result.pcFormUrl)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">手机地址</label>
                    <div class="layui-input-block"><input id="js-mobile-url" name="mobileFormUrl" class="layui-input" value="${(result.mobileFormUrl)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">流程标题</label>
                    <div class="layui-input-block"><input name="titleTemplate" class="layui-input" value="${(result.titleTemplate)!}"></div>
                </div>
                <div class="wf-token-bar">
                    <span>${r"${task.procIns.bizKey}"}</span><span>${r"${task.businessCode}"}</span><span>${r"${form.currentUser.userName}"}</span><span>${r"${date(),'yyyy-MM-dd'}"}</span>
                </div>
            </section>
        </div>

        <section class="wf-editor-section wf-editor-wide">
            <h3>安全事件与表单选项</h3>
            <div class="layui-form-item">
                <label class="layui-form-label">事件模板</label>
                <div class="layui-input-block">
                    <input name="eventTemplate" class="layui-input" value="${(result.eventTemplate)!}">
                    <div class="wf-help">仅允许 ORDER_APPROVE，审批完成后同步生产订单状态。</div>
                </div>
            </div>
            <div class="layui-form-item wf-check-row">
                <label class="layui-form-label">流程选项</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="skipFirstNode" value="1" title="跳过第一个环节" <#if (result.skipFirstNode!1) == 1>checked</#if>>
                    <span class="wf-muted">“跳过相同处理人”已按安全策略固定关闭。</span>
                </div>
            </div>
            <div class="layui-form-item wf-check-row">
                <label class="layui-form-label">按钮选项</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="allowReturn" value="1" title="允许退回" <#if (result.allowReturn!1) == 1>checked</#if>>
                    <input type="checkbox" name="allowTransfer" value="1" title="允许转办" <#if (result.allowTransfer!1) == 1>checked</#if>>
                    <input type="checkbox" name="allowEntrust" value="1" title="允许委托" <#if (result.allowEntrust!1) == 1>checked</#if>>
                    <input type="checkbox" name="allowRevoke" value="1" title="允许撤回" <#if (result.allowRevoke!1) == 1>checked</#if>>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block"><textarea name="remark" class="layui-textarea">${(result.remark)!}</textarea></div>
            </div>
        </section>
        <div class="layui-hide">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">保存</button>
        </div>
    </form>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;
        var currentUrl = '/order/release/add-or-update-ui?id=$' + '{task.procIns.bizKey}';
        var legacyUrl = '/order/plMpsMo//form?id=$' + '{task.procIns.bizKey}';
        $('#js-current-url').on('click', function(){ $('#js-pc-url,#js-mobile-url').val(currentUrl); });
        $('#js-legacy-url').on('click', function(){ $('#js-pc-url,#js-mobile-url').val(legacyUrl); });
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({url:'${request.contextPath}/workflow/form/add-or-update', data:data.field});
            return false;
        });
        form.render();
    });
</script>
</body>
</html>
