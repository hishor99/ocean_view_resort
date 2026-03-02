<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Vehicle" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Vehicles</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  body{background:#f5f7fa;}
  .page-head{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;flex-wrap:wrap}
  .muted{color:#6b7280}
  .grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
  .grid-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px}
  .field{display:flex;flex-direction:column;gap:6px}
  .field input,.field select{padding:10px;border:1px solid #ddd;border-radius:10px;outline:none}
  .actions{display:flex;gap:10px;flex-wrap:wrap;align-items:center;margin-top:10px}
  .btn{padding:10px 14px;border:none;border-radius:10px;cursor:pointer;font-weight:700}
  .btn-primary{background:#0b3d91;color:#fff}
  .btn-ghost{background:#eef2ff;color:#0b3d91;text-decoration:none;display:inline-block}
  .btn-link{color:#0b3d91;text-decoration:none;font-weight:700}
  .btn-link:hover{text-decoration:underline}

  .table-wrap{overflow:auto;border:1px solid #eee;border-radius:14px;background:#fff}
  table{width:100%;border-collapse:collapse;min-width:900px}
  th,td{padding:12px;border-bottom:1px solid #f0f0f0;vertical-align:top}
  th{background:#f8fafc;text-align:left;font-size:13px;color:#111827;position:sticky;top:0}
  tr:hover td{background:#fcfcff}

  .badge{display:inline-block;padding:5px 10px;border-radius:999px;font-size:12px;font-weight:800}
  .b-yes{background:#dcfce7;color:#166534}
  .b-no{background:#fee2e2;color:#991b1b}

  @media (max-width: 900px){
    .grid,.grid-3{grid-template-columns:1fr}
    table{min-width:820px}
  }
</style>
</head>

<body>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">

  <div class="card">
    <div class="page-head">
      <div>
        <h2 style="margin:0;">Manage Vehicles</h2>
        <p class="muted" style="margin:6px 0 0;">Add new vehicles, update details, and manage active status.</p>
      </div>
      <div class="actions">
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/manager/dashboard">← Back to Dashboard</a>
      </div>
    </div>
  </div>

  <%
    Vehicle editVehicle = (Vehicle) request.getAttribute("editVehicle");
    boolean isEdit = (editVehicle != null);
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
  %>

  <!-- FORM CARD -->
  <div class="card">
    <h3 style="margin-top:0;"><%= isEdit ? "Edit Vehicle" : "Add Vehicle" %></h3>

    <form method="post" action="<%= request.getContextPath() %>/manager/vehicles">
      <input type="hidden" name="vehicle_id" value="<%= isEdit ? editVehicle.getVehicleId() : "" %>">

      <div class="grid">
        <div class="field">
          <label>Type</label>
          <input type="text" name="type" required
                 placeholder="Van / Car / Tuk / Bus"
                 value="<%= isEdit ? editVehicle.getType() : "" %>">
        </div>

        <div class="field">
          <label>Model (optional)</label>
          <input type="text" name="model"
                 placeholder="Toyota / Nissan..."
                 value="<%= isEdit ? (editVehicle.getModel()==null?"":editVehicle.getModel()) : "" %>">
        </div>
      </div>

      <div class="grid">
        <div class="field">
          <label>Plate No (optional)</label>
          <input type="text" name="plate_no"
                 placeholder="ABC-1234"
                 value="<%= isEdit ? (editVehicle.getPlateNo()==null?"":editVehicle.getPlateNo()) : "" %>">
        </div>

        <div class="field">
          <label>Notes (optional)</label>
          <input type="text" name="notes"
                 placeholder="Driver included / Fuel excluded..."
                 value="<%= isEdit ? (editVehicle.getNotes()==null?"":editVehicle.getNotes()) : "" %>">
        </div>
      </div>

      <div class="grid-3">
        <div class="field">
          <label>Price per day (Rs.)</label>
          <input type="number" name="price_per_day" step="0.01" min="0" required
                 value="<%= isEdit ? editVehicle.getPricePerDay() : 0 %>">
        </div>

        <div class="field">
          <label>Capacity</label>
          <input type="number" name="capacity" min="1" required
                 value="<%= isEdit ? editVehicle.getCapacity() : 4 %>">
        </div>

        <div class="field">
          <label>Active</label>
          <select name="is_active">
            <option value="1" <%= (!isEdit || editVehicle.isActive()) ? "selected" : "" %>>Yes</option>
            <option value="0" <%= (isEdit && !editVehicle.isActive()) ? "selected" : "" %>>No</option>
          </select>
        </div>
      </div>

      <div class="actions">
        <button class="btn btn-primary" type="submit"><%= isEdit ? "Update Vehicle" : "Add Vehicle" %></button>

        <% if (isEdit) { %>
          <a class="btn-link" href="<%= request.getContextPath() %>/manager/vehicles">Cancel</a>
        <% } %>
      </div>
    </form>
  </div>

  <!-- TABLE CARD -->
  <div class="card">
    <div class="page-head">
      <h3 style="margin:0;">Vehicles List</h3>
      <p class="muted" style="margin:0;">Total: <b><%= (vehicles == null ? 0 : vehicles.size()) %></b></p>
    </div>

    <div class="table-wrap" style="margin-top:12px;">
      <table>
        <thead>
          <tr>
            <th style="width:150px;">Type</th>
            <th style="width:160px;">Model</th>
            <th style="width:140px;">Plate</th>
            <th style="width:140px;">Price/Day</th>
            <th style="width:110px;">Capacity</th>
            <th style="width:120px;">Active</th>
            <th style="width:120px;">Action</th>
          </tr>
        </thead>

        <tbody>
        <%
          if (vehicles == null || vehicles.isEmpty()) {
        %>
          <tr>
            <td colspan="7" class="muted">No vehicles found.</td>
          </tr>
        <%
          } else {
            for (Vehicle v : vehicles) {
              boolean act = v.isActive();
        %>
          <tr>
            <td><b><%= v.getType() %></b></td>
            <td><%= v.getModel() == null || v.getModel().isBlank() ? "-" : v.getModel() %></td>
            <td><%= v.getPlateNo() == null || v.getPlateNo().isBlank() ? "-" : v.getPlateNo() %></td>
            <td>Rs. <%= v.getPricePerDay() %></td>
            <td><%= v.getCapacity() %></td>
            <td>
              <span class="badge <%= act ? "b-yes" : "b-no" %>">
                <%= act ? "Yes" : "No" %>
              </span>
            </td>
            <td>
              <a class="btn-link" href="<%= request.getContextPath() %>/manager/vehicles?edit=<%= v.getVehicleId() %>">Edit</a>
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

</div>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>