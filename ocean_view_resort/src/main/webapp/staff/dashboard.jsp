<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reception Dashboard</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
  <style>
    /* --- Dashboard Enhancements (only affects this page) --- */
    .dash-hero{
      padding:18px;
      border-radius:16px;
      border:1px solid #e9e9e9;
      background:#fff;
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:16px;
      margin-bottom:14px;
    }
    .dash-hero h2{ margin:0 0 6px 0; font-size:22px; }
    .dash-hero p{ margin:0; color:#666; }

    .pill{
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding:10px 12px;
      border-radius:999px;
      background:#f6f6f6;
      border:1px solid #e9e9e9;
      font-size:14px;
      color:#333;
      white-space:nowrap;
    }

    .grid{
      display:grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap:14px;
    }
    @media (max-width: 820px){
      .grid{ grid-template-columns:1fr; }
      .dash-hero{ flex-direction:column; align-items:flex-start; }
    }

    .action-card{
      border:1px solid #e9e9e9;
      border-radius:16px;
      background:#fff;
      padding:16px;
      transition: transform .15s ease, box-shadow .15s ease;
      display:flex;
      gap:12px;
      align-items:flex-start;
    }
    .action-card:hover{
      transform: translateY(-2px);
      box-shadow: 0 10px 24px rgba(0,0,0,.06);
    }

    .icon{
      width:44px;
      height:44px;
      border-radius:12px;
      border:1px solid #e9e9e9;
      background:#fafafa;
      display:flex;
      align-items:center;
      justify-content:center;
      font-size:18px;
      flex:0 0 auto;
    }

    .action-card h3{
      margin:0 0 6px 0;
      font-size:16px;
    }
    .action-card p{
      margin:0 0 10px 0;
      color:#666;
      font-size:14px;
      line-height:1.4;
    }

    .btn-link{
      display:inline-block;
      padding:9px 12px;
      border-radius:10px;
      border:1px solid #e0e0e0;
      background:#f4f4f4;
      text-decoration:none;
      color:#111;
      font-size:14px;
    }
    .btn-link:hover{ background:#eee; }

    .btn-primary{
      background:#111;
      color:#fff;
      border-color:#111;
    }
    .btn-primary:hover{ background:#000; }

    .muted{ color:#666; }
  </style>
</head>
<body>

  <jsp:include page="/includes/header.jsp" />
  <jsp:include page="/includes/navbar.jsp" />

  <div class="container">

    <!-- Hero / Header -->
    <div class="dash-hero">
      <div>
        <h2>Reception Staff Dashboard</h2>
        <p class="muted">Manage reservations, confirmations, and customer support from one place.</p>
      </div>
      <div class="pill">🧾 <span>Quick Access</span></div>
    </div>

    <!-- Actions Grid -->
    <div class="grid">

      <!-- Pending Reservations -->
      <div class="action-card">
        <div class="icon">⏳</div>
        <div>
          <h3>Pending Reservations</h3>
          <p>View new reservation requests and confirm or cancel quickly.</p>
          <a class="btn-link btn-primary" href="<%= request.getContextPath() %>/staff/view-reservations">
            Open Pending List →
          </a>
        </div>
      </div>

      <!-- Add Reservation (✅ FIXED: goes to servlet, not JSP) -->
      <div class="action-card">
        <div class="icon">➕</div>
        <div>
          <h3>Add New Reservation</h3>
          <p>Create a reservation for walk-in customers (face-to-face service).</p>
          <a class="btn-link" href="<%= request.getContextPath() %>/staff/add-reservation">
            Create Reservation →
          </a>
        </div>
      </div>

      <!-- Reservation Details -->
      <div class="action-card">
        <div class="icon">🔎</div>
        <div>
          <h3>Reservation Details</h3>
          <p>Search and view reservation details using reservation number.</p>
          <a class="btn-link" href="<%= request.getContextPath() %>/staff/reservation-details.jsp">
            View Details →
          </a>
        </div>
      </div>

      <!-- Help -->
      <div class="action-card">
        <div class="icon">❓</div>
        <div>
          <h3>Help & Guidelines</h3>
          <p>Quick help for staff operations and common customer questions.</p>
          <a class="btn-link" href="<%= request.getContextPath() %>/staff/help.jsp">
            Open Help →
          </a>
        </div>
      </div>

    </div>
  </div>

  <jsp:include page="/includes/footer.jsp" />

</body>
</html>