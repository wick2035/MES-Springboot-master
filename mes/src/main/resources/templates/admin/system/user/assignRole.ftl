<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>分配角色</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        :root {
            --accent: #0a84ff;
            --accent-soft: rgba(10, 132, 255, .08);
            --ink: #1d1d1f;
            --ink-2: #6e6e73;
            --line: #ececf0;
        }

        html, body {
            background: #f5f5f7;
            -webkit-font-smoothing: antialiased;
        }

        .ar-wrap {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC",
            "Hiragino Sans GB", "Microsoft YaHei", sans-serif;
            color: var(--ink);
            padding: 18px 20px 14px;
        }

        /* 顶部用户卡片 */
        .ar-head {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, .04), 0 6px 18px rgba(0, 0, 0, .03);
        }

        .ar-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            flex: 0 0 44px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 18px;
            font-weight: 600;
            background: linear-gradient(135deg, #0a84ff, #5e5ce6);
            letter-spacing: 0;
        }

        .ar-head-info { line-height: 1.5; min-width: 0; }
        .ar-head-name { font-size: 16px; font-weight: 600; }
        .ar-head-sub { font-size: 12px; color: var(--ink-2); }

        /* 工具条：搜索 + 计数 + 全选 */
        .ar-tools {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 16px 2px 12px;
        }

        .ar-search {
            flex: 1;
            position: relative;
        }

        .ar-search i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #b0b0b8;
            font-size: 15px;
        }

        .ar-search input {
            width: 100%;
            height: 36px;
            border: none;
            border-radius: 10px;
            background: #fff;
            padding: 0 12px 0 34px;
            font-size: 13px;
            color: var(--ink);
            outline: none;
            box-shadow: inset 0 0 0 1px var(--line);
            transition: box-shadow .18s ease;
        }

        .ar-search input:focus { box-shadow: inset 0 0 0 2px var(--accent); }

        .ar-count {
            font-size: 12px;
            color: var(--ink-2);
            white-space: nowrap;
        }
        .ar-count b { color: var(--accent); font-weight: 600; }

        .ar-allbtn {
            font-size: 12px;
            color: var(--accent);
            cursor: pointer;
            user-select: none;
            white-space: nowrap;
            padding: 4px 2px;
        }
        .ar-allbtn:hover { opacity: .7; }

        /* 角色网格 */
        .ar-list {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            max-height: 320px;
            overflow-y: auto;
            padding: 2px;
            margin: 0 -2px;
        }

        .ar-list::-webkit-scrollbar { width: 6px; }
        .ar-list::-webkit-scrollbar-thumb { background: #d2d2d7; border-radius: 6px; }

        .ar-item {
            position: relative;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 13px 14px;
            background: #fff;
            border-radius: 12px;
            cursor: pointer;
            box-shadow: inset 0 0 0 1px var(--line);
            transition: box-shadow .18s ease, transform .12s ease, background .18s ease;
        }

        .ar-item:hover { transform: translateY(-1px); box-shadow: inset 0 0 0 1px #d6d6db, 0 4px 14px rgba(0, 0, 0, .05); }
        .ar-item.checked { background: var(--accent-soft); box-shadow: inset 0 0 0 2px var(--accent); }
        .ar-item input { position: absolute; opacity: 0; pointer-events: none; }

        /* 自定义勾选圈 */
        .ar-tick {
            flex: 0 0 20px;
            width: 20px;
            height: 20px;
            margin-top: 1px;
            border-radius: 50%;
            box-shadow: inset 0 0 0 1.5px #cfcfd6;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all .18s ease;
        }

        .ar-tick i { color: #fff; font-size: 12px; opacity: 0; transform: scale(.5); transition: all .18s ease; }
        .ar-item.checked .ar-tick { background: var(--accent); box-shadow: inset 0 0 0 1.5px var(--accent); }
        .ar-item.checked .ar-tick i { opacity: 1; transform: scale(1); }

        .ar-body { min-width: 0; flex: 1; }
        .ar-name {
            font-size: 14px;
            font-weight: 600;
            color: var(--ink);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .ar-name .sys-tag {
            font-size: 10px;
            font-weight: 500;
            color: #b25e09;
            background: #fff3e0;
            border-radius: 5px;
            padding: 1px 6px;
        }
        .ar-meta { font-size: 11px; color: #a1a1a8; margin-top: 2px; }
        .ar-desc {
            font-size: 12px;
            color: var(--ink-2);
            margin-top: 5px;
            line-height: 1.4;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .ar-empty { grid-column: 1 / -1; text-align: center; color: #a1a1a8; padding: 40px 0; font-size: 13px; }
        .ar-noresult { grid-column: 1 / -1; text-align: center; color: #a1a1a8; padding: 30px 0; font-size: 13px; display: none; }
    </style>
</head>
<body>
<div class="ar-wrap">
    <#assign initial = 'U'>
    <#if (user.name)?? && user.name?has_content>
        <#assign initial = user.name?substring(0, 1)?upper_case>
    <#elseif (user.username)?? && user.username?has_content>
        <#assign initial = user.username?substring(0, 1)?upper_case>
    </#if>
    <div class="ar-head">
        <div class="ar-avatar">${initial}</div>
        <div class="ar-head-info">
            <div class="ar-head-name">${user.name!''}</div>
            <div class="ar-head-sub">
                @${user.username!''}<#if (user.mobile)?? && user.mobile != ''> · ${user.mobile}</#if>
            </div>
        </div>
    </div>

    <form id="js-form">
        <input type="hidden" name="userId" value="${user.id!''}">

        <div class="ar-tools">
            <div class="ar-search">
                <i class="layui-icon layui-icon-search"></i>
                <input type="text" id="js-keyword" placeholder="搜索角色名称或编码…" autocomplete="off">
            </div>
            <span class="ar-count">已选 <b id="js-count">0</b> 项</span>
            <span class="ar-allbtn" id="js-toggle-all">全选</span>
        </div>

        <div class="ar-list" id="js-role-list">
            <#if allRoles?? && allRoles?size gt 0>
                <#list allRoles as role>
                    <#assign isChecked = checkedIds?seq_contains(role.id) />
                    <label class="ar-item <#if isChecked>checked</#if>"
                           data-key="${(role.name!'')?lower_case} ${(role.code!'')?lower_case}">
                        <input type="checkbox" name="roleIds" value="${role.id}" lay-ignore <#if isChecked>checked</#if>>
                        <span class="ar-tick"><i class="layui-icon layui-icon-ok"></i></span>
                        <div class="ar-body">
                            <div class="ar-name">
                                <span>${role.name!''}</span>
                                <#if (role.isSystemRole!'0') == '1'><span class="sys-tag">系统</span></#if>
                            </div>
                            <div class="ar-meta">${role.code!''}</div>
                            <#if (role.descr)?? && role.descr != ''>
                                <div class="ar-desc">${role.descr}</div>
                            </#if>
                        </div>
                    </label>
                </#list>
            <#else>
                <div class="ar-empty">暂无可分配的角色</div>
            </#if>
            <div class="ar-noresult" id="js-noresult">没有匹配的角色</div>
        </div>

        <#-- 由弹窗底部「确定」按钮触发，隐藏提交按钮供 spLayer 点击 -->
        <button type="button" id="js-submit" class="layui-hide"></button>
    </form>
</div>
<script>
    var CTX = "${request.contextPath}";
    var $list = $('#js-role-list');

    // 计数 + 全选按钮文案
    function refreshState() {
        var total = $list.find('input[name=roleIds]').length;
        var checked = $list.find('input[name=roleIds]:checked').length;
        $('#js-count').text(checked);
        $('#js-toggle-all').text(checked > 0 && checked === total ? '取消全选' : '全选');
    }

    // 勾选切换样式
    $list.on('change', 'input[name=roleIds]', function () {
        $(this).closest('.ar-item').toggleClass('checked', this.checked);
        refreshState();
    });

    // 全选 / 取消全选（仅作用于当前可见项）
    $('#js-toggle-all').on('click', function () {
        var $visible = $list.find('.ar-item:visible input[name=roleIds]');
        var allChecked = $visible.length > 0 && $visible.filter(':checked').length === $visible.length;
        $visible.each(function () {
            this.checked = !allChecked;
            $(this).closest('.ar-item').toggleClass('checked', this.checked);
        });
        refreshState();
    });

    // 实时搜索过滤
    $('#js-keyword').on('input', function () {
        var kw = $.trim(this.value).toLowerCase();
        var shown = 0;
        $list.find('.ar-item').each(function () {
            var hit = !kw || $(this).attr('data-key').indexOf(kw) > -1;
            $(this).toggle(hit);
            if (hit) shown++;
        });
        $('#js-noresult').toggle(shown === 0 && $list.find('.ar-item').length > 0);
    });

    // 弹窗「确定」会点击此隐藏按钮，同步提交后由 spLayer 读取 spChildFrameResult 决定关闭
    $('#js-submit').on('click', function () {
        var userId = $('input[name=userId]').val();
        var roleIds = $list.find('input[name=roleIds]:checked').map(function () {
            return this.value;
        }).get();
        spUtil.submitForm({
            url: CTX + '/admin/sys/user/assign-role',
            traditional: true,
            data: {userId: userId, roleIds: roleIds}
        });
    });

    refreshState();
</script>
</body>
</html>
