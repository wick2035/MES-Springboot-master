<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺内容编制</title>
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .step-bar {
            display: flex; align-items: center; padding: 12px 16px; background:#fafafa;
            border-bottom: 1px solid #eee; gap: 0;
        }
        .step-item {
            display:flex; align-items:center; flex:1;
        }
        .step-circle {
            width: 32px; height: 32px; border-radius:50%; background:#ccc; color:#fff;
            display:flex; align-items:center; justify-content:center; font-weight:bold; flex-shrink:0;
        }
        .step-circle.active { background:#2563EB; }
        .step-circle.done   { background:#16BAAA; }
        .step-label { margin-left:8px; font-size:13px; color:#666; }
        .step-label.active { color:#2563EB; font-weight: bold; }
        .step-line { flex: 1; height: 2px; background: #ddd; margin: 0 4px; }
        .step-line.done { background:#16BAAA; }

        .panel { padding: 16px 20px; }
        .panel-title { font-size: 14px; color:#D97706; font-weight: bold; margin-bottom: 12px; border-left: 3px solid #D97706; padding-left:8px; }
        .img-preview-list { display:flex; gap:10px; flex-wrap:wrap; margin-top: 8px; }
        .img-preview-item { position: relative; }
        .img-preview-item img { width: 120px; height: 90px; object-fit: cover; border: 1px solid #ddd; }
        .img-preview-item .del-btn {
            position: absolute; top: -8px; right: -8px; width: 20px; height: 20px;
            background: #2563EB; color: #fff; border-radius: 50%; text-align: center;
            line-height: 20px; cursor: pointer; font-size: 12px;
        }
        .attach-item { padding: 6px 10px; background:#f0f0f0; border-radius:3px; margin: 4px 0; }
        .panel-footer { padding: 16px 20px; border-top: 1px solid #eee; text-align:center; }
        .layui-form-label { width: 110px; }
        .lock-banner {
            margin: 12px 16px 0; padding: 10px 14px; border-left: 4px solid #16BAAA;
            background: #f0fdfa; color: #0f766e; font-weight: 600;
        }
        .content-locked .layui-input,
        .content-locked .layui-textarea,
        .content-locked select {
            background: #f5f7fa !important; color: #555;
        }
    </style>
</head>
<body class="<#if contentLocked?? && contentLocked>content-locked</#if>">
<div>
    <#if contentLocked?? && contentLocked>
    <div class="lock-banner">当前工序已完成编制并锁定，页面仅支持查看，不能再编辑。</div>
    </#if>

    <!-- 顶部步骤导航 -->
    <div class="step-bar" id="js-step-bar">
        <div class="step-item">
            <div class="step-circle active" data-step="1">1</div>
            <div class="step-label active">工序主信息</div>
            <div class="step-line"></div>
        </div>
        <div class="step-item">
            <div class="step-circle" data-step="2">2</div>
            <div class="step-label">工序内容</div>
            <div class="step-line"></div>
        </div>
        <div class="step-item">
            <div class="step-circle" data-step="3">3</div>
            <div class="step-label">工序要求</div>
            <div class="step-line"></div>
        </div>
        <div class="step-item">
            <div class="step-circle" data-step="4">4</div>
            <div class="step-label">注意事项</div>
            <div class="step-line"></div>
        </div>
        <div class="step-item">
            <div class="step-circle" data-step="5">5</div>
            <div class="step-label">工装设备</div>
            <div class="step-line"></div>
        </div>
        <div class="step-item">
            <div class="step-circle" data-step="6">6</div>
            <div class="step-label">技术文档</div>
            <div class="step-line"></div>
        </div>
        <div class="step-item">
            <div class="step-circle" data-step="7">7</div>
            <div class="step-label">备料清单</div>
        </div>
    </div>

    <!-- Step 1：工序主信息 -->
    <div class="panel" id="panel-1">
        <div class="panel-title">工艺编制 / 工序主信息</div>
        <div style="color:#999; margin-bottom:12px;">当前工序的编号、名称信息，负责该工序具体作业时的部门、加工单元信息，以及该工序包含的工时和所需制造周期等信息。</div>
        <form class="layui-form" lay-filter="form1">
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">工序编号</label>
                        <div class="layui-input-inline" style="width:300px;">
                            <input type="text" class="layui-input" value="${route.routeCode!''}" readonly>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">工序名称</label>
                        <div class="layui-input-inline" style="width:300px;">
                            <input type="text" class="layui-input" value="${mainInfo.operName!route.nodeName!''}" readonly>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">工序工时(h)</label>
                        <div class="layui-input-inline" style="width:300px;">
                            <input type="text" class="layui-input" value="${mainInfo.operHours!''}" readonly>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">制造周期(h)</label>
                        <div class="layui-input-inline" style="width:300px;">
                            <input type="text" class="layui-input" value="${mainInfo.manuCycle!''}" readonly>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">加工单元</label>
                        <div class="layui-input-inline" style="width:300px;">
                            <input type="text" class="layui-input" value="${mainInfo.unitName!''}" readonly>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label">加工单元类型</label>
                        <div class="layui-input-inline" style="width:300px;">
                            <input type="text" class="layui-input" value="${mainInfo.unitTypeName!''}" readonly>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">是否生成生产计划</label>
                <div class="layui-input-inline" style="width:300px;">
                    <input type="text" class="layui-input" value="<#if (mainInfo.genPlan!'') == 'Y'>是<#elseif (mainInfo.genPlan!'') == 'N'>否</#if>" readonly>
                </div>
            </div>
        </form>
        <div class="panel-footer">
            <button class="layui-btn" onclick="goStep(2)">开始编制</button>
        </div>
    </div>

    <!-- Step 2：工序内容 -->
    <div class="panel" id="panel-2" style="display:none;">
        <div class="panel-title">工艺编制 / 工序内容</div>
        <form class="layui-form" lay-filter="form2">
            <div class="layui-form-item">
                <label class="layui-form-label">工序内容</label>
                <div class="layui-input-block">
                    <textarea name="contentText" rows="6" class="layui-textarea" placeholder="如：1.将CPU安装在主板的CPU插槽上&#10;2.将内存的安装到主板的内存条插槽上 ...">${content.contentText!''}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">图片上传</label>
                <div class="layui-input-block">
                    <button type="button" class="layui-btn layui-btn-sm" id="js-upload-content-img">
                        <i class="layui-icon">&#xe67c;</i>点击选择图片
                    </button>
                    <div class="img-preview-list" id="js-content-img-list"></div>
                </div>
            </div>
        </form>
        <div class="panel-footer">
            <button class="layui-btn layui-btn-primary" onclick="goStep(1)">上一步</button>
            <button class="layui-btn" onclick="saveStep(2)">保存并进入下一步</button>
        </div>
    </div>

    <!-- Step 3：工序要求 -->
    <div class="panel" id="panel-3" style="display:none;">
        <div class="panel-title">工艺编制 / 工序要求</div>
        <form class="layui-form" lay-filter="form3">
            <div class="layui-form-item">
                <label class="layui-form-label">工序要求</label>
                <div class="layui-input-block">
                    <textarea name="requireText" rows="6" class="layui-textarea">${content.requireText!''}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label sp-required">是否需要检验</label>
                <div class="layui-input-inline" style="width:220px;">
                    <select name="needCheck">
                        <option value="Y" <#if (content.needCheck!'Y') == 'Y'>selected</#if>>是</option>
                        <option value="N" <#if (content.needCheck!'') == 'N'>selected</#if>>否</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">图片上传</label>
                <div class="layui-input-block">
                    <button type="button" class="layui-btn layui-btn-sm" id="js-upload-req-img">
                        <i class="layui-icon">&#xe67c;</i>点击选择检验标准图片
                    </button>
                    <div class="img-preview-list" id="js-req-img-list"></div>
                </div>
            </div>
        </form>
        <div class="panel-footer">
            <button class="layui-btn layui-btn-primary" onclick="goStep(2)">上一步</button>
            <button class="layui-btn" onclick="saveStep(3)">保存并进入下一步</button>
        </div>
    </div>

    <!-- Step 4：注意事项 -->
    <div class="panel" id="panel-4" style="display:none;">
        <div class="panel-title">工艺编制 / 注意事项</div>
        <form class="layui-form" lay-filter="form4">
            <div class="layui-form-item">
                <label class="layui-form-label">注意事项</label>
                <div class="layui-input-block">
                    <textarea name="precautionText" rows="6" class="layui-textarea">${content.precautionText!''}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">图片上传</label>
                <div class="layui-input-block">
                    <button type="button" class="layui-btn layui-btn-sm" id="js-upload-prec-img">
                        <i class="layui-icon">&#xe67c;</i>点击选择图片
                    </button>
                    <div class="img-preview-list" id="js-prec-img-list"></div>
                </div>
            </div>
        </form>
        <div class="panel-footer">
            <button class="layui-btn layui-btn-primary" onclick="goStep(3)">上一步</button>
            <button class="layui-btn" onclick="saveStep(4)">保存并进入下一步</button>
        </div>
    </div>

    <!-- Step 5：工装设备 -->
    <div class="panel" id="panel-5" style="display:none;">
        <div class="panel-title">工艺编制 / 工装设备</div>
        <div style="margin-bottom:10px;">
            <button class="layui-btn layui-btn-sm" onclick="openEquipmentSelect()">
                <i class="layui-icon layui-icon-add-1"></i> 新增设备
            </button>
        </div>
        <table id="js-equip-table" lay-filter="js-equip-table-filter"></table>
        <div class="panel-footer">
            <button class="layui-btn layui-btn-primary" onclick="goStep(4)">上一步</button>
            <button class="layui-btn" onclick="saveStep(5)">保存并进入下一步</button>
        </div>
    </div>

    <!-- Step 6：技术文档 -->
    <div class="panel" id="panel-6" style="display:none;">
        <div class="panel-title">工艺编制 / 技术文档</div>
        <form class="layui-form" lay-filter="form6">
            <div class="layui-form-item">
                <label class="layui-form-label">技术文档描述</label>
                <div class="layui-input-block">
                    <input type="text" name="techDocDesc" class="layui-input" value="${content.techDocDesc!''}" placeholder="如：作业指导书-主板单元">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">图片上传</label>
                <div class="layui-input-block">
                    <button type="button" class="layui-btn layui-btn-sm" id="js-upload-tech-img">
                        <i class="layui-icon">&#xe67c;</i>选择图片
                    </button>
                    <div class="img-preview-list" id="js-tech-img-list"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">附件上传</label>
                <div class="layui-input-block">
                    <button type="button" class="layui-btn layui-btn-sm" id="js-upload-tech-attach">
                        <i class="layui-icon">&#xe67c;</i>选择附件（docx/pdf）
                    </button>
                    <div id="js-tech-attach-list" style="margin-top:8px;"></div>
                </div>
            </div>
        </form>
        <div class="panel-footer">
            <button class="layui-btn layui-btn-primary" onclick="goStep(5)">上一步</button>
            <button class="layui-btn" onclick="saveStep(6)">保存并进入下一步</button>
        </div>
    </div>

    <!-- Step 7：备料清单 -->
    <div class="panel" id="panel-7" style="display:none;">
        <div class="panel-title">工艺编制 / 备料清单</div>
        <div style="margin-bottom:10px;">
            <button class="layui-btn layui-btn-sm" onclick="openMaterileSelect()">
                <i class="layui-icon layui-icon-add-1"></i> 添加物料
            </button>
        </div>
        <table id="js-mat-table" lay-filter="js-mat-table-filter"></table>
        <div class="panel-footer">
            <button class="layui-btn layui-btn-primary" onclick="goStep(6)">上一步</button>
            <button class="layui-btn" onclick="saveStep(7)">保存</button>
            <button class="layui-btn layui-btn-warm" onclick="completeAll()">
                <i class="layui-icon">&#xe605;</i> 完成编制
            </button>
        </div>
    </div>
</div>

<script>
    var routeId = '${route.id}';
    var contentLocked = ${contentLocked?string('true','false')};
    var ROUTE = {
        contentImgs: [],
        reqImgs: [],
        precImgs: [],
        techImgs: [],
        techAttachs: [],
        equipments: [],
        materials: []
    };

    function goStep(n) {
        for (var i = 1; i <= 7; i++) $('#panel-' + i).hide();
        $('#panel-' + n).show();

        $('#js-step-bar .step-circle').each(function () {
            var s = parseInt($(this).data('step'));
            $(this).removeClass('active done');
            $(this).next('.step-label').removeClass('active');
            if (s < n) { $(this).addClass('done'); }
            else if (s === n) { $(this).addClass('active'); $(this).next('.step-label').addClass('active'); }
        });
        $('#js-step-bar .step-line').each(function (idx) {
            $(this).toggleClass('done', (idx + 1) < n);
        });
    }

    function renderImgList(listElemId, arr, fileType) {
        var $el = $('#' + listElemId).empty();
        for (var i = 0; i < arr.length; i++) {
            var f = arr[i];
            var url = f.url || ('${request.contextPath}/upload/' + f.filePath);
            var idx = i;
            var $item = $('<div class="img-preview-item"></div>');
            $item.append('<img src="' + url + '" title="' + (f.originalName || '') + '">');
            if (!contentLocked) {
                $item.append($('<span class="del-btn">×</span>').on('click', (function (k) {
                    return function () { arr.splice(k, 1); renderImgList(listElemId, arr, fileType); };
                })(idx)));
            }
            $el.append($item);
        }
    }

    function renderAttachList(listElemId, arr) {
        var $el = $('#' + listElemId).empty();
        for (var i = 0; i < arr.length; i++) {
            var f = arr[i];
            var idx = i;
            var $item = $('<div class="attach-item"></div>');
            $item.append('<i class="layui-icon layui-icon-file"></i> <a href="${request.contextPath}/upload/' + f.filePath + '" target="_blank">' + (f.originalName || '') + '</a> <span style="color:#999;">(' + Math.round((f.size || 0) / 1024) + 'KB)</span> ');
            if (!contentLocked) {
                $item.append($('<a style="color:red; margin-left:10px; cursor:pointer;">删除</a>').on('click', (function (k) {
                    return function () { arr.splice(k, 1); renderAttachList(listElemId, arr); };
                })(idx)));
            }
            $el.append($item);
        }
    }

    function loadInitData() {
        // load files
        spUtil.ajax({
            url: '${request.contextPath}/technology/process-content/files',
            type: 'GET', serializable: false, data: {routeId: routeId},
            success: function (resp) {
                var arr = resp.data || [];
                for (var i = 0; i < arr.length; i++) {
                    var f = arr[i];
                    var item = { filePath: f.filePath, originalName: f.originalName, size: f.fileSize };
                    if (f.fileType === 'CONTENT_IMG') ROUTE.contentImgs.push(item);
                    else if (f.fileType === 'REQ_IMG') ROUTE.reqImgs.push(item);
                    else if (f.fileType === 'PREC_IMG') ROUTE.precImgs.push(item);
                    else if (f.fileType === 'TECH_IMG') ROUTE.techImgs.push(item);
                    else if (f.fileType === 'TECH_ATTACH') ROUTE.techAttachs.push(item);
                }
                renderImgList('js-content-img-list', ROUTE.contentImgs, 'CONTENT_IMG');
                renderImgList('js-req-img-list', ROUTE.reqImgs, 'REQ_IMG');
                renderImgList('js-prec-img-list', ROUTE.precImgs, 'PREC_IMG');
                renderImgList('js-tech-img-list', ROUTE.techImgs, 'TECH_IMG');
                renderAttachList('js-tech-attach-list', ROUTE.techAttachs);
            }
        });
        // load equipments
        spUtil.ajax({
            url: '${request.contextPath}/technology/process-content/equipments',
            type: 'GET', serializable: false, data: {routeId: routeId},
            success: function (resp) {
                ROUTE.equipments = (resp.data || []).map(function (r) {
                    return {equipmentId: r.equipmentId, equipmentCode: r.equipmentCode, equipmentName: r.equipmentName,
                            equipmentModel: r.equipmentModel, purpose: r.purpose, reqQty: r.reqQty || 1, remark: r.remark || ''};
                });
                renderEquipTable();
            }
        });
        // load materials
        spUtil.ajax({
            url: '${request.contextPath}/technology/process-content/materials',
            type: 'GET', serializable: false, data: {routeId: routeId},
            success: function (resp) {
                ROUTE.materials = (resp.data || []).map(function (r) {
                    return {materielId: r.materielId, materielCode: r.materielCode, materielDesc: r.materielDesc,
                            matType: r.matType, model: r.model, reqQty: r.reqQty || 1, remark: r.remark || ''};
                });
                renderMatTable();
            }
        });
    }

    layui.use(['form', 'upload', 'table'], function () {
        var upload = layui.upload, table = layui.table;

        function buildUpload(elemId, arr, listId) {
            if (contentLocked) return;
            upload.render({
                elem: '#' + elemId,
                url: '${request.contextPath}/common/uploads',
                multiple: true,
                accept: 'images',
                field: 'files',
                done: function (resp) {
                    if (resp.code === 0) {
                        var files = resp.data || [];
                        for (var i = 0; i < files.length; i++) {
                            arr.push({filePath: files[i].filePath, originalName: files[i].originalName, size: files[i].size, url: files[i].url ? '${request.contextPath}' + files[i].url : null});
                        }
                        renderImgList(listId, arr);
                    } else {
                        layer.msg(resp.msg || '上传失败');
                    }
                }
            });
        }
        buildUpload('js-upload-content-img', ROUTE.contentImgs, 'js-content-img-list');
        buildUpload('js-upload-req-img', ROUTE.reqImgs, 'js-req-img-list');
        buildUpload('js-upload-prec-img', ROUTE.precImgs, 'js-prec-img-list');
        buildUpload('js-upload-tech-img', ROUTE.techImgs, 'js-tech-img-list');

        // 附件上传（非图片）
        if (!contentLocked) {
            upload.render({
                elem: '#js-upload-tech-attach',
                url: '${request.contextPath}/common/uploads',
                multiple: true,
                accept: 'file',
                exts: 'doc|docx|pdf|xls|xlsx|ppt|pptx|txt|zip|rar',
                field: 'files',
                done: function (resp) {
                    if (resp.code === 0) {
                        var files = resp.data || [];
                        for (var i = 0; i < files.length; i++) {
                            ROUTE.techAttachs.push({filePath: files[i].filePath, originalName: files[i].originalName, size: files[i].size});
                        }
                        renderAttachList('js-tech-attach-list', ROUTE.techAttachs);
                    } else {
                        layer.msg(resp.msg || '上传失败');
                    }
                }
            });
        }

        // Step5 工装设备表
        window.renderEquipTable = function () {
            var equipCols = [
                {field: 'equipmentCode', title: '设备编码', width: 130},
                {field: 'equipmentName', title: '设备名称'},
                {field: 'equipmentModel', title: '设备规格/型号'},
                {field: 'purpose', title: '设备用途'},
                {field: 'reqQty', title: '需求数量', width: 100, edit: contentLocked ? false : 'text'},
                {field: 'remark', title: '备注信息', edit: contentLocked ? false : 'text'}
            ];
            if (!contentLocked) {
                equipCols.push({fixed: 'right', title: '操作', width: 80, templet: function (d) { return '<a class="layui-btn layui-btn-xs layui-btn-danger" onclick="removeEquip(' + d.LAY_INDEX + ')">移除</a>'; }});
            }
            table.render({
                elem: '#js-equip-table',
                data: ROUTE.equipments,
                cols: [equipCols]
            });
        };
        // Step7 物料表
        window.renderMatTable = function () {
            var matCols = [
                {field: 'materielCode', title: '物料编码', width: 130},
                {field: 'materielDesc', title: '物料名称'},
                {field: 'matType', title: '物料类型', width: 100},
                {field: 'model', title: '规格/型号'},
                {field: 'reqQty', title: '需求数量', width: 110, edit: contentLocked ? false : 'text'},
                {field: 'remark', title: '备注信息', edit: contentLocked ? false : 'text'}
            ];
            if (!contentLocked) {
                matCols.push({fixed: 'right', title: '操作', width: 80, templet: function (d) { return '<a class="layui-btn layui-btn-xs layui-btn-danger" onclick="removeMat(' + d.LAY_INDEX + ')">移除</a>'; }});
            }
            table.render({
                elem: '#js-mat-table',
                data: ROUTE.materials,
                cols: [matCols]
            });
        };

        // 收集编辑修改
        table.on('edit(js-equip-table-filter)', function (obj) {
            ROUTE.equipments[obj.data.LAY_INDEX || obj.data.LAY_TABLE_INDEX || 0][obj.field] = obj.value;
        });
        table.on('edit(js-mat-table-filter)', function (obj) {
            ROUTE.materials[obj.data.LAY_INDEX || obj.data.LAY_TABLE_INDEX || 0][obj.field] = obj.value;
        });

        loadInitData();
        applyReadonlyState();
    });

    window.removeEquip = function (idx) {
        if (contentLocked) return;
        ROUTE.equipments.splice(idx, 1);
        renderEquipTable();
    };
    window.removeMat = function (idx) {
        if (contentLocked) return;
        ROUTE.materials.splice(idx, 1);
        renderMatTable();
    };

    window.__equipmentSelectCallback = function (rows) {
        if (contentLocked) return;
        for (var i = 0; i < rows.length; i++) {
            var r = rows[i];
            if (ROUTE.equipments.some(function (x) { return x.equipmentId === r.id; })) continue;
            ROUTE.equipments.push({equipmentId: r.id, equipmentCode: r.equipmentCode, equipmentName: r.equipmentName,
                equipmentModel: r.equipmentModel, purpose: r.purpose, reqQty: 1, remark: ''});
        }
        renderEquipTable();
    };
    window.__materileSelectCallback = function (rows) {
        if (contentLocked) return;
        for (var i = 0; i < rows.length; i++) {
            var r = rows[i];
            if (ROUTE.materials.some(function (x) { return x.materielId === r.id; })) continue;
            ROUTE.materials.push({materielId: r.id, materielCode: r.materiel, materielDesc: r.materielDesc,
                matType: r.matType, model: r.model, reqQty: 1, remark: ''});
        }
        renderMatTable();
    };

    function openEquipmentSelect() {
        if (contentLocked) { layer.msg('当前工序已锁定，仅可查看'); return; }
        layer.open({type: 2, title: '选择设备', area: ['80%', '70%'],
            content: '${request.contextPath}/basedata/equipment/select-ui'});
    }
    function openMaterileSelect() {
        if (contentLocked) { layer.msg('当前工序已锁定，仅可查看'); return; }
        layer.open({type: 2, title: '选择物料', area: ['80%', '70%'],
            content: '${request.contextPath}/basedata/materile/select-ui'});
    }

    function saveStep(n, done) {
        if (contentLocked) {
            layer.msg('当前工序已锁定，仅可查看');
            if (n < 7) goStep(n + 1);
            return;
        }
        var data = {routeId: routeId};
        var url = '${request.contextPath}/technology/process-content/save-step' + n;
        if (n === 2) {
            data.contentText = $('#panel-2 textarea[name=contentText]').val();
            data.imgsJson = JSON.stringify(ROUTE.contentImgs);
        } else if (n === 3) {
            data.requireText = $('#panel-3 textarea[name=requireText]').val();
            data.needCheck = $('#panel-3 select[name=needCheck]').val();
            data.imgsJson = JSON.stringify(ROUTE.reqImgs);
        } else if (n === 4) {
            data.precautionText = $('#panel-4 textarea[name=precautionText]').val();
            data.imgsJson = JSON.stringify(ROUTE.precImgs);
        } else if (n === 5) {
            data.equipmentsJson = JSON.stringify(ROUTE.equipments.map(function (x) {
                return {equipmentId: x.equipmentId, reqQty: parseInt(x.reqQty) || 1, remark: x.remark || ''};
            }));
        } else if (n === 6) {
            data.techDocDesc = $('#panel-6 input[name=techDocDesc]').val();
            data.imgsJson = JSON.stringify(ROUTE.techImgs);
            data.attachsJson = JSON.stringify(ROUTE.techAttachs);
        } else if (n === 7) {
            data.materialsJson = JSON.stringify(ROUTE.materials.map(function (x) {
                return {materielId: x.materielId, reqQty: parseFloat(x.reqQty) || 1, remark: x.remark || ''};
            }));
        }
        spUtil.ajax({
            url: url, type: 'POST', serializable: false, data: data,
            success: function () {
                layer.msg('保存成功');
                if (n < 7) goStep(n + 1);
                if (typeof done === 'function') done();
            }
        });
    }

    function completeAll() {
        if (contentLocked) { layer.msg('当前工序已锁定，仅可查看'); return; }
        saveStep(7, function () {
            layer.confirm('确认已完成当前工序各个步骤的编制？', function (idx) {
                spUtil.ajax({
                    url: '${request.contextPath}/technology/process-content/complete',
                    type: 'POST', serializable: false, data: {routeId: routeId},
                    success: function (resp) {
                        layer.close(idx);
                        layer.msg(resp.msg || '工序编制完成 ^_^!');
                        setTimeout(function () {
                            parent.layer.close(parent.layer.getFrameIndex(window.name));
                        }, 800);
                    }
                });
            });
        });
    }

    function applyReadonlyState() {
        if (!contentLocked) return;
        $('textarea, select').prop('disabled', true);
        $('#panel-6 input[name=techDocDesc]').prop('disabled', true);
        $('#js-upload-content-img,#js-upload-req-img,#js-upload-prec-img,#js-upload-tech-img,#js-upload-tech-attach')
            .addClass('layui-btn-disabled').attr('disabled', true);
        $('#panel-5 .layui-btn-sm,#panel-7 .layui-btn-sm').addClass('layui-btn-disabled').attr('disabled', true);
        layui.use(['form'], function () { layui.form.render(); });
    }
</script>
</body>
</html>
