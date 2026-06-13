<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程分类</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-form-wrap">
    <p class="wf-form-tip">分类编码用于模型归档和业务识别，建议使用小写英文，例如生产流程使用 <b>prod</b>。</p>
    <form class="layui-form splayui-form" lay-filter="js-form-filter">
        <input type="hidden" name="id" value="${(result.id)!}">
        <div class="layui-form-item">
            <label class="layui-form-label sp-required">分类名称</label>
            <div class="layui-input-block">
                <input type="text" name="categoryName" lay-verify="required" autocomplete="off" class="layui-input" value="${(result.categoryName)!}" placeholder="例如：生产流程">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label sp-required">分类编码</label>
            <div class="layui-input-block">
                <input type="text" name="categoryCode" lay-verify="required" autocomplete="off" class="layui-input" value="${(result.categoryCode)!}" placeholder="例如：prod">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">上级分类</label>
            <div class="layui-input-block">
                <input type="text" name="parentId" autocomplete="off" class="layui-input" value="${(result.parentId)!'0'}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">排序</label>
            <div class="layui-input-block">
                <input type="number" name="sortNum" autocomplete="off" class="layui-input" value="${(result.sortNum)!30}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-block">
                <select name="status">
                            <option value="0" <#if ((result.status)!'0') == '0'>selected</#if>>正常</option>
                    <option value="2" <#if ((result.status)!'') == '2'>selected</#if>>停用</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-block">
                <textarea name="remark" class="layui-textarea" placeholder="说明该分类适用的流程范围">${(result.remark)!}</textarea>
            </div>
        </div>
        <div class="layui-hide">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </div>
    </form>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({url: '${request.contextPath}/workflow/category/add-or-update', data: data.field});
            return false;
        });
        form.render();
    });
</script>
</body>
</html>
