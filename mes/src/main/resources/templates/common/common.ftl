<link rel="shortcut icon" href="${request.contextPath}/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" href="${request.contextPath}/lib/layui/css/layui.css" media="all">
<link rel="stylesheet" href="${request.contextPath}/lib/font-awesome-4.7.0/css/font-awesome.min.css" media="all">
<link rel="stylesheet" href="${request.contextPath}/css/public.css" media="all">
<link rel="stylesheet" href="${request.contextPath}/css/theme.css?v=1.1.8" media="all">
<!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
<!--[if lt IE 9]>
<script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
<script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
<script src="${request.contextPath}/lib/jquery/jquery.min.js?v=v2.2.0" charset="utf-8"></script>
<script src="${request.contextPath}/lib/layui/layui.js?v=v2.5.6" charset="utf-8"></script>
<script src="${request.contextPath}/js/spDataBus.js?v=1.0.4" charset="utf-8"></script>
<script src="${request.contextPath}/js/spConfig.js?v=1.0.0" charset="utf-8"></script>
<script src="${request.contextPath}/js/spUtil.js?v=1.0.0" charset="utf-8"></script>
<script src="${request.contextPath}/js/layuimodule/config.js?v=1.0.1" charset="utf-8"></script>
<script>
    // 全局搜索快捷键转发：在 iframe 子页内按 Ctrl/⌘ + K 唤起顶层 Spotlight 面板。
    // 顶层窗口由 index.ftl 自行绑定，这里仅处理「非顶层」以免重复触发相互抵消。
    if (window.top !== window.self) {
        document.addEventListener('keydown', function (e) {
            if ((e.ctrlKey || e.metaKey) && (e.key === 'k' || e.key === 'K')) {
                try {
                    if (window.top && window.top.spGlobalSearchToggle) {
                        e.preventDefault();
                        window.top.spGlobalSearchToggle();
                    }
                } catch (err) { /* 跨域或顶层未就绪时安全忽略 */ }
            }
        });
    }
</script>
