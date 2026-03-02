<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Room" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Rooms</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  .page-head{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;flex-wrap:wrap}
  .muted{color:#6b7280}
  .grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
  .grid-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px}
  .field{display:flex;flex-direction:column;gap:6px}
  .field input,.field select,.field textarea{padding:10px;border:1px solid #ddd;border-radius:10px;outline:none}
  .field textarea{min-height:90px;resize:vertical}
  .actions{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
  .btn{padding:10px 14px;border:none;border-radius:10px;cursor:pointer;font-weight:600}
  .btn-primary{background:#0b3d91;color:#fff}
  .btn-danger{background:#dc2626;color:#fff}
  .btn-ghost{background:#eef2ff;color:#0b3d91}
  .btn-sm{padding:8px 10px;border-radius:9px}

  .table-wrap{overflow:auto;border:1px solid #eee;border-radius:14px}
  table{width:100%;border-collapse:collapse;min-width:980px}
  th,td{padding:12px 12px;border-bottom:1px solid #f0f0f0;vertical-align:top}
  th{background:#f8fafc;text-align:left;font-size:13px;color:#111827;position:sticky;top:0;z-index:1}
  tr:hover td{background:#fcfcff}

  .badge{display:inline-block;padding:5px 10px;border-radius:999px;font-size:12px;font-weight:700}
  .b-avail{background:#dcfce7;color:#166534}
  .b-main{background:#fef3c7;color:#92400e}
  .b-occ{background:#fee2e2;color:#991b1b}

  .row-form{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
  .row-form input,.row-form select,.row-form textarea{padding:8px 10px;border:1px solid #ddd;border-radius:10px}
  .desc-cell{max-width:360px}
  .desc-cell small{color:#6b7280}

  @media (max-width: 900px){
    .grid,.grid-3{grid-template-columns:1fr}
    table{min-width:860px}
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
        <h2 style="margin:0;">Manage Room Prices</h2>
        <p class="muted" style="margin:6px 0 0;">
          Add rooms, edit price/capacity/description/status, and delete rooms.
        </p>
      </div>
      <div class="actions">
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/manager/dashboard">← Back to Dashboard</a>
      </div>
    </div>
  </div>

  <!-- ✅ ADD NEW ROOM -->
  <div class="card">
    <h3 style="margin-top:0;">Add New Room</h3>

    <form method="post" action="<%= request.getContextPath() %>/manager/rooms">

      <div class="grid">
        <div class="field">
          <label>Room Number</label>
          <input type="text" name="roomNumber" placeholder="A-101" required>
        </div>

        <div class="field">
          <label>Room Type</label>
          <input type="text" name="roomType" placeholder="Deluxe / Standard" required>
        </div>
      </div>

      <div class="grid-3" style="margin-top:12px;">
        <div class="field">
          <label>Capacity</label>
          <input type="number" name="capacity" min="1" required>
        </div>

        <div class="field">
          <label>Description</label>
          <input type="text" name="description" placeholder="Sea view, AC, balcony..." required>
        </div>

        <div class="field">
          <label>Price Per Night (Rs.)</label>
          <input type="number" name="pricePerNight" min="0" step="0.01" required>
        </div>
      </div>

      <div class="grid" style="margin-top:12px;">
        <div class="field">
          <label>Status</label>
          <select name="status">
            <option value="AVAILABLE">AVAILABLE</option>
            <option value="MAINTENANCE">MAINTENANCE</option>
            <option value="OCCUPIED">OCCUPIED</option>
          </select>
        </div>

        <div class="field" style="justify-content:end;">
          <label style="visibility:hidden;">Action</label>
          <button class="btn btn-primary" type="submit">Add Room</button>
        </div>
      </div>

    </form>
  </div>

  <!-- ✅ ROOMS TABLE -->
  <div class="card">
    <h3 style="margin-top:0;">All Rooms</h3>

    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th style="width:90px;">Room No</th>
            <th style="width:160px;">Type</th>
            <th style="width:110px;">Capacity</th>
            <th>Description</th>
            <th style="width:140px;">Price / Night</th>
            <th style="width:160px;">Status</th>
            <th style="width:170px;">Actions</th>
          </tr>
        </thead>

        <tbody>
        <%
          List<Room> rooms = (List<Room>) request.getAttribute("rooms");
          if (rooms == null || rooms.isEmpty()) {
        %>
          <tr>
            <td colspan="7" class="muted">No rooms found.</td>
          </tr>
        <%
          } else {
            for (Room r : rooms) {

              String st = (r.getStatus() == null) ? "" : r.getStatus();
              String badgeClass = "b-avail";
              if ("MAINTENANCE".equalsIgnoreCase(st)) badgeClass = "b-main";
              else if ("OCCUPIED".equalsIgnoreCase(st)) badgeClass = "b-occ";
        %>

          <tr>
            <td><b><%= r.getRoomNumber() %></b></td>
            <td><%= r.getRoomType() %></td>

            <!-- ✅ UPDATE FORM (capacity + description + price + status) -->
            <td>
              <form method="post"
                    action="<%= request.getContextPath() %>/manager/rooms/update"
                    class="row-form"
                    style="margin:0;">
                <input type="number" name="capacity" min="1" value="<%= r.getCapacity() %>" required>
            </td>

            <td class="desc-cell">
                <input type="text" name="description"
                       value="<%= (r.getDescription() != null ? r.getDescription() : "") %>"
                       placeholder="Room features..." required>
                <div><small>Edit description and click Save</small></div>
            </td>

            <td>
                <input type="number" name="pricePerNight" min="0" step="0.01"
                       value="<%= r.getPricePerNight() %>" required>
            </td>

            <td>
                <div style="display:flex;flex-direction:column;gap:8px;">
                  <span class="badge <%= badgeClass %>"><%= st %></span>

                  <select name="status" required>
                    <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(st) ? "selected" : "" %>>AVAILABLE</option>
                    <option value="MAINTENANCE" <%= "MAINTENANCE".equalsIgnoreCase(st) ? "selected" : "" %>>MAINTENANCE</option>
                    <option value="OCCUPIED" <%= "OCCUPIED".equalsIgnoreCase(st) ? "selected" : "" %>>OCCUPIED</option>
                  </select>
                </div>
            </td>

            <td>
                <input type="hidden" name="roomId" value="<%= r.getRoomId() %>">
                <button class="btn btn-primary btn-sm" type="submit">Save</button>
              </form>

              <!-- ✅ DELETE FORM -->
              <form method="post"
                    action="<%= request.getContextPath() %>/manager/rooms/delete"
                    style="margin-top:8px;"
                    onsubmit="return confirm('Delete this room?');">
                <input type="hidden" name="roomId" value="<%= r.getRoomId() %>">
                <button class="btn btn-danger btn-sm" type="submit">Delete</button>
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

</div>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>