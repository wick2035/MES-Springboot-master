<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>加工单元编辑</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">单元编号</label>
                <div class="layui-input-inline">
                    <input type="text" id="js-unitCode" name="unitCode" lay-verify="required"
                           autocomplete="off" class="layui-input" value="${result.unitCode!''}">
                </div>
                <div class="layui-form-mid layui-word-aux">默认自动生成，可手动修改（需唯一）</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">单元名称</label>
                <div class="layui-input-inline">
                    <input type="text" name="unitName" lay-verify="required"
                           autocomplete="off" class="layui-input" value="${result.unitName!''}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">单元类型</label>
                <div class="layui-input-inline">
                    <select name="unitType" lay-verify="required">
                        <option value="person" <#if (result.unitType!'') == 'person'>selected</#if>>人员作业单元</option>
                        <option value="device" <#if (result.unitType!'') == 'device'>selected</#if>>设备作业单元</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">日标准产能(小时)</label>
                <div class="layui-input-inline">
                    <input type="number" step="0.5" min="0" name="stdCapacity" lay-verify="required"
                           autocomplete="off" class="layui-input" value="${(result.stdCapacity!8.0)?c}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">是否有线边库</label>
                <div class="layui-input-inline">
                    <select name="hasEdgeWarehouse" lay-verify="required">
                        <option value="N" <#if (result.hasEdgeWarehouse!'N') == 'N'>selected</#if>>否</option>
                        <option value="Y" <#if (result.hasEdgeWarehouse!'') == 'Y'>selected</#if>>是</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">描述</label>
                <div class="layui-input-inline" style="width: 400px;">
                    <textarea name="description" class="layui-textarea">${result.description!''}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">状态</label>
                <div class="layui-input-block" style="width: 310px;">
                    <input type="radio" name="status" value="0" title="正常"
                           <#if (result.status!'0') == '0' || (result.status!'') == '1'>checked</#if>>
                    <input type="radio" name="status" value="2" title="异常"
                           <#if (result.status!'') == '2'>checked</#if>>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <input id="js-id" name="id" value="${result.id!''}"/>
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
                url: "${request.contextPath}/basedata/processing-unit/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
