<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单维护</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body { background:#f3f7fb; }
        .order-form-shell { padding:18px 20px 8px; }
        .order-form-head {
            margin-bottom:14px;
            padding:14px 16px;
            border-radius:8px;
            border:1px solid #dbe5ef;
            background:linear-gradient(180deg, #f8fafc, #f7fbff);
            color:#0f172a;
        }
        .order-form-head h2 { margin:0; font-size:18px; font-weight:800; }
        .order-form-head p { margin:6px 0 0; color:#64748b; font-size:12px; }
        .order-form-grid {
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:14px;
        }
        .order-form-card {
            border:1px solid #dbe5ef;
            border-radius:8px;
            background:#fff;
            padding:14px 16px 4px;
            box-shadow:0 10px 24px rgba(15,23,42,.06);
        }
        .order-form-card h3 {
            margin:0 0 12px;
            color:#0f172a;
            font-size:15px;
            font-weight:800;
        }
        .order-pick-line { display:flex; gap:6px; }
        .order-pick-line .layui-input { flex:1; }
        .order-pick-line .layui-btn { width:42px; padding:0; }
        @media (max-width: 760px) { .order-form-grid { grid-template-columns:1fr; } }
    </style>
</head>
<body>
<div class="order-form-shell">
    <div class="order-form-head">
        <h2>生产工单审批维护</h2>
        <p>正常工单由生产订单生成；此处仅维护待审批工单或异常/返工/临时补单，审批通过后锁定编辑，最终下发在生产订单下发中完成。</p>
    </div>
    <form class="layui-form splayui-form" lay-filter="js-order-form">
        <div class="order-form-grid">
            <section class="order-form-card">
                <h3>工单信息</h3>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">工单编号</label>
                    <div class="layui-input-block"><input type="text" name="orderCode" lay-verify="required" autocomplete="off" class="layui-input" value="${(result.orderCode)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">工单描述</label>
                    <div class="layui-input-block"><input type="text" name="orderDescription" lay-verify="required" autocomplete="off" class="layui-input" value="${(result.orderDescription)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">工单数量</label>
                    <div class="layui-input-block"><input type="number" name="qty" lay-verify="required|number" autocomplete="off" class="layui-input" value="${(result.qty)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">订单类型</label>
                    <div class="layui-input-block">
                        <select name="orderType" lay-verify="required">
                            <option value="P" <#if (result.orderType!'P') == 'P'>selected</#if>>量产</option>
                            <option value="A" <#if (result.orderType!'P') == 'A'>selected</#if>>验证</option>
                            <option value="F" <#if (result.orderType!'P') == 'F'>selected</#if>>返工</option>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">设计人</label>
                    <div class="layui-input-block"><input type="text" readonly autocomplete="off" class="layui-input" value="${(result.designerName)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-block">
                        <input type="text" readonly autocomplete="off" class="layui-input" value="<#if (result.statue!1) == 1>待审批<#elseif (result.statue!1) == 2>已审批<#elseif (result.statue!1) == 5>已下发<#elseif (result.statue!1) == 3>已结束<#elseif (result.statue!1) == 4>已终止<#else>未设置</#if>">
                    </div>
                </div>
            </section>
            <section class="order-form-card">
                <h3>物料与计划</h3>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">物料编码</label>
                    <div class="layui-input-block order-pick-line">
                        <input id="js-materiel" name="materiel" readonly lay-verify="required" autocomplete="off" class="layui-input" value="${(result.materiel)!}">
                        <button type="button" id="js-pick-mat" class="layui-btn"><i class="layui-icon layui-icon-search"></i></button>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">物料名称</label>
                    <div class="layui-input-block"><input id="js-materiel-desc" name="materielDesc" readonly lay-verify="required" autocomplete="off" class="layui-input" value="${(result.materielDesc)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">工艺路线</label>
                    <div class="layui-input-block">
                        <select name="flowId" lay-verify="required">
                            <option value="">请选择工艺路线</option>
                            <#list flows as flow>
                                <option value="${flow.id}" <#if ((result.flowId)!'') == flow.id>selected</#if>>${flow.flow} ${flow.flowDesc}</option>
                            </#list>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">计划开始</label>
                    <div class="layui-input-block"><input type="text" id="js-plan-start" name="planStartTime" lay-verify="required" autocomplete="off" class="layui-input" value="${(result.planStartTime)!}"></div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required">计划结束</label>
                    <div class="layui-input-block"><input type="text" id="js-plan-end" name="planEndTime" lay-verify="required" autocomplete="off" class="layui-input" value="${(result.planEndTime)!}"></div>
                </div>
            </section>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" value="${(result.id)!}">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </div>
    </form>
</div>
<script>
    layui.use(['form', 'laydate', 'spLayer'], function () {
        var form = layui.form, laydate = layui.laydate, spLayer = layui.spLayer;
        laydate.render({elem:'#js-plan-start', type:'datetime', trigger:'click', format:'yyyy-MM-dd HH:mm:ss', zIndex:99999999});
        laydate.render({elem:'#js-plan-end', type:'datetime', trigger:'click', format:'yyyy-MM-dd HH:mm:ss', zIndex:99999999});
        $('#js-pick-mat').click(function () {
            spLayer.open({
                type:2,
                area:['720px','500px'],
                reload:false,
                content:'${request.contextPath}/admin/common/ui/searchPanelMaterile',
                spCallback:function (result) {
                    if (result && result.code === 0 && result.data && result.data.length > 0) {
                        var mat = result.data[0];
                        $('#js-materiel').val(mat.materiel || '');
                        $('#js-materiel-desc').val(mat.materielDesc || '');
                    }
                }
            });
        });
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({url:'${request.contextPath}/order/release/add-or-update', data:data.field});
            return false;
        });
        form.render();
    });
</script>
</body>
</html>
