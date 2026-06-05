<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>基本资料</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <#assign dispName = (result.name)!''>
    <#assign dispUser = (result.username)!''>
    <#if dispName?has_content>
        <#assign initial = dispName?substring(0,1)?upper_case>
    <#elseif dispUser?has_content>
        <#assign initial = dispUser?substring(0,1)?upper_case>
    <#else>
        <#assign initial = 'U'>
    </#if>
    <#assign picId = (result.picId)!''>
    <#assign status = (result.deleted)!'0'>
    <style>
        html, body { height: 100%; }
        body { background: var(--sp-bg); }

        .pf-wrap { padding: 16px; min-height: 100%; max-width: 1080px; margin: 0 auto; }

        /* ============ 身份 Hero ============ */
        .pf-hero {
            position: relative;
            overflow: hidden;
            border-radius: 14px;
            padding: 26px 30px;
            color: #fff;
            background: linear-gradient(120deg, #2563EB 0%, #1D4ED8 58%, #1E3A8A 100%);
            box-shadow: 0 14px 34px rgba(37, 99, 235, .22);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 28px;
            flex-wrap: wrap;
        }
        .pf-hero:after {
            content: "";
            position: absolute;
            right: -70px; top: -90px;
            width: 300px; height: 300px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, .16), transparent 62%);
            pointer-events: none;
        }
        .pf-hero:before {
            content: "";
            position: absolute;
            inset: 0;
            background-image:
                linear-gradient(rgba(255, 255, 255, .06) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 255, 255, .06) 1px, transparent 1px);
            background-size: 44px 44px;
            mask-image: linear-gradient(90deg, #000, transparent 72%);
            -webkit-mask-image: linear-gradient(90deg, #000, transparent 72%);
            pointer-events: none;
        }

        .pf-id { position: relative; z-index: 1; display: flex; align-items: center; gap: 20px; }

        /* 头像（可点击上传） */
        .pf-avatar {
            position: relative;
            width: 84px; height: 84px;
            border-radius: 50%;
            cursor: pointer;
            flex-shrink: 0;
            background: linear-gradient(135deg, rgba(255,255,255,.30), rgba(255,255,255,.08));
            box-shadow: 0 0 0 4px rgba(255, 255, 255, .25), 0 6px 16px rgba(0, 0, 0, .18);
            display: flex; align-items: center; justify-content: center;
            overflow: hidden;
            transition: transform .18s ease, box-shadow .18s ease;
        }
        .pf-avatar:hover { transform: translateY(-2px); box-shadow: 0 0 0 4px rgba(255,255,255,.45), 0 10px 22px rgba(0,0,0,.24); }
        .pf-avatar-initial { font-size: 34px; font-weight: 700; color: #fff; letter-spacing: 1px; user-select: none; }
        .pf-avatar-img { width: 100%; height: 100%; object-fit: cover; display: <#if picId?has_content>block<#else>none</#if>; }
        .pf-avatar-cam {
            position: absolute; left: 0; right: 0; bottom: 0;
            height: 26px; line-height: 26px; text-align: center;
            font-size: 12px; color: #fff;
            background: rgba(15, 23, 42, .42);
            opacity: 0; transition: opacity .18s ease;
        }
        .pf-avatar:hover .pf-avatar-cam { opacity: 1; }

        .pf-id-text .pf-name { margin: 0; font-size: 24px; font-weight: 750; letter-spacing: .3px; line-height: 1.2; }
        .pf-id-text .pf-username { margin: 6px 0 10px; font-size: 13px; color: rgba(255, 255, 255, .82); }
        .pf-role-chip {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 3px 12px;
            font-size: 12px; font-weight: 500;
            border-radius: 999px;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            color: #fff;
        }

        /* Hero 右侧统计 */
        .pf-stats { position: relative; z-index: 1; display: flex; gap: 0; }
        .pf-stat { padding: 0 22px; text-align: center; border-left: 1px solid rgba(255, 255, 255, .18); }
        .pf-stat:first-child { border-left: none; }
        .pf-stat .s-lbl { font-size: 12px; color: rgba(255, 255, 255, .78); }
        .pf-stat .s-val { margin-top: 7px; font-size: 15px; font-weight: 600; }
        .pf-stat .s-val .dot {
            display: inline-block; width: 7px; height: 7px; border-radius: 50%;
            background: #34D399; margin-right: 5px; vertical-align: middle;
            box-shadow: 0 0 0 3px rgba(52, 211, 153, .25);
        }
        .pf-stat .s-val.off .dot { background: #FCA5A5; box-shadow: 0 0 0 3px rgba(252, 165, 165, .25); }

        /* ============ 编辑卡 ============ */
        .pf-card {
            margin-top: 16px;
            background: var(--sp-surface);
            border: 1px solid var(--sp-border);
            border-radius: 12px;
            box-shadow: var(--sp-shadow-sm);
            padding: 6px 26px 22px;
        }

        .pf-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 2px 30px;
        }
        .pf-grid .layui-form-item { margin-bottom: 18px; }
        .pf-grid .layui-form-item:after { display: none; }
        .pf-col-full { grid-column: 1 / -1; }

        /* 标签上置、字段占满 —— 更现代克制 */
        .pf-grid .layui-form-label {
            float: none; display: block; width: auto;
            text-align: left; padding: 0 0 7px; line-height: 18px;
        }
        .pf-grid .layui-input-block,
        .pf-grid .layui-input-inline { float: none; display: block; margin-left: 0; width: auto; }
        .pf-grid .layui-input,
        .pf-grid .layui-textarea { width: 100%; }
        .pf-grid .layui-form-radio { margin-top: 0; }

        /* 底部操作条 */
        .pf-actions {
            margin-top: 6px; padding-top: 18px;
            border-top: 1px solid var(--sp-border);
            text-align: right;
        }

        @media screen and (max-width: 720px) {
            .pf-hero { justify-content: center; text-align: center; }
            .pf-id { flex-direction: column; text-align: center; }
            .pf-stats { width: 100%; justify-content: center; }
            .pf-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="pf-wrap">

    <!-- 身份 Hero -->
    <div class="pf-hero">
        <div class="pf-id">
            <div class="pf-avatar" id="pf-avatar" title="点击上传头像">
                <span class="pf-avatar-initial" id="pf-avatar-initial" <#if picId?has_content>style="display:none"</#if>>${initial}</span>
                <img class="pf-avatar-img" id="pf-avatar-img" <#if picId?has_content>src="${request.contextPath}/upload/${picId}"</#if> alt="">
                <span class="pf-avatar-cam"><i class="fa fa-camera"></i></span>
            </div>
            <div class="pf-id-text">
                <h1 class="pf-name" id="pf-show-name">${dispName!'未命名用户'}</h1>
                <div class="pf-username">@${dispUser!'-'}</div>
                <span class="pf-role-chip"><i class="fa fa-id-badge"></i> ${roleNames!'普通用户'}</span>
            </div>
        </div>
        <div class="pf-stats">
            <div class="pf-stat">
                <div class="s-lbl">所属部门</div>
                <div class="s-val">${deptName!'未分配'}</div>
            </div>
            <div class="pf-stat">
                <div class="s-lbl">账号状态</div>
                <div class="s-val <#if status != '0'>off</#if>"><span class="dot"></span><#if status == '0'>正常<#else>已禁用</#if></div>
            </div>
            <div class="pf-stat">
                <div class="s-lbl">注册时间</div>
                <div class="s-val">${joinDate!'--'}</div>
            </div>
        </div>
    </div>

    <!-- 编辑卡 -->
    <div class="pf-card">
        <div class="sp-section-title">编辑资料</div>
        <form class="layui-form" lay-filter="pf-form">
            <input type="hidden" name="picId" value="${picId}">
            <div class="pf-grid">
                <div class="layui-form-item">
                    <label class="layui-form-label sp-required" for="pf-name">姓名</label>
                    <div class="layui-input-block">
                        <input type="text" id="pf-name" name="name" lay-verify="required" placeholder="请输入姓名"
                               autocomplete="off" class="layui-input" value="${dispName}">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-block">
                        <input type="text" class="layui-input sp-readonly" value="${dispUser}" readonly>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label" for="pf-email">邮箱</label>
                    <div class="layui-input-block">
                        <input type="text" id="pf-email" name="email" lay-verify="pf-email" placeholder="name@example.com"
                               autocomplete="off" class="layui-input" value="${(result.email)!''}">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label" for="pf-mobile">手机号</label>
                    <div class="layui-input-block">
                        <input type="text" id="pf-mobile" name="mobile" lay-verify="pf-mobile" placeholder="请输入手机号"
                               autocomplete="off" class="layui-input" value="${(result.mobile)!''}">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label" for="pf-tel">固定电话</label>
                    <div class="layui-input-block">
                        <input type="text" id="pf-tel" name="tel" placeholder="选填，如 010-12345678"
                               autocomplete="off" class="layui-input" value="${(result.tel)!''}">
                    </div>
                </div>

                <#assign bday = (result.birthday)!''>
                <#if (bday?length > 10)><#assign bday = bday?substring(0, 10)></#if>
                <div class="layui-form-item">
                    <label class="layui-form-label" for="pf-birthday">出生日期</label>
                    <div class="layui-input-block">
                        <input type="text" id="pf-birthday" name="birthday" placeholder="yyyy-MM-dd"
                               autocomplete="off" class="layui-input" value="${bday}">
                    </div>
                </div>

                <#assign sexVal = (result.sex)!''>
                <div class="layui-form-item pf-col-full">
                    <label class="layui-form-label">性别</label>
                    <div class="layui-input-block">
                        <input type="radio" name="sex" value="1" title="男" <#if sexVal == '1' || !(sexVal?has_content)>checked</#if>>
                        <input type="radio" name="sex" value="0" title="女" <#if sexVal == '0'>checked</#if>>
                        <input type="radio" name="sex" value="2" title="其他" <#if sexVal == '2'>checked</#if>>
                    </div>
                </div>

                <div class="layui-form-item pf-col-full">
                    <label class="layui-form-label" for="pf-descr">个人简介</label>
                    <div class="layui-input-block">
                        <textarea id="pf-descr" name="descr" placeholder="一句话介绍自己…" class="layui-textarea">${(result.descr)!''}</textarea>
                    </div>
                </div>
            </div>

            <div class="pf-actions">
                <button type="button" class="layui-btn layui-btn-primary" id="pf-reset">重置</button>
                <button class="layui-btn" lay-submit lay-filter="pf-save"><i class="fa fa-check"></i> 保存修改</button>
            </div>
        </form>
    </div>
</div>

<script>
    var CTX = '${request.contextPath}';
    layui.use(['form', 'layer', 'laydate', 'upload'], function () {
        var form = layui.form,
            layer = layui.layer,
            laydate = layui.laydate,
            upload = layui.upload;

        form.render();

        laydate.render({elem: '#pf-birthday', trigger: 'click'});

        // 选填校验：有值才校验格式
        form.verify({
            'pf-email': function (value) {
                if (value && !/^[\w.+-]+@[\w-]+(\.[\w-]+)+$/.test(value)) return '邮箱格式不正确';
            },
            'pf-mobile': function (value) {
                if (value && !/^1[3-9]\d{9}$/.test(value)) return '手机号格式不正确';
            }
        });

        // 头像上传
        upload.render({
            elem: '#pf-avatar',
            url: CTX + '/common/upload',
            field: 'file',
            accept: 'images',
            acceptMime: 'image/*',
            done: function (res) {
                if (res.code === 0 && res.data && res.data.filePath) {
                    var p = res.data.filePath;
                    $('input[name=picId]').val(p);
                    $('#pf-avatar-img').attr('src', CTX + '/upload/' + p).show();
                    $('#pf-avatar-initial').hide();
                    layer.msg('头像已更新，记得点击「保存修改」', {icon: 1});
                } else {
                    layer.msg(res.msg || '上传失败', {icon: 2});
                }
            },
            error: function () {
                layer.msg('上传失败，请重试', {icon: 2});
            }
        });

        // 重置（回到服务端原值）
        $('#pf-reset').on('click', function () {
            location.reload();
        });

        // 保存
        form.on('submit(pf-save)', function (data) {
            spUtil.ajax({
                url: CTX + '/admin/sys/profile/update',
                type: 'POST',
                data: data.field,
                success: function (res) {
                    layer.msg(res.msg || '保存成功', {icon: 1});
                    // 顶部展示名同步
                    var nm = data.field.name || '';
                    $('#pf-show-name').text(nm || '未命名用户');
                    // 同步父级顶栏（姓名 + 头像）
                    try {
                        var $pName = parent.$('.sp-user-name');
                        if ($pName.length) $pName.text(nm);
                        var pic = $('input[name=picId]').val();
                        var $av = parent.$('.sp-user-avatar');
                        if ($av.length) {
                            if (pic) {
                                $av.text('').css({
                                    backgroundImage: 'url(' + CTX + '/upload/' + pic + ')',
                                    backgroundSize: 'cover',
                                    backgroundPosition: 'center',
                                    color: 'transparent'
                                });
                            } else {
                                $av.css({backgroundImage: 'none', color: ''})
                                   .text(nm ? nm.substring(0, 1).toUpperCase() : 'U');
                            }
                        }
                    } catch (e) {}
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
