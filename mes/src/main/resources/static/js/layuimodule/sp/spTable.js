/**
 * 组件：扩展layui数据表格
 */
layui.define(['table'], function (exports) {
    var $ = layui.jquery,
        table = layui.table;

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

        var total = 34;
        $buttons.each(function (index) {
            total += estimateButtonWidth($(this));
            if (index > 0) {
                total += 6;
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
                if (!isActionToolbarColumn(column)) {
                    return;
                }

                var toolbarWidth = estimateToolbarWidth(column.toolbar);
                if (!toolbarWidth) {
                    return;
                }

                column.width = Math.max(parseFloat(column.width) || 0, toolbarWidth);
            });
        });
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

            // 包装 done 回调：渲染后修正操作列单元格样式，防止按钮被折叠隐藏
            var userDone = config.done;
            config.done = function(res, curr, count) {
                if (typeof userDone === 'function') {
                    userDone.call(this, res, curr, count);
                }
                var $table = $(this.elem);
                $table.find('td[data-off="true"] .layui-table-cell, td[data-field="operate"] .layui-table-cell').css({
                    'overflow': 'visible',
                    'text-overflow': 'clip'
                });
                $table.find('td[data-off="true"] .layui-table-grid-down, td[data-field="operate"] .layui-table-grid-down').hide();
            };

            return table.render(config);
        }
    };

    exports('spTable', spTable);
});
