<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>404 · 页面走丢了</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>html, body { height: 100%; }</style>
</head>
<body>
<div class="sp-error">
    <div class="sp-error-card">
        <div class="sp-error-code">404</div>
        <div class="sp-error-title">页面走丢了</div>
        <p class="sp-error-desc">抱歉，您访问的页面不存在或已被移动。<br>请检查地址是否正确，或返回首页继续操作。</p>
        <div class="sp-error-actions">
            <a class="layui-btn" href="${request.contextPath}/admin"><i class="layui-icon layui-icon-home"></i> 返回首页</a>
            <a class="layui-btn layui-btn-primary" href="javascript:history.back();">返回上一页</a>
        </div>
    </div>
</div>
</body>
</html>
