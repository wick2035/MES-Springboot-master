<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加用户</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .user-form-tip {
            padding: 0 0 14px 110px;
            color: #8a96a8;
            font-size: 12px;
            line-height: 20px;
        }

        .user-avatar-field {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar-preview {
            width: 46px;
            height: 46px;
            border: 1px solid #e6eaf0;
            border-radius: 4px;
            background: #f6f8fb;
            color: #9aa5b5;
            font-size: 12px;
            line-height: 46px;
            text-align: center;
            overflow: hidden;
        }

        .user-avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>
</head>

<#assign isEdit = ((result.id)!'')?has_content>
<#assign birthdayValue = (result.birthday)!''>
<#if birthdayValue?length gt 10><#assign birthdayValue = birthdayValue?substring(0, 10)></#if>
<#assign sexValue = (result.sex)!'0'>
<#assign deletedValue = (result.deleted)!'0'>
<#assign deptValue = (result.deptId)!''>
<#assign picIdValue = (result.picId)!''>

<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form">
            <div class="user-form-tip">带红色标记的是必填项，选填项填写后会自动校验格式。</div>
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">姓名</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" placeholder="请输入姓名"
                                   autocomplete="off" class="layui-input" value="${(result.name)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-username" class="layui-form-label sp-required">用户名</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-username" name="username" lay-verify="required|usernameRule"
                                   placeholder="3-32位字母、数字或常用符号" autocomplete="off" class="layui-input"
                                   value="${(result.username)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-password" class="layui-form-label sp-required">密码</label>
                        <div class="layui-input-inline">
                            <input type="password" id="js-password" name="password" lay-verify="required|passwordRule"
                                   placeholder="至少6位" autocomplete="off" class="layui-input"
                                   value="${(result.password)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-repassword" class="layui-form-label sp-required">确认密码</label>
                        <div class="layui-input-inline">
                            <input type="password" id="js-repassword" name="repassword" lay-verify="required|repasswordRule"
                                   placeholder="请再次输入密码" autocomplete="off" class="layui-input"
                                   value="${(result.password)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-dept-id" class="layui-form-label">部门</label>
                        <div class="layui-input-inline">
                            <select id="js-dept-id" name="deptId" lay-search>
                                <option value="">请选择部门</option>
                                <#list departments as department>
                                    <option value="${department.id}" <#if deptValue == department.id>selected</#if>>${department.name}</option>
                                </#list>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-email" class="layui-form-label">邮箱</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-email" name="email" lay-verify="emailOptional"
                                   placeholder="name@example.com" autocomplete="off" class="layui-input"
                                   value="${(result.email)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-mobile" class="layui-form-label sp-required">手机号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-mobile" name="mobile" lay-verify="required|mobileRule"
                                   placeholder="11位手机号" maxlength="11" autocomplete="off" class="layui-input"
                                   value="${(result.mobile)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-tel" class="layui-form-label">固定电话</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-tel" name="tel" lay-verify="telOptional"
                                   placeholder="选填，如 010-12345678" autocomplete="off" class="layui-input"
                                   value="${(result.tel)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">性别</label>
                        <div class="layui-input-block" id="js-sex">
                            <input type="radio" name="sex" value="0" title="女" <#if sexValue == "0">checked</#if>>
                            <input type="radio" name="sex" value="1" title="男" <#if sexValue == "1">checked</#if>>
                            <input type="radio" name="sex" value="2" title="其他" <#if sexValue == "2">checked</#if>>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-birthday" class="layui-form-label">出生日期</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-birthday" name="birthday" lay-verify="birthdayOptional"
                                   placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input"
                                   value="${birthdayValue}">
                        </div>
                    </div>
                </div>

                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">头像</label>
                        <div class="layui-input-inline user-avatar-field">
                            <input type="hidden" id="js-pic-id" name="picId" value="${picIdValue}">
                            <div class="user-avatar-preview" id="js-avatar-preview">
                                <#if picIdValue?has_content>
                                    <img src="${request.contextPath}/upload/${picIdValue}" alt="">
                                <#else>
                                    未上传
                                </#if>
                            </div>
                            <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-avatar-upload">
                                <i class="layui-icon layui-icon-upload"></i> 上传
                            </button>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-id-card" class="layui-form-label">身份证</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-id-card" name="idCard" lay-verify="idCardOptional"
                                   placeholder="15位或18位，末位可为X" maxlength="18" autocomplete="off" class="layui-input"
                                   value="${(result.idCard)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-hobby" class="layui-form-label">爱好</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-hobby" name="hobby" placeholder="选填"
                                   autocomplete="off" class="layui-input" value="${(result.hobby)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-province" class="layui-form-label">省份</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-province" name="province" placeholder="选填"
                                   autocomplete="off" class="layui-input" value="${(result.province)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-city" class="layui-form-label">城市</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-city" name="city" placeholder="选填"
                                   autocomplete="off" class="layui-input" value="${(result.city)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-district" class="layui-form-label">区县</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-district" name="district" placeholder="选填"
                                   autocomplete="off" class="layui-input" value="${(result.district)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-street" class="layui-form-label">街道</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-street" name="street" placeholder="选填"
                                   autocomplete="off" class="layui-input" value="${(result.street)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-street-number" class="layui-form-label">门牌号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-street-number" name="streetNumber" placeholder="选填"
                                   autocomplete="off" class="layui-input" value="${(result.streetNumber)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-descr" class="layui-form-label">描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-descr" name="descr" placeholder="选填"
                                   autocomplete="off" class="layui-input" value="${(result.descr)!''}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted">
                            <input type="radio" name="deleted" value="0" title="正常" <#if deletedValue == "0" || deletedValue == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="禁用" <#if deletedValue == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-col-xs12 layui-col-sm12 layui-col-md12">
                    <div class="layui-form-item" pane="">
                        <label class="layui-form-label">分配角色</label>
                        <div class="layui-input-block">
                            <#list sysRoles as sysRole>
                                <input type="checkbox" name="sysRoleIds" title="${sysRole.name}" value="${sysRole.id}" <#if sysRole.checked>checked</#if>>
                            </#list>
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
    var CTX = "${request.contextPath}";
    layui.use(['form', 'layer', 'laydate', 'upload'], function () {
        var form = layui.form,
            layer = layui.layer,
            laydate = layui.laydate,
            upload = layui.upload;

        form.render();
        laydate.render({elem: '#js-birthday', trigger: 'click', max: 0});

        form.verify({
            usernameRule: function (value) {
                value = $.trim(value);
                if (!/^[A-Za-z0-9_.@-]{3,32}$/.test(value)) {
                    return '用户名需为3-32位，可包含字母、数字、下划线、点、@或-';
                }
            },
            passwordRule: function (value) {
                if (value.length < 6 || value.length > 64) {
                    return '密码长度需为6-64位';
                }
            },
            repasswordRule: function (value) {
                if (value !== $('#js-password').val()) {
                    return '两次输入的密码不一致';
                }
            },
            mobileRule: function (value) {
                if (!/^1[3-9]\d{9}$/.test($.trim(value))) {
                    return '手机号必须是11位中国大陆手机号';
                }
            },
            emailOptional: function (value) {
                if (value && !/^[\w.+-]+@[\w-]+(\.[\w-]+)+$/.test($.trim(value))) {
                    return '邮箱格式不正确';
                }
            },
            telOptional: function (value) {
                if (value && !/^[0-9+\-()]{6,20}$/.test($.trim(value))) {
                    return '固定电话格式不正确';
                }
            },
            idCardOptional: function (value) {
                if (value && !/(^\d{15}$)|(^\d{17}[\dXx]$)/.test($.trim(value))) {
                    return '身份证号需为15位或18位，18位末位可为X';
                }
            },
            birthdayOptional: function (value) {
                if (value && !/^\d{4}-\d{2}-\d{2}$/.test($.trim(value))) {
                    return '出生日期格式应为 yyyy-MM-dd';
                }
            }
        });

        upload.render({
            elem: '#js-avatar-upload',
            url: CTX + '/common/upload',
            field: 'file',
            accept: 'images',
            acceptMime: 'image/*',
            done: function (res) {
                if (res.code === 0 && res.data && res.data.filePath) {
                    var p = res.data.filePath;
                    $('#js-pic-id').val(p);
                    $('#js-avatar-preview').html('<img src="' + CTX + '/upload/' + p + '" alt="">');
                    layer.msg('头像上传成功');
                } else {
                    layer.alert(res.msg || '头像上传失败', {icon: 2});
                }
            }
        });

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: CTX + "/admin/sys/user/add-or-update",
                data: data.field
            });

            return false;
        });
    });
</script>
</body>
</html>
