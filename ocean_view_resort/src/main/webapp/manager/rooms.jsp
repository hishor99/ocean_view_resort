<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Room" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Rooms</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">

  <div class="card">
    <h2>Manage Room Prices</h2>
    <p>Add rooms, edit price/capacity/status, and delete rooms.</p>
  </div>

  <!-- ✅ ADD NEW ROOM -->
  <div class="card">
    <h3>Add New Room</h3>

    <!-- This submits to ManagerRoomsServlet doPost: /manager/rooms -->
    <form method="post" action="<%= request.getContextPath() %>/manager/rooms">

      <label>Room Number</label><br>
      <input type="text" name="roomNumber" required><br><br>

      <label>Room Type</label><br>
      <input type="text" name="roomType" required><br><br>

      <label>Capacity</label><br>
      <input type="number" name="capacity" min="1" required><br><br>

      <label>Price Per Night</label><br>
      <input type="number" name="pricePerNight" min="0" step="0.01" required><br><br>

      <label>Status</label><br>
      <select name="status">
        <option value="AVAILABLE">AVAILABLE</option>
        <option value="MAINTENANCE">MAINTENANCE</option>
        <option value="OCCUPIED">OCCUPIED</option>
      </select><br><br>

      <button class="btn" type="submit">Add Room</button>
    </form>
  </div>

  <!-- ✅ ROOMS TABLE -->
  <div class="card">
    <h3>All Rooms</h3>

    <table border="1" cellpadding="10" cellspacing="0" style="width:100%; border-collapse:collapse;">
      <tr>
        <th>Room No</th>
        <th>Type</th>
        <th>Capacity</th>
        <th>Price / Night</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>

      <%
        List<Room> rooms = (List<Room>) request.getAttribute("rooms");
        if (rooms == null || rooms.isEmpty()) {
      %>
        <tr>
          <td colspan="6">No rooms found.</td>
        </tr>
      <%
        } else {
          for (Room r : rooms) {
      %>

      <tr>
        <td><%= r.getRoomNumber() %></td>
        <td><%= r.getRoomType() %></td>

        <!-- ✅ UPDATE FORM (price+capacity+status) -->
        <td>
          <form method="post"
                action="<%= request.getContextPath() %>/manager/rooms/update"
                style="margin:0;">
            <input type="number" name="capacity" min="1" value="<%= r.getCapacity() %>" required>
        </td>

        <td>
            <input type="number" name="pricePerNight" min="0" step="0.01"
                   value="<%= r.getPricePerNight() %>" required>
        </td>

        <td>
            <select name="status">
              <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(r.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
              <option value="MAINTENANCE" <%= "MAINTENANCE".equalsIgnoreCase(r.getStatus()) ? "selected" : "" %>>MAINTENANCE</option>
              <option value="OCCUPIED" <%= "OCCUPIED".equalsIgnoreCase(r.getStatus()) ? "selected" : "" %>>OCCUPIED</option>
            </select>
        </td>

        <td>
            <input type="hidden" name="roomId" value="<%= r.getRoomId() %>">

            <button class="btn" type="submit">Save</button>
          </form>

          <!-- ✅ DELETE FORM -->
          <form method="post"
                action="<%= request.getContextPath() %>/manager/rooms/delete"
                style="margin-top:6px;"
                onsubmit="return confirm('Delete this room?');">
            <input type="hidden" name="roomId" value="<%= r.getRoomId() %>">
            <button type="submit"
                    style="background:#dc2626;color:#fff;border:none;padding:6px 10px;border-radius:6px;cursor:pointer;">
              Delete
            </button>
          </form>
        </td>
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