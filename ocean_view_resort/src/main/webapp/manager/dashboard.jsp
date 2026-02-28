<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manager Dashboard</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

  <!-- Dashboard specific styles (you can move to a separate css file later) -->
  <style>
    .dash-wrap{max-width:1100px;margin:24px auto;padding:0 16px;}
    .dash-header{
      display:flex;align-items:center;justify-content:space-between;gap:16px;
      background:#fff;border:1px solid #eee;border-radius:14px;padding:18px 18px;
      box-shadow:0 6px 18px rgba(0,0,0,.04);
    }
    .dash-title h2{margin:0;font-size:22px;}
    .dash-title p{margin:6px 0 0;color:#666;font-size:14px;}

    .dash-actions{display:flex;gap:10px;flex-wrap:wrap;}
    .btn{
      display:inline-flex;align-items:center;gap:8px;
      padding:10px 14px;border-radius:10px;border:1px solid #e6e6e6;
      background:#f8f8f8;color:#111;text-decoration:none;font-weight:600;
      transition:.15s ease-in-out;
    }
    .btn:hover{transform:translateY(-1px);background:#f1f1f1;}
    .btn.primary{background:#111;color:#fff;border-color:#111;}
    .btn.primary:hover{background:#000;}

    .grid{
      display:grid;grid-template-columns:repeat(3, minmax(0,1fr));
      gap:14px;margin-top:16px;
    }
    @media (max-width:900px){ .grid{grid-template-columns:repeat(2,1fr);} }
    @media (max-width:600px){ .grid{grid-template-columns:1fr;} }

    .tile{
      background:#fff;border:1px solid #eee;border-radius:14px;padding:16px;
      box-shadow:0 6px 18px rgba(0,0,0,.04);
      display:flex;flex-direction:column;gap:10px;
      transition:.15s ease-in-out;
    }
    .tile:hover{transform:translateY(-2px);}
    .tile-top{display:flex;align-items:center;justify-content:space-between;gap:10px;}
    .badge{
      font-size:12px;color:#333;background:#f2f2f2;border:1px solid #e6e6e6;
      padding:4px 10px;border-radius:999px;
    }
    .tile h3{margin:0;font-size:16px;}
    .tile p{margin:0;color:#666;font-size:13px;line-height:1.4;}
    .tile a{
      margin-top:auto;
      display:inline-flex;justify-content:center;
      padding:10px 12px;border-radius:10px;
      text-decoration:none;font-weight:700;border:1px solid #e6e6e6;
      background:#fafafa;color:#111;
    }
    .tile a:hover{background:#f1f1f1;}

    .footer{
      text-align:center;color:#777;margin:26px 0 10px;font-size:13px;
    }
  </style>
</head>

<body>
<jsp:include page="/includes/navbar.jsp" />

<div class="dash-wrap">

  <!-- Top Header -->
  <div class="dash-header">
    <div class="dash-title">
      <h2>Manager Dashboard</h2>
      <p>System control & monitoring panel for Ocean View Resort.</p>
    </div>

    <div class="dash-actions">
      <a class="btn primary" href="<%= request.getContextPath() %>/manager/reports">View Reports</a>
      <a class="btn" href="<%= request.getContextPath() %>/manager/add-staff">+ Add Staff</a>
      <a class="btn" href="<%= request.getContextPath() %>/manager/add-room">+ Add Room</a>
    </div>
  </div>

  <!-- Quick Tiles -->
  <div class="grid">

    <div class="tile">
      <div class="tile-top">
        <h3>Staff Management</h3>
        <span class="badge">Admin</span>
      </div>
      <p>Add new staff members and manage roles & status.</p>
      <a href="<%= request.getContextPath() %>/manager/manage-staff">Open Staff Panel</a>
    </div>

    <div class="tile">
      <div class="tile-top">
        <h3>Rooms</h3>
        <span class="badge">Pricing</span>
      </div>
      <p>Manage room types, availability, and update room prices.</p>
      <a href="<%= request.getContextPath() %>/manager/rooms">Manage Room Prices</a>
    </div>

    <div class="tile">
      <div class="tile-top">
        <h3>Food Packages</h3>
        <span class="badge">Menu</span>
      </div>
      <p>Add or update food package options for customers.</p>
      <a href="<%= request.getContextPath() %>/manager/food-packages">Manage Food Packages</a>
    </div>

    <div class="tile">
      <div class="tile-top">
        <h3>Vehicles</h3>
        <span class="badge">Transport</span>
      </div>
      <p>Maintain available vehicles and pricing for transport services.</p>
      <a href="<%= request.getContextPath() %>/manager/vehicles">Manage Vehicles</a>
    </div>

    <div class="tile">
      <div class="tile-top">
        <h3>Add Rooms</h3>
        <span class="badge">Setup</span>
      </div>
      <p>Create new room entries and set default settings.</p>
      <a href="<%= request.getContextPath() %>/manager/add-room">Add New Room</a>
    </div>

    <div class="tile">
      <div class="tile-top">
        <h3>Reports & Monitoring</h3>
        <span class="badge">Insights</span>
      </div>
      <p>Track reservations, staff activities, and system usage.</p>
      <a href="<%= request.getContextPath() %>/manager/reports">View Reports</a>
    </div>

  </div>

  <div class="footer">© 2026 Ocean View Resort.</div>
</div>

</body>
</html>