<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        html, body { height: 100%; }
        body { background: var(--sp-bg); }

        .pw-wrap {
            min-height: 100%;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 36px 16px;
        }
        .pw-card {
            width: 100%;
            max-width: 500px;
            background: var(--sp-surface);
            border: 1px solid var(--sp-border);
            border-radius: 14px;
            box-shadow: var(--sp-shadow-lg);
            padding: 34px 36px 30px;
        }

        /* 顶部锁徽标 */
        .pw-head { text-align: center; margin-bottom: 26px; }
        .pw-badge {
            width: 60px; height: 60px;
            margin: 0 auto 16px;
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 26px; color: #fff;
            background: linear-gradient(135deg, #2563EB 0%, #1E3A8A 100%);
            box-shadow: 0 10px 24px rgba(37, 99, 235, .30);
        }
        .pw-title { margin: 0; font-size: 20px; font-weight: 700; color: var(--sp-text); }
        .pw-sub { margin: 8px 0 0; font-size: 13px; color: var(--sp-text-secondary); }

        .pw-field { margin-bottom: 18px; }
        .pw-label { display: block; margin-bottom: 7px; font-size: 13px; font-weight: 500; color: var(--sp-text-secondary); }
        .pw-input { position: relative; }
        .pw-input .layui-input { padding-right: 40px; }
        .pw-eye {
            position: absolute; right: 0; top: 0;
            width: 38px; height: 36px;
            display: flex; align-items: center; justify-content: center;
            color: var(--sp-text-muted); cursor: pointer;
            transition: color .15s ease;
        }
        .pw-eye:hover { color: var(--sp-primary); }

        /* 强度条 */
        .pw-strength { margin-top: 10px; display: <#-- 默认隐藏 -->none; }
        .pw-strength.show { display: block; }
        .pw-bars { display: flex; gap: 6px; }
        .pw-bars span {
            flex: 1; height: 5px; border-radius: 999px;
            background: #E5E8EC; transition: background-color .2s ease;
        }
        .pw-strength.lv1 .pw-bars span:nth-child(1) { background: var(--sp-danger); }
        .pw-strength.lv2 .pw-bars span:nth-child(-n+2) { background: var(--sp-warning); }
        .pw-strength.lv3 .pw-bars span { background: var(--sp-success); }
        .pw-strength-text { margin-top: 6px; font-size: 12px; color: var(--sp-text-muted); }
        .pw-strength.lv1 .pw-strength-text { color: var(--sp-danger); }
        .pw-strength.lv2 .pw-strength-text { color: var(--sp-warning); }
        .pw-strength.lv3 .pw-strength-text { color: var(--sp-success); }

        /* 要求清单 */
        .pw-reqs { margin: 12px 0 4px; padding: 0; list-style: none; }
        .pw-reqs li {
            display: flex; align-items: center; gap: 8px;
            font-size: 12.5px; color: var(--sp-text-muted);
            line-height: 24px;
            transition: color .15s ease;
        }
        .pw-reqs li i {
            width: 16px; height: 16px; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 9px;
            background: #EEF1F5; color: var(--sp-text-muted);
            transition: all .15s ease;
        }
        .pw-reqs li.ok { color: var(--sp-success); }
        .pw-reqs li.ok i { background: var(--sp-success); color: #fff; }

        /* 匹配提示 */
        .pw-match { margin-top: 7px; font-size: 12px; height: 16px; }
        .pw-match.ok { color: var(--sp-success); }
        .pw-match.no { color: var(--sp-danger); }

        .pw-actions { margin-top: 22px; display: flex; gap: 10px; }
        .pw-actions .layui-btn { flex: 1; margin: 0; }
        .pw-actions .layui-btn-lg { height: 42px; line-height: 42px; }
    </style>
</head>
<body>
<div class="pw-wrap">
    <div class="pw-card">
        <div class="pw-head">
            <div class="pw-badge"><i class="fa fa-lock"></i></div>
            <h1 class="pw-title">修改密码</h1>
            <p class="pw-sub">定期更换密码，保护账号安全。修改成功后需重新登录。</p>
        </div>

        <form class="layui-form" lay-filter="pw-form">
            <div class="pw-field">
                <label class="pw-label" for="pw-old">当前密码</label>
                <div class="pw-input">
                    <input type="password" id="pw-old" name="oldPassword" lay-verify="required" placeholder="请输入当前密码"
                           autocomplete="off" class="layui-input">
                    <span class="pw-eye" data-target="pw-old"><i class="fa fa-eye-slash"></i></span>
                </div>
            </div>

            <div class="pw-field">
                <label class="pw-label" for="pw-new">新密码</label>
                <div class="pw-input">
                    <input type="password" id="pw-new" name="newPassword" lay-verify="required" placeholder="请输入新密码"
                           autocomplete="off" class="layui-input">
                    <span class="pw-eye" data-target="pw-new"><i class="fa fa-eye-slash"></i></span>
                </div>
                <div class="pw-strength" id="pw-strength">
                    <div class="pw-bars"><span></span><span></span><span></span></div>
                    <div class="pw-strength-text" id="pw-strength-text">密码强度</div>
                </div>
                <ul class="pw-reqs" id="pw-reqs">
                    <li data-rule="len"><i class="fa fa-check"></i> 至少 6 位字符</li>
                    <li data-rule="letter"><i class="fa fa-check"></i> 包含字母</li>
                    <li data-rule="digit"><i class="fa fa-check"></i> 包含数字</li>
                </ul>
            </div>

            <div class="pw-field">
                <label class="pw-label" for="pw-confirm">确认新密码</label>
                <div class="pw-input">
                    <input type="password" id="pw-confirm" name="confirmPassword" lay-verify="required" placeholder="请再次输入新密码"
                           autocomplete="off" class="layui-input">
                    <span class="pw-eye" data-target="pw-confirm"><i class="fa fa-eye-slash"></i></span>
                </div>
                <div class="pw-match" id="pw-match"></div>
            </div>

            <div class="pw-actions">
                <button type="button" class="layui-btn layui-btn-primary layui-btn-lg" id="pw-reset">重置</button>
                <button class="layui-btn layui-btn-lg" lay-submit lay-filter="pw-submit"><i class="fa fa-shield"></i> 确认修改</button>
            </div>
        </form>
    </div>
</div>

<script>
    var CTX = '${request.contextPath}';
    layui.use(['form', 'layer'], function () {
        var form = layui.form,
            layer = layui.layer;

        // 显隐切换
        $('.pw-eye').on('click', function () {
            var $i = $(this).find('i');
            var $input = $('#' + $(this).data('target'));
            if ($input.attr('type') === 'password') {
                $input.attr('type', 'text');
                $i.removeClass('fa-eye-slash').addClass('fa-eye');
            } else {
                $input.attr('type', 'password');
                $i.removeClass('fa-eye').addClass('fa-eye-slash');
            }
        });

        // 强度 + 要求清单
        function scorePwd(v) {
            var s = 0;
            if (v.length >= 6) s++;
            if (/[a-zA-Z]/.test(v)) s++;
            if (/\d/.test(v)) s++;
            if (v.length >= 10 || /[^\w]/.test(v)) s++;
            return s;
        }
        $('#pw-new').on('input', function () {
            var v = this.value;
            // 要求清单
            toggleReq('len', v.length >= 6);
            toggleReq('letter', /[a-zA-Z]/.test(v));
            toggleReq('digit', /\d/.test(v));
            // 强度
            var $st = $('#pw-strength').removeClass('lv1 lv2 lv3');
            if (!v) { $st.removeClass('show'); }
            else {
                $st.addClass('show');
                var sc = scorePwd(v);
                var lv = sc <= 1 ? 1 : (sc <= 3 ? 2 : 3);
                var txt = lv === 1 ? '弱 · 建议加长并混合字母数字' : (lv === 2 ? '中 · 还可以更强' : '强 · 安全性良好');
                $st.addClass('lv' + lv);
                $('#pw-strength-text').text('密码强度：' + txt);
            }
            checkMatch();
        });
        function toggleReq(rule, ok) {
            $('#pw-reqs li[data-rule=' + rule + ']').toggleClass('ok', ok);
        }

        // 一致性提示
        function checkMatch() {
            var n = $('#pw-new').val(), c = $('#pw-confirm').val();
            var $m = $('#pw-match').removeClass('ok no').text('');
            if (!c) return;
            if (n === c) $m.addClass('ok').html('<i class="fa fa-check-circle"></i> 两次输入一致');
            else $m.addClass('no').html('<i class="fa fa-times-circle"></i> 两次输入不一致');
        }
        $('#pw-confirm').on('input', checkMatch);

        $('#pw-reset').on('click', function () {
            $('#pw-old, #pw-new, #pw-confirm').val('');
            $('#pw-strength').removeClass('show lv1 lv2 lv3');
            $('#pw-reqs li').removeClass('ok');
            $('#pw-match').removeClass('ok no').text('');
        });

        // 提交
        form.on('submit(pw-submit)', function (data) {
            var f = data.field;
            if (f.newPassword.length < 6) { layer.msg('新密码长度不能少于 6 位', {icon: 2}); return false; }
            if (f.newPassword !== f.confirmPassword) { layer.msg('两次输入的新密码不一致', {icon: 2}); return false; }
            if (f.newPassword === f.oldPassword) { layer.msg('新密码不能与原密码相同', {icon: 2}); return false; }

            spUtil.ajax({
                url: CTX + '/admin/sys/profile/change-password',
                type: 'POST',
                data: {oldPassword: f.oldPassword, newPassword: f.newPassword},
                success: function (res) {
                    layer.msg(res.msg || '密码修改成功，请重新登录', {icon: 1, time: 1200});
                    setTimeout(function () {
                        top.location = CTX + '/login-ui';
                    }, 1200);
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
