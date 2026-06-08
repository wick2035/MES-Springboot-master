<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MES系统-PRO</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <link rel="shortcut icon" href="./favicon.ico" type="image/x-icon"/>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        * { box-sizing: border-box; }

        html, body {
            width: 100%;
            min-height: 100%;
            margin: 0;
        }

        body {
            min-height: 100vh;
            overflow-x: hidden;
            color: #1F2937;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", "PingFang SC", sans-serif;
            background: #F4F6F9;
        }

        /* 浅色蓝图底纹 */
        body:before,
        body:after {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 0;
        }
        body:before {
            background:
                radial-gradient(circle at 16% 22%, rgba(37, 99, 235, 0.10), transparent 38%),
                radial-gradient(circle at 88% 12%, rgba(37, 99, 235, 0.06), transparent 34%),
                linear-gradient(180deg, #FBFCFE 0%, #F1F4F9 100%);
        }
        body:after {
            opacity: 0.6;
            background-image:
                linear-gradient(rgba(37, 99, 235, 0.05) 1px, transparent 1px),
                linear-gradient(90deg, rgba(37, 99, 235, 0.05) 1px, transparent 1px);
            background-size: 48px 48px;
            mask-image: radial-gradient(circle at 30% 40%, #000 0%, transparent 70%);
            -webkit-mask-image: radial-gradient(circle at 30% 40%, #000 0%, transparent 70%);
        }

        .login-shell {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 1240px;
            margin: 0 auto;
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 460px);
            align-items: center;
            justify-items: center;
            gap: 64px;
            padding: 56px clamp(28px, 7vw, 104px);
        }

        .login-shell > .brand-panel { justify-self: start; }
        .brand-panel { max-width: 720px; }

        .brand-mark {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            height: 42px;
            padding: 0 16px 0 8px;
            border: 1px solid #E5E8EC;
            border-radius: 999px;
            background: #FFFFFF;
            box-shadow: 0 1px 2px rgba(16, 24, 40, .05);
            color: #5B6573;
            font-size: 13px;
            letter-spacing: .2px;
        }
        .brand-mark img { width: 26px; height: 26px; border-radius: 7px; }

        .brand-title {
            margin: 28px 0 16px;
            color: #111827;
            font-size: clamp(40px, 6vw, 64px);
            line-height: 1.05;
            font-weight: 750;
            letter-spacing: -.5px;
        }
        .brand-title .accent { color: #2563EB; }

        .brand-subtitle {
            max-width: 560px;
            margin: 0;
            color: #5B6573;
            font-size: 17px;
            line-height: 1.8;
        }

        .position-relative { position: relative; }
        .position-absolute { position: absolute; }

        /* fit2cloud 同款分层浮动 banner */
        .f2c-banner {
            width: 100%;
            max-width: 720px;
            margin-top: 28px;
        }
        .f2c-banner img { display: block; }
        .f2c-bg {
            width: 100%;
            height: auto;
            filter: drop-shadow(0 18px 40px rgba(16, 24, 40, .12));
        }
        .f2c-banner .position-absolute { height: auto; z-index: 2; }
        .f2c-banner .position-absolute img { width: 100%; height: auto; }
        .f2c-animate-img-bottom { width: 60%; }
        .f2c-animate-img-block  { width: 36%; }
        .f2c-animate-img-left   { width: 13%; }
        .f2c-animate-img-right  { width: 7.7%; }
        .f2c-animate-img-AI     { width: 16.4%; }

        @keyframes f2cFloat {
            0%, 100% { transform: translateY(0); }
            50%      { transform: translateY(-14px); }
        }
        .f2c-animate-img-bottom { animation: f2cFloat 6s ease-in-out infinite; }
        .f2c-animate-img-block  { animation: f2cFloat 5s ease-in-out infinite .4s; }
        .f2c-animate-img-left   { animation: f2cFloat 4.5s ease-in-out infinite .8s; }
        .f2c-animate-img-right  { animation: f2cFloat 5.5s ease-in-out infinite .2s; }
        .f2c-animate-img-AI     { animation: f2cFloat 4s ease-in-out infinite .6s; }

        @media (prefers-reduced-motion: reduce) {
            .f2c-banner .position-absolute { animation: none !important; }
        }

        .login-panel {
            position: relative;
            width: 100%;
            max-width: 420px;
            border: 1px solid #E5E8EC;
            border-radius: 12px;
            padding: 34px 32px;
            background: #FFFFFF;
            box-shadow: 0 18px 48px rgba(16, 24, 40, .10), 0 2px 8px rgba(16, 24, 40, .05);
        }
        .login-panel:before {
            content: "";
            position: absolute;
            left: 22px;
            right: 22px;
            top: 0;
            height: 3px;
            border-radius: 0 0 4px 4px;
            background: linear-gradient(90deg, transparent, #2563EB, transparent);
        }

        .login-heading { margin-bottom: 26px; }
        .login-heading h1 {
            margin: 0;
            color: #111827;
            font-size: 26px;
            line-height: 1.2;
            font-weight: 700;
        }
        .login-heading p {
            margin: 9px 0 0;
            color: #98A2B3;
            font-size: 14px;
            line-height: 1.7;
        }

        .login-form { background: transparent; }
        .login-form .layui-form-item { position: relative; margin-bottom: 16px; }
        .login-form .layui-form-item > label.icon-label {
            position: absolute;
            left: 14px;
            top: 50%;
            z-index: 2;
            width: 22px;
            height: 22px;
            line-height: 22px;
            margin-top: -11px;
            text-align: center;
            color: #98A2B3;
            font-size: 16px;
        }
        .login-form .layui-input {
            height: 46px;
            padding-left: 44px;
            border: 1px solid #D5D9DF;
            border-radius: 8px;
            background: #FFFFFF;
            color: #1F2937;
            font-size: 15px;
            transition: border-color .2s ease, box-shadow .2s ease;
        }
        .login-form .layui-input::placeholder { color: #98A2B3; }
        .login-form .layui-input:focus {
            border-color: #2563EB;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
        }

        .captcha-row {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 122px;
            gap: 12px;
        }
        .captcha-row .layui-form-item { margin-bottom: 0; }
        .captcha-img {
            width: 122px;
            height: 46px;
            border: 1px solid #D5D9DF;
            border-radius: 8px;
            overflow: hidden;
            background: #F4F6F9;
            cursor: pointer;
        }
        .captcha-img img { display: block; width: 100%; height: 100%; object-fit: cover; }

        .form-options { margin: 16px 0 20px; color: #5B6573; }
        .form-options .layui-form-checkbox[lay-skin=primary] span { color: #5B6573; }
        .form-options .layui-form-checked[lay-skin=primary] i {
            border-color: #2563EB !important;
            background-color: #2563EB;
        }

        .login-button {
            height: 48px;
            border: 0;
            border-radius: 8px;
            background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%);
            color: #FFFFFF;
            font-size: 16px;
            font-weight: 600;
            letter-spacing: .5px;
            box-shadow: 0 12px 26px rgba(37, 99, 235, .26);
            transition: transform .2s ease, box-shadow .2s ease, filter .2s ease;
        }
        .login-button:hover {
            color: #FFFFFF;
            filter: brightness(1.04);
            transform: translateY(-1px);
            box-shadow: 0 16px 34px rgba(37, 99, 235, .32);
        }

        .login-footer {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 22px;
            color: #98A2B3;
            font-size: 12px;
            line-height: 1.6;
        }

        @media (max-width: 1180px) {
            .login-shell {
                grid-template-columns: 1fr;
                justify-items: center;
                gap: 32px;
                padding: 40px 22px;
            }
            .login-shell > .brand-panel { justify-self: center; text-align: center; }
            .brand-panel { max-width: 100%; }
            .f2c-banner { margin-left: auto; margin-right: auto; max-width: 460px; margin-top: 24px; }
            .brand-title { margin-top: 20px; font-size: 40px; }
            .brand-subtitle { font-size: 15px; }
            .login-panel { max-width: 420px; margin: 0 auto; }
        }
        @media (max-width: 480px) {
            .login-shell { padding: 26px 14px; }
            .brand-mark { max-width: 100%; height: auto; min-height: 42px; padding: 8px 14px 8px 8px; white-space: normal; }
            .brand-title { font-size: 32px; }
            .login-panel { padding: 26px 20px; }
            .login-heading h1 { font-size: 23px; }
            .captcha-row { grid-template-columns: 1fr; }
            .captcha-img { width: 100%; }
            .login-footer { display: block; }
        }
    </style>
</head>
<body>
<div class="login-shell">
    <section class="brand-panel" aria-label="MES系统-PRO">
        <h1 class="brand-title">MES<span class="accent">系统</span>-PRO</h1>
        <p class="brand-subtitle">面向生产计划、工艺流转、物料追踪与现场执行的智能制造中枢。</p>
        <div class="f2c-banner position-relative" aria-hidden="true">
            <div class="f2c-animate-img-bottom position-absolute" style="bottom: 14%; right: 12%">
                <img src="${request.contextPath}/image/banner/banner-bottom.png" alt="">
            </div>
            <div class="f2c-animate-img-block position-absolute" style="top: 6%; left: 38%">
                <img src="${request.contextPath}/image/banner/banner-block.png" alt="">
            </div>
            <div class="f2c-animate-img-left position-absolute" style="top: 18%; left: 20%">
                <img src="${request.contextPath}/image/banner/banner-left.png" alt="">
            </div>
            <div class="f2c-animate-img-right position-absolute" style="top: 18%; right: 23%">
                <img src="${request.contextPath}/image/banner/banner-right.png" alt="">
            </div>
            <div class="f2c-animate-img-AI position-absolute" style="top: 8%; left: 47%">
                <img src="${request.contextPath}/image/banner/banner-AI.png" alt="">
            </div>
            <img class="f2c-bg" src="${request.contextPath}/image/banner/banner-bg.png" alt="">
        </div>
    </section>

    <section class="layui-form login-panel" aria-label="登录">
        <div class="login-heading">
            <h1>欢迎登录</h1>
            <p>进入智能制造控制台</p>
        </div>
        <form class="layui-form login-form" action="">
            <div class="layui-form-item">
                <label class="layui-icon layui-icon-username icon-label" for="username"></label>
                <input id="username" type="text" name="username" lay-verify="required|account" placeholder="用户名或者邮箱" autocomplete="off" class="layui-input" value="admin">
            </div>
            <div class="layui-form-item">
                <label class="layui-icon layui-icon-password icon-label" for="password"></label>
                <input id="password" type="password" name="password" lay-verify="required|password" placeholder="密码" autocomplete="off" class="layui-input" value="123">
            </div>
            <div class="captcha-row">
                <div class="layui-form-item">
                    <label class="layui-icon layui-icon-vercode icon-label" for="captcha"></label>
                    <input id="captcha" type="text" name="captcha" lay-verify="required|captcha" placeholder="图形验证码" autocomplete="off" class="layui-input verification">
                </div>
                <div class="captcha-img" title="点击刷新验证码">
                    <img id="captchaPic" alt="验证码">
                </div>
            </div>
            <div class="layui-form-item form-options">
                <input type="checkbox" name="rememberMe" value="true" lay-skin="primary" title="记住密码">
            </div>
            <div class="layui-form-item">
                <button class="layui-btn layui-btn-fluid login-button" lay-submit="" lay-filter="login">登 入</button>
            </div>
        </form>
        <div class="login-footer">
            <span>MES系统-PRO</span>
            <span>Secure Access</span>
        </div>
    </section>
</div>
<script>
    layui.use(['form', 'layer'], function () {
        var form = layui.form,
            layer = layui.layer;

        // 登录过期的时候，跳出iframe框架
        if (top.location != self.location) top.location = self.location;

        form.on('submit(login)', function (data) {
            $.ajax({
                type: "POST",
                url: "${request.contextPath}/login",
                data: data.field,
                success: function (result) {
                    if (result.code === 0) {
                        location.href = '${request.contextPath}/admin'
                    } else {
                        layer.alert(result.msg, {
                            icon: 2
                        })
                    }
                },
                error: function (e) {
                    layer.alert(e, {
                        icon: 2
                    })
                }
            });
            return false;
        });

        $('#captchaPic').click(function () {
            this.src = "${request.contextPath}/verification/code?" + Math.random();
        });
        $("#captchaPic").click();
    });
</script>
</body>
</html>
