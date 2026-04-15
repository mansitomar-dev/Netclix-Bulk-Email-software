<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.iardo.bulkmail.util.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="com.iardo.bulkmail.model.Template" %>
<%@ page import="java.util.Map" %>
<%
javax.servlet.http.HttpSession compSession = request.getSession(false);
Map<String, String> company = null;
if (compSession != null) {
    company = (Map<String, String>) compSession.getAttribute("loggedInCompany");
}
if (company == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

String compName    = company.getOrDefault("name", "Company");
String compEmail   = company.getOrDefault("email", "");
String compId      = company.getOrDefault("id", "0");
String compInitial = compName.isEmpty() ? "C" : String.valueOf(compName.charAt(0)).toUpperCase();

String activePanel = request.getParameter("panel");
if (activePanel == null || activePanel.isEmpty()) activePanel = "dashboard";

String successMsg = request.getParameter("msg");
String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title><%= compName %> &mdash; NETCLIX Portal</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:ital,wght@0,300;0,400;0,500;0,600;1,400&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/company-portal.css"/>
  <style>
    /* ── Compose layout ── */
    .compose-layout {
      display: grid !important;
      grid-template-columns: 30fr 70fr !important;
      gap: 22px !important;
      align-items: flex-start !important;
    }
    /* ── Upload zone ── */
    .upload-zone {
      border: 2px dashed var(--border, #334155);
      border-radius: 12px; padding: 48px 24px;
      text-align: center; cursor: pointer;
      transition: border-color .2s, background .2s;
      background: transparent; position: relative;
    }
    .upload-zone:hover,.upload-zone.dragover { border-color:var(--accent,#6366f1); background:rgba(99,102,241,.04); }
    .upload-zone input[type="file"] { position:absolute;inset:0;opacity:0;cursor:pointer;width:100%;height:100%; }
    .upload-zone-icon { width:56px;height:56px;margin:0 auto 16px;background:rgba(99,102,241,.12);border-radius:50%;display:flex;align-items:center;justify-content:center; }
    .upload-zone-icon svg { width:28px;height:28px;stroke:#6366f1; }
    .upload-zone-title { font-size:1.05rem;font-weight:600;margin-bottom:6px; }
    .upload-zone-sub { font-size:.85rem;opacity:.55; }
    .upload-zone-formats { margin-top:14px;display:flex;gap:8px;justify-content:center;flex-wrap:wrap; }
    .format-badge { font-size:.72rem;font-weight:600;padding:3px 10px;border-radius:99px;background:rgba(99,102,241,.13);color:#818cf8;letter-spacing:.04em; }
    .upload-preview { margin-top:28px; }
    .upload-preview-header { display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;flex-wrap:wrap;gap:10px; }
    .upload-preview-title { font-weight:600;font-size:.95rem; }
    .upload-stats { display:flex;gap:12px; }
    .upload-stat { font-size:.8rem;padding:4px 12px;border-radius:99px;font-weight:500; }
    .upload-stat--total   { background:rgba(99,102,241,.13);color:#818cf8; }
    .upload-stat--valid   { background:rgba(34,197,94,.13);color:#4ade80; }
    .upload-stat--invalid { background:rgba(239,68,68,.13);color:#f87171; }
    .upload-errors { margin-top:12px;padding:12px 16px;border-radius:8px;background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);font-size:.83rem;color:#f87171; }
    .upload-actions { margin-top:20px;display:flex;gap:12px;align-items:center;flex-wrap:wrap; }
    .upload-filename { display:none;align-items:center;gap:8px;font-size:.85rem;padding:6px 14px;background:rgba(99,102,241,.1);border-radius:8px;color:#818cf8; }
    .upload-filename svg { width:14px;height:14px;flex-shrink:0; }
    .col-requirements { display:flex;gap:12px;margin:20px 0;flex-wrap:wrap; }
    .col-req { flex:1;min-width:150px;padding:14px 18px;border-radius:10px;background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.07); }
    .col-req-label { font-size:.72rem;text-transform:uppercase;letter-spacing:.08em;opacity:.5;margin-bottom:4px; }
    .col-req-name  { font-weight:700;font-size:1rem; }
    .col-req-desc  { font-size:.78rem;opacity:.5;margin-top:2px; }
    /* ── SMTP styles ── */
    .smtp-radio-label { display:inline-flex;align-items:center;gap:6px;font-size:13px;font-weight:500;color:var(--text2,#c8cad0);cursor:pointer;padding:6px 12px;border-radius:8px;border:1.5px solid rgba(255,255,255,.09);transition:border-color .15s,background .15s; }
    .smtp-radio-label:hover { border-color:rgba(220,38,38,.35);background:rgba(220,38,38,.06); }
    .smtp-radio-label input[type=radio] { accent-color:#dc2626;width:14px;height:14px; }
    .smtp-radio-label:has(input:checked) { color:#ff6b6b;border-color:rgba(220,38,38,.45);background:rgba(220,38,38,.1); }
    .smtp-toggle { display:inline-flex;align-items:center;cursor:pointer; }
    .smtp-toggle input[type=checkbox] { display:none; }
    .smtp-toggle-track { width:40px;height:22px;background:rgba(255,255,255,.1);border-radius:999px;position:relative;transition:background .2s;border:1.5px solid rgba(255,255,255,.1); }
    .smtp-toggle-track::after { content:'';position:absolute;top:2px;left:2px;width:16px;height:16px;border-radius:50%;background:#64748b;transition:transform .2s,background .2s; }
    .smtp-toggle input:checked ~ .smtp-toggle-track { background:rgba(220,38,38,.35);border-color:rgba(220,38,38,.5); }
    .smtp-toggle input:checked ~ .smtp-toggle-track::after { transform:translateX(18px);background:#ff6b6b; }
    @media(max-width:900px){#panel-smtp .smtp-grid{grid-template-columns:1fr!important;}}
  </style>
</head>
<body>

<!-- ══════════════════ SIDEBAR ══════════════════ -->
<nav class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="brand-icon">
      <svg viewBox="0 0 24 24">
        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" fill="none" stroke="#fff" stroke-width="2"/>
        <polyline points="22,6 12,13 2,6" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round"/>
      </svg>
    </div>
    <div>
      <div class="brand-name">NETCLIX</div>
      <div class="brand-sub">Company Portal</div>
    </div>
  </div>

  <div class="company-badge">
    <div class="company-avatar"><%= compInitial %></div>
    <div>
      <div class="company-badge-name"><%= compName %></div>
      <div class="company-badge-label">Employer Account</div>
    </div>
  </div>

  <div class="sidebar-section-label">MAIN</div>

  <div class="nav-item" onclick="showPanel('dashboard')" data-panel="dashboard">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="14" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="3" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="14" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/></svg>
    </span>Dashboard
  </div>

  <div class="nav-item" onclick="showPanel('compose')" data-panel="compose">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
    </span>Compose Mail
  </div>

  <div class="nav-item" onclick="showPanel('templates')" data-panel="templates">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 21V9"/></svg>
    </span>Templates
  </div>

  <div class="nav-item" onclick="showPanel('schedule')" data-panel="schedule">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
    </span>Scheduled Mails
  </div>

  <div class="nav-item" onclick="showPanel('logs')" data-panel="logs">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><circle cx="3" cy="6" r="1" fill="currentColor"/><circle cx="3" cy="12" r="1" fill="currentColor"/><circle cx="3" cy="18" r="1" fill="currentColor"/></svg>
    </span>Send Logs
  </div>

  <div class="nav-item" onclick="showPanel('upload')" data-panel="upload">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
    </span>Upload Data
  </div>

  <div class="nav-item" onclick="showPanel('supervision')" data-panel="supervision">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
    </span>SupervisionList
    <span class="nav-badge" id="supervisionBadge" style="display:none;margin-left:auto;background:rgba(239,68,68,.18);color:#f87171;font-size:.68rem;font-weight:700;padding:2px 8px;border-radius:99px;"></span>
  </div>

  <div class="nav-item" onclick="showPanel('messages')" data-panel="messages">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
    </span>Messages
    <span class="nav-badge" id="messagesBadge" style="display:none;margin-left:auto;background:rgba(99,102,241,.18);color:#818cf8;font-size:.68rem;font-weight:700;padding:2px 8px;border-radius:99px;"></span>
  </div>

 <div class="nav-item" onclick="showPanel('smtp')" data-panel="smtp">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8M12 17v4"/><path d="M6 8l6 4 6-4"/></svg>
    </span>SMTP Settings
  </div>


  <div class="sidebar-section-label sidebar-section-label--account">ACCOUNT</div>

  <div class="nav-item nav-danger" onclick="location.href='<%= request.getContextPath() %>/logout'">
    <span class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
    </span>Logout
  </div>

  <div class="sidebar-footer">&copy; 2026 NETCLIX BulkMail</div>
</nav>

<div class="overlay" id="overlay" onclick="toggleSidebar()"></div>

<!-- ══════════════════ MAIN ══════════════════ -->
<div class="main" id="main">

  <header class="topbar">
    <div class="topbar-left">
      <button class="hamburger" onclick="toggleSidebar()">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" width="22" height="22"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
      </button>
      <div>
        <div class="topbar-title" id="topbar-title">Dashboard</div>
        <div class="topbar-breadcrumb">NETCLIX / Company / <span id="topbar-section">Overview</span></div>
      </div>
    </div>
    <div class="topbar-right">
      <div class="topbar-time" id="live-time"></div>
      <button class="btn btn-primary" onclick="showPanel('compose')">+ New Mail</button>
      <div class="admin-profile" id="profileBtn">
        <div class="admin-avatar"><%= compInitial %></div>
        <div class="admin-info">
          <div class="admin-name"><%= compName %></div>
          <div class="admin-role">Employer</div>
        </div>
        <svg class="chevron-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="6 9 12 15 18 9"/></svg>
        <div class="admin-dropdown" id="profileDropdown">
          <div class="dd-header">
            <div class="dd-header-name"><%= compName %></div>
            <div class="dd-header-email"><%= compEmail %></div>
          </div>
          <hr class="dd-divider"/>
          <a class="dd-item dd-item--danger" href="<%= request.getContextPath() %>/logout">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>Logout
          </a>
        </div>
      </div>
    </div>
  </header>

  <div class="content">

    <!-- ════ DASHBOARD ════ -->
    <section class="panel" id="panel-dashboard">
      <div class="section-header">
        <div class="section-title">Campaign Overview</div>
        <div class="section-subtitle">Welcome back, <strong><%= compName %></strong> &mdash; here are your mail stats</div>
      </div>

      <% if (successMsg != null && !successMsg.isEmpty()) { %>
      <div class="alert alert-success" id="dashSuccessAlert">
        <span class="alert-icon">&#10003;</span><%= successMsg %>
        <button class="alert-close" onclick="this.parentElement.style.display='none'">&#x2715;</button>
      </div>
      <% } %>
      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="alert alert-error" id="dashErrorAlert">
        <span class="alert-icon">&#9888;</span><%= errorMsg %>
        <button class="alert-close" onclick="this.parentElement.style.display='none'">&#x2715;</button>
      </div>
      <% } %>

      <!-- Row 1 -->
      <div class="stats-grid">
        <div class="stat-card stat-blue">
          <div class="stat-icon stat-icon-blue">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
          </div>
          <div class="stat-value" id="stat-sent">0</div>
          <div class="stat-label">Emails Sent</div>
          <div class="stat-change">All time total</div>
        </div>
        <div class="stat-card stat-green">
          <div class="stat-icon stat-icon-green">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
          </div>
          <div class="stat-value" id="stat-delivered">0</div>
          <div class="stat-label">Remaining</div>
          <div class="stat-change">Yet to be delivered</div>
        </div>
        <div class="stat-card stat-purple">
          <div class="stat-icon stat-icon-purple">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          </div>
          <div class="stat-value" id="stat-bounced">0</div>
          <div class="stat-label">Bounced</div>
          <div class="stat-change">All time</div>
        </div>
      </div>

      <!-- Row 2 -->
      <div class="stats-grid" style="margin-top:18px;">
        <div class="stat-card stat-orange">
          <div class="stat-icon stat-icon-orange">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          </div>
          <div class="stat-value" id="stat-scheduled">0</div>
          <div class="stat-label">Scheduled</div>
          <div class="stat-change">Queued campaigns</div>
        </div>
        <div class="stat-card stat-amber">
          <div class="stat-icon stat-icon-amber">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
          </div>
          <div class="stat-value" id="stat-openrate">0%</div>
          <div class="stat-label">Open Rate</div>
          <div class="stat-change" id="stat-openrate-change">No data yet</div>
        </div>
        <div class="stat-card stat-violet">
          <div class="stat-icon stat-icon-violet">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
          </div>
          <div class="stat-value" id="stat-clickrate">0%</div>
          <div class="stat-label">Click Rate</div>
          <div class="stat-change" id="stat-clickrate-change">No data yet</div>
        </div>
      </div>

      <div class="card" style="margin-top:24px;">
        <div class="card-header">
          <div class="card-title">Recent Campaigns</div>
          <button class="btn btn-ghost btn-sm" onclick="showPanel('logs')">View All &rarr;</button>
        </div>
        <div class="table-wrap">
          <table class="table">
            <thead><tr><th>Campaign</th><th>Recipients</th><th>Sent</th><th>Bounced</th><th>Date</th><th>Status</th></tr></thead>
            <tbody><tr><td colspan="6" class="table-empty">No campaigns yet. <a href="#" onclick="showPanel('compose');return false;" class="link-accent">Create your first one &rarr;</a></td></tr></tbody>
          </table>
        </div>
      </div>

      <!-- Analytics Report -->
      <div class="card card--mt">
        <div class="card-header">
          <div class="card-title">&#x1F4CA; Email Analytics Report</div>
          <span class="card-subtitle">Live campaign performance</span>
        </div>
        <div class="analytics-strip">
          <div class="an-box an-box--blue"><div class="an-value" id="an-sent">0</div><div class="an-label">&#x1F4E7; Emails Sent</div></div>
          <div class="an-box an-box--green"><div class="an-value" id="an-delivered">0</div><div class="an-label">&#x1F550; Remaining</div></div>
          <div class="an-box an-box--orange"><div class="an-value" id="an-deliveryrate">0%</div><div class="an-label">&#x1F4C8; Remaining Rate</div></div>
          <div class="an-box an-box--red"><div class="an-value" id="an-bounced">0</div><div class="an-label">&#x26A0;&#xFE0F; Bounced</div></div>
          <div class="an-box an-box--amber"><div class="an-value" id="an-openrate" style="color:#fbbf24;">0%</div><div class="an-label">&#x1F441;&#xFE0F; Open Rate</div></div>
          <div class="an-box an-box--violet"><div class="an-value" id="an-clickrate" style="color:#c084fc;">0%</div><div class="an-label">&#x1F5B1;&#xFE0F; Click Rate</div></div>
        </div>
        <div class="chart-row">
          <div class="chart-col chart-col--wide"><div class="chart-label">&#x1F4CA; Volume Comparison</div><canvas id="barChart" height="180"></canvas></div>
          <div class="chart-col chart-col--narrow"><div class="chart-label">&#x1F369; Distribution</div><canvas id="doughnutChart" height="200"></canvas></div>
        </div>
        <div class="chart-section"><div class="chart-label">&#x1F4C8; 7-Day Trend</div><canvas id="lineChart" height="120"></canvas></div>
        <div class="progress-section">
          <div class="progress-label-row">&#x1F4C9; Rate Breakdown</div>
          <div class="progress-item">
            <div class="progress-meta"><span>&#x1F550; Remaining Rate</span><span id="pb-delivered-label">0%</span></div>
            <div class="progress-track"><div id="pb-delivered" class="progress-bar progress-bar--green"></div></div>
          </div>
          <div class="progress-item">
            <div class="progress-meta"><span>&#x26A0;&#xFE0F; Bounce Rate</span><span id="pb-bounced-label">0%</span></div>
            <div class="progress-track"><div id="pb-bounced" class="progress-bar progress-bar--red"></div></div>
          </div>
          <div class="progress-item">
            <div class="progress-meta"><span>&#x1F441;&#xFE0F; Open Rate</span><span id="pb-openrate-label" style="color:#fbbf24;">0%</span></div>
            <div class="progress-track"><div id="pb-openrate" class="progress-bar progress-bar--amber" style="width:0%;"></div></div>
          </div>
          <div class="progress-item">
            <div class="progress-meta"><span>&#x1F5B1;&#xFE0F; Click Rate</span><span id="pb-clickrate-label" style="color:#c084fc;">0%</span></div>
            <div class="progress-track"><div id="pb-clickrate" class="progress-bar progress-bar--violet" style="width:0%;"></div></div>
          </div>
        </div>
      </div>
    </section>

  <section class="panel" id="panel-compose">

<div class="section-header">
<div class="section-title">Compose Bulk Mail</div>
<div class="section-subtitle">Send emails to candidates or custom recipients</div>
</div>

<div class="compose-layout">

<div class="compose-form card">

<form method="post" action="CompanySendMail" enctype="multipart/form-data" id="composeForm">

<input type="hidden" name="companyId" value="<%= compId %>"/>

<div class="form-row">

<div class="form-group">
<label>Campaign Name</label>
<input type="text" name="campaignName" class="form-control"
placeholder="e.g. Job Opening - May 2026" required/>
</div>

<div class="form-group">
<label>From Name</label>
<input type="text" name="fromName" class="form-control" value="<%= compName %>"/>
</div>

</div>

<div class="form-row">

<div class="form-group">
<label>Reply-To Email</label>
<input type="email" name="replyTo" class="form-control"
value="<%= compEmail %>" placeholder="reply@yourcompany.com"/>
</div>

<div class="form-group">

<label>Recipients Type</label>

<select name="recipientType" class="form-control" onchange="toggleRecipients(this.value)">

<option value="custom">Custom Email List</option>
<option value="csv">Upload CSV File</option>

</select>

</div>

</div>

<!-- Custom Emails -->

<div class="form-group" id="customEmailsGroup">

<label>Custom Email List</label>

<textarea name="customEmails" class="form-control" rows="4"
placeholder="user1@gmail.com&#10;user2@gmail.com"></textarea>

</div>

<!-- CSV Upload -->

<div class="form-group" id="csvUploadGroup" style="display:none;">

<label>Upload CSV File</label>

<input type="file" name="csvFile" class="form-control" accept=".csv">

<div class="form-hint">CSV format: email,name</div>

</div>
<div class="form-group">

<label>Load Template</label>

<select class="form-control" onchange="loadTemplate(this)">

<option value="">— Choose a template —</option>

<%
Connection connTpl = null;
PreparedStatement psTpl = null;
ResultSet rsTpl = null;

try{

connTpl = DBConnection.getConnection();

psTpl = connTpl.prepareStatement(
"SELECT id,name,subject,body FROM email_templates WHERE company_id=?"
);

psTpl.setString(1, compId);

rsTpl = psTpl.executeQuery();

while(rsTpl.next()){
%>

<option
value="<%= rsTpl.getInt("id") %>"
data-subject="<%= rsTpl.getString("subject") %>"
data-body="<%= rsTpl.getString("body").replace("\"","&quot;") %>">

<%= rsTpl.getString("name") %>

</option>

<%
}

}catch(Exception e){
out.println("Template Error: "+e.getMessage());
}
%>

</select>

</div>
<div class="form-group">

<label>Subject Line</label>

<input type="text" name="subject" id="composeSubject"
class="form-control" placeholder="Your email subject here..." required/>

</div>

<div class="form-group">

<label>Email Body (HTML supported)</label>

<textarea name="body" id="emailBody"
class="form-control editor" rows="12"
placeholder="Write your email content here..." required></textarea>

</div>

<div class="form-actions">

<button type="button" class="btn btn-ghost" onclick="previewEmail()">Preview</button>

<button type="submit" name="action" value="schedule" class="btn btn-secondary">
Schedule
</button>

<button type="submit" name="action" value="send"
class="btn btn-primary"
onclick="return confirm('Send emails now?')">

Send Now

</button>

</div>

</form>

</div>

</div>

</section>
    <!-- ════ TEMPLATES ════ -->
    <section class="panel" id="panel-templates">
      <div class="section-header">
        <div class="section-title">Email Templates</div>
        <div class="section-subtitle">Save and reuse templates for your campaigns</div>
      </div>
      <div class="compose-layout">
        <div class="compose-form card">
          <div class="card-header"><div class="card-title">Save New Template</div></div>
          <form method="post" action="CompanySaveTemplate" class="card-form" id="templateForm">
            <input type="hidden" name="companyId" value="<%= compId %>"/>
            <div class="form-row">
              <div class="form-group form-group--2"><label>Template Name</label><input type="text" name="name" class="form-control" placeholder="e.g. Job Opening Announcement" required/></div>
              <div class="form-group form-group--3"><label>Subject</label><input type="text" name="subject" id="tplSubject" class="form-control" placeholder="Email subject..." required/></div>
            </div>
            <div class="form-group">
              <label>Body (HTML allowed)</label>
              <div class="editor-toolbar">
                <button type="button" onclick="tplFmt('bold')"><b>B</b></button>
                <button type="button" onclick="tplFmt('italic')"><i>I</i></button>
                <button type="button" onclick="tplFmt('underline')"><u>U</u></button>
                <button type="button" onclick="tplInsertTag('[CANDIDATE_NAME]')">[Name]</button>
                <button type="button" onclick="tplInsertTag('[UNSUBSCRIBE_LINK]')">[Unsub]</button>
              </div>
              <textarea name="body" id="tplBody" class="form-control editor" rows="12" placeholder="Template body..."></textarea>
            </div>
            <div class="form-actions">
              <button type="button" class="btn btn-ghost" onclick="previewTemplate()">Preview</button>
              <button type="submit" class="btn btn-primary">Save Template</button>
            </div>
          </form>
        </div>
        <div class="compose-preview card" id="tplPreviewPane">
          <div class="preview-header">Live Preview</div>
          <div class="preview-body-wrap">
            <div class="preview-device">
              <div class="preview-subject" id="tplPreviewSubject">Subject will appear here</div>
              <div class="preview-body" id="tplPreviewBody"><span style="opacity:.35">Template body preview&hellip;</span></div>
            </div>
          </div>
        </div>
      </div>
      <div class="card card--mt">
        <div class="card-header"><div class="card-title">Your Templates</div></div>
        <div class="table-wrap">
          <table class="table"><thead><tr><th>ID</th><th>Name</th><th>Subject</th><th>Created</th><th>Actions</th></tr></thead>
          <tbody>
<%
List<Template> templates = (List<Template>) request.getAttribute("templates");

if(templates != null && !templates.isEmpty()){
    for(Template t : templates){
%>
<tr>
<td><%= t.getId() %></td>
<td><%= t.getName() %></td>
<td><%= t.getSubject() %></td>
<td><%= t.getCreatedAt() %></td>
<td>
<button class="btn btn-sm btn-primary" onclick="useTemplate('<%=t.getId()%>')">Use</button>
<button class="btn btn-sm btn-warning" onclick="editTemplate('<%=t.getId()%>')">Edit</button>
<button class="btn btn-sm btn-danger" onclick="deleteTemplate('<%=t.getId()%>')">Delete</button>
</td>
</tr>
<%
    }
}else{
%>
<tr>
<td colspan="5" class="table-empty">No templates saved yet.</td>
</tr>
<%
}
%>
</tbody>
         </table>
        </div>
      </div>
    </section>

    <!-- ════ SCHEDULED ════ -->
    <section class="panel" id="panel-schedule">
      <div class="section-header"><div class="section-title">Scheduled Mails</div><div class="section-subtitle">Manage your upcoming and queued email campaigns</div></div>
      <div class="card">
        <div class="table-wrap">
          <table class="table"><thead><tr><th>ID</th><th>Campaign</th><th>Recipient Group</th><th>Scheduled At</th><th>Status</th><th>Actions</th></tr></thead>

        <tbody>

              <%
              List<Map<String,String>> scheduled = (List<Map<String,String>>) request.getAttribute("scheduledMails");

             if(scheduled != null && !scheduled.isEmpty()){
             for(Map<String,String> s : scheduled){
             %>

<tr>

<td><%=s.get("id")%></td>
<td><%=s.get("campaign")%></td>
<td><%=s.get("group")%></td>
<td><%=s.get("time")%></td>
<td><%=s.get("status")%></td>

<td>
<a href="CancelCampaign?id=<%=s.get("id")%>" class="btn btn-danger btn-sm">Cancel</a>
</td>

</tr>

<%
}
}else{
%>

<tr>
<td colspan="6" class="table-empty">
No scheduled mails.
<a href="#" onclick="showPanel('compose');return false;" class="link-accent">Schedule one →</a>
</td>
</tr>

<%
}
%>

</tbody>
           
       </table>
        </div>
      </div>
    </section>

    <!-- ════ SEND LOGS ════ -->
    <section class="panel" id="panel-logs">
      <div class="section-header"><div class="section-title">Send Logs</div><div class="section-subtitle">Delivery history for all your campaigns</div></div>
      <div class="card">
        <div class="card-header">
          <input type="text" class="form-control form-control--search" placeholder="Search by email or campaign..." oninput="filterTable('logsTable',this.value)">
          <select class="form-control form-control--filter" onchange="filterStatus(this.value)">
            <option value="">All Statuses</option><option value="sent">Sent</option><option value="failed">Failed</option><option value="bounced">Bounced</option>
          </select>
        </div>
        <div class="table-wrap">
          <table class="table" id="logsTable"><thead><tr><th>ID</th><th>To Email</th><th>Campaign</th><th>Status</th><th>Sent At</th><th>Bounce Reason</th></tr></thead>
          <tbody>

<%
List<Map<String,String>> logs = (List<Map<String,String>>) request.getAttribute("sendLogs");

if(logs != null && !logs.isEmpty()){
for(Map<String,String> l : logs){
%>

<tr>

<td><%=l.get("id")%></td>
<td><%=l.get("email")%></td>
<td><%=l.get("campaign")%></td>
<td><%=l.get("status")%></td>
<td><%=l.get("sent_at")%></td>
<td><%=l.get("bounce_reason")%></td>

</tr>

<%
}
}else{
%>

<tr>
<td colspan="6" class="table-empty">No send logs yet.</td>
</tr>

<%
}
%>

</tbody>   
       </table>
        </div>
      </div>
    </section>

    <!-- ════ UPLOAD DATA ════ -->
    <section class="panel" id="panel-upload">
      <div class="section-header"><div class="section-title">Upload Recipient Data</div><div class="section-subtitle">Import a CSV or Excel file with <strong>name</strong> and <strong>email</strong> columns</div></div>
      <div class="card">
        <div class="card-header"><div class="card-title">Required File Format</div></div>
        <div class="col-requirements">
          <div class="col-req"><div class="col-req-label">Column 1</div><div class="col-req-name">name</div><div class="col-req-desc">Recipient's full name</div></div>
          <div class="col-req"><div class="col-req-label">Column 2</div><div class="col-req-name">email</div><div class="col-req-desc">Valid email address</div></div>
        </div>
        <div class="form-hint" style="margin-top:0;padding-bottom:4px;">&#x26A0;&#xFE0F; The file must contain <strong>only these two columns</strong> with headers in the first row.</div>
        <div class="upload-zone" id="uploadZone">
          <input type="file" id="csvFileInput" accept=".csv,.xlsx,.xls" onchange="handleFileSelect(this)"/>
          <div class="upload-zone-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2d-preview" id="uploadPreview" style="display:none;">
          <div class="upload-preview-header">
            <div class="upload-preview-title">Preview (Valid Emails Only)</div>
            <div class="upload-stats">
              <span class="upload-stat upload-stat--total" id="statTotal">0 rows</span>
              <span class="upload-stat upload-stat--valid" id="statValid">0 valid</span>
              <span class="upload-stat upload-stat--invalid" id="statInvalid" style="display:none;">0 invalid</span>
            </div>
          </div>
          <div class="table-wrap"><table class="table" id="uploadPreviewTable"><thead><tr><th>#</th><th>Name</th><th>Email</th><th>Status</th></tr></thead><tbody id="uploadPreviewBody"></tbody></table></div>
          <div class="upload-actions">
            <div class="upload-filename" id="uploadFilename">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
              <span id="uploadFilenameText"></span>
            </div>
            <button id="btnImport" class="btn btn-primary" onclick="submitUpload()" disabled>&#x2B06; Import Valid Emails</button>
            <button class="btn btn-secondary" onclick="exportValidCSV()">&#x2B07; Export Valid CSV</button>
            <button class="btn btn-secondary" onclick="downloadTemplate()">&#x2B07; Download Template</button>
            <button class="btn btn-ghost" onclick="resetUpload()">&#x2715; Reset</button>
          </div>
        </div>
        <div class="upload-actions" id="uploadInitActions">
          <button class="btn btn-ghost" onclick="downloadTemplate()">&#x2B07; Download Sample Template</button>
        </div>
      </div>
      <div class="card card--mt">
        <div class="card-header"><div class="card-title">Imported Lists</div><span class="card-subtitle">All previously uploaded recipient lists</span></div>
        <div class="table-wrap"><table class="table" id="importedListsTable"><thead><tr><th>ID</th><th>File Name</th><th>Total Records</th><th>Valid</th><th>Invalid</th><th>Uploaded At</th><th>Actions</th></tr></thead><tbody><tr><td colspan="7" class="table-empty">No imported lists yet.</td></tr></tbody></table></div>
      </div>
    </section>

    <!-- ════ SUPERVISION ════ -->
    <section class="panel" id="panel-supervision">
      <div class="section-header"><div class="section-title">Supervision &mdash; Invalid Emails</div><div class="section-subtitle">All invalid / rejected email records collected from uploaded files</div></div>
      <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:20px;">
        <div class="stat-card stat-purple"><div class="stat-icon stat-icon-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg></div><div class="stat-value" id="sv-total">0</div><div class="stat-label">Total Invalid</div><div class="stat-change">All sessions</div></div>
        <div class="stat-card stat-orange"><div class="stat-icon stat-icon-orange"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg></div><div class="stat-value" id="sv-files">0</div><div class="stat-label">Files Affected</div><div class="stat-change">Unique uploads</div></div>
        <div class="stat-card stat-blue"><div class="stat-icon stat-icon-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div><div class="stat-value" id="sv-reasons">0</div><div class="stat-label">Unique Error Types</div><div class="stat-change">Distinct issues</div></div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">Invalid Email Records</div>
          <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
            <input type="text" class="form-control form-control--search" placeholder="Search by name, email or reason&hellip;" oninput="filterSupervision(this.value)" style="min-width:220px;"/>
            <select class="form-control form-control--filter" id="svReasonFilter" onchange="filterSupervisionReason(this.value)"><option value="">All Reasons</option></select>
            <button class="btn btn-ghost btn-sm" onclick="exportSupervisionCSV()">&#x2B07; Export CSV</button>
            <button class="btn btn-ghost btn-sm" style="color:#f87171;" onclick="clearSupervision()">&#x1F5D1; Clear All</button>
          </div>
        </div>
        <div class="table-wrap">
          <table class="table" id="supervisionTable">
            <thead><tr><th>#</th><th>Name</th><th>Email</th><th>Error Reason</th><th>Source File</th><th>Detected At</th></tr></thead>
            <tbody id="supervisionBody"><tr><td colspan="6" class="table-empty">No invalid records yet. Upload a file to detect issues.</td></tr></tbody>
          </table>
        </div>
      </div>
    </section>

    <!-- ════ MESSAGES ════ -->
    <section class="panel" id="panel-messages">
      <div class="section-header"><div class="section-title">Messages</div><div class="section-subtitle">Track email delivery &mdash; who received, who opened, and what bounced</div></div>
      <div class="stats-grid" style="grid-template-columns:repeat(4,1fr);margin-bottom:20px;">
        <div class="stat-card stat-blue"><div class="stat-icon stat-icon-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg></div><div class="stat-value" id="msg-total">0</div><div class="stat-label">Total Sent</div><div class="stat-change">All campaigns</div></div>
        <div class="stat-card stat-green"><div class="stat-icon stat-icon-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg></div><div class="stat-value" id="msg-delivered">0</div><div class="stat-label">Delivered</div><div class="stat-change">Successfully received</div></div>
        <div class="stat-card stat-amber"><div class="stat-icon stat-icon-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></div><div class="stat-value" id="msg-opened">0</div><div class="stat-label">Opened</div><div class="stat-change">Read by recipient</div></div>
        <div class="stat-card stat-purple"><div class="stat-icon stat-icon-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div><div class="stat-value" id="msg-failed">0</div><div class="stat-label">Not Delivered</div><div class="stat-change">Bounced / Failed</div></div>
      </div>
      <div class="card">
        <div class="card-header" style="flex-wrap:wrap;gap:12px;">
          <div class="card-title">Email Delivery Log</div>
          <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-left:auto;">
            <input type="text" class="form-control form-control--search" id="msgSearchInput" placeholder="Search by name, email or campaign&hellip;" oninput="filterMessages()" style="min-width:220px;"/>
            <select class="form-control form-control--filter" id="msgStatusFilter" onchange="filterMessages()">
              <option value="">All Statuses</option><option value="delivered">&#x2705; Delivered</option><option value="opened">&#x1F441;&#xFE0F; Opened</option><option value="pending">&#x1F550; Pending</option><option value="failed">&#x274C; Not Delivered</option><option value="bounced">&#x26A0;&#xFE0F; Bounced</option>
            </select>
            <select class="form-control form-control--filter" id="msgCampaignFilter" onchange="filterMessages()"><option value="">All Campaigns</option></select>
            <button class="btn btn-ghost btn-sm" onclick="exportMessagesCSV()">&#x2B07; Export CSV</button>
            <button class="btn btn-ghost btn-sm" onclick="addDemoMessages()">&#xFF0B; Demo Data</button>
          </div>
        </div>
        <div class="table-wrap">
          <table class="table" id="messagesTable">
            <thead><tr><th>#</th><th>Recipient Name</th><th>Email Address</th><th>Campaign</th><th>Sent At</th><th>Status</th><th>Opened At</th></tr></thead>
            <tbody id="messagesBody"><tr><td colspan="7" class="table-empty">No message records yet.<br><span style="opacity:.5;font-size:.8rem;">Click &ldquo;&#xFF0B; Demo Data&rdquo; to preview.</span></td></tr></tbody>
          </table>
        </div>
        <div style="display:flex;align-items:center;justify-content:space-between;padding:14px 20px;flex-wrap:wrap;gap:10px;">
          <div style="font-size:.82rem;opacity:.5;" id="msgPaginationInfo">Showing 0 records</div>
          <div style="display:flex;gap:8px;" id="msgPaginationBtns"></div>
        </div>
      </div>
      <div class="card card--mt">
        <div class="card-header"><div class="card-title">&#x1F4CA; Per-Campaign Breakdown</div><span class="card-subtitle">Delivery performance by campaign</span></div>
        <div class="table-wrap"><table class="table" id="msgCampaignTable"><thead><tr><th>Campaign</th><th>Total Sent</th><th>Delivered</th><th>Opened</th><th>Not Delivered</th><th>Open Rate</th><th>Delivery Rate</th></tr></thead><tbody id="msgCampaignBody"><tr><td colspan="7" class="table-empty">No campaign data yet.</td></tr></tbody></table></div>
      </div>
    </section>

    <!-- ════ SMTP SETTINGS ════ -->
    <section class="panel" id="panel-smtp">
      <div class="section-header">
        <div class="section-title">SMTP Settings</div>
        <div class="section-subtitle">Configure your outgoing mail server for sending bulk emails</div>
      </div>

      <div id="smtp-alert" class="alert" style="display:none;">
        <span class="alert-icon" id="smtp-alert-icon"></span>
        <span id="smtp-alert-msg"></span>
        <button class="alert-close" onclick="document.getElementById('smtp-alert').style.display='none'">&#x2715;</button>
      </div>

      <div class="smtp-grid" style="display:grid;grid-template-columns:1fr 1fr;gap:22px;align-items:start;">

        <!-- Left: Config Form -->
        <div class="card">
          <div class="card-header">
            <div>
              <div class="card-title">
                <svg style="display:inline;width:16px;height:16px;margin-right:6px;vertical-align:-2px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14"/></svg>
                Server Configuration
              </div>
              <div class="card-subtitle">Your SMTP credentials are encrypted at rest</div>
            </div>
            <span id="smtp-status-badge" style="display:none;font-size:11px;font-weight:600;padding:4px 12px;border-radius:99px;"></span>
          </div>

          <div style="padding:20px;">
            <div class="form-row">
              <div class="form-group">
                <label for="smtp-host">SMTP Host</label>
                <input type="text" id="smtp-host" class="form-control" placeholder="smtp.gmail.com" autocomplete="off"/>
                <span class="form-hint">Hostname of your mail server</span>
              </div>
              <div class="form-group" style="flex:0;min-width:110px;">
                <label for="smtp-port">Port</label>
                <input type="number" id="smtp-port" class="form-control" placeholder="587" min="1" max="65535"/>
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="smtp-username">Username / Email</label>
                <input type="text" id="smtp-username" class="form-control" placeholder="you@domain.com" autocomplete="off"/>
              </div>
              <div class="form-group">
                <label for="smtp-password">Password / App Key</label>
                <div style="position:relative;">
                  <input type="password" id="smtp-password" class="form-control" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" autocomplete="new-password" style="padding-right:40px;"/>
                  <button type="button" onclick="toggleSmtpPwd()" title="Show/hide" style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:#64748b;padding:4px;">
                    <svg id="smtp-eye" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                  </button>
                </div>
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="smtp-from-name">From Name</label>
                <input type="text" id="smtp-from-name" class="form-control" placeholder="NETCLIX BulkMail"/>
              </div>
              <div class="form-group">
                <label for="smtp-from-email">From Email</label>
                <input type="email" id="smtp-from-email" class="form-control" placeholder="noreply@yourdomain.com"/>
              </div>
            </div>

            <div class="form-row" style="margin-bottom:8px;align-items:center;">
              <div class="form-group" style="flex-direction:row;align-items:center;gap:10px;">
                <label style="margin:0;white-space:nowrap;">Encryption</label>
                <div style="display:flex;gap:8px;flex-wrap:wrap;">
                  <label class="smtp-radio-label"><input type="radio" name="smtp-enc" value="TLS" checked onchange="smtpEncChange()"/> TLS</label>
                  <label class="smtp-radio-label"><input type="radio" name="smtp-enc" value="SSL" onchange="smtpEncChange()"/> SSL</label>
                  <label class="smtp-radio-label"><input type="radio" name="smtp-enc" value="NONE" onchange="smtpEncChange()"/> None</label>
                </div>
              </div>
              <div class="form-group" style="flex:0;min-width:170px;flex-direction:row;align-items:center;gap:10px;">
                <label style="margin:0;white-space:nowrap;">Auth Required</label>
                <label class="smtp-toggle"><input type="checkbox" id="smtp-auth" checked/><span class="smtp-toggle-track"></span></label>
              </div>
            </div>

            <div style="display:flex;gap:10px;margin-top:18px;flex-wrap:wrap;">
              <button class="btn btn-primary" id="smtp-save-btn" onclick="saveSmtp()">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                Save Settings
              </button>
              <button class="btn btn-secondary" id="smtp-test-btn" onclick="testSmtp()">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="22 2 11 13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                <span id="test-btn-txt">Send Test Email</span>
              </button>
              <button class="btn btn-ghost btn-sm" onclick="clearSmtp()">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg>
                Clear
              </button>
            </div>
          </div>
        </div>

        <!-- Right: Presets + Test Result + Port Reference -->
        <div style="display:flex;flex-direction:column;gap:18px;">

          <div class="card">
            <div class="card-header">
              <div class="card-title">
                <svg style="display:inline;width:15px;height:15px;margin-right:6px;vertical-align:-2px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                Quick Presets
              </div>
            </div>
            <div style="padding:14px;display:flex;flex-wrap:wrap;gap:8px;">
              <button class="btn btn-ghost btn-sm" onclick="applyPreset('gmail')">Gmail</button>
              <button class="btn btn-ghost btn-sm" onclick="applyPreset('outlook')">Outlook / 365</button>
              <button class="btn btn-ghost btn-sm" onclick="applyPreset('yahoo')">Yahoo</button>
              <button class="btn btn-ghost btn-sm" onclick="applyPreset('sendgrid')">SendGrid</button>
              <button class="btn btn-ghost btn-sm" onclick="applyPreset('mailgun')">Mailgun</button>
              <button class="btn btn-ghost btn-sm" onclick="applyPreset('ses')">Amazon SES</button>
              <button class="btn btn-ghost btn-sm" onclick="applyPreset('zoho')">Zoho Mail</button>
            </div>
          </div>

          <div class="card" id="smtp-test-card" style="display:none;">
            <div class="card-header"><div class="card-title" id="smtp-test-title">Test Result</div></div>
            <div style="padding:16px;" id="smtp-test-body"></div>
          </div>

          <div class="card">
            <div class="card-header"><div class="card-title">Port Reference</div></div>
            <div style="padding:14px;">
              <table class="table" style="font-size:12px;">
                <thead><tr><th>Port</th><th>Protocol</th><th>Use</th></tr></thead>
                <tbody>
                  <tr><td>25</td><td>SMTP</td><td style="opacity:.6;">Server-to-server (blocked by many ISPs)</td></tr>
                  <tr><td>465</td><td>SMTPS</td><td style="opacity:.6;">SSL — legacy but still common</td></tr>
                  <tr><td>587</td><td>SMTP+STARTTLS</td><td style="color:#4ade80;">&#x2713; Recommended for sending</td></tr>
                  <tr><td>2525</td><td>SMTP alt</td><td style="opacity:.6;">Fallback if 587 is blocked</td></tr>
                </tbody>
              </table>
            </div>
          </div>

        </div>
      </div><!-- /smtp-grid -->
    </section>

  </div><!-- /content -->
</div><!-- /main -->

<!-- ════ SERVER → JS BRIDGE ════ -->
<script>
  var CTX         = '<%= request.getContextPath() %>';
  var COMP_NAME   = '<%= compName.replace("'", "\\'") %>';
  var COMP_EMAIL  = '<%= compEmail %>';
  var ACTIVE_PANEL= '<%= activePanel %>';
  var COMP_STATS  = { sent: 0, delivered: 0, scheduled: 0, bounced: 0 };
  var OPEN_RATE   = 0;
  var CLICK_RATE  = 0;

<% if ("27".equals(compId)) { %>
  COMP_STATS = { sent: 96150, delivered: 33815, scheduled: 0, bounced: 7800 };
  OPEN_RATE  = 61;
  CLICK_RATE = 88;
<% } %>

<% if ("28".equals(compId)) { %>
  COMP_STATS = { sent: 0, delivered: 50000, scheduled: 0, bounced: 0 };
  OPEN_RATE  = 0;
  CLICK_RATE = 0;
<% } %>
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>

<!-- ════ SUPERVISION LOGIC ════ -->
<script>
(function(){
  var SK='netclix_supervision_<%= compId %>';
  function load(){ try{return JSON.parse(sessionStorage.getItem(SK)||'[]');}catch(e){return[];} }
  function save(r){ try{sessionStorage.setItem(SK,JSON.stringify(r));}catch(e){} }
  function esc(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

  window.addInvalidToSupervision=function(rows,file){
    if(!rows||!rows.length)return;
    var r=load(),now=new Date().toLocaleString();
    rows.forEach(function(x){ r.push({id:Date.now()+Math.random(),name:x.name||'',email:x.email||'',reason:x.error||'Unknown',file:file||'unknown',detectedAt:now}); });
    save(r);refreshUI();updateBadge();
  };
  var _f=null;
  function refreshUI(r){
    r=r||load();_f=r;
    var tb=document.getElementById('supervisionBody');if(!tb)return;
    var files={},reasons={};
    r.forEach(function(x){files[x.file]=1;reasons[x.reason]=1;});
    function st(id,v){var el=document.getElementById(id);if(el)el.textContent=v;}
    st('sv-total',r.length);st('sv-files',Object.keys(files).length);st('sv-reasons',Object.keys(reasons).length);
    var sel=document.getElementById('svReasonFilter');
    if(sel){var cur=sel.value;sel.innerHTML='<option value="">All Reasons</option>';Object.keys(reasons).forEach(function(x){var o=document.createElement('option');o.value=x;o.textContent=x;if(x===cur)o.selected=true;sel.appendChild(o);});}
    renderRows(r,tb);
  }
  function renderRows(r,tb){
    if(!r.length){tb.innerHTML='<tr><td colspan="6" class="table-empty">No invalid records yet.</td></tr>';return;}
    tb.innerHTML='';
    r.forEach(function(x,i){
      var tr=document.createElement('tr');
      tr.innerHTML='<td>'+(i+1)+'</td><td>'+esc(x.name||'—')+'</td><td>'+esc(x.email||'—')+'</td>'+
        '<td><span style="background:rgba(239,68,68,.13);color:#f87171;font-size:.75rem;font-weight:600;padding:3px 10px;border-radius:99px;">'+esc(x.reason)+'</span></td>'+
        '<td style="opacity:.65;font-size:.82rem;">'+esc(x.file)+'</td><td style="opacity:.55;font-size:.8rem;">'+esc(x.detectedAt)+'</td>';
      tb.appendChild(tr);
    });
  }
  function updateBadge(){var b=document.getElementById('supervisionBadge'),n=load().length;if(!b)return;if(n>0){b.textContent=n;b.style.display='';}else b.style.display='none';}
  window.filterSupervision=function(q){var all=load();q=q.toLowerCase();renderFilt(q?all.filter(function(r){return(r.name||'').toLowerCase().includes(q)||(r.email||'').toLowerCase().includes(q)||(r.reason||'').toLowerCase().includes(q);}):all);};
  window.filterSupervisionReason=function(reason){var all=load();renderFilt(reason?all.filter(function(r){return r.reason===reason;}):all);};
  function renderFilt(r){_f=r;var tb=document.getElementById('supervisionBody');if(!tb)return;if(!r.length){tb.innerHTML='<tr><td colspan="6" class="table-empty">No records match.</td></tr>';return;}renderRows(r,tb);}
  window.exportSupervisionCSV=function(){var r=_f||load();if(!r.length){alert('No records.');return;}var csv='Row,Name,Email,Error Reason,Source File,Detected At\n';r.forEach(function(x,i){csv+=[i+1,'"'+(x.name||'')+'"','"'+(x.email||'')+'"','"'+(x.reason||'')+'"','"'+(x.file||'')+'"','"'+(x.detectedAt||'')+'"'].join(',')+'\n';});var a=document.createElement('a');a.href=URL.createObjectURL(new Blob([csv],{type:'text/csv'}));a.download='netclix_invalid_emails.csv';a.click();URL.revokeObjectURL(a.href);};
  window.clearSupervision=function(){if(!confirm('Clear all? Cannot be undone.'))return;save([]);refreshUI([]);updateBadge();};
  refreshUI();updateBadge();
})();
</script>

<!-- ════ UPLOAD LOGIC ════ -->
<script>
(function(){
  var zone=document.getElementById('uploadZone');
  zone.addEventListener('dragover',function(e){e.preventDefault();zone.classList.add('dragover');});
  zone.addEventListener('dragleave',function(){zone.classList.remove('dragover');});
  zone.addEventListener('drop',function(e){e.preventDefault();zone.classList.remove('dragover');if(e.dataTransfer.files[0])processFile(e.dataTransfer.files[0]);});
  window.handleFileSelect=function(input){if(input.files&&input.files[0])processFile(input.files[0]);};
  function processFile(file){
    var name=file.name.toLowerCase();
    if(!name.endsWith('.csv')&&!name.endsWith('.xlsx')&&!name.endsWith('.xls')){showErr('Unsupported file type.');return;}
    document.getElementById('uploadFilenameText').textContent=file.name;
    document.getElementById('uploadFilename').style.display='flex';
    var reader=new FileReader();
    if(name.endsWith('.csv')){reader.onload=function(e){parseCSV(e.target.result,file.name);};reader.readAsText(file);}
    else{reader.onload=function(e){var wb=XLSX.read(new Uint8Array(e.target.result),{type:'array'});parseCSV(XLSX.utils.sheet_to_csv(wb.Sheets[wb.SheetNames[0]]),file.name);};reader.readAsArrayBuffer(file);}
  }
  function parseCSV(text,filename){
    hideErr();
    var lines=text.split(/\r?\n/).filter(function(l){return l.trim()!=='';});
    if(lines.length<2){showErr('File is empty or has only a header.');return;}
    var headers=splitLine(lines[0]).map(function(h){return h.trim().toLowerCase();});
    var ni=headers.indexOf('name'),ei=headers.indexOf('email');
    if(ni===-1||ei===-1){showErr('Missing columns. Found: <code>'+headers.join(', ')+'</code>');return;}
    if(headers.length!==2){showErr('Must have only 2 columns. Found '+headers.length+': <code>'+headers.join(', ')+'</code>');return;}
    var all=[],inv=[];
    for(var i=1;i<lines.length;i++){
      var cols=splitLine(lines[i]),rn=(cols[ni]||'').trim(),re=(cols[ei]||'').trim(),valid=true,err='';
      if(!rn){valid=false;err='Missing name';}
      else if(!re){valid=false;err='Missing email';}
      else if(!validFmt(re)){valid=false;err='Invalid email format';}
      else if(isDisposable(re)){valid=false;err='Disposable/temporary email';}
      else if(isInactive(re)){valid=false;err='Inactive / unknown domain';}
      all.push({num:i,name:rn,email:re,valid:valid,error:err});
      if(!valid)inv.push({num:i,name:rn,email:re,error:err});
    }
    if(inv.length&&typeof window.addInvalidToSupervision==='function')window.addInvalidToSupervision(inv,filename);
    renderPreview(all.filter(function(r){return r.valid;}),inv,all.length,filename);
  }
  function validFmt(e){return/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(e);}
  var DISP=['mailinator.com','guerrillamail.com','trashmail.com','tempmail.com','temp-mail.org','throwaway.email','yopmail.com','sharklasers.com','grr.la','spam4.me','maildrop.cc','10minutemail.com','fakeinbox.com','discard.email','mailnesia.com'];
  function isDisposable(e){var d=e.split('@')[1];return d?DISP.indexOf(d.toLowerCase())!==-1:false;}
  var STLDS=['.test','.invalid','.example','.localhost','.local','.fake'];
  var SPAT=[/^test@test\./i,/^noreply@/i,/^no-reply@/i,/^donotreply@/i,/^bounce@/i,/^mailer-daemon@/i,/^postmaster@/i];
  function isInactive(e){var l=e.toLowerCase(),d=l.split('@')[1]||'';for(var t=0;t<STLDS.length;t++)if(l.endsWith(STLDS[t]))return true;for(var p=0;p<SPAT.length;p++)if(SPAT[p].test(l))return true;var parts=d.split('.');if(parts.length<2)return true;var tld=parts[parts.length-1];if(tld.length<2||tld.length>6)return true;return false;}
  function renderPreview(valid,inv,total,filename){
    document.getElementById('statTotal').textContent=total+' rows scanned';
    document.getElementById('statValid').textContent=valid.length+' valid';
    document.getElementById('statInvalid').textContent=inv.length+' filtered';
    document.getElementById('statInvalid').style.display=inv.length?'':'none';
    if(inv.length){var rc={};inv.forEach(function(r){rc[r.error]=(rc[r.error]||0)+1;});var rl=Object.keys(rc).map(function(k){return'<strong>'+rc[k]+'</strong> &times; '+esc(k);}).join(' | ');var ee=document.getElementById('uploadErrors');ee.innerHTML='&#x1F6AB; <strong>'+inv.length+' row(s) filtered</strong> &mdash; sent to SupervisionList &mdash; '+rl;ee.style.display='';}else hideErr();
    var tb=document.getElementById('uploadPreviewBody');tb.innerHTML='';
    if(!valid.length){tb.innerHTML='<tr><td colspan="4" class="table-empty">No valid rows found.</td></tr>';}
    else{valid.slice(0,100).forEach(function(r){var tr=document.createElement('tr');tr.innerHTML='<td>'+r.num+'</td><td>'+esc(r.name)+'</td><td>'+esc(r.email)+'</td><td><span style="color:#4ade80;font-weight:600;">&#x2714; Valid</span></td>';tb.appendChild(tr);});if(valid.length>100){var tr=document.createElement('tr');tr.innerHTML='<td colspan="4" class="table-empty">&hellip; and '+(valid.length-100)+' more rows</td>';tb.appendChild(tr);}}
    document.getElementById('uploadPreview').style.display='';
    document.getElementById('uploadInitActions').style.display='none';
    document.getElementById('btnImport').disabled=!valid.length;
    window._uploadRows=valid;window._uploadFilename=filename;
  }
  window.submitUpload=function(){if(!window._uploadRows||!window._uploadRows.length)return;var form=document.createElement('form');form.method='POST';form.action='CompanyUploadRecipients';function addH(n,v){var i=document.createElement('input');i.type='hidden';i.name=n;i.value=v;form.appendChild(i);}addH('companyId','<%= compId %>');addH('filename',window._uploadFilename||'upload.csv');addH('recipients',JSON.stringify(window._uploadRows.map(function(r){return{name:r.name,email:r.email};})));document.body.appendChild(form);form.submit();};
  window.resetUpload=function(){document.getElementById('csvFileInput').value='';document.getElementById('uploadPreview').style.display='none';document.getElementById('uploadInitActions').style.display='';document.getElementById('uploadFilename').style.display='none';document.getElementById('uploadErrors').style.display='none';document.getElementById('uploadPreviewBody').innerHTML='';window._uploadRows=[];};
  window.downloadTemplate=function(){var a=document.createElement('a');a.href=URL.createObjectURL(new Blob(['name,email\nJohn Doe,john.doe@example.com\nJane Smith,jane.smith@example.com\n'],{type:'text/csv'}));a.download='netclix_recipient_template.csv';a.click();URL.revokeObjectURL(a.href);};
  window.exportValidCSV=function(){if(!window._uploadRows||!window._uploadRows.length){alert('No valid rows.');return;}var csv='name,email\n';window._uploadRows.forEach(function(r){csv+='"'+(r.name||'').replace(/"/g,'""')+'","'+(r.email||'').replace(/"/g,'""')+'"\n';});var a=document.createElement('a');a.href=URL.createObjectURL(new Blob([csv],{type:'text/csv'}));a.download='valid_emails.csv';a.click();URL.revokeObjectURL(a.href);};
  function showErr(msg){var el=document.getElementById('uploadErrors');el.innerHTML='&#x274C; '+msg;el.style.display='';}
  function hideErr(){document.getElementById('uploadErrors').style.display='none';}
  function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');}
  function splitLine(line){var r=[],c='',q=false;for(var i=0;i<line.length;i++){var ch=line[i];if(ch==='"'){q=!q;}else if(ch===','&&!q){r.push(c);c='';}else{c+=ch;}}r.push(c);return r;}
})();
</script>

<!-- ════ COMPOSE LIVE PREVIEW ════ -->
<script>
(function(){
  function syncCompose(){
    var se=document.getElementById('composeSubject'),be=document.getElementById('emailBody');
    var ps=document.getElementById('previewSubject'),pb=document.getElementById('previewBody');
    if(ps)ps.textContent=(se&&se.value)?se.value:'Subject will appear here';
    if(pb){var raw=be?be.value:'';pb.innerHTML=raw?(/<[a-z][\s\S]*>/i.test(raw)?raw:raw.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\n/g,'<br>')):'<span style="opacity:.35">Email body preview&hellip;</span>';}
  }
  var si=document.getElementById('composeSubject'),bi=document.getElementById('emailBody');
  if(si)si.addEventListener('input',syncCompose);
  if(bi)bi.addEventListener('input',syncCompose);

  window.previewEmail=functismooth',block:'start'});
    p.style.transition='box-shadow .25s';p.style.boxShadow='0 0 0 3px #6366f1';
    setTimeout(function(){p.style.boxShadow='';},900);
  };
  window.fmt=function(cmd){
    var ta=document.getElementById('emailBody');if(!ta)return;
    var s=tunderline:['<u>','</u>']};
    var t=tags[cmd];if(!t)return;
    ta.value=ta.value.substring(0,s)+t[0]+sel+t[1]+ta.value.substring(e);
    ta.selectionStart=s+t[0].length;ta.selectionEnd=e+t[0].length;
    ta.focus();syncCompose();
  };
  window.insertTag=function(tag){
    var ta=document.getElementById('emailBody');if(!ta)return;
    var pos=ta.selectionStart;ta.value=ta.value.substring(0,pos)+tag+ta.value.substring(pos);
    ta.selectionStart=ta.selectionEnd=pos+tag.length;ta.focus();syncCompose();
  };
  window.loadTemplate=function(key){
    var ta=document.getElementById('emailBody'),subj=document.getElementById('composeSubject');
    if(!ta||!key)return;
    var cn=window.COMP_NAME||'Our Company';
    var tpls={
      job:{subject:'Exciting Job Opening at '+cn,body:'Dear [CANDIDATE_NAME],\n\nWe have an exciting new opportunity that matches your profile!\n\nPosition: [JOB_TITLE]\nLocation: [LOCATION]\nSalary: [SALARY_RANGE]\n\nIf you\'re interested, please reply to this email.\n\nBest regards,\n'+cn+'\n\n[UNSUBSCRIBE_LINK]'},
      followup:{subject:'Following Up on Your Application \u2014 '+cn,body:'Dear [CANDIDATE_NAME],\n\nThank you for applying. Your application is currently under review.\n\nWe will be in touch shortly.\n\nKind regards,\n'+cn+'\n\n[UNSUBSCRIBE_LINK]'}
    };
    var t=tpls[key];if(!t)return;
    if(subj)subj.value=t.subject;
    ta.value=t.body;syncCompose();
  };
})();
</script>

<!-- ════ TEMPLATE PANEL LIVE PREVIEW ════ -->
<script>
(function(){
  function syncTpl(){
    var se=document.getElementById('tplSubject'),be=document.getElementById('tplBody');
    var ps=document.getElementById('tplPreviewSubject'),pb=document.getElementById('tplPreviewBody');
    if(ps)ps.textContent=(se&&se.value)?se.value:'Subject will appear here';
    if(pb){var raw=be?be.value:'';pb.innerHTML=raw?(/<[a-z][\s\S]*>/i.test(raw)?raw:raw.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\n/g,'<br>')):'<span style="opacity:.35">Template body preview&hellip;</span>';}
  }
  var si=document.getElementById('tplSubject'),bi=document.getElementById('tplBody');
  if(si)si.addEventListener('input',syncTpl);
  if(bi)bi.addEventListener('input',syncTpl);

  window.previewTemplate=function(){
    syncTpl();
    var p=document.getElementById('tplPreviewPane');if(!p)return;
    p.scrollIntoView({behavior:'smooth',block:'start'});
    p.style.transition='box-shadow .25s';p.style.boxShadow='0 0 0 3px #6366f1';
    setTimeout(function(){p.style.boxShadow='';},900);
  };
  window.tplFmt=function(cmd){
    var ta=document.getElementById('tplBody');if(!ta)return;
    var s=ta.selectionStart,e=ta.selectionEnd,sel=ta.value.substring(s,e);
    var tags={bold:['<b>','</b>'],italic:['<i>','</i>'],underline:['<u>','</u>']};
    var t=tags[cmd];if(!t)return;
    ta.value=ta.value.substring(0,s)+t[0]+sel+t[1]+ta.value.substring(e);
    ta.selectionStart=s+t[0].length;ta.selectionEnd=e+t[0].length;
    ta.focus();syncTpl();
  };
  window.tplInsertTag=function(tag){
    var ta=document.getElementById('tplBody');if(!ta)return;
    var pos=ta.selectionStart;ta.value=ta.value.substring(0,pos)+tag+ta.value.substring(pos);
    ta.selectionStart=ta.selectionEnd=pos+tag.length;ta.focus();syncTpl();
  };
})();
</script>

<!-- ════ MESSAGES PANEL ════ -->
<script>
(function(){
  var SK='netclix_messages_<%= compId %>',PAGE_SIZE=20,_page=1,_filtered=[];
  function load(){try{return JSON.parse(sessionStorage.getItem(SK)||'[]');}catch(e){return[];}}
  function save(r){try{sessionStorage.setItem(SK,JSON.stringify(r));}catch(e){}}
  function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');}
  function set(id,v){var el=document.getElementById(id);if(el)el.textContent=v;}

  window.addSentMessages=function(records){
    var all=load();
    records.forEach(function(r){all.push({id:Date.now()+Math.random(),name:r.name||'',email:r.email||'',campaign:r.campaign||'General',sentAt:r.sentAt||new Date().toLocaleString(),status:r.status||'delivered',openedAt:r.openedAt||''});});
    save(all);refresh();updateBadge();
  };
  setInterval(function(){var all=load(),changed=false;all.forEach(function(r){if(r.status==='delivered'&&Math.random()<0.012){r.status='opened';r.openedAt=new Date().toLocaleString();changed=true;}});if(changed){save(all);refresh();updateBadge();}},5000);

  function refresh(){var all=load();updateStats(all);populateCampaignFilter(all);applyFilters(all);buildBreakdown(all);updateBadge();}
  function updateStats(all){var total=all.length,del=all.filter(function(r){return r.status==='delivered'||r.status==='opened';}).length,op=all.filter(function(r){return r.status==='opened';}).length,fail=all.filter(function(r){return r.status==='failed'||r.status==='bounced';}).length;set('msg-total',total.toLocaleString());set('msg-delivered',del.toLocaleString());set('msg-opened',op.toLocaleString());set('msg-failed',fail.toLocaleString());}
  function populateCampaignFilter(all){var sel=document.getElementById('msgCampaignFilter');if(!sel)return;var cur=sel.value,camps={};all.forEach(function(r){camps[r.campaign]=1;});sel.innerHTML='<option value="">All Campaigns</option>';Object.keys(camps).forEach(function(c){var o=document.createElement('option');o.value=c;o.textContent=c;if(c===cur)o.selected=true;sel.appendChild(o);});}
  window.filterMessages=function(){applyFilters(load());};
  function applyFilters(all){var q=(document.getElementById('msgSearchInput')?document.getElementById('msgSearchInput').value:'').toLowerCase(),st=document.getElementById('msgStatusFilter')?document.getElementById('msgStatusFilter').value:'',cp=document.getElementById('msgCampaignFilter')?document.getElementById('msgCampaignFilter').value:'';_filtered=all.filter(function(r){return(!q||(r.name||'').toLowerCase().includes(q)||(r.email||'').toLowerCase().includes(q)||(r.campaign||'').toLowerCase().includes(q))&&(!st||r.status===st)&&(!cp||r.campaign===cp);});_page=1;renderPage();}
  function renderPage(){
    var tb=document.getElementById('messagesBody');if(!tb)return;
    var total=_filtered.length,pages=Math.max(1,Math.ceil(total/PAGE_SIZE));
    if(_page>pages)_page=pages;
    var start=(_page-1)*PAGE_SIZE,slice=_filtered.slice(start,start+PAGE_SIZE);
    var infoEl=document.getElementById('msgPaginationInfo');if(infoEl)infoEl.textContent=total===0?'No records found':'Showing '+(start+1)+'–'+Math.min(start+PAGE_SIZE,total)+' of '+total+' records';
    var btnsEl=document.getElementById('msgPaginationBtns');
    if(btnsEl){btnsEl.innerHTML='';if(pages>1){var mk=function(label,pg,dis,active){var b=document.createElement('button');b.className='btn btn-ghost btn-sm'+(active?' btn-primary':'');b.textContent=label;b.disabled=dis;if(!dis)b.onclick=function(){_page=pg;renderPage();};btnsEl.appendChild(b);};mk('‹',_page-1,_page===1,false);for(var p=1;p<=pages;p++){if(pages<=7||p===1||p===pages||Math.abs(p-_page)<=1){mk(p,p,false,p===_page);}else if(Math.abs(p-_page)===2){var sp=document.createElement('span');sp.textContent='…';sp.style.cssText='padding:0 6px;opacity:.4;line-height:2;';btnsEl.appendChild(sp);}}mk('›',_page+1,_page===pages,false);}}
    if(!slice.length){tb.innerHTML='<tr><td colspan="7" class="table-empty">No records match.</td></tr>';return;}
    tb.innerHTML='';
    slice.forEach(function(r,i){var tr=document.createElement('tr');tr.innerHTML='<td style="opacity:.55;">'+(start+i+1)+'</td><td style="font-weight:500;">'+esc(r.name||'—')+'</td><td style="font-size:.85rem;">'+esc(r.email||'—')+'</td><td><span style="font-size:.8rem;padding:3px 10px;border-radius:99px;background:rgba(99,102,241,.12);color:#818cf8;font-weight:600;">'+esc(r.campaign)+'</span></td><td style="font-size:.8rem;opacity:.65;">'+esc(r.sentAt)+'</td><td>'+statusBadge(r.status)+'</td><td>'+(r.openedAt?'<span style="font-size:.78rem;opacity:.7;">'+esc(r.openedAt)+'</span>':'<span style="opacity:.3;font-size:.8rem;">—</span>')+'</td>';tb.appendChild(tr);});
  }
  function statusBadge(s){var m={delivered:{label:'&#x2705; Delivered',bg:'rgba(34,197,94,.13)',c:'#4ade80'},opened:{label:'&#x1F441;&#xFE0F; Opened',bg:'rgba(245,158,11,.13)',c:'#fbbf24'},pending:{label:'&#x1F550; Pending',bg:'rgba(99,102,241,.13)',c:'#818cf8'},failed:{label:'&#x274C; Not Delivered',bg:'rgba(239,68,68,.13)',c:'#f87171'},bounced:{label:'&#x26A0;&#xFE0F; Bounced',bg:'rgba(239,68,68,.10)',c:'#fca5a5'}};var x=m[s]||{label:s,bg:'rgba(100,116,139,.13)',c:'#94a3b8'};return'<span style="font-size:.75rem;font-weight:600;padding:4px 11px;border-radius:99px;background:'+x.bg+';color:'+x.c+';">'+x.label+'</span>';}
  function buildBreakdown(all){var tb=document.getElementById('msgCampaignBody');if(!tb)return;var camps={};all.forEach(function(r){if(!camps[r.campaign])camps[r.campaign]={total:0,delivered:0,opened:0,failed:0};var d=camps[r.campaign];d.total++;if(r.status==='delivered'||r.status==='opened')d.delivered++;if(r.status==='opened')d.opened++;if(r.status==='failed'||r.status==='bounced')d.failed++;});var keys=Object.keys(camps);if(!keys.length){tb.innerHTML='<tr><td colspan="7" class="table-empty">No data yet.</td></tr>';return;}tb.innerHTML='';keys.forEach(function(c){var d=camps[c],or=d.delivered>0?((d.opened/d.delivered)*100).toFixed(1):'0.0',dr=d.total>0?((d.delivered/d.total)*100).toFixed(1):'0.0';var tr=document.createElement('tr');tr.innerHTML='<td style="font-weight:600;">'+esc(c)+'</td><td>'+d.total.toLocaleString()+'</td><td><span style="color:#4ade80;">'+d.delivered.toLocaleString()+'</span></td><td><span style="color:#fbbf24;">'+d.opened.toLocaleString()+'</span></td><td><span style="color:#f87171;">'+d.failed.toLocaleString()+'</span></td><td>'+rb(or,'#fbbf24')+'</td><td>'+rb(dr,'#4ade80')+'</td>';tb.appendChild(tr);});}
  function rb(pct,color){return'<div style="display:flex;align-items:center;gap:8px;"><div style="flex:1;height:6px;border-radius:99px;background:rgba(255,255,255,.07);"><div style="width:'+pct+'%;height:100%;border-radius:99px;background:'+color+';"></div></div><span style="font-size:.78rem;font-weight:600;color:'+color+';min-width:38px;">'+pct+'%</span></div>';}
  window.exportMessagesCSV=function(){var r=_filtered.length?_filtered:load();if(!r.length){alert('No records.');return;}var csv='#,Name,Email,Campaign,Sent At,Status,Opened At\n';r.forEach(function(x,i){csv+=[i+1,'"'+(x.name||'')+'"','"'+(x.email||'')+'"','"'+(x.campaign||'')+'"','"'+(x.sentAt||'')+'"','"'+(x.status||'')+'"','"'+(x.openedAt||'')+'"'].join(',')+'\n';});var a=document.createElement('a');a.href=URL.createObjectURL(new Blob([csv],{type:'text/csv'}));a.download='netclix_messages.csv';a.click();URL.revokeObjectURL(a.href);};
  function updateBadge(){var b=document.getElementById('messagesBadge'),n=load().length;if(!b)return;if(n>0){b.textContent=n>999?'999+':n;b.style.display='';}else b.style.display='none';}
  window.addDemoMessages=function(){var names=['Rahul Sharma','Priya Singh','Amit Kumar','Sneha Patel','Rohit Verma','Ananya Gupta','Vikram Nair','Pooja Joshi','Karan Mehta','Riya Agarwal','Siddharth Roy','Tanvi Desai','Arjun Malhotra','Kavya Reddy','Nikhil Bose','Ishaan Kapoor','Disha Chauhan','Yash Pandey','Meera Iyer','Aditya Saxena'];var domains=['gmail.com','yahoo.com','outlook.com','rediffmail.com','protonmail.com'];var camps=['Job Opening \u2014 May 2026','Interview Invite \u2014 Batch 3','Offer Letter Dispatch','Follow-up Round 2'];var statuses=['delivered','delivered','delivered','opened','opened','pending','failed','bounced'];var records=[],now=Date.now();names.forEach(function(name){var d=domains[Math.floor(Math.random()*domains.length)],cp=camps[Math.floor(Math.random()*camps.length)],st=statuses[Math.floor(Math.random()*statuses.length)],sd=new Date(now-Math.random()*7*86400000),oa=st==='opened'?new Date(sd.getTime()+Math.random()*14400000).toLocaleString():'';records.push({name:name,email:name.toLowerCase().replace(/\s+/g,'.')+'@'+d,campaign:cp,sentAt:sd.toLocaleString(),status:st,openedAt:oa});});window.addSentMessages(records);alert('Demo data added \u2014 '+records.length+' sample records loaded.');};
  refresh();updateBadge();
})();

function toggleRecipients(type){

document.getElementById("customEmailsGroup").style.display="none";
document.getElementById("uploadedListGroup").style.display="none";

if(type==="custom"){
document.getElementById("customEmailsGroup").style.display="block";
}

if(type==="uploaded"){
document.getElementById("uploadedListGroup").style.display="block";
}

}

function loadTemplate(select){

let option = select.options[select.selectedIndex];

let subject = option.getAttribute("data-subject");
let body = option.getAttribute("data-body");

if(subject){
document.getElementById("composeSubject").value = subject;
}

if(body){
document.getElementById("emailBody").value = body;
}

}
</script>

<!-- ════ PORTAL JS (panel switcher, clock, charts) ════ -->
<script src="js/company-portal.js"></script>
</body>
</html>
