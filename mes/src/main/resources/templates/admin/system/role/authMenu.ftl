<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>授权菜单</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .menu-tree { padding: 10px; }
        .menu-tree-item { padding: 4px 0; display: flex; align-items: center; }
        .menu-tree-item label { cursor: pointer; }
        .menu-level-1 { font-weight: bold; font-size: 14px; }
        .menu-level-2 { padding-left: 20px; font-size: 13px; }
        .menu-level-3 { padding-left: 40px; font-size: 12px; color: #666; }
        .menu-tree-actions { padding: 8px 10px; border-bottom: 1px solid #eee; margin-bottom: 8px; }
        .menu-url { color: #aaa; font-size: 11px; margin-left: 8px; }
        .tree-scroll { max-height: 440px; overflow-y: auto; border: 1px solid #eee; border-radius:4px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="menu-tree-actions">
            <button class="layui-btn layui-btn-sm" id="js-check-all">全选</button>
            <button class="layui-btn layui-btn-sm layui-btn-normal" id="js-uncheck-all">取消全选</button>
            <button class="layui-btn layui-btn-sm layui-btn-warm" id="js-expand-all">展开全部</button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" id="js-collapse-all">折叠全部</button>
        </div>
        <div class="tree-scroll">
            <div class="menu-tree" id="js-menu-tree">
                <#-- 递归渲染菜单树 -->
                <#macro renderTree nodes>
                    <#list nodes as node>
                        <div class="menu-tree-item menu-level-${(node.id?length < 3)?then('1', (node.id?length < 4)?then('2','3'))}"
                             data-pid="${node.pid!}">
                            <#if node.children?has_content>
                                <span class="js-toggle" style="cursor:pointer;margin-right:4px;color:#999;font-size:11px;">▼</span>
                            <#else>
                                <span style="margin-right:4px;width:14px;display:inline-block;"></span>
                            </#if>
                            <input type="checkbox" name="menuIds" value="${node.id}"
                                   id="menu_${node.id}"
                                   <#if node.checked>checked</#if>
                                   class="menu-checkbox">
                            <label for="menu_${node.id}" style="margin-left:4px;">
                                <#if node.icon?has_content><i class="${node.icon}" style="margin-right:3px;"></i></#if>
                                ${node.name}
                                <#if node.url?has_content && node.url != "#" && node.url != "">
                                    <span class="menu-url">${node.url}</span>
                                </#if>
                            </label>
                        </div>
                        <#if node.children?has_content>
                            <div class="js-children" style="padding-left:16px;">
                                <@renderTree node.children />
                            </div>
                        </#if>
                    </#list>
                </#macro>
                <@renderTree menuTree />
            </div>
        </div>

        <div style="padding:12px 0 0 0; text-align:center;">
            <input type="hidden" id="js-role-id" value="${roleId}">
            <button class="layui-btn" id="js-submit-auth">保存授权</button>
            <button class="layui-btn layui-btn-primary" id="js-cancel">取消</button>
        </div>
    </div>
</div>
<script>
    // 全选/取消全选
    document.getElementById('js-check-all').onclick = function () {
        document.querySelectorAll('.menu-checkbox').forEach(function (cb) { cb.checked = true; });
    };
    document.getElementById('js-uncheck-all').onclick = function () {
        document.querySelectorAll('.menu-checkbox').forEach(function (cb) { cb.checked = false; });
    };
    document.getElementById('js-expand-all').onclick = function () {
        document.querySelectorAll('.js-children').forEach(function (el) { el.style.display = ''; });
        document.querySelectorAll('.js-toggle').forEach(function (el) { el.textContent = '▼'; });
    };
    document.getElementById('js-collapse-all').onclick = function () {
        document.querySelectorAll('.js-children').forEach(function (el) { el.style.display = 'none'; });
        document.querySelectorAll('.js-toggle').forEach(function (el) { el.textContent = '►'; });
    };

    // 折叠切换
    document.querySelectorAll('.js-toggle').forEach(function (el) {
        el.onclick = function () {
            var children = el.closest('.menu-tree-item').nextElementSibling;
            if (children && children.classList.contains('js-children')) {
                if (children.style.display === 'none') {
                    children.style.display = '';
                    el.textContent = '▼';
                } else {
                    children.style.display = 'none';
                    el.textContent = '►';
                }
            }
        };
    });

    // 父子联动：勾选父节点时联动子节点
    document.querySelectorAll('.menu-checkbox').forEach(function (cb) {
        cb.addEventListener('change', function () {
            var item = cb.closest('.menu-tree-item');
            var children = item.nextElementSibling;
            if (children && children.classList.contains('js-children')) {
                children.querySelectorAll('.menu-checkbox').forEach(function (child) {
                    child.checked = cb.checked;
                });
            }
        });
    });

    // 提交
    document.getElementById('js-submit-auth').onclick = function () {
        var roleId = document.getElementById('js-role-id').value;
        var menuIds = [];
        document.querySelectorAll('.menu-checkbox:checked').forEach(function (cb) {
            menuIds.push(cb.value);
        });

        var params = 'roleId=' + encodeURIComponent(roleId);
        menuIds.forEach(function (id) {
            params += '&menuIds=' + encodeURIComponent(id);
        });

        $.post('${request.contextPath}/admin/sys/role/auth-menu', params, function (res) {
            if (res.code === 0) {
                layer.msg('授权成功');
                var index = parent.layer.getFrameIndex(window.name);
                parent.layer.close(index);
            } else {
                layer.msg(res.msg || '授权失败');
            }
        });
    };

    document.getElementById('js-cancel').onclick = function () {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    };
</script>
</body>
</html>
