<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单维护</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="js-order-form">
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工单编号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderCode" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.orderCode}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工单描述</label>
                        <div class="layui-input-inline">
                            <input type="text" name="orderDescription" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.orderDescription}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工单数量</label>
                        <div class="layui-input-inline">
                            <input type="number" name="qty" lay-verify="required|number" autocomplete="off"
                                   class="layui-input" value="${result.qty}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">订单类型</label>
                        <div class="layui-input-inline">
                            <select name="orderType" lay-verify="required">
                                <option value="P" <#if (result.orderType!'P') == 'P'>selected</#if>>量产</option>
                                <option value="A" <#if result.orderType == 'A'>selected</#if>>验证</option>
                                <option value="F" <#if result.orderType == 'F'>selected</#if>>返工</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">设计人</label>
                        <div class="layui-input-inline">
                            <input type="text" readonly autocomplete="off" class="layui-input"
                                   value="${result.designerName!''}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <input type="text" readonly autocomplete="off" class="layui-input"
                                   value="<#if (result.statue!1) == 1>已创建/待审批<#elseif result.statue == 2>已审批<#elseif result.statue == 3>已结束<#elseif result.statue == 4>已终结<#else>未设置</#if>">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">物料编码</label>
                        <div class="layui-input-inline" style="display:flex;width:190px;">
                            <input id="js-materiel" name="materiel" readonly lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.materiel}">
                            <button type="button" id="js-pick-mat" class="layui-btn" style="height:38px;margin-left:4px;">
                                <i class="layui-icon layui-icon-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">物料名称</label>
                        <div class="layui-input-inline">
                            <input id="js-materiel-desc" name="materielDesc" readonly lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.materielDesc}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">工艺路线</label>
                        <div class="layui-input-inline">
                            <select name="flowId" lay-verify="required">
                                <option value="">请选择工艺路线</option>
                                <#list flows as flow>
                                    <option value="${flow.id}" <#if result.flowId == flow.id>selected</#if>>
                                        ${flow.flow} ${flow.flowDesc}
                                    </option>
                                </#list>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">计划开始</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-plan-start" name="planStartTime" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.planStartTime}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">计划结束</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-plan-end" name="planEndTime" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.planEndTime}">
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input name="id" value="${result.id}"/>
                    <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form', 'laydate', 'spLayer'], function () {
        var form = layui.form,
            laydate = layui.laydate,
            spLayer = layui.spLayer;

        laydate.render({
            elem: '#js-plan-start',
            type: 'datetime',
            trigger: 'click',
            format: 'yyyy-MM-dd HH:mm:ss',
            zIndex: 99999999
        });
        laydate.render({
            elem: '#js-plan-end',
            type: 'datetime',
            trigger: 'click',
            format: 'yyyy-MM-dd HH:mm:ss',
            zIndex: 99999999
        });

        $('#js-pick-mat').click(function () {
            spLayer.open({
                type: 2,
                area: ['720px', '500px'],
                reload: false,
                content: '${request.contextPath}/admin/common/ui/searchPanelMaterile',
                spCallback: function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        var mat = result.data[0];
                        $('#js-materiel').val(mat.materiel || '');
                        $('#js-materiel-desc').val(mat.materielDesc || '');
                    }
                }
            });
        });

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: '${request.contextPath}/order/release/add-or-update',
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
