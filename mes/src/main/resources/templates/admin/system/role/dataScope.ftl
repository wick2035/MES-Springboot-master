<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>数据权限</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">数据范围</label>
                <div class="layui-input-block">
                    <select name="dataScope" lay-filter="js-data-scope" lay-verify="required">
                        <option value="">请选择</option>
                        <option value="全部" <#if (result.dataScope)?? && result.dataScope == "全部">selected</#if>>全部数据</option>
                        <option value="本部门" <#if (result.dataScope)?? && result.dataScope == "本部门">selected</#if>>本部门</option>
                        <option value="本部门及子部门" <#if (result.dataScope)?? && result.dataScope == "本部门及子部门">selected</#if>>本部门及子部门</option>
                        <option value="仅本人" <#if (result.dataScope)?? && result.dataScope == "仅本人">selected</#if>>仅本人</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">业务范围</label>
                <div class="layui-input-block">
                    <select name="businessScope" lay-filter="js-business-scope">
                        <option value="">请选择</option>
                        <option value="全部业务" <#if (result.businessScope)?? && result.businessScope == "全部业务">selected</#if>>全部业务</option>
                        <option value="本部门业务" <#if (result.businessScope)?? && result.businessScope == "本部门业务">selected</#if>>本部门业务</option>
                        <option value="指定业务模块" <#if (result.businessScope)?? && result.businessScope == "指定业务模块">selected</#if>>指定业务模块</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <input id="js-id" name="id" value="${(result.id)!}">
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
            </div>
        </form>

        <div style="padding-top:12px; text-align:center;">
            <button class="layui-btn" onclick="document.getElementById('js-submit').click();">保存</button>
            <button class="layui-btn layui-btn-primary" id="js-cancel">取消</button>
        </div>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;

        form.on('submit(js-submit-filter)', function (data) {
            $.post('${request.contextPath}/admin/sys/role/data-scope', data.field, function (res) {
                if (res.code === 0) {
                    layer.msg('保存成功');
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);
                    // 刷新父页面表格
                    if (parent.tableIns) { parent.tableIns.reload(); }
                } else {
                    layer.msg(res.msg || '保存失败');
                }
            });
            return false;
        });
    });

    document.getElementById('js-cancel').onclick = function () {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    };
</script>
</body>
</html>
