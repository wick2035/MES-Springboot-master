<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑角色</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <#-- 基本信息标题 -->
        <div class="sp-section-title">基本信息</div>
        <form class="layui-form splayui-form">
            <div class="layui-row layui-col-space10">
                <!-- 左列 -->
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">* 角色名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="name" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${(result.name)!}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">* 排序号</label>
                        <div class="layui-input-inline">
                            <input type="number" name="sortNum" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${(result.sortNum)!0}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">* 系统角色</label>
                        <div class="layui-input-block" style="width: 220px; padding-top:9px;">
                            <input type="radio" name="isSystemRole" value="1" title="是"
                                   <#if (result.isSystemRole)?? && result.isSystemRole == "1">checked</#if>>
                            <input type="radio" name="isSystemRole" value="0" title="否"
                                   <#if !(result.isSystemRole)?? || result.isSystemRole != "1">checked</#if>>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注信息</label>
                        <div class="layui-input-inline">
                            <input type="text" name="descr" autocomplete="off"
                                   class="layui-input" value="${(result.descr)!}">
                        </div>
                    </div>
                </div>

                <!-- 右列 -->
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">* 角色编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="code" lay-verify="required" autocomplete="off"
                                   class="layui-input"
                                   value="${(result.code)!}"
                                   <#if (result.id)?? && result.id != "">readonly</#if>>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">用户类型</label>
                        <div class="layui-input-inline">
                            <select name="userType" lay-filter="js-user-type">
                                <option value="">请选择</option>
                                <option value="employee" <#if (result.userType)?? && result.userType == "employee">selected</#if>>员工</option>
                                <option value="manager" <#if (result.userType)?? && result.userType == "manager">selected</#if>>管理员</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">角色分类</label>
                        <div class="layui-input-inline">
                            <select name="roleCategory" lay-filter="js-role-category">
                                <option value="">请选择</option>
                                <option value="normal" <#if (result.roleCategory)?? && result.roleCategory == "normal">selected</#if>>普通角色</option>
                                <option value="system" <#if (result.roleCategory)?? && result.roleCategory == "system">selected</#if>>系统角色</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input id="js-id" name="id" value="${(result.id)!}"/>
                    <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
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
                url: "${request.contextPath}/admin/sys/role/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
