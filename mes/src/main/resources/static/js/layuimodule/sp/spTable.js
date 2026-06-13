/**
 * 组件：扩展layui数据表格
 */
layui.define(['table'], function (exports) {
    var $ = layui.jquery,
        table = layui.table;
    var registry = {};
    var refreshTimer = null;
    var listenerReady = false;

    function getTextWidth(text) {
        var width = 0;
        text = text || '';
        for (var i = 0; i < text.length; i++) {
            width += text.charCodeAt(i) > 255 ? 13 : 7;
        }
        return width;
    }

    function estimateButtonWidth($button) {
        var text = $.trim($button.clone().children().remove().end().text()).replace(/\s+/g, '');
        var hasIcon = $button.find('.layui-icon, .fa').length > 0;
        var padding = $button.hasClass('layui-btn-xs') ? 18 : ($button.hasClass('layui-btn-sm') ? 24 : 32);
        var minWidth = text ? 42 : 30;

        return Math.max(minWidth, getTextWidth(text) + (hasIcon ? 17 : 0) + padding);
    }

    function estimateToolbarWidth(toolbarSelector) {
        if (typeof toolbarSelector !== 'string' || toolbarSelector.charAt(0) !== '#') {
            return 0;
        }

        var $template = $(toolbarSelector);
        if (!$template.length) {
            return 0;
        }

        var html = $template.html();
        if (!html) {
            return 0;
        }

        var $wrap = $('<div></div>').html(html);
        var $buttons = $wrap.find('.layui-btn');
        if (!$buttons.length) {
            $buttons = $wrap.find('[lay-event]');
        }
        if (!$buttons.length) {
            return 0;
        }

        var total = 42;
        $buttons.each(function (index) {
            total += estimateButtonWidth($(this));
            if (index > 0) {
                total += 8;
            }
        });

        return Math.ceil(total);
    }

    function isActionToolbarColumn(column) {
        return column && column.toolbar && (
            column.field === 'operate' ||
            column.title === '\u64cd\u4f5c' ||
            /toolbar-right|operate|bar/i.test(column.toolbar)
        );
    }

    function fitActionToolbarColumns(config) {
        if (!config.cols || !$.isArray(config.cols)) {
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

                var desiredWidth = Math.max(96, Math.min(toolbarWidth, 360));
                column.width = desiredWidth;
                column.minWidth = desiredWidth;
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

    function isInsetChromeTable(config) {
        var path = window.location ? (window.location.pathname || '') : '';
        var url = config && config.url ? String(config.url) : '';
        return path.indexOf('/production-order/') > -1 || url.indexOf('/production-order/') > -1 ||
            path.indexOf('/warehouse/') > -1 || url.indexOf('/warehouse/') > -1;
    }

    function applyInsetTableChrome(config) {
        if (!isInsetChromeTable(config)) {
            return;
        }
        var $view = getTableView(config.elem);
        if ($view.length) {
            $view.addClass('sp-production-table-view');
        }
    }

    function getTableId(config) {
        if (config.id) {
            return config.id;
        }
        if (typeof config.elem === 'string') {
            return config.elem.replace(/^#/, '');
        }
        return null;
    }

    function remember(config) {
        var id = getTableId(config);
        if (!id || config.autoRefresh === false || config.spAutoRefresh === false) {
            return;
        }
        if (!config.url && config.autoRefresh !== true && config.spAutoRefresh !== true) {
            return;
        }
        registry[id] = {
            id: id,
            reloadOptions: config.autoRefreshOptions || {}
        };
    }

    function reloadRegisteredTables(reason) {
        window.clearTimeout(refreshTimer);
        refreshTimer = window.setTimeout(function () {
            $.each(registry, function (id, item) {
                try {
                    table.reload(id, $.extend(true, {}, item.reloadOptions));
                } catch (e) {
                    delete registry[id];
                }
            });
        }, 250);
    }

    function bindRefreshListener() {
        if (listenerReady) {
            return;
        }
        listenerReady = true;
        if (window.spDataBus && typeof window.spDataBus.onChange === 'function') {
            window.spDataBus.onChange(reloadRegisteredTables);
        } else if (window.addEventListener) {
            window.addEventListener('sp:data-change', function (event) {
                reloadRegisteredTables(event.detail || {});
            });
        }
    }

    var spTable = {
        // 渲染表格
        render: function (param) {
            var defaultConfig = {
                elem: '#js-record-table',
                toolbar: '#js-record-table-toolbar-top',
                method: 'POST',
                limits: [10, 20, 50, 100],
                limit: 10,
                page: true,
                height: 'full-' + ($('#js-search-form').height() + 40),
                request: {
                    pageName: 'current'
                    , limitName: 'size'
                },
                parseData: function (res) {
                    return {
                        "code": res.code,
                        "msg": res.msg,
                        "count": res.data ? res.data.total : 0,
                        "data": res.data ? res.data.records : []
                    };
                }
            };

            var config = $.extend({}, defaultConfig, param, {
            });

            fitActionToolbarColumns(config);
            if (!config.id && typeof config.elem === 'string') {
                config.id = config.elem.replace(/^#/, '');
            }
            remember(config);
            bindRefreshListener();

            // 包装 done 回调：渲染后修正操作列单元格样式，防止按钮被折叠隐藏
            var userDone = config.done;
            config.done = function(res, curr, count) {
                if (typeof userDone === 'function') {
                    userDone.call(this, res, curr, count);
                }
                var $view = getTableView(config.elem);
                applyInsetTableChrome(config);
                var $actionCells = $view.find('td[data-off="true"], td[data-field="operate"]');
                $actionCells.addClass('sp-table-action-td');
                $actionCells.find('.layui-table-cell').addClass('sp-table-action-cell').css({
                    'overflow': 'visible',
                    'text-overflow': 'clip'
                });
                $actionCells.find('.layui-table-grid-down').hide();
            };

            var instance = table.render(config);
            window.setTimeout(function () {
                applyInsetTableChrome(config);
            }, 0);
            return instance;
        }
    };

    exports('spTable', spTable);
});
