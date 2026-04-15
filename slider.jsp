<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Slider CSS -->

<link rel="stylesheet" href="css/slider.css"/>



<section class="trusted-brands">
  <div class="trusted-container">

    <!-- Header -->
    <div class="trusted-header">
      <h3 class="trusted-title">
        Trusted by <span class="title-accent">Industry Leaders</span>
      </h3>
      <p class="trusted-subtitle">
        Join 10,500+ brands across 40+ countries achieving exceptional results
      </p>
    </div>

    <!-- Stats chips -->
    <div class="trusted-stats">
      <span class="stat-chip"><strong>10,500+</strong> Global Brands</span>
      <span class="stat-chip"><strong>40+</strong> Countries</span>
      <span class="stat-chip"><strong>25B+</strong> Emails / Month</span>
      <span class="stat-chip"><strong>3&times;</strong> Avg. ROI Uplift</span>
    </div>

    <!-- Brand logos track — populated by slider.js -->
    <div class="brands-track-wrapper" id="brandsWrapper">
      <div class="brands-track" id="brandsTrack"></div>
    </div>

    <!-- Mobile dot navigation -->
    <div class="slider-dots" id="sliderDots"></div>

    <!-- Mobile swipe hint -->
    <p class="swipe-hint" id="swipeHint">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <path d="M5 12h14M12 5l7 7-7 7"/>
      </svg>
      Swipe to explore
    </p>

  </div>
</section>

<!-- 
  Inject context path so slider.js resolves image URLs correctly
  whether this file is loaded standalone OR included in index.jsp
-->
<script>
  window.SLIDER_BASE_PATH = '${pageContext.request.contextPath}';
</script>
<script src="js/slider.js"></script>
