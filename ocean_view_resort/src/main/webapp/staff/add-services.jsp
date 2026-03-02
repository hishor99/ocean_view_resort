<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Add Services</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-4">

  <h3 class="mb-1">Optional Services</h3>
  <p class="text-muted">Reservation: <strong><%= request.getAttribute("resNo") %></strong></p>

  <form method="post" action="<%=request.getContextPath()%>/staff/add-services" class="card shadow-sm border-0">
    <div class="card-body p-4">

      <input type="hidden" name="reservationId" value="<%= request.getAttribute("reservationId") %>"/>
      <input type="hidden" name="resNo" value="<%= request.getAttribute("resNo") %>"/>

      <div class="row g-4">
        <div class="col-md-6">
          <h5>Food Packages (Optional)</h5>
          <select name="food_id" class="form-select">
            <option value="">-- No Food Package --</option>
            <%
              List<Map<String,Object>> foods = (List<Map<String,Object>>) request.getAttribute("foods");
              if (foods != null) for (Map<String,Object> f : foods) {
            %>
              <option value="<%= f.get("food_id") %>">
                <%= f.get("package_name") %> - Rs. <%= f.get("price") %>
              </option>
            <% } %>
          </select>
        </div>

        <div class="col-md-6">
          <h5>Vehicle Service (Optional)</h5>
          <select name="vehicle_id" class="form-select">
            <option value="">-- No Vehicle Service --</option>
            <%
              List<Map<String,Object>> vehicles = (List<Map<String,Object>>) request.getAttribute("vehicles");
              if (vehicles != null) for (Map<String,Object> v : vehicles) {
            %>
              <option value="<%= v.get("vehicle_id") %>">
                <%= v.get("service_name") %> - Rs. <%= v.get("price") %>
              </option>
            <% } %>
          </select>
        </div>
      </div>

      <div class="d-flex justify-content-end mt-4">
        <button class="btn btn-primary px-4">Save & View Reservation</button>
      </div>

    </div>
  </form>
</div>
</body>
</html>