<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reservation Details</title>
  <style>
    body{font-family:Arial;margin:20px}
    .card{border:1px solid #eee;border-radius:12px;padding:16px;max-width:900px}
    table{width:100%;border-collapse:collapse}
    td{padding:8px;border-bottom:1px solid #f0f0f0}
    .right{text-align:right}
    .btn{padding:10px 14px;border-radius:10px;border:1px solid #111;background:#111;color:#fff;cursor:pointer}
  </style>
</head>
<body>

<jsp:include page="/includes/navbar.jsp" />

<c:if test="${not empty error}">
  <p style="color:red">${error}</p>
</c:if>

<c:if test="${not empty res}">
  <div class="card" id="printArea">
    <h2>Reservation Details</h2>
    <p><b>Reservation No:</b> ${res.reservationNo}</p>

    <table>
      <tr><td><b>Guest Name</b></td><td>${res.guestName}</td></tr>
      <tr><td><b>Address</b></td><td>${res.guestAddress}</td></tr>
      <tr><td><b>Phone</b></td><td>${res.guestPhone}</td></tr>
      <tr><td><b>Email</b></td><td>${res.guestEmail}</td></tr>

      <tr><td><b>Room</b></td><td>Room ${res.roomNumber} (${res.roomType})</td></tr>
      <tr><td><b>Check-in</b></td><td>${res.checkIn}</td></tr>
      <tr><td><b>Check-out</b></td><td>${res.checkOut}</td></tr>
      <tr><td><b>Nights</b></td><td>${res.nights}</td></tr>

      <tr><td><b>Rate / Night</b></td><td class="right">LKR ${res.roomRate}</td></tr>
      <tr><td><b>Total</b></td><td class="right"><b>LKR ${res.roomTotal}</b></td></tr>
    </table>

    <p><b>Status:</b> ${res.status}</p>
  </div>

  <br>
  <button class="btn" onclick="window.print()">Print Bill</button>
</c:if>

</body>
</html>