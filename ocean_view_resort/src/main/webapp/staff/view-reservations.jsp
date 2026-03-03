<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Pending Reservations</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">

  <div class="card">
    <h2>Pending Reservations</h2>

    <% if (request.getAttribute("success") != null) { %>
      <div class="alert success"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert error"><%= request.getAttribute("error") %></div>
    <% } %>
  </div>

  <div class="card">
    <%
      List<Map<String,Object>> reservations =
          (List<Map<String,Object>>) request.getAttribute("reservations");

      if (reservations == null || reservations.isEmpty()) {
    %>
      <p class="muted">No pending reservations found.</p>
    <%
      } else {
    %>

    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Room</th>
          <th>Check-In</th>
          <th>Check-Out</th>
          <th>Guests</th>
          <th>Total</th>
          <th style="width:260px;">Actions</th>
        </tr>
      </thead>
      <tbody>
      <%
        for (Map<String,Object> r : reservations) {
      %>
        <tr>
          <td>#<%= r.get("reservationId") %></td>
          <td><b><%= r.get("roomNumber") %></b> (<%= r.get("roomType") %>)</td>
          <td><%= r.get("checkIn") %></td>
          <td><%= r.get("checkOut") %></td>
          <td><%= r.get("guests") %></td>
          <td>Rs. <%= r.get("grandTotal") %></td>
          <td>

            <!-- Confirm -->
            <form method="post"
                  action="<%= request.getContextPath() %>/staff/confirm-reservation"
                  class="inline">
              <input type="hidden" name="id" value="<%= r.get("reservationId") %>">
              <button class="btn success" type="submit">Confirm</button>
            </form>

            <!-- Cancel -->
            <form method="post"
                  action="<%= request.getContextPath() %>/staff/cancel-reservation"
                  class="inline"
                  onsubmit="return confirm('Cancel this reservation?');">
              <input type="hidden" name="id" value="<%= r.get("reservationId") %>">
              <input type="text" name="reason" placeholder="Reason" class="input-sm">
              <button class="btn danger" type="submit">Cancel</button>
            </form>

            <!-- Print -->
            <a class="btn"
               target="_blank"
               href="<%= request.getContextPath() %>/staff/reservation-invoice?id=<%= r.get("reservationId") %>">
              Print
            </a>

          </td>
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