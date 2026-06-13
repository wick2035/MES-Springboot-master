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
        var text = $.trim($button.clone().children().remove().end().text()).replace(/\s+/g, '');
        var hasIcon = $button.find('.layui-icon, .fa').length > 0;
        var padding = $button.hasClass('layui-btn-xs') ? 18 : ($button.hasClass('layui-btn-sm') ? 24 : 32);
        var minWidth = text ? 42 : 30;
        return Math.max(minWidth, textWidth(text) + (hasIcon ? 20 : 0) + padding);
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

        var total = 42;
        $.each(eventOrder, function (index, eventKey) {
            total += widthsByEvent[eventKey];
            if (index > 0) {
                total += 8;
            }
        });

        return Math.ceil(total + 16);
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

        var available = Math.floor($cell.innerWidth() || $cell.closest('td').innerWidth() || 0);
        if (available <= 0) {
            var retries = parseInt($cell.data('spFitRetry'), 10) || 0;
            if (retries < 3) {
                $cell.data('spFitRetry', retries + 1);
                window.setTimeout(function () {
                    fitActionCell(cell);
                }, 100);
            }
            return;
        }
        $cell.data('spFitRetry', 0);

        var rowHeight = Math.floor($cell.closest('tr').outerHeight() || 36);
        var buttonHeight = Math.max(18, Math.min(24, rowHeight - 12));
        var gap = available < 140 ? 4 : 6;
        var padX = available < 160 ? 5 : 7;
        var iconSize = Math.max(20, Math.min(24, buttonHeight));
        var fullWidth = 0;
        var compactWidth = 0;

        $buttons.each(function (index) {
            var meta = prepareActionButton(this);
            fullWidth += meta.fullWidth + (padX * 2 - 14);
            compactWidth += meta.compactWidth;
            if (index > 0) {
                fullWidth += gap;
                compactWidth += gap;
            }
        });

        var shouldCompact = fullWidth > available;
        var shouldWrap = shouldCompact && compactWidth > available;

        $cell
            .toggleClass('sp-action-compact', shouldCompact)
            .toggleClass('sp-action-wrap', shouldWrap)
            .css({
                '--sp-table-action-height': buttonHeight + 'px',
                '--sp-table-action-icon-size': iconSize + 'px',
                '--sp-table-action-gap': (shouldWrap ? Math.max(2, gap - 2) : gap) + 'px',
                '--sp-table-action-pad-x': padX + 'px'
            });
    }

    function fitTableActionButtons(root) {
        var $root = root ? $(root) : $('.layui-table-view');
        $root.find('td[data-off="true"] .layui-table-cell, td[data-field="operate"] .layui-table-cell, .sp-table-action-cell').each(function () {
            fitActionCell(this);
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
