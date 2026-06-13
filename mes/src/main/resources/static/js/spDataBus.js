;(function (window, $) {
    'use strict';

    var CHANNEL = 'sp:data-change';
    var STORAGE_KEY = '__sp_data_change__';
    var SOURCE_ID = 'sp-' + Date.now().toString(36) + '-' + Math.random().toString(36).slice(2);
    var lastEventId = {};
    var bc = null;
    var tableRegistry = {};
    var tableRefreshTimer = null;
    var tableListenerReady = false;
    var actionButtonResizeReady = false;
    var actionButtonTimer = null;

    function now() {
        return new Date().getTime();
    }

    function normalizeUrl(url) {
        var a = document.createElement('a');
        a.href = url || location.href;
        return (a.pathname || '').replace(/\/+/g, '/').toLowerCase();
    }

    function responseOk(res) {
        if (res == null) {
            return true;
        }
        if (typeof res === 'string') {
            try {
                res = JSON.parse(res);
            } catch (e) {
                return true;
            }
        }
        return res.code === undefined || res.code === 0 || res.code === 1 || res.success === true;
    }

    function shouldPublish(options, res) {
        if (!options || options.autoPublishRefresh === false || options.spAutoRefresh === false) {
            return false;
        }
        if (options.autoPublishRefresh === true || options.spAutoRefresh === true) {
            return responseOk(res);
        }

        var type = String(options.type || options.method || 'GET').toUpperCase();
        if (type === 'GET' || type === 'HEAD' || type === 'OPTIONS') {
            return false;
        }

        var url = normalizeUrl(options.url || '');
        if (!url || /\.(css|js|png|jpg|jpeg|gif|ico|svg|woff2?|ttf)$/i.test(url)) {
            return false;
        }

        var readOnlyPattern = /\/(page|list|tree|detail|info|view|select|search|query|dashboard|count|stat|stats|options|available|preview|precheck|menu|messages|conversations)(\/|$|-)/i;
        if (readOnlyPattern.test(url)) {
            return false;
        }

        var mutationPattern = /\/(add|save|update|edit|delete|remove|disable|enable|submit|create|import|upload|publish|approve|reject|complete|deliver|start|finish|close|cancel|assign|dispatch|confirm|apply|sync|calculate|generate|reset|clear|data-scope)(\/|$|-)/i;
        if (!mutationPattern.test(url)) {
            return false;
        }

        return responseOk(res);
    }

    function dispatchLocal(payload) {
        if (window.CustomEvent) {
            window.dispatchEvent(new CustomEvent(CHANNEL, {detail: payload}));
        }
    }

    function fanoutToFrames(payload) {
        var root;
        try {
            root = window.top || window;
        } catch (e) {
            root = window;
        }

        function visit(win) {
            try {
                if (win !== window && win.spDataBus && typeof win.spDataBus.receive === 'function') {
                    win.spDataBus.receive(payload);
                } else if (win !== window && win.CustomEvent) {
                    win.dispatchEvent(new win.CustomEvent(CHANNEL, {detail: payload}));
                }
                for (var i = 0; i < win.frames.length; i++) {
                    visit(win.frames[i]);
                }
            } catch (e) {
            }
        }

        visit(root);
    }

    function publish(payload) {
        payload = $.extend({
            id: SOURCE_ID + ':' + now() + ':' + Math.random().toString(36).slice(2),
            sourceId: SOURCE_ID,
            href: location.href,
            time: now()
        }, payload || {});

        receive(payload);

        try {
            if (bc) {
                bc.postMessage(payload);
            }
        } catch (e) {}

        try {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(payload));
            localStorage.removeItem(STORAGE_KEY);
        } catch (e) {}

        fanoutToFrames(payload);
    }

    function receive(payload) {
        if (!payload || !payload.id || lastEventId[payload.id]) {
            return;
        }
        lastEventId[payload.id] = true;
        dispatchLocal(payload);
    }

    function wrapAjax() {
        if (!$ || !$.ajax || $.ajax.__spDataBusWrapped) {
            return;
        }

        var rawAjax = $.ajax;
        $.ajax = function (url, options) {
            var settings = typeof url === 'object'
                ? $.extend(true, {}, url)
                : $.extend(true, {}, options || {}, {url: url});

            var userSuccess = settings.success;
            settings.success = function (res) {
                if (typeof userSuccess === 'function') {
                    userSuccess.apply(this, arguments);
                }
                if (shouldPublish(settings, res)) {
                    publish({
                        type: 'ajax',
                        method: String(settings.type || settings.method || 'GET').toUpperCase(),
                        url: normalizeUrl(settings.url || ''),
                        rawUrl: settings.url || ''
                    });
                }
            };

            return rawAjax.call(this, settings);
        };
        $.ajax.__spDataBusWrapped = true;
    }

    function getTableId(config) {
        if (!config) {
            return null;
        }
        if (config.id) {
            return config.id;
        }
        if (typeof config.elem === 'string') {
            return config.elem.replace(/^#/, '');
        }
        return null;
    }

    function reloadRegisteredTables() {
        var table = window.layui && window.layui.table;
        if (!table || !table.reload) {
            return;
        }
        window.clearTimeout(tableRefreshTimer);
        tableRefreshTimer = window.setTimeout(function () {
            $.each(tableRegistry, function (id, item) {
                try {
                    table.reload(id, $.extend(true, {}, item.reloadOptions));
                } catch (e) {
                    delete tableRegistry[id];
                }
            });
        }, 250);
    }

    function registerTable(config) {
        var id = getTableId(config);
        if (!id || config.autoRefresh === false || config.spAutoRefresh === false) {
            return;
        }
        if (!config.url && config.autoRefresh !== true && config.spAutoRefresh !== true) {
            return;
        }
        tableRegistry[id] = {
            id: id,
            reloadOptions: config.autoRefreshOptions || {}
        };
    }

    function bindTableRefreshListener() {
        if (tableListenerReady) {
            return;
        }
        tableListenerReady = true;
        window.addEventListener(CHANNEL, reloadRegisteredTables);
    }

    function estimateTemplateButtonWidth($button) {
        // 与 theme.css 操作列按钮口径一致：左右内边距 10px(共 20)、
        // 图标固定盒宽 14 + margin 4 = 18，外加每按钮 4px 安全余量。
        var text = $.trim($button.clone().children().remove().end().text()).replace(/\s+/g, '');
        var hasIcon = $button.find('.layui-icon, .fa').length > 0;
        var padding = 20;
        var minWidth = text ? 48 : 32;
        return Math.max(minWidth, textWidth(text) + (hasIcon ? 18 : 0) + padding + 4);
    }

    function estimateToolbarWidth(toolbarSelector) {
        if (typeof toolbarSelector !== 'string' || toolbarSelector.charAt(0) !== '#') {
            return 0;
        }

        var $template = $(toolbarSelector);
        if (!$template.length || !$template.html()) {
            return 0;
        }

        var $wrap = $('<div></div>').html($template.html());
        var $buttons = $wrap.find('.layui-btn');
        if (!$buttons.length) {
            $buttons = $wrap.find('[lay-event]');
        }
        if (!$buttons.length) {
            return 0;
        }

        var widthsByEvent = {};
        var eventOrder = [];
        $buttons.each(function (index) {
            var $button = $(this);
            var eventKey = $button.attr('lay-event') || ('__button_' + index);
            var width = estimateTemplateButtonWidth($button);
            if (!widthsByEvent.hasOwnProperty(eventKey)) {
                widthsByEvent[eventKey] = width;
                eventOrder.push(eventKey);
            } else {
                widthsByEvent[eventKey] = Math.max(widthsByEvent[eventKey], width);
            }
        });

        // 列宽 = 各按钮宽之和 + 按钮间距(gap 6，与 CSS 一致) + 单元格左右内边距(8*2)
        var total = 0;
        $.each(eventOrder, function (index, eventKey) {
            total += widthsByEvent[eventKey];
            if (index > 0) {
                total += 6;
            }
        });

        return Math.ceil(total + 16 + 6);
    }

    function isActionToolbarColumn(column) {
        return column && column.toolbar && (
            column.field === 'operate' ||
            column.title === '\u64cd\u4f5c' ||
            /toolbar-right|operate|bar/i.test(column.toolbar)
        );
    }

    function fitActionToolbarColumns(config) {
        if (!config || !config.cols || !$.isArray(config.cols)) {
            return;
        }

        $.each(config.cols, function (_, row) {
            if (!$.isArray(row)) {
                return;
            }

            $.each(row, function (_, column) {
                if (column.fitToolbar === false || !isActionToolbarColumn(column)) {
                    return;
                }

                var toolbarWidth = estimateToolbarWidth(column.toolbar);
                if (!toolbarWidth) {
                    return;
                }

                var maxToolbarWidth = parseInt(column.maxToolbarWidth, 10) || 760;
                var desiredWidth = Math.max(110, Math.min(toolbarWidth, maxToolbarWidth));
                column.width = desiredWidth;
                column.minWidth = desiredWidth;
                delete column.fixed;
            });
        });
    }

    function getTableView(elem) {
        var $elem = $(elem);
        var $view = $elem.next('.layui-table-view');
        if (!$view.length && $elem.attr('id')) {
            $view = $('.layui-table-view[lay-id="' + $elem.attr('id') + '"]');
        }
        return $view;
    }

    function textWidth(text) {
        var width = 0;
        text = text || '';
        for (var i = 0; i < text.length; i++) {
            width += text.charCodeAt(i) > 255 ? 12 : 6.5;
        }
        return width;
    }

    function buttonLabel($button) {
        var label = $.trim($button.attr('aria-label') || $button.attr('title') || '');
        if (label) {
            return label;
        }

        label = $.trim($button.clone().children().remove().end().text()).replace(/\s+/g, '');
        if (label) {
            return label;
        }

        label = $.trim($button.find('.sp-table-btn-text').text()).replace(/\s+/g, '');
        return label;
    }

    function prepareActionButton(button) {
        var $button = $(button);
        if (!$button.data('spActionButtonReady')) {
            $button.contents().filter(function () {
                return this.nodeType === 3 && $.trim(this.nodeValue);
            }).each(function () {
                $(this).replaceWith($('<span class="sp-table-btn-text"></span>').text($.trim(this.nodeValue)));
            });

            $button.data('spActionButtonReady', true);
        }

        var label = buttonLabel($button);
        var hasIcon = $button.find('.layui-icon, .fa').length > 0;
        $button.toggleClass('sp-table-button-no-icon', !hasIcon);

        if (label) {
            $button.attr({
                title: label,
                'aria-label': label
            });
        }

        return {
            label: label,
            hasIcon: hasIcon,
            fullWidth: Math.max(hasIcon ? 28 : 34, textWidth(label) + (hasIcon ? 18 : 0) + 16),
            compactWidth: Math.max(hasIcon ? 36 : 34, textWidth(label) + (hasIcon ? 14 : 0) + 10)
        };
    }

    function fitActionCell(cell) {
        var $cell = $(cell);
        var $buttons = $cell.find('.layui-btn');
        if (!$buttons.length) {
            return;
        }

        $cell.addClass('sp-table-action-cell');

        // 统一固定几何：逐个准备按钮（包裹文字 span、补全 title/aria-label），
        // 不再按可用宽度压缩或换行，保证按钮尺寸全局一致、图标与文字完整显示。
        // 列宽已由 estimateToolbarWidth 估足，无需运行期再测量裁剪。
        $buttons.each(function () {
            prepareActionButton(this);
        });

        // 清除历史动态压缩/换行状态与内联几何变量，回落到 theme.css 默认口径。
        $cell.removeClass('sp-action-compact sp-action-wrap');
        if (cell && cell.style && cell.style.removeProperty) {
            cell.style.removeProperty('--sp-table-action-height');
            cell.style.removeProperty('--sp-table-action-icon-size');
            cell.style.removeProperty('--sp-table-action-gap');
            cell.style.removeProperty('--sp-table-action-pad-x');
        }
    }

    function isActionBodyCell($td) {
        return $td.is('[data-off="true"], [data-field="operate"]') || $td.find('.sp-table-action-cell, .layui-btn').length > 0;
    }

    // 以表体动作列为基准对齐表头：
    // 1) LayUI 表头 th 的 data-field 在未设 field 时取列下标数字，纯 CSS 无法稳定命中，
    //    故按列下标把对应表头 th 标记 sp-table-action-th 后由 CSS 居中。
    // 2) 即便表头表体都居中，垂直滚动条占位(layui patch)或固定列宽差会让「表头列」与
    //    「表体列」整列横向错位，居中点并不重合。故再实测表体单元格内容中心，与表头标题
    //    中心比对，用 translateX 把表头标题精确移到表体按钮列的 x 位置。
    // 必须按「区」配对：主表头↔主表体、固定列表头↔固定列表体（fixed:'right' 时 LayUI
    // 会单独渲染 .layui-table-fixed-r）。表头与其表体在 DOM 中互为同级。
    function alignActionHeaders($view) {
        $view.find('.layui-table-header').each(function () {
            var $header = $(this);
            var $headerCells = $header.find('thead tr').last().children('th');
            if (!$headerCells.length) {
                return;
            }
            var $bodyRow = $header.siblings('.layui-table-body').first().find('tbody tr').first();
            if (!$bodyRow.length) {
                return;
            }
            $bodyRow.children('td').each(function (idx) {
                var $td = $(this);
                if (!isActionBodyCell($td)) {
                    return;
                }
                var $th = $headerCells.eq(idx);
                if (!$th.length) {
                    return;
                }
                $th.addClass('sp-table-action-th');

                var $thCell = $th.children('.layui-table-cell');
                var $tdCell = $td.children('.layui-table-cell');
                if (!$thCell.length || !$tdCell.length) {
                    return;
                }
                // 先清零上次的位移再测量，避免叠加
                $thCell.css('transform', '');
                var tdRect = $tdCell[0].getBoundingClientRect();
                var thRect = $thCell[0].getBoundingClientRect();
                if (!tdRect.width || !thRect.width) {
                    return;
                }
                var delta = (tdRect.left + tdRect.width / 2) - (thRect.left + thRect.width / 2);
                if (Math.abs(delta) >= 1) {
                    $thCell.css('transform', 'translateX(' + Math.round(delta) + 'px)');
                }
            });
        });
    }

    function fitTableActionButtons(root) {
        var $root = root ? $(root) : $('.layui-table-view');
        $root.find('td[data-off="true"] .layui-table-cell, td[data-field="operate"] .layui-table-cell, .sp-table-action-cell').each(function () {
            fitActionCell(this);
        });
        $root.filter('.layui-table-view').add($root.find('.layui-table-view')).each(function () {
            alignActionHeaders($(this));
        });
    }

    function scheduleFitTableActionButtons(root) {
        if (root) {
            window.requestAnimationFrame(function () {
                window.setTimeout(function () {
                    fitTableActionButtons(root);
                }, 50);
            });
            return;
        }

        window.clearTimeout(actionButtonTimer);
        actionButtonTimer = window.setTimeout(function () {
            window.requestAnimationFrame(function () {
                window.setTimeout(function () {
                    fitTableActionButtons();
                }, 50);
            });
        }, 0);
    }

    function bindActionButtonResize() {
        if (actionButtonResizeReady) {
            return;
        }
        actionButtonResizeReady = true;
        $(window).on('resize', function () {
            scheduleFitTableActionButtons();
        });
    }

    function wrapLayuiTable() {
        if (!window.layui || !window.layui.use) {
            return;
        }
        window.layui.use(['table'], function () {
            var table = window.layui.table;
            if (!table || !table.render || table.render.__spDataBusWrapped) {
                return;
            }
            var rawRender = table.render;
            table.render = function (config) {
                if (config && !config.id && typeof config.elem === 'string') {
                    config.id = config.elem.replace(/^#/, '');
                }
                fitActionToolbarColumns(config || {});
                registerTable(config || {});
                bindTableRefreshListener();
                bindActionButtonResize();

                if (config) {
                    var userDone = config.done;
                    config.done = function (res, curr, count) {
                        if (typeof userDone === 'function') {
                            userDone.call(this, res, curr, count);
                        }
                        scheduleFitTableActionButtons(getTableView(config.elem));
                    };
                }

                var renderResult = rawRender.apply(this, arguments);
                if (config) {
                    scheduleFitTableActionButtons(getTableView(config.elem));
                }
                return renderResult;
            };
            table.render.__spDataBusWrapped = true;
        });
    }

    window.spDataBus = {
        channel: CHANNEL,
        publish: publish,
        receive: receive,
        shouldPublish: shouldPublish,
        onChange: function (handler) {
            if (typeof handler !== 'function') {
                return;
            }
            window.addEventListener(CHANNEL, function (event) {
                handler(event.detail || {});
            });
        },
        fitTableActionButtons: fitTableActionButtons
    };

    try {
        if (window.BroadcastChannel) {
            bc = new BroadcastChannel(CHANNEL);
            bc.onmessage = function (event) {
                receive(event.data);
            };
        }
    } catch (e) {}

    window.addEventListener('storage', function (event) {
        if (event.key !== STORAGE_KEY || !event.newValue) {
            return;
        }
        try {
            receive(JSON.parse(event.newValue));
        } catch (e) {}
    });

    wrapAjax();
    wrapLayuiTable();
})(window, window.jQuery || window.$);
