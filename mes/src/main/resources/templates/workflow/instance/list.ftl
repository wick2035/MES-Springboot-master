<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程实例管理</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-shell">
    <div class="wf-page-head">
        <div class="wf-page-head-inner">
            <div>
                <h1 class="wf-page-title">流程实例管理</h1>
                <div class="wf-page-copy">把“分类、模型、定义”落到每一张业务单据上，清楚看到它从发起、流转、审批到结束的完整运行状态。</div>
            </div>
        </div>
    </div>

    <div class="wf-stat-grid">
        <div class="wf-stat" style="--wf-accent:#38bdf8;">
            <div class="wf-stat-label"><span>运行中实例</span><i class="fa fa-refresh"></i></div>
            <div class="wf-stat-value" data-summary="running">-</div>
            <div class="wf-stat-note">当前正在审批或等待处理</div>
        </div>
        <div class="wf-stat" style="--wf-accent:#22c55e;">
            <div class="wf-stat-label"><span>已完成</span><i class="fa fa-check-circle"></i></div>
            <div class="wf-stat-value" data-summary="completed">-</div>
            <div class="wf-stat-note">流程闭环且业务事件已同步</div>
        </div>
        <div class="wf-stat" style="--wf-accent:#ef4444;">
            <div class="wf-stat-label"><span>被驳回</span><i class="fa fa-ban"></i></div>
            <div class="wf-stat-value" data-summary="rejected">-</div>
            <div class="wf-stat-note">审批拒绝后停止在当前节点</div>
        </div>
        <div class="wf-stat" style="--wf-accent:#f59e0b;">
            <div class="wf-stat-label"><span>超过 24 小时</span><i class="fa fa-clock-o"></i></div>
            <div class="wf-stat-value" data-summary="longRunning">-</div>
            <div class="wf-stat-note">需要优先关注的长时间运行实例</div>
        </div>
    </div>

    <div class="wf-panel">
        <div class="wf-filter-row">
            <form id="js-search-form" class="layui-form wf-search" lay-filter="js-q-form-filter">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">关键词</label>
                        <div class="layui-input-inline"><input type="text" name="keyword" placeholder="标题 / 单据号" class="layui-input"></div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">业务类型</label>
                        <div class="layui-input-inline"><input type="text" name="businessType" placeholder="ORDER_APPROVAL" class="layui-input"></div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                <option value="">全部</option>
                                <option value="running">进行中</option>
                                <option value="completed">已完成</option>
                                <option value="rejected">已驳回</option>
                                <option value="revoked">已撤回</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search"></i>查询</button>
                        <button type="button" class="layui-btn layui-btn-primary" id="js-reset"><i class="fa fa-undo"></i>重置</button>
                    </div>
                </div>
            </form>
            <div class="wf-quick-tabs" id="js-status-tabs">
                <button type="button" class="wf-quick-tab on" data-status="">全部</button>
                <button type="button" class="wf-quick-tab" data-status="running">进行中</button>
                <button type="button" class="wf-quick-tab" data-status="completed">已完成</button>
                <button type="button" class="wf-quick-tab" data-status="rejected">已驳回</button>
                <button type="button" class="wf-quick-tab" data-status="revoked">已撤回</button>
            </div>
        </div>
        <div class="wf-table-wrap">
            <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
        </div>
    </div>
</div>

<script type="text/html" id="js-business-code-tpl">
    <span class="wf-code-pill">{{ d.businessCode || '-' }}</span>
</script>
<script type="text/html" id="js-title-tpl">
    <div class="wf-main-cell">
        <b>{{ d.title || '-' }}</b>
        <span>{{ businessTypeName(d.businessType) }} · {{ d.businessType || '-' }}</span>
    </div>
</script>
<script type="text/html" id="js-status-tpl">
    {{# if(d.status === 'completed'){ }}<span class="wf-badge ok">已完成</span>{{# } else if(d.status === 'rejected'){ }}<span class="wf-badge danger">已驳回</span>{{# } else if(d.status === 'revoked'){ }}<span class="wf-badge gray">已撤回</span>{{# } else { }}<span class="wf-badge info">进行中</span>{{# } }}
</script>
<script type="text/html" id="js-node-tpl">
    <span class="wf-node-mark"><i class="fa fa-map-marker"></i>{{ d.currentNodeName || '待进入' }}</span>
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <div class="wf-action-group">
        <a class="layui-btn layui-btn-xs" lay-event="trace"><i class="fa fa-sitemap"></i>轨迹</a>
    </div>
</script>
<script>
    function businessTypeName(value) {
        if (value === 'ORDER_APPROVAL') return '生产订单审批';
        return value || '-';
    }
    layui.use(['form', 'table', 'layer', 'spTable'], function () {
        var form = layui.form, table = layui.table, layer = layui.layer, spTable = layui.spTable;
        var tableIns = spTable.render({
            url: '${request.contextPath}/workflow/instance/page',
            toolbar: false,
            cols: [[
                {field:'businessCode', title:'业务单号', width:170, templet:'#js-business-code-tpl'},
                {field:'title', title:'实例信息', minWidth:240, templet:'#js-title-tpl'},
                {field:'status', title:'状态', width:100, templet:'#js-status-tpl'},
                {field:'currentNodeName', title:'当前节点', width:150, templet:'#js-node-tpl'},
                {field:'startUsername', title:'发起人', width:110, templet:function(d){ return escapeHtml(d.startUsername || '-'); }},
                {field:'startTime', title:'发起时间', width:170},
                {field:'endTime', title:'结束时间', width:170, templet:function(d){ return d.endTime || '<span class="wf-muted">未结束</span>'; }},
                {fixed:'right', title:'操作', toolbar:'#js-record-table-toolbar-right', width:96}
            ]],
            done: function(){ loadSummary(); }
        });

        form.on('submit(js-search-filter)', function(data){
            setActiveTab(data.field.status || '');
            reloadTable(data.field);
            return false;
        });

        $('#js-reset').on('click', function(){
            $('#js-search-form')[0].reset();
            setActiveTab('');
            form.render();
            reloadTable({});
        });

        $('#js-status-tabs').on('click', '.wf-quick-tab', function(){
            var status = $(this).data('status') || '';
            form.val('js-q-form-filter', {status: status});
            setActiveTab(status);
            reloadTable(getSearch());
        });

        table.on('tool(js-record-table-filter)', function(obj){
            if (obj.event === 'trace') {
                spUtil.ajax({
                    url:'${request.contextPath}/workflow/instance/tasks',
                    data:{instanceId:obj.data.id},
                    success:function(res){ openTrace(obj.data, res.data || []); }
                });
            }
        });

        function reloadTable(where) {
            tableIns.reload({where: where, page:{curr:1}});
            loadSummary(where);
        }

        function loadSummary(where) {
            spUtil.ajax({
                url:'${request.contextPath}/workflow/instance/summary',
                data: where || getSearch(),
                errNoTip: true,
                success:function(res){
                    var data = res.data || {};
                    $('[data-summary]').each(function(){
                        var key = $(this).data('summary');
                        $(this).text(data[key] == null ? 0 : data[key]);
                    });
                }
            });
        }

        function getSearch() {
            var data = {};
            $.each($('#js-search-form').serializeArray(), function(_, item){ data[item.name] = item.value; });
            return data;
        }

        function setActiveTab(status) {
            $('#js-status-tabs .wf-quick-tab').removeClass('on');
            $('#js-status-tabs .wf-quick-tab[data-status="' + status + '"]').addClass('on');
        }

        function openTrace(instance, tasks) {
            var html = '<div class="wf-trace-dialog">';
            html += '<div class="wf-trace-head"><div><b>'+escapeHtml(instance.title || '-')+'</b><span>'+escapeHtml(instance.businessCode || '-')+' · '+businessTypeName(instance.businessType)+'</span></div><div>'+statusBadge(instance.status)+'</div></div>';
            if (!tasks.length) {
                html += '<div class="wf-empty">暂无任务轨迹</div>';
            } else {
                html += '<div class="wf-timeline">';
                $.each(tasks, function(i, t){
                    var status = t.status || 'todo';
                    html += '<div class="wf-timeline-item '+escapeHtml(status)+'">';
                    html += '<div class="wf-timeline-dot"><i class="fa '+statusIcon(status)+'"></i></div>';
                    html += '<div class="wf-timeline-body">';
                    html += '<div class="wf-timeline-title"><span>'+escapeHtml(t.nodeName || t.taskName || '-')+'</span>'+taskStatusBadge(status)+'</div>';
                    html += '<div class="wf-timeline-meta">';
                    html += '<span>处理人：'+escapeHtml(t.assigneeName || '-')+'</span>';
                    html += '<span>到达：'+escapeHtml(t.startTime || '-')+'</span>';
                    html += '<span>处理：'+escapeHtml(t.completeTime || '待处理')+'</span>';
                    html += '</div>';
                    if (t.opinion) html += '<div class="wf-timeline-opinion">意见：'+escapeHtml(t.opinion)+'</div>';
                    html += '</div></div>';
                });
                html += '</div>';
            }
            html += '</div>';
            layer.open({type:1, title:'流程轨迹', area:['860px','560px'], content:html});
        }

        function statusBadge(status) {
            if (status === 'completed') return '<span class="wf-badge ok">已完成</span>';
            if (status === 'rejected') return '<span class="wf-badge danger">已驳回</span>';
            if (status === 'revoked') return '<span class="wf-badge gray">已撤回</span>';
            return '<span class="wf-badge info">进行中</span>';
        }
        function taskStatusBadge(status) {
            if (status === 'done') return '<span class="wf-badge ok">已完成</span>';
            if (status === 'rejected') return '<span class="wf-badge danger">已驳回</span>';
            if (status === 'revoked') return '<span class="wf-badge gray">已撤回</span>';
            return '<span class="wf-badge warn">待处理</span>';
        }
        function statusIcon(status) {
            if (status === 'done') return 'fa-check';
            if (status === 'rejected') return 'fa-times';
            if (status === 'revoked') return 'fa-undo';
            return 'fa-clock-o';
        }
        function escapeHtml(s){ return String(s || '').replace(/[&<>"']/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]; }); }
        form.render();
        loadSummary();
    });
</script>
</body>
</html>
