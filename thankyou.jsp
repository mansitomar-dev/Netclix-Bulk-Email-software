<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Thank You — Netclix</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;1,400&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Archivo+Black&family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<style>
/* ════════════════════════════════════════
   RESET & BASE
════════════════════════════════════════ */
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
html{scroll-behavior:smooth;overflow-x:hidden;}
body{
  font-family:'Outfit',sans-serif;
  background:linear-gradient(135deg,#fefefe,#e0f7fa);
  color:#1A1510;
  overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
  line-height:1.6;
  min-height:100vh;
}
a{text-decoration:none;color:inherit;}
img{max-width:100%;display:block;}

/* ════════════════════════════════════════
   NAVBAR
════════════════════════════════════════ */
.navbar{
  position:fixed;top:0;left:0;right:0;
  z-index:9999;
  display:flex;align-items:center;justify-content:space-between;
  padding:0 48px;height:64px;
  background:rgba(10,10,18,0.82);
  backdrop-filter:blur(20px) saturate(180%);
  -webkit-backdrop-filter:blur(20px) saturate(180%);
  border-bottom:1px solid rgba(255,255,255,0.08);
  box-shadow:0 2px 20px rgba(0,0,0,0.18);
  transition:background .3s ease;
}
.navbar.scrolled{background:rgba(8,8,14,0.95);}

.navbar-logo{display:flex;align-items:center;gap:10px;text-decoration:none;flex-shrink:0;}
.navbar-logo-icon{
  width:36px;height:36px;border-radius:10px;
  background:linear-gradient(135deg,#D94F2B,#C0385E);
  display:flex;align-items:center;justify-content:center;
  box-shadow:0 4px 14px rgba(217,79,43,0.4);flex-shrink:0;
}
.navbar-logo-name{
  font-family:'Archivo Black',Arial,sans-serif;
  font-size:20px;font-weight:900;color:#fff;
  letter-spacing:-.02em;text-transform:uppercase;
}

.navbar-links{
  display:flex;align-items:center;gap:4px;
  list-style:none;flex:1;justify-content:center;
}
.navbar-links a{
  font-size:14px;font-weight:600;
  color:rgba(255,255,255,0.78);
  padding:7px 14px;border-radius:8px;
  text-decoration:none;white-space:nowrap;
  transition:color .2s,background .2s;
}
.navbar-links a:hover,.navbar-links a.active{
  color:#fff;background:rgba(255,255,255,0.10);
}

.navbar-cta{
  display:flex;align-items:center;
  font-size:13px;font-weight:700;color:#fff;
  padding:9px 22px;border-radius:50px;
  background:linear-gradient(135deg,#D94F2B,#C0385E);
  box-shadow:0 4px 16px rgba(217,79,43,0.40);
  text-decoration:none;white-space:nowrap;flex-shrink:0;
  transition:transform .25s,box-shadow .25s,filter .25s;
}
.navbar-cta:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(217,79,43,0.55);filter:brightness(1.08);}

.navbar-burger{
  display:none;
  flex-direction:column;gap:5px;
  background:rgba(255,255,255,0.08);
  border:1px solid rgba(255,255,255,0.18);
  border-radius:8px;cursor:pointer;
  padding:9px 12px;transition:background .2s;flex-shrink:0;
}
.navbar-burger:hover{background:rgba(255,255,255,0.15);}
.navbar-burger span{display:block;width:20px;height:2px;background:#fff;border-radius:2px;transition:all .28s ease;}
.navbar-burger.open span:nth-child(1){transform:rotate(45deg) translate(5px,5px);}
.navbar-burger.open span:nth-child(2){opacity:0;transform:scaleX(0);}
.navbar-burger.open span:nth-child(3){transform:rotate(-45deg) translate(5px,-5px);}

.navbar-mobile-menu{
  display:none;flex-direction:column;
  position:fixed;top:64px;left:0;right:0;
  background:rgba(8,8,14,0.97);
  backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);
  border-bottom:1px solid rgba(255,255,255,0.08);
  padding:12px 16px 20px;gap:4px;
  z-index:9998;box-shadow:0 8px 30px rgba(0,0,0,0.4);
}
.navbar-mobile-menu.open{display:flex;animation:mobileSlide .28s ease;}
@keyframes mobileSlide{from{opacity:0;transform:translateY(-8px);}to{opacity:1;transform:translateY(0);}}
.navbar-mobile-menu a{
  font-size:16px;font-weight:600;
  color:rgba(255,255,255,0.82);
  padding:13px 16px;border-radius:10px;
  text-decoration:none;transition:all .2s;
  border-bottom:1px solid rgba(255,255,255,0.05);
}
.navbar-mobile-menu a:last-child{border-bottom:none;}
.navbar-mobile-menu a:hover{color:#fff;background:rgba(255,255,255,0.07);}
.mob-cta{
  margin-top:8px;
  background:linear-gradient(135deg,#D94F2B,#C0385E) !important;
  color:#fff !important;text-align:center;
  border-radius:50px !important;border:none !important;
  padding:14px 0 !important;font-weight:700 !important;
}

/* ════════════════════════════════════════
   MAIN CONTENT
════════════════════════════════════════ */
main{
  display:flex;flex-wrap:wrap;justify-content:center;
  max-width:1200px;margin:0 auto;
  padding:100px 20px 60px;
  gap:40px;
}
.left-col,.right-col{flex:1 1 400px;}

h1{font-size:2.8rem;line-height:1.3;margin-bottom:20px;}
h1 em{color:#ff5722;font-style:normal;}
.highlight{color:#ff5722;}
.subtitle{font-size:1.1rem;color:#555;margin-bottom:30px;line-height:1.7;}
.rule{display:flex;align-items:center;margin-bottom:30px;}
.rule-line{flex:1;height:2px;background:#ff5722;}
.rule-icon{margin-left:10px;font-size:1.5rem;color:#ff5722;}
.check-list{list-style:none;padding:0;}
.check-list li{display:flex;align-items:flex-start;margin-bottom:15px;font-size:1rem;line-height:1.6;}
.check-icon{color:#ff5722;font-weight:bold;margin-right:10px;flex-shrink:0;margin-top:2px;}

/* Card */
.company-card{background:#fff;border-radius:20px;padding:25px;box-shadow:0 8px 25px rgba(0,0,0,0.08);}
.card-header{text-align:center;margin-bottom:25px;}
.success-badge{font-size:2.5rem;margin-bottom:10px;}
.card-header h2{font-size:1.4rem;font-weight:700;margin-bottom:8px;}
.stats-row{display:flex;justify-content:space-around;margin-bottom:20px;flex-wrap:wrap;gap:12px;}
.stat-item{text-align:center;}
.stat-num{font-size:1.5rem;font-weight:700;color:#ff5722;}
.stat-label{font-size:0.9rem;color:#555;}
.card-divider{height:1px;background:#eee;margin:20px 0;}
.section-label{text-align:center;font-size:0.9rem;color:#888;margin-bottom:15px;}

/* Logos grid */
.logos-grid{
  display:grid;
  grid-template-columns:repeat(4,1fr);
  gap:12px;justify-items:center;
}
.logo-cell{
  background:#f9f9f9;border:1px solid #eee;
  border-radius:10px;padding:12px;
  display:flex;align-items:center;justify-content:center;
  width:100%;min-height:70px;
  transition:box-shadow .2s,transform .2s;
}
.logo-cell:hover{box-shadow:0 4px 16px rgba(0,0,0,0.08);transform:translateY(-2px);}
.logo-cell img{max-width:80px;max-height:50px;object-fit:contain;filter:grayscale(30%);transition:filter .2s;}
.logo-cell img:hover{filter:grayscale(0%);}

/* Background orbs */
.orb{position:fixed;border-radius:50%;opacity:0.12;pointer-events:none;z-index:0;}
.orb-1{width:300px;height:300px;top:80px;left:-60px;background:#ff5722;filter:blur(80px);}
.orb-2{width:250px;height:250px;top:350px;right:-60px;background:#2196f3;filter:blur(80px);}
.orb-3{width:280px;height:280px;bottom:300px;left:60px;background:#4caf50;filter:blur(80px);}

/* ════════════════════════════════════════
   FOOTER
════════════════════════════════════════ */
.footer{
  background:#fff;
  color:#4A4540;
  padding:72px 0 0;
  border-top:1px solid rgba(26,21,16,0.09);
  position:relative;overflow:hidden;
  margin-top:40px;
}
.footer::before{
  content:'';position:absolute;top:0;left:50%;
  transform:translateX(-50%);width:55%;height:2px;
  background:linear-gradient(90deg,transparent,rgba(217,79,43,0.3),transparent);
}

.footer .container{max-width:1280px;margin:0 auto;padding:0 48px;}

.footer-grid{
  display:grid;
  grid-template-columns:2fr 1fr 1fr 1fr 1fr;
  gap:48px;
  padding-bottom:48px;
  border-bottom:1px solid rgba(26,21,16,0.09);
}

/* Brand col */
.footer-brand{display:flex;flex-direction:column;gap:16px;}
.footer-logo{
  display:flex;align-items:center;gap:11px;
  color:#1A1510;
  font-family:'Archivo Black',serif;font-size:20px;font-weight:900;text-transform:uppercase;
}
.logo-hex{
  background:linear-gradient(135deg,#D94F2B,#C0385E);
  display:flex;align-items:center;justify-content:center;
}
.logo-hex.sm{width:34px;height:34px;border-radius:9px;}
.footer-brand>p{font-size:14px;line-height:1.75;max-width:250px;color:#8A8278;}

/* Contact cards */
.footer-contact-cards{display:flex;flex-direction:column;gap:8px;}
.fcc{
  display:flex;align-items:center;gap:12px;
  background:#F5F3EF;border:1px solid rgba(26,21,16,0.09);
  border-radius:12px;padding:11px 15px;
  transition:all .2s;text-decoration:none;
}
.fcc:hover{background:rgba(217,79,43,0.05);border-color:rgba(217,79,43,0.2);transform:translateX(4px);}
.fcc-icon{
  width:32px;height:32px;border-radius:9px;
  background:rgba(217,79,43,0.07);border:1px solid rgba(217,79,43,0.16);
  display:flex;align-items:center;justify-content:center;
  flex-shrink:0;font-size:13px;color:#D94F2B;
}
.fcc-text{display:flex;flex-direction:column;gap:2px;}
.fcc-text strong{font-size:12px;font-weight:700;color:#1A1510;line-height:1.3;}
.fcc-text span{font-size:10px;color:#8A8278;text-transform:uppercase;letter-spacing:.06em;}

/* Social */
.fsoc{display:flex;gap:8px;margin-top:4px;}
.fs-a{
  width:36px;height:36px;border-radius:50%;
  background:#F5F3EF;border:1px solid rgba(26,21,16,0.15);
  display:flex;align-items:center;justify-content:center;
  color:#8A8278;font-size:12px;font-weight:700;
  transition:all .25s;
}
.fs-a:hover{background:#D94F2B;border-color:#D94F2B;color:#fff;transform:translateY(-3px);}

/* Link columns */
.fc{display:flex;flex-direction:column;gap:10px;}
.fc h5{
  color:#D94F2B;font-size:10px;font-weight:800;
  margin-bottom:6px;letter-spacing:.15em;text-transform:uppercase;
}
.fc a{
  font-size:13px;font-weight:500;color:#8A8278;
  transition:all .2s;display:inline-block;
}
.fc a:hover{color:#D94F2B;transform:translateX(4px);}

/* Footer bottom */
.footer-bottom{
  display:flex;align-items:center;justify-content:space-between;
  padding:24px 0;font-size:12px;color:#BAB4AC;flex-wrap:wrap;gap:12px;
}
.footer-bottom div{display:flex;gap:24px;}
.footer-bottom a{color:#BAB4AC;font-weight:500;transition:color .2s;}
.footer-bottom a:hover{color:#D94F2B;}

/* ════════════════════════════════════════
   RESPONSIVE
════════════════════════════════════════ */
@media (max-width:768px){
  .navbar-links{display:none !important;}
  .navbar-cta{display:none !important;}
  .navbar-burger{display:flex !important;}
  .navbar{padding:0 16px;height:58px;}
  .navbar-mobile-menu{top:58px;}
  .navbar-logo-name{font-size:17px;}
  .navbar-logo-icon{width:32px;height:32px;border-radius:8px;}
}

@media (max-width:1100px){
  .footer-grid{grid-template-columns:1fr 1fr 1fr;gap:30px;}
  .footer-brand{grid-column:1/-1;}
}

@media (max-width:900px){
  main{flex-direction:column;padding:80px 16px 40px;}
  .left-col,.right-col{flex:none;width:100%;}
  h1{font-size:2rem;}
  .footer .container{padding:0 24px;}
  .footer-grid{grid-template-columns:1fr 1fr;gap:28px;}
  .footer-brand{grid-column:1/-1;}
  .logos-grid{grid-template-columns:repeat(3,1fr);}
}

@media (max-width:600px){
  .footer-grid{grid-template-columns:1fr 1fr;gap:22px;}
  .footer-bottom{flex-direction:column;text-align:center;}
  .footer-bottom div{justify-content:center;}
  .logos-grid{grid-template-columns:repeat(2,1fr);}
  .stats-row{flex-direction:column;align-items:center;}
  .footer .container{padding:0 16px;}
  .footer{padding:48px 0 0;}
}

@media (max-width:400px){
  h1{font-size:1.7rem;}
  .company-card{padding:18px;}
}
</style>
</head>
<body>

<!-- ══════════ NAVBAR ══════════ -->
<nav class="navbar" id="navbar">
  <a href="#" class="navbar-logo">
    <div class="navbar-logo-icon">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
        <path d="M12 2L22 7V17L12 22L2 17V7L12 2Z" fill="rgba(255,255,255,0.95)"/>
        <path d="M12 8L17 10.5V15.5L12 18L7 15.5V10.5L12 8Z" fill="rgba(255,255,255,0.5)"/>
      </svg>
    </div>
  </a>
  <ul class="navbar-links">
    <li><a href="#" class="active">Home</a></li>
    <li><a href="#pricing">Pricing</a></li>
    <li><a href="#features">How It Works</a></li>
    <li><a href="#about">About</a></li>
    <li><a href="#contact">Contact</a></li>
  </ul>
  <a href="#contact" class="navbar-cta">Get Started →</a>
  <button class="navbar-burger" id="navBurger" aria-label="Open menu">
    <span></span><span></span><span></span>
  </button>
</nav>

<div class="navbar-mobile-menu" id="mobileMenu">
  <a href="#">Home</a>
  <a href="#pricing">Pricing</a>
  <a href="#features">How It Works</a>
  <a href="#about">About</a>
  <a href="#contact">Contact</a>
  <a href="#contact" class="mob-cta">🚀 Get Started</a>
</div>
<!-- ══════════ END NAVBAR ══════════ -->

<!-- Background orbs -->
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<div class="orb orb-3"></div>

<main>
  <div class="left-col">
    <h1>Your growth journey<br/><em>starts right here,</em><br/><span class="highlight">right now.</span></h1>
    <p class="subtitle">We've received your request! Expect a personalized demo crafted around your business, your customers, and your goals.</p>
    <div class="rule"><div class="rule-line"></div><span class="rule-icon">✦</span></div>
    <ul class="check-list">
      <li><span class="check-icon">✓</span><div><strong>Response within 24 hours</strong> — Our specialist will contact you via email or call.</div></li>
      <li><span class="check-icon">✓</span><div>Learn how 10,500+ businesses achieved <strong>3× higher engagement</strong> with Netclix.</div></li>
      <li><span class="check-icon">✓</span><div>Join leading brands scaling smarter in email marketing worldwide.</div></li>
    </ul>
  </div>

  <div class="right-col">
    <div class="company-card">
      <div class="card-header">
        <div class="success-badge">🎯</div>
        <h2>Brands that trust Email Marketing</h2>
        <p>10,500+ global brands across retail, finance, travel, and e-commerce.</p>
      </div>
      <div class="stats-row">
        <div class="stat-item"><div class="stat-num">10,500+</div><div class="stat-label">Global Brands</div></div>
        <div class="stat-item"><div class="stat-num">25B+</div><div class="stat-label">Emails / Month</div></div>
        <div class="stat-item"><div class="stat-num">3×</div><div class="stat-label">Avg. ROI Uplift</div></div>
      </div>
      <div class="card-divider"></div>
      <p class="section-label">Email Marketing is Trusted by industry leaders</p>

      <div class="logos-grid">
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_1.webp"  alt="Brand 1"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_2.webp"  alt="Brand 2"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_3.webp"  alt="Brand 3"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_5.webp"  alt="Brand 5"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_6.webp"  alt="Brand 6"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_7.webp"  alt="Brand 7"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_8.webp"  alt="Brand 8"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_9.webp"  alt="Brand 9"  loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_10.webp" alt="Brand 10" loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_11.webp" alt="Brand 11" loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_12.webp" alt="Brand 12" loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_13.webp" alt="Brand 13" loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_14.webp" alt="Brand 14" loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_15.webp" alt="Brand 15" loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_16.webp" alt="Brand 16" loading="lazy" referrerpolicy="no-referrer"/></div>
        <div class="logo-cell"><img src="https://netclix.pages.dev/logo_17.webp" alt="Brand 17" loading="lazy" referrerpolicy="no-referrer"/></div>
      </div>
    </div>
  </div>
</main>

<!-- ══════════ FOOTER ══════════ -->
<footer class="footer">
  <div class="container">
    <div class="footer-grid">

      <!-- Brand + Contact -->
      <div class="footer-brand">
   <div class="footer-logo">
          <div class="logo-hex sm">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
              <path d="M12 2L22 7V17L12 22L2 17V7L12 2Z" fill="white" opacity="0.9"/>
            </svg>
          </div>
          <span>NETCLIX</span>
        </div>
        <p>AI-native email marketing. Supercharge your email conversion rate.</p>

        <div class="footer-contact-cards">
          <a href="mailto:info@netclixcloud.com" class="fcc">
            <div class="fcc-icon">✉</div>
            <div class="fcc-text">
              <strong>info@netclixcloud.com</strong>
              <span>Email us anytime</span>
            </div>
          </a>
          <a href="tel:+917065580729" class="fcc">
            <div class="fcc-icon">📞</div>
            <div class="fcc-text">
              <strong>+91 7065580729</strong>
              <span>Mon–Sat, 10am–6pm IST</span>
            </div>
          </a>
          <a href="tel:+918922870543" class="fcc">
            <div class="fcc-icon">📞</div>
            <div class="fcc-text">
              <strong>+91 8922870543</strong>
              <span>Mon–Sat, 10am–6pm IST</span>
          </div>
        </div>

        <div class="fsoc">
          <a href="#" class="fs-a">𝕏</a>
          <a href="#" class="fs-a">in</a>
          <a href="#" class="fs-a">▶</a>
          <a href="#" class="fs-a">f</a>
        </div>
      </div>

      <div class="fc">
        <h5>Menu</h5>
        <a href="#">Home</a>
        <a href="#">About</a>
        <a href="#">Services</a>
        <a href="#">Blog</a>
        <a href="#contact">Contact</a>
      </div>

      <div class="fc">
        <h5>Services</h5>
        <a href="#">Email Marketing</a>
        <a href="#">AMP Emails</a>
        <a href="#">AI Platform</a>
        <a href="#">Automation</a>
        <a href="#">Analytics</a>
        <a href="#pricing">Pricing</a>
      </div>

      <div class="fc">
        <h5>Company</h5>
        <a href="#">About</a>
        <a href="#">Customers</a>
        <a href="#">Careers</a>
        <a href="#">Blog</a>
        <a href="#">Press</a>
        <a href="#">Partners</a>
      </div>

      <div class="fc">
        <h5>Support</h5>
        <a href="#">Help Center</a>
        <a href="#">Community</a>
        <a href="#">Contact</a>
        <a href="#">Security</a>
        <a href="#">GDPR</a>
        <a href="#">CCPA</a>
      </div>

    </div>

    <div class="footer-bottom">
      <span>© 2026 Netclix Cloud. All rights reserved.</span>
      <div>
        <a href="#">Privacy</a>
        <a href="#">Terms</a>
        <a href="#">Cookies</a>
      </div>
    </div>
  </div>
</footer>
<!-- ══════════ END FOOTER ══════════ -->

<!-- ══════════ SCRIPTS ══════════ -->
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.5.1/dist/confetti.browser.min.js"></script>

<script>
/* ── Confetti on load ── */
window.addEventListener('load', function () {
  var duration = 3 * 1000;
  var end = Date.now() + duration;
  (function frame() {
    confetti({ particleCount: 5, angle: 60,  spread: 55, origin: { x: 0 } });
    confetti({ particleCount: 5, angle: 120, spread: 55, origin: { x: 1 } });
    if (Date.now() < end) { requestAnimationFrame(frame); }
  })();
});

/* ── Navbar + Mobile Menu ── */
(function () {
  'use strict';
  var navbar  = document.getElementById('navbar');
  var burger  = document.getElementById('navBurger');
  var mobMenu = document.getElementById('mobileMenu');

  window.addEventListener('scroll', function () {
    navbar.classList.toggle('scrolled', window.pageYOffset > 40);
  }, { passive: true });

  document.querySelectorAll('a[href^="#"]').forEach(function (a) {
    a.addEventListener('click', function (e) {
      var id = this.getAttribute('href').slice(1);
      if (!id) return;
      var el = document.getElementById(id);
      if (el) {
        e.preventDefault();
        window.scrollTo({ top: el.getBoundingClientRect().top + window.pageYOffset - 72, behavior: 'smooth' });
        closeMob();
      }
    });
  });

  function closeMob() {
    burger.classList.remove('open');
    mobMenu.classList.remove('open');
    document.body.style.overflow = '';
  }

  burger.addEventListener('click', function () {
    var isOpen = mobMenu.classList.contains('open');
    if (isOpen) { closeMob(); }
    else { burger.classList.add('open'); mobMenu.classList.add('open'); document.body.style.overflow = 'hidden'; }
  });

  document.addEventListener('click', function (e) {
    if (mobMenu.classList.contains('open') && !mobMenu.contains(e.target) && !burger.contains(e.target)) closeMob();
  });

  window.addEventListener('resize', function () { if (window.innerWidth > 768) closeMob(); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeMob(); });
})();
</script>
<!-- ══════════ END SCRIPTS ══════════ -->

</body>
</html>
