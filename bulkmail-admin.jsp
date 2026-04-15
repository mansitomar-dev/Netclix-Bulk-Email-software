<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.iardo.bulkmail.model.Admin" %>
<%@ page import="com.iardo.bulkmail.servlet.LoginServlet" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList" %>
<%@ page import="com.iardo.bulkmail.model.Template" %>

<%!
  private String jsonEsc(String s) {
    if (s == null) return "\"\"";
    return "\"" + s
        .replace("\\", "\\\\")
        .replace("\"", "\\\"")
        .replace("\r", "\\r")
        .replace("\n", "\\n")
        .replace("'",  "\\'")
        + "\"";
  }
%>

<%
    HttpSession adminSession = request.getSession(false);
    Admin loggedInAdmin = null;
    if (adminSession != null) {
        loggedInAdmin = (Admin) adminSession.getAttribute(LoginServlet.SESSION_ADMIN);
    }
    if (loggedInAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String adminFullName = loggedInAdmin.getFullName();
    String adminRole     = loggedInAdmin.getRole();
    String adminEmail    = loggedInAdmin.getEmail();
    String adminInitial  = (adminFullName != null && !adminFullName.isEmpty())
                           ? String.valueOf(adminFullName.charAt(0)).toUpperCase() : "A";

    String successMsg  = request.getParameter("msg");
    String errorMsg    = request.getParameter("error");
    String activePanel = request.getParameter("panel");
    if (activePanel == null || activePanel.isEmpty()) activePanel = "dashboard";

    List<Map<String, String>> candidates =
        (List<Map<String, String>>) request.getAttribute("candidates");
    if (candidates == null) candidates = new ArrayList<>();

    List<Map<String, String>> companies =
        (List<Map<String, String>>) request.getAttribute("companies");
    if (companies == null) companies = new ArrayList<>();
%>




<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Bulk Mail Admin &mdash; NETCLIXCLOUD</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/bulkmail-admin.css" />
<style>
  .admin-profile {
    display: flex; align-items: center; gap: 10px;
    padding: 5px 12px 5px 5px; border-radius: 40px;
    background: var(--surface2); border: 1px solid var(--border);
    cursor: pointer; transition: background 0.2s, box-shadow 0.2s;
    position: relative; user-select: none;
  }
  .admin-profile:hover { background: var(--surface); box-shadow: 0 2px 12px rgba(201,151,58,0.12); }
  .admin-avatar {
    width: 32px; height: 32px; border-radius: 50%;
    background: linear-gradient(135deg, #c9973a, #e8c14a);
    display: flex; align-items: center; justify-content: center;
    font-family: 'Bebas Neue', sans-serif; font-size: 15px; color: #1a2232; flex-shrink: 0;
  }
  .admin-info { line-height: 1.3; }
  .admin-name  { font-size: 13px; font-weight: 600; color: var(--text); white-space: nowrap; }
  .admin-role  { font-size: 11px; color: var(--muted); text-transform: capitalize; }
  .chevron-icon { width: 13px; height: 13px; color: var(--muted); margin-left: 2px; flex-shrink: 0; }
  .admin-dropdown {
    display: none; position: absolute; top: calc(100% + 8px); right: 0;
    background: var(--surface); border: 1px solid var(--border);
    border-radius: 12px; box-shadow: 0 8px 32px rgba(26,34,50,0.13);
    min-width: 210px; z-index: 999; overflow: hidden; animation: ddDown 0.16s ease;
  }
  @keyframes ddDown { from{opacity:0;transform:translateY(-6px)} to{opacity:1;transform:translateY(0)} }
  .admin-dropdown.open { display: block; }
  .dd-header { padding: 14px 16px 10px; border-bottom: 1px solid var(--border); }
  .dd-header-name  { font-weight: 600; font-size: 14px; color: var(--text); }
  .dd-header-email { font-size: 11px; color: var(--muted); margin-top: 2px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .dd-item {
    display: flex; align-items: center; gap: 10px;
    padding: 10px 16px; font-size: 13px; color: var(--text);
    cursor: pointer; transition: background 0.15s; text-decoration: none;
  }
  .dd-item:hover { background: var(--surface2); }
  .dd-item svg { width: 15px; height: 15px; color: var(--muted); flex-shrink: 0; }
  .dd-item.danger { color: #dc2626; }
  .dd-item.danger svg { color: #dc2626; }
  .dd-divider { border: none; border-top: 1px solid var(--border); margin: 4px 0; }

  .alert {
    display: flex; align-items: flex-start; gap: 12px;
    padding: 14px 18px; border-radius: 10px;
    font-size: 14px; font-weight: 500; margin-bottom: 20px;
    border: 1px solid transparent;
  }
  .alert-success { background: #d1fae5; color: #065f46; border-color: #6ee7b7; }
  .alert-error   { background: #fee2e2; color: #991b1b; border-color: #fca5a5; }
  .alert-icon    { font-size: 18px; flex-shrink: 0; margin-top: 1px; }
  .alert-close   {
    margin-left: auto; cursor: pointer; font-size: 16px; opacity: 0.6;
    background: none; border: none; color: inherit; padding: 0 0 0 12px; flex-shrink: 0;
  }
  .alert-close:hover { opacity: 1; }
</style>
</head>
<body>

<nav class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="brand-icon">
      <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" fill="none" stroke="#fff" stroke-width="2"/><polyline points="22,6 12,13 2,6" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round"/></svg>
    </div>
    <div><div class="brand-name">NETCLIXCLOUD</div><div class="brand-sub">BulkMail Admin</div></div>
  </div>

  <div class="sidebar-section-label">MAIN</div>
  <div class="nav-item active" onclick="showPanel('dashboard')" data-panel="dashboard">
    <span class="nav-icon"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="14" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="3" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="14" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/></svg></span>Dashboard
  </div>
  <div class="nav-item" onclick="showPanel('compose')" data-panel="compose">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></span>Compose Mail
  </div>
  <div class="nav-item" onclick="showPanel('templates')" data-panel="templates">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 21V9"/></svg></span>Templates
  </div>
  <div class="nav-item" onclick="showPanel('schedule')" data-panel="schedule">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></span>Scheduled Mails <span class="badge">3</span>
  </div>
  <div class="nav-item" onclick="showPanel('logs')" data-panel="logs">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><circle cx="3" cy="6" r="1" fill="currentColor"/><circle cx="3" cy="12" r="1" fill="currentColor"/><circle cx="3" cy="18" r="1" fill="currentColor"/></svg></span>Send Logs
  </div>

  <div class="sidebar-section-label" style="margin-top:18px;">RECIPIENTS</div>

  <div class="nav-item" onclick="showPanel('companies')" data-panel="companies">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg></span>Companies
  </div>
  <div class="nav-item" onclick="showPanel('unsubscribe')" data-panel="unsubscribe">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg></span>Unsubscribed
  </div>
  <div class="nav-item" onclick="showPanel('groups')" data-panel="groups">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg></span>Groups / Lists
  </div>

  <div class="sidebar-section-label" style="margin-top:18px;">ACCOUNT</div>
  <div class="nav-item" onclick="location.href='settings.jsp'">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg></span>SMTP Settings
  </div>
  <div class="nav-item nav-danger" onclick="location.href='<%= request.getContextPath() %>/logout'">
    <span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg></span>Logout
  </div>
  <div class="sidebar-footer">&copy; 2026 NETCLIXCLOUD BulkMail</div>
</nav>

<div class="overlay" id="overlay" onclick="toggleSidebar()"></div>

<div class="main" id="main">

  <header class="topbar">
    <div class="topbar-left">
      <button class="hamburger" onclick="toggleSidebar()">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" width="22" height="22">
          <line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/>
        </svg>
      </button>
      <div>
        <div class="topbar-title" id="topbar-title">Dashboard</div>
        <div class="topbar-breadcrumb">NETCLIXCLOUD / Bulk Mail / <span id="topbar-section">Overview</span></div>
      </div>
    </div>
    <div class="topbar-right">
      <div class="topbar-time" id="live-time"></div>
      <button class="btn btn-primary" onclick="showPanel('compose')">+ New Campaign</button>
      <div class="admin-profile" id="adminProfileBtn" onclick="toggleAdminDropdown()">
        <div class="admin-avatar"><%= adminInitial %></div>
        <div class="admin-info">
          <div class="admin-name"><%= adminFullName %></div>
          <div class="admin-role"><%= adminRole %></div>
        </div>
        <svg class="chevron-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="6 9 12 15 18 9"/></svg>
        <div class="admin-dropdown" id="adminDropdown">
          <div class="dd-header">
            <div class="dd-header-name"><%= adminFullName %></div>
            <div class="dd-header-email"><%= adminEmail %></div>
          </div>
          <a class="dd-item" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>My Profile</a>
          <a class="dd-item" href="settings.jsp"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>Settings</a>
          <hr class="dd-divider"/>
          <a class="dd-item danger" href="<%= request.getContextPath() %>/logout"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>Logout</a>
        </div>
      </div>
    </div>
  </header>

  <!-- ══════════════════ DASHBOARD PANEL ══════════════════ -->
  <section class="panel active" id="panel-dashboard">
    <div class="section-header">
      <div class="section-title">Campaign Overview</div>
      <div class="section-subtitle">Welcome back, <strong><%= adminFullName %></strong> &mdash; here are your NETCLIXCLOUD bulk mail stats</div>
    </div>
    <div class="stats-grid">
      <div class="stat-card stat-blue"><div class="stat-icon stat-icon-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg></div><div class="stat-value"><%= companies.size() %></div><div class="stat-label">Total Companies</div><div class="stat-change">Registered employers</div></div>
      <div class="stat-card stat-green"><div class="stat-icon stat-icon-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg></div><div class="stat-value">1,240</div><div class="stat-label">Emails Sent Today</div><div class="stat-change">Since midnight</div></div>
      <div class="stat-card stat-red"><div class="stat-icon stat-icon-red"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div><div class="stat-value">37</div><div class="stat-label">Total Bounces</div><div class="stat-change">All time</div></div>
      <div class="stat-card stat-orange"><div class="stat-icon stat-icon-orange"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><div class="stat-value">3</div><div class="stat-label">Scheduled Pending</div><div class="stat-change">Queued campaigns</div></div>
    </div>
    <div class="card mt-24">
      <div class="card-header"><div class="card-title">Recent Campaigns</div><button class="btn btn-ghost btn-sm" onclick="showPanel('logs')">View All &rarr;</button></div>
      <div class="table-wrap">
        <table class="table">
          <thead><tr><th>Campaign</th><th>Recipients</th><th>Sent</th><th>Bounced</th><th>Date</th><th>Status</th></tr></thead>
          <tbody>
            <tr><td><strong>June Job Alerts</strong></td><td>3,812</td><td>3,775</td><td><span class="pill pill-red">12</span></td><td class="muted">2025-06-10 09:00</td><td><span class="pill pill-green">completed</span></td></tr>
            <tr><td><strong>Payment Reminder</strong></td><td>540</td><td>538</td><td><span class="pill pill-red">2</span></td><td class="muted">2025-06-08 11:30</td><td><span class="pill pill-green">completed</span></td></tr>
            <tr><td><strong>Welcome New Users</strong></td><td>210</td><td>206</td><td><span class="pill pill-red">4</span></td><td class="muted">2025-06-05 08:00</td><td><span class="pill pill-green">completed</span></td></tr>
            <tr><td><strong>Company Newsletter</strong></td><td>48</td><td>0</td><td><span class="pill pill-red">0</span></td><td class="muted">2025-06-12 10:00</td><td><span class="pill pill-orange">sending</span></td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <!-- ══════════════════ COMPOSE PANEL ════════════════════ -->
  <section class="panel" id="panel-compose">
    <div class="section-header"><div class="section-title">Compose Bulk Mail</div><div class="section-subtitle">Send emails to selected groups or all users</div></div>
    <div class="compose-layout">
      <div class="compose-form card">
        <form method="post" action="SendBulkMail" id="composeForm">
          <div class="form-row">
            <div class="form-group"><label>Campaign Name</label><input type="text" name="campaignName" class="form-control" placeholder="e.g. June Job Alerts" required /></div>
            <div class="form-group"><label>From Name</label><input type="text" name="fromName" class="form-control" value="NETCLIX Team" /></div>
          </div>
          <div class="form-row">
            <div class="form-group"><label>Reply-To Email</label><input type="email" name="replyTo" class="form-control" placeholder="info@netclixcloud.com" /></div>
            <div class="form-group"><label>Send To</label>
              <select name="recipientGroup" class="form-control" onchange="updateCount(this.value)">
                <option value="all_candidates">All Candidates (<%= candidates.size() %>)</option>
                <option value="pending_payment">Pending Payment Candidates</option>
                <option value="all_companies">All Companies (<%= companies.size() %>)</option>
                <option value="custom">Custom List (paste emails)</option>
              </select>
            </div>
          </div>
          <div class="form-group" id="customEmailsGroup" style="display:none;"><label>Custom Email List</label><textarea name="customEmails" class="form-control" rows="4" placeholder="user1@example.com&#10;user2@example.com"></textarea></div>
          <div class="form-group"><label>Subject Line</label><input type="text" name="subject" class="form-control" placeholder="Your email subject here..." required /></div>
          <div class="form-row" style="align-items:flex-start;">
            <div class="form-group" style="flex:1;"><label>Load Template</label>
              <select class="form-control" onchange="loadTemplateById(this.value)">
                <option value="">&#x2014; Choose a template &#x2014;</option>
                <option value="1">Monthly Job Alert</option><option value="2">Payment Reminder</option><option value="3">Welcome Email</option>
              </select>
            </div>
            <div class="form-group" style="flex:0;min-width:200px;"><label>Schedule For (optional)</label><input type="datetime-local" name="scheduledAt" class="form-control" /></div>
          </div>
          <div class="form-group">
            <label>Email Body (HTML supported)</label>
            <div class="editor-toolbar">
              <button type="button" onclick="formatText('bold')"><b>B</b></button>
              <button type="button" onclick="formatText('italic')"><i>I</i></button>
              <button type="button" onclick="formatText('underline')"><u>U</u></button>
              <button type="button" onclick="insertLink()">Link</button>
              <button type="button" onclick="insertTag('[NAME]')">[Name]</button>
              <button type="button" onclick="insertTag('[UNSUBSCRIBE_LINK]')">[Unsub]</button>
            </div>
            <textarea name="body" id="emailBody" class="form-control editor" rows="14" placeholder="Write your email content here..." required></textarea>
          </div>
          <div class="form-group"><label>Attachments</label><input type="file" name="attachment" class="form-control" multiple accept=".pdf,.docx,.jpg,.png" /><div class="form-hint">Max 5MB per file. Accepted: PDF, DOCX, JPG, PNG</div></div>
          <div class="form-actions">
            <button type="button" class="btn btn-ghost" onclick="previewEmail()">Preview</button>
            <button type="submit" name="action" value="schedule" class="btn btn-secondary">Schedule</button>
            <button type="submit" name="action" value="send" class="btn btn-primary" onclick="return confirm('Send to all selected recipients now?')">Send Now</button>
          </div>
        </form>
      </div>
      <div class="compose-preview card" id="previewPane">
        <div class="card-title" style="padding:14px 18px;border-bottom:1px solid var(--border);margin-bottom:0;">Live Preview</div>
        <div style="padding:14px;"><div class="preview-device"><div class="preview-subject" id="previewSubject">Subject will appear here</div><div class="preview-body" id="previewBody">Email body preview...</div></div></div>
      </div>
    </div>
  </section>

  <!-- ══════════════════ TEMPLATES PANEL ══════════════════ -->
  <section class="panel" id="panel-templates">
  <div class="section-header">
    <div class="section-title">Email Templates</div>
    <div class="section-subtitle">Save and reuse email templates for campaigns</div>
  </div>

  <%-- Alerts --%>
  <%
    String tplMsg = request.getParameter("msg");
    String tplErr = request.getParameter("error");
  %>
  <% if ("templates".equals(activePanel) && tplMsg != null && !tplMsg.isEmpty()) { %>
  <div class="alert alert-success" id="tplSuccessAlert">
    <span class="alert-icon">&#10003;</span><%= tplMsg %>
    <button class="alert-close" onclick="document.getElementById('tplSuccessAlert').style.display='none'">&#x2715;</button>
  </div>
  <% } %>
  <% if ("templates".equals(activePanel) && tplErr != null && !tplErr.isEmpty()) { %>
  <div class="alert alert-error" id="tplErrorAlert">
    <span class="alert-icon">&#9888;</span><%= tplErr %>
    <button class="alert-close" onclick="document.getElementById('tplErrorAlert').style.display='none'">&#x2715;</button>
  </div>
  <% } %>

  <%-- Save / Edit Form --%>
  <div class="card" style="margin-bottom:24px;">
    <div class="card-header">
      <div class="card-title" id="tplFormTitle">Save New Template</div>
    </div>
    <form method="post" action="<%= request.getContextPath() %>/templates" style="padding:16px 18px;" id="tplForm">
      <input type="hidden" name="action" id="tplAction" value="save" />
      <input type="hidden" name="id"     id="tplEditId" value="" />

      <div class="form-row">
        <div class="form-group" style="flex:2;">
          <label>Template Name <span class="required">*</span></label>
          <input type="text" name="name" id="tplName" class="form-control"
                 placeholder="e.g. Monthly Job Alert" required />
        </div>
        <div class="form-group" style="flex:3;">
          <label>Subject <span class="required">*</span></label>
          <input type="text" name="subject" id="tplSubject" class="form-control"
                 placeholder="Email subject..." required />
        </div>
      </div>
      <div class="form-group">
        <label>Body (HTML allowed) <span class="required">*</span></label>
        <textarea name="body" id="tplBody" class="form-control" rows="7"
                  placeholder="Template body..." required></textarea>
      </div>
      <div class="form-actions">
        <button type="button" class="btn btn-ghost" onclick="resetTplForm()">Cancel / Clear</button>
        <button type="submit" class="btn btn-primary" id="tplSubmitBtn">Save Template</button>
      </div>
    </form>
  </div>

  <%-- Saved Templates Table --%>
  <div class="card">
    <div class="card-header">
      <div class="card-title">Saved Templates</div>
      <input type="text" class="form-control" style="max-width:260px;"
             placeholder="Search templates..."
             oninput="filterTable('templatesTable', this.value)">
    </div>
    <div class="table-wrap">
      <table class="table" id="templatesTable">
        <thead>
          <tr><th>ID</th><th>Name</th><th>Subject</th><th>Created</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <%
            List<Template> templates = (List<Template>) request.getAttribute("templates");
            if (templates == null) { templates = new java.util.ArrayList<Template>(); }
          %>
          <% if (templates.isEmpty()) { %>
          <tr>
            <td colspan="5" style="text-align:center;padding:40px;color:var(--muted);">
              No templates yet. Use the form above to create one.
            </td>
          </tr>
          <% } else { %>
          <% for (Template tpl : templates) { %>
          <%
            String tplCreatedStr = "-";
            if (tpl.getCreatedAt() != null) {
              tplCreatedStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(tpl.getCreatedAt());
            }
          %>
          <tr>
            <td><%= tpl.getId() %></td>
            <td><strong><%= tpl.getName() %></strong></td>
            <td class="muted"><%= tpl.getSubject() %></td>
            <td class="muted"><%= tplCreatedStr %></td>
            <td style="white-space:nowrap;">
              <%-- Use in Compose --%>
              <button class="btn btn-ghost btn-sm"
                onclick="useTemplate(<%= tpl.getId() %>, <%= jsonEsc(tpl.getSubject()) %>, <%= jsonEsc(tpl.getBody()) %>)">Use</button>
              <%-- Edit --%>
              <button class="btn btn-ghost btn-sm"
                onclick="editTemplate(<%= tpl.getId() %>, <%= jsonEsc(tpl.getName()) %>, <%= jsonEsc(tpl.getSubject()) %>, <%= jsonEsc(tpl.getBody()) %>)">Edit</button>
              <%-- Delete --%>
              <form method="post" action="<%= request.getContextPath() %>/templates"
                    style="display:inline;"
                    onsubmit="return confirm('Delete this template?')">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="id"     value="<%= tpl.getId() %>" />
                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
              </form>
            </td>
          </tr>
          <% } %>
          <% } %>
        </tbody>
      </table>
    </div>
    <div style="padding:10px 18px;border-top:1px solid var(--border);font-size:13px;color:var(--muted);">
      Total: <strong><%= templates.size() %></strong>
      template<%= templates.size() != 1 ? "s" : "" %>
    </div>
  </div>
</section>

  <!-- ══════════════════ SCHEDULED PANEL ══════════════════ -->
  <section class="panel" id="panel-schedule">
    <div class="section-header"><div class="section-title">Scheduled Mails</div><div class="section-subtitle">Manage upcoming and queued email campaigns</div></div>
    <div class="card">
      <div class="table-wrap">
        <table class="table">
          <thead><tr><th>ID</th><th>Campaign</th><th>Recipient Group</th><th>Scheduled At</th><th>Status</th><th>Actions</th></tr></thead>
          <tbody>
            <tr><td>1</td><td><strong>Weekly Newsletter</strong></td><td>All Candidates</td><td class="muted">2025-06-15 09:00</td><td><span class="pill pill-orange">pending</span></td><td><button class="btn btn-danger btn-sm" onclick="return confirm('Cancel?')">Cancel</button></td></tr>
            <tr><td>2</td><td><strong>Company Promo</strong></td><td>All Companies</td><td class="muted">2025-06-16 10:00</td><td><span class="pill pill-orange">pending</span></td><td><button class="btn btn-danger btn-sm" onclick="return confirm('Cancel?')">Cancel</button></td></tr>
            <tr><td>3</td><td><strong>Payment Follow-up</strong></td><td>Pending Payment</td><td class="muted">2025-06-17 08:30</td><td><span class="pill pill-orange">pending</span></td><td><button class="btn btn-danger btn-sm" onclick="return confirm('Cancel?')">Cancel</button></td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <!-- ══════════════════ LOGS PANEL ════════════════════════ -->
  <section class="panel" id="panel-logs">
    <div class="section-header"><div class="section-title">Send Logs</div><div class="section-subtitle">Detailed delivery history for all campaigns</div></div>
    <div class="card">
      <div class="card-header">
        <input type="text" class="form-control" style="max-width:280px;" placeholder="Search by email or campaign..." oninput="filterTable('logsTable', this.value)">
        <select class="form-control" style="max-width:160px;" onchange="filterLogs(this.value)">
          <option value="">All Statuses</option><option value="sent">Sent</option><option value="failed">Failed</option><option value="bounced">Bounced</option>
        </select>
      </div>
      <div class="table-wrap">
        <table class="table" id="logsTable">
          <thead><tr><th>ID</th><th>To Email</th><th>Campaign</th><th>Status</th><th>Sent At</th><th>Bounce Reason</th></tr></thead>
          <tbody>
            <tr><td>1</td><td>rahul@example.com</td><td>June Job Alerts</td><td><span class="pill pill-green">sent</span></td><td class="muted">2025-06-10 09:01</td><td class="muted">-</td></tr>
            <tr><td>2</td><td>priya@gmail.com</td><td>June Job Alerts</td><td><span class="pill pill-green">sent</span></td><td class="muted">2025-06-10 09:01</td><td class="muted">-</td></tr>
            <tr><td>3</td><td>bad@invalid.com</td><td>June Job Alerts</td><td><span class="pill pill-red">bounced</span></td><td class="muted">2025-06-10 09:02</td><td class="muted">Invalid domain</td></tr>
            <tr><td>4</td><td>amit@company.in</td><td>Payment Reminder</td><td><span class="pill pill-green">sent</span></td><td class="muted">2025-06-08 11:31</td><td class="muted">-</td></tr>
            <tr><td>5</td><td>xyz@noexist.net</td><td>Payment Reminder</td><td><span class="pill pill-red">bounced</span></td><td class="muted">2025-06-08 11:31</td><td class="muted">User unknown</td></tr>
            <tr><td>6</td><td>neha@outlook.com</td><td>Welcome New Users</td><td><span class="pill pill-green">sent</span></td><td class="muted">2025-06-05 08:01</td><td class="muted">-</td></tr>
            <tr><td>7</td><td>test@broken.io</td><td>Welcome New Users</td><td><span class="pill pill-orange">failed</span></td><td class="muted">2025-06-05 08:01</td><td class="muted">SMTP timeout</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <!-- ══════════════════ COMPANIES PANEL ══════════════════ -->
  <section class="panel" id="panel-companies">
    <div class="section-header">
      <div class="section-title">Companies</div>
      <div class="section-subtitle">All registered employer companies</div>
    </div>

    <% if ("companies".equals(activePanel) && successMsg != null && !successMsg.isEmpty()) { %>
    <div class="alert alert-success" id="compSuccessAlert">
      <span class="alert-icon">&#10003;</span><%= successMsg %>
      <button class="alert-close" onclick="document.getElementById('compSuccessAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>
    <% if ("companies".equals(activePanel) && errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="alert alert-error" id="compErrorAlert">
      <span class="alert-icon">&#9888;</span><%= errorMsg %>
      <button class="alert-close" onclick="document.getElementById('compErrorAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>

    <%-- Add Company Form --%>
    <div c/div>
        </div>
        <div class="form-actions" style="padding-top:8px;">
          <button type="reset" class="btn btn-ghost">Clear</button>
          <button type="submit" class="btn btn-primary">Add Company</button>
        </div>
      </form>
    </div>

    <%-- Companies Table --%>
    <div class="card">
      <div class="card-header">
        <input type="text" class="form-control" style="max-width:280px;" placeholder="Search company or email..." oninput="filterTable('companiesTable',this.value)">
        <button class="btn btn-primary btn-sm" onclick="showPanel('compose')">Mail All Companies</button>
      </div>
      <div class="table-wrap">
        <table class="table" id="companiesTable">
          <thead>
            <tr><th>ID</th><th>Company</th><th>Email</th><th>Phone</th><th>Password</th><th>Registered</th></tr>
          </thead>
          <tbody>
            <% if (companies.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;padding:40px;color:var(--muted);">
              No companies found. Use the form above to add one.
            </td></tr>
            <% } else { %>
            <% for (Map<String, String> co : companies) { %>
            <%
              String coPhone = co.get("phone");
              String coPhoneDisplay = (coPhone == null || coPhone.isEmpty()) ? "-" : coPhone;
            %>
            <tr>
              <td><%= co.get("id") %></td>
              <td><strong><%= co.get("name") %></strong></td>
              <td><%= co.get("email") %></td>
              <td><%= coPhoneDisplay %></td>
              <td><code><%= co.get("password") %></code></td>
              <td class="muted"><%= co.get("createdAt") %></td>
            </tr>
            <% } %>
            <% } %>
          </tbody>
        </table>
      </div>
      <div style="padding:10px 18px;border-top:1px solid var(--border);font-size:13px;color:var(--muted);">
        Total: <strong><%= companies.size() %></strong> compan<%= companies.size() != 1 ? "ies" : "y" %>
      </div>
    </div>

  </section>

  <!-- ══════════════════ UNSUBSCRIBE PANEL ════════════════ -->
  <section class="panel" id="panel-unsubscribe">
    <div class="section-header">
      <div class="section-title">Unsubscribed Emails</div>
      <div class="section-subtitle">These addresses are excluded from all campaigns</div>
    </div>

    <% if ("unsubscribe".equals(activePanel) && successMsg != null && !successMsg.isEmpty()) { %>
    <div class="alert alert-success" id="unsubSuccessAlert">
      <span class="alert-icon">&#10003;</span><%= successMsg %>
      <button class="alert-close" onclick="document.getElementById('unsubSuccessAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>
    <% if ("unsubscribe".equals(activePanel) && errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="alert alert-error" id="unsubErrorAlert">
      <span class="alert-icon">&#9888;</span><%= errorMsg %>
      <button class="alert-close" onclick="document.getElementById('unsubErrorAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>

    <%-- Add to block list --%>
    <div class="card" style="margin-bottom:24px;">
      <div class="card-header"><div class="card-title">Block an Email Address</div></div>
      <form method="post" action="<%= request.getContextPath() %>/unsubscribe" style="padding:16px 18px;">
        <input type="hidden" name="action" value="add" />
        <div class="form-row">
          <div class="form-group" style="flex:2;">
            <label>Email Address <span class="required">*</span></label>
            <input type="email" name="email" class="form-control" placeholder="user@example.com" required />
          </div>
          <div class="form-group" style="flex:2;">
            <label>Reason</label>
            <input type="text" name="reason" class="form-control" placeholder="e.g. Hard bounce, Marked as spam" />
          </div>
          <div class="form-group" style="flex:0;min-width:140px;align-self:flex-end;">
            <button type="submit" class="btn btn-danger" style="width:100%;">Block Email</button>
          </div>
        </div>
      </form>
    </div>

    <%-- Table --%>
    <div class="card">
      <div class="card-header">
        <input type="text" class="form-control" style="max-width:280px;"
               placeholder="Search email or reason..."
               oninput="filterTable('unsubTable', this.value)">
        <button class="btn btn-ghost btn-sm" onclick="exportCSV('unsubTable','unsubscribed.csv')">
          &#x2913; Export CSV
        </button>
      </div>
      <div class="table-wrap">
        <table class="table" id="unsubTable">
          <thead>
            <tr><th>ID</th><th>Email</th><th>Reason</th><th>Blocked On</th><th>Actions</th></tr>
          </thead>
          <tbody>
            <%
              List<Map<String, String>> unsubList =
                  (List<Map<String, String>>) request.getAttribute("unsubList");
              if (unsubList == null) { unsubList = new java.util.ArrayList<Map<String, String>>(); }
            %>
            <% if (unsubList.isEmpty()) { %>
            <tr><td colspan="5" style="text-align:center;padding:40px;color:var(--muted);">
              No blocked emails yet.
            </td></tr>
            <% } else { %>
            <% for (Map<String, String> u : unsubList) { %>
            <tr>
              <td><%= u.get("id") %></td>
              <td><%= u.get("email") %></td>
              <td class="muted"><%= u.get("reason") %></td>
              <td class="muted"><%= u.get("date") %></td>
              <td>
                <form method="post" action="<%= request.getContextPath() %>/unsubscribe"
                      style="display:inline;"
                      onsubmit="return confirm('Remove this email from the block list?')">
                  <input type="hidden" name="action" value="delete" />
                  <input type="hidden" name="id"     value="<%= u.get("id") %>" />
                  <button type="submit" class="btn btn-ghost btn-sm">Restore</button>
                </form>
              </td>
            </tr>
            <% } %>
            <% } %>
          </tbody>
        </table>
      </div>
      <div style="padding:10px 18px;border-top:1px solid var(--border);font-size:13px;color:var(--muted);">
        Total blocked: <strong><%= unsubList.size() %></strong>
      </div>
    </div>
  </section>

  <!-- ══════════════════ GROUPS PANEL ═════════════════════ -->
  <section class="panel" id="panel-groups">
    <div class="section-header">
      <div class="section-title">Groups / Mailing Lists</div>
      <div class="section-subtitle">Create custom groups for targeted campaigns</div>
    </div>

    <% if ("groups".equals(activePanel) && successMsg != null && !successMsg.isEmpty()) { %>
    <div class="alert alert-success" id="groupSuccessAlert">
      <span class="alert-icon">&#10003;</span><%= successMsg %>
      <button class="alert-close" onclick="document.getElementById('groupSuccessAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>
    <% if ("groups".equals(activePanel) && errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="alert alert-error" id="groupErrorAlert">
      <span class="alert-icon">&#9888;</span><%= errorMsg %>
      <button class="alert-close" onclick="document.getElementById('groupErrorAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>

    <%
      List<Map<String, String>> mailGroups =
          (List<Map<String, String>>) request.getAttribute("mailGroups");
      if (mailGroups == null) { mailGroups = new java.util.ArrayList<Map<String, String>>(); }

      String viewGroupId   = (String) request.getAttribute("viewGroupId");
      String viewGroupName = (String) request.getAttribute("viewGroupName");
      List<Map<String, String>> viewGroupMembers =
          (List<Map<String, String>>) request.getAttribute("viewGroupMembers");
      if (viewGroupMembers == null) { viewGroupMembers = new java.util.ArrayList<Map<String, String>>(); }
    %>

    <%-- Create New Group --%>
    <div class="card" style="margin-bottom:24px;">
      <div class="card-header"><div class="card-title">Create New Group</div></div>
      <form method="post" action="<%= request.getContextPath() %>/mail-groups" style="padding:16px 18px;">
        <input type="hidden" name="action" value="create" />
        <div class="form-row">
          <div class="form-group" style="flex:2;">
            <label>Group Name <span class="required">*</span></label>
            <input type="text" name="groupName" class="form-control"
                   placeholder="e.g. Premium Users" required />
          </div>
          <div class="form-group" style="flex:3;">
            <label>Description</label>
            <input type="text" name="description" class="form-control"
                   placeholder="Short description of this group..." />
          </div>
        </div>
        <div class="form-group">
          <label>Member Emails <span style="font-weight:400;color:var(--muted);">(one per line &mdash; optional, you can add members later)</span></label>
          <textarea name="emails" class="form-control" rows="5"
                    placeholder="email1@example.com&#10;email2@example.com&#10;email3@example.com"></textarea>
        </div>
        <div class="form-actions">
          <button type="reset"  class="btn btn-ghost">Clear</button>
          <button type="submit" class="btn btn-primary">Create Group</button>
        </div>
      </form>
    </div>

    <%-- Groups Table --%>
    <div class="card" style="margin-bottom:24px;">
      <div class="card-header">
        <div class="card-title">All Groups</div>
        <input type="text" class="form-control" style="max-width:240px;"
               placeholder="Search group..." oninput="filterTable('groupsTable',this.value)">
      </div>
      <div class="table-wrap">
        <table class="table" id="groupsTable">
          <thead>
            <tr><th>ID</th><th>Name</th><th>Members</th><th>Description</th><th>Created</th><th>Actions</th></tr>
          </thead>
          <tbody>
            <% if (mailGroups.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;padding:40px;color:var(--muted);">
              No groups yet. Use the form above to create one.
            </td></tr>
            <% } else { %>
            <% for (Map<String, String> g : mailGroups) { %>
            <%
              String gDesc = g.get("description");
              String gDescDisplay = (gDesc == null || gDesc.isEmpty()) ? "-" : gDesc;
            %>
            <tr>
              <td><%= g.get("id") %></td>
              <td><strong><%= g.get("name") %></strong></td>
              <td><span class="pill pill-blue"><%= g.get("members") %></span></td>
              <td class="muted"><%= gDescDisplay %></td>
              <td class="muted"><%= g.get("createdAt") %></td>
              <td style="white-space:nowrap;">
                <a href="<%= request.getContextPath() %>/mail-groups?viewGroup=<%= g.get("id") %>&amp;panel=groups"
                   class="btn btn-ghost btn-sm">Members</a>
                <button class="btn btn-ghost btn-sm"
                        onclick="loadGroupToCompose('<%= g.get("id") %>','<%= g.get("name") %>')">Mail</button>
                <form method="post" action="<%= request.getContextPath() %>/mail-groups"
                      style="display:inline;"
                      onsubmit="return confirm('Delete this group and all its members?')">
                  <input type="hidden" name="action" value="delete" />
                  <input type="hidden" name="id"     value="<%= g.get("id") %>" />
                  <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                </form>
              </td>
            </tr>
            <% } %>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <%-- Member Management (shown only when a group is selected) --%>
    <% if (viewGroupId != null && !viewGroupId.isEmpty()) { %>
    <div class="card" id="memberPanel">
      <div class="card-header">
        <div class="card-title">Members of &ldquo;<%= viewGroupName != null ? viewGroupName : "Group" %>&rdquo;</div>
        <a href="<%= request.getContextPath() %>/mail-groups?panel=groups" class="btn btn-ghost btn-sm">&#8592; Back to Groups</a>
      </div>

      <%-- Add member form --%>
      <form method="post" action="<%= request.getContextPath() %>/mail-groups"
            style="padding:14px 18px;border-bottom:1px solid var(--border);display:flex;gap:10px;align-items:flex-end;flex-wrap:wrap;">
        <input type="hidden" name="action"  value="addMember" />
        <input type="hidden" name="groupId" value="<%= viewGroupId %>" />
        <div class="form-group" style="flex:1;min-width:240px;margin-bottom:0;">
          <label>Add Email</label>
          <input type="email" name="email" class="form-control" placeholder="newmember@example.com" required />
        </div>
        <button type="submit" class="btn btn-primary btn-sm" style="margin-bottom:4px;">Add Member</button>
      </form>

      <div class="table-wrap">
        <table class="table" id="membersTable">
          <thead><tr><th>ID</th><th>Email</th><th>Actions</th></tr></thead>
          <tbody>
            <% if (viewGroupMembers.isEmpty()) { %>
            <tr><td colspan="3" style="text-align:center;padding:32px;color:var(--muted);">
              No members yet. Add emails above.
            </td></tr>
            <% } else { %>
            <% for (Map<String, String> mem : viewGroupMembers) { %>
            <tr>
              <td><%= mem.get("id") %></td>
              <td><%= mem.get("email") %></td>
              <td>
                <form method="post" action="<%= request.getContextPath() %>/mail-groups"
                      style="display:inline;"
                      onsubmit="return confirm('Remove this member?')">
                  <input type="hidden" name="action"   value="removeMember" />
                  <input type="hidden" name="memberId" value="<%= mem.get("id") %>" />
                  <input type="hidden" name="groupId"  value="<%= viewGroupId %>" />
                  <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                </form>
              </td>
            </tr>
            <% } %>
            <% } %>
          </tbody>
        </table>
      </div>
      <div style="padding:10px 18px;border-top:1px solid var(--border);font-size:13px;color:var(--muted);">
        <strong><%= viewGroupMembers.size() %></strong> member<%= viewGroupMembers.size() != 1 ? "s" : "" %> in this group
        &nbsp;&middot;&nbsp;
        <button class="btn btn-ghost btn-sm" onclick="exportCSV('membersTable','group-members.csv')">&#x2913; Export CSV</button>
      </div>
    </div>
    <% } %>

  </section>

</div><!-- /main -->

<div class="modal-overlay" id="emailModal" onclick="closeModal(event)">
  <div class="modal-box">
    <div class="modal-header"><div class="modal-title">Email Preview</div><button class="modal-close" onclick="document.getElementById('emailModal').classList.remove('open')">&#x2715;</button></div>
    <div class="modal-body" id="modalBody"></div>
  </div>
</div>

<script src="js/bulkmail-admin.js"></script>
<script>
  (function() {
    var panel = '<%= activePanel %>';
    if (panel && panel !== 'dashboard') {
      window.addEventListener('DOMContentLoaded', function() {
        if (typeof showPanel === 'function') showPanel(panel);
      });
    }
  })();

  document.addEventListener('click', function(e) {
    var btn = document.getElementById('adminProfileBtn');
    var dd  = document.getElementById('adminDropdown');
    if (btn && dd && !btn.contains(e.target)) dd.classList.remove('open');
  });

  function toggleAdminDropdown() {
    document.getElementById('adminDropdown').classList.toggle('open');
  }
</script>
</body>
</html>
