<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工序编辑</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <h3 style="color:#2563EB; margin-bottom:15px;"><i>基本信息</i></h3>
        <form class="layui-form splayui-form" lay-filter="formTest">
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工序编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="oper" lay-verify="required" class="layui-input"
                                   value="${result.oper!''}" readonly>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工序名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="operDesc" lay-verify="required" class="layui-input"
                                   value="${result.operDesc!''}">
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">加工单元</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-unitName" name="_unitName" lay-verify="required" readonly
                                   class="layui-input" value="${unitName!''}" style="cursor: pointer;"
                                   onclick="openUnitSelect()">
                            <input type="hidden" id="js-unitId" name="unitId" value="${result.unitId!''}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工序工时(h)</label>
                        <div class="layui-input-inline">
                            <input type="number" name="operHours" lay-verify="required|positiveInteger" class="layui-input"
                                   step="1" min="1" value="${(result.operHours!1)?string}">
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">制造周期(h)</label>
                        <div class="layui-input-inline">
                            <input type="number" name="manuCycle" lay-verify="required|positiveInteger|cycleRule" class="layui-input"
                                   step="1" min="1" value="${(result.manuCycle!2)?string}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">需≥工序工时</div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">是否生成生产计划</label>
                        <div class="layui-input-inline">
                            <input type="hidden" name="genPlan" value="Y">
                            <select disabled>
                                <option value="Y" selected>是</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">备注信息</label>
                <div class="layui-input-inline" style="width: 540px;">
                    <textarea name="remark" class="layui-textarea">${result.remark!''}</textarea>
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
    window.__unitSelectCallback = function (row) {
        $('#js-unitId').val(row.id);
        $('#js-unitName').val(row.unitName);
    };

    function openUnitSelect() {
        layer.open({
            type: 2,
            title: '选择加工单元',
            area: ['700px', '500px'],
            content: '${request.contextPath}/basedata/processing-unit/select-ui'
        });
    }

    layui.use(['form'], function () {
        var form = layui.form;
        form.verify({
            positiveInteger: function (value) {
                if (!/^[1-9]\d*$/.test(value)) {
                    return '请输入正整数';
                }
            },
            cycleRule: function (value) {
                var operHours = parseInt($('input[name="operHours"]').val(), 10);
                var manuCycle = parseInt(value, 10);
                if (!isNaN(operHours) && !isNaN(manuCycle) && manuCycle < operHours) {
                    return '制造周期应大于等于工序工时';
                }
            }
        });
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/technology/oper/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
