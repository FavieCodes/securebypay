export const getLandingPageHtml = (): string => `<!DOCTYPE html>
<html lang="en" class="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SecureByPay — Auth API Portal & Developer Docs</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;600&family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg-dark: #090d16;
      --bg-card: rgba(17, 24, 39, 0.7);
      --border-card: rgba(255, 255, 255, 0.08);
      --border-card-hover: rgba(59, 130, 246, 0.35);
      --primary: #3b82f6;
      --primary-hover: #2563eb;
      --primary-glow: rgba(59, 130, 246, 0.25);
      --cyan: #06b6d4;
      --emerald: #10b981;
      --rose: #f43f5e;
      --amber: #f59e0b;
      --purple: #8b5cf6;
      --text-main: #f3f4f6;
      --text-muted: #9ca3af;
      --text-dim: #6b7280;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      background-color: var(--bg-dark);
      background-image: 
        radial-gradient(at 0% 0%, rgba(37, 99, 235, 0.12) 0px, transparent 50%),
        radial-gradient(at 100% 0%, rgba(6, 182, 212, 0.1) 0px, transparent 50%),
        radial-gradient(at 50% 100%, rgba(139, 92, 246, 0.08) 0px, transparent 50%);
      background-attachment: fixed;
      color: var(--text-main);
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      line-height: 1.6;
      min-height: 100vh;
      padding-bottom: 60px;
    }

    h1, h2, h3, h4 {
      font-family: 'Outfit', sans-serif;
      color: #fff;
    }

    code, pre, .font-mono {
      font-family: 'Fira Code', monospace;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 24px;
    }

    /* Header Navigation */
    header {
      position: sticky;
      top: 0;
      z-index: 50;
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      background: rgba(9, 13, 22, 0.85);
      border-bottom: 1px solid var(--border-card);
    }

    .nav-inner {
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 72px;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
      text-decoration: none;
    }

    .brand-logo {
      width: 38px;
      height: 38px;
      background: linear-gradient(135deg, #3b82f6, #06b6d4);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 0 15px var(--primary-glow);
    }

    .brand-logo svg {
      width: 20px;
      height: 20px;
      fill: none;
      stroke: #fff;
      stroke-width: 2.2;
    }

    .brand-text {
      font-family: 'Outfit', sans-serif;
      font-weight: 700;
      font-size: 1.25rem;
      letter-spacing: -0.02em;
      color: #fff;
    }

    .brand-text span {
      background: linear-gradient(135deg, #60a5fa, #38bdf8);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .status-badge {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 6px 14px;
      background: rgba(16, 185, 129, 0.1);
      border: 1px solid rgba(16, 185, 129, 0.25);
      border-radius: 9999px;
      font-size: 0.825rem;
      font-weight: 500;
      color: var(--emerald);
    }

    .status-dot {
      width: 8px;
      height: 8px;
      background-color: var(--emerald);
      border-radius: 50%;
      box-shadow: 0 0 8px var(--emerald);
      animation: pulse 2s infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.5; transform: scale(0.85); }
    }

    .btn-swagger {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 10px 20px;
      background: linear-gradient(135deg, var(--primary), var(--cyan));
      color: #fff;
      font-weight: 600;
      font-size: 0.875rem;
      border-radius: 10px;
      text-decoration: none;
      box-shadow: 0 4px 14px var(--primary-glow);
      transition: all 0.2s ease;
    }

    .btn-swagger:hover {
      transform: translateY(-1px);
      box-shadow: 0 6px 20px rgba(6, 182, 212, 0.35);
    }

    /* Hero Section */
    .hero {
      padding: 56px 0 36px;
      text-align: center;
    }

    .hero-pill {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 4px 14px;
      background: rgba(59, 130, 246, 0.1);
      border: 1px solid rgba(59, 130, 246, 0.2);
      border-radius: 9999px;
      color: #60a5fa;
      font-size: 0.85rem;
      font-weight: 500;
      margin-bottom: 20px;
    }

    .hero-title {
      font-size: 3rem;
      font-weight: 800;
      line-height: 1.15;
      letter-spacing: -0.03em;
      margin-bottom: 16px;
    }

    .hero-title span {
      background: linear-gradient(135deg, #60a5fa 0%, #38bdf8 50%, #818cf8 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .hero-subtitle {
      max-width: 720px;
      margin: 0 auto;
      font-size: 1.125rem;
      color: var(--text-muted);
      font-weight: 400;
    }

    .search-bar-wrapper {
      max-width: 540px;
      margin: 28px auto 0;
      position: relative;
    }

    .search-input {
      width: 100%;
      padding: 14px 20px 14px 44px;
      background: rgba(15, 23, 42, 0.8);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 12px;
      color: #fff;
      font-family: inherit;
      font-size: 0.95rem;
      outline: none;
      transition: all 0.2s ease;
    }

    .search-input:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 4px var(--primary-glow);
    }

    .search-icon {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-dim);
      pointer-events: none;
    }

    /* Section Grid & Glass Cards */
    .section-grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 32px;
      margin-top: 32px;
    }

    .glass-card {
      background: var(--bg-card);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid var(--border-card);
      border-radius: 16px;
      padding: 32px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
      transition: border-color 0.2s ease;
    }

    .glass-card:hover {
      border-color: var(--border-card-hover);
    }

    .card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 24px;
    }

    .card-title-group {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .card-icon {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      background: rgba(59, 130, 246, 0.12);
      border: 1px solid rgba(59, 130, 246, 0.2);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #60a5fa;
    }

    .card-icon svg {
      width: 22px;
      height: 22px;
      fill: none;
      stroke: currentColor;
      stroke-width: 2;
    }

    .card-title {
      font-size: 1.35rem;
      font-weight: 700;
    }

    /* Integrated GUI Sandbox */
    .sandbox-layout {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 28px;
    }

    @media (max-width: 900px) {
      .sandbox-layout {
        grid-template-columns: 1fr;
      }
      .hero-title {
        font-size: 2.25rem;
      }
    }

    .tabs {
      display: flex;
      gap: 8px;
      background: rgba(15, 23, 42, 0.6);
      padding: 6px;
      border-radius: 12px;
      border: 1px solid var(--border-card);
      margin-bottom: 20px;
    }

    .tab-btn {
      flex: 1;
      padding: 10px 14px;
      border: none;
      background: transparent;
      color: var(--text-muted);
      font-family: inherit;
      font-size: 0.85rem;
      font-weight: 600;
      border-radius: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: all 0.2s ease;
    }

    .tab-btn.active {
      background: rgba(59, 130, 246, 0.15);
      color: #60a5fa;
      border: 1px solid rgba(59, 130, 246, 0.3);
    }

    .method-tag {
      padding: 2px 6px;
      border-radius: 4px;
      font-size: 0.7rem;
      font-weight: 700;
      text-transform: uppercase;
    }

    .method-post {
      background: rgba(16, 185, 129, 0.2);
      color: #34d399;
    }

    .method-get {
      background: rgba(59, 130, 246, 0.2);
      color: #60a5fa;
    }

    .form-group {
      margin-bottom: 16px;
    }

    .form-label {
      display: block;
      font-size: 0.825rem;
      font-weight: 500;
      color: var(--text-muted);
      margin-bottom: 6px;
    }

    .form-input {
      width: 100%;
      padding: 12px 14px;
      background: rgba(15, 23, 42, 0.7);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 10px;
      color: #fff;
      font-family: inherit;
      font-size: 0.9rem;
      outline: none;
      transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .form-input:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 3px var(--primary-glow);
    }

    .feedback-banner {
      padding: 12px 16px;
      border-radius: 10px;
      font-size: 0.875rem;
      font-weight: 500;
      margin-bottom: 16px;
      line-height: 1.4;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .feedback-success {
      background: rgba(16, 185, 129, 0.15);
      border: 1px solid rgba(16, 185, 129, 0.35);
      color: #34d399;
    }

    .feedback-error {
      background: rgba(244, 63, 94, 0.15);
      border: 1px solid rgba(244, 63, 94, 0.35);
      color: #fb7185;
    }

    .btn-submit {
      width: 100%;
      padding: 12px;
      background: linear-gradient(135deg, var(--primary), #2563eb);
      color: #fff;
      font-family: inherit;
      font-weight: 600;
      font-size: 0.925rem;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      box-shadow: 0 4px 12px var(--primary-glow);
      transition: all 0.2s ease;
      margin-top: 10px;
    }

    .btn-submit:hover {
      background: linear-gradient(135deg, #2563eb, #1d4ed8);
      transform: translateY(-1px);
    }

    .response-console {
      background: #080c14;
      border: 1px solid var(--border-card);
      border-radius: 12px;
      display: flex;
      flex-direction: column;
      height: 100%;
      min-height: 380px;
      overflow: hidden;
    }

    .console-header {
      padding: 12px 16px;
      background: rgba(15, 23, 42, 0.8);
      border-bottom: 1px solid var(--border-card);
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .console-title {
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--text-muted);
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .status-tag {
      font-family: 'Fira Code', monospace;
      font-size: 0.775rem;
      padding: 4px 8px;
      border-radius: 6px;
      font-weight: 600;
    }

    .status-2xx {
      background: rgba(16, 185, 129, 0.15);
      color: #34d399;
      border: 1px solid rgba(16, 185, 129, 0.3);
    }

    .status-4xx, .status-5xx {
      background: rgba(244, 63, 94, 0.15);
      color: #fb7185;
      border: 1px solid rgba(244, 63, 94, 0.3);
    }

    .console-body {
      padding: 16px;
      flex: 1;
      overflow-y: auto;
      font-family: 'Fira Code', monospace;
      font-size: 0.825rem;
      color: #e2e8f0;
      white-space: pre-wrap;
      word-break: break-all;
    }

    .token-bar {
      margin-top: 14px;
      padding: 10px 14px;
      background: rgba(15, 23, 42, 0.6);
      border: 1px solid var(--border-card);
      border-radius: 10px;
      font-size: 0.8rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .token-value {
      font-family: 'Fira Code', monospace;
      color: #38bdf8;
      max-width: 280px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    /* API Endpoint Catalog Cards */
    .endpoint-list {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }

    .endpoint-card {
      background: rgba(15, 23, 42, 0.6);
      border: 1px solid var(--border-card);
      border-radius: 12px;
      padding: 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 20px;
      transition: all 0.2s ease;
    }

    .endpoint-card:hover {
      border-color: rgba(59, 130, 246, 0.3);
      transform: translateX(2px);
    }

    .endpoint-meta {
      display: flex;
      align-items: center;
      gap: 14px;
    }

    .endpoint-path {
      font-family: 'Fira Code', monospace;
      font-size: 0.95rem;
      font-weight: 600;
      color: #fff;
    }

    .endpoint-desc {
      font-size: 0.85rem;
      color: var(--text-muted);
      margin-top: 2px;
    }

    .auth-badge {
      font-size: 0.75rem;
      padding: 4px 10px;
      border-radius: 9999px;
      font-weight: 600;
    }

    .auth-public {
      background: rgba(16, 185, 129, 0.12);
      color: #34d399;
      border: 1px solid rgba(16, 185, 129, 0.25);
    }

    .auth-bearer {
      background: rgba(245, 158, 11, 0.12);
      color: #fbbf24;
      border: 1px solid rgba(245, 158, 11, 0.25);
    }

    /* Code Snippet Generator */
    .snippet-container {
      background: #080c14;
      border: 1px solid var(--border-card);
      border-radius: 12px;
      overflow: hidden;
    }

    .snippet-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 16px;
      background: rgba(15, 23, 42, 0.8);
      border-bottom: 1px solid var(--border-card);
    }

    .snippet-tabs {
      display: flex;
      gap: 6px;
    }

    .lang-btn {
      padding: 6px 12px;
      border: none;
      background: transparent;
      color: var(--text-muted);
      font-family: inherit;
      font-size: 0.8rem;
      font-weight: 600;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .lang-btn.active {
      background: rgba(59, 130, 246, 0.2);
      color: #60a5fa;
    }

    .btn-copy {
      padding: 6px 12px;
      background: rgba(255, 255, 255, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.1);
      color: var(--text-main);
      font-size: 0.8rem;
      border-radius: 6px;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 6px;
      transition: all 0.2s ease;
    }

    .btn-copy:hover {
      background: rgba(255, 255, 255, 0.15);
    }

    .snippet-body {
      padding: 20px;
      font-family: 'Fira Code', monospace;
      font-size: 0.85rem;
      color: #e2e8f0;
      overflow-x: auto;
      white-space: pre;
    }

    /* Error Code Table */
    .error-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 16px;
    }

    .error-card {
      background: rgba(15, 23, 42, 0.6);
      border: 1px solid var(--border-card);
      border-radius: 12px;
      padding: 18px;
    }

    .error-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 8px;
    }

    .error-code {
      font-family: 'Fira Code', monospace;
      font-size: 0.9rem;
      font-weight: 700;
      padding: 2px 8px;
      border-radius: 6px;
    }

    .err-2xx { background: rgba(16, 185, 129, 0.15); color: #34d399; }
    .err-400 { background: rgba(245, 158, 11, 0.15); color: #fbbf24; }
    .err-401 { background: rgba(239, 68, 68, 0.15); color: #fca5a5; }
    .err-409 { background: rgba(168, 85, 247, 0.15); color: #c084fc; }

    .error-desc {
      font-size: 0.85rem;
      color: var(--text-muted);
    }

    /* Architecture Grid */
    .arch-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 20px;
    }

    .arch-card {
      background: rgba(15, 23, 42, 0.6);
      border: 1px solid var(--border-card);
      border-radius: 12px;
      padding: 20px;
      transition: transform 0.2s ease, border-color 0.2s ease;
    }

    .arch-card:hover {
      transform: translateY(-2px);
      border-color: rgba(59, 130, 246, 0.3);
    }

    .arch-title-wrapper {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 10px;
    }

    .arch-title-icon {
      width: 28px;
      height: 28px;
      border-radius: 8px;
      background: rgba(59, 130, 246, 0.15);
      border: 1px solid rgba(59, 130, 246, 0.25);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #60a5fa;
    }

    .arch-title-icon svg {
      width: 16px;
      height: 16px;
      fill: none;
      stroke: currentColor;
      stroke-width: 2;
    }

    .arch-title {
      font-size: 1.05rem;
      font-weight: 700;
      color: #fff;
    }

    .arch-desc {
      font-size: 0.85rem;
      color: var(--text-muted);
      line-height: 1.5;
    }

    footer {
      margin-top: 60px;
      text-align: center;
      color: var(--text-dim);
      font-size: 0.85rem;
    }
  </style>
</head>
<body>

  <!-- Header Navigation -->
  <header>
    <div class="container nav-inner">
      <a href="/" class="brand">
        <div class="brand-logo">
          <svg viewBox="0 0 24 24">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          </svg>
        </div>
        <div class="brand-text">SecureByPay <span>API</span></div>
      </a>

      <div style="display: flex; align-items: center; gap: 16px;">
        <div class="status-badge" id="healthBadge">
          <div class="status-dot"></div>
          <span>API Online</span>
        </div>

        <a href="/api/v1/docs" target="_blank" rel="noopener noreferrer" class="btn-swagger">
          <span>Swagger UI</span>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
            <polyline points="15 3 21 3 21 9"></polyline>
            <line x1="10" y1="14" x2="21" y2="3"></line>
          </svg>
        </a>
      </div>
    </div>
  </header>

  <main class="container">
    <!-- Hero Header -->
    <section class="hero">
      <div class="hero-pill">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
        <span>v1.0.0</span> • <span>Production Auth Engine</span>
      </div>
      <h1 class="hero-title">SecureByPay <span>Developer Portal</span></h1>
      <p class="hero-subtitle">
        Enterprise authentication microservice with JWT token generation, Bcrypt password encryption, and real-time request testing.
      </p>

      <!-- Live Search Bar -->
      <div class="search-bar-wrapper">
        <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        <input type="text" id="searchInput" class="search-input" placeholder="Search endpoints, status codes, SDKs..." onkeyup="filterContent()" />
      </div>
    </section>

    <div class="section-grid">

      <!-- Integrated GUI REST Client Sandbox -->
      <section class="glass-card searchable-item" data-search="sandbox signup login profile me post get auth test">
        <div class="card-header">
          <div class="card-title-group">
            <div class="card-icon">
              <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
            </div>
            <div>
              <h2 class="card-title">Interactive API Sandbox</h2>
              <p style="font-size: 0.85rem; color: var(--text-muted);">Test request payloads directly against live endpoints</p>
            </div>
          </div>
        </div>

        <div class="sandbox-layout">
          <!-- Request Builder Panel -->
          <div>
            <div class="tabs">
              <button class="tab-btn active" onclick="switchTab('signup')">
                <span class="method-tag method-post">POST</span> Signup
              </button>
              <button class="tab-btn" onclick="switchTab('login')">
                <span class="method-tag method-post">POST</span> Login
              </button>
              <button class="tab-btn" onclick="switchTab('forgot')">
                <span class="method-tag method-post">POST</span> Forgot Password
              </button>
              <button class="tab-btn" onclick="switchTab('reset')">
                <span class="method-tag method-post">POST</span> Reset Password
              </button>
              <button class="tab-btn" onclick="switchTab('me')">
                <span class="method-tag method-get">GET</span> Profile
              </button>
            </div>

            <!-- Visual Feedback Toast Banner -->
            <div id="formFeedback" class="feedback-banner" style="display: none;"></div>

            <!-- Signup Form -->
            <form id="form-signup" onsubmit="handleRequest(event, 'signup')">
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                <div class="form-group">
                  <label class="form-label">First Name</label>
                  <input type="text" id="signup-firstName" class="form-input" value="Imo" required />
                </div>
                <div class="form-group">
                  <label class="form-label">Last Name</label>
                  <input type="text" id="signup-lastName" class="form-input" value="Johnson" required />
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Email Address</label>
                <input type="email" id="signup-email" class="form-input" value="imo.dev@example.com" required />
              </div>
              <div class="form-group">
                <label class="form-label">Phone Number</label>
                <input type="tel" id="signup-phoneNumber" class="form-input" value="+1234567890" required />
              </div>
              <div class="form-group">
                <label class="form-label">Password (min 8 chars)</label>
                <input type="password" id="signup-password" class="form-input" value="SuperSecret123" required />
              </div>
              <button type="submit" class="btn-submit">
                <span>Send Signup Request</span>
              </button>
            </form>

            <!-- Login Form -->
            <form id="form-login" style="display: none;" onsubmit="handleRequest(event, 'login')">
              <div class="form-group">
                <label class="form-label">Email Address</label>
                <input type="email" id="login-email" class="form-input" value="imo.dev@example.com" required />
              </div>
              <div class="form-group">
                <label class="form-label">Password</label>
                <input type="password" id="login-password" class="form-input" value="SuperSecret123" required />
              </div>
              <button type="submit" class="btn-submit">
                <span>Send Login Request</span>
              </button>
            </form>

            <!-- Forgot Password Form -->
            <form id="form-forgot" style="display: none;" onsubmit="handleRequest(event, 'forgot')">
              <div class="form-group">
                <label class="form-label">Email Address</label>
                <input type="email" id="forgot-email" class="form-input" value="imo.dev@example.com" required />
              </div>
              <button type="submit" class="btn-submit">
                <span>Send Reset Code</span>
              </button>
            </form>

            <!-- Reset Password Form -->
            <form id="form-reset" style="display: none;" onsubmit="handleRequest(event, 'reset')">
              <div class="form-group">
                <label class="form-label">Email Address</label>
                <input type="email" id="reset-email" class="form-input" value="imo.dev@example.com" required />
              </div>
              <div class="form-group">
                <label class="form-label">Reset Code</label>
                <input type="text" id="reset-token" class="form-input font-mono" placeholder="e.g. 123456" required />
              </div>
              <div class="form-group">
                <label class="form-label">New Password (min 8 chars)</label>
                <input type="password" id="reset-password" class="form-input" value="NewSuperSecret123" required />
              </div>
              <button type="submit" class="btn-submit">
                <span>Send Reset Password Request</span>
              </button>
            </form>

            <!-- Profile Me Form -->
            <form id="form-me" style="display: none;" onsubmit="handleRequest(event, 'me')">
              <div class="form-group">
                <label class="form-label">Authorization Bearer Token</label>
                <input type="text" id="me-token" class="form-input font-mono" placeholder="Sign in to generate token automatically" required />
              </div>
              <button type="submit" class="btn-submit">
                <span>Fetch Profile (/api/auth/me)</span>
              </button>
            </form>

            <div class="token-bar">
              <span style="color: var(--text-muted)">Active Session Token:</span>
              <span id="sessionToken" class="token-value">No active token</span>
            </div>
          </div>

          <!-- Response Console Panel -->
          <div>
            <div class="response-console">
              <div class="console-header">
                <div class="console-title">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="4 17 10 11 4 5"></polyline><line x1="12" y1="19" x2="20" y2="19"></line></svg>
                  <span>Response Output</span>
                </div>
                <div id="statusTag" class="status-tag status-2xx" style="display: none;">200 OK</div>
              </div>
              <div id="consoleBody" class="console-body">// Click "Send Request" to execute endpoint and view live response</div>
            </div>
          </div>
        </div>
      </section>

      <!-- API Endpoint Reference Catalog -->
      <section class="glass-card searchable-item" data-search="endpoints routes catalog signup login me health openapi">
        <div class="card-header">
          <div class="card-title-group">
            <div class="card-icon">
              <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
            </div>
            <div>
              <h2 class="card-title">API Endpoint Reference</h2>
              <p style="font-size: 0.85rem; color: var(--text-muted);">Available application endpoints</p>
            </div>
          </div>
        </div>

        <div class="endpoint-list">
          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-post">POST</span>
              <div>
                <div class="endpoint-path">/api/auth/signup</div>
                <div class="endpoint-desc">Registers a new account with firstName, lastName, email, phoneNumber, and password.</div>
              </div>
            </div>
            <span class="auth-badge auth-public">Public</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-post">POST</span>
              <div>
                <div class="endpoint-path">/api/auth/login</div>
                <div class="endpoint-desc">Authenticates email and password credentials and returns a signed JWT token.</div>
              </div>
            </div>
            <span class="auth-badge auth-public">Public</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-post">POST</span>
              <div>
                <div class="endpoint-path">/api/auth/forgot-password</div>
                <div class="endpoint-desc">Requests a password reset code for the given email. Always returns 200, even for unknown emails, so the response can't be used to enumerate registered accounts.</div>
              </div>
            </div>
            <span class="auth-badge auth-public">Public</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-post">POST</span>
              <div>
                <div class="endpoint-path">/api/auth/reset-password</div>
                <div class="endpoint-desc">Sets a new password given the email, the reset code, and the new password. The code expires after use or after a fixed time window.</div>
              </div>
            </div>
            <span class="auth-badge auth-public">Public</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-get">GET</span>
              <div>
                <div class="endpoint-path">/api/auth/me</div>
                <div class="endpoint-desc">Returns the authenticated user profile using Bearer JWT authorization header.</div>
              </div>
            </div>
            <span class="auth-badge auth-bearer">Bearer Token</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-post">POST</span>
              <div>
                <div class="endpoint-path">/api/auth/me/avatar</div>
                <div class="endpoint-desc">Uploads or replaces the authenticated user's profile picture (base64 PNG/JPEG/WEBP data URI, normalized to PNG server-side).</div>
              </div>
            </div>
            <span class="auth-badge auth-bearer">Bearer Token</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-get" style="background: rgba(239, 68, 68, 0.15); color: #fca5a5;">DEL</span>
              <div>
                <div class="endpoint-path">/api/auth/me/avatar</div>
                <div class="endpoint-desc">Removes the authenticated user's profile picture.</div>
              </div>
            </div>
            <span class="auth-badge auth-bearer">Bearer Token</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-get">GET</span>
              <div>
                <div class="endpoint-path">/api/auth/avatar/:userId</div>
                <div class="endpoint-desc">Serves a user's profile picture as raw image bytes — public with no auth, since it's used directly as an &lt;img&gt;/NetworkImage src.</div>
              </div>
            </div>
            <span class="auth-badge auth-public">Public</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-get">GET</span>
              <div>
                <div class="endpoint-path">/health</div>
                <div class="endpoint-desc">API health check status endpoint for load balancer & uptime monitoring.</div>
              </div>
            </div>
            <span class="auth-badge auth-public">Public</span>
          </div>

          <div class="endpoint-card">
            <div class="endpoint-meta">
              <span class="method-tag method-get">GET</span>
              <div>
                <div class="endpoint-path">/api/v1/docs/openapi.json</div>
                <div class="endpoint-desc">Raw OpenAPI 3.0 specification in JSON format.</div>
              </div>
            </div>
            <span class="auth-badge auth-public">Public</span>
          </div>
        </div>
      </section>

      <!-- Code Snippet Generator -->
      <section class="glass-card searchable-item" data-search="code snippets curl javascript nodejs python php sdk fetch requests">
        <div class="card-header">
          <div class="card-title-group">
            <div class="card-icon">
              <svg viewBox="0 0 24 24"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>
            </div>
            <div>
              <h2 class="card-title">Code Snippet Generator</h2>
              <p style="font-size: 0.85rem; color: var(--text-muted);">Ready-to-use request code for multiple programming languages</p>
            </div>
          </div>
        </div>

        <div class="snippet-container">
          <div class="snippet-header">
            <div class="snippet-tabs">
              <button class="lang-btn active" onclick="switchLang('curl')">cURL</button>
              <button class="lang-btn" onclick="switchLang('js')">JavaScript</button>
              <button class="lang-btn" onclick="switchLang('node')">Node.js</button>
              <button class="lang-btn" onclick="switchLang('python')">Python</button>
              <button class="lang-btn" onclick="switchLang('php')">PHP</button>
            </div>
            <button class="btn-copy" onclick="copySnippet()">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
              <span id="copyText">Copy</span>
            </button>
          </div>
          <div id="snippetBody" class="snippet-body">curl -X POST http://localhost:4000/api/auth/signup \\
  -H "Content-Type: application/json" \\
  -d '{
    "firstName": "Imo",
    "lastName": "Johnson",
    "email": "imo.dev@example.com",
    "phoneNumber": "+1234567890",
    "password": "SuperSecret123"
  }'</div>
        </div>
      </section>

      <!-- HTTP Status Codes & Troubleshooting -->
      <section class="glass-card searchable-item" data-search="error status codes 200 201 400 401 409 500 responses troubleshooting">
        <div class="card-header">
          <div class="card-title-group">
            <div class="card-icon">
              <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
            </div>
            <div>
              <h2 class="card-title">Response Status & Error Guide</h2>
              <p style="font-size: 0.85rem; color: var(--text-muted);">Standard HTTP status codes returned by the API</p>
            </div>
          </div>
        </div>

        <div class="error-grid">
          <div class="error-card">
            <div class="error-header">
              <span class="error-code err-2xx">201 CREATED</span>
              <strong style="color: #fff; font-size: 0.9rem;">Success</strong>
            </div>
            <p class="error-desc">Returned when a new user account is successfully registered during signup.</p>
          </div>

          <div class="error-card">
            <div class="error-header">
              <span class="error-code err-2xx">200 OK</span>
              <strong style="color: #fff; font-size: 0.9rem;">Success</strong>
            </div>
            <p class="error-desc">Returned for successful logins, profile requests, and health checks.</p>
          </div>

          <div class="error-card">
            <div class="error-header">
              <span class="error-code err-400">400 BAD REQUEST</span>
              <strong style="color: #fff; font-size: 0.9rem;">Validation Error</strong>
            </div>
            <p class="error-desc">Triggered when request body validation fails (e.g., password under 8 chars or invalid email).</p>
          </div>

          <div class="error-card">
            <div class="error-header">
              <span class="error-code err-401">401 UNAUTHORIZED</span>
              <strong style="color: #fff; font-size: 0.9rem;">Auth Failure</strong>
            </div>
            <p class="error-desc">Invalid email/password credentials or missing/invalid Bearer JWT token.</p>
          </div>

          <div class="error-card">
            <div class="error-header">
              <span class="error-code err-409">409 CONFLICT</span>
              <strong style="color: #fff; font-size: 0.9rem;">Duplicate Email</strong>
            </div>
            <p class="error-desc">Attempting to register with an email address that is already registered.</p>
          </div>
        </div>
      </section>

      <!-- Architecture & Tech Stack -->
      <section class="glass-card searchable-item" data-search="architecture technology stack express ts postgresql drizzle jwt bcrypt validation">
        <div class="card-header">
          <div class="card-title-group">
            <div class="card-icon">
              <svg viewBox="0 0 24 24"><rect x="2" y="2" width="20" height="8" rx="2" ry="2"></rect><rect x="2" y="14" width="20" height="8" rx="2" ry="2"></rect><line x1="6" y1="6" x2="6.01" y2="6"></line><line x1="6" y1="18" x2="6.01" y2="18"></line></svg>
            </div>
            <div>
              <h2 class="card-title">Architecture & Tech Stack</h2>
              <p style="font-size: 0.85rem; color: var(--text-muted);">Core system architecture highlights</p>
            </div>
          </div>
        </div>

        <div class="arch-grid">
          <div class="arch-card">
            <div class="arch-title-wrapper">
              <div class="arch-title-icon">
                <svg viewBox="0 0 24 24"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
              </div>
              <h3 class="arch-title">Express + TypeScript</h3>
            </div>
            <p class="arch-desc">Strongly typed request/response handlers with helmet security headers, cors, and custom error middleware.</p>
          </div>

          <div class="arch-card">
            <div class="arch-title-wrapper">
              <div class="arch-title-icon">
                <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
              </div>
              <h3 class="arch-title">JWT Token Auth</h3>
            </div>
            <p class="arch-desc">Stateless Bearer JWT tokens signed with secret key, verified on protected routes like <code style="color:#38bdf8">/api/auth/me</code>.</p>
          </div>

          <div class="arch-card">
            <div class="arch-title-wrapper">
              <div class="arch-title-icon">
                <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
              </div>
              <h3 class="arch-title">Password Encryption</h3>
            </div>
            <p class="arch-desc">Bcrypt cryptographic salt hashing for all passwords before storing in PostgreSQL.</p>
          </div>

          <div class="arch-card">
            <div class="arch-title-wrapper">
              <div class="arch-title-icon">
                <svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
              </div>
              <h3 class="arch-title">Input Validation</h3>
            </div>
            <p class="arch-desc">Strict request sanitization & schema validation using <code style="color:#38bdf8">express-validator</code> middleware.</p>
          </div>
        </div>
      </section>

    </div>
  </main>

  <footer>
    <div class="container">
      SecureByPay Technical Assessment • System Documentation Portal
    </div>
  </footer>

  <script>
    let activeToken = '';
    let currentLang = 'curl';

    const snippets = {
      curl: 'curl -X POST http://localhost:4000/api/auth/signup \\\n  -H "Content-Type: application/json" \\\n  -d \'{\n    "firstName": "Imo",\n    "lastName": "Johnson",\n    "email": "imo.dev@example.com",\n    "phoneNumber": "+1234567890",\n    "password": "SuperSecret123"\n  }\'',
      js: 'const response = await fetch(\'http://localhost:4000/api/auth/signup\', {\n  method: \'POST\',\n  headers: { \'Content-Type\': \'application/json\' },\n  body: JSON.stringify({\n    firstName: \'Imo\',\n    lastName: \'Johnson\',\n    email: \'imo.dev@example.com\',\n    phoneNumber: \'+1234567890\',\n    password: \'SuperSecret123\'\n  })\n});\nconst data = await response.json();\nconsole.log(data);',
      node: 'const axios = require(\'axios\');\n\nconst { data } = await axios.post(\'http://localhost:4000/api/auth/signup\', {\n  firstName: \'Imo\',\n  lastName: \'Johnson\',\n  email: \'imo.dev@example.com\',\n  phoneNumber: \'+1234567890\',\n  password: \'SuperSecret123\'\n});\nconsole.log(data);',
      python: 'import requests\n\nresponse = requests.post(\n    \'http://localhost:4000/api/auth/signup\',\n    json={\n        \'firstName\': \'Imo\',\n        \'lastName\': \'Johnson\',\n        \'email\': \'imo.dev@example.com\',\n        \'phoneNumber\': \'+1234567890\',\n        \'password\': \'SuperSecret123\'\n    }\n)\nprint(response.json())',
      php: '<?php\n$ch = curl_init(\'http://localhost:4000/api/auth/signup\');\ncurl_setopt($ch, CURLOPT_RETURNTRANSFER, true);\ncurl_setopt($ch, CURLOPT_HTTPHEADER, [\'Content-Type: application/json\']);\ncurl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([\n    \'firstName\' => \'Imo\',\n    \'lastName\' => \'Johnson\',\n    \'email\' => \'imo.dev@example.com\',\n    \'phoneNumber\' => \'+1234567890\',\n    \'password\' => \'SuperSecret123\'\n]));\n$response = curl_exec($ch);\ncurl_close($ch);\necho $response;'
    };

    function switchTab(tab) {
      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      document.querySelectorAll('form').forEach(f => f.style.display = 'none');
      document.getElementById('formFeedback').style.display = 'none';
      
      const btn = event.currentTarget;
      btn.classList.add('active');
      document.getElementById('form-' + tab).style.display = 'block';
    }

    function switchLang(lang) {
      currentLang = lang;
      document.querySelectorAll('.lang-btn').forEach(b => b.classList.remove('active'));
      event.currentTarget.classList.add('active');
      document.getElementById('snippetBody').textContent = snippets[lang];
    }

    function copySnippet() {
      const text = document.getElementById('snippetBody').textContent;
      navigator.clipboard.writeText(text);
      const copyText = document.getElementById('copyText');
      copyText.textContent = 'Copied!';
      setTimeout(() => copyText.textContent = 'Copy', 2000);
    }

    function filterContent() {
      const query = document.getElementById('searchInput').value.toLowerCase();
      document.querySelectorAll('.searchable-item').forEach(item => {
        const searchData = item.getAttribute('data-search') || '';
        const textContent = item.textContent.toLowerCase();
        if (searchData.includes(query) || textContent.includes(query)) {
          item.style.display = 'block';
        } else {
          item.style.display = 'none';
        }
      });
    }

    async function handleRequest(event, type) {
      event.preventDefault();
      const consoleBody = document.getElementById('consoleBody');
      const statusTag = document.getElementById('statusTag');
      const feedbackBanner = document.getElementById('formFeedback');
      
      consoleBody.textContent = '// Sending request...';
      feedbackBanner.style.display = 'none';

      let url = '';
      let method = 'POST';
      let headers = { 'Content-Type': 'application/json' };
      let body = null;

      if (type === 'signup') {
        url = '/api/auth/signup';
        body = JSON.stringify({
          firstName: document.getElementById('signup-firstName').value,
          lastName: document.getElementById('signup-lastName').value,
          email: document.getElementById('signup-email').value,
          phoneNumber: document.getElementById('signup-phoneNumber').value,
          password: document.getElementById('signup-password').value,
        });
      } else if (type === 'login') {
        url = '/api/auth/login';
        body = JSON.stringify({
          email: document.getElementById('login-email').value,
          password: document.getElementById('login-password').value,
        });
      } else if (type === 'forgot') {
        url = '/api/auth/forgot-password';
        body = JSON.stringify({
          email: document.getElementById('forgot-email').value,
        });
      } else if (type === 'reset') {
        url = '/api/auth/reset-password';
        body = JSON.stringify({
          email: document.getElementById('reset-email').value,
          token: document.getElementById('reset-token').value,
          password: document.getElementById('reset-password').value,
        });
      } else if (type === 'me') {
        url = '/api/auth/me';
        method = 'GET';
        const token = document.getElementById('me-token').value || activeToken;
        if (token) {
          headers['Authorization'] = 'Bearer ' + token;
        }
      }

      const startTime = performance.now();
      try {
        const res = await fetch(url, { method, headers, body });
        const latency = Math.round(performance.now() - startTime);
        const data = await res.json();

        if (data.data && data.data.token) {
          activeToken = data.data.token;
          document.getElementById('sessionToken').textContent = activeToken;
          document.getElementById('me-token').value = activeToken;
        }

        statusTag.style.display = 'inline-block';
        statusTag.textContent = res.status + ' ' + res.statusText + ' (' + latency + 'ms)';
        statusTag.className = 'status-tag ' + (res.ok ? 'status-2xx' : 'status-4xx');

        consoleBody.textContent = JSON.stringify(data, null, 2);

        // Display visual inline feedback banner
        feedbackBanner.style.display = 'flex';
        if (res.ok) {
          feedbackBanner.className = 'feedback-banner feedback-success';
          feedbackBanner.innerHTML = '<span><strong>Success (' + res.status + '):</strong> ' + (data.message || 'Operation completed successfully.') + '</span>';
        } else {
          let errText = data.message || 'Request failed';
          if (data.errors && Array.isArray(data.errors)) {
            errText += ': ' + data.errors.map(e => e.field ? e.field + ' - ' + e.message : e.message).join(', ');
          }
          feedbackBanner.className = 'feedback-banner feedback-error';
          feedbackBanner.innerHTML = '<span><strong>Error (' + res.status + '):</strong> ' + errText + '</span>';
        }

      } catch (err) {
        statusTag.style.display = 'inline-block';
        statusTag.textContent = 'ERROR';
        statusTag.className = 'status-tag status-5xx';
        consoleBody.textContent = '// Request Error: ' + err.message;

        feedbackBanner.style.display = 'flex';
        feedbackBanner.className = 'feedback-banner feedback-error';
        feedbackBanner.innerHTML = '<span><strong>Connection Error:</strong> ' + err.message + '</span>';
      }
    }
  </script>
</body>
</html>
`;