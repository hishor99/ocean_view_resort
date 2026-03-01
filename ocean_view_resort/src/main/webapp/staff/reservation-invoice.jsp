<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Reservation Invoice</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
  <style>
    .invoice { max-width: 820px; margin: 20px auto; }
    .invoice h2 { margin-bottom: 6px; }
    .invoice .row { display:flex; justify-content:space-between; gap:20px; }
    .invoice .box { padding:14px; border:1px solid #ddd; border-radius:10px; }
    @media print { .no-print { display:none; } body { background:#fff; } }
  </style>
</head>
<body>

<%
  Map<String,Object> inv = (Map<String,Object>) request.getAttribute("invoice");
%>

<div class="invoice card">
  <div class="row">
    <div>
      <h2>Reservation Invoice</h2>
      <p class="muted">Reservation No: <b><%= inv.get("reservationNo") %></b></p>
      <p class="muted">Status: <b><%= inv.get("status") %></b></p>
    </div>
    <div class="no-print">
      <button class="btn" onclick="window.print()">Print</button>
    </div>
  </div>

  <div class="row" style="margin-top:12px;">
    <div class="box" style="flex:1;">
      <h3>Room</h3>
      <p><b><%= inv.get("roomNumber") %></b> (<%= inv.get("roomType") %>)</p>
      <p>Capacity: <%= inv.get("capacity") %></p>
      <p>Price/Night: Rs. <%= inv.get("pricePerNight") %></p>
    </div>

    <div class="box" style="flex:1;">
      <h3>Stay</h3>
      <p>Check-In: <b><%= inv.get("checkIn") %></b></p>
      <p>Check-Out: <b><%= inv.get("checkOut") %></b></p>
      <p>Nights: <b><%= inv.get("nights") %></b></p>
      <p>Guests: <b><%= inv.get("guests") %></b></p>
    </div>
  </div>

  <div class="box" style="margin-top:12px;">
    <h3>Payment</h3>
    <p>Room Total: Rs. <b><%= inv.get("roomTotal") %></b></p>
    <p>Food Total: Rs. <b><%= inv.get("foodTotal") %></b></p>
    <p>Vehicle Total: Rs. <b><%= inv.get("vehicleTotal") %></b></p>
    <hr>
    <p style="font-size:18px;">Grand Total: Rs. <b><%= inv.get("grandTotal") %></b></p>
  </div>
</div>

</body>
</html>