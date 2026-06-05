<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BOM树形结构</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .bom-header-bar {
            padding: 8px 12px;
            background: #f8f8f8;
            border-bottom: 1px solid #e2e2e2;
            font-size: 13px;
            color: #555;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .bom-header-bar span strong { color: #333; margin-right: 4px; }
        .bom-lock-badge {
            display: inline-block; padding: 1px 8px; border-radius: 10px;
            font-size: 11px; color: #fff;
        }
        .lock-draft  { background: #98A2B3; }
        .lock-locked { background: #D97706; }

        .bom-main-wrap {
            display: flex;
            height: calc(100vh - 110px);
            overflow: hidden;
        }

        /* 左侧树面板 */
        .bom-left-panel {
            width: 240px;
            min-width: 180px;
            overflow-y: auto;
            border-right: 1px solid #e2e2e2;
            padding: 8px 4px;
            flex-shrink: 0;
        }
        .bom-left-panel .layui-tree-entry { cursor: pointer; }
        .bom-left-panel .layui-tree-entry:hover { background: #EFF4FF; }
        .bom-left-panel .bom-tree-active > .layui-tree-entry { background: #e5f3ff; }

        /* 右侧表格面板 */
        .bom-right-panel {
            flex: 1;
            overflow: hidden;
            padding: 0 8px;
            display: flex;
            flex-direction: column;
        }
        .bom-right-panel-title {
            font-size: 12px;
            color: #999;
            padding: 6px 0 4px 0;
            border-bottom: 1px solid #f0f0f0;
            margin-bottom: 4px;
        }
        #js-right-table-wrap { flex: 1; overflow: auto; }

        /* 节点类型颜色 */
        .nt-product { color: #D97706; font-weight: bold; }
        .nt-part    { color: #16BAAA; }
        .nt-mat     { color: #98A2B3; }
    </style>
</head>
<body>
<div class="splayui-container" style="padding:0;">
    <!-- 顶部信息栏 -->
    <div class="bom-header-bar">
        <span><strong>BOM编码:</strong>${(bom.bomCode)!''}</span>
        <span><strong>物料:</strong>${(bom.materielCode)!''} ${(bom.materielDesc)!''}</span>
        <span><strong>版本:</strong>V${(bom.versionNumber)!''}</span>
        <span><strong>层级:</strong>
            <#if (bom.bomLevel)??>
                <#if bom.bomLevel == 0>成品BOM<#elseif bom.bomLevel == 1>半成品BOM<#else>组件BOM</#if>
            </#if>
        </span>
        <span><strong>定版:</strong>
            <#if (bom.lockStatus)?? && bom.lockStatus == 'locked'>
                <span class="bom-lock-badge lock-locked">已定版</span>
            <#else>
                <span class="bom-lock-badge lock-draft">草稿</span>
            </#if>
        </span>
    </div>

    <!-- 左右分栏 -->
    <div class="bom-main-wrap">

        <!-- 左侧：层级导航树 -->
        <div class="bom-left-panel">
            <div id="js-bom-left-tree"></div>
        </div>

        <!-- 右侧：节点明细表 -->
        <div class="bom-right-panel">
            <div class="bom-right-panel-title" id="js-right-panel-title">BOM完整层级</div>
            <div id="js-right-table-wrap">
                <table id="js-bom-right-table"></table>
            </div>
        </div>
    </div>
</div>

<script>
    layui.use(['tree', 'treeTable'], function () {
        var tree = layui.tree;
        var treeTable = layui.treeTable;
        var bomId = '${(bomId)!''}';

        // 存储完整树数据供节点点击时查找子树
        var fullTreeRoot = null;

        // ===== 加载BOM树数据 =====
        spUtil.ajax({
            url: '${request.contextPath}/technology/bom/tree-data',
            type: 'GET',
            data: { bomId: bomId },
            showLoading: true,
            success: function (res) {
                if (res.code !== 0) {
                    layer.msg(res.msg || '加载失败', { icon: 2 });
                    return;
                }
                fullTreeRoot = res.data;
                if (!fullTreeRoot) return;

                // 构建左侧 layui tree 数据
                var leftData = buildLeftTree(fullTreeRoot);

                tree.render({
                    elem: '#js-bom-left-tree',
                    data: [leftData],
                    showCheckbox: false,
                    click: function (obj) {
                        var nodeId = obj.data.customId;
                        var found = findNodeById(fullTreeRoot, nodeId);
                        var title = obj.data.title || '';
                        $('#js-right-panel-title').text('当前节点：' + title);
                        renderRightTable(found ? [found] : [fullTreeRoot]);
                    }
                });

                // 默认显示完整树
                $('#js-right-panel-title').text('BOM完整层级（点击左侧节点查看子树）');
                renderRightTable([fullTreeRoot]);
            },
            error: function () {
                layer.msg('BOM树数据加载失败', { icon: 2 });
            }
        });

        // ===== 将BomTreeNodeVO转成layui tree节点格式 =====
        function buildLeftTree(node) {
            var item = {
                title: (node.materielDesc || node.materielCode || '-'),
                customId: node.id,     // 自定义字段，用于找回原始节点
                spread: (node.level != null && node.level < 2)
            };
            if (node.children && node.children.length > 0) {
                item.children = node.children
                    .filter(function (c) { return c.nodeType !== '物料'; })
                    .map(buildLeftTree);
                // 左侧树只显示非叶节点（产品/零部件），物料叶子不显示在左树
                if (item.children.length === 0) delete item.children;
            }
            return item;
        }

        // ===== 在树中按id查找节点（DFS） =====
        function findNodeById(node, id) {
            if (node.id === id) return node;
            if (node.children) {
                for (var i = 0; i < node.children.length; i++) {
                    var found = findNodeById(node.children[i], id);
                    if (found) return found;
                }
            }
            return null;
        }

        // ===== 渲染右侧 treeTable =====
        function renderRightTable(rows) {
            // 重置DOM保证treeTable可以重新渲染
            $('#js-right-table-wrap').html('<table id="js-bom-right-table"></table>');

            treeTable.render({
                elem: '#js-bom-right-table',
                data: rows,
                tree: {
                    idName: 'id',
                    pidName: 'pid',
                    childName: 'children',
                    haveChildName: 'haveChild',
                    openName: 'open',
                    iconIndex: 0,
                    isPidData: false
                },
                cols: [
                    {
                        field: 'materielDesc', title: '节点名称', width: 200
                    },
                    {
                        field: 'level', title: '节点层级', width: 80, align: 'center'
                    },
                    {
                        field: 'nodeCode', title: '节点编号', width: 130
                    },
                    {
                        field: 'nodeType', title: '节点类型', width: 80, align: 'center',
                        templet: function (d) {
                            var cls = { '产品': 'nt-product', '零部件': 'nt-part', '物料': 'nt-mat' };
                            return '<span class="' + (cls[d.nodeType] || '') + '">' + (d.nodeType || '-') + '</span>';
                        }
                    },
                    {
                        field: 'itemNum', title: '数量', width: 90, align: 'center',
                        templet: function (d) {
                            if (d.itemNum == null) return '-';
                            return d.itemNum + (d.itemUnit ? ' ' + d.itemUnit : '');
                        }
                    },
                    {
                        field: 'updateTime', title: '更新时间', width: 140
                    }
                ]
            });
        }
    });
</script>
</body>
</html>
