<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分配用户</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .assign-layout { display: flex; gap: 16px; height: 460px; }
        .assign-panel { flex: 1; border: 1px solid #e2e2e2; border-radius:4px; display:flex; flex-direction:column; }
        .assign-panel-header { padding: 8px 12px; background:#f2f2f2; border-bottom:1px solid #e2e2e2; font-weight:bold; font-size:13px; }
        .assign-panel-body { flex:1; overflow-y:auto; padding:8px; }
        .assign-arrows { display:flex; flex-direction:column; justify-content:center; align-items:center; gap:10px; padding: 0 8px; }
        .user-item { padding:6px 8px; cursor:pointer; border-radius:3px; font-size:13px; }
        .user-item:hover { background:#e8f4ff; }
        .user-item.selected { background:#d6eaf8; }
        .search-row { padding:8px; border-bottom:1px solid #eee; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <input type="hidden" id="js-role-id" value="${roleId}">

        <div class="assign-layout">
            <!-- 左侧：全部用户 -->
            <div class="assign-panel">
                <div class="assign-panel-header">全部用户</div>
                <div class="search-row">
                    <input type="text" id="js-all-search" class="layui-input" placeholder="搜索用户名/姓名" style="height:30px;">
                </div>
                <div class="assign-panel-body" id="js-all-users"></div>
            </div>

            <!-- 中间箭头 -->
            <div class="assign-arrows">
                <button class="layui-btn layui-btn-sm" id="js-add-btn" title="添加选中用户到角色">▶ 添加</button>
                <button class="layui-btn layui-btn-danger layui-btn-sm" id="js-remove-btn" title="从角色移除选中用户">◀ 移除</button>
            </div>

            <!-- 右侧：已分配用户 -->
            <div class="assign-panel">
                <div class="assign-panel-header">已分配用户</div>
                <div class="assign-panel-body" id="js-assigned-users"></div>
            </div>
        </div>

        <div style="padding:12px 0 0 0; text-align:center;">
            <button class="layui-btn layui-btn-primary" id="js-close">关闭</button>
        </div>
    </div>
</div>
<script>
    var roleId = document.getElementById('js-role-id').value;
    var contextPath = '${request.contextPath}';
    var allUsers = [];
    var assignedUserIds = new Set();

    function renderAllUsers(filter) {
        var container = document.getElementById('js-all-users');
        container.innerHTML = '';
        allUsers.forEach(function (u) {
            if (filter && u.username.indexOf(filter) < 0 && u.name.indexOf(filter) < 0) return;
            if (assignedUserIds.has(u.id)) return;
            var div = document.createElement('div');
            div.className = 'user-item';
            div.dataset.id = u.id;
            div.dataset.name = u.name;
            div.dataset.username = u.username;
            div.innerHTML = '<i class="layui-icon layui-icon-username" style="color:#999;"></i> ' +
                u.name + ' <span style="color:#aaa;font-size:11px;">(' + u.username + ')</span>';
            div.onclick = function () { this.classList.toggle('selected'); };
            container.appendChild(div);
        });
    }

    function renderAssignedUsers() {
        var container = document.getElementById('js-assigned-users');
        container.innerHTML = '';
        allUsers.forEach(function (u) {
            if (!assignedUserIds.has(u.id)) return;
            var div = document.createElement('div');
            div.className = 'user-item';
            div.dataset.id = u.id;
            div.innerHTML = '<i class="layui-icon layui-icon-username" style="color:var(--sp-primary);"></i> ' +
                u.name + ' <span style="color:var(--sp-text-muted);font-size:11px;">(' + u.username + ')</span>';
            div.onclick = function () { this.classList.toggle('selected'); };
            container.appendChild(div);
        });
    }

    // 加载全部用户
    $.post(contextPath + '/admin/sys/user/page', {current: 1, size: 999}, function (res) {
        if (res.code === 0 && res.data && res.data.records) {
            allUsers = res.data.records;
            loadAssigned();
        }
    });

    // 加载已分配用户
    function loadAssigned() {
        $.post(contextPath + '/admin/sys/role/assign-user/page', {roleId: roleId, current: 1, size: 999}, function (res) {
            assignedUserIds = new Set();
            if (res.code === 0 && res.data) {
                var data = Array.isArray(res.data) ? res.data : (res.data.records || []);
                data.forEach(function (ur) { assignedUserIds.add(ur.userId); });
            }
            renderAllUsers('');
            renderAssignedUsers();
        });
    }

    // 搜索过滤
    document.getElementById('js-all-search').oninput = function () {
        renderAllUsers(this.value.trim());
    };

    // 添加选中
    document.getElementById('js-add-btn').onclick = function () {
        var selected = document.querySelectorAll('#js-all-users .user-item.selected');
        if (selected.length === 0) { layer.msg('请先选择要添加的用户'); return; }
        var pending = [];
        selected.forEach(function (el) { pending.push(el.dataset.id); });
        var done = 0;
        pending.forEach(function (userId) {
            $.post(contextPath + '/admin/sys/role/assign-user/add', {roleId: roleId, userId: userId}, function () {
                assignedUserIds.add(userId);
                done++;
                if (done === pending.length) {
                    renderAllUsers(document.getElementById('js-all-search').value);
                    renderAssignedUsers();
                }
            });
        });
    };

    // 移除选中
    document.getElementById('js-remove-btn').onclick = function () {
        var selected = document.querySelectorAll('#js-assigned-users .user-item.selected');
        if (selected.length === 0) { layer.msg('请先选择要移除的用户'); return; }
        var pending = [];
        selected.forEach(function (el) { pending.push(el.dataset.id); });
        var done = 0;
        pending.forEach(function (userId) {
            $.post(contextPath + '/admin/sys/role/assign-user/remove', {roleId: roleId, userId: userId}, function () {
                assignedUserIds.delete(userId);
                done++;
                if (done === pending.length) {
                    renderAllUsers(document.getElementById('js-all-search').value);
                    renderAssignedUsers();
                }
            });
        });
    };

    document.getElementById('js-close').onclick = function () {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    };
</script>
</body>
</html>
