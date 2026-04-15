<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.iardo.bulkmail.servlet.LoginServlet" %>

<%
HttpSession existingSession = request.getSession(false);
if (existingSession != null
&& existingSession.getAttribute(LoginServlet.SESSION_ADMIN) != null) {
    response.sendRedirect(request.getContextPath() + "/bulkmail-admin.jsp");
    return;
}
String errorMsg = (String) request.getAttribute("errorMessage");
String activeTab = (String) request.getAttribute("activeTab");
if (activeTab == null) activeTab = "company";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Sign In &mdash; NETCLIX CLOUD</title>
  <link rel="icon" type="image/webp" href="https://netclix.pages.dev/netclix_logo.webp"/>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="css/login.css"/>
</head>
<body>

<!-- Background -->
<div class="bg-canvas">
  <div class="orb orb1"></div>
  <div class="orb orb2"></div>
  <div class="orb orb3"></div>
</div>
<div class="bg-grid"></div>

<div class="page">

  <!-- Brand -->
  <div class="brand">
    <div class="brand-icon">

<img src="https://netclix.pages.dev/netclix_logo.webp" 
         alt="NETCLIX CLOUD" 
         style="width:100%; height:100%; object-fit:contain;" />


    </div>
    <div>
      <div class="brand-name">NETCLIX CLOUD</div>
      <div class="brand-sub">BulkMail Platform</div>
    </div>
  </div>

  <!-- Card -->
  <div class="card">

    <!-- Tabs -->
    <div class="tabs" role="tablist">
      <button class="tab-btn company <%= "company".equals(activeTab) ? "active" : "" %>"
              role="tab" aria-selected="<%= "company".equals(activeTab) %>"
              onclick="switchTab('company')" id="tab-company">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <rect x="2" y="7" width="20" height="14" rx="2"/>
          <path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/>
        </svg>
        <span>Company Login</span>
      </button>
      <button class="tab-btn admin <%= "admin".equals(activeTab) ? "active" : "" %>"
              role="tab" aria-selected="<%= "admin".equals(activeTab) %>"
              onclick="switchTab('admin')" id="tab-admin">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
        </svg>
        <span>Admin Login</span>
      </button>
    </div>

    <!-- ═══════════ COMPANY PANEL ═══════════ -->
    <div class="panel company-panel <%= "company".equals(activeTab) ? "active" : "" %>"
         id="panel-company" role="tabpanel">

      <div class="panel-title">Company Sign In</div>
      <div class="panel-desc">Access your BulkMail dashboard and campaigns</div>

      <% if ("company".equals(activeTab) && errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="error-box show">
        <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
        <span><%= errorMsg %></span>
      </div>
      <% } %>

      <div class="company-badge">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <circle cx="12" cy="12" r="10"/>
          <path d="M2 12h20M12 2a15.3 15.3 0 010 20M12 2a15.3 15.3 0 000 20"/>
        </svg>
        Sign in with your company credentials
      </div>

      <form method="post" action="<%= request.getContextPath() %>/company-login"
            onsubmit="handleSubmit(event,'companyBtn')">
        <input type="hidden" name="loginType" value="company"/>

        <div class="form-group">
          <label for="c-email">Work Email</label>
          <div class="input-wrap">
            <span class="input-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                <polyline points="22,6 12,13 2,6"/>
              </svg>
            </span>
            <input type="email" id="c-email" name="email" class="form-control"
                   placeholder="you@company.com" autocomplete="email" required/>
          </div>
        </div>

        <div class="form-group">
          <label for="c-password">Password</label>
          <div class="input-wrap">
            <span class="input-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <rect x="3" y="11" width="18" height="11" rx="2"/>
                <path d="M7 11V7a5 5 0 0110 0v4"/>
              </svg>
            </span>
            <input type="password" id="c-password" name="password" class="form-control"
                   placeholder="••••••••" autocomplete="current-password" required/>
            <button type="button" class="toggle-pass" onclick="togglePwd('c-password','eyeC')" aria-label="Show/hide">
              <svg id="eyeC" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
            </button>
          </div>
        </div>

        <div class="row-between">
          <label class="remember"><input type="checkbox" name="remember"/> Remember me</label>
          <a href="#" class="forgot">Forgot password?</a>
        </div>

        <button type="submit" class="btn-login" id="companyBtn">
          <span class="btn-text">Sign In to Dashboard</span>
          <div class="spinner"></div>
        </button>
      </form>
    </div>

    <!-- ═══════════ ADMIN PANEL ═══════════ -->
    <div class="panel admin-panel <%= "admin".equals(activeTab) ? "active" : "" %>"
         id="panel-admin" role="tabpanel">

      <div class="panel-title">Admin Sign In</div>
      <div class="panel-desc">Restricted access &mdash; authorized personnel only</div>

      <% if ("admin".equals(activeTab) && errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="error-box show">
        <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
        <span><%= errorMsg %></span>
      </div>
      <% } %>

      <div class="admin-badge">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
        </svg>
        Secure admin portal &mdash; activity is monitored
      </div>

      <form method="post" action="<%= request.getContextPath() %>/login"
            onsubmit="handleSubmit(event,'adminBtn')">
        <input type="hidden" name="loginType" value="admin"/>

        <div class="form-group">
          <label for="a-username">Username</label>
          <div class="input-wrap">
            <span class="input-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
              </svg>
            </span>
            <input type="text" id="a-username" name="username" class="form-control"
                   placeholder="admin" autocomplete="username" required
                   value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"/>
          </div>
        </div>

        <div class="form-group">
          <label for="a-password">Password</label>
          <div class="input-wrap">
            <span class="input-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <rect x="3" y="11" width="18" height="11" rx="2"/>
                <path d="M7 11V7a5 5 0 0110 0v4"/>
              </svg>
            </span>
            <input type="password" id="a-password" name="password" class="form-control"
                   placeholder="••••••••" autocomplete="current-password" required/>
            <button type="button" class="toggle-pass" onclick="togglePwd('a-password','eyeA')" aria-label="Show/hide">
              <svg id="eyeA" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
            </button>
          </div>
        </div>

        <div class="row-between">
          <label class="remember"><input type="checkbox" name="remember"/> Remember me</label>
          <a href="#" class="forgot">Forgot password?</a>
        </div>

        <button type="submit" class="btn-login" id="adminBtn">
          <span class="btn-text">Sign In as Admin</span>
          <div class="spinner"></div>
        </button>
      </form>
    </div>

  </div><!-- /card -->

  <div class="footer">&copy; 2026 NETCLIX CLOUD &middot; Secure Access Portal</div>

</div><!-- /page -->

<script>var ACTIVE_TAB = '<%= activeTab %>';</script>
<script src="js/login.js"></script>
</body>
</html>
