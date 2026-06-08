<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>零部件编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .form-help { color:#98A2B3; line-height: 20px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
                <legend style="font-size:14px;">基本信息</legend>
            </fieldset>
            <div class="layui-row">
                <div class="layui-col-xs12 layui-col-sm12 layui-col-md10">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">所属产品名称</label>
                        <div class="layui-input-inline" style="width: 260px;">
                            <input type="text" name="productName" lay-verify="required" autocomplete="off"
                                   placeholder="例如：台式电脑主机"
                                   class="layui-input" value="${(result.productName)!''}">
                        </div>
                        <div class="layui-form-mid form-help">用于限定该成品可选哪些半成品/组件</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">零部件编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="componentCode" readonly autocomplete="off"
                                   class="layui-input sp-readonly" value="${(result.componentCode)!''}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">系统自动生成；创建子BOM时会作为节点编号使用</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">零部件名称</label>
                        <div class="layui-input-inline" style="width: 260px;">
                            <input type="text" name="componentName" lay-verify="required" autocomplete="off"
                                   placeholder="例如：主板单元、机箱单元"
                                   class="layui-input" value="${(result.componentName)!''}">
                        </div>
                        <div class="layui-form-mid form-help">这是产品BOM中的可装配节点名称</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">类型</label>
                        <div class="layui-input-inline">
                            <select name="componentType" lay-verify="required">
                                <option value="COMP" <#if (result.componentType!'COMP') == 'COMP' || (result.componentType!'') == '组件'>selected</#if>>组件</option>
                                <option value="PG" <#if (result.componentType!'') == 'PG' || (result.componentType!'') == '半成品'>selected</#if>>半成品</option>
                            </select>
                        </div>
                        <div class="layui-form-mid form-help">半成品对应 1 级BOM，组件对应 2 级BOM</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注信息</label>
                        <div class="layui-input-inline" style="width: 420px;">
                            <textarea name="remark" class="layui-textarea"
                                      placeholder="请输入备注信息">${(result.remark)!''}</textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" style="width: 310px;">
                            <input type="radio" name="deleted" value="0" title="正常"
                                   <#if (result.deleted!'0') == '0'>checked</#if>>
                            <input type="radio" name="deleted" value="2" title="禁用"
                                   <#if (result.deleted!'') == '2'>checked</#if>>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${(result.id)!''}"/>
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: '${request.contextPath}/technology/component/add-or-update',
                data: data.field
            });
            return false;
        });

        form.render();
    });
</script>
</body>
</html>
