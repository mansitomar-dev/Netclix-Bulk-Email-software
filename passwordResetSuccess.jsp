<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset Successful — Netclix Cloud</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif; background: #f0f2f7;
            min-height: 100vh; display: flex; flex-direction: column;
            align-items: center; justify-content: center; padding: 20px; position: relative;
        }
        body::before {
            content: ''; position: fixed; inset: 0;
            background-image: linear-gradient(rgba(180,190,210,0.25) 1px, transparent 1px), linear-gradient(90deg, rgba(180,190,210,0.25) 1px, transparent 1px);
            background-size: 40px 40px; pointer-events: none; z-index: 0;
        }

        .logo-wrap { display: flex; flex-direction: column; align-items: center; gap: 10px; margin-bottom: 24px; position: relative; z-index: 1; }
        .logo-icon { width: 56px; height: 56px; background: linear-gradient(135deg, #2563eb, #1d4ed8); border-radius: 14px; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 16px rgba(37,99,235,0.35); }
        .logo-icon svg { width: 28px; height: 28px; }
        .logo-text h2 { font-size: 1.1rem; font-weight: 700; letter-spacing: 0.12em; color: #1e293b; text-transform: uppercase; text-align: center; }
        .logo-text p  { font-size: 0.7rem; font-weight: 600; letter-spacing: 0.18em; color: #64748b; text-transform: uppercase; margin-top: 2px; text-align: center; }

        .card {
            position: relative; z-index: 1; width: 100%; max-width: 460px;
            background: #fff; border-radius: 16px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.04), 0 8px 32px rgba(0,0,0,0.08);
            overflow: hidden; text-align: center;
            animation: popIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        @keyframes popIn {
            from { opacity: 0; transform: scale(0.95) translateY(16px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }

        /* Green top bar */
        .card-top {
            background: linear-gradient(135deg, #16a34a, #15803d);
            padding: 32px 40px 28px;
        }

        /* Animated checkmark circle */
        .check-wrap {
            width: 72px; height: 72px;
            background: rgba(255,255,255,0.15);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 16px;
            animation: scaleIn 0.4s 0.2s cubic-bezier(0.34, 1.56, 0.64, 1) both;
        }
        @keyframes scaleIn {
            from { transform: scale(0); opacity: 0; }
            to   { transform: scale(1); opacity: 1; }
        }
        .check-wrap svg { width: 38px; height: 38px; }
        .check-wrap svg path {
            stroke-dasharray: 50;
            stroke-dashoffset: 50;
            animation: drawCheck 0.4s 0.5s ease forwards;
        }
        @keyframes drawCheck { to { stroke-dashoffset: 0; } }

        .card-top h1 { font-size: 1.4rem; font-weight: 700; color: #fff; margin: 0; }
        .card-top p  { font-size: 0.875rem; color: rgba(255,255,255,0.75); margin-top: 6px; line-height: 1.5; }

        /* Card body */
        .card-body { padding: 28px 40px 36px; }

        .info-box {
            background: #f0fdf4; border: 1px solid #bbf7d0;
            border-radius: 12px; padding: 18px 20px;
            margin-bottom: 24px; text-align: left;
        }
        .info-box .info-row { display: flex; align-items: flex-start; gap: 10px; font-size: 0.855rem; color: #166534; line-height: 1.6; }
        .info-box .info-row + .info-row { margin-top: 10px; }
        .info-box .info-row svg { width: 16px; height: 16px; flex-shrink: 0; margin-top: 2px; }

        .email-note {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            background: #eff6ff; border: 1px solid #bfdbfe;
            border-radius: 10px; padding: 12px 16px;
            font-size: 0.83rem; color: #1d4ed8; font-weight: 500;
            margin-bottom: 24px;
        }
        .email-note svg { width: 15px; height: 15px; flex-shrink: 0; }

        .btn {
            width: 100%; padding: 14px; background: #2563eb;
            border: none; border-radius: 10px; color: #fff;
            font-family: 'Inter', sans-serif; font-weight: 700; font-size: 0.95rem;
            cursor: pointer; transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            box-shadow: 0 4px 12px rgba(37,99,235,0.3); text-decoration: none;
            display: block;
        }
        .btn:hover { background: #1d4ed8; box-shadow: 0 6px 18px rgba(37,99,235,0.4); transform: translateY(-1px); }
        .btn:active { transform: translateY(0); }

        /* Countdown auto-redirect */
        .auto-redirect {
            margin-top: 14px; font-size: 0.78rem; color: #94a3b8; text-align: center;
        }
        .auto-redirect span { color: #2563eb; font-weight: 600; }

        .footer { margin-top: 20px; font-size: 0.75rem; color: #94a3b8; text-align: center; position: relative; z-index: 1; }
        .footer span { margin: 0 6px; }
    </style>
</head>
<body>

    <div class="logo-wrap">
        <div class="logo-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
            </svg>
        </div>
        <div class="logo-text">
            <h2>Netclix Cloud</h2>
            <p>Bulkmail Platform</p>
        </div>
    </div>

    <div class="card">
        <!-- Green top -->
        <div class="card-top">
            <div class="check-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 13l4 4L19 7"/>
                </svg>
            </div>
            <h1>Password Reset Successful</h1>
            <p>Your password has been reset successfully and sent on your registered mail. Please login again.</p>
        </div>

        <div class="card-body">
            <!-- Info points -->
            <div class="info-box">
                <div class="info-row">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                    </svg>
                    New password has been sent to your registered email address.
                </div>
                <div class="info-row">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    Please change your password after logging in for security.
                </div>
            </div>

            <!-- Sent from badge -->
            <div class="email-note">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                </svg>
                Email sent from &nbsp;<strong>info@netclixcloud.com</strong>
            </div>

            <a href="<%= request.getContextPath() %>/login.jsp" class="btn" id="loginBtn">
                Go to Login
            </a>

            <p class="auto-redirect">
                Redirecting automatically in <span id="countdown">5</span> seconds...
            </p>
        </div>
    </div>

    <p class="footer">© 2026 @NETCLIX CLOUD <span>·</span> Secure Access Portal</p>

    <script>
        // Auto redirect countdown
        let secs = 5;
        const el = document.getElementById('countdown');
        const interval = setInterval(() => {
            secs--;
            el.textContent = secs;
            if (secs <= 0) {
                clearInterval(interval);
                window.location.href = '<%= request.getContextPath() %>/login.jsp';
            }
        }, 1000);
    </script>
</body>
</html>
