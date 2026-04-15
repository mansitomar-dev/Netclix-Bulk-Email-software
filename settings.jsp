<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.iardo.bulkmail.model.Admin" %>
<%@ page import="com.iardo.bulkmail.servlet.LoginServlet" %>
<%@ page import="com.iardo.bulkmail.servlet.SmtpSettingsServlet" %>
<%@ page import="java.util.Map" %>
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

    // Load SMTP settings – from request attribute (forwarded) or fetch directly
    Map<String, String> smtp = (Map<String, String>) request.getAttribute("smtpSettings");
    if (smtp == null) smtp = SmtpSettingsServlet.loadSettings();

    String successMsg = request.getParameter("msg");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>SMTP Settings &mdash; NETCLIXCLOUD</title>
<link rel="stylesheet" href="css/bulkmail-admin.css" />
<link rel="stylesheet" href="css/settings.css" />

</head>
<body>

<nav class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="brand-icon"><svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" fill="none" stroke="#fff" stroke-width="2"/><polyline points="22,6 12,13 2,6" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round"/></svg></div>
    <div><div class="brand-name">NETCLIXCLOUD</div><div class="brand-sub">BulkMail Admin</div></div>
  </div>
  <div class="sidebar-section-label">MAIN</div>
  <div class="nav-item" onclick="location.href='<%= request.getContextPath() %>/dashboard'"><span class="nav-icon"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="14" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="3" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/><rect x="14" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="2"/></svg></span>Dashboard</div>
  <div class="sidebar-section-label" style="margin-top:18px;">ACCOUNT</div>
  <div class="nav-item active"><span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg></span>SMTP Settings</div>
  <div class="nav-item nav-danger" onclick="location.href='<%= request.getContextPath() %>/logout'"><span class="nav-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg></span>Logout</div>
  <div class="sidebar-footer">&copy; 2026 NETCLIXCLOUD BulkMail</div>
</nav>

<div class="overlay" id="overlay" onclick="document.getElementById('sidebar').classList.toggle('open');this.classList.toggle('open');"></div>

<div class="main" id="main">
  <header class="topbar">
    <div class="topbar-left">
      <button class="hamburger" onclick="document.getElementById('sidebar').classList.toggle('open');document.getElementById('overlay').classList.toggle('open');">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" width="22" height="22"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
      </button>
      <div>
        <div class="topbar-title">SMTP Settings</div>
        <div class="topbar-breadcrumb">NETCLIXCLOUD / Admin / SMTP Configuration</div>
      </div>
    </div>
    <div class="topbar-right">
      <div class="topbar-time" id="live-time"></div>
      <div class="admin-profile">
        <div class="admin-avatar"><%= adminInitial %></div>
        <div class="admin-info">
          <div class="admin-name"><%= adminFullName %></div>
          <div class="admin-role"><%= adminRole %></div>
        </div>
      </div>
    </div>
  </header>

  <section class="panel active" style="display:block;">
    <div class="section-header">
      <div class="section-title">SMTP Configuration</div>
      <div class="section-subtitle">Configure the mail server used to send all bulk campaigns</div>
    </div>

    <% if (successMsg != null && !successMsg.isEmpty()) { %>
    <div class="alert alert-success" id="smtpSuccessAlert">
      <span class="alert-icon">&#10003;</span><%= successMsg %>
      <button class="alert-close" onclick="document.getElementById('smtpSuccessAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="alert alert-error" id="smtpErrorAlert">
      <span class="alert-icon">&#9888;</span><%= errorMsg %>
      <button class="alert-close" onclick="document.getElementById('smtpErrorAlert').style.display='none'">&#x2715;</button>
    </div>
    <% } %>

    <div class="settings-grid">

      <%-- ── Main SMTP Form ── --%>
      <form method="post" action="<%= request.getContextPath() %>/smtp-settings" id="smtpForm">
        <div class="card">
          <div class="card-header"><div class="card-title">Server Settings</div></div>
          <div style="padding:16px 18px;">

            <div class="form-row">
              <div class="form-group" style="flex:2;">
                <label>SMTP Host <span class="required">*</span></label>
                <input type="text" name="smtpHost" class="form-control"
                       placeholder="smtp.gmail.com"
                       value="<%= smtp.get("host") %>" required />
              </div>
              <div class="form-group" style="flex:1;">
                <label>Port</label>
                <input type="number" name="smtpPort" class="form-control"
                       placeholder="587"
                       value="<%= smtp.get("port") %>" />
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label>Username / Email</label>
                <input type="text" name="smtpUsername" class="form-control"
                       placeholder="your@email.com"
                       value="<%= smtp.get("username") %>" />
              </div>
              <div class="form-group">
                <label>Password <span class="form-hint" style="font-weight:400;">(leave blank to keep current)</span></label>
                <input type="password" name="smtpPassword" class="form-control"
                       placeholder="&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;" />
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label>From Email Address <span class="required">*</span></label>
                <input type="email" name="fromEmail" class="form-control"
                       placeholder="noreply@netclixcloud.com"
                       value="<%= smtp.get("fromEmail") %>" required />
              </div>
              <div class="form-group">
                <label>From Display Name</label>
                <input type="text" name="fromName" class="form-control"
                       placeholder="NETCLIX Team"
                       value="<%= smtp.get("fromName") %>" />
              </div>
            </div>

            <%-- TLS / SSL toggles --%>
            <div style="margin-top:8px;">
              <div class="toggle-row">
                <div>
                  <div class="toggle-label">Enable STARTTLS</div>
                  <div class="toggle-desc">Recommended for port 587 (Gmail, Outlook, etc.)</div>
                </div>
                <label class="toggle-switch">
                  <input type="checkbox" name="useTls" id="useTls"
                         <%= "1".equals(smtp.get("useTls")) ? "checked" : "" %> />
                  <span class="slider"></span>
                </label>
              </div>
              <div class="toggle-row">
                <div>
                  <div class="toggle-label">Use SSL/TLS (port 465)</div>
                  <div class="toggle-desc">Use when connecting on port 465</div>
                </div>
                <label class="toggle-switch">
                  <input type="checkbox" name="useSsl" id="useSsl"
                         <%= "1".equals(smtp.get("useSsl")) ? "checked" : "" %> />
                  <span class="slider"></span>
                </label>
              </div>
            </div>

            <div class="form-actions" style="padding-top:20px;">
              <button type="button" class="btn btn-ghost" onclick="testSmtp()">&#9654; Test Connection</button>
              <button type="submit" class="btn btn-primary">Save Settings</button>
            </div>

            <div class="test-result" id="testResult"></div>
          </div>
        </div>
      </form>

      <%-- ── Info / Help Panel ── --%>
      <div>
        <div class="card">
          <div class="card-header"><div class="card-title">Quick Reference</div></div>
          <div style="padding:16px 18px;font-size:13px;line-height:1.7;color:var(--text);">
            <p style="margin:0 0 12px;font-weight:600;color:var(--muted);font-size:11px;text-transform:uppercase;letter-spacing:.05em;">Common Providers</p>
            <table style="width:100%;border-collapse:collapse;font-size:12px;">
              <thead><tr style="color:var(--muted);">
                <th style="text-align:left;padding:4px 6px;">Provider</th>
                <th style="text-align:left;padding:4px 6px;">Host</th>
                <th style="text-align:center;padding:4px 6px;">Port</th>
              </tr></thead>
              <tbody>
                <tr onclick="fillQuick('smtp.gmail.com','587')" style="cursor:pointer;" onmouseover="this.style.background='var(--surface2)'" onmouseout="this.style.background=''">
                  <td style="padding:6px;">Gmail</td><td style="padding:6px;">smtp.gmail.com</td><td style="text-align:center;padding:6px;">587</td>
                </tr>
                <tr onclick="fillQuick('smtp.office365.com','587')" style="cursor:pointer;" onmouseover="this.style.background='var(--surface2)'" onmouseout="this.style.background=''">
                  <td style="padding:6px;">Outlook 365</td><td style="padding:6px;">smtp.office365.com</td><td style="text-align:center;padding:6px;">587</td>
                </tr>
                <tr onclick="fillQuick('smtp-relay.sendinblue.com','587')" style="cursor:pointer;" onmouseover="this.style.background='var(--surface2)'" onmouseout="this.style.background=''">
                  <td style="padding:6px;">Brevo (SIB)</td><td style="padding:6px;">smtp-relay.sendinblue.com</td><td style="text-align:center;padding:6px;">587</td>
                </tr>
                <tr onclick="fillQuick('email-smtp.us-east-1.amazonaws.com','587')" style="cursor:pointer;" onmouseover="this.style.background='var(--surface2)'" onmouseout="this.style.background=''">
                  <td style="padding:6px;">Amazon SES</td><td style="padding:6px;">email-smtp.us-east-1…</td><td style="text-align:center;padding:6px;">587</td>
                </tr>
                <tr onclick="fillQuick('smtp.mailgun.org','587')" style="cursor:pointer;" onmouseover="this.style.background='var(--surface2)'" onmouseout="this.style.background=''">
                  <td style="padding:6px;">Mailgun</td><td style="padding:6px;">smtp.mailgun.org</td><td style="text-align:center;padding:6px;">587</td>
                </tr>
              </tbody>
            </table>
            <p style="margin:14px 0 4px;color:var(--muted);font-size:11px;">Click a row to auto-fill Host &amp; Port.</p>
            <hr style="border:none;border-top:1px solid var(--border);margin:14px 0;" />
            <p style="margin:0;color:var(--muted);font-size:12px;">
              &#128274; Passwords are stored encrypted.<br/>
              &#128276; For Gmail, use an <strong>App Password</strong>, not your regular password.<br/>
              &#128736; Changes take effect immediately on the next campaign send.
            </p>
          </div>
        </div>

        <div class="card" style="margin-top:18px;">
          <div class="card-header"><div class="card-title">Current Config</div></div>
          <div style="padding:14px 18px;font-size:13px;color:var(--text);">
            <div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--border);">
              <span style="color:var(--muted);">Host</span>
              <strong><%= smtp.get("host").isEmpty() ? "Not set" : smtp.get("host") %></strong>
            </div>
            <div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--border);">
              <span style="color:var(--muted);">Port</span>
              <strong><%= smtp.get("port") %></strong>
            </div>
            <div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--border);">
              <span style="color:var(--muted);">From</span>
              <strong><%= smtp.get("fromEmail").isEmpty() ? "Not set" : smtp.get("fromEmail") %></strong>
            </div>
            <div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--border);">
              <span style="color:var(--muted);">TLS</span>
              <% if("1".equals(smtp.get("useTls"))) { %><span class="pill pill-green">Enabled</span><% } else { %><span class="pill pill-red">Off</span><% } %>
            </div>
            <div style="display:flex;justify-content:space-between;padding:6px 0;">
              <span style="color:var(--muted);">SSL</span>
              <% if("1".equals(smtp.get("useSsl"))) { %><span class="pill pill-green">Enabled</span><% } else { %><span class="pill pill-red">Off</span><% } %>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</div>

<script src="js/settings.js"></script>
</body>
</html>
