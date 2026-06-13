<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>智能助手</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        :root {
            --brand: #2563EB; --brand-2: #4f46e5; --side: #0f172a; --side-2: #1e293b;
            --bg: #f5f7fb; --line: #e6e9ef; --text: #1f2733; --muted: #94a3b8;
        }
        html, body { height: 100%; margin: 0; background: var(--bg);
            font-family: -apple-system, "Segoe UI", "Microsoft YaHei", sans-serif; }
        * { box-sizing: border-box; }
        .sp-ai-wrap { display: flex; height: 100vh; }

        /* 侧栏 */
        .sp-ai-side { width: 248px; background: var(--side); color: #cbd5e1; display: flex; flex-direction: column; }
        .sp-ai-brand { padding: 16px 18px 10px; font-size: 15px; font-weight: 600; color: #fff; display: flex; align-items: center; gap: 8px; }
        .sp-ai-brand i { color: #60a5fa; }
        .sp-ai-side .new-chat { margin: 6px 12px 10px; padding: 10px 0; text-align: center;
            border-radius: 8px; cursor: pointer; color: #fff; font-size: 13px; font-weight: 500;
            background: linear-gradient(135deg, var(--brand), var(--brand-2)); transition: opacity .2s; }
        .sp-ai-side .new-chat:hover { opacity: .9; }
        .sp-ai-side .conv-label { padding: 6px 18px; font-size: 11px; color: #64748b; letter-spacing: .5px; }
        .sp-ai-convs { flex: 1; overflow-y: auto; padding: 0 8px 12px; }
        .sp-ai-convs::-webkit-scrollbar { width: 6px; }
        .sp-ai-convs::-webkit-scrollbar-thumb { background: #334155; border-radius: 3px; }
        .sp-ai-conv { padding: 9px 12px; margin: 2px 0; font-size: 13px; cursor: pointer; border-radius: 7px;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis; position: relative; color: #cbd5e1; }
        .sp-ai-conv:hover { background: var(--side-2); }
        .sp-ai-conv.active { background: var(--side-2); color: #fff; }
        .sp-ai-conv.active::before { content: ''; position: absolute; left: 0; top: 8px; bottom: 8px; width: 3px;
            background: #60a5fa; border-radius: 2px; }
        .sp-ai-conv .del { display: none; position: absolute; right: 8px; top: 9px; color: #64748b; }
        .sp-ai-conv .del:hover { color: #f87171; }
        .sp-ai-conv:hover .del { display: inline; }

        /* 主区 */
        .sp-ai-main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .sp-ai-header { height: 56px; padding: 0 22px; background: #fff; border-bottom: 1px solid var(--line);
            display: flex; align-items: center; gap: 10px; }
        .sp-ai-header .logo { width: 30px; height: 30px; border-radius: 8px; color: #fff; display: flex;
            align-items: center; justify-content: center; background: linear-gradient(135deg, var(--brand), var(--brand-2)); }
        .sp-ai-header .t { font-weight: 600; color: var(--text); font-size: 15px; }
        .sp-ai-header .s { font-size: 12px; color: var(--muted); margin-top: 1px; }
        .sp-ai-msgs { flex: 1; overflow-y: auto; padding: 24px 0; }
        .sp-ai-msgs::-webkit-scrollbar { width: 8px; }
        .sp-ai-msgs::-webkit-scrollbar-thumb { background: #d4dae5; border-radius: 4px; }
        .sp-ai-inner { max-width: 860px; margin: 0 auto; padding: 0 24px; }

        .sp-ai-row { display: flex; gap: 12px; margin-bottom: 22px; align-items: flex-start; }
        .sp-ai-row.user { flex-direction: row-reverse; }
        .sp-ai-avatar { width: 34px; height: 34px; border-radius: 9px; flex: none; display: flex;
            align-items: center; justify-content: center; color: #fff; font-size: 15px; }
        .sp-ai-row.ai .sp-ai-avatar { background: linear-gradient(135deg, var(--brand), var(--brand-2)); }
        .sp-ai-row.user .sp-ai-avatar { background: #475569; }
        .sp-ai-col { min-width: 0; max-width: 80%; }
        .sp-ai-bubble { padding: 11px 15px; border-radius: 12px; font-size: 14px; line-height: 1.7;
            word-break: break-word; box-shadow: 0 1px 2px rgba(15,23,42,.06); display: inline-block; }
        .sp-ai-row.user .sp-ai-col { text-align: right; }
        .sp-ai-row.user .sp-ai-bubble { background: var(--brand); color: #fff; border-top-right-radius: 3px; text-align: left; }
        .sp-ai-row.ai .sp-ai-bubble { background: #fff; color: var(--text); border-top-left-radius: 3px; border: 1px solid var(--line); }
        .sp-ai-bubble p, .sp-ai-bubble div { margin: 0 0 2px; }
        .sp-ai-bubble h3, .sp-ai-bubble h4, .sp-ai-bubble h5, .sp-ai-bubble h6 { margin: 10px 0 6px; font-size: 14px; }
        .sp-ai-bubble ul { margin: 4px 0; padding-left: 20px; }
        .sp-ai-bubble li { margin: 2px 0; }
        .sp-ai-bubble table { border-collapse: collapse; margin: 8px 0; width: 100%; }
        .sp-ai-bubble th, .sp-ai-bubble td { border: 1px solid #dce0e8; padding: 6px 10px; font-size: 13px; }
        .sp-ai-bubble th { background: #f5f7fa; font-weight: 600; }
        .sp-ai-bubble tr:nth-child(even) td { background: #fafbfc; }
        .sp-ai-bubble pre { background: #0f172a; color: #e2e8f0; padding: 12px; border-radius: 8px; overflow-x: auto; margin: 8px 0; }
        .sp-ai-bubble pre code { background: none; color: inherit; padding: 0; }
        .sp-ai-bubble code { background: #eef1f6; color: #d6336c; padding: 1px 5px; border-radius: 4px; font-size: 13px; }
        .sp-ai-tool { font-size: 12px; color: #64748b; margin: 0 0 8px; display: inline-flex; align-items: center;
            gap: 6px; background: #eef2ff; border: 1px solid #e0e7ff; padding: 4px 10px; border-radius: 14px; }
        .sp-ai-tool i { color: var(--brand); }
        .sp-ai-acts { margin-top: 6px; font-size: 12px; color: var(--muted); }
        .sp-ai-acts a { color: var(--muted); cursor: pointer; text-decoration: none; }
        .sp-ai-acts a:hover { color: var(--brand); }

        /* 空态 */
        .sp-ai-empty { text-align: center; margin-top: 56px; color: var(--text); }
        .sp-ai-empty .hi { width: 56px; height: 56px; border-radius: 16px; margin: 0 auto 16px; color: #fff;
            display: flex; align-items: center; justify-content: center; font-size: 26px;
            background: linear-gradient(135deg, var(--brand), var(--brand-2)); box-shadow: 0 6px 18px rgba(37,99,235,.3); }
        .sp-ai-empty h2 { margin: 0 0 6px; font-size: 19px; }
        .sp-ai-empty p { margin: 0 0 22px; color: var(--muted); font-size: 13px; }
        .sp-ai-cards { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; max-width: 620px; margin: 0 auto; text-align: left; }
        .sp-ai-card { background: #fff; border: 1px solid var(--line); border-radius: 12px; padding: 13px 15px;
            cursor: pointer; transition: all .15s; }
        .sp-ai-card:hover { border-color: var(--brand); box-shadow: 0 4px 14px rgba(37,99,235,.1); transform: translateY(-1px); }
        .sp-ai-card .ico { font-size: 16px; color: var(--brand); margin-bottom: 6px; }
        .sp-ai-card .q { font-size: 13px; color: var(--text); font-weight: 500; }
        .sp-ai-card .d { font-size: 12px; color: var(--muted); margin-top: 3px; }

        /* 输入 */
        .sp-ai-input { padding: 12px 24px 18px; }
        .sp-ai-input .box { max-width: 860px; margin: 0 auto; background: #fff; border: 1px solid #d6dbe5;
            border-radius: 14px; padding: 10px 12px; box-shadow: 0 2px 10px rgba(15,23,42,.05); transition: border-color .2s; }
        .sp-ai-input .box:focus-within { border-color: var(--brand); box-shadow: 0 2px 14px rgba(37,99,235,.12); }
        .sp-ai-input textarea { width: 100%; max-height: 160px; min-height: 26px; resize: none; border: none;
            outline: none; font-size: 14px; line-height: 1.6; padding: 2px 4px; font-family: inherit; }
        .sp-ai-input .bar { display: flex; justify-content: space-between; align-items: center; margin-top: 6px; }
        .sp-ai-input .tip { font-size: 12px; color: #a8b1c0; }
        .sp-ai-btn { border: none; border-radius: 9px; height: 34px; padding: 0 18px; cursor: pointer;
            font-size: 13px; color: #fff; display: inline-flex; align-items: center; gap: 6px;
            background: linear-gradient(135deg, var(--brand), var(--brand-2)); }
        .sp-ai-btn:hover { opacity: .92; }
        .sp-ai-btn.stop { background: #ef4444; }
        .sp-ai-btn[disabled] { opacity: .5; cursor: not-allowed; }
        .blink { display: inline-block; width: 7px; background: var(--brand); margin-left: 1px;
            animation: blink 1s steps(1) infinite; }
        @keyframes blink { 50% { opacity: 0; } }
    </style>
</head>
<body>
<div class="sp-ai-wrap">
    <div class="sp-ai-side">
        <div class="sp-ai-brand"><i class="fa fa-cubes"></i> 黑科制造 · 智能助手</div>
        <div class="new-chat" id="js-new-chat"><i class="fa fa-plus"></i> 新建对话</div>
        <div class="conv-label">历史会话</div>
        <div class="sp-ai-convs" id="js-convs"></div>
    </div>
    <div class="sp-ai-main">
        <div class="sp-ai-header">
            <div class="logo"><i class="fa fa-magic"></i></div>
            <div>
                <div class="t">MES 智能助手</div>
                <div class="s">查数据 · 讲操作 · 答流程</div>
            </div>
        </div>
        <div class="sp-ai-msgs" id="js-msgs">
            <div class="sp-ai-inner">
                <div class="sp-ai-empty" id="js-empty">
                    <div class="hi"><i class="fa fa-magic"></i></div>
                    <h2>你好，我是 MES 智能助手</h2>
                    <p>既能查询工单、库存、合格率、BOM 等真实数据，也能告诉你功能怎么操作、业务流程是什么。</p>
                    <div class="sp-ai-cards">
                        <div class="sp-ai-card" data-q="哪些物料低于安全库存？">
                            <div class="ico"><i class="fa fa-database"></i></div>
                            <div class="q">哪些物料低于安全库存？</div>
                            <div class="d">实时库存预警</div>
                        </div>
                        <div class="sp-ai-card" data-q="统计各工序的报工合格率">
                            <div class="ico"><i class="fa fa-bar-chart"></i></div>
                            <div class="q">统计各工序的报工合格率</div>
                            <div class="d">质量数据分析</div>
                        </div>
                        <div class="sp-ai-card" data-q="生产订单怎么下发？需要哪些前置条件？">
                            <div class="ico"><i class="fa fa-info-circle"></i></div>
                            <div class="q">生产订单怎么下发？</div>
                            <div class="d">操作步骤指引</div>
                        </div>
                        <div class="sp-ai-card" data-q="台式电脑主机从订单到交付的完整生产流程是什么？">
                            <div class="ico"><i class="fa fa-sitemap"></i></div>
                            <div class="q">完整生产流程是什么？</div>
                            <div class="d">端到端业务闭环</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="sp-ai-input">
            <div class="box">
                <textarea id="js-input" rows="1" placeholder="输入你的问题，Enter 发送，Shift+Enter 换行"></textarea>
                <div class="bar">
                    <span class="tip">回答基于系统真实数据与产品说明书，由通义千问生成，仅供参考</span>
                    <button class="sp-ai-btn" id="js-send"><i class="fa fa-paper-plane"></i> 发送</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var ctx = '${request.contextPath}';
    var currentConvId = '';
    var sending = false;
    var currentEs = null;

    layui.use(['layer'], function () {
        var $ = layui.jquery;
        var layer = layui.layer;

        function escapeHtml(s) {
            return (s || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        }
        function renderMarkdown(text) {
            if (!text) return '';
            var blocks = [];
            text = text.replace(/```([\s\S]*?)```/g, function (m, p1) {
                blocks.push('<pre><code>' + escapeHtml(p1) + '</code></pre>');
                return '@@CB' + (blocks.length - 1) + 'CB@@';
            });
            var lines = text.split('\n');
            var html = '';
            var i = 0;
            while (i < lines.length) {
                var line = lines[i];
                if (/\|/.test(line) && i + 1 < lines.length && /^\s*\|?[\s:\-|]+\|?\s*$/.test(lines[i + 1])) {
                    var header = line.split('|').filter(function (c) { return c.trim() !== ''; });
                    html += '<table><thead><tr>';
                    header.forEach(function (h) { html += '<th>' + inline(h.trim()) + '</th>'; });
                    html += '</tr></thead><tbody>';
                    i += 2;
                    while (i < lines.length && /\|/.test(lines[i])) {
                        var cells = lines[i].split('|').filter(function (c, idx, arr) {
                            return !(idx === 0 && c.trim() === '') && !(idx === arr.length - 1 && c.trim() === '');
                        });
                        html += '<tr>';
                        cells.forEach(function (c) { html += '<td>' + inline(c.trim()) + '</td>'; });
                        html += '</tr>';
                        i++;
                    }
                    html += '</tbody></table>';
                    continue;
                }
                var hm = line.match(/^(#+)\s+(.*)$/);
                if (hm) {
                    var lv = Math.min(hm[1].length, 4) + 2;
                    html += '<h' + lv + '>' + inline(hm[2]) + '</h' + lv + '>';
                    i++;
                    continue;
                }
                if (/^\s*\d+\.\s+/.test(line)) {
                    html += '<ol>';
                    while (i < lines.length && /^\s*\d+\.\s+/.test(lines[i])) {
                        html += '<li>' + inline(lines[i].replace(/^\s*\d+\.\s+/, '')) + '</li>';
                        i++;
                    }
                    html += '</ol>';
                    continue;
                }
                if (/^\s*[-*]\s+/.test(line)) {
                    html += '<ul>';
                    while (i < lines.length && /^\s*[-*]\s+/.test(lines[i])) {
                        html += '<li>' + inline(lines[i].replace(/^\s*[-*]\s+/, '')) + '</li>';
                        i++;
                    }
                    html += '</ul>';
                    continue;
                }
                if (line.trim() === '') { html += '<br>'; i++; continue; }
                html += '<div>' + inline(line) + '</div>';
                i++;
            }
            html = html.replace(/@@CB(\d+)CB@@/g, function (m, idx) { return blocks[parseInt(idx)]; });
            return html;
        }
        function inline(s) {
            s = escapeHtml(s);
            s = s.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
            s = s.replace(/`([^`]+)`/g, '<code>$1</code>');
            return s;
        }

        function $inner() { return $('#js-msgs .sp-ai-inner'); }
        function hideEmpty() { $('#js-empty').hide(); }
        function scrollBottom() { var el = document.getElementById('js-msgs'); el.scrollTop = el.scrollHeight; }

        function appendUser(text) {
            hideEmpty();
            $inner().append('<div class="sp-ai-row user"><div class="sp-ai-avatar"><i class="fa fa-user"></i></div>'
                + '<div class="sp-ai-col"><div class="sp-ai-bubble">' + escapeHtml(text) + '</div></div></div>');
            scrollBottom();
        }
        function appendAiBubble() {
            hideEmpty();
            var $row = $('<div class="sp-ai-row ai"><div class="sp-ai-avatar"><i class="fa fa-magic"></i></div>'
                + '<div class="sp-ai-col"><div class="sp-ai-bubble"><span class="blink">&nbsp;</span></div></div></div>');
            $inner().append($row);
            scrollBottom();
            return $row.find('.sp-ai-bubble');
        }
        function appendStaticAi(content) {
            var $col = $('<div class="sp-ai-row ai"><div class="sp-ai-avatar"><i class="fa fa-magic"></i></div>'
                + '<div class="sp-ai-col"><div class="sp-ai-bubble"></div></div></div>');
            $col.find('.sp-ai-bubble').html(renderMarkdown(content));
            $inner().append($col);
            addCopy($col.find('.sp-ai-bubble'), content);
        }
        function addCopy($bubble, raw) {
            if ($bubble.next('.sp-ai-acts').length) return;
            var $a = $('<div class="sp-ai-acts"><a><i class="fa fa-copy"></i> 复制</a></div>');
            $a.find('a').on('click', function () {
                copyText(raw);
                layer.msg('已复制', { time: 1000 });
            });
            $bubble.after($a);
        }
        function copyText(t) {
            var ta = document.createElement('textarea');
            ta.value = t; ta.style.position = 'fixed'; ta.style.opacity = '0';
            document.body.appendChild(ta); ta.select();
            try { document.execCommand('copy'); } catch (e) {}
            document.body.removeChild(ta);
        }
        function appendTool($bubble, tools) {
            var names = (tools || []).map(toolName).join('、');
            $bubble.before('<div class="sp-ai-tool"><i class="fa fa-spinner fa-spin"></i> 正在查询：' + names + '</div>');
            scrollBottom();
        }
        function toolName(n) {
            var map = {
                queryOrderStats: '工单统计', queryOverdueOrders: '超期工单', queryYieldByOperation: '报工合格率',
                querySnHistory: 'SN追溯', queryLowStockMaterials: '库存预警', queryInventory: '物料库存',
                queryBomStructure: 'BOM结构', queryMaterialByKeyword: '物料查询', queryOperationGuide: '操作指引'
            };
            return map[n] || n;
        }

        function send(text) {
            if (sending) return;
            text = (text || $('#js-input').val()).trim();
            if (!text) return;
            sending = true;
            setSending(true);
            $('#js-input').val(''); autoGrow();
            appendUser(text);
            var $bubble = appendAiBubble();
            var acc = '';

            var url = ctx + '/llm/chat/stream?message=' + encodeURIComponent(text)
                + '&conversationId=' + encodeURIComponent(currentConvId);
            var es = new EventSource(url);
            currentEs = es;

            es.addEventListener('meta', function (e) {
                try { var d = JSON.parse(e.data); if (d.conversationId) currentConvId = d.conversationId; } catch (x) {}
            });
            es.addEventListener('tool', function (e) {
                try { var d = JSON.parse(e.data); appendTool($bubble, d.tools); } catch (x) {}
            });
            es.addEventListener('delta', function (e) {
                try {
                    var d = JSON.parse(e.data);
                    acc += d.c;
                    $bubble.html(renderMarkdown(acc) + '<span class="blink">&nbsp;</span>');
                    scrollBottom();
                } catch (x) {}
            });
            es.addEventListener('error', function (e) {
                var msg = '请求出错，请稍后重试';
                try { if (e.data) { msg = JSON.parse(e.data).message || msg; } } catch (x) {}
                $bubble.html('<span style="color:#ef4444">' + escapeHtml(msg) + '</span>');
                finish(es);
            });
            es.addEventListener('done', function (e) {
                if (!acc) $bubble.html('<span style="color:#94a3b8">（无内容）</span>');
                else { $bubble.html(renderMarkdown(acc)); addCopy($bubble, acc); }
                finish(es);
                loadConversations();
            });
            es.onerror = function () {
                if (sending) {
                    if (acc) { $bubble.html(renderMarkdown(acc)); addCopy($bubble, acc); }
                    finish(es);
                }
            };
        }
        function stopGenerate() {
            if (!sending || !currentEs) return;
            try { currentEs.close(); } catch (x) {}
            $('#js-msgs .blink').last().remove();
            finish(currentEs);
        }
        function finish(es) {
            try { es.close(); } catch (x) {}
            currentEs = null;
            sending = false;
            setSending(false);
            $('#js-msgs .blink').remove();
        }
        function setSending(on) {
            var $btn = $('#js-send');
            if (on) { $btn.addClass('stop').html('<i class="fa fa-stop"></i> 停止'); }
            else { $btn.removeClass('stop').html('<i class="fa fa-paper-plane"></i> 发送'); }
        }

        function loadConversations() {
            $.post(ctx + '/llm/chat/conversations', {}, function (res) {
                if (res.code !== 0) return;
                var html = '';
                (res.data || []).forEach(function (c) {
                    var active = c.id === currentConvId ? ' active' : '';
                    html += '<div class="sp-ai-conv' + active + '" data-id="' + c.id + '" title="' + escapeHtml(c.title || '新对话') + '">'
                        + escapeHtml(c.title || '新对话')
                        + '<i class="fa fa-trash-o del" data-id="' + c.id + '"></i></div>';
                });
                $('#js-convs').html(html || '<div style="padding:10px 14px;color:#475569;font-size:12px;">暂无历史</div>');
            });
        }
        function loadMessages(id) {
            $.post(ctx + '/llm/chat/messages', { conversationId: id }, function (res) {
                var $empty = $('#js-empty').hide();
                $inner().empty().append($empty);
                if (res.code !== 0 || !res.data || !res.data.length) { $empty.show(); return; }
                res.data.forEach(function (m) {
                    if (m.role === 'user') appendUser(m.content);
                    else appendStaticAi(m.content);
                });
                scrollBottom();
            });
        }
        function resetToEmpty() {
            currentConvId = '';
            var $empty = $('#js-empty').show();
            $inner().empty().append($empty);
        }

        function autoGrow() {
            var el = document.getElementById('js-input');
            el.style.height = 'auto';
            el.style.height = Math.min(el.scrollHeight, 160) + 'px';
        }

        $('#js-send').on('click', function () { if (sending) stopGenerate(); else send(); });
        $('#js-input').on('input', autoGrow);
        $('#js-input').on('keydown', function (e) {
            if (e.keyCode === 13 && !e.shiftKey) { e.preventDefault(); send(); }
        });
        $('#js-new-chat').on('click', function () {
            if (sending) stopGenerate();
            $('#js-convs .sp-ai-conv').removeClass('active');
            resetToEmpty();
        });
        $('#js-convs').on('click', '.sp-ai-conv', function () {
            if (sending) stopGenerate();
            var id = $(this).data('id');
            currentConvId = id;
            $('#js-convs .sp-ai-conv').removeClass('active');
            $(this).addClass('active');
            loadMessages(id);
        });
        $('#js-convs').on('click', '.del', function (e) {
            e.stopPropagation();
            var id = $(this).data('id');
            layer.confirm('确认删除该会话？', function (idx) {
                $.post(ctx + '/llm/chat/delete-conversation', { conversationId: id }, function () {
                    if (id === currentConvId) { resetToEmpty(); }
                    loadConversations();
                });
                layer.close(idx);
            });
        });
        $('#js-msgs').on('click', '.sp-ai-card', function () { send($(this).data('q')); });

        loadConversations();
    });
</script>
</body>
</html>
