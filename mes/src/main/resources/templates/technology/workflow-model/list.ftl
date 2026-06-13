<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单流程模型</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        :root {
            --ink: #172033;
            --muted: #6d778b;
            --line: #dfe5ef;
            --paper: #fbfcff;
            --panel: rgba(255, 255, 255, .94);
            --navy: #123c69;
            --blue: #256fca;
            --cyan: #28b8d4;
            --green: #23a66f;
            --orange: #f0a23a;
            --red: #e84d3d;
            --shadow: 0 18px 55px rgba(28, 55, 90, .14);
        }

        html, body {
            min-height: 100%;
            background:
                    radial-gradient(circle at 9% 11%, rgba(40, 184, 212, .18), transparent 26%),
                    linear-gradient(135deg, #eef6fb 0%, #f9fbff 44%, #eef4f8 100%);
            color: var(--ink);
            font-family: "Avenir Next", "Segoe UI", "PingFang SC", "Microsoft YaHei", sans-serif;
        }

        .workflow-shell {
            padding: 18px;
        }

        .workflow-topbar {
            min-height: 74px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            border-bottom: 1px solid rgba(18, 60, 105, .12);
            margin-bottom: 16px;
        }

        .workflow-title {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .workflow-mark {
            width: 44px;
            height: 44px;
            display: grid;
            place-items: center;
            color: #fff;
            background: linear-gradient(145deg, var(--navy), var(--cyan));
            box-shadow: 0 12px 26px rgba(37, 111, 202, .28);
        }

        .workflow-title h1 {
            margin: 0;
            font-size: 24px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: 0;
        }

        .workflow-title p {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 13px;
        }

        .workflow-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .workflow-btn {
            height: 38px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid rgba(18, 60, 105, .12);
            background: #fff;
            color: var(--ink);
            padding: 0 14px;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
        }

        .workflow-btn:hover {
            transform: translateY(-1px);
            border-color: rgba(37, 111, 202, .35);
            box-shadow: 0 10px 26px rgba(28, 55, 90, .12);
        }

        .workflow-btn.primary {
            border: 0;
            background: linear-gradient(135deg, var(--blue), var(--cyan));
            color: #fff;
            box-shadow: 0 14px 30px rgba(37, 111, 202, .25);
        }

        .workflow-btn.publish {
            border: 0;
            background: linear-gradient(135deg, #1c9b68, #45c485);
            color: #fff;
            box-shadow: 0 14px 30px rgba(35, 166, 111, .24);
        }

        .workflow-grid {
            display: grid;
            grid-template-columns: minmax(260px, 330px) minmax(620px, 1fr);
            gap: 16px;
            min-height: calc(100vh - 132px);
        }

        .workflow-side,
        .workflow-studio {
            background: var(--panel);
            border: 1px solid rgba(18, 60, 105, .10);
            box-shadow: var(--shadow);
            backdrop-filter: blur(12px);
        }

        .workflow-side {
            padding: 14px;
        }

        .workflow-search {
            position: relative;
            margin-bottom: 14px;
        }

        .workflow-search i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
        }

        .workflow-search input {
            height: 40px;
            width: 100%;
            box-sizing: border-box;
            border: 1px solid var(--line);
            padding: 0 12px 0 34px;
            background: #fff;
        }

        .model-list {
            display: grid;
            gap: 10px;
            max-height: calc(100vh - 235px);
            overflow: auto;
            padding-right: 2px;
        }

        .model-card {
            border: 1px solid var(--line);
            background: #fff;
            padding: 13px;
            cursor: pointer;
            transition: border-color .18s ease, transform .18s ease, box-shadow .18s ease;
        }

        .model-card:hover,
        .model-card.active {
            border-color: rgba(37, 111, 202, .55);
            transform: translateY(-1px);
            box-shadow: 0 12px 26px rgba(28, 55, 90, .10);
        }

        .model-card-head {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            align-items: flex-start;
        }

        .model-card-title {
            font-weight: 800;
            line-height: 1.35;
            word-break: break-word;
        }

        .model-card-key {
            margin-top: 8px;
            color: var(--muted);
            font-size: 12px;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            height: 24px;
            padding: 0 9px;
            font-size: 12px;
            border: 1px solid rgba(240, 162, 58, .35);
            color: #a56612;
            background: #fff8ed;
            white-space: nowrap;
        }

        .status-pill.published {
            border-color: rgba(35, 166, 111, .32);
            color: #16764d;
            background: #edf9f3;
        }

        .empty-state {
            border: 1px dashed #cbd5e3;
            color: var(--muted);
            padding: 18px;
            text-align: center;
            background: rgba(255, 255, 255, .6);
        }

        .workflow-studio {
            display: grid;
            grid-template-rows: auto 1fr;
            overflow: hidden;
        }

        .studio-form {
            padding: 16px 18px 14px;
            border-bottom: 1px solid rgba(18, 60, 105, .10);
            background: linear-gradient(180deg, rgba(255, 255, 255, .92), rgba(247, 250, 255, .92));
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(130px, 1fr));
            gap: 12px;
        }

        .field-block label {
            display: block;
            margin-bottom: 6px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
        }

        .field-block input,
        .field-block select,
        .field-block textarea {
            width: 100%;
            box-sizing: border-box;
            border: 1px solid var(--line);
            background: #fff;
            min-height: 38px;
            padding: 8px 10px;
            color: var(--ink);
            resize: vertical;
        }

        .field-block textarea {
            min-height: 38px;
            max-height: 74px;
        }

        .field-block.wide {
            grid-column: span 2;
        }

        .studio-canvas {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 272px;
            min-height: 520px;
        }

        .canvas-board {
            position: relative;
            overflow: auto;
            padding: 42px 36px;
            background:
                    linear-gradient(rgba(18, 60, 105, .045) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(18, 60, 105, .045) 1px, transparent 1px),
                    #f9fbff;
            background-size: 28px 28px;
        }

        .canvas-board:before {
            content: "";
            position: absolute;
            inset: 0;
            pointer-events: none;
            background: linear-gradient(90deg, rgba(255, 255, 255, .88), transparent 16%, transparent 84%, rgba(255, 255, 255, .9));
        }

        .flow-line {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: 76px 80px minmax(158px, 1fr) 80px minmax(158px, 1fr) 80px 76px;
            align-items: center;
            gap: 0;
            min-width: 760px;
            max-width: 980px;
            margin: 116px auto 0;
        }

        .flow-node {
            min-height: 96px;
            display: grid;
            align-content: center;
            justify-items: center;
            gap: 8px;
            background: #fff;
            border: 1px solid rgba(18, 60, 105, .14);
            box-shadow: 0 18px 34px rgba(28, 55, 90, .11);
        }

        .flow-node.task {
            position: relative;
            padding: 14px 12px;
        }

        .flow-node.task:before {
            content: "\f007";
            font-family: FontAwesome;
            position: absolute;
            left: 12px;
            top: 10px;
            color: var(--blue);
            font-size: 16px;
        }

        .flow-node.task.manager:before {
            color: var(--green);
        }

        .flow-node-title {
            margin-top: 10px;
            font-size: 16px;
            font-weight: 800;
            text-align: center;
        }

        .flow-node-role {
            color: var(--muted);
            font-size: 12px;
            text-align: center;
        }

        .event-node {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: #fff;
            border: 5px solid #c8d2df;
            box-shadow: 0 12px 26px rgba(28, 55, 90, .10);
            justify-self: center;
        }

        .event-node.end {
            border-color: var(--navy);
        }

        .connector {
            position: relative;
            height: 2px;
            background: #aeb9c8;
        }

        .connector:after {
            content: "";
            position: absolute;
            right: -1px;
            top: 50%;
            transform: translateY(-50%);
            border-left: 12px solid #7d8998;
            border-top: 7px solid transparent;
            border-bottom: 7px solid transparent;
        }

        .canvas-label {
            position: absolute;
            z-index: 1;
            left: 36px;
            top: 24px;
            display: flex;
            align-items: center;
            gap: 9px;
            color: var(--muted);
            font-size: 13px;
            font-weight: 700;
        }

        .canvas-label span {
            width: 9px;
            height: 9px;
            background: var(--green);
            border-radius: 50%;
            box-shadow: 0 0 0 6px rgba(35, 166, 111, .12);
        }

        .inspector {
            border-left: 1px solid rgba(18, 60, 105, .10);
            background: rgba(255, 255, 255, .72);
            padding: 18px;
        }

        .inspector h2 {
            margin: 0 0 14px;
            font-size: 16px;
            font-weight: 800;
        }

        .metric-row {
            display: grid;
            gap: 10px;
        }

        .metric {
            border: 1px solid var(--line);
            background: #fff;
            padding: 12px;
        }

        .metric b {
            display: block;
            font-size: 18px;
            line-height: 1.2;
            color: var(--navy);
        }

        .metric span {
            color: var(--muted);
            font-size: 12px;
        }

        .publish-note {
            margin-top: 16px;
            padding: 12px;
            border-left: 4px solid var(--cyan);
            background: #f0fbff;
            color: #335;
            line-height: 1.65;
            font-size: 13px;
        }

        @media (max-width: 980px) {
            .workflow-grid,
            .studio-canvas {
                grid-template-columns: 1fr;
            }

            .workflow-side {
                min-height: 220px;
            }

            .model-list {
                max-height: 260px;
            }

            .form-grid {
                grid-template-columns: repeat(2, minmax(130px, 1fr));
            }

            .inspector {
                border-left: 0;
                border-top: 1px solid rgba(18, 60, 105, .10);
            }
        }
    </style>
</head>
<body>
<div class="workflow-shell">
    <div class="workflow-topbar">
        <div class="workflow-title">
            <div class="workflow-mark"><i class="fa fa-share-alt"></i></div>
            <div>
                <h1>订单生产计划流程模型</h1>
                <p>计划员发起，生产主管审批，发布到生产流程分类后驱动工单审批权限。</p>
            </div>
        </div>
        <div class="workflow-actions">
            <button type="button" class="workflow-btn" id="js-new-model"><i class="fa fa-plus"></i> 创建流程</button>
            <button type="button" class="workflow-btn primary" id="js-save-model"><i class="fa fa-save"></i> 保存草稿</button>
            <button type="button" class="workflow-btn publish" id="js-publish-model"><i class="fa fa-check"></i> 发布模型</button>
        </div>
    </div>

    <div class="workflow-grid">
        <aside class="workflow-side">
            <div class="workflow-search">
                <i class="fa fa-search"></i>
                <input type="text" id="js-keyword" placeholder="搜索名称或 key">
            </div>
            <div class="model-list" id="js-model-list"></div>
        </aside>

        <main class="workflow-studio">
            <section class="studio-form">
                <div class="form-grid">
                    <div class="field-block wide">
                        <label>模型名称</label>
                        <input type="text" id="js-model-name" value="生产订单审批流程">
                    </div>
                    <div class="field-block">
                        <label>模型 key</label>
                        <input type="text" id="js-model-key" value="orderRecord">
                    </div>
                    <div class="field-block">
                        <label>流程分类</label>
                        <input type="text" id="js-category-name" value="生产流程" readonly>
                    </div>
                    <div class="field-block">
                        <label>发起角色</label>
                        <select id="js-initiator-role">
                            <#list roles as role>
                                <option value="${role.code?js_string}" data-name="${role.name?js_string}" <#if role.code == 'productionPlannerRole'>selected</#if>>${role.name} / ${role.code}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="field-block">
                        <label>审批角色</label>
                        <select id="js-approver-role">
                            <#list roles as role>
                                <option value="${role.code?js_string}" data-name="${role.name?js_string}" <#if role.code == 'productionManagerRole'>selected</#if>>${role.name} / ${role.code}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="field-block wide">
                        <label>描述</label>
                        <textarea id="js-model-desc">计划员发起生产订单计划，生产主管审批后进入生产执行。</textarea>
                    </div>
                </div>
            </section>

            <section class="studio-canvas">
                <div class="canvas-board">
                    <div class="canvas-label"><span></span>业务流程模型</div>
                    <div class="flow-line">
                        <div class="event-node" title="开始事件"></div>
                        <div class="connector"></div>
                        <div class="flow-node task">
                            <div class="flow-node-title">计划员发起</div>
                            <div class="flow-node-role" id="js-initiator-label">生产计划员</div>
                        </div>
                        <div class="connector"></div>
                        <div class="flow-node task manager">
                            <div class="flow-node-title">生产主管审批</div>
                            <div class="flow-node-role" id="js-approver-label">生产主管</div>
                        </div>
                        <div class="connector"></div>
                        <div class="event-node end" title="结束事件"></div>
                    </div>
                </div>
                <aside class="inspector">
                    <h2>发布状态</h2>
                    <div class="metric-row">
                        <div class="metric">
                            <b id="js-status-text">草稿</b>
                            <span>当前模型状态</span>
                        </div>
                        <div class="metric">
                            <b id="js-deployed-time">未发布</b>
                            <span>最近发布时间</span>
                        </div>
                        <div class="metric">
                            <b id="js-model-summary">4 节点 / 3 连线</b>
                            <span>模型结构</span>
                        </div>
                    </div>
                    <div class="publish-note">
                        发布后，工单下达页面会使用该模型的审批角色。默认流程 key 为 orderRecord，分类为 prod / 生产流程。
                    </div>
                </aside>
            </section>
        </main>
    </div>
</div>

<script>
    layui.use(['layer', 'form'], function () {
        var layer = layui.layer;
        var form = layui.form;
        var contextPath = '${request.contextPath}';
        var models = [];
        var current = {};

        var defaultModel = {
            modelName: '生产订单审批流程',
            modelKey: 'orderRecord',
            modelDesc: '计划员发起生产订单计划，生产主管审批后进入生产执行。',
            categoryCode: 'prod',
            categoryName: '生产流程',
            status: 'DRAFT',
            initiatorRoleCode: 'productionPlannerRole',
            initiatorRoleName: '生产计划员',
            approverRoleCode: 'productionManagerRole',
            approverRoleName: '生产主管'
        };

        function selectedRoleName(selector) {
            return $(selector).find('option:selected').data('name') || '';
        }

        function buildDefinition(model) {
            return JSON.stringify({
                nodes: [
                    {id: 'start', type: 'startEvent', name: '开始'},
                    {id: 'planner', type: 'userTask', name: '计划员发起', roleCode: model.initiatorRoleCode, roleName: model.initiatorRoleName},
                    {id: 'manager', type: 'userTask', name: '生产主管审批', roleCode: model.approverRoleCode, roleName: model.approverRoleName},
                    {id: 'end', type: 'endEvent', name: '结束'}
                ],
                edges: [['start', 'planner'], ['planner', 'manager'], ['manager', 'end']]
            });
        }

        function collectModel() {
            var model = $.extend({}, current);
            model.modelName = $.trim($('#js-model-name').val());
            model.modelKey = $.trim($('#js-model-key').val());
            model.modelDesc = $.trim($('#js-model-desc').val());
            model.categoryCode = 'prod';
            model.categoryName = '生产流程';
            model.initiatorRoleCode = $('#js-initiator-role').val();
            model.initiatorRoleName = selectedRoleName('#js-initiator-role');
            model.approverRoleCode = $('#js-approver-role').val();
            model.approverRoleName = selectedRoleName('#js-approver-role');
            model.definitionJson = buildDefinition(model);
            return model;
        }

        function statusText(status) {
            return status === 'PUBLISHED' ? '已发布' : '草稿';
        }

        function renderMeta(model) {
            $('#js-status-text').text(statusText(model.status));
            $('#js-deployed-time').text(model.deployedTime || '未发布');
            $('#js-model-summary').text('4 节点 / 3 连线');
            $('#js-initiator-label').text(model.initiatorRoleName || selectedRoleName('#js-initiator-role'));
            $('#js-approver-label').text(model.approverRoleName || selectedRoleName('#js-approver-role'));
        }

        function fillForm(model) {
            current = $.extend({}, defaultModel, model || {});
            $('#js-model-name').val(current.modelName || '');
            $('#js-model-key').val(current.modelKey || '');
            $('#js-model-desc').val(current.modelDesc || '');
            $('#js-category-name').val(current.categoryName || '生产流程');
            $('#js-initiator-role').val(current.initiatorRoleCode || 'productionPlannerRole');
            $('#js-approver-role').val(current.approverRoleCode || 'productionManagerRole');
            form.render('select');
            renderMeta(current);
            renderCards();
        }

        function renderCards() {
            var keyword = $.trim($('#js-keyword').val()).toLowerCase();
            var html = '';
            $.each(models, function (_, item) {
                if (keyword && (String(item.modelName).toLowerCase().indexOf(keyword) === -1 && String(item.modelKey).toLowerCase().indexOf(keyword) === -1)) {
                    return;
                }
                var active = current.id === item.id ? ' active' : '';
                var published = item.status === 'PUBLISHED';
                html += '<div class="model-card' + active + '" data-id="' + item.id + '">'
                    + '<div class="model-card-head">'
                    + '<div class="model-card-title">' + (item.modelName || '-') + '</div>'
                    + '<span class="status-pill ' + (published ? 'published' : '') + '">' + statusText(item.status) + '</span>'
                    + '</div>'
                    + '<div class="model-card-key">Key: ' + (item.modelKey || '-') + '</div>'
                    + '<div class="model-card-key">分类: ' + (item.categoryName || '生产流程') + '</div>'
                    + '</div>';
            });
            if (!html) {
                html = '<div class="empty-state">暂无流程模型，点击“创建流程”开始。</div>';
            }
            $('#js-model-list').html(html);
        }

        function loadModels(selectFirst) {
            spUtil.ajax({
                url: contextPath + '/workflow/model/page',
                type: 'POST',
                serializable: false,
                data: {current: 1, size: 100},
                success: function (res) {
                    models = (res.data && res.data.records) ? res.data.records : [];
                    if (selectFirst && models.length > 0) {
                        var orderModel = null;
                        $.each(models, function (_, item) {
                            if (item.modelKey === 'orderRecord') {
                                orderModel = item;
                                return false;
                            }
                        });
                        fillForm(orderModel || models[0]);
                    } else {
                        renderCards();
                    }
                }
            });
        }

        function saveModel(publish) {
            var model = collectModel();
            if (!model.modelName) {
                layer.msg('请填写模型名称');
                return;
            }
            if (!model.modelKey) {
                layer.msg('请填写模型 key');
                return;
            }
            spUtil.ajax({
                url: contextPath + '/workflow/model/' + (publish ? 'publish' : 'add-or-update'),
                type: 'POST',
                serializable: true,
                showLoading: true,
                data: model,
                success: function (res) {
                    current = res.data || model;
                    layer.msg(publish ? '已发布到生产流程分类' : '草稿已保存');
                    fillForm(current);
                    loadModels(false);
                }
            });
        }

        $('#js-new-model').on('click', function () {
            fillForm(defaultModel);
            layer.msg('已准备好订单审批流程模板');
        });

        $('#js-save-model').on('click', function () {
            saveModel(false);
        });

        $('#js-publish-model').on('click', function () {
            saveModel(true);
        });

        $('#js-keyword').on('input', renderCards);

        $('#js-model-list').on('click', '.model-card', function () {
            var id = $(this).data('id');
            $.each(models, function (_, item) {
                if (item.id === id) {
                    fillForm(item);
                    return false;
                }
            });
        });

        $('#js-initiator-role, #js-approver-role').on('change', function () {
            var model = collectModel();
            renderMeta(model);
        });

        form.render();
        fillForm(defaultModel);
        loadModels(true);
    });
</script>
</body>
</html>
