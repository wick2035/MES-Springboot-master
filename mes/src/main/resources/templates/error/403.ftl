<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>403 · 没有访问权限</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>html, body { height: 100%; }</style>
</head>
<body>
<div class="sp-error">
    <div class="sp-error-card">
        <div class="sp-error-code">403</div>
        <div class="sp-error-title">没有访问权限</div>
        <p class="sp-error-desc">抱歉，您当前的账号没有访问该资源的权限。<br>如需开通，请联系系统管理员分配相应角色权限。</p>
        <div class="sp-error-actions">
            <a class="layui-btn" href="${request.contextPath}/admin"><i class="layui-icon layui-icon-home"></i> 返回首页</a>
            <a class="layui-btn layui-btn-primary" href="javascript:history.back();">返回上一页</a>
        </div>
    </div>
</div>
</body>
</html>
