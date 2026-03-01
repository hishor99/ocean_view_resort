<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>All Reservations</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">
  <div class="card">
    <h2>All Reservations</h2>

    <form method="get" action="<%= request.getContextPath() %>/manager/reservations">
      <select name="status">
        <option value="ALL">ALL</option>
        <option value="PENDING">PENDING</option>
        <option value="CONFIRMED">CONFIRMED</option>
        <option value="CANCELLED">CANCELLED</option>
      </select>
      <button class="btn" type="submit">Filter</button>
    </form>
  </div>

  <div class="card">
    <%
      List<Map<String,Object>> list = (List<Map<String,Object>>) request.getAttribute("list");
      if (list == null || list.isEmpty()) {
    %>
      <p class="muted">No reservations found.</p>
    <%
      } else {
    %>
      <table class="table">
        <thead>
          <tr>
            <th>ID</th><th>Res No</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Total</th><th>Status</th>
          </tr>
        </thead>
        <tbody>
        <%
          for (Map<String,Object> r : list) {
        %>
          <tr>
            <td>#<%= r.get("reservationId") %></td>
            <td><%= r.get("reservationNo") %></td>
            <td><%= r.get("roomNumber") %> (<%= r.get("roomType") %>)</td>
            <td><%= r.get("checkIn") %></td>
            <td><%= r.get("checkOut") %></td>
            <td>Rs. <%= r.get("grandTotal") %></td>
            <td><b><%= r.get("status") %></b></td>
          </tr>
        <%
          }
        %>
        </tbody>
      </table>
    <%
      }
    %>
  </div>
</div>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>