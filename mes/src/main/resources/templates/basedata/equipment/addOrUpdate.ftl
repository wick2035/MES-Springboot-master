<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备编辑</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">设备编号</label>
                <div class="layui-input-inline">
                    <input type="text" name="equipmentCode" lay-verify="required"
                           autocomplete="off" class="layui-input" value="${result.equipmentCode!''}" readonly>
                </div>
                <div class="layui-form-mid layui-word-aux">系统自动生成</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">设备名称</label>
                <div class="layui-input-inline">
                    <input type="text" name="equipmentName" lay-verify="required"
                           autocomplete="off" class="layui-input" value="${result.equipmentName!''}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">设备规格/型号</label>
                <div class="layui-input-inline">
                    <input type="text" name="equipmentModel" autocomplete="off"
                           class="layui-input" value="${result.equipmentModel!''}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">设备用途</label>
                <div class="layui-input-inline" style="width: 400px;">
                    <input type="text" name="purpose" autocomplete="off" class="layui-input" value="${result.purpose!''}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">设定条件</label>
                <div class="layui-input-inline">
                    <input type="text" name="spec" autocomplete="off" class="layui-input" value="${result.spec!''}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">状态</label>
                <div class="layui-input-block" style="width: 310px;">
                    <input type="radio" name="status" value="1" title="启用"
                           <#if (result.status!'1') == '1'>checked</#if>>
                    <input type="radio" name="status" value="0" title="停用"
                           <#if (result.status!'') == '0'>checked</#if>>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <input name="id" value="${result.id!''}"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/basedata/equipment/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
