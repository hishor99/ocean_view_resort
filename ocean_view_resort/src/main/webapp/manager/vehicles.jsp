<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*" %>
<%@ page import="model.Vehicle" %>
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
    <h2>Manage Vehicles</h2>
  </div>

  <%
    Vehicle editVehicle = (Vehicle) request.getAttribute("editVehicle");
    boolean isEdit = (editVehicle != null);
  %>

  <div class="card">
    <h3><%= isEdit ? "Edit Vehicle" : "Add Vehicle" %></h3>

    <form method="post" action="<%= request.getContextPath() %>/manager/vehicles">
      <input type="hidden" name="vehicle_id" value="<%= isEdit ? editVehicle.getVehicleId() : "" %>">

      <label>Type</label><br>
      <input type="text" name="type" required value="<%= isEdit ? editVehicle.getType() : "" %>"><br><br>

      <label>Model (optional)</label><br>
      <input type="text" name="model" value="<%= isEdit ? (editVehicle.getModel()==null?"":editVehicle.getModel()) : "" %>"><br><br>

      <label>Plate No (optional)</label><br>
      <input type="text" name="plate_no" value="<%= isEdit ? (editVehicle.getPlateNo()==null?"":editVehicle.getPlateNo()) : "" %>"><br><br>

      <label>Price per day</label><br>
      <input type="number" name="price_per_day" step="0.01" min="0" required value="<%= isEdit ? editVehicle.getPricePerDay() : 0 %>"><br><br>

      <label>Capacity</label><br>
      <input type="number" name="capacity" min="1" required value="<%= isEdit ? editVehicle.getCapacity() : 4 %>"><br><br>

      <label>Active</label>
      <select name="is_active">
        <option value="1" <%= (!isEdit || editVehicle.isActive()) ? "selected" : "" %>>Yes</option>
        <option value="0" <%= (isEdit && !editVehicle.isActive()) ? "selected" : "" %>>No</option>
      </select><br><br>

      <label>Notes</label><br>
      <input type="text" name="notes" value="<%= isEdit ? (editVehicle.getNotes()==null?"":editVehicle.getNotes()) : "" %>"><br><br>

      <button class="btn" type="submit"><%= isEdit ? "Update" : "Add" %></button>
      <% if (isEdit) { %>
        <a style="margin-left:10px;" href="<%= request.getContextPath() %>/manager/vehicles">Cancel</a>
      <% } %>
    </form>
  </div>

  <div class="card">
    <h3>Vehicles List</h3>
    <table border="1" cellpadding="10" cellspacing="0" style="width:100%; border-collapse:collapse;">
      <tr>
        <th>Type</th>
        <th>Model</th>
        <th>Plate</th>
        <th>Price/Day</th>
        <th>Capacity</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>

      <%
        List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
        if (vehicles != null) {
          for (Vehicle v : vehicles) {
      %>
      <tr>
        <td><%= v.getType() %></td>
        <td><%= v.getModel() == null ? "-" : v.getModel() %></td>
        <td><%= v.getPlateNo() == null ? "-" : v.getPlateNo() %></td>
        <td><%= v.getPricePerDay() %></td>
        <td><%= v.getCapacity() %></td>
        <td><%= v.isActive() ? "Yes" : "No" %></td>
        <td>
          <a href="<%= request.getContextPath() %>/manager/vehicles?edit=<%= v.getVehicleId() %>">Edit</a>
        </td>
      </tr>
      <%
          }
        }
      %>
    </table>
  </div>
</div>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>