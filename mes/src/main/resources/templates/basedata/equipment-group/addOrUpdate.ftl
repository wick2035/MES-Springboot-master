<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备编组编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
                <legend style="font-size:14px;">基本信息</legend>
            </fieldset>
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md10">
                    <div class="layui-form-item">
                        <label for="js-groupCode" class="layui-form-label sp-required">编组编号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-groupCode" name="groupCode" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.groupCode}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-groupName" class="layui-form-label sp-required">编组名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-groupName" name="groupName" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.groupName}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-groupDesc" class="layui-form-label">编组描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-groupDesc" name="groupDesc" autocomplete="off"
                                   class="layui-input" value="${result.groupDesc}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-remark" class="layui-form-label">备注信息</label>
                        <div class="layui-input-inline" style="width: 360px;">
                            <textarea id="js-remark" name="remark" class="layui-textarea"
                                      placeholder="请输入备注信息">${result.remark}</textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" style="width: 310px;">
                            <input type="radio" name="deleted" value="0" title="正常"
                                   <#if (result.deleted)?? && result.deleted == "2">  <#else> checked </#if>>
                            <input type="radio" name="deleted" value="2" title="禁用"
                                   <#if (result.deleted)?? && result.deleted == "2"> checked </#if>>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${result.id}"/>
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

        //监听提交
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/basedata/equipment-group/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
