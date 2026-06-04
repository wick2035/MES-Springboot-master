<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户选择</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sp-search-row { padding: 8px 4px; }
        .sp-tree-box { border: 1px solid #e6e6e6; border-radius: 4px; padding: 8px; height: 430px; overflow: auto; margin: 0 4px; }
        .sp-tip { color: #999; font-size: 12px; padding: 4px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="sp-search-row layui-form">
            <div class="layui-inline">
                <input type="text" id="js-kw" placeholder="关键字（姓名/用户名）" autocomplete="off" class="layui-input"
                       style="width: 320px; display:inline-block;">
            </div>
            <button type="button" class="layui-btn layui-btn-sm" id="js-tree-search">
                <i class="layui-icon layui-icon-search"></i>搜索
            </button>
            <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" id="js-tree-clear">清除</button>
        </div>
        <div class="sp-tip">勾选要加入班组的用户（可勾选部门快速全选其下用户）</div>
        <div class="sp-tree-box">
            <div id="js-user-tree"></div>
        </div>

        <!-- spLayer「确定」会触发此隐藏按钮 -->
        <form class="layui-form layui-hide">
            <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
        </form>
    </div>
</div>
<script>
    layui.use(['tree', 'form', 'layer'], function () {
        var tree = layui.tree,
            layer = layui.layer,
            $ = layui.jquery;

        var contextPath = '${request.contextPath}';
        var TREE_ID = 'userTree';
        var fullData = [];

        // 渲染树
        function renderTree(data) {
            tree.render({
                elem: '#js-user-tree',
                data: data,
                id: TREE_ID,
                showCheckbox: true,
                onlyIconControl: true
            });
        }

        // 加载部门+用户树
        $.get(contextPath + '/basedata/team/user-dept-tree', function (res) {
            if (res.code === 0 && res.data) {
                fullData = res.data;
                renderTree(fullData);
            } else {
                layer.msg(res.msg || '加载用户树失败');
            }
        });

        // 关键字过滤（layui 2.5.6 tree 无内置搜索，前端重建数据）
        function filterTree(nodes, kw) {
            var result = [];
            for (var i = 0; i < nodes.length; i++) {
                var n = nodes[i];
                if (n.isUser) {
                    var hit = !kw
                        || (n.title && n.title.indexOf(kw) >= 0)
                        || (n.username && n.username.indexOf(kw) >= 0);
                    if (hit) {
                        result.push($.extend({}, n));
                    }
                } else {
                    var children = filterTree(n.children || [], kw);
                    var deptHit = kw && n.title && n.title.indexOf(kw) >= 0;
                    if (children.length > 0 || !kw || deptHit) {
                        var copy = $.extend({}, n);
                        copy.children = children;
                        copy.spread = true;
                        result.push(copy);
                    }
                }
            }
            return result;
        }

        $('#js-tree-search').on('click', function () {
            var kw = $.trim($('#js-kw').val());
            renderTree(filterTree(fullData, kw));
        });
        $('#js-kw').on('keydown', function (e) {
            if (e.keyCode === 13) { $('#js-tree-search').click(); return false; }
        });
        $('#js-tree-clear').on('click', function () {
            $('#js-kw').val('');
            renderTree(fullData);
        });

        // 递归收集勾选的用户节点 userId
        function collectUserIds(nodes, acc) {
            nodes.forEach(function (n) {
                if (n.isUser && n.userId) {
                    if (acc.indexOf(n.userId) < 0) acc.push(n.userId);
                }
                if (n.children && n.children.length) {
                    collectUserIds(n.children, acc);
                }
            });
            return acc;
        }

        // spLayer 点「确定」时触发，结果回传父页面
        layui.form.on('submit(js-submit-filter)', function () {
            var checked = tree.getChecked(TREE_ID);
            var userIds = collectUserIds(checked || [], []);
            window.spChildFrameResult = {
                code: 0,
                msg: '操作成功',
                data: userIds
            };
            return false;
        });
    });
</script>
</body>
</html>
