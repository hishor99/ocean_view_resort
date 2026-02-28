<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*" %>
<%@ page import="model.Room" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">
  <div class="card">
    <h2>Manage Room Prices</h2>
    <p>Edit room price, capacity and status.</p>
  </div>

  <div class="card">
    <table border="1" cellpadding="10" cellspacing="0" style="width:100%; border-collapse:collapse;">
      <tr>
        <th>Room No</th>
        <th>Type</th>
        <th>Capacity</th>
        <th>Price / Night</th>
        <th>Status</th>
        <th>Update</th>
      </tr>

      <%
        List<Room> rooms = (List<Room>) request.getAttribute("rooms");
        if (rooms != null) {
          for (Room r : rooms) {
      %>
      <tr>
        <form method="post" action="<%= request.getContextPath() %>/manager/rooms/update">
          <td><%= r.getRoomNumber() %></td>
          <td><%= r.getRoomType() %></td>

          <td>
            <input type="number" name="capacity" min="1" value="<%= r.getCapacity() %>" required>
          </td>

          <td>
            <input type="number" name="price_per_night" min="0" step="0.01" value="<%= r.getPricePerNight() %>" required>
          </td>

          <td>
            <select name="status">
              <option value="AVAILABLE" <%= "AVAILABLE".equals(r.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
              <option value="MAINTENANCE" <%= "MAINTENANCE".equals(r.getStatus()) ? "selected" : "" %>>MAINTENANCE</option>
              <option value="DISABLED" <%= "DISABLED".equals(r.getStatus()) ? "selected" : "" %>>DISABLED</option>
            </select>
          </td>

          <td>
            <input type="hidden" name="room_id" value="<%= r.getRoomId() %>">
            <button class="btn" type="submit">Save</button>
          </td>
        </form>
      </tr>
      <%
          }
        }
      %>
    </table>
  </div>

  <div class="card">
    <a href="<%= request.getContextPath() %>/manager/dashboard.jsp">Back to Manager Dashboard</a>
  </div>
</div>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>