<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑部门</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
                <legend style="font-size:14px;">基本信息</legend>
            </fieldset>

            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md10">
                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">部门名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${(result.name)!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-parent-id" class="layui-form-label">上级部门</label>
                        <div class="layui-input-inline">
                            <select id="js-parent-id" name="parentId" lay-search>
                                <option value="0">无（顶级部门）</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-sort-num" class="layui-form-label">排序号</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-sort-num" name="sortNum"
                                   autocomplete="off" class="layui-input" value="${(result.sortNum)!0}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" style="width: 220px;">
                            <input type="radio" name="isDeleted" value="0" title="正常"
                                   <#if !(result.isDeleted)?? || result.isDeleted == "0">checked</#if>>
                            <input type="radio" name="isDeleted" value="2" title="禁用"
                                   <#if (result.isDeleted)?? && result.isDeleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${(result.id)!}"/>
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;

        // 加载部门树到上级部门下拉框
        function loadDeptTree() {
            $.get('${request.contextPath}/admin/sys/department/tree', function (res) {
                if (res.code === 0 && res.data) {
                    var currentParentId = '${(result.parentId)!"0"}';
                    var currentId = '${(result.id)!""}';
                    var $select = $('#js-parent-id');
                    // 保留第一个默认选项
                    $select.find('option:gt(0)').remove();

                    function appendOptions(nodes, level) {
                        if (!nodes) return;
                        for (var i = 0; i < nodes.length; i++) {
                            var node = nodes[i];
                            // 编辑时排除自身（不能选自己为上级）
                            if (currentId && node.id === currentId) continue;
                            var prefix = '';
                            for (var j = 0; j < level; j++) {
                                prefix += '├─';
                            }
                            var $option = $('<option value="' + node.id + '">' + prefix + node.name + '</option>');
                            if (node.id === currentParentId) {
                                $option.attr('selected', 'selected');
                            }
                            $select.append($option);
                            if (node.children && node.children.length > 0) {
                                appendOptions(node.children, level + 1);
                            }
                        }
                    }

                    appendOptions(res.data, 0);
                    form.render('select');
                }
            });
        }

        loadDeptTree();

        // 监听提交
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/department/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>