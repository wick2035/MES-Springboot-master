<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>智能数据助手</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        html, body { height: 100%; margin: 0; background: #f2f4f7; }
        .sp-ai-wrap { display: flex; height: 100vh; }
        .sp-ai-side { width: 240px; background: #1f2733; color: #cfd6e0; display: flex; flex-direction: column; }
        .sp-ai-side .new-chat { margin: 12px; padding: 9px 0; text-align: center; border: 1px dashed #4a5568;
            border-radius: 6px; cursor: pointer; color: #fff; font-size: 13px; }
        .sp-ai-side .new-chat:hover { background: #2b3543; }
        .sp-ai-convs { flex: 1; overflow-y: auto; }
        .sp-ai-conv { padding: 10px 14px; font-size: 13px; cursor: pointer; border-left: 3px solid transparent;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis; position: relative; }
        .sp-ai-conv:hover { background: #2b3543; }
        .sp-ai-conv.active { background: #2b3543; border-left-color: #2563EB; color: #fff; }
        .sp-ai-conv .del { display: none; position: absolute; right: 8px; top: 9px; color: #8a94a6; }
        .sp-ai-conv:hover .del { display: inline; }
        .sp-ai-main { flex: 1; display: flex; flex-direction: column; }
        .sp-ai-header { height: 48px; line-height: 48px; padding: 0 18px; background: #fff;
            border-bottom: 1px solid #e6e9ef; font-weight: bold; color: #2563EB; }
        .sp-ai-msgs { flex: 1; overflow-y: auto; padding: 20px; }
        .sp-ai-row { display: flex; margin-bottom: 18px; }
        .sp-ai-row.user { justify-content: flex-end; }
        .sp-ai-bubble { max-width: 76%; padding: 10px 14px; border-radius: 10px; font-size: 14px;
            line-height: 1.65; word-break: break-word; box-shadow: 0 1px 2px rgba(0,0,0,.05); }
        .sp-ai-row.user .sp-ai-bubble { background: #2563EB; color: #fff; border-top-right-radius: 2px; }
        .sp-ai-row.ai .sp-ai-bubble { background: #fff; color: #1f2733; border-top-left-radius: 2px; }
        .sp-ai-bubble table { border-collapse: collapse; margin: 8px 0; width: 100%; }
        .sp-ai-bubble th, .sp-ai-bubble td { border: 1px solid #dcdfe6; padding: 5px 8px; font-size: 13px; }
        .sp-ai-bubble th { background: #f5f7fa; }
        .sp-ai-bubble pre { background: #f5f7fa; padding: 8px; border-radius: 4px; overflow-x: auto; }
        .sp-ai-bubble code { background: #f0f2f5; padding: 1px 4px; border-radius: 3px; }
        .sp-ai-tool { font-size: 12px; color: #8a94a6; margin: 4px 0 10px 2px; }
        .sp-ai-tool i { color: #2563EB; }
        .sp-ai-input { border-top: 1px solid #e6e9ef; background: #fff; padding: 12px 18px; }
        .sp-ai-input textarea { width: 100%; height: 56px; resize: none; border: 1px solid #dcdfe6;
            border-radius: 6px; padding: 8px 10px; font-size: 14px; outline: none; box-sizing: border-box; }
        .sp-ai-input .bar { display: flex; justify-content: space-between; align-items: center; margin-top: 8px; }
        .sp-ai-input .tip { font-size: 12px; color: #a0a8b5; }
        .sp-ai-empty { color: #a0a8b5; text-align: center; margin-top: 80px; font-size: 14px; }
        .sp-ai-empty .examples { margin-top: 16px; }
        .sp-ai-empty .examples span { display: inline-block; margin: 5px; padding: 6px 12px; background: #fff;
            border: 1px solid #e6e9ef; border-radius: 16px; cursor: pointer; color: #2563EB; font-size: 13px; }
        .blink { animation: blink 1s steps(1) infinite; }
        @keyframes blink { 50% { opacity: 0; } }
    </style>
</head>
<body>
<div class="sp-ai-wrap">
    <div class="sp-ai-side">
        <div class="new-chat" id="js-new-chat"><i class="fa fa-plus"></i> 新建对话</div>
        <div class="sp-ai-convs" id="js-convs"></div>
    </div>
    <div class="sp-ai-main">
        <div class="sp-ai-header"><i class="fa fa-magic"></i> MES 智能数据助手</div>
        <div class="sp-ai-msgs" id="js-msgs">
            <div class="sp-ai-empty" id="js-empty">
                你好，我可以帮你查询工单、库存、报工合格率、BOM 等真实数据。
                <div class="examples">
                    <span>哪些物料低于安全库存？</span>
                    <span>统计各工序的报工合格率</span>
                    <span>有哪些超期工单？</span>
                    <span>台式电脑主机的 BOM 结构是什么？</span>
                </div>
            </div>
        </div>
        <div class="sp-ai-input">
            <textarea id="js-input" placeholder="输入你的问题，Enter 发送，Shift+Enter 换行"></textarea>
            <div class="bar">
                <span class="tip">回答基于系统真实数据，由通义千问生成，仅供参考</span>
                <button class="layui-btn layui-btn-sm" id="js-send">发送</button>
            </div>
        </div>
    </div>
</div>

<script>
    var ctx = '${request.contextPath}';
    var currentConvId = '';
    var sending = false;

    layui.use(['layer'], function () {
        var $ = layui.jquery;
        var layer = layui.layer;

        function escapeHtml(s) {
            return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
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

        function hideEmpty() { $('#js-empty').hide(); }
        function scrollBottom() { var el = document.getElementById('js-msgs'); el.scrollTop = el.scrollHeight; }

        function appendUser(text) {
            hideEmpty();
            $('#js-msgs').append('<div class="sp-ai-row user"><div class="sp-ai-bubble">' + escapeHtml(text) + '</div></div>');
            scrollBottom();
        }
        function appendAiBubble() {
            hideEmpty();
            var $row = $('<div class="sp-ai-row ai"><div class="sp-ai-bubble"><span class="blink">▍</span></div></div>');
            $('#js-msgs').append($row);
            scrollBottom();
            return $row.find('.sp-ai-bubble');
        }
        function appendTool($bubble, tools) {
            var names = (tools || []).map(toolName).join('、');
            $bubble.before('<div class="sp-ai-tool"><i class="fa fa-database"></i> 正在查询：' + names + ' ...</div>');
            scrollBottom();
        }
        function toolName(n) {
            var map = {
                queryOrderStats: '工单统计', queryOverdueOrders: '超期工单', queryYieldByOperation: '报工合格率',
                querySnHistory: 'SN追溯', queryLowStockMaterials: '库存预警', queryInventory: '物料库存',
                queryBomStructure: 'BOM结构', queryMaterialByKeyword: '物料查询'
            };
            return map[n] || n;
        }

        function send(text) {
            if (sending) return;
            text = (text || $('#js-input').val()).trim();
            if (!text) return;
            sending = true;
            $('#js-send').addClass('layui-btn-disabled').attr('disabled', true);
            $('#js-input').val('');
            appendUser(text);
            var $bubble = appendAiBubble();
            var acc = '';

            var url = ctx + '/llm/chat/stream?message=' + encodeURIComponent(text)
                + '&conversationId=' + encodeURIComponent(currentConvId);
            var es = new EventSource(url);

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
                    $bubble.html(renderMarkdown(acc));
                    scrollBottom();
                } catch (x) {}
            });
            es.addEventListener('error', function (e) {
                var msg = '请求出错，请稍后重试';
                try { if (e.data) { msg = JSON.parse(e.data).message || msg; } } catch (x) {}
                $bubble.html('<span style="color:#e54d42">' + escapeHtml(msg) + '</span>');
                finish(es);
            });
            es.addEventListener('done', function (e) {
                if (!acc) $bubble.html('<span style="color:#a0a8b5">（无内容）</span>');
                else $bubble.html(renderMarkdown(acc));
                finish(es);
                loadConversations();
            });
            es.onerror = function () {
                if (sending) { finish(es); }
            };
        }
        function finish(es) {
            try { es.close(); } catch (x) {}
            sending = false;
            $('#js-send').removeClass('layui-btn-disabled').removeAttr('disabled');
        }

        function loadConversations() {
            $.post(ctx + '/llm/chat/conversations', {}, function (res) {
                if (res.code !== 0) return;
                var html = '';
                (res.data || []).forEach(function (c) {
                    var active = c.id === currentConvId ? ' active' : '';
                    html += '<div class="sp-ai-conv' + active + '" data-id="' + c.id + '">'
                        + escapeHtml(c.title || '新对话')
                        + '<i class="fa fa-trash-o del" data-id="' + c.id + '"></i></div>';
                });
                $('#js-convs').html(html);
            });
        }
        function loadMessages(id) {
            $.post(ctx + '/llm/chat/messages', { conversationId: id }, function (res) {
                $('#js-msgs').html('');
                if (res.code !== 0 || !res.data || !res.data.length) {
                    $('#js-msgs').html($('#js-empty'));
                    $('#js-empty').show();
                    return;
                }
                res.data.forEach(function (m) {
                    if (m.role === 'user') appendUser(m.content);
                    else $('#js-msgs').append('<div class="sp-ai-row ai"><div class="sp-ai-bubble">' + renderMarkdown(m.content) + '</div></div>');
                });
                scrollBottom();
            });
        }

        $('#js-send').on('click', function () { send(); });
        $('#js-input').on('keydown', function (e) {
            if (e.keyCode === 13 && !e.shiftKey) { e.preventDefault(); send(); }
        });
        $('#js-new-chat').on('click', function () {
            currentConvId = '';
            $('#js-convs .sp-ai-conv').removeClass('active');
            $('#js-msgs').html('').append($('#js-empty'));
            $('#js-empty').show();
        });
        $('#js-convs').on('click', '.sp-ai-conv', function () {
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
                    if (id === currentConvId) { currentConvId = ''; $('#js-msgs').html('').append($('#js-empty')); $('#js-empty').show(); }
                    loadConversations();
                });
                layer.close(idx);
            });
        });
        $('#js-msgs').on('click', '.examples span', function () { send($(this).text()); });

        loadConversations();
    });
</script>
</body>
</html>
