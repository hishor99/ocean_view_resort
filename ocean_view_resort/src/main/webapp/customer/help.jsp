<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Help & Support</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  :root{
    --bg:#f5f7fb; --card:#fff; --text:#0f172a; --muted:#64748b;
    --primary:#2563eb; --border:#e5e7eb;
    --shadow:0 10px 25px rgba(2,6,23,.08);
    --radius:16px;
  }
  body{ background:var(--bg); color:var(--text); }
  .wrap{ max-width: 980px; margin: 18px auto 70px; padding: 0 16px; }

  .hero{
    background: linear-gradient(90deg, rgba(37,99,235,.12), rgba(37,99,235,.02));
    border:1px solid var(--border); border-radius: var(--radius);
    box-shadow: var(--shadow);
    padding: 20px;
  }
  .hero h2{ margin:0; font-size:22px; }
  .hero p{ margin:6px 0 0; color:var(--muted); }

  .search{
    margin-top: 14px;
    display:flex; gap:10px; align-items:center;
    background:#fff;
    border:1px solid var(--border);
    border-radius: 14px;
    padding: 10px 12px;
  }
  .search input{
    width:100%;
    border:none; outline:none;
    font-size:14px;
  }

  .section{
    margin-top:16px;
    background:#fff; border:1px solid var(--border);
    border-radius: var(--radius);
    padding: 16px;
    box-shadow: 0 6px 16px rgba(2,6,23,.06);
  }

  .faq-item{
    border:1px solid var(--border);
    border-radius: 14px;
    overflow:hidden;
    margin-top:12px;
  }
  .faq-q{
    width:100%;
    background:#fff;
    border:none;
    text-align:left;
    padding: 14px 14px;
    font-weight:900;
    font-size:14px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    cursor:pointer;
  }
  .faq-a{
    display:none;
    padding: 0 14px 14px;
    color: var(--muted);
    line-height: 1.5;
    font-size: 13.5px;
  }
  .chev{
    width:20px;height:20px; flex:0 0 auto;
    transition: transform .15s ease;
  }
  .open .faq-a{ display:block; }
  .open .chev{ transform: rotate(180deg); }

  .pill{
    display:inline-flex; gap:8px; align-items:center;
    padding:8px 10px; border-radius:999px;
    border:1px solid var(--border);
    background:#f8fafc;
    font-weight:900; font-size:12.5px; color:#334155;
  }
  .footer{ text-align:center; color:var(--muted); margin-top:18px; padding:18px 10px; }
</style>
</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">

  <div class="hero">
    <h2>Help & Support</h2>
    <p>Find answers quickly using the FAQ below. If you still need help, contact the reception.</p>

    <div class="search">
      <svg viewBox="0 0 24 24" width="18" height="18" style="fill:#64748b;">
        <path d="M10 2a8 8 0 105.29 14.29l4.2 4.2 1.41-1.41-4.2-4.2A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z"/>
      </svg>
      <input id="faqSearch" type="text" placeholder="Search help topics (e.g., rooms, reservation, status)..." />
    </div>

    <div style="margin-top:12px; display:flex; gap:10px; flex-wrap:wrap;">
      <span class="pill">📌 Common Issues</span>
      <span class="pill">🛏 Rooms & Pricing</span>
      <span class="pill">📅 Reservations</span>
      <span class="pill">☎ Contact</span>
    </div>
  </div>

  <div class="section">
    <h3 style="margin:0 0 6px;">FAQ</h3>
    <p style="margin:0; color:#64748b; font-size:13px;">Click a question to view the answer.</p>

    <div class="faq-item" data-keywords="rooms price room pricing view rooms">
      <button class="faq-q" type="button">
        How can I view room prices and details?
        <svg class="chev" viewBox="0 0 24 24"><path d="M7 10l5 5 5-5z"/></svg>
      </button>
      <div class="faq-a">
        Go to <b>Customer Dashboard → View Rooms</b>. You can see room types, prices, and details there.
      </div>
    </div>

    <div class="faq-item" data-keywords="reservation history status confirmed pending">
      <button class="faq-q" type="button">
        Where can I see my reservation history?
        <svg class="chev" viewBox="0 0 24 24"><path d="M7 10l5 5 5-5z"/></svg>
      </button>
      <div class="faq-a">
        On the dashboard, check <b>Reservation History</b> section. You can also click <b>My Reservations</b> to view all.
      </div>
    </div>

    <div class="faq-item" data-keywords="pending confirmed cancel change dates">
      <button class="faq-q" type="button">
        What does “Pending” mean in my reservation status?
        <svg class="chev" viewBox="0 0 24 24"><path d="M7 10l5 5 5-5z"/></svg>
      </button>
      <div class="faq-a">
        “Pending” means your request is received and waiting for reception staff confirmation. Once approved, it becomes “Confirmed”.
      </div>
    </div>

    <div class="faq-item" data-keywords="login password forgot reset">
      <button class="faq-q" type="button">
        I forgot my password. What should I do?
        <svg class="chev" viewBox="0 0 24 24"><path d="M7 10l5 5 5-5z"/></svg>
      </button>
      <div class="faq-a">
        If you have a password reset feature, use it from the login page. Otherwise, contact reception for support.
      </div>
    </div>

    <div class="faq-item" data-keywords="contact phone email help support reception">
      <button class="faq-q" type="button">
        How do I contact the resort for help?
        <svg class="chev" viewBox="0 0 24 24"><path d="M7 10l5 5 5-5z"/></svg>
      </button>
      <div class="faq-a">
        Contact reception via phone or email (add your real contact details here). You can also visit the resort for face-to-face support.
      </div>
    </div>

  </div>

  <div class="footer">
    © 2026 Ocean View Resort. All rights reserved.
  </div>

</div>

<script>
  // Accordion toggle
  document.querySelectorAll(".faq-item .faq-q").forEach(btn => {
    btn.addEventListener("click", () => {
      btn.parentElement.classList.toggle("open");
    });
  });

  // Search filter
  const input = document.getElementById("faqSearch");
  const items = Array.from(document.querySelectorAll(".faq-item"));

  input.addEventListener("input", () => {
    const q = input.value.toLowerCase().trim();
    items.forEach(item => {
      const text = (item.innerText + " " + (item.dataset.keywords || "")).toLowerCase();
      item.style.display = text.includes(q) ? "" : "none";
    });
  });
</script>

</body>
</html>