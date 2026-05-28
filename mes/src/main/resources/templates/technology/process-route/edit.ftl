<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑工艺规划</title>
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <#if parentRoute??>
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
                <legend style="color:#FF7200;">上级工艺</legend>
            </fieldset>
            <div class="layui-form-item">
                <label class="layui-form-label">工艺编号</label>
                <div class="layui-input-inline" style="width:400px;">
                    <input type="text" class="layui-input" value="${parentRoute.routeCode!''}" readonly>
                </div>
                <label class="layui-form-label">节点名称</label>
                <div class="layui-input-inline" style="width:280px;">
                    <input type="text" class="layui-input" value="${parentRoute.nodeName!''}" readonly>
                </div>
            </div>
        </#if>

        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend style="color:#FF7200;">当前工艺信息</legend>
        </fieldset>
        <form class="layui-form" lay-filter="formCurrent">
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">工艺编号</label>
                <div class="layui-input-inline" style="width:400px;">
                    <input type="text" name="routeCode" class="layui-input" value="${route.routeCode!''}" readonly>
                </div>
                <label class="layui-form-label">节点名称</label>
                <div class="layui-input-inline" style="width:240px;">
                    <input type="text" class="layui-input" value="${route.nodeName!''}" readonly>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label sp-required">工序</label>
                <div class="layui-input-inline" style="width:400px;">
                    <input type="text" id="js-operName" lay-verify="required" class="layui-input" readonly
                           placeholder="点击选择工序" style="cursor:pointer;" onclick="openOperSelect()">
                    <input type="hidden" id="js-operId" name="operId" value="${route.operId!''}">
                </div>
                <a class="layui-btn layui-btn-sm" onclick="openOperSelect()"><i class="layui-icon layui-icon-search"></i></a>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">加工单元</label>
                <div class="layui-input-inline" style="width:400px;">
                    <input type="text" id="js-unitName" class="layui-input" readonly>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">制造周期(h)</label>
                <div class="layui-input-inline" style="width:200px;">
                    <input type="text" id="js-manuCycle" class="layui-input" readonly>
                </div>
                <label class="layui-form-label">工序工时(h)</label>
                <div class="layui-input-inline" style="width:200px;">
                    <input type="text" id="js-operHours" class="layui-input" readonly>
                </div>
            </div>

            <div class="layui-form-item">
                <input type="hidden" name="routeId" value="${route.id!''}">
                <div class="layui-input-block" style="margin-left:0; text-align:center;">
                    <button class="layui-btn" lay-submit lay-filter="js-submit-filter">保存</button>
                    <button type="button" class="layui-btn layui-btn-primary" onclick="parent.layer.close(parent.layer.getFrameIndex(window.name));">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    var currentOper = null;

    window.__operSelectCallback = function (row) {
        currentOper = row;
        $('#js-operId').val(row.id);
        $('#js-operName').val((row.oper || '') + ' ' + (row.operDesc || ''));
        $('#js-unitName').val(row.unitName || '');
        $('#js-operHours').val(row.operHours || '');
        $('#js-manuCycle').val(row.manuCycle || '');
    };

    function openOperSelect() {
        layer.open({
            type: 2, title: '选择工序', area: ['80%', '70%'],
            content: '${request.contextPath}/technology/oper/select-ui'
        });
    }

    layui.use(['form'], function () {
        var form = layui.form;

        // 初始化已绑定工序
        var initOperId = '${route.operId!''}';
        if (initOperId) {
            spUtil.ajax({
                url: '${request.contextPath}/technology/oper/getInfo',
                type: 'GET', serializable: false, data: {id: initOperId},
                success: function (resp) {
                    var d = resp.data || {};
                    var o = d.oper || {};
                    if (o.id) {
                        $('#js-operId').val(o.id);
                        $('#js-operName').val((o.oper || '') + ' ' + (o.operDesc || ''));
                        $('#js-unitName').val(d.unitName || '');
                        $('#js-operHours').val(o.operHours || '');
                        $('#js-manuCycle').val(o.manuCycle || '');
                    }
                }
            });
        }

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.ajax({
                url: '${request.contextPath}/technology/process-route/bind-oper',
                type: 'POST', serializable: false,
                data: {routeId: data.field.routeId, operId: data.field.operId},
                success: function () {
                    layer.msg('保存成功');
                    setTimeout(function () {
                        parent.layer.close(parent.layer.getFrameIndex(window.name));
                    }, 600);
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
