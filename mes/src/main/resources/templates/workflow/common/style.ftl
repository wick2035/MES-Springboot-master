<style>
    .wf-shell {
        padding: 12px 18px 18px;
        background:
            linear-gradient(135deg, rgba(37, 99, 235, .08), transparent 34%),
            linear-gradient(180deg, #f8fbff 0%, #eef3f8 100%);
        min-height: calc(100vh - 36px);
    }
    .wf-hero {
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        gap: 16px;
        margin-bottom: 10px;
        padding: 16px 20px;
        border: 1px solid rgba(37, 99, 235, .14);
        border-radius: 8px;
        background: rgba(255, 255, 255, .86);
        box-shadow: 0 12px 32px rgba(15, 23, 42, .08);
    }
    .wf-title {
        margin: 0;
        color: #102a43;
        font-size: 22px;
        font-weight: 700;
        letter-spacing: 0;
    }
    .wf-subtitle {
        margin-top: 6px;
        color: #526173;
        font-size: 13px;
        line-height: 1.7;
    }
    .wf-pill {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        height: 30px;
        padding: 0 12px;
        border-radius: 999px;
        background: #eef5ff;
        color: #2563eb;
        font-size: 12px;
        font-weight: 600;
        white-space: nowrap;
    }
    .wf-panel {
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        background: rgba(255,255,255,.94);
        box-shadow: 0 8px 24px rgba(15, 23, 42, .06);
        padding: 12px 14px;
    }
    .wf-search {
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        min-height: 56px;
        padding: 9px 12px;
        border-radius: 8px;
        background: #f8fafc;
        border: 1px solid #e7edf5;
        box-sizing: border-box;
    }
    .wf-flow-preview {
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        gap: 10px;
        min-height: 64px;
        padding: 12px;
        border: 1px solid #dbe7f6;
        border-radius: 8px;
        background: linear-gradient(180deg, #fbfdff, #f3f7fb);
    }
    .wf-node {
        position: relative;
        min-width: 96px;
        padding: 9px 12px;
        border: 1px solid #c8d8ec;
        border-radius: 8px;
        background: #fff;
        color: #18324a;
        font-size: 13px;
        line-height: 1.35;
        box-shadow: 0 5px 14px rgba(15,23,42,.07);
    }
    .wf-node.approval {
        border-color: #2563eb;
        background: #eff6ff;
    }
    .wf-node.end {
        border-color: #16a34a;
        background: #ecfdf3;
    }
    .wf-arrow {
        color: #7b8ca3;
        font-size: 18px;
    }
    .wf-json {
        min-height: 260px;
        font-family: Consolas, Monaco, monospace;
        font-size: 12px;
        line-height: 1.6;
    }
    .wf-badge {
        display: inline-block;
        padding: 2px 9px;
        border-radius: 999px;
        font-size: 12px;
        line-height: 18px;
        font-weight: 600;
    }
    .wf-badge.ok { color: #15803d; background: #dcfce7; }
    .wf-badge.warn { color: #b45309; background: #fef3c7; }
    .wf-badge.info { color: #1d4ed8; background: #dbeafe; }
    .wf-badge.gray { color: #64748b; background: #f1f5f9; }
    .wf-badge.danger { color: #dc2626; background: #fee2e2; }
    .wf-form-wrap {
        padding: 18px 20px 8px;
    }
    .wf-form-tip {
        margin: 0 0 14px;
        padding: 10px 12px;
        border-radius: 8px;
        border: 1px solid #dbe7f6;
        background: #f8fbff;
        color: #526173;
        line-height: 1.7;
        font-size: 13px;
    }
    .wf-hero-command {
        background: rgba(255, 255, 255, .86);
        color: #102a43;
        border-color: rgba(37, 99, 235, .14);
    }
    .wf-hero-command .wf-title { color: #102a43; }
    .wf-hero-command .wf-subtitle { color: #526173; }
    .wf-metric-strip {
        display: grid;
        grid-template-columns: repeat(3, minmax(96px, 1fr));
        gap: 8px;
        min-width: 340px;
    }
    .wf-metric-strip span {
        border: 1px solid #dbe7f6;
        border-radius: 8px;
        padding: 10px 12px;
        background: #f8fbff;
        color: #526173;
        font-size: 12px;
        white-space: nowrap;
    }
    .wf-metric-strip b {
        display: block;
        margin-bottom: 2px;
        color: #102a43;
        letter-spacing: .08em;
    }
    .wf-mini-chip {
        display: inline-flex;
        align-items: center;
        height: 22px;
        margin-right: 4px;
        padding: 0 8px;
        border-radius: 999px;
        background: #eef2f7;
        color: #94a3b8;
        font-size: 12px;
    }
    .wf-mini-chip.on {
        background: #e0f2fe;
        color: #0369a1;
        font-weight: 600;
    }
    .wf-designer {
        background: linear-gradient(180deg, #f8fbff, #eef4f8);
        min-height: calc(100vh - 28px);
    }
    .wf-editor-grid {
        display: grid;
        grid-template-columns: 1fr 1.2fr;
        gap: 14px;
    }
    .wf-editor-section {
        border: 1px solid #dbe7f0;
        border-radius: 8px;
        background: rgba(255,255,255,.96);
        padding: 14px 16px 4px;
        box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
    }
    .wf-editor-section h3 {
        margin: 0 0 14px;
        color: #0f172a;
        font-size: 15px;
        font-weight: 700;
    }
    .wf-editor-wide { margin-top: 14px; }
    .wf-preset-row {
        display: flex;
        gap: 8px;
        margin-bottom: 12px;
        flex-wrap: wrap;
    }
    .wf-token-bar {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        margin: -2px 0 12px 110px;
    }
    .wf-token-bar span {
        padding: 4px 8px;
        border-radius: 6px;
        background: #eff6ff;
        color: #1d4ed8;
        font-family: Consolas, Monaco, monospace;
        font-size: 12px;
    }
    .wf-help {
        margin-top: 6px;
        color: #64748b;
        font-size: 12px;
    }
    .wf-muted {
        color: #64748b;
        font-size: 12px;
        margin-left: 12px;
    }
    .wf-check-row .layui-form-checkbox { margin-right: 10px; }
    .wf-page-head {
        position: relative;
        overflow: hidden;
        margin-bottom: 10px;
        border: 1px solid rgba(37, 99, 235, .14);
        border-radius: 8px;
        background: rgba(255, 255, 255, .86);
        box-shadow: 0 12px 32px rgba(15, 23, 42, .08);
    }
    .wf-page-head:before {
        content: "";
        position: absolute;
        inset: 0;
        pointer-events: none;
        opacity: .38;
        background-image:
            linear-gradient(rgba(37,99,235,.10) 1px, transparent 1px),
            linear-gradient(90deg, rgba(37,99,235,.10) 1px, transparent 1px);
        background-size: 28px 28px;
        mask-image: linear-gradient(90deg, #000 0%, transparent 82%);
    }
    .wf-page-head-inner {
        position: relative;
        display: grid;
        grid-template-columns: minmax(280px, 1fr);
        gap: 14px;
        align-items: stretch;
        padding: 16px 22px 18px;
    }
    .wf-page-kicker {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        height: 26px;
        padding: 0 10px;
        border: 1px solid #dbe7f6;
        border-radius: 999px;
        background: #eef5ff;
        color: #2563eb;
        font-size: 12px;
        font-weight: 600;
    }
    .wf-page-title {
        margin: 10px 0 6px;
        color: #102a43;
        font-size: 28px;
        line-height: 1.2;
        font-weight: 800;
        letter-spacing: 0;
    }
    .wf-page-copy {
        max-width: 680px;
        color: #526173;
        font-size: 13px;
        line-height: 1.65;
    }
    .wf-route-board {
        align-self: center;
        padding: 14px;
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        background: rgba(255,255,255,.88);
        box-shadow: 0 12px 30px rgba(15, 23, 42, .10);
    }
    .wf-route-title {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 10px;
        color: #102a43;
        font-size: 13px;
        font-weight: 700;
    }
    .wf-route-title span {
        color: #64748b;
        font-size: 12px;
        font-weight: 500;
    }
    .wf-route-steps {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 8px;
    }
    .wf-route-step {
        min-height: 58px;
        padding: 10px;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        background: #f8fafc;
        color: #475569;
        font-size: 12px;
        line-height: 1.45;
    }
    .wf-route-step b {
        display: block;
        margin-bottom: 4px;
        color: #0f172a;
        font-size: 13px;
    }
    .wf-route-step.on {
        border-color: #38bdf8;
        background: linear-gradient(180deg, #ecfeff, #ffffff);
        box-shadow: inset 0 3px 0 #38bdf8;
    }
    .wf-stat-grid {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 10px;
        margin-bottom: 10px;
    }
    .wf-stat {
        position: relative;
        overflow: hidden;
        min-height: 82px;
        padding: 12px 14px 10px;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        background: #ffffff;
        box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
    }
    .wf-stat:after {
        content: "";
        position: absolute;
        right: 0;
        bottom: 0;
        width: 70px;
        height: 4px;
        background: var(--wf-accent, #38bdf8);
    }
    .wf-stat-label {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 8px;
        color: #64748b;
        font-size: 12px;
        font-weight: 600;
    }
    .wf-stat-label i { color: var(--wf-accent, #38bdf8); }
    .wf-stat-value {
        margin-top: 8px;
        color: #0f172a;
        font-size: 28px;
        line-height: 1;
        font-weight: 800;
        letter-spacing: 0;
    }
    .wf-stat-note {
        margin-top: 6px;
        color: #94a3b8;
        font-size: 12px;
    }
    .wf-filter-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        margin-bottom: 12px;
    }
    .wf-filter-row .wf-search {
        flex: 1 1 auto;
        min-width: 0;
        margin-bottom: 0;
        box-sizing: border-box;
    }
    .wf-search .layui-form-item {
        display: flex;
        align-items: center;
        flex-wrap: nowrap;
        gap: 24px;
        width: 100%;
        margin-bottom: 0;
    }
    .wf-search .layui-inline {
        display: inline-flex;
        align-items: center;
        flex: none;
        margin: 0;
        vertical-align: middle;
    }
    .wf-search .layui-form-label {
        flex: none;
        width: auto;
        min-width: 52px;
        padding: 0 10px 0 0;
        line-height: 36px;
        color: #475569;
        box-sizing: border-box;
    }
    .wf-search .layui-input-inline {
        width: 190px;
        margin: 0;
    }
    .wf-search .layui-inline:last-child {
        gap: 10px;
    }
    .wf-search .layui-inline:last-child .layui-btn {
        margin: 0;
        min-width: 86px;
    }
    .wf-quick-tabs {
        flex: none;
        display: inline-flex;
        gap: 6px;
        margin-top: 0;
        padding: 6px;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        background: #ffffff;
        box-shadow: 0 8px 18px rgba(15, 23, 42, .05);
        white-space: nowrap;
    }
    .wf-quick-tab {
        height: 30px;
        min-width: 68px;
        padding: 0 12px;
        border: 1px solid transparent;
        border-radius: 6px;
        background: transparent;
        color: #64748b;
        cursor: pointer;
        font-size: 12px;
        font-weight: 600;
        transition: all .18s ease;
    }
    .wf-quick-tab:hover {
        border-color: #bfdbfe;
        background: #eff6ff;
        color: #1d4ed8;
    }
    .wf-quick-tab.on {
        border-color: #bfdbfe;
        background: #dbeafe;
        color: #1d4ed8;
        box-shadow: inset 0 0 0 1px rgba(37, 99, 235, .08);
    }
    .wf-table-wrap {
        overflow: hidden;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        background: #ffffff;
    }
    .wf-table-wrap .layui-table-view {
        margin: 0;
        border-width: 0;
    }
    .wf-main-cell {
        min-width: 0;
    }
    .wf-main-cell b {
        display: block;
        overflow: hidden;
        color: #0f172a;
        text-overflow: ellipsis;
        white-space: nowrap;
        font-size: 13px;
    }
    .wf-main-cell span {
        display: block;
        overflow: hidden;
        margin-top: 3px;
        color: #94a3b8;
        text-overflow: ellipsis;
        white-space: nowrap;
        font-size: 12px;
    }
    .wf-code-pill {
        display: inline-flex;
        align-items: center;
        max-width: 100%;
        height: 24px;
        padding: 0 8px;
        border-radius: 6px;
        background: #eef6ff;
        color: #075985;
        font-family: Consolas, Monaco, monospace;
        font-size: 12px;
        font-weight: 700;
    }
    .wf-node-mark {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        max-width: 100%;
        height: 26px;
        padding: 0 9px;
        border: 1px solid #dbeafe;
        border-radius: 999px;
        background: #f8fbff;
        color: #1e3a8a;
        font-size: 12px;
        font-weight: 700;
    }
    .wf-action-group {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        flex-wrap: nowrap;
        width: 100%;
        line-height: 1;
    }
    .wf-action-group .layui-btn-xs {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 58px;
        height: 26px;
        line-height: 26px;
        margin: 0 !important;
        padding: 0 9px;
        border: 1px solid #bfdbfe;
        border-radius: 6px;
        background: #eff6ff;
        color: #1d4ed8;
        box-sizing: border-box;
        white-space: nowrap;
        box-shadow: none;
    }
    .wf-action-group .layui-btn-xs:hover {
        border-color: #93c5fd;
        background: #dbeafe;
        color: #1d4ed8;
    }
    .wf-action-group .layui-btn-normal {
        border-color: #2563eb;
        background: #2563eb;
        color: #fff;
    }
    .wf-action-group .layui-btn-normal:hover {
        border-color: #1d4ed8;
        background: #1d4ed8;
        color: #fff;
    }
    .wf-action-group .layui-btn-danger {
        border-color: #fecaca;
        background: #fef2f2;
        color: #dc2626;
    }
    .wf-action-group .layui-btn-danger:hover {
        border-color: #fca5a5;
        background: #fee2e2;
        color: #b91c1c;
    }
    .wf-action-group .layui-btn-xs i {
        margin-right: 4px;
        font-size: 12px;
    }
    .wf-trace-dialog {
        padding: 18px;
        background: linear-gradient(180deg, #f8fafc, #ffffff);
    }
    .wf-trace-head {
        display: flex;
        justify-content: space-between;
        gap: 16px;
        margin-bottom: 14px;
        padding-bottom: 12px;
        border-bottom: 1px solid #e2e8f0;
    }
    .wf-trace-head b {
        display: block;
        color: #0f172a;
        font-size: 15px;
    }
    .wf-trace-head span {
        color: #64748b;
        font-size: 12px;
    }
    .wf-timeline {
        display: grid;
        gap: 10px;
    }
    .wf-timeline-item {
        display: grid;
        grid-template-columns: 32px 1fr;
        gap: 10px;
        align-items: start;
    }
    .wf-timeline-dot {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: #e2e8f0;
        color: #64748b;
    }
    .wf-timeline-item.done .wf-timeline-dot { background: #dcfce7; color: #15803d; }
    .wf-timeline-item.todo .wf-timeline-dot { background: #fef3c7; color: #b45309; }
    .wf-timeline-item.rejected .wf-timeline-dot { background: #fee2e2; color: #dc2626; }
    .wf-timeline-item.revoked .wf-timeline-dot { background: #f1f5f9; color: #64748b; }
    .wf-timeline-body {
        padding: 11px 12px;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        background: #ffffff;
    }
    .wf-timeline-title {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        margin-bottom: 5px;
        color: #0f172a;
        font-weight: 700;
    }
    .wf-timeline-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        color: #64748b;
        font-size: 12px;
        line-height: 1.7;
    }
    .wf-timeline-opinion {
        margin-top: 6px;
        padding-top: 6px;
        border-top: 1px dashed #e2e8f0;
        color: #475569;
        font-size: 12px;
        line-height: 1.7;
    }
    .wf-empty {
        padding: 22px;
        border: 1px dashed #cbd5e1;
        border-radius: 8px;
        background: #f8fafc;
        color: #64748b;
        text-align: center;
    }
    @media (max-width: 900px) {
        .wf-hero { align-items: flex-start; flex-direction: column; }
        .wf-metric-strip { width: 100%; min-width: 0; grid-template-columns: 1fr; }
        .wf-editor-grid { grid-template-columns: 1fr; }
        .wf-token-bar { margin-left: 0; }
        .wf-page-head-inner { grid-template-columns: 1fr; }
        .wf-route-steps { grid-template-columns: repeat(2, 1fr); }
        .wf-stat-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        .wf-filter-row { flex-direction: column; }
        .wf-quick-tabs { width: 100%; overflow-x: auto; }
    }
    @media (max-width: 560px) {
        .wf-page-head {
            background: rgba(255, 255, 255, .86);
        }
        .wf-route-board { display: none; }
        .wf-page-head-inner { padding: 18px; }
        .wf-page-title { font-size: 24px; }
        .wf-stat-grid { grid-template-columns: 1fr; }
    }
</style>
