<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>
<title>Netclix — Bulk Email Marketing Platform</title>
<link rel="icon" href="https://netclix.pages.dev/netclix-favicon.ico" sizes="any">
<meta name="theme-color" content="#c0151a">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;0,600;1,400&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
:root{
  --red:#c9181e;--red-2:#e8323a;--red-deep:#8b0a0e;--red-light:#ff4a52;
  --red-glow:rgba(201,24,30,0.38);
  --bg:#0b0809;--bg-2:#100c0d;--surface:#17100f;--surface-2:#1e1413;
  --border:rgba(255,255,255,0.07);--border-red:rgba(201,24,30,0.22);
  --text:#f5eeee;--muted:#9e8f8f;
  --nav-h:64px;
}
*{margin:0;padding:0;box-sizing:border-box;}
html{scroll-behavior:smooth;overflow-x:hidden;}
a{text-decoration:none;color:inherit;}
ul{list-style:none;}
img{max-width:100%;display:block;}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);overflow-x:hidden;max-width:100vw;}
body::before{content:'';position:fixed;inset:0;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='1'/%3E%3C/svg%3E");opacity:0.035;z-index:0;pointer-events:none;}
section{padding:100px 24px;position:relative;}
.container{max-width:1200px;margin:0 auto;position:relative;width:100%;}

/* ============================
   NAVBAR
   ============================ */
nav{
  position:fixed;top:0;left:0;width:100%;
  background:rgba(11,8,9,0.82);
  backdrop-filter:blur(22px) saturate(1.4);
  border-bottom:1px solid var(--border);
  z-index:998;padding:0 32px;
  transition:box-shadow 0.3s,background 0.3s;
}
nav.scrolled{
  background:rgba(11,8,9,0.95);
  box-shadow:0 4px 40px rgba(201,24,30,0.12);
  border-bottom-color:var(--border-red);
}
.nav-wrap{
  display:flex;align-items:center;
  justify-content:space-between;
  height:var(--nav-h);position:relative;
}
.nav-logo img{
  height:44px;display:block;
  transition:transform 0.3s;
  filter:drop-shadow(0 0 12px rgba(201,24,30,0.3));
}
.nav-logo img:hover{transform:scale(1.05);}

/* Desktop nav links */
.nav-links{display:flex;gap:32px;align-items:center;}
.nav-links li a{
  position:relative;padding:6px 0;
  font-family:'DM Sans',sans-serif;
  font-weight:500;font-size:0.9rem;
  color:white;transition:color 0.3s;letter-spacing:0.01em;
}
.nav-links li a::after{
  content:'';position:absolute;left:0;bottom:-2px;
  width:0%;height:1.5px;
  background:linear-gradient(90deg,var(--red),var(--red-light));
  transition:width 0.35s;border-radius:2px;
}
.nav-links li a:hover::after{width:100%;}
.nav-end a{
  padding:10px 24px;
  background:linear-gradient(135deg,var(--red-deep),var(--red));
  color:#fff;border-radius:6px;
  font-family:'Syne',sans-serif;font-weight:700;
  font-size:0.85rem;letter-spacing:0.05em;
  text-transform:uppercase;
  box-shadow:0 4px 20px var(--red-glow);
  border:1px solid rgba(255,255,255,0.08);
  transition:transform 0.2s,box-shadow 0.3s;
}
.nav-end a:hover{transform:translateY(-2px);box-shadow:0 6px 30px rgba(201,24,30,0.55);}

/* Hamburger — hidden by default on desktop */
.brgr{
  display:none;
  flex-direction:column;justify-content:space-between;
  width:28px;height:20px;
  background:none;border:none;cursor:pointer;padding:0;
  -webkit-tap-highlight-color:transparent;
  z-index:999;
  margin-left:auto;
  flex-shrink:0;
}
.brgr span{
  display:block;height:2px;width:100%;
  background:var(--text);border-radius:2px;
  transition:0.3s;
}

/* Mobile dropdown */
.nav-links.mob-open{
  display:flex !important;
  flex-direction:column;gap:0;
  position:fixed;
  top:var(--nav-h);
  left:0;right:0;
  background:rgba(15,10,10,0.98);
  border-bottom:1px solid var(--border-red);
  box-shadow:0 20px 60px rgba(0,0,0,0.8);
  padding:8px 0 16px;
  backdrop-filter:blur(20px);
  animation:dropDown 0.22s cubic-bezier(0.16,1,0.3,1);
  z-index:997;
  max-height:calc(100vh - var(--nav-h));
  overflow-y:auto;
}
@keyframes dropDown{from{opacity:0;transform:translateY(-10px);}to{opacity:1;transform:translateY(0);}}
.nav-links.mob-open li a{
  display:block;padding:14px 24px;
  font-size:1rem;color:var(--text);
  border-bottom:1px solid rgba(255,255,255,0.04);
  transition:color 0.2s,background 0.2s,padding-left 0.2s;
}
.nav-links.mob-open li:last-child a{border-bottom:none;}
.nav-links.mob-open li a:hover{
  color:var(--red-light);
  background:rgba(201,24,30,0.06);
  padding-left:32px;
}
.nav-links.mob-open li a::after{display:none !important;}

/* ============================
   HERO
   ============================ */
.hero{
  position:relative;display:flex;align-items:center;
  justify-content:center;min-height:100svh;
  text-align:center;
  background:var(--bg);
  padding:calc(var(--nav-h) + 40px) 24px 60px;
  width:100%;
  clip-path:inset(0);
}
.hero::before{
  content:'';position:absolute;inset:0;
  background-image:linear-gradient(rgba(255,255,255,0.025) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,0.025) 1px,transparent 1px);
  background-size:72px 72px;
  mask-image:radial-gradient(ellipse 80% 80% at 50% 50%,black 20%,transparent 80%);
  z-index:0;
}
.hero::after{
  content:'';position:absolute;width:800px;height:500px;
  top:50%;left:50%;transform:translate(-50%,-55%);
  background:radial-gradient(ellipse,rgba(180,10,15,0.2) 0%,transparent 68%);
  z-index:0;animation:hPulse 8s ease-in-out infinite;
}
@keyframes hPulse{0%,100%{opacity:0.8;transform:translate(-50%,-55%) scale(1);}50%{opacity:1;transform:translate(-50%,-55%) scale(1.08);}}
.h-orb{position:absolute;border-radius:50%;filter:blur(90px);pointer-events:none;z-index:0;}
.h-orb-1{width:560px;height:560px;background:radial-gradient(circle,rgba(180,10,15,0.16),transparent 70%);top:-100px;left:-160px;animation:orbF 12s ease-in-out infinite;}
.h-orb-2{width:420px;height:420px;background:radial-gradient(circle,rgba(220,50,60,0.1),transparent 70%);top:80px;right:-100px;animation:orbF 10s ease-in-out infinite reverse;}
.h-orb-3{width:380px;height:380px;background:radial-gradient(circle,rgba(140,5,10,0.09),transparent 70%);bottom:-60px;left:40%;animation:orbF 14s ease-in-out infinite 3s;}
@keyframes orbF{0%,100%{transform:translateY(0);}50%{transform:translateY(-28px);}}

/* Floating stat cards */
.hfc{position:absolute;z-index:4;background:rgba(8,5,5,0.94);border:1px solid rgba(255,255,255,0.09);border-radius:12px;box-shadow:0 24px 70px rgba(0,0,0,0.85),0 0 0 1px rgba(255,255,255,0.03),inset 0 1px 0 rgba(255,255,255,0.05);backdrop-filter:blur(24px);pointer-events:none;padding:22px 24px 20px;min-width:180px;width:190px;}
.hfc-left{left:3%;top:36%;opacity:0;animation:flyL 1.1s cubic-bezier(0.16,1,0.3,1) 0.8s forwards,bobL 6s ease-in-out 2.1s infinite;}
@keyframes flyL{0%{opacity:0;transform:translateX(-260px) translateY(40px) rotate(-14deg) scale(0.6);}50%{opacity:1;transform:translateX(12px) translateY(-6px) rotate(2deg) scale(1.03);}72%{transform:translateX(-4px) translateY(2px) rotate(-0.5deg) scale(0.99);}100%{opacity:1;transform:translateX(0) translateY(0) rotate(0deg) scale(1);}}
@keyframes bobL{0%,100%{transform:translateY(0);}40%{transform:translateY(-13px);}70%{transform:translateY(-5px);}}
.hfc-right{right:3%;top:44%;opacity:0;animation:flyR 1.1s cubic-bezier(0.16,1,0.3,1) 1.1s forwards,bobR 7s ease-in-out 2.4s infinite;}
@keyframes flyR{0%{opacity:0;transform:translateX(260px) translateY(40px) rotate(14deg) scale(0.6);}50%{opacity:1;transform:translateX(-12px) translateY(-6px) rotate(-2deg) scale(1.03);}72%{transform:translateX(4px) translateY(2px) rotate(0.5deg) scale(0.99);}100%{opacity:1;transform:translateX(0) translateY(0) rotate(0deg) scale(1);}}
@keyframes bobR{0%,100%{transform:translateY(0);}35%{transform:translateY(-16px);}65%{transform:translateY(-6px);}}
.hfc-lbl{font-family:'DM Mono',monospace;font-size:0.6rem;text-transform:uppercase;letter-spacing:0.12em;color:var(--muted);margin-bottom:7px;}
.hfc-val{font-family:'Syne',sans-serif;font-weight:800;font-size:2.1rem;color:var(--text);line-height:1;margin-bottom:11px;}
.hfc-badge{display:inline-flex;align-items:center;gap:5px;background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.18);color:#34d399;font-family:'DM Mono',monospace;font-size:0.6rem;font-weight:600;padding:5px 10px;border-radius:6px;}
.hfc-bdot{width:6px;height:6px;border-radius:50%;background:#34d399;flex-shrink:0;animation:bpulse 1.4s ease-in-out infinite;}
@keyframes bpulse{0%,100%{opacity:1;transform:scale(1);}50%{opacity:0.3;transform:scale(1.8);}}

#heroCanvas{position:absolute;inset:0;width:100%;height:100%;z-index:1;pointer-events:none;opacity:0;transition:opacity 1.4s ease;}
#heroCanvas.visible{opacity:1;}

/* Envelopes */
.env{position:absolute;z-index:3;pointer-events:none;opacity:0;filter:drop-shadow(0 8px 24px rgba(201,24,30,0.4));}
.env-1{top:18%;left:6%;width:72px;animation:envFly1 1.1s cubic-bezier(0.16,1,0.3,1) 0.7s forwards;}
@keyframes envFly1{0%{opacity:0;transform:translate(-420px,-180px) rotate(-35deg) scale(0.4);}55%{opacity:1;transform:translate(8px,4px) rotate(3deg) scale(1.05);}72%{transform:translate(-3px,-2px) rotate(-1deg) scale(0.98);}100%{opacity:1;transform:translate(0,0) rotate(-6deg) scale(1);}}
.env-2{bottom:22%;right:7%;width:54px;animation:envFly2 1s cubic-bezier(0.16,1,0.3,1) 1.0s forwards;}
@keyframes envFly2{0%{opacity:0;transform:translate(380px,200px) rotate(28deg) scale(0.35);}55%{opacity:1;transform:translate(-6px,-5px) rotate(-3deg) scale(1.06);}72%{transform:translate(3px,2px) rotate(1deg) scale(0.97);}100%{opacity:1;transform:translate(0,0) rotate(5deg) scale(1);}}
.env-3{top:14%;right:12%;width:38px;animation:envFly3 0.9s cubic-bezier(0.16,1,0.3,1) 1.3s forwards;}
@keyframes envFly3{0%{opacity:0;transform:translate(200px,-320px) rotate(20deg) scale(0.3);}55%{opacity:1;transform:translate(-4px,5px) rotate(-2deg) scale(1.08);}72%{transform:translate(2px,-2px) rotate(1deg) scale(0.97);}100%{opacity:1;transform:translate(0,0) rotate(8deg) scale(1);}}
.env-4{bottom:18%;left:10%;width:30px;animation:envFly4 0.85s cubic-bezier(0.16,1,0.3,1) 1.55s forwards;}
@keyframes envFly4{0%{opacity:0;transform:translate(-280px,280px) rotate(-22deg) scale(0.3);}55%{opacity:1;transform:translate(5px,-5px) rotate(3deg) scale(1.1);}72%{transform:translate(-2px,2px) rotate(-1deg) scale(0.97);}100%{opacity:1;transform:translate(0,0) rotate(-10deg) scale(1);}}

/* Hero content */
.hero-content{
  position:relative;z-index:5;
  width:100%;max-width:700px;
  margin:0 auto;
  padding:0 8px;
  box-sizing:border-box;
}
.h-eyebrow{display:inline-flex;align-items:center;gap:8px;background:rgba(201,24,30,0.08);border:1px solid rgba(201,24,30,0.28);color:#f0e8e8;font-family:'DM Mono',monospace;font-size:0.7rem;font-weight:500;letter-spacing:0.12em;text-transform:uppercase;padding:8px 16px;border-radius:4px;margin-bottom:28px;opacity:0;animation:fadeUp 0.8s cubic-bezier(0.16,1,0.3,1) 0.1s forwards;}
.h-eyebrow-dot{width:6px;height:6px;border-radius:50%;background:#ff7a80;display:block;animation:bpulse 1.6s ease-in-out infinite;}
.hero h1{
  font-family:'Syne',sans-serif;
  font-size:clamp(2.2rem,8vw,5.2rem);
  font-weight:800;line-height:1.08;
  letter-spacing:-0.025em;
  color:var(--text);
  margin-bottom:24px;
  opacity:0;
  animation:fadeUp 0.9s cubic-bezier(0.16,1,0.3,1) 0.25s forwards;
  word-break:keep-all;
  overflow-wrap:normal;
  min-height:3.3em;
}
#tw-line1,#tw-line2,#tw-line3{display:block;min-height:1.08em;}
.h-grad{background:linear-gradient(115deg,#ff6b70,var(--red-light),#c9181e,#8b0a0e);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;background-size:200% auto;animation:gradS 4s linear infinite;}
@keyframes gradS{0%{background-position:0% center;}100%{background-position:200% center;}}
.h-ul{position:relative;display:inline-block;}
.h-ul::after{content:'';position:absolute;left:0;bottom:-4px;width:100%;height:3px;background:linear-gradient(90deg,var(--red),var(--red-light));border-radius:2px;transform:scaleX(0);transform-origin:left;transition:transform 0.6s cubic-bezier(0.16,1,0.3,1);}
.h-ul.line-on::after{transform:scaleX(1);}
.tw-cur{display:inline-block;width:3px;height:0.85em;background:var(--red-light);border-radius:2px;vertical-align:middle;margin-left:2px;animation:curBlink 0.85s step-end infinite;}
@keyframes curBlink{0%,100%{opacity:1;}50%{opacity:0;}}
.hero p{font-family:'DM Sans',sans-serif;font-size:clamp(0.93rem,1.7vw,1.1rem);font-weight:400;color:var(--muted);max-width:500px;margin:0 auto 40px;line-height:1.78;opacity:0;animation:fadeUp 0.9s cubic-bezier(0.16,1,0.3,1) 0.4s forwards;}
.hero-btns{display:flex;gap:12px;justify-content:center;flex-wrap:wrap;opacity:0;animation:fadeUp 0.9s cubic-bezier(0.16,1,0.3,1) 0.55s forwards;}
.btn-primary{padding:14px 30px;background:linear-gradient(135deg,var(--red-deep),var(--red),var(--red-2));background-size:200% auto;color:#fff;border-radius:7px;font-family:'Syne',sans-serif;font-weight:700;font-size:0.88rem;letter-spacing:0.04em;text-transform:uppercase;box-shadow:0 4px 28px var(--red-glow),inset 0 1px 0 rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.07);transition:transform 0.2s,box-shadow 0.3s;position:relative;overflow:hidden;}
.btn-primary::before{content:'';position:absolute;top:0;left:-120%;width:60%;height:100%;background:linear-gradient(90deg,transparent,rgba(255,255,255,0.22),transparent);transform:skewX(-18deg);animation:shimmer 3.5s ease-in-out infinite 2s;}
@keyframes shimmer{0%{left:-120%}100%{left:220%}}
.btn-primary:hover{transform:translateY(-3px);box-shadow:0 8px 40px rgba(201,24,30,0.55);}
.btn-outline{padding:14px 30px;border:1px solid rgba(201,24,30,0.35);color:var(--text);border-radius:7px;font-family:'Syne',sans-serif;font-weight:600;font-size:0.86rem;letter-spacing:0.04em;text-transform:uppercase;background:rgba(201,24,30,0.04);transition:0.3s;}
.btn-outline:hover{border-color:var(--red-light);color:var(--red-light);background:rgba(201,24,30,0.1);transform:translateY(-3px);}
.hero-stats{display:flex;gap:32px;justify-content:center;margin-top:56px;opacity:0;animation:fadeUp 0.9s cubic-bezier(0.16,1,0.3,1) 0.7s forwards;}
.h-stat{text-align:center;}
.h-stat .num{font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;background:linear-gradient(120deg,#ff6b70,var(--red-light));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;display:block;}
.h-stat .lbl{font-family:'DM Mono',monospace;font-size:0.67rem;color:var(--muted);margin-top:3px;letter-spacing:0.08em;text-transform:uppercase;}
.stat-sep{width:1px;background:var(--border);align-self:stretch;}

/* ============================
   BRANDS
   ============================ */
.brands-section{background:var(--surface);border-top:1px solid var(--border);border-bottom:1px solid var(--border);padding:80px 24px;text-align:center;position:relative;overflow:hidden;}
.brands-section::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse 60% 140% at 50% 0%,rgba(201,24,30,0.06),transparent);}
.section-label{font-family:'DM Mono',monospace;font-size:0.76rem;color:var(--muted);margin-bottom:44px;text-transform:uppercase;letter-spacing:0.1em;display:flex;align-items:center;justify-content:center;gap:14px;flex-wrap:wrap;}
.section-label::before,.section-label::after{content:'';flex:1;max-width:80px;height:1px;background:linear-gradient(90deg,transparent,var(--border));}
.section-label::after{background:linear-gradient(90deg,var(--border),transparent);}
.section-label .t-num{color:var(--red-light);font-weight:500;}
.brands-grid{display:grid;grid-template-columns:repeat(5,1fr);border:1px solid var(--border);border-radius:12px;overflow:hidden;max-width:900px;margin:0 auto;}
.brands-grid img{width:100%;height:110px;object-fit:contain;padding:22px 32px;opacity:0.4;filter:grayscale(1) brightness(2);background:var(--surface-2);border-right:1px solid var(--border);border-bottom:1px solid var(--border);transition:opacity 0.35s,filter 0.35s,background 0.3s,transform 0.3s;}
.brands-grid img:nth-child(5n){border-right:none;}
.brands-grid img:nth-last-child(-n+5){border-bottom:none;}
.brands-grid img:hover{opacity:1;filter:grayscale(0) brightness(1);background:var(--surface);transform:scale(1.07);z-index:1;position:relative;}

/* ============================
   SHARED SECTION ELEMENTS
   ============================ */
.sec-chip{display:inline-block;background:rgba(201,24,30,0.1);border:1px solid rgba(201,24,30,0.25);color:var(--red-light);font-family:'DM Mono',monospace;font-size:0.68rem;font-weight:500;letter-spacing:0.12em;text-transform:uppercase;padding:5px 14px;border-radius:4px;margin-bottom:16px;}
.sec-title{font-family:'Syne',sans-serif;font-size:clamp(1.85rem,3.8vw,3rem);font-weight:800;letter-spacing:-0.025em;line-height:1.1;color:var(--text);margin-bottom:14px;}
.sec-sub{font-family:'DM Sans',sans-serif;color:var(--muted);font-size:1rem;max-width:500px;line-height:1.7;}

/* ============================
   FEATURES
   ============================ */
.feat-sec{background:var(--bg-2);}
.bento{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;margin-top:52px;}
.bc{background:var(--surface);border:1px solid var(--border);padding:32px;border-radius:12px;position:relative;overflow:hidden;transition:transform 0.4s cubic-bezier(0.16,1,0.3,1),box-shadow 0.4s;opacity:0;transform:translateY(28px);}
.bc:hover{transform:translateY(-10px) scale(1.015);box-shadow:0 20px 60px rgba(0,0,0,0.4),0 0 0 1px var(--border-red);}
.bc::after{content:'';position:absolute;width:220px;height:220px;top:-80px;right:-80px;background:radial-gradient(circle,rgba(201,24,30,0.12),transparent 70%);border-radius:50%;transition:opacity 0.4s;opacity:0;}
.bc:hover::after{opacity:1;}
.bc-accent{position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--red),var(--red-light));transform:scaleX(0);transform-origin:left;transition:transform 0.45s cubic-bezier(0.16,1,0.3,1);}
.bc:hover .bc-accent{transform:scaleX(1);}
.bc-icon{width:52px;height:52px;background:rgba(201,24,30,0.1);border:1px solid rgba(201,24,30,0.2);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;margin-bottom:20px;}
.bc h3{font-family:'Syne',sans-serif;font-size:1.05rem;font-weight:700;margin-bottom:10px;color:var(--text);}
.bc p{font-family:'DM Sans',sans-serif;font-size:0.91rem;color:var(--muted);line-height:1.75;}

/* ============================
   PRICING
   ============================ */
.price-sec{background:var(--surface);}
.price-sec-inner{text-align:center;}
.price-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-top:48px;}
.price-card{background:var(--surface-2);border:1px solid var(--border);padding:30px;border-radius:12px;position:relative;transition:transform 0.4s cubic-bezier(0.16,1,0.3,1),box-shadow 0.4s;opacity:0;transform:translateY(28px);}
.price-card:hover{transform:translateY(-8px);box-shadow:0 20px 60px rgba(0,0,0,0.4);}
.price-card.pc-hot{background:linear-gradient(160deg,rgba(201,24,30,0.08),rgba(139,10,14,0.04));border-color:rgba(201,24,30,0.4);box-shadow:0 4px 30px rgba(201,24,30,0.1);}
.price-card.pc-hot:hover{box-shadow:0 20px 60px rgba(201,24,30,0.25);}
.pc-badge{position:absolute;top:-1px;right:22px;background:linear-gradient(135deg,var(--red-deep),var(--red));color:#fff;font-family:'DM Mono',monospace;font-size:0.62rem;font-weight:500;padding:5px 12px;border-radius:0 0 8px 8px;text-transform:uppercase;letter-spacing:0.1em;}
.pc-name{font-family:'DM Mono',monospace;font-size:0.7rem;font-weight:500;color:var(--muted);text-transform:uppercase;letter-spacing:0.12em;margin-bottom:8px;}
.pc-price-row{font-family:'Syne',sans-serif;font-size:1.85rem;font-weight:800;color:var(--text);margin:10px 0 22px;line-height:1;}
.pc-price-row span{font-family:'DM Sans',sans-serif;font-size:0.76rem;color:var(--muted);font-weight:400;}
.price-card ul{margin-bottom:24px;}
.price-card ul li{padding:8px 0;display:flex;align-items:center;gap:9px;font-family:'DM Sans',sans-serif;font-size:0.86rem;color:var(--muted);border-bottom:1px solid var(--border);}
.price-card ul li:last-child{border-bottom:none;}
.price-card ul li::before{content:'';width:18px;height:18px;flex-shrink:0;background:rgba(201,24,30,0.12) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='8' viewBox='0 0 10 8'%3E%3Cpath d='M1 4l2.5 2.5L9 1' stroke='%23c9181e' stroke-width='1.6' fill='none' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E") no-repeat center;border-radius:50%;}
.pc-cta{display:block;width:100%;text-align:center;padding:12px;border-radius:6px;font-family:'Syne',sans-serif;font-weight:700;font-size:0.8rem;letter-spacing:0.05em;text-transform:uppercase;transition:0.3s;}
.pc-cta-solid{background:linear-gradient(135deg,var(--red-deep),var(--red));color:#fff;box-shadow:0 4px 20px var(--red-glow);}
.pc-cta-solid:hover{box-shadow:0 6px 32px rgba(201,24,30,0.55);transform:translateY(-2px);}
.pc-cta-outline{border:1px solid var(--border-red);color:var(--muted);}
.pc-cta-outline:hover{border-color:var(--red-light);color:var(--red-light);background:rgba(201,24,30,0.06);}

/* ============================
   TESTIMONIALS
   ============================ */
.testi-sec{background:var(--bg-2);}
.testi-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-top:48px;}
.tcard{background:var(--surface);border:1px solid var(--border);padding:28px;border-radius:12px;transition:transform 0.4s cubic-bezier(0.16,1,0.3,1),box-shadow 0.4s;opacity:0;transform:translateY(28px);position:relative;overflow:hidden;}
.tcard::before{content:'❝';position:absolute;top:14px;right:20px;font-size:4rem;color:rgba(201,24,30,0.06);font-family:serif;line-height:1;}
.tcard:hover{transform:translateY(-8px);box-shadow:0 16px 50px rgba(0,0,0,0.4),0 0 0 1px var(--border-red);}
.tcard-stars{color:var(--red-light);font-size:0.85rem;letter-spacing:3px;margin-bottom:14px;}
.tcard p{font-family:'DM Sans',sans-serif;font-size:0.93rem;color:rgba(245,238,238,0.75);line-height:1.8;margin-bottom:20px;font-style:italic;}
.tcard-author{display:flex;align-items:center;gap:12px;}
.tcard-avatar{width:44px;height:44px;background:linear-gradient(135deg,var(--red-deep),var(--red));border-radius:50%;display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-weight:700;font-size:0.82rem;color:#fff;border:2px solid rgba(201,24,30,0.3);flex-shrink:0;}
.tcard-info strong{display:block;font-family:'Syne',sans-serif;font-size:0.88rem;color:var(--text);font-weight:700;}
.tcard-info span{font-family:'DM Mono',monospace;font-size:0.7rem;color:var(--muted);}
.tcard-metric{margin-top:18px;background:rgba(201,24,30,0.06);border:1px solid rgba(201,24,30,0.15);border-radius:7px;padding:11px 14px;display:flex;justify-content:space-between;align-items:center;}
.tcard-metric span:first-child{font-family:'DM Mono',monospace;font-size:0.68rem;color:var(--muted);text-transform:uppercase;letter-spacing:0.08em;}
.tcard-metric span:last-child{font-family:'Syne',sans-serif;font-weight:800;color:var(--red-light);font-size:1.1rem;}

/* ============================
   CONTACT
   ============================ */
.contact-sec{background:var(--surface);}
.contact-grid{display:grid;grid-template-columns:1fr 1.6fr;gap:60px;align-items:start;}
.contact-info p{font-family:'DM Sans',sans-serif;color:var(--muted);margin-bottom:36px;font-size:0.97rem;line-height:1.75;}
.c-feature{display:flex;gap:14px;align-items:flex-start;margin-bottom:22px;}
.c-icon{width:46px;height:46px;background:rgba(201,24,30,0.1);border:1px solid rgba(201,24,30,0.2);border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;}
.c-text strong{display:block;font-family:'Syne',sans-serif;font-size:0.9rem;color:var(--text);margin-bottom:3px;font-weight:700;}
.c-text span{font-family:'DM Sans',sans-serif;font-size:0.82rem;color:var(--muted);}
.contact-form{background:var(--surface-2);border:1px solid var(--border-red);padding:36px;border-radius:12px;box-shadow:0 0 60px rgba(201,24,30,0.06);position:relative;overflow:hidden;}
.contact-form::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--red),var(--red-light),var(--red),transparent);}
.contact-form h3{font-family:'Syne',sans-serif;font-size:1.25rem;font-weight:800;margin-bottom:24px;color:var(--text);}
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.contact-sec input,.contact-sec select{width:100%;padding:12px 14px;border-radius:6px;border:1px solid var(--border);background:var(--surface);color:var(--text);font-family:'DM Sans',sans-serif;font-size:0.88rem;margin-bottom:12px;transition:0.3s;outline:none;}
.contact-sec input::placeholder{color:rgba(158,143,143,0.55);}
.contact-sec select{color:var(--muted);-webkit-appearance:none;}
.contact-sec input:focus,.contact-sec select:focus{border-color:rgba(201,24,30,0.5);box-shadow:0 0 0 3px rgba(201,24,30,0.1);background:rgba(201,24,30,0.03);}
.contact-sec button{width:100%;margin-top:4px;background:linear-gradient(135deg,var(--red-deep),var(--red),var(--red-2));color:#fff;padding:14px 28px;border:none;border-radius:6px;font-family:'Syne',sans-serif;font-weight:700;font-size:0.88rem;letter-spacing:0.05em;text-transform:uppercase;cursor:pointer;transition:0.3s;box-shadow:0 4px 24px var(--red-glow);position:relative;overflow:hidden;}
.contact-sec button::before{content:'';position:absolute;top:0;left:-120%;width:60%;height:100%;background:linear-gradient(90deg,transparent,rgba(255,255,255,0.2),transparent);transform:skewX(-18deg);transition:0.55s;}
.contact-sec button:hover::before{left:170%;}
.contact-sec button:hover{transform:translateY(-2px);box-shadow:0 8px 36px rgba(201,24,30,0.55);}

/* ============================
   FOOTER
   ============================ */
.footer{background:var(--bg);padding:80px 0 0;border-top:1px solid var(--border);position:relative;}
.footer::before{content:'';position:absolute;top:0;left:50%;transform:translateX(-50%);width:600px;height:1px;background:linear-gradient(90deg,transparent,rgba(201,24,30,0.5),transparent);}
.footer-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr 1fr;gap:36px;padding-bottom:48px;border-bottom:1px solid var(--border);}
.footer-logo{display:flex;align-items:center;gap:10px;font-family:'Syne',sans-serif;font-size:17px;font-weight:800;text-transform:uppercase;letter-spacing:0.05em;color:var(--text);margin-bottom:4px;}
.footer-logo .logo-hex{width:86px;height:56px;border-radius:8px;display:flex;align-items:center;justify-content:center;border:1px solid rgba(201,24,30,0.4);}
.footer-brand{display:flex;flex-direction:column;gap:16px;}
.footer-brand>p{font-family:'DM Sans',sans-serif;font-size:13px;color:var(--muted);line-height:1.7;max-width:220px;}
.footer-contact-cards{display:flex;flex-direction:column;gap:8px;}
.fcc{display:flex;align-items:center;gap:12px;padding:10px 14px;background:var(--surface);border:1px solid var(--border);border-radius:8px;text-decoration:none;transition:border-color 0.25s,transform 0.25s;}
.fcc:hover{border-color:rgba(201,24,30,0.4);transform:translateX(3px);}
.fcc-icon{width:30px;height:30px;border-radius:7px;background:rgba(201,24,30,0.1);border:1px solid rgba(201,24,30,0.2);display:flex;align-items:center;justify-content:center;flex-shrink:0;}
.fcc-text strong{display:block;font-family:'Syne',sans-serif;font-size:11px;font-weight:700;color:var(--text);}
.fcc-text span{font-family:'DM Mono',monospace;font-size:9px;color:var(--muted);text-transform:uppercase;letter-spacing:0.06em;}
.fsoc{display:flex;flex-direction:row;flex-wrap:wrap;gap:8px;}
.fs-a{width:34px;height:34px;border-radius:50%;background:var(--surface);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;font-family:'Syne',sans-serif;color:var(--muted);text-decoration:none;transition:background 0.25s,color 0.25s,transform 0.25s,border-color 0.25s;}
.fs-a:hover{background:var(--red);border-color:var(--red);color:#fff;transform:translateY(-2px);}
.fc{display:flex;flex-direction:column;gap:10px;}
.fc h5{font-family:'DM Mono',monospace;font-size:9px;font-weight:500;text-transform:uppercase;letter-spacing:0.14em;color:var(--red-light);margin-bottom:6px;}
.fc a{font-family:'DM Sans',sans-serif;font-size:13px;color:var(--muted);transition:color 0.2s,transform 0.2s;display:inline-block;}
.fc a:hover{color:var(--text);transform:translateX(3px);}
.footer-bottom{display:flex;align-items:center;justify-content:space-between;padding:20px 0;font-family:'DM Mono',monospace;font-size:11px;color:rgba(158,143,143,0.5);letter-spacing:0.04em;}
.footer-bottom div{display:flex;gap:18px;}
.footer-bottom a{color:rgba(158,143,143,0.5);transition:color 0.2s;}
.footer-bottom a:hover{color:var(--red-light);}

@keyframes fadeUp{to{opacity:1;transform:translateY(0);}}

/* ============================================================
   RESPONSIVE
   ============================================================ */
@media(max-width:1200px){
  .price-grid{grid-template-columns:repeat(2,1fr);}
  .footer-grid{grid-template-columns:1.5fr 1fr 1fr 1fr;gap:28px;}
}
@media(max-width:1024px){
  nav{padding:0 24px;}
  .nav-links{gap:20px;}
  .nav-links li a{font-size:0.85rem;}
  .footer-grid{grid-template-columns:1fr 1fr 1fr;gap:24px;}
  .footer-brand{grid-column:1/-1;}
  .hfc-left{left:1%;width:172px;}
  .hfc-right{right:1%;width:172px;}
}
@media(pointer:coarse),(max-width:900px){
  nav{padding:0 16px;}
  .nav-links{display:none !important;}
  .nav-end{display:none !important;}
  .brgr{display:flex !important;}
  .hfc,.env{display:none;}
  .nav-logo img{height:38px;}
  :root{--nav-h:56px;}
}
@media(max-width:768px){
  section{padding:80px 20px;}
  .hero{padding:calc(var(--nav-h) + 32px) 20px 48px;}
  .bento{grid-template-columns:1fr 1fr;gap:14px;}
  .testi-grid{grid-template-columns:1fr 1fr;gap:16px;}
  .contact-grid{grid-template-columns:1fr;gap:28px;}
  .price-grid{grid-template-columns:1fr 1fr;}
  .brands-grid{grid-template-columns:repeat(3,1fr);}
  .brands-grid img:nth-child(3n){border-right:none;}
  .brands-grid img:nth-last-child(-n+3){border-bottom:none;}
  .footer-grid{grid-template-columns:1fr 1fr;gap:20px;}
  .footer-brand{grid-column:1/-1;}
  .footer-bottom{flex-direction:column;gap:10px;text-align:center;}
  .footer-bottom div{justify-content:center;}
}
@media(max-width:600px){
  section{padding:60px 16px;}
  nav{padding:0 14px;}
  .nav-links.mob-open{border-radius:0;}
  .hero{padding:calc(var(--nav-h) + 28px) 16px 44px;}
  .hero h1{font-size:clamp(1.9rem,8.5vw,2.8rem);}
  .hero p{font-size:0.9rem;}
  .h-eyebrow{font-size:0.62rem;padding:7px 12px;letter-spacing:0.08em;}
  .hero-btns{flex-direction:column;align-items:center;gap:10px;}
  .btn-primary,.btn-outline{width:100%;max-width:100%;text-align:center;padding:14px 18px;font-size:0.84rem;}
  .hero-stats{display:grid;grid-template-columns:1fr 1fr;gap:16px 8px;margin-top:32px;}
  .stat-sep{display:none;}
  .h-stat .num{font-size:1.55rem;}
  .h-stat .lbl{font-size:0.6rem;}
  .bento{grid-template-columns:1fr;gap:12px;}
  .bc{padding:22px;}
  .price-grid{grid-template-columns:1fr;gap:14px;}
  .testi-grid{grid-template-columns:1fr;gap:12px;}
  .tcard{padding:20px;}
  .brands-grid{grid-template-columns:repeat(2,1fr);}
  .brands-grid img{height:80px;padding:14px 18px;}
  .brands-grid img:nth-child(2n){border-right:none;}
  .brands-grid img:nth-last-child(-n+2){border-bottom:none;}
  .contact-form{padding:20px 14px;}
  .form-row{grid-template-columns:1fr;}
  .contact-sec input,.contact-sec select{margin-bottom:10px;}
  .footer{padding:48px 0 0;}
  .footer-grid{grid-template-columns:1fr;gap:20px;}
  .footer-brand{grid-column:1;}
  .footer-bottom{flex-direction:column;gap:10px;text-align:center;}
  .footer-bottom div{justify-content:center;}
}
@media(max-width:480px){
  .hero h1{font-size:clamp(1.75rem,8vw,2.2rem);}
  .h-stat .num{font-size:1.4rem;}
  .contact-form{padding:16px 12px;}
}
@media(max-width:380px){
  .hero h1{font-size:1.65rem;}
  .h-stat .num{font-size:1.25remh-stat .lbl{font-size:0.55rem;}
  .hero-stats{gap:12px 6px;}
  section{padding:48px 12px;}
}
@media(hover:none){
  .bc:hover,.price-card:hover,.tcard:hover,.fcc:hover{transform:none !important;}
  .btn-primary:hover,.btn-outline:hover,.pc-cta-solid:hover,.pc-cta-outline:hover{transform:none !important;}
  .nav-end a:hover,.fs-a:hover{transform:none !important;}
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav id="mainNav">
  <div class="nav-wrap">
    <div class="nav-logo">
      <img src="https://netclix.pages.dev/netclix_logo.webp" alt="Netclix"/>
    </div>
    <ul class="nav-links" id="navLinks">
      <li><a href="#hero"         onclick="closeMenu()">Home</a></li>
      <li><a href="#pricing"      onclick="closeMenu()">Pricing</a></li>
      <li><a href="#features"     onclick="closeMenu()">Features</a></li>
      <li><a href="#testimonials" onclick="closeMenu()">Reviews</a></li>
      <li><a href="#contact"      onclick="closeMenu()">Contact</a></li>
      <li><a href="/login.jsp"    onclick="closeMenu()">Login</a></li>
    </ul>
    <div class="nav-end">
      <a href="#contact">Get Started</a>
    </div>
    <button class="brgr" id="brgr" onclick="toggleMenu()" aria-label="Toggle menu" aria-expanded="false">
      <span></span><span></span><span></span>
    </button>
  </div>
</nav>

<!-- HERO -->
<section class="hero" id="hero">
  <canvas id="heroCanvas" aria-hidden="true"></canvas>
  <div class="h-orb h-orb-1"></div>
  <div class="h-orb h-orb-2"></div>
  <div class="h-orb h-orb-3"></div>

  <div class="env env-1">
    <svg width="72" height="56" viewBox="0 0 72 56" fill="none"><rect x="1" y="1" width="70" height="54" rx="6" fill="rgba(18,8,8,0.92)" stroke="rgba(201,24,30,0.6)" stroke-width="1.5"/><path d="M1 8 L36 32 L71 8" stroke="rgba(201,24,30,0.8)" stroke-width="1.5" fill="none" stroke-linecap="round"/><rect x="14" y="20" width="28" height="3" rx="1.5" fill="rgba(255,255,255,0.12)"/><rect x="14" y="27" width="22" height="3" rx="1.5" fill="rgba(255,255,255,0.08)"/><circle cx="56" cy="44" r="2" fill="#c9181e"/></svg>
  </div>
  <div class="env env-2">
    <svg width="54" height="42" viewBox="0 0 54 42" fill="none"><rect x="1" y="1" width="52" height="40" rx="5" fill="rgba(18,8,8,0.9)" stroke="rgba(201,24,30,0.5)" stroke-width="1.5"/><path d="M1 6 L27 24 L53 6" stroke="rgba(201,24,30,0.7)" stroke-width="1.5" fill="none" stroke-linecap="round"/><circle cx="44" cy="10" r="5" fill="#c9181e"/><text x="44" y="14" text-anchor="middle" font-size="6" fill="white" font-family="sans-serif" font-weight="700">1</text></svg>
  </div>
  <div class="env env-3">
    <svg width="38" height="30" viewBox="0 0 38 30" fill="none"><rect x="1" y="1" width="36" height="28" rx="4" fill="rgba(14,6,6,0.88)" stroke="rgba(201,24,30,0.45)" stroke-width="1.5"/><path d="M1 5 L19 17 L37 5" stroke="rgba(201,24,30,0.65)" stroke-width="1.5" fill="none" stroke-linecap="round"/></svg>
  </div>
  <div class="env env-4">
    <svg width="30" height="23" viewBox="0 0 30 23" fill="none"><rect x="1" y="1" width="28" height="21" rx="3" fill="rgba(14,6,6,0.85)" stroke="rgba(201,24,30,0.4)" stroke-width="1.5"/><path d="M1 4 L15 13 L29 4" stroke="rgba(201,24,30,0.55)" stroke-width="1.5" fill="none" stroke-linecap="round"/></svg>
  </div>

  <div class="hfc hfc-left">
    <div class="hfc-lbl">Open Rate</div>
    <div class="hfc-val">42.8%</div>
    <div class="hfc-badge"><span class="hfc-bdot"></span>↑ +18% this week</div>
  </div>
  <div class="hfc hfc-right">
    <div class="hfc-lbl">Emails Delivered</div>
    <div class="hfc-val">2.4M</div>
    <div class="hfc-badge"><span class="hfc-bdot"></span>Live right now</div>
  </div>

  <div class="container hero-content">
    <div class="h-eyebrow"><span class="h-eyebrow-dot"></span>Trusted by 10,500+ Brands</div>
    <h1 aria-label="Emails That Convert. At Any Scale."><span id="tw-line1"></span><span id="tw-line2"></span><span id="tw-line3"></span></h1>
    <p>Personalize, automate &amp; grow revenue — across 38 countries with industry-leading inbox deliverability.</p>
    <div class="hero-btns">
      <a href="#contact" class="btn-primary">Start Free — No Card Needed</a>
      <a href="#features" class="btn-outline">See How It Works →</a>
    </div>
    <div class="hero-stats">
      <div class="h-stat"><span class="num" data-count="10500" data-suffix="+" data-format="k">10.5K+</span><span class="lbl">Active Brands</span></div>
      <div class="stat-sep"></div>
      <div class="h-stat"><span class="num" data-count="38" data-suffix="">38</span><span class="lbl">Countries</span></div>
      <div class="stat-sep"></div>
      <div class="h-stat"><span class="num" data-count="99.2" data-suffix="%" data-decimal="1">99.2%</span><span class="lbl">Deliverability</span></div>
      <div class="stat-sep"></div>
      <div class="h-stat"><span class="num" data-count="3" data-suffix="×">3×</span><span class="lbl">Avg. Revenue Lift</span></div>
    </div>
  </div>
</section>

<!-- BRANDS -->
<section class="brands-section">
  <p class="section-label">
    <span class="t-num">10,500+</span> brands across <span class="t-num">38 countries</span> trust Email Marketing
  </p>
  <div class="brands-grid">
    <% for(int i=1;i<=3;i++){ %>
    <img src="https://netclix.pages.dev/logo_<%=i%>.webp" alt="Brand <%=i%>" loading="lazy"/>
    <% } %>
    <% for(int i=5;i<=11;i++){ %>
    <img src="https://netclix.pages.dev/logo_<%=i%>.webp" alt="Brand <%=i%>" loading="lazy"/>
    <% } %>
  </div>
</section>

<!-- FEATURES -->
<section class="feat-sec" id="features">
  <div class="container">
    <div class="sec-chip">Platform</div>
    <h2 class="sec-title">Everything you need<br>to win the inbox</h2>
    <p class="sec-sub">From AI-powered personalization to real-time analytics — one platform, infinite campaigns.</p>
    <div class="bento">
      <div class="bc"><div class="bc-accent"></div><div class="bc-icon">⚡</div><h3>Convert Customers Inside Email</h3><p>Embed product carousels, countdown timers &amp; one-click purchase flows directly inside emails — no redirect needed.</p></div>
      <div class="bc"><div class="bc-accent"></div><div class="bc-icon">🤖</div><h3>AI-Native Platform</h3><p>Smart segmentation, predictive send-time optimization, and automated A/B tests that learn from every campaign.</p></div>
      <div class="bc"><div class="bc-accent"></div><div class="bc-icon">🏆</div><h3>Forrester Wave™ Recognized</h3><p>Named a Strong Performer in Q3 2024 for Email Marketing Providers. Backed by enterprise-grade infrastructure.</p></div>
    </div>
  </div>
</section>

<!-- PRICING -->
<section class="price-sec" id="pricing">
  <div class="container">
    <div class="price-sec-inner">
      <div class="sec-chip">Pricing</div>
      <h2 class="sec-title" style="margin:0 auto 10px;">Plans for every<br>campaign goal</h2>
      <p class="sec-sub" style="margin:0 auto;">Start free, scale when ready. No hidden fees.</p>
    </div>
    <div class="price-grid">
      <div class="price-card">
        <div class="pc-name">One-Time</div>
        <div class="pc-price-row">₹7,500 <span>/ campaign</span></div>
        <ul><li>1 Dedicated Campaign</li><li>Up to 100,000 Subscribers</li><li>Custom Banner Design</li><li>Open &amp; Click Tracking</li></ul>
        <a href="#contact" class="pc-cta pc-cta-outline">Get Started</a>
      </div>
      <div class="price-card pc-hot">
        <div class="pc-badge">Most Popular</div>
        <div class="pc-name">Monthly</div>
        <div class="pc-price-row">₹20,000 <span>/ month</span></div>
        <ul><li>4 Campaigns per Month</li><li>Up to 100,000 Emails Each</li><li>Click &amp; Open Rate Reports</li><li>Priority Seller Placement</li></ul>
        <a href="#contact" class="pc-cta pc-cta-solid">Get Started</a>
      </div>
      <div class="price-card">
        <div class="pc-name">Premium</div>
        <div class="pc-price-row">₹35,000 <span>/ month</span></div>
        <ul><li>8 Campaigns / Month</li><li>Festival &amp; Mega Sale Boost</li><li>Performance Analytics</li><li>WhatsApp Add-On Option</li></ul>
        <a href="#contact" class="pc-cta pc-cta-outline">Get Started</a>
      </div>
      <div class="price-card pc-hot">
        <div class="pc-badge">Best Value</div>
        <div class="pc-name">Enterprise</div>
        <div class="pc-price-row">Custom <span>quote</span></div>
        <ul><li>Unlimited Campaigns</li><li>Dedicated Account Manager</li><li>Advanced Analytics &amp; Insights</li><li>Custom Integrations &amp; APIs</li></ul>
        <a href="#contact" class="pc-cta pc-cta-solid">Talk to Sales</a>
      </div>
    </div>
  </div>
</section>

<!-- TESTIMONIALS -->
<section class="testi-sec" id="testimonials">
  <div class="container">
    <div style="text-align:center;">
      <div class="sec-chip">Reviews</div>
      <h2 class="sec-title">Real results from<br>real customers</h2>
    </div>
    <div class="testi-grid">
      <div class="tcard"><div class="tcard-stars">★★★★★</div><p>"NETCLIX transformed our email strategy. Our subscribers are actually engaging now — not just opening and bouncing."</p><div class="tcard-author"><div class="tcard-avatar">AK</div><div class="tcard-info"><strong>Asish Kumar</strong><span>Growth Lead, Myntra</span></div></div><div class="tcard-metric"><span>Conversion increase</span><span>+40%</span></div></div>
      <div class="tcard"><div class="tcard-stars">★★★★★</div><p>"AMP email campaigns were a game-changer. Customers browse and buy without ever leaving their inbox."</p><div class="tcard-author"><div class="tcard-avatar">PS</div><div class="tcard-info"><strong>Priya Sharma</strong><span>Marketing Director, Nykaa</span></div></div><div class="tcard-metric"><span>Conversion lift</span><span>+35%</span></div></div>
      <div class="tcard"><div class="tcard-stars">★★★★★</div><p>"Deliverability improved dramatically from day one. Our campaigns now reach customers who never saw emails before."</p><div class="tcard-author"><div class="tcard-avatar">RM</div><div class="tcard-info"><strong>Rahul Mehta</strong><span>CMO, CaratLane</span></div></div><div class="tcard-metric"><span>Revenue growth</span><span>3× ROI</span></div></div>
    </div>
  </div>
</section>

<!-- CONTACT -->
<section class="contact-sec" id="contact">
  <div class="container">
    <div class="contact-grid">
      <div class="contact-info">
        <div class="sec-chip">Get in Touch</div>
        <h2 class="sec-title">Schedule Your<br>Free Demo</h2>
        <p>See how Netclix can transform your campaigns. Our team walks you through a personalized demo in under 30 minutes.</p>
        <div class="c-feature"><div class="c-icon">🚀</div><div class="c-text"><strong>Live in 24 hours</strong><span>Launch your first campaign same day</span></div></div>
        <div class="c-feature"><div class="c-icon">📊</div><div class="c-text"><strong>Real-time analytics</strong><span>Track opens, clicks and conversions live</span></div></div>
        <div class="c-feature"><div class="c-icon">🛡️</div><div class="c-text"><strong>Enterprise-grade security</strong><span>GDPR compliant, SOC2 certified</span></div></div>
      </div>
      <div class="contact-form">
        <form action="LeadServlet" method="POST">
          <h3>Book a Free Demo</h3>
          <div class="form-row">
            <input type="text" name="fname" placeholder="First Name" required/>
            <input type="text" name="lname" placeholder="Last Name" required/>
          </div>
          <input type="email" name="email" placeholder="Work Email" required/>
          <div class="form-row">
            <input type="tel" name="phone" placeholder="Phone Number"/>
            <input type="text" name="company" placeholder="Company Name" required/>
          </div>
          <div class="form-row">
            <input type="text" name="job_title" placeholder="Job Title"/>
            <input type="text" name="website" placeholder="Website"/>
          </div>
          <select name="monthly_volume">
            <option value="">Monthly Email Volume?</option>
            <option>1–50k</option><option>50–200k</option><option>200k+</option>
          </select>
          <div class="form-row">
            <input type="text" name="industry" placeholder="Industry"/>
            <input type="text" name="country" placeholder="Country"/>
          </div>
          <div class="form-row">
            <input type="text" name="current_provider" placeholder="Current Email Provider"/>
            <input type="text" name="services_needed" placeholder="Services Needed"/>
          </div>
          <input type="text" name="budget" placeholder="Budget"/>
          <button type="submit">Schedule My Free Demo →</button>
        </form>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer class="footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <div class="footer-logo">
          <div class="logo-hex"><img src="https://netclix.pages.dev/netclix_logo.webp" alt="Netclix"/></div>
          <span>NETCLIX</span>
        </div>
        <p>AI-native email marketing. Supercharge your email conversion rate.</p>
        <div class="footer-contact-cards">
          <a href="mailto:info@netclixcloud.com" class="fcc">
            <div class="fcc-icon"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#c9181e" stroke-width="2" stroke-linecap="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg></div>
            <div class="fcc-text"><strong>info@netclixcloud.com</strong><span>Email us anytime</span></div>
          </a>
          <a href="tel:+917065580729" class="fcc">
            <div class="fcc-icon"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#c9181e" stroke-width="2" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6A19.79 19.79 0 0 1 2.12 4.18 2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg></div>
            <div class="fcc-text"><strong>+91 7065580729</strong><span>Mon–Sat, 10am–6pm IST</span></div>
          </a>
          <a href="tel:+918922870543" class="fcc">
            <div class="fcc-icon"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#c9181e" stroke-width="2" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6A19.79 19.79 0 0 1 2.12 4.18 2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg></div>
            <div class="fcc-text"><strong>+91 8922870543</strong><span>Mon–Sat, 10am–6pm IST</span></div>
          </a>
        </div>
        <div class="fsoc">
          <a href="#" class="fs-a">X</a>
          <a href="https://www.instagram.com/netclixcloud/" class="fs-a">in</a>
          <a href="#" class="fs-a">Yt</a>
          <a href="https://www.facebook.com/people/Netclix/61588481018467/" class="fs-a">f</a>
        </div>
      </div>
      <div class="fc"><h5>Menu</h5><a href="#">Home</a><a href="#">About</a><a href="#">Services</a><a href="#">Blog</a><a href="#contact">Contact</a></div>
      <div class="fc"><h5>Services</h5><a href="#">Email Marketing</a><a href="#">AMP Emails</a><a href="#">AI Platform</a><a href="#">Automation</a><a href="#">Analytics</a><a href="#pricing">Pricing</a></div>
      <div class="fc"><h5>Company</h5><a href="#">About</a><a href="#">Customers</a><a href="#">Careers</a><a href="#">Blog</a><a href="#">Press</a><a href="#">Partners</a></div>
      <div class="fc"><h5>Support</h5><a href="#">Help Center</a><a href="#">Community</a><a href="#">Contact</a><a href="#">Security</a><a href="#">GDPR</a><a href="#">CCPA</a></div>
    </div>
    <div class="footer-bottom">
      <span>&copy; 2026 NETCLIX Cloud Pvt. Ltd. All rights reserved.</span>
      <div><a href="#">Privacy</a><a href="#">Terms</a><a href="#">Cookies</a></div>
    </div>
  </div>
</footer>

<script>
/* ============================
   NAV — HAMBURGER
   ============================ */
const navLinks = document.getElementById('navLinks');
const brgrBtn  = document.getElementById('brgr');
let menuOpen   = false;

function toggleMenu(){
  menuOpen = !menuOpen;
  navLinks.classList.toggle('mob-open', menuOpen);
  brgrBtn.setAttribute('aria-expanded', menuOpen);
  const spans = brgrBtn.querySelectorAll('span');
  if(menuOpen){
    spans[0].style.cssText = 'transform:translateY(9px) rotate(45deg)';
    spans[1].style.cssText = 'opacity:0;transform:scaleX(0)';
    spans[2].style.cssText = 'transform:translateY(-9px) rotate(-45deg)';
  } else {
    spans[0].style.cssText = '';
    spans[1].style.cssText = '';
    spans[2].style.cssText = '';
  }
}

function closeMenu(){
  if(!menuOpen) return;
  menuOpen = false;
  navLinks.classList.remove('mob-open');
  brgrBtn.setAttribute('aria-expanded','false');
  const spans = brgrBtn.querySelectorAll('span');
  spans[0].style.cssText = '';
  spans[1].style.cssText = '';
  spans[2].style.cssText = '';
}

document.addEventListener('click', e => {
  if(!e.target.closest('nav')) closeMenu();
});
window.addEventListener('scroll', () => {
  closeMenu();
  document.getElementById('mainNav').classList.toggle('scrolled', window.scrollY > 50);
}, {passive:true});

/* ============================
   SCROLL REVEAL
   ============================ */
const revObs = new IntersectionObserver(entries => {
  entries.forEach(e => {
    if(e.isIntersecting){
      e.target.style.animation = 'fadeUp 0.7s cubic-bezier(0.16,1,0.3,1) forwards';
      revObs.unobserve(e.target);
    }
  });
}, {threshold:0.08});
document.querySelectorAll('.bc,.price-card,.tcard').forEach(el => {
  el.style.opacity='0'; el.style.transform='translateY(24px)'; revObs.observe(el);
});

/* ============================
   TYPEWRITER
   ============================ */
function typeWriter(el, text, speed, onDone){
  let i=0; el.innerHTML='';
  const cur = document.createElement('span'); cur.className='tw-cur';
  const tick = () => {
    el.textContent = text.slice(0,i); el.appendChild(cur);
    if(i<=text.length){ i++; setTimeout(tick, speed+(Math.random()*25)); }
    else{ onDone&&onDone(cur); }
  };
  tick();
}

/* ============================
   PARTICLES
   ============================ */
(function(){
  const canvas = document.getElementById('heroCanvas');
  if(!canvas) return;
  const ctx = canvas.getContext('2d');
  let W,H,particles=[];
  function resize(){ W=canvas.width=canvas.offsetWidth; H=canvas.height=canvas.offsetHeight; }
  function mkP(forced){
    const s=Math.random(); let x,y,vx,vy;
    if(forced){ x=Math.random()*W; y=Math.random()*H; vx=(Math.random()-0.5)*0.35; vy=(Math.random()-0.5)*0.35; }
    else if(s<0.25){ x=0; y=Math.random()*H; vx=Math.random()*0.4+0.1; vy=(Math.random()-0.5)*0.2; }
    else if(s<0.5){ x=W; y=Math.random()*H; vx=-(Math.random()*0.4+0.1); vy=(Math.random()-0.5)*0.2; }
    else if(s<0.75){ x=Math.random()*W; y=0; vy=Math.random()*0.4+0.1; vx=(Math.random()-0.5)*0.2; }
    else{ x=Math.random()*W; y=H; vy=-(Math.random()*0.4+0.1); vx=(Math.random()-0.5)*0.2; }
    const t=Math.random();
    return{x,y,vx,vy,size:Math.random()*2.2+0.5,alpha:Math.random()*0.45+0.08,life:Math.random()*0.5+0.5,decay:Math.random()*0.0008+0.0003,type:t<0.55?'dot':t<0.82?'cross':'ring',hue:Math.random()<0.7?0:220,rot:Math.random()*Math.PI*2,rs:(Math.random()-0.5)*0.015};
  }
  function draw(p){
    ctx.save();
    const c=p.hue===0?`rgba(${201+Math.round(Math.random()*20)},24,30,${p.alpha*p.life})`:`rgba(245,238,238,${p.alpha*p.life*0.55})`;
    if(p.type==='dot'){ctx.beginPath();ctx.arc(p.x,p.y,p.size,0,Math.PI*2);ctx.fillStyle=c;ctx.fill();}
    else if(p.type==='cross'){ctx.translate(p.x,p.y);ctx.rotate(p.rot);ctx.strokeStyle=c;ctx.lineWidth=0.8;ctx.lineCap='round';const s=p.size*1.8;ctx.beginPath();ctx.moveTo(-s,0);ctx.lineTo(s,0);ctx.stroke();ctx.beginPath();ctx.moveTo(0,-s);ctx.lineTo(0,s);ctx.stroke();}
    else{ctx.beginPath();ctx.arc(p.x,p.y,p.size*1.5,0,Math.PI*2);ctx.strokeStyle=c;ctx.lineWidth=0.7;ctx.stroke();}
    ctx.restore();
  }
  function tick(){
    ctx.clearRect(0,0,W,H);
    for(let i=particles.length-1;i>=0;i--){const p=particles[i];p.x+=p.vx;p.y+=p.vy;p.rot+=p.rs;p.life-=p.decay;draw(p);if(p.life<=0)particles.splice(i,1);}
    while(particles.length<28) particles.push(mkP(false));
    requestAnimationFrame(tick);
  }
  window.addEventListener('load',()=>{
    resize(); window.addEventListener('resize',resize,{passive:true});
    particles=[]; for(let i=0;i<28;i++) particles.push(mkP(true));
    setTimeout(()=>{canvas.classList.add('visible');tick();},400);
  });
})();

/* ============================
   COUNTERS
   ============================ */
(function(){
  function easeOut(t){return t===1?1:1-Math.pow(2,-10*t);}
  function anim(el){
    const raw=parseFloat(el.dataset.count),suf=el.dataset.suffix||'',dec=parseInt(el.dataset.decimal||'0'),isK=el.dataset.format==='k',dur=1800,t0=performance.now();
    function f(now){
      const p=Math.min((now-t0)/dur,1),e=easeOut(p),v=raw*e;
      let d=isK?v>=1000?(v/1000).toFixed(1)+'K':Math.round(v)+'':dec>0?v.toFixed(dec):Math.round(v)+'';
      el.textContent=d+suf;
      if(p<1)requestAnimationFrame(f);
    }
    requestAnimationFrame(f);
  }
  const st=document.querySelector('.hero-stats');
  if(!st) return;
  let done=false;
  new IntersectionObserver(([e])=>{
    if(e.isIntersecting&&!done){done=true;setTimeout(()=>document.querySelectorAll('.hero-stats .num[data-count]').forEach(anim),800);}
  },{threshold:0.4}).observe(st);
})();

/* ============================
   TYPEWRITER TRIGGER
   ============================ */
setTimeout(()=>{
  const l1=document.getElementById('tw-line1'),
        l2=document.getElementById('tw-line2'),
        l3=document.getElementById('tw-line3');
  typeWriter(l1,'Emails That',68,()=>{
    l1.innerHTML='Emails That';
    setTimeout(()=>{
      typeWriter(l2,'Convert.',72,()=>{
        l2.innerHTML='<span class="h-grad">Convert.</span>';
        setTimeout(()=>{
          typeWriter(l3,'At Any Scale.',76,()=>{
            l3.innerHTML='<span class="h-ul line-on">At Any Scale.</span>';
          });
        },180);
      });
    },160);
  });
},600);
</script>
</body>
</html>
