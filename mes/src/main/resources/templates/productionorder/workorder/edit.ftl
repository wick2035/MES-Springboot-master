<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>已下达工单修改</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        body{background:#f4f7fb;color:#1f3347;font-family:"Microsoft YaHei","PingFang SC",sans-serif}
        .wrap{padding:18px}
        .notice{padding:13px 14px;margin-bottom:14px;border-radius:8px;border:1px solid #dbe8f2;background:#fff;color:#536b7f;line-height:1.7}
        .notice strong{color:#17324a}
        .notice.warn{border-color:#ffe0a3;background:#fff8e8;color:#8a5a00}
        .form-card{border:1px solid #dbe8f2;border-radius:8px;background:#fff;padding:16px 18px 4px;box-shadow:0 12px 28px rgba(31,65,92,.08)}
        .layui-form-label{width:96px;color:#50697d}
        .layui-input-block{margin-left:126px}
        .readonly,.layui-disabled{background:#f2f5f8!important;color:#7a8793!important}
        .footer{padding:14px 0 0;text-align:right}
        .footer .layui-btn{min-width:92px}
    </style>
</head>
<body>
<div class="wrap">
    <#if errorMsg??>
        <div class="notice warn"><strong>无法修改：</strong>${errorMsg}</div>
    <#else>
        <#assign locked = !(directEditable!false)>
        <div class="notice <#if started!false>warn</#if>">
            <#if started!false>
                <strong>已动工：</strong>工单已有现场采集记录，核心字段不可直接修改；提交后将进入变更审批。
            <#else>
                <strong>未动工：</strong>工单尚无现场采集记录，保存后将直接更新工单。
            </#if>
        </div>
        <form class="layui-form form-card" lay-filter="changeForm">
            <input type="hidden" name="id" value="${(workOrder.id)!}">
            <#if locked><input type="hidden" name="flowId" value="${(workOrder.flowId)!}"></#if>
            <div class="layui-form-item">
                <label class="layui-form-label">工单编号</label>
                <div class="layui-input-block"><input readonly class="layui-input readonly" value="${(workOrder.orderCode)!}"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">来源计划</label>
                <div class="layui-input-block"><input readonly class="layui-input readonly" value="${(productionOrder.orderNo)!}"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">产品</label>
                <div class="layui-input-block"><input readonly class="layui-input readonly" value="${(orderItem.productMateriel)!} ${(orderItem.productName)!}"></div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">工艺路线</label>
                <div class="layui-input-block">
                    <select name="flowId" lay-verify="required" <#if locked>disabled</#if>>
                        <option value="">请选择工艺路线</option>
                        <#list flows as flow>
                            <option value="${flow.id}" <#if ((workOrder.flowId)!'') == flow.id>selected</#if>>${(flow.flow)!} ${(flow.flowDesc)!}</option>
                        </#list>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">计划数量</label>
                <div class="layui-input-block">
                    <input type="number" name="qty" lay-verify="required|number" autocomplete="off" class="layui-input <#if locked>readonly</#if>" value="${(workOrder.qty)!}" <#if locked>readonly</#if>>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">计划开始</label>
                <div class="layui-input-block">
                    <input type="text" id="planStartTime" name="planStartTime" lay-verify="required" autocomplete="off" class="layui-input <#if locked>readonly</#if>" value="${(workOrder.planStartTime)!}" <#if locked>readonly</#if>>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">计划结束</label>
                <div class="layui-input-block">
                    <input type="text" id="planEndTime" name="planEndTime" lay-verify="required" autocomplete="off" class="layui-input <#if locked>readonly</#if>" value="${(workOrder.planEndTime)!}" <#if locked>readonly</#if>>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <textarea name="remark" class="layui-textarea" placeholder="<#if started!false>请填写变更原因或审批说明<#else>请输入备注</#if>">${(workOrder.remark)!}</textarea>
                </div>
            </div>
            <div class="footer">
                <button type="button" class="layui-btn layui-btn-primary" id="cancelBtn">取消</button>
                <button class="layui-btn" lay-submit lay-filter="submitChange">提交</button>
            </div>
        </form>
    </#if>
</div>
<script>
layui.use(['form','laydate','layer'],function(){
    var form=layui.form,laydate=layui.laydate,layer=layui.layer;
    var directEditable=${(directEditable!false)?c};
    if(directEditable){
        laydate.render({elem:'#planStartTime',type:'datetime',trigger:'click',format:'yyyy-MM-dd HH:mm:ss',zIndex:99999999});
        laydate.render({elem:'#planEndTime',type:'datetime',trigger:'click',format:'yyyy-MM-dd HH:mm:ss',zIndex:99999999});
    }
    $('#cancelBtn').on('click',function(){
        var index=parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    });
    form.on('submit(submitChange)',function(data){
        $.ajax({
            url:'${request.contextPath}/production-order/work-order/update',
            type:'POST',
            contentType:'application/json;charset=UTF-8',
            dataType:'json',
            data:JSON.stringify(data.field),
            success:function(res){
                if(res && res.code===0){
                    parent.layer.msg(res.msg || '操作成功', {icon:1});
                    parent.layer.close(parent.layer.getFrameIndex(window.name));
                }else{
                    layer.msg((res && res.msg) || '操作失败', {icon:2});
                }
            },
            error:function(){
                layer.msg('提交失败，请稍后重试', {icon:2});
            }
        });
        return false;
    });
    form.render();
});
</script>
</body>
</html>
