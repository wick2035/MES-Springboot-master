<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料信息定义</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sp-section-title {
            color: #FF5722;
            font-weight: bold;
            margin: 10px 0 12px 18px;
        }
        .sp-img-box {
            display: inline-block;
            position: relative;
            margin: 6px;
            border: 1px solid #e6e6e6;
            border-radius: 4px;
            padding: 2px;
        }
        .sp-img-box img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            display: block;
        }
        .sp-img-del {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #FF5722;
            color: #fff;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            line-height: 18px;
            text-align: center;
            cursor: pointer;
            font-size: 12px;
        }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <div class="sp-section-title">基本信息</div>
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">物料编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="materiel" readonly autocomplete="off"
                                   class="layui-input" style="background:#f2f2f2;" value="${result.materiel!''}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">系统自动生成</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">物料类型</label>
                        <div class="layui-input-inline">
                            <select name="matType" id="js-matType" lay-verify="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">规格/型号</label>
                        <div class="layui-input-inline">
                            <input type="text" name="model" autocomplete="off"
                                   class="layui-input" value="${result.model!''}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">物料来源</label>
                        <div class="layui-input-inline">
                            <select name="matSource" id="js-matSource" lay-verify="required">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">物料需求提前期(天)</label>
                        <div class="layui-input-inline">
                            <input type="number" name="leadTime" min="1" lay-verify="required|leadTime"
                                   autocomplete="off" class="layui-input" value="${(result.leadTime)!1}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">不可为0，至少1天</div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">物料名称</label>
                        <div class="layui-input-inline">
                            <input type="text" name="materielDesc" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.materielDesc!''}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">计量单位</label>
                        <div class="layui-input-inline">
                            <select name="unit" id="js-unit">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">材质</label>
                        <div class="layui-input-inline">
                            <select name="texture" id="js-texture">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">安全库存</label>
                        <div class="layui-input-inline">
                            <input type="number" name="safetyStock" min="0"
                                   autocomplete="off" class="layui-input" value="${(result.safetyStock)!0}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">可为0</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" style="width: 260px;">
                            <input type="radio" name="deleted" value="0" title="正常"
                                   <#if (result.deleted!'0') == '0'>checked</#if>>
                            <input type="radio" name="deleted" value="2" title="禁用"
                                   <#if (result.deleted!'') == '2'>checked</#if>>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">备注信息</label>
                <div class="layui-input-block" style="margin-right: 18px;">
                    <textarea name="remark" placeholder="请输入备注" class="layui-textarea">${result.remark!''}</textarea>
                </div>
            </div>

            <div class="sp-section-title">图片上传</div>
            <div class="layui-form-item">
                <div class="layui-input-block" style="margin-left: 18px;">
                    <button type="button" class="layui-btn layui-btn-normal" id="js-upload-img">
                        <i class="layui-icon">&#xe67c;</i>点击选择图片
                    </button>
                    <div class="layui-word-aux" style="margin-top:6px;">支持多张，便于与实物对照</div>
                    <div id="js-img-preview" style="margin-top:8px;"></div>
                </div>
            </div>

            <input type="hidden" name="imageUrls" id="js-imageUrls" value="${result.imageUrls!''}"/>

            <div class="layui-form-item layui-hide">
                <input id="js-id" name="id" value="${result.id!''}"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
            </div>
        </form>
    </div>
</div>

<script>
    layui.use(['form', 'upload', 'layer'], function () {
        var form = layui.form,
            upload = layui.upload,
            layer = layui.layer;
        var contextPath = '${request.contextPath}';

        // 图片相对路径数组
        var imgList = [];
        var initImg = '${result.imageUrls!''}';
        if (initImg) {
            $.each(initImg.split(','), function (i, p) {
                if (p) imgList.push(p);
            });
        }

        function renderImg() {
            var $box = $('#js-img-preview').empty();
            $.each(imgList, function (i, p) {
                $box.append(
                    '<div class="sp-img-box" data-path="' + p + '">' +
                    '<span class="sp-img-del" data-idx="' + i + '">×</span>' +
                    '<img src="' + contextPath + '/upload/' + p + '">' +
                    '</div>'
                );
            });
            $('#js-imageUrls').val(imgList.join(','));
        }
        renderImg();

        $('#js-img-preview').on('click', '.sp-img-del', function () {
            var idx = parseInt($(this).attr('data-idx'));
            imgList.splice(idx, 1);
            renderImg();
        });

        // 多图上传
        upload.render({
            elem: '#js-upload-img',
            url: contextPath + '/common/uploads',
            multiple: true,
            accept: 'images',
            field: 'files',
            done: function (res) {
                if (res.code === 0) {
                    $.each(res.data || [], function (i, item) {
                        if (item.filePath) imgList.push(item.filePath);
                    });
                    renderImg();
                } else {
                    layer.msg(res.msg || '图片上传失败');
                }
            },
            error: function () {
                layer.msg('图片上传请求失败');
            }
        });

        // 加载字典下拉
        function loadDict(type, selectId, selectedVal) {
            spUtil.ajax({
                url: contextPath + '/basedata/dict/list/' + type,
                async: false, type: 'GET', serializable: false, data: {},
                success: function (res) {
                    $.each(res.data, function (i, item) {
                        $('#' + selectId).append(new Option(item.name, item.value));
                    });
                }
            });
        }
        loadDict('material_type', 'js-matType');
        loadDict('material_source', 'js-matSource');
        loadDict('ORDER_UNIT', 'js-unit');
        loadDict('material_texture', 'js-texture');

        // 回显下拉选中值
        form.val('formTest', {
            'matType': '${result.matType!''}',
            'matSource': '${result.matSource!''}',
            'unit': '${result.unit!''}',
            'texture': '${result.texture!''}'
        });
        form.render('select');

        // 自定义校验：提前期不可为0
        form.verify({
            leadTime: function (value) {
                if (value === '' || parseInt(value) < 1) {
                    return '物料需求提前期不可为0，至少1天';
                }
            }
        });

        // 提交
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: contextPath + '/basedata/materile/add-or-update',
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
