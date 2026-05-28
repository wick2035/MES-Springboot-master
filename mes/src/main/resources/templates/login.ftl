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
        * {
            box-sizing: border-box;
        }

        html,
        body {
            width: 100%;
            min-height: 100%;
            margin: 0;
        }

        body {
            min-height: 100vh;
            overflow-x: hidden;
            color: #f8fafc;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
            background: #08111f url("${request.contextPath}/image/digitization.jpg") center center / cover no-repeat fixed;
        }

        body:before,
        body:after {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
        }

        body:before {
            z-index: 0;
            background:
                linear-gradient(115deg, rgba(3, 8, 19, 0.92) 0%, rgba(8, 17, 31, 0.78) 42%, rgba(9, 37, 58, 0.68) 100%),
                radial-gradient(circle at 20% 20%, rgba(64, 196, 255, 0.22), transparent 34%),
                radial-gradient(circle at 82% 18%, rgba(34, 211, 238, 0.14), transparent 30%);
        }

        body:after {
            z-index: 0;
            opacity: 0.3;
            background-image:
                linear-gradient(rgba(148, 163, 184, 0.12) 1px, transparent 1px),
                linear-gradient(90deg, rgba(148, 163, 184, 0.1) 1px, transparent 1px);
            background-size: 56px 56px;
            mask-image: linear-gradient(90deg, transparent 0%, #000 18%, #000 82%, transparent 100%);
        }

        .login-shell {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 1280px;
            margin: 0 auto;
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 480px);
            align-items: center;
            justify-items: center;
            gap: 72px;
            padding: 56px clamp(28px, 7vw, 112px);
        }

        .login-shell > .brand-panel {
            justify-self: start;
        }

        .brand-panel {
            max-width: 720px;
        }

        .brand-mark {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            height: 44px;
            padding: 0 18px 0 10px;
            border: 1px solid rgba(148, 163, 184, 0.24);
            border-radius: 999px;
            background: rgba(8, 15, 28, 0.52);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.08);
            color: #cbd5e1;
            font-size: 13px;
            letter-spacing: 0;
        }

        .brand-mark img {
            width: 28px;
            height: 28px;
            border-radius: 8px;
        }

        .brand-title {
            margin: 30px 0 18px;
            color: #ffffff;
            font-size: clamp(42px, 6vw, 72px);
            line-height: 1.02;
            font-weight: 700;
            letter-spacing: 0;
        }

        .brand-subtitle {
            max-width: 620px;
            margin: 0;
            color: rgba(226, 232, 240, 0.78);
            font-size: 18px;
            line-height: 1.8;
            letter-spacing: 0;
        }

        .signal-row {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
            max-width: 610px;
            margin-top: 42px;
        }

        .signal-item {
            min-height: 92px;
            padding: 16px;
            border: 1px solid rgba(148, 163, 184, 0.2);
            border-radius: 8px;
            background: rgba(8, 15, 28, 0.42);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06);
        }

        .signal-item strong {
            display: block;
            color: #f8fafc;
            font-size: 24px;
            line-height: 1.1;
            font-weight: 650;
            letter-spacing: 0;
        }

        .signal-item span {
            display: block;
            margin-top: 9px;
            color: rgba(203, 213, 225, 0.72);
            font-size: 13px;
            letter-spacing: 0;
        }

        .login-panel {
            position: relative;
            width: 100%;
            max-width: 430px;
            border: 1px solid rgba(226, 232, 240, 0.2);
            border-radius: 8px;
            padding: 34px;
            background: rgba(9, 16, 30, 0.72);
            box-shadow:
                0 32px 80px rgba(0, 0, 0, 0.46),
                inset 0 1px 0 rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
        }

        .login-panel:before {
            content: "";
            position: absolute;
            left: 24px;
            right: 24px;
            top: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(125, 211, 252, 0.8), transparent);
        }

        .login-heading {
            margin-bottom: 28px;
        }

        .login-heading h1 {
            margin: 0;
            color: #ffffff;
            font-size: 30px;
            line-height: 1.2;
            font-weight: 700;
            letter-spacing: 0;
        }

        .login-heading p {
            margin: 10px 0 0;
            color: rgba(203, 213, 225, 0.74);
            font-size: 14px;
            line-height: 1.7;
            letter-spacing: 0;
        }

        .login-form {
            background: transparent;
        }

        .login-form .layui-form-item {
            position: relative;
            margin-bottom: 18px;
        }

        .login-form .layui-form-item label {
            position: absolute;
            left: 15px;
            top: 50%;
            z-index: 2;
            width: 22px;
            height: 22px;
            line-height: 22px;
            margin-top: -11px;
            text-align: center;
            color: rgba(148, 163, 184, 0.95);
        }

        .login-form .layui-input {
            height: 48px;
            padding-left: 48px;
            border: 1px solid rgba(148, 163, 184, 0.28);
            border-radius: 8px;
            background: rgba(15, 23, 42, 0.68);
            color: #f8fafc;
            font-size: 15px;
            letter-spacing: 0;
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04);
            transition: border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .login-form .layui-input::placeholder {
            color: rgba(148, 163, 184, 0.72);
        }

        .login-form .layui-input:focus {
            border-color: rgba(56, 189, 248, 0.78);
            background: rgba(15, 23, 42, 0.82);
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.14);
        }

        .captcha-row {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 124px;
            gap: 12px;
        }

        .captcha-row .layui-form-item {
            margin-bottom: 0;
        }

        .captcha-img {
            width: 124px;
            height: 48px;
            border: 1px solid rgba(148, 163, 184, 0.28);
            border-radius: 8px;
            overflow: hidden;
            background: rgba(226, 232, 240, 0.92);
            cursor: pointer;
        }

        .captcha-img img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .form-options {
            margin: 18px 0 22px;
            color: rgba(203, 213, 225, 0.78);
        }

        .form-options .layui-form-checkbox[lay-skin=primary] span {
            color: rgba(203, 213, 225, 0.78);
        }

        .form-options .layui-form-checked[lay-skin=primary] i {
            border-color: #22d3ee !important;
            background-color: #22d3ee;
        }

        .login-button {
            height: 50px;
            border: 0;
            border-radius: 8px;
            background: linear-gradient(135deg, #22d3ee 0%, #2563eb 100%);
            color: #ffffff;
            font-size: 16px;
            font-weight: 650;
            letter-spacing: 0;
            box-shadow: 0 16px 34px rgba(37, 99, 235, 0.3);
            transition: transform 0.2s ease, box-shadow 0.2s ease, filter 0.2s ease;
        }

        .login-button:hover {
            color: #ffffff;
            filter: brightness(1.05);
            transform: translateY(-1px);
            box-shadow: 0 20px 42px rgba(37, 99, 235, 0.38);
        }

        .login-footer {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-top: 22px;
            color: rgba(148, 163, 184, 0.76);
            font-size: 12px;
            line-height: 1.6;
            letter-spacing: 0;
        }

        @media (max-width: 1180px) {
            body {
                background-attachment: scroll;
            }

            .login-shell {
                grid-template-columns: 1fr;
                justify-items: center;
                gap: 34px;
                padding: 36px 22px;
            }

            .login-shell > .brand-panel {
                justify-self: center;
                text-align: center;
            }

            .brand-panel {
                max-width: 100%;
            }

            .signal-row {
                margin-left: auto;
                margin-right: auto;
            }

            .brand-title {
                margin-top: 22px;
                font-size: 42px;
            }

            .brand-subtitle {
                font-size: 16px;
            }

            .signal-row {
                grid-template-columns: 1fr;
                margin-top: 24px;
            }

            .login-panel {
                max-width: 430px;
                margin: 0 auto;
                padding: 28px;
            }
        }

        @media (max-width: 480px) {
            .login-shell {
                padding: 26px 14px;
            }

            .brand-mark {
                max-width: 100%;
                height: auto;
                min-height: 42px;
                padding: 8px 14px 8px 8px;
                white-space: normal;
            }

            .brand-title {
                font-size: 34px;
            }

            .brand-subtitle {
                font-size: 14px;
            }

            .login-panel {
                padding: 24px 18px;
            }

            .login-heading h1 {
                font-size: 26px;
            }

            .captcha-row {
                grid-template-columns: 1fr;
            }

            .captcha-img {
                width: 100%;
            }

            .login-footer {
                display: block;
            }
        }
    </style>
</head>
<body>
<div class="login-shell">
    <section class="brand-panel" aria-label="MES系统-PRO">
        <div class="brand-mark">
            <img src="${request.contextPath}/image/logo.png" alt="">
            <span>Manufacturing Execution Intelligence</span>
        </div>
        <h1 class="brand-title">MES系统-PRO</h1>
        <p class="brand-subtitle">面向生产计划、工艺流转、物料追踪与现场执行的数据化制造中枢。</p>
        <div class="signal-row" aria-hidden="true">
            <div class="signal-item">
                <strong>Realtime</strong>
                <span>产线状态同步</span>
            </div>
            <div class="signal-item">
                <strong>Trace</strong>
                <span>过程数据追溯</span>
            </div>
            <div class="signal-item">
                <strong>Control</strong>
                <span>执行闭环管控</span>
            </div>
        </div>
    </section>

    <section class="layui-form login-panel" aria-label="登录">
        <div class="login-heading">
            <h1>MES系统-PRO</h1>
            <p>进入智能制造控制台</p>
        </div>
        <form class="layui-form login-form" action="">
            <div class="layui-form-item">
                <label class="layui-icon layui-icon-username" for="username"></label>
                <input id="username" type="text" name="username" lay-verify="required|account" placeholder="用户名或者邮箱" autocomplete="off" class="layui-input" value="admin">
            </div>
            <div class="layui-form-item">
                <label class="layui-icon layui-icon-password" for="password"></label>
                <input id="password" type="password" name="password" lay-verify="required|password" placeholder="密码" autocomplete="off" class="layui-input" value="123">
            </div>
            <div class="captcha-row">
                <div class="layui-form-item">
                    <label class="layui-icon layui-icon-vercode" for="captcha"></label>
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
                <button class="layui-btn layui-btn-fluid login-button" lay-submit="" lay-filter="login">登入</button>
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
