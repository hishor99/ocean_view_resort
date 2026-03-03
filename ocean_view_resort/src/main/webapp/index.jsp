<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Ocean View Resort | Home</title>

  <!-- If you already have style.css, keep it. Otherwise this page has its own CSS below -->
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">

  <style>
    :root{
      --bg:#0b1220;
      --card:#0f1a33;
      --soft:#101f3d;
      --text:#eaf0ff;
      --muted:#b9c6ea;
      --line:rgba(255,255,255,.10);
      --brand:#66e3ff;
      --brand2:#8b7bff;
      --shadow: 0 16px 50px rgba(0,0,0,.35);
      --radius:18px;
      --radius2:26px;
    }
    *{box-sizing:border-box}
    body{
      margin:0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      background: radial-gradient(1200px 600px at 10% 0%, rgba(102,227,255,.14), transparent 60%),
                  radial-gradient(1000px 600px at 90% 10%, rgba(139,123,255,.12), transparent 55%),
                  var(--bg);
      color:var(--text);
    }
    a{color:inherit;text-decoration:none}
    .container{max-width:1100px;margin:0 auto;padding:0 18px}
    .nav{
      position:sticky;top:0;z-index:20;
      background:rgba(11,18,32,.75);
      backdrop-filter: blur(10px);
      border-bottom:1px solid var(--line);
    }
    .nav-inner{
      display:flex;align-items:center;justify-content:space-between;
      padding:14px 0;
    }
    .brand{
      display:flex;gap:10px;align-items:center;font-weight:800;letter-spacing:.3px
    }
    .logo{
      width:38px;height:38px;border-radius:12px;
      background: linear-gradient(135deg, var(--brand), var(--brand2));
      box-shadow: 0 10px 30px rgba(102,227,255,.15);
    }
    .nav-links{display:flex;gap:14px;align-items:center}
    .pill{
      padding:10px 14px;border-radius:999px;
      border:1px solid var(--line);
      background:rgba(255,255,255,.04);
      color:var(--text);
      font-weight:600;
    }
    .pill:hover{background:rgba(255,255,255,.08)}
    .btn{
      padding:10px 14px;border-radius:999px;
      background: linear-gradient(135deg, var(--brand), var(--brand2));
      color:#071021;font-weight:800;border:none;
      box-shadow: 0 14px 40px rgba(102,227,255,.14);
    }
    .btn:hover{filter:brightness(1.05)}
    .hero{
      padding:34px 0 18px;
    }
    .hero-grid{
      display:grid;grid-template-columns: 1.1fr .9fr;gap:18px;align-items:stretch;
    }
    .hero-card{
      border:1px solid var(--line);
      border-radius: var(--radius2);
      overflow:hidden;
      background: linear-gradient(180deg, rgba(255,255,255,.06), rgba(255,255,255,.02));
      box-shadow: var(--shadow);
      min-height: 420px;
      position:relative;
    }
    .hero-img{
      position:absolute;inset:0;
      background-image:
        linear-gradient(90deg, rgba(11,18,32,.30), rgba(11,18,32,.70)),
        url("<%=request.getContextPath()%>/assets/img/hero.jpg");
      background-size:cover;background-position:center;
    }
    .hero-content{
      position:relative;z-index:2;
      padding:28px;
      display:flex;flex-direction:column;gap:14px;
      height:100%;
      justify-content:flex-end;
    }
    .kicker{
      display:inline-flex;gap:8px;align-items:center;
      padding:8px 12px;border-radius:999px;
      border:1px solid var(--line);
      background:rgba(255,255,255,.06);
      color:var(--muted);
      width:fit-content;
      font-weight:700;
    }
    .headline{font-size:42px;line-height:1.05;margin:0}
    .sub{color:var(--muted);font-size:16px;max-width:560px;margin:0}
    .hero-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:6px}
    .ghost{
      padding:10px 14px;border-radius:999px;
      border:1px solid var(--line);
      background:rgba(255,255,255,.05);
      color:var(--text);
      font-weight:700;
    }
    .ghost:hover{background:rgba(255,255,255,.10)}
    .info-card{
      border:1px solid var(--line);
      border-radius: var(--radius2);
      background: rgba(255,255,255,.04);
      box-shadow: var(--shadow);
      padding:18px;
      display:flex;flex-direction:column;gap:12px;
      min-height:420px;
    }
    .mini{
      border:1px solid var(--line);
      background: rgba(255,255,255,.04);
      border-radius:16px;padding:14px;
    }
    .mini h4{margin:0 0 6px;font-size:14px;color:var(--muted);font-weight:800;letter-spacing:.4px;text-transform:uppercase}
    .mini p{margin:0;color:var(--text);font-weight:700}
    .stats{display:grid;grid-template-columns:1fr 1fr;gap:10px}
    .section{padding:22px 0}
    .section-title{display:flex;align-items:end;justify-content:space-between;gap:14px;margin-bottom:12px}
    .section-title h2{margin:0;font-size:22px}
    .section-title p{margin:0;color:var(--muted);max-width:520px}
    .grid3{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
    .card{
      border:1px solid var(--line);
      border-radius: var(--radius);
      background: rgba(255,255,255,.04);
      overflow:hidden;
      box-shadow: 0 14px 40px rgba(0,0,0,.25);
    }
    .card-img{
      height:150px;
      background-size:cover;background-position:center;
      filter:saturate(1.05);
    }
    .card-body{padding:14px}
    .tag{
      display:inline-block;
      font-size:12px;font-weight:900;color:#06101f;
      padding:6px 10px;border-radius:999px;
      background: linear-gradient(135deg, var(--brand), var(--brand2));
    }
    .card-body h3{margin:10px 0 6px;font-size:18px}
    .card-body p{margin:0;color:var(--muted);font-size:14px;line-height:1.5}
    .row{
      display:flex;gap:10px;flex-wrap:wrap;margin-top:12px
    }
    .price{
      font-weight:900;color:var(--text);
      padding:8px 10px;border-radius:12px;
      background: rgba(255,255,255,.06);
      border:1px solid var(--line);
    }
    .gallery{display:grid;grid-template-columns: 1.2fr .8fr;gap:14px}
    .g-big{min-height:320px;border-radius:var(--radius2);overflow:hidden;border:1px solid var(--line);background-size:cover;background-position:center;box-shadow:var(--shadow)}
    .g-side{display:grid;grid-template-columns:1fr;gap:14px}
    .g-small{min-height:153px;border-radius:var(--radius2);overflow:hidden;border:1px solid var(--line);background-size:cover;background-position:center;box-shadow:var(--shadow)}
    .cta{
      border-radius: var(--radius2);
      border:1px solid var(--line);
      background: linear-gradient(135deg, rgba(102,227,255,.10), rgba(139,123,255,.10));
      box-shadow: var(--shadow);
      padding:18px;
      display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap;
    }
    .cta h3{margin:0;font-size:20px}
    .cta p{margin:6px 0 0;color:var(--muted)}
    .footer{
      padding:24px 0;
      border-top:1px solid var(--line);
      color:var(--muted);
      font-size:13px;
    }

    @media (max-width: 900px){
      .hero-grid{grid-template-columns:1fr}
      .headline{font-size:34px}
      .grid3{grid-template-columns:1fr}
      .gallery{grid-template-columns:1fr}
      .g-side{grid-template-columns:1fr 1fr}
    }
    @media (max-width: 520px){
      .g-side{grid-template-columns:1fr}
      .nav-links{gap:10px}
      .pill{display:none} /* hide some links on tiny screens */
    }
  </style>
</head>
<body>

  <!-- Top Nav -->
  <div class="nav">
    <div class="container">
      <div class="nav-inner">
        <a class="brand" href="<%=request.getContextPath()%>/index.jsp">
          <div class="logo"></div>
          <div>
            Ocean View Resort<br/>
            <span style="font-size:12px;color:var(--muted);font-weight:700;">Colombo • Sri Lanka</span>
          </div>
        </a>

        <div class="nav-links">
          <a class="pill" href="#rooms">Rooms</a>
          <a class="pill" href="#gallery">Gallery</a>
          <a class="pill" href="#contact">Contact</a>

          <!-- Change these paths to your real servlets/JSPs -->
          <a class="ghost" href="<%=request.getContextPath()%>/auth/login.jsp">Login</a>
          <a class="btn" href="<%=request.getContextPath()%>/auth/register.jsp">Register</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Hero -->
  <div class="hero">
    <div class="container">
      <div class="hero-grid">

        <div class="hero-card">
          <div class="hero-img"></div>
          <div class="hero-content">
            <div class="kicker">🌴 Sea View • Luxury Rooms • Best Service</div>
            <h1 class="headline">Relax by the ocean.<br/>Book your perfect stay.</h1>
            <p class="sub">
              Explore rooms, request a quotation, and reserve online. Our reception team will confirm your booking and provide your reservation number.
            </p>

            <div class="hero-actions">
              <a class="btn" href="<%=request.getContextPath()%>/customer/reservations/new">Book a Room</a>
              <a class="ghost" href="<%=request.getContextPath()%>/customer/quotation">Request Quotation</a>
              <a class="ghost" href="#rooms">View Rooms</a>
            </div>
          </div>
        </div>

        <div class="info-card">
          <div class="mini">
            <h4>Quick Booking</h4>
            <p>Reserve online in 2 minutes</p>
          </div>
          <div class="mini">
            <h4>Reception Support</h4>
            <p>Confirmation + reservation number</p>
          </div>

          <div class="stats">
            <div class="mini">
              <h4>Location</h4>
              <p>Oceanfront View</p>
            </div>
            <div class="mini">
              <h4>Free</h4>
              <p>Wi-Fi & Breakfast</p>
            </div>
            <div class="mini">
              <h4>Facilities</h4>
              <p>Pool • Gym • Spa</p>
            </div>
            <div class="mini">
              <h4>Transport</h4>
              <p>Airport Pickup</p>
            </div>
          </div>

          <div class="mini" style="margin-top:auto;">
            <h4>Need help?</h4>
            <p>Call: +94 75 561 6274</p>
            <p style="color:var(--muted);font-weight:600;margin-top:6px;"></p>
          </div>
        </div>

      </div>
    </div>
  </div>

  <!-- Rooms -->
  <div class="section" id="rooms">
    <div class="container">
      <div class="section-title">
        <div>
          <h2>Popular Rooms</h2>
          <p>Choose a room type. You can request a quotation before confirming your reservation.</p>
        </div>
      </div>

      <div class="grid3">
        <div class="card">
          <div class="card-img" style="background-image:url('<%=request.getContextPath()%>/assets/img/room1.jpg')"></div>
          <div class="card-body">
            <span class="tag">Best Value</span>
            <h3>Standard Room</h3>
            <p>Comfortable room for couples or solo travelers with essential facilities.</p>
            <div class="row">
              <div class="price">From LKR 18,000 / night</div>
              <a class="ghost" href="<%=request.getContextPath()%>/customer/quotation">Get Quote</a>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-img" style="background-image:url('<%=request.getContextPath()%>/assets/img/room2.jpg')"></div>
          <div class="card-body">
            <span class="tag">Sea View</span>
            <h3>Deluxe Room</h3>
            <p>Sea-facing balcony, premium interior, perfect for a relaxing holiday.</p>
            <div class="row">
              <div class="price">From LKR 25,000 / night</div>
              <a class="ghost" href="<%=request.getContextPath()%>/customer/quotation">Get Quote</a>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-img" style="background-image:url('<%=request.getContextPath()%>/assets/img/room3.jpg')"></div>
          <div class="card-body">
            <span class="tag">Family</span>
            <h3>Suite Room</h3>
            <p>Spacious suite with living area, best for families and long stays.</p>
            <div class="row">
              <div class="price">From LKR 38,000 / night</div>
              <a class="ghost" href="<%=request.getContextPath()%>/customer/quotation">Get Quote</a>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>

  <!-- Gallery -->
  <div class="section" id="gallery">
    <div class="container">
      <div class="section-title">
        <div>
          <h2>Resort Gallery</h2>
          <p>Use real photos (best for presentation). Add images into <b>/assets/img/</b>.</p>
        </div>
      </div>

      <div class="gallery">
        <div class="g-big" style="background-image:url('<%=request.getContextPath()%>/assets/img/beach.jpg')"></div>
        <div class="g-side">
          <div class="g-small" style="background-image:url('<%=request.getContextPath()%>/assets/img/pool.jpg')"></div>
          <div class="g-small" style="background-image:url('<%=request.getContextPath()%>/assets/img/lobby.jpg')"></div>
        </div>
      </div>
    </div>
  </div>

  <!-- CTA -->
  <div class="section">
    <div class="container">
      <div class="cta">
        <div>
          <h3>Ready to book your stay?</h3>
          <p>Request a quotation or create a reservation online. Reception staff will confirm it.</p>
        </div>
        <div class="row">
          <a class="btn" href="<%=request.getContextPath()%>/customer/reservations/new">Book Now</a>
          <a class="ghost" href="<%=request.getContextPath()%>/customer/quotation">Request Quotation</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <div class="footer" id="contact">
    <div class="container">
      <div style="display:flex;justify-content:space-between;gap:14px;flex-wrap:wrap;">
        <div>
          <b style="color:var(--text)">Ocean View Resort</b><br/>
          <span>Colombo, Sri Lanka</span>
        </div>
        <div>
          <span>Email: info@oceanviewresort.lk</span><br/>
          <span>Phone: +94 XX XXX XXXX</span>
        </div>
      </div>
      <div style="margin-top:12px;color:rgba(185,198,234,.85)">
        © <%= java.time.Year.now() %> Ocean View Resort. All rights reserved.
      </div>
    </div>
  </div>

</body>
</html>