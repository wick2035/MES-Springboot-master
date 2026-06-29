<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>流程任务管理</title>
    <#include "${request.contextPath}/common/common.ftl">
    <#include "${request.contextPath}/workflow/common/style.ftl">
</head>
<body>
<div class="wf-shell">
    <div class="wf-page-head">
        <div class="wf-page-head-inner">
            <div>
                <h1 class="wf-page-title">流程任务管理</h1>
                <div class="wf-page-copy">将流程定义里的审批节点转成可执行待办，处理结果会回写流程实例，并触发已配置的业务事件。</div>
            </div>
        </div>
    </div>

    <div class="wf-stat-grid">
        <div class="wf-stat" style="--wf-accent:#f59e0b;">
            <div class="wf-stat-label"><span>待处理</span><i class="fa fa-inbox"></i></div>
            <div class="wf-stat-value" data-summary="todo">-</div>
            <div class="wf-stat-note">当前用户可处理的任务</div>
        </div>
        <div class="wf-stat" style="--wf-accent:#22c55e;">
            <div class="wf-stat-label"><span>已完成</span><i class="fa fa-check-circle"></i></div>
            <div class="wf-stat-value" data-summary="done">-</div>
            <div class="wf-stat-note">审批通过并进入下一节点</div>
        </div>
        <div class="wf-stat" style="--wf-accent:#ef4444;">
            <div class="wf-stat-label"><span>已驳回</span><i class="fa fa-times-circle"></i></div>
            <div class="wf-stat-value" data-summary="rejected">-</div>
            <div class="wf-stat-note">拒绝后流程实例终止</div>
        </div>
        <div class="wf-stat" style="--wf-accent:#38bdf8;">
            <div class="wf-stat-label"><span>超过 24 小时</span><i class="fa fa-bell-o"></i></div>
            <div class="wf-stat-value" data-summary="overdue">-</div>
            <div class="wf-stat-note">建议优先处理</div>
        </div>
    </div>

    <div class="wf-panel">
        <div class="wf-filter-row">
            <form id="js-search-form" class="layui-form wf-search" lay-filter="js-q-form-filter">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">关键词</label>
                        <div class="layui-input-inline"><input type="text" name="keyword" placeholder="任务 / 节点 / 单据号" class="layui-input"></div>
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
                                <option value="todo">待处理</option>
                                <option value="done">已完成</option>
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
                <button type="button" class="wf-quick-tab" data-status="todo">待处理</button>
                <button type="button" class="wf-quick-tab" data-status="done">已完成</button>
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
<script type="text/html" id="js-form-title-tpl">
    <div class="wf-main-cell">
        <b>{{ d.formTitle || d.taskName || '-' }}</b>
        <span>{{ businessTypeName(d.businessType) }} · {{ d.businessType || '-' }}</span>
    </div>
</script>
<script type="text/html" id="js-task-tpl">
    <div class="wf-main-cell">
        <b>{{ d.taskName || '-' }}</b>
        <span>{{ d.nodeKey || '-' }}</span>
    </div>
</script>
<script type="text/html" id="js-node-tpl">
    <span class="wf-node-mark"><i class="fa fa-location-arrow"></i>{{ d.nodeName || '-' }}</span>
</script>
<script type="text/html" id="js-status-tpl">
    {{# if(d.status === 'done'){ }}<span class="wf-badge ok">已完成</span>{{# } else if(d.status === 'rejected'){ }}<span class="wf-badge danger">已驳回</span>{{# } else if(d.status === 'revoked'){ }}<span class="wf-badge gray">已撤回</span>{{# } else { }}<span class="wf-badge warn">待处理</span>{{# } }}
</script>
<script type="text/html" id="js-record-table-toolbar-right">
    <div class="wf-action-group">
        <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="trace"><i class="fa fa-sitemap"></i>轨迹</a>
        {{# if(d.status === 'todo'){ }}
        <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="form"><i class="fa fa-file-text-o"></i>表单</a>
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="complete"><i class="layui-icon layui-icon-ok"></i>通过</a>
        {{# if(d.allowReturn === 1){ }}<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="reject"><i class="layui-icon layui-icon-close"></i>退回</a>{{# } }}
        {{# if(d.allowTransfer === 1){ }}<a class="layui-btn layui-btn-xs" lay-event="transfer"><i class="fa fa-share"></i>转办</a>{{# } }}
        {{# if(d.allowEntrust === 1){ }}<a class="layui-btn layui-btn-xs" lay-event="entrust"><i class="fa fa-handshake-o"></i>委托</a>{{# } }}
        {{# if(d.allowRevoke === 1){ }}<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="revoke"><i class="fa fa-undo"></i>撤回</a>{{# } }}
        {{# } }}
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
            url: '${request.contextPath}/workflow/task/page',
            toolbar: false,
            cols: [[
                {field:'businessCode', title:'业务单号', width:170, templet:'#js-business-code-tpl'},
                {field:'formTitle', title:'流程信息', minWidth:230, templet:'#js-form-title-tpl'},
                {field:'taskName', title:'任务', minWidth:170, templet:'#js-task-tpl'},
                {field:'nodeName', title:'节点', width:145, templet:'#js-node-tpl'},
                {field:'assigneeName', title:'处理人/角色', width:150, templet:function(d){ return escapeHtml(d.assigneeName || '-'); }},
                {field:'status', title:'状态', width:96, templet:'#js-status-tpl'},
                {field:'startTime', title:'到达时间', width:170},
                {field:'completeTime', title:'处理时间', width:170, templet:function(d){ return d.completeTime || '<span class="wf-muted">待处理</span>'; }},
                {field:'opinion', title:'意见', minWidth:190, templet:function(d){ return escapeHtml(d.opinion || '-'); }},
                {fixed:'right', title:'操作', toolbar:'#js-record-table-toolbar-right', width:420}
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
            if (obj.event === 'trace') openTraceForTask(obj.data);
            if (obj.event === 'form') openBusinessForm(obj.data);
            if (obj.event === 'complete') submitDecision(obj.data.id, 'complete', '确认通过该审批任务吗？', '同意');
            if (obj.event === 'reject') submitDecision(obj.data.id, 'reject', '请输入退回意见', '退回');
            if (obj.event === 'transfer') submitReassign(obj.data.id, 'transfer', '转办');
            if (obj.event === 'entrust') submitReassign(obj.data.id, 'entrust', '委托');
            if (obj.event === 'revoke') submitDecision(obj.data.id, 'revoke', '请输入撤回原因', '撤回流程');
        });

        function openBusinessForm(row) {
            var url = normalizeUrl(row.pcFormUrl);
            if (!url) { layer.msg('该任务未配置表单地址'); return; }
            layer.open({type:2, title: row.formTitle || '业务表单', area:['980px','720px'], content:url});
        }

        function openTraceForTask(row) {
            spUtil.ajax({
                url:'${request.contextPath}/workflow/instance/tasks',
                data:{instanceId:row.instanceId},
                success:function(res){ openTrace(row, res.data || []); }
            });
        }

        function normalizeUrl(url) {
            if (!url) return '';
            if (/^https?:\/\//i.test(url)) return url;
            return '${request.contextPath}' + (url.charAt(0) === '/' ? url : '/' + url);
        }

        function submitDecision(taskId, action, title, defaultText) {
            layer.prompt({title:title, value:defaultText, formType:2}, function(value, index){
                spUtil.ajax({
                    url:'${request.contextPath}/workflow/task/' + action,
                    type:'POST',
                    serializable:true,
                    data:{taskId:taskId, opinion:value},
                    success:function(){ reloadTable(getSearch()); layer.close(index); }
                });
            });
        }

        var reassignUsers = null;
        function loadReassignUsers(cb) {
            if (reassignUsers) { cb(reassignUsers); return; }
            spUtil.ajax({
                url:'${request.contextPath}/admin/sys/user/page',
                type:'POST',
                data:{current:1, size:999},
                success:function(res){
                    var d = res.data || {};
                    reassignUsers = d.records || [];
                    cb(reassignUsers);
                }
            });
        }
        function submitReassign(taskId, action, label) {
            loadReassignUsers(function(users){
                var opts = '<option value="">请选择用户（可输入姓名/用户名搜索）</option>';
                $.each(users, function(_, u){
                    var nm = u.name || u.username || '';
                    opts += '<option value="'+u.id+'">'+escapeHtml(nm)+'（'+escapeHtml(u.username||'')+'）</option>';
                });
                var html = ''
                    + '<div class="layui-form" lay-filter="js-reassign-form" style="padding:20px 22px 6px;">'
                    + '  <div class="layui-form-item">'
                    + '    <label class="layui-form-label">目标用户</label>'
                    + '    <div class="layui-input-block">'
                    + '      <select id="js-reassign-user" lay-search>'+opts+'</select>'
                    + '    </div>'
                    + '  </div>'
                    + '  <div class="layui-form-item">'
                    + '    <label class="layui-form-label">'+label+'说明</label>'
                    + '    <div class="layui-input-block">'
                    + '      <textarea id="js-reassign-opinion" class="layui-textarea" placeholder="请输入'+label+'说明">'+label+'</textarea>'
                    + '    </div>'
                    + '  </div>'
                    + '</div>';
                layer.open({
                    type:1,
                    title:label,
                    area:['480px','330px'],
                    btn:['确定','取消'],
                    content:html,
                    success:function(){ form.render('select', 'js-reassign-form'); },
                    yes:function(index){
                        var userId = $('#js-reassign-user').val();
                        if (!userId) { layer.msg('请选择目标用户'); return; }
                        spUtil.ajax({
                            url:'${request.contextPath}/workflow/task/' + action,
                            type:'POST',
                            serializable:true,
                            data:{taskId:taskId, targetUserId:userId, opinion:$('#js-reassign-opinion').val()},
                            success:function(){ reloadTable(getSearch()); layer.close(index); }
                        });
                    }
                });
            });
        }

        function reloadTable(where) {
            tableIns.reload({where: where, page:{curr:1}});
            loadSummary(where);
        }

        function loadSummary(where) {
            spUtil.ajax({
                url:'${request.contextPath}/workflow/task/summary',
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

        function openTrace(row, tasks) {
            var html = '<div class="wf-trace-dialog">';
            html += '<div class="wf-trace-head"><div><b>'+escapeHtml(row.formTitle || row.taskName || '-')+'</b><span>'+escapeHtml(row.businessCode || '-')+' · '+businessTypeName(row.businessType)+'</span></div><div>'+taskStatusBadge(row.status)+'</div></div>';
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
            layer.open({type:1, title:'任务轨迹', area:['860px','560px'], content:html});
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
