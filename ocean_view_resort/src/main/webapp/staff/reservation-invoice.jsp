<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reservation Invoice</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

  <style>
    :root{
      --bg:#f6f7fb;
      --card:#ffffff;
      --text:#1f2937;
      --muted:#6b7280;
      --line:#e5e7eb;
      --brand:#0b3d91;
      --brand2:#1458c2;
      --success:#16a34a;
      --warn:#f59e0b;
      --danger:#dc2626;
      --shadow: 0 10px 30px rgba(15, 23, 42, .08);
      --radius: 16px;
    }
    body{ background:var(--bg); color:var(--text); }
    .container{ max-width: 980px; margin: 24px auto; padding: 0 14px; }

    .invoice-card{
      background: var(--card);
      border: 1px solid var(--line);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow: hidden;
    }

    .header{
      padding: 18px 20px;
      background: linear-gradient(135deg, var(--brand), var(--brand2));
      color: #fff;
      display:flex;
      align-items:flex-start;
      justify-content:space-between;
      gap: 16px;
    }
    .brand h2{ margin:0; font-size: 22px; letter-spacing: .2px; }
    .brand p{ margin: 6px 0 0; color: rgba(255,255,255,.85); font-size: 13px; }
    .header-right{ text-align:right; }
    .badge{
      display:inline-block;
      padding: 6px 10px;
      border-radius: 999px;
      background: rgba(255,255,255,.18);
      border: 1px solid rgba(255,255,255,.25);
      font-size: 12px;
      font-weight: 600;
      margin-top: 6px;
    }
    .actions{ margin-top: 10px; display:flex; gap:10px; justify-content:flex-end; flex-wrap:wrap; }

    .btn{
      border:0;
      border-radius: 10px;
      padding: 10px 14px;
      cursor:pointer;
      font-weight: 600;
      display:inline-flex;
      align-items:center;
      gap:8px;
      transition: transform .04s ease, opacity .2s ease;
    }
    .btn:active{ transform: translateY(1px); }
    .btn-primary{ background:#fff; color: var(--brand); }
    .btn-ghost{ background: rgba(255,255,255,.18); color:#fff; border:1px solid rgba(255,255,255,.25); }
    .btn:hover{ opacity:.92; }

    .content{ padding: 18px 20px 22px; }

    .grid{
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
      margin-top: 14px;
    }
    @media (max-width: 780px){
      .grid{ grid-template-columns: 1fr; }
      .header{ flex-direction: column; align-items: stretch; }
      .header-right{ text-align:left; }
      .actions{ justify-content:flex-start; }
    }

    .panel{
      border: 1px solid var(--line);
      border-radius: 14px;
      padding: 14px 14px 12px;
      background:#fff;
    }
    .panel h3{
      margin:0 0 10px;
      font-size: 15px;
      color: var(--text);
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:10px;
    }
    .muted{ color: var(--muted); }

    .kv{
      display:grid;
      grid-template-columns: 140px 1fr;
      row-gap: 8px;
      column-gap: 10px;
      font-size: 14px;
    }
    .kv .k{ color: var(--muted); }
    .kv .v{ font-weight: 600; color: var(--text); }

    .totals{
      margin-top: 14px;
      border: 1px solid var(--line);
      border-radius: 14px;
      overflow:hidden;
      background:#fff;
    }
    .totals-head{
      padding: 12px 14px;
      border-bottom: 1px solid var(--line);
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:12px;
    }
    .totals-head h3{ margin:0; font-size: 15px; }
    .totals-body{ padding: 12px 14px; }
    .line{
      display:flex;
      justify-content:space-between;
      gap:12px;
      padding: 8px 0;
      font-size: 14px;
      border-bottom: 1px dashed var(--line);
    }
    .line:last-child{ border-bottom:0; }
    .amount{ font-weight: 700; }
    .grand{
      margin-top: 10px;
      padding-top: 12px;
      border-top: 2px solid var(--line);
      display:flex;
      justify-content:space-between;
      font-size: 18px;
      font-weight: 800;
    }

    .footer-note{
      margin-top: 14px;
      font-size: 12px;
      color: var(--muted);
      display:flex;
      justify-content:space-between;
      gap: 10px;
      flex-wrap:wrap;
    }

    /* Print */
    @media print{
      body{ background:#fff; }
      .no-print{ display:none !important; }
      .container{ max-width: 100%; margin:0; padding:0; }
      .invoice-card{ box-shadow:none; border: 0; }
      .panel, .totals{ border-color:#ccc; }
      .header{ background: #0b3d91 !important; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    }
  </style>
</head>

<body>
<%
  Map<String,Object> inv = (Map<String,Object>) request.getAttribute("invoice");
  if (inv == null) { inv = new HashMap<>(); } // safety (prevents null crash)
  String status = String.valueOf(inv.get("status"));
%>

<div class="container">
  <div class="invoice-card">

    <!-- Header -->
    <div class="header">
      <div class="brand">
        <h2>Reservation Invoice</h2>
        <p>Ocean View Resort • Staff Billing / Receipt</p>
      </div>

      <div class="header-right">
        <div style="font-size:13px; opacity:.95;">Reservation No</div>
        <div style="font-size:18px; font-weight:800;">
          <%= inv.get("reservationNo") %>
        </div>

        <div class="badge">
          Status: <%= status %>
        </div>

        <div class="actions no-print">
          <button class="btn btn-primary" onclick="window.print()">
            🖨️ Print
          </button>
          <button class="btn btn-ghost" onclick="history.back()">
            ← Back
          </button>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="content">

      <div class="grid">
        <!-- Room Panel -->
        <div class="panel">
          <h3>
            Room Details
            <span class="muted">#<%= inv.get("roomNumber") %></span>
          </h3>
          <div class="kv">
            <div class="k">Room Type</div><div class="v"><%= inv.get("roomType") %></div>
            <div class="k">Capacity</div><div class="v"><%= inv.get("capacity") %></div>
            <div class="k">Price / Night</div><div class="v">Rs. <%= inv.get("pricePerNight") %></div>
          </div>
        </div>

        <!-- Stay Panel -->
        <div class="panel">
          <h3>Stay Information <span class="muted">Dates</span></h3>
          <div class="kv">
            <div class="k">Check-In</div><div class="v"><%= inv.get("checkIn") %></div>
            <div class="k">Check-Out</div><div class="v"><%= inv.get("checkOut") %></div>
            <div class="k">Nights</div><div class="v"><%= inv.get("nights") %></div>
            <div class="k">Guests</div><div class="v"><%= inv.get("guests") %></div>
          </div>
        </div>
      </div>

      <!-- Totals -->
      <div class="totals">
        <div class="totals-head">
          <h3>Payment Summary</h3>
          <span class="muted">All prices in LKR (Rs.)</span>
        </div>
        <div class="totals-body">
          <div class="line">
            <span class="muted">Room Total</span>
            <span class="amount">Rs. <%= inv.get("roomTotal") %></span>
          </div>
          <div class="line">
            <span class="muted">Food Total</span>
            <span class="amount">Rs. <%= inv.get("foodTotal") %></span>
          </div>
          <div class="line">
            <span class="muted">Vehicle Total</span>
            <span class="amount">Rs. <%= inv.get("vehicleTotal") %></span>
          </div>

          <div class="grand">
            <span>Grand Total</span>
            <span>Rs. <%= inv.get("grandTotal") %></span>
          </div>
        </div>
      </div>

      <div class="footer-note">
        <div>Generated on: <%= new java.util.Date() %></div>
        <div class="muted">Thank you for choosing Ocean View Resort.</div>
      </div>

    </div>
  </div>
</div>

</body>
</html>