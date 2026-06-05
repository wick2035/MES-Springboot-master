<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料信息定义</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <!--查询参数-->
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">物料编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materielLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materielDescLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料类型</label>
                    <div class="layui-input-inline">
                        <select name="matType" id="js-q-matType"><option value="">全部</option></select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">物料来源</label>
                    <div class="layui-input-inline">
                        <select name="matSource" id="js-q-matSource"><option value="">全部</option></select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="deleted">
                            <option value="">全部</option>
                            <option value="0">正常</option>
                            <option value="2">禁用</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i>查询</a>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>

        <!--操作按钮栏-->
        <div class="layui-btn-container" style="margin-bottom: 10px;">
            <@shiro.hasPermission name="user:add">
                <button class="layui-btn layui-btn-sm" id="js-btn-add"><i class="layui-icon">&#xe61f;</i>新增</button>
            </@shiro.hasPermission>
            <button class="layui-btn layui-btn-sm" id="js-btn-import"><i class="layui-icon">&#xe67c;</i>导入</button>
            <a class="layui-btn layui-btn-primary layui-btn-sm" href="${request.contextPath}/basedata/materile/import-template">
                <i class="layui-icon">&#xe601;</i>下载模板
            </a>
        </div>

        <!--表格-->
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<!--行操作模板-->
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<!--js逻辑-->
<script>
    layui.use(['form', 'table', 'layer', 'upload', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            upload = layui.upload,
            spLayer = layui.spLayer,
            spTable = layui.spTable;

        var contextPath = '${request.contextPath}';

        // ---- 加载字典为 {value:name} 映射（同步），用于列展示与查询下拉 ----
        function loadDict(type, selectId) {
            var map = {};
            spUtil.ajax({
                url: contextPath + '/basedata/dict/list/' + type,
                async: false, type: 'GET', serializable: false, data: {},
                success: function (res) {
                    $.each(res.data, function (i, item) {
                        map[item.value] = item.name;
                        if (selectId) {
                            $('#' + selectId).append(new Option(item.name, item.value));
                        }
                    });
                }
            });
            return map;
        }

        var matTypeMap = loadDict('material_type', 'js-q-matType');
        var matSourceMap = loadDict('material_source', 'js-q-matSource');
        var textureMap = loadDict('material_texture', null);
        var unitMap = loadDict('ORDER_UNIT', null);
        form.render('select');

        function dictName(map, v) {
            return (v != null && map[v] != null) ? map[v] : (v || '');
        }

        // 表格及数据初始化
        var tableIns = spTable.render({
            elem: '#js-record-table',
            url: contextPath + '/basedata/materile/page',
            toolbar: false,
            cols: [
                [{
                    field: 'materiel', title: '物料编码', width: 110
                }, {
                    field: 'materielDesc', title: '物料名称', width: 130
                }, {
                    field: 'matType', title: '物料类型', width: 90, templet: function (d) {
                        return dictName(matTypeMap, d.matType);
                    }
                }, {
                    field: 'unit', title: '计量单位', width: 90, templet: function (d) {
                        return dictName(unitMap, d.unit);
                    }
                }, {
                    field: 'model', title: '规格/型号', width: 110
                }, {
                    field: 'texture', title: '材质', width: 80, templet: function (d) {
                        return dictName(textureMap, d.texture);
                    }
                }, {
                    field: 'leadTime', title: '物料需求提前期(天)', width: 140
                }, {
                    field: 'safetyStock', title: '安全库存', width: 90
                }, {
                    field: 'matSource', title: '物料来源', width: 90, templet: function (d) {
                        return dictName(matSourceMap, d.matSource);
                    }
                }, {
                    field: 'deleted', title: '状态', width: 80, templet: function (d) {
                        return spConfig.isDeletedDict[d.deleted];
                    }
                }, {
                    field: 'updateTime', title: '更新时间', width: 160
                }, {
                    field: 'remark', title: '备注信息', width: 120
                }, {
                    fixed: 'right',
                    field: 'operate',
                    title: '操作',
                    toolbar: '#js-record-table-toolbar-right',
                    unresize: true,
                    width: 130
                }]
            ],
            done: function (res, curr, count) {
            }
        });

        $(function () {
            form.render();
        });

        // 搜索
        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({where: data.field, page: {curr: 1}});
            return false;
        });

        // 新增
        $('#js-btn-add').on('click', function () {
            spLayer.open({
                title: '新增物料',
                area: ['900px', '90%'],
                content: contextPath + '/basedata/materile/add-or-update-ui',
                reload: false,
                spCallback: function (res) {
                    if (res && res.code === 0) {
                        tableIns.reload();
                    }
                }
            });
        });

        // 导入（layui upload 绑定到「导入」按钮）
        upload.render({
            elem: '#js-btn-import',
            url: contextPath + '/basedata/materile/import',
            accept: 'file',
            exts: 'xls|xlsx',
            field: 'file',
            auto: true,
            before: function () {
                layer.load(2);
            },
            done: function (res) {
                layer.closeAll('loading');
                if (res.code === 0) {
                    layer.alert(res.msg || '导入完成', {title: '导入结果'});
                    tableIns.reload();
                } else {
                    layer.msg(res.msg || '导入失败');
                }
            },
            error: function () {
                layer.closeAll('loading');
                layer.msg('导入请求失败');
            }
        });

        // 行工具：编辑/删除
        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'edit') {
                spLayer.open({
                    title: '编辑物料',
                    area: ['900px', '90%'],
                    spWhere: {id: data.id},
                    content: contextPath + '/basedata/materile/add-or-update-ui',
                    reload: false,
                    spCallback: function (res) {
                        if (res && res.code === 0) {
                            tableIns.reload();
                        }
                    }
                });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除物料【' + (data.materielDesc || data.materiel) + '】吗？', function (index) {
                    spUtil.ajax({
                        url: contextPath + '/basedata/materile/delete',
                        async: false, type: 'POST', showLoading: true, serializable: false,
                        data: {id: data.id},
                        success: function () {
                            tableIns.reload();
                            layer.close(index);
                        }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
