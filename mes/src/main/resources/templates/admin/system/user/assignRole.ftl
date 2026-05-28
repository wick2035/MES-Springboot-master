<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分配角色</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .user-info-bar {
            background:#f8f8f8; padding:10px 16px; border-bottom:1px solid #eee;
            margin-bottom: 10px;
        }
        .user-info-bar strong { color:#333; }
        .role-list {
            padding: 10px 20px; max-height: 360px; overflow-y: auto;
        }
        .role-item {
            display: flex; align-items: center; padding: 8px 12px; border: 1px solid #eee;
            border-radius: 4px; margin-bottom: 6px; cursor: pointer;
            transition: background 0.15s;
        }
        .role-item:hover { background: #f0f7ff; }
        .role-item.checked { background: #e5f3ff; border-color: #1E9FFF; }
        .role-item input[type=checkbox] { margin-right: 10px; }
        .role-name { font-weight: bold; color: #333; }
        .role-code { color: #999; margin-left: 8px; font-size: 12px; }
        .role-desc { color: #666; font-size: 12px; margin-top: 3px; }
        .toolbar {
            text-align: center; padding: 12px; border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="user-info-bar">
        <strong>姓名：</strong>${user.name!''}
        &nbsp;&nbsp;<strong>用户名：</strong>${user.username!''}
        <#if (user.mobile)?? && user.mobile != ''>&nbsp;&nbsp;<strong>手机：</strong>${user.mobile}</#if>
    </div>

    <form id="js-form" class="layui-form">
        <div class="role-list">
            <#if allRoles?? && allRoles?size gt 0>
                <#list allRoles as role>
                    <#assign isChecked = checkedIds?seq_contains(role.id) />
                    <label class="role-item <#if isChecked>checked</#if>">
                        <input type="checkbox" name="roleIds" value="${role.id}" <#if isChecked>checked</#if>>
                        <div style="flex:1;">
                            <div>
                                <span class="role-name">${role.name!''}</span>
                                <span class="role-code">[${role.code!''}]</span>
                                <#if (role.isSystemRole!'0') == '1'>
                                    <span class="layui-badge layui-bg-orange" style="margin-left:8px;">系统角色</span>
                                </#if>
                            </div>
                            <#if (role.descr)?? && role.descr != ''>
                                <div class="role-desc">${role.descr}</div>
                            </#if>
                        </div>
                    </label>
                </#list>
            <#else>
                <div style="text-align:center; color:#999; padding:30px;">暂无可分配的角色</div>
            </#if>
        </div>

        <div class="toolbar">
            <input type="hidden" name="userId" value="${user.id!''}">
            <button class="layui-btn" id="js-submit-btn">保存</button>
            <button type="button" class="layui-btn layui-btn-primary" id="js-cancel-btn">取消</button>
        </div>
    </form>
</div>
<script>
    $(document).on('change', '.role-item input[type=checkbox]', function () {
        $(this).closest('.role-item').toggleClass('checked', this.checked);
    });

    $('#js-cancel-btn').on('click', function () {
        parent.layer.close(parent.layer.getFrameIndex(window.name));
    });

    $('#js-submit-btn').on('click', function (e) {
        e.preventDefault();
        var userId = $('input[name=userId]').val();
        var roleIds = $('input[name=roleIds]:checked').map(function () { return this.value; }).get();
        spUtil.ajax({
            url: '${request.contextPath}/admin/sys/user/assign-role',
            type: 'POST',
            traditional: true,
            serializable: false,
            data: {userId: userId, roleIds: roleIds},
            success: function (resp) {
                layer.msg(resp.msg || '分配成功');
                setTimeout(function () {
                    var parentTable = parent.layui && parent.layui.table;
                    parent.layer.close(parent.layer.getFrameIndex(window.name));
                }, 600);
            }
        });
        return false;
    });
</script>
</body>
</html>
