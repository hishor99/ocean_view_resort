<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pending Reservations</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  body{ background:#f5f7fb; }
  .wrap{ max-width:1100px; margin:20px auto 70px; padding:0 16px; }
  .card{ background:#fff; border:1px solid #e5e7eb; border-radius:16px; padding:16px; margin-bottom:14px; }
  table{ width:100%; border-collapse:collapse; min-width:900px; }
  th,td{ padding:12px; border-bottom:1px solid #e5e7eb; text-align:left; }
  th{ background:#f8fafc; font-weight:900; }
  .table-wrap{ overflow:auto; border:1px solid #e5e7eb; border-radius:14px; }
  .btn{ background:#2563eb; color:#fff; border:none; padding:8px 12px; border-radius:10px; font-weight:900; cursor:pointer; }
  .btn:hover{ background:#1d4ed8; }
</style>
</head>
<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">

  <div class="card">
    <h2 style="margin:0;">Pending Reservations</h2>
    <p style="margin:6px 0 0; color:#64748b;">
      Confirm reservations to generate reservation number and mark room as <b>BOOKED</b>.
    </p>
  </div>

  <div class="card table-wrap">
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Room</th>
          <th>Check-in</th>
          <th>Check-out</th>
          <th>Nights</th>
          <th>Guests</th>
          <th>Total</th>
          <th>Action</th>
        </tr>
      </thead>

      <tbody>
      <%
        List<Map<String,Object>> pending = (List<Map<String,Object>>) request.getAttribute("pending");
        if (pending == null || pending.isEmpty()) {
      %>
        <tr>
          <td colspan="8" style="color:#64748b; font-weight:800;">No pending reservations.</td>
        </tr>
      <%
        } else {
          for (Map<String,Object> r : pending) {
      %>
        <tr>
          <td><%= r.get("reservationId") %></td>
          <td><b><%= r.get("roomNumber") %></b> - <%= r.get("roomType") %></td>
          <td><%= r.get("checkIn") %></td>
          <td><%= r.get("checkOut") %></td>
          <td><%= r.get("nights") %></td>
          <td><%= r.get("guests") %></td>
          <td>Rs. <%= r.get("grandTotal") %></td>
          <td>
            <!-- ✅ Correct URL + Correct param name -->
            <form method="post" action="<%= request.getContextPath() %>/staff/confirm-reservation">
  <input type="hidden" name="id" value="<%= r.get("reservationId") %>">
  <button class="btn" type="submit">Confirm</button>
</form>
          </td>
        </tr>
      <%
          }
        }
      %>
      </tbody>
    </table>
  </div>

</div>

</body>
</html>