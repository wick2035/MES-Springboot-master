<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>黑科开源-MES系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <#include "${request.contextPath}/common/common.ftl">
    <link rel="stylesheet" href="${request.contextPath}/css/splayui.css?v=1.3.1" media="all">
    <style id="splayui-bg-color">
    </style>
</head>
<body class="layui-layout-body splayui-all">
<div class="layui-layout layui-layout-admin">

    <div class="layui-header header">
        <div class="layui-logo">
        </div>
        <a>
            <div class="splayui-tool"><i title="展开" class="fa fa-outdent" data-side-fold="1"></i></div>
        </a>

        <ul class="layui-nav layui-layout-left layui-header-menu layui-header-pc-menu mobile layui-hide-xs">
        </ul>
        <ul class="layui-nav layui-layout-left layui-header-menu mobile layui-hide-sm">
            <li class="layui-nav-item">
                <a href="javascript:;"><i class="fa fa-list-ul"></i> 选择模块</a>
                <dl class="layui-nav-child layui-header-menu">
                </dl>
            </li>
        </ul>

        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item splayui-tools">
                <a href="javascript:;" data-refresh="刷新" title="刷新当前页"><i class="fa fa-refresh"></i></a>
            </li>
            <li class="layui-nav-item splayui-tools">
                <a href="javascript:;" data-clear="清理" class="splayui-clear" title="清理缓存"><i class="fa fa-trash-o"></i></a>
            </li>
            <li class="layui-nav-item splayui-tools">
                <a href="javascript:;" data-fullscreen="全屏" title="全屏切换"><i class="fa fa-arrows-alt"></i></a>
            </li>
            <#assign cuName = (currentUser.name)!''>
            <#if !(cuName?has_content)><#assign cuName = (currentUser.username)!'用户'></#if>
            <#assign cuPic = (currentUser.picId)!''>
            <#if cuName?has_content><#assign cuInitial = cuName?substring(0,1)?upper_case><#else><#assign cuInitial = 'U'></#if>
            <#assign cuRole = (roleName)!''>
            <#if !(cuRole?has_content)><#assign cuRole = '系统用户'></#if>
            <li class="layui-nav-item splayui-setting">
                <a href="javascript:;" class="sp-user">
                    <#if cuPic?has_content>
                        <span class="sp-user-avatar" style="background-image:url('${request.contextPath}/upload/${cuPic}');background-size:cover;background-position:center;color:transparent;"></span>
                    <#else>
                        <span class="sp-user-avatar">${cuInitial}</span>
                    </#if>
                    <span class="sp-user-meta">
                        <cite class="sp-user-name">${cuName}</cite>
                        <cite class="sp-user-role">${cuRole}</cite>
                    </span>
                </a>
                <dl class="layui-nav-child">
                    <dd>
                        <a href="javascript:;" data-iframe-tab="${request.contextPath}/admin/sys/profile/setting-ui" data-title="基本资料"
                           data-icon="fa fa-user-o"><i class="fa fa-user-o"></i> 基本资料</a>
                    </dd>
                    <dd>
                        <a href="javascript:;" data-iframe-tab="${request.contextPath}/admin/sys/profile/password-ui" data-title="修改密码"
                           data-icon="fa fa-key"><i class="fa fa-key"></i> 修改密码</a>
                    </dd>
                    <dd>
                        <a class="login-out" href="${request.contextPath}/login-ui"><i class="fa fa-sign-out"></i> 退出登录</a>
                    </dd>
                </dl>
            </li>
        </ul>
    </div>
    <form class="layui-form splayui-side-form">
        <div class="layui-side layui-bg-black splayui-side-form">
            <div class="splayui-side-inner">
                <div class="layui-side-scroll layui-left-menu">
                </div>
            </div>

            <div layui-left-menu class="splayui-side-search">
                <button type="button" class="sp-gs-trigger" id="js-gs-trigger">
                    <i class="layui-icon layui-icon-search"></i>
                    <span class="sp-gs-trigger-text">全局搜索</span>
                    <kbd class="sp-gs-kbd"><span class="sp-gs-mod">Ctrl</span>K</kbd>
                </button>
            </div>
        </div>
    </form>

    <div class="layui-body">
        <div class="layui-tab" lay-filter="splayuiTab" id="top_tabs_box">
            <ul class="layui-tab-title" id="top_tabs">
                <li class="layui-this" id="splayuiHomeTabId" lay-id=""></li>
            </ul>
            <ul class="layui-nav closeBox">
                <li class="layui-nav-item">
                    <a href="javascript:;"> <i class="fa fa-dot-circle-o"></i> 页面操作</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-page-close="other"><i class="fa fa-window-close"></i> 关闭其他</a>
                        </dd>
                        <dd><a href="javascript:;" data-page-close="all"><i class="fa fa-window-close-o"></i> 关闭全部</a>
                        </dd>
                    </dl>
                </li>
            </ul>
            <div class="layui-tab-content clildFrame">
                <div id="splayuiHomeTabIframe" class="layui-tab-item layui-show">
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 全局搜索 · Spotlight 命令面板 -->
<div id="js-gs" class="sp-gs" hidden>
    <div class="sp-gs-backdrop"></div>
    <div class="sp-gs-panel" role="dialog" aria-modal="true" aria-label="全局搜索">
        <div class="sp-gs-head">
            <i class="layui-icon layui-icon-search sp-gs-head-icon"></i>
            <input type="text" id="js-gs-input" class="sp-gs-input" placeholder="搜索菜单、功能…"
                   autocomplete="off" spellcheck="false" aria-label="搜索菜单、功能">
            <button type="button" class="sp-gs-esc" id="js-gs-close">esc</button>
        </div>
        <div class="sp-gs-body">
            <ul class="sp-gs-list" id="js-gs-list"></ul>
            <div class="sp-gs-empty" id="js-gs-empty" hidden>
                <i class="layui-icon layui-icon-search"></i>
                <p>未找到与“<span id="js-gs-empty-kw"></span>”相关的菜单</p>
            </div>
        </div>
        <div class="sp-gs-foot">
            <span><kbd>↑</kbd><kbd>↓</kbd> 选择</span>
            <span><kbd>↵</kbd> 打开</span>
            <span><kbd>esc</kbd> 关闭</span>
        </div>
    </div>
</div>

<script>
    layui.use(['element', 'layer', 'spLayui', 'form', 'jquery'], function () {
        var element = layui.element,
            layer = layui.layer,
            spLayui = layui.spLayui,
            form = layui.form,
            $ = layui.jquery;

        spLayui.init('${request.contextPath}/admin/list/index/menu/tree');

        /* ===================== 全局搜索（Spotlight 命令面板） ===================== */
        (function () {
            var $wrap = $('#js-gs'),
                $input = $('#js-gs-input'),
                $list = $('#js-gs-list'),
                $empty = $('#js-gs-empty'),
                $emptyKw = $('#js-gs-empty-kw');

            var index = [];      // 菜单扁平索引
            var matches = [];    // 当前过滤结果
            var activeIndex = -1;
            var isOpen = false;

            // Mac 下把键帽改为 ⌘
            if (/Mac|iPhone|iPad/.test(navigator.platform)) {
                $('.sp-gs-mod').text('⌘ ');
            }

            // 转义用于正则/HTML（字符类刻意避开「美元+花括号」相邻序列，以免被 FreeMarker 解析）
            function escapeReg(s) {
                return s.replace(/[.*+?^$()|[\]{}\\]/g, '\\$&');
            }
            function escapeHtml(s) {
                return $('<div>').text(s == null ? '' : s).html();
            }

            // 扫描已渲染的左侧菜单，构建扁平索引
            function buildIndex() {
                index = [];
                $('.layui-left-menu a[data-tab]').each(function () {
                    var $a = $(this);
                    var name = $.trim($a.find('.layui-left-nav').text());
                    if (!name) {
                        return;
                    }
                    var icon = $a.children('i').attr('class') || 'fa fa-circle-o';
                    // 面包屑：逐层向上收集分组名（每个 dl.layui-nav-child 前的分组锚点即该层标题）
                    var path = [];
                    $a.parents('dl.layui-nav-child').each(function () {
                        var $grpA = $(this).prevAll('a').first();
                        var t = $.trim($grpA.find('.layui-left-nav').text());
                        if (t && t !== name) {
                            path.unshift(t);
                        }
                    });
                    // 模块名：所属 ul 的 id 对应表头菜单
                    var moduleId = $a.closest('ul.layui-left-nav-tree').attr('id');
                    if (moduleId) {
                        var mName = $.trim($('#' + moduleId + 'HeaderId').text());
                        if (mName && mName !== name) {
                            path.unshift(mName);
                        }
                    }
                    index.push({ name: name, icon: icon, path: path, el: this });
                });
            }

            // 过滤：前缀命中优先、其次子串（匹配名称与路径）
            function filter(kw) {
                kw = $.trim(kw).toLowerCase();
                if (!kw) {
                    return index.slice(0, 50);
                }
                var starts = [], contains = [];
                for (var i = 0; i < index.length; i++) {
                    var it = index[i];
                    var name = it.name.toLowerCase();
                    var hay = (it.path.join(' ') + ' ' + it.name).toLowerCase();
                    if (name.indexOf(kw) === 0) {
                        starts.push(it);
                    } else if (hay.indexOf(kw) > -1) {
                        contains.push(it);
                    }
                }
                return starts.concat(contains).slice(0, 50);
            }

            // 高亮命中片段（先转义文本，再按转义后的关键字匹配）
            function highlight(text, kw) {
                if (!kw) {
                    return escapeHtml(text);
                }
                return escapeHtml(text).replace(
                    new RegExp('(' + escapeReg(escapeHtml(kw)) + ')', 'ig'),
                    '<mark class="sp-gs-hl">$1</mark>'
                );
            }

            function render(kw) {
                matches = filter(kw);
                if (!matches.length) {
                    $list.empty().hide();
                    $emptyKw.text(kw);
                    $empty.prop('hidden', false).show();
                    activeIndex = -1;
                    return;
                }
                $empty.prop('hidden', true).hide();
                var html = '';
                for (var i = 0; i < matches.length; i++) {
                    var it = matches[i];
                    var crumb = it.path.length
                        ? '<span class="sp-gs-item-path">' + escapeHtml(it.path.join(' › ')) + '</span>'
                        : '';
                    html += '<li class="sp-gs-item" data-idx="' + i + '">'
                        + '<span class="sp-gs-item-icon"><i class="' + escapeHtml(it.icon) + '"></i></span>'
                        + '<span class="sp-gs-item-name">' + highlight(it.name, kw) + '</span>'
                        + crumb
                        + '</li>';
                }
                $list.html(html).show();
                setActive(0);
            }

            function setActive(i) {
                var $items = $list.children('.sp-gs-item');
                if (!$items.length) {
                    activeIndex = -1;
                    return;
                }
                if (i < 0) { i = $items.length - 1; }
                if (i >= $items.length) { i = 0; }
                activeIndex = i;
                $items.removeClass('is-active');
                var $cur = $items.eq(i).addClass('is-active');
                var el = $cur[0];
                if (el && el.scrollIntoView) {
                    el.scrollIntoView({ block: 'nearest' });
                }
            }

            function selectItem(i) {
                if (i < 0 || i >= matches.length) {
                    return;
                }
                var el = matches[i].el;
                close();
                // 复用现有「点击菜单开标签」逻辑
                $(el).trigger('click');
            }

            function open() {
                if (isOpen) {
                    return;
                }
                if (!index.length) {
                    buildIndex();
                }
                isOpen = true;
                $wrap.prop('hidden', false);
                // 触发进场动画
                requestAnimationFrame(function () { $wrap.addClass('is-open'); });
                $('body').addClass('sp-gs-lock');
                $input.val('');
                render('');
                setTimeout(function () { $input.trigger('focus'); }, 0);
            }

            function close() {
                if (!isOpen) {
                    return;
                }
                isOpen = false;
                $wrap.removeClass('is-open');
                $('body').removeClass('sp-gs-lock');
                setTimeout(function () { $wrap.prop('hidden', true); }, 180);
            }

            function toggle() {
                isOpen ? close() : open();
            }

            // 暴露给 iframe 内快捷键调用
            window.spGlobalSearchToggle = toggle;

            // —— 事件绑定 ——
            $('#js-gs-trigger').on('click', open);
            $('#js-gs-close').on('click', close);
            $wrap.find('.sp-gs-backdrop').on('click', close);

            $input.on('input', function () {
                render($(this).val());
            });

            $input.on('keydown', function (e) {
                if (e.key === 'ArrowDown') {
                    e.preventDefault();
                    setActive(activeIndex + 1);
                } else if (e.key === 'ArrowUp') {
                    e.preventDefault();
                    setActive(activeIndex - 1);
                } else if (e.key === 'Enter') {
                    e.preventDefault();
                    selectItem(activeIndex);
                } else if (e.key === 'Escape') {
                    e.preventDefault();
                    close();
                }
            });

            $list.on('mouseenter', '.sp-gs-item', function () {
                setActive(parseInt($(this).attr('data-idx'), 10));
            }).on('click', '.sp-gs-item', function () {
                selectItem(parseInt($(this).attr('data-idx'), 10));
            });

            // 本窗口快捷键：Ctrl/⌘ + K 切换
            $(document).on('keydown', function (e) {
                if ((e.ctrlKey || e.metaKey) && (e.key === 'k' || e.key === 'K')) {
                    e.preventDefault();
                    toggle();
                } else if (e.key === 'Escape' && isOpen) {
                    close();
                }
            });
        })();
    });
</script>
</body>
</html>