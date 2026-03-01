<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Room" %>
<%@ page import="model.FoodPackage" %>
<%@ page import="model.Vehicle" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Final Quote</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  :root{
    --bg:#f5f7fb; --card:#fff; --text:#0f172a; --muted:#64748b;
    --primary:#2563eb; --primary2:#1d4ed8; --border:#e5e7eb;
    --shadow:0 10px 25px rgba(2,6,23,.08);
    --radius:16px;
  }
  body{ background:var(--bg); color:var(--text); }

  .wrap{ max-width:900px; margin:30px auto 70px; padding:0 16px; }

  .invoice{
    background:var(--card);
    border:1px solid var(--border);
    border-radius:var(--radius);
    box-shadow:var(--shadow);
    padding:24px;
  }

  .head{
    display:flex; justify-content:space-between; align-items:flex-start;
    margin-bottom:20px;
  }

  .title{ font-size:22px; font-weight:900; margin:0; }
  .muted{ color:var(--muted); font-size:13px; }

  .badge{
    display:inline-flex; align-items:center;
    padding:8px 12px;
    border-radius:999px;
    background:rgba(245,158,11,.15);
    color:#92400e;
    font-weight:900;
    font-size:13px;
  }

  table{
    width:100%;
    border-collapse:collapse;
    margin-top:16px;
  }

  th, td{
    padding:12px;
    text-align:left;
    border-bottom:1px solid var(--border);
    font-size:14px;
  }

  th{
    background:#f8fafc;
    font-weight:900;
  }

  .right{ text-align:right; }

  .total{
    font-size:18px;
    font-weight:900;
    color:var(--primary2);
  }

  .actions{
    margin-top:20px;
    display:flex;
    gap:12px;
    flex-wrap:wrap;
  }

  .btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    background:var(--primary);
    color:#fff;
    border:none;
    padding:10px 16px;
    border-radius:12px;
    font-weight:900;
    text-decoration:none;
    cursor:pointer;
    transition:.2s;
  }

  .btn:hover{ background:var(--primary2); }

  .btn-outline{
    background:#fff;
    color:var(--primary2);
    border:1px solid rgba(37,99,235,.3);
  }

  .btn-outline:hover{
    background:rgba(37,99,235,.08);
  }

  @media print {
    .actions { display:none; }
    body { background:#fff; }
  }
</style>
</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">
<%
  Room room = (Room) request.getAttribute("room");
  FoodPackage food = (FoodPackage) request.getAttribute("food");
  Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
%>

<div class="invoice">

  <div class="head">
    <div>
      <h2 class="title">Reservation Quote</h2>
      <div class="muted">
        Reservation ID: <%= request.getAttribute("reservationId") %><br>
        Check-in: <%= request.getAttribute("checkIn") %> |
        Check-out: <%= request.getAttribute("checkOut") %><br>
        Nights: <%= request.getAttribute("nights") %> |
        Guests: <%= request.getAttribute("guests") %>
      </div>
    </div>
    <div class="badge">Pending Confirmation</div>
  </div>

  <table>
    <thead>
      <tr>
        <th>Description</th>
        <th class="right">Amount (Rs.)</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Room <%= room.getRoomNumber() %> - <%= room.getRoomType() %></td>
        <td class="right"><%= request.getAttribute("roomTotal") %></td>
      </tr>

      <tr>
        <td>
          Food Package
          <% if (food != null) { %>
            (<%= food.getName() %>)
          <% } else { %>
            (None)
          <% } %>
        </td>
        <td class="right"><%= request.getAttribute("foodTotal") %></td>
      </tr>

      <tr>
        <td>
          Vehicle Service
          <% if (vehicle != null) { %>
            (<%= vehicle.getType() %> - <%= vehicle.getModel() %>)
          <% } else { %>
            (None)
          <% } %>
        </td>
        <td class="right"><%= request.getAttribute("vehicleTotal") %></td>
      </tr>

      <tr>
        <td class="total">Grand Total</td>
        <td class="right total">
          <%= request.getAttribute("grandTotal") %>
        </td>
      </tr>
    </tbody>
  </table>

  <div class="actions">
    <button class="btn" onclick="window.print()">Print Quote</button>
    <a class="btn btn-outline"
       href="<%= request.getContextPath() %>/customer/dashboard.jsp">
       Back to Dashboard
    </a>
  </div>

</div>
</div>

</body>
</html>