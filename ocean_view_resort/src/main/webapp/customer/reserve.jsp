<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Room" %>
<%@ page import="model.FoodPackage" %>
<%@ page import="model.Vehicle" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reserve Room</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  :root{
    --bg:#f5f7fb; --card:#fff; --text:#0f172a; --muted:#64748b;
    --primary:#2563eb; --primary2:#1d4ed8; --border:#e5e7eb;
    --shadow:0 10px 25px rgba(2,6,23,.08); --shadow2:0 6px 16px rgba(2,6,23,.07);
    --radius:16px;
  }
  body{ background:var(--bg); color:var(--text); }

  .wrap{ max-width:1100px; margin:18px auto 70px; padding:0 16px; }

  .hero{
    background: radial-gradient(1200px 300px at 20% 0%, rgba(37,99,235,.18), transparent 60%),
                linear-gradient(180deg, #fff, #fff);
    border:1px solid var(--border); border-radius:var(--radius);
    box-shadow:var(--shadow);
    padding:20px;
    display:flex; justify-content:space-between; align-items:flex-start; gap:16px;
  }
  .hero h2{ margin:0; font-size:22px; }
  .hero p{ margin:6px 0 0; color:var(--muted); }

  .chip{
    display:inline-flex; align-items:center; gap:8px;
    padding:10px 12px; border-radius:999px;
    border:1px solid rgba(37,99,235,.25);
    background: rgba(37,99,235,.08);
    color:var(--primary2); font-weight:900; font-size:13px;
    white-space:nowrap;
  }
  .dot{ width:10px; height:10px; border-radius:50%; background:#22c55e; box-shadow:0 0 0 4px rgba(34,197,94,.18); }

  .grid{ margin-top:16px; display:grid; grid-template-columns:repeat(12,1fr); gap:16px; }

  .panel{
    grid-column:span 12;
    background:var(--card);
    border:1px solid var(--border);
    border-radius:var(--radius);
    box-shadow:var(--shadow2);
    padding:18px;
  }
  @media (min-width: 980px){
    .left{ grid-column:span 7; }
    .right{ grid-column:span 5; }
  }

  .sub{ margin:0 0 14px; color:var(--muted); font-size:13px; }

  .alert{
    border:1px solid rgba(239,68,68,.25);
    background: rgba(239,68,68,.10);
    color:#b91c1c;
    padding:10px 12px;
    border-radius:12px;
    font-weight:800;
    margin-top:12px;
  }

  /* Form */
  .form-grid{ display:grid; grid-template-columns:repeat(12, 1fr); gap:12px; }
  .field{ grid-column:span 12; }
  .field label{
    display:block; margin:0 0 6px;
    font-size:12px; color:#334155; font-weight:900;
  }
  .field input, .field select{
    width:100%;
    padding:10px 12px;
    border-radius:12px;
    border:1px solid var(--border);
    background:#fff;
    font-size:13px;
    outline:none;
  }
  .field input:focus, .field select:focus{
    border-color: rgba(37,99,235,.45);
    box-shadow: 0 0 0 3px rgba(37,99,235,.12);
  }
  @media (min-width: 760px){
    .field.sm6{ grid-column:span 6; }
    .field.sm4{ grid-column:span 4; }
  }

  /* Summary boxes */
  .summary{
    display:grid;
    grid-template-columns:repeat(2, 1fr);
    gap:12px;
    margin-top:10px;
  }
  .box{
    border:1px solid var(--border);
    border-radius:14px;
    padding:12px;
    background:#fff;
  }
  .k{ margin:0 0 4px; color:var(--muted); font-weight:900; font-size:12px; }
  .v{ margin:0; font-weight:950; font-size:14px; }

  /* Buttons */
  .actions{ display:flex; gap:10px; flex-wrap:wrap; margin-top:14px; }
  .btn{
    display:inline-flex; align-items:center; justify-content:center; gap:8px;
    background: var(--primary); color:#fff;
    border:1px solid rgba(37,99,235,.45);
    border-radius:12px; padding:10px 14px;
    font-weight:950; text-decoration:none; font-size:13px;
    transition:transform .15s ease, background .15s ease;
    cursor:pointer;
  }
  .btn:hover{ background:var(--primary2); transform:translateY(-1px); }
  .btn-outline{
    background:#fff; color:var(--primary2);
    border:1px solid rgba(37,99,235,.22);
  }
  .btn-outline:hover{ background:rgba(37,99,235,.06); }

  .hint{
    margin-top:10px;
    color:var(--muted);
    font-size:13px;
    line-height:1.4;
  }
</style>
</head>

<body>
<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">
  <%
    Room room = (Room) request.getAttribute("room");
    String error = (String) request.getAttribute("error");

    List<FoodPackage> foods = (List<FoodPackage>) request.getAttribute("foods");
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
  %>

  <div class="hero">
    <div>
      <h2>Reserve Room <%= (room != null ? room.getRoomNumber() : "") %></h2>
      <p>Choose dates, guests, and optional services to generate your final quote.</p>
      <% if (error != null) { %>
        <div class="alert"><%= error %></div>
      <% } %>
    </div>
    <div class="chip"><span class="dot"></span> Reservation</div>
  </div>

  <div class="grid">
    <!-- LEFT: Form -->
    <div class="panel left">
      <h3 style="margin:0 0 6px;">Reservation Details</h3>
      <p class="sub">Fill in the details below. You will see the final quote on the next page.</p>

      <% if (room == null) { %>
        <div class="alert">Room not found.</div>
      <% } else { %>

      <form method="post" action="<%= request.getContextPath() %>/customer/reserve">
        <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">

        <div class="form-grid">
          <div class="field sm4">
            <label>Guests</label>
            <input type="number" name="guests" min="1" max="<%= room.getCapacity() %>" value="1" required>
          </div>

          <div class="field sm4">
            <label>Check-in</label>
            <input type="date" name="checkIn" required>
          </div>

          <div class="field sm4">
            <label>Check-out</label>
            <input type="date" name="checkOut" required>
          </div>

          <div class="field sm6">
            <label>Food Package (Optional)</label>
            <select name="foodId">
              <option value="0">No Food Package</option>
              <% if (foods != null) for (FoodPackage f : foods) { %>
                <option value="<%= f.getFoodId() %>">
                  <%= f.getName() %> - Rs.<%= f.getPricePerDay() %>/day (<%= f.getPricingType() %>)
                </option>
              <% } %>
            </select>
          </div>

          <div class="field sm6">
            <label>Vehicle (Optional)</label>
            <select name="vehicleId">
              <option value="0">No Vehicle</option>
              <% if (vehicles != null) for (Vehicle v : vehicles) { %>
                <option value="<%= v.getVehicleId() %>">
                  <%= v.getType() %> - <%= v.getModel() %> - Rs.<%= v.getPricePerDay() %>/day
                </option>
              <% } %>
            </select>
          </div>
        </div>

        <div class="actions">
          <button class="btn" type="submit">Get Final Quote</button>
          <a class="btn btn-outline" href="<%= request.getContextPath() %>/customer/rooms">Back to Rooms</a>
        </div>

        <div class="hint">
          Note: Food pricing is calculated using your package pricing type:
          <b>PER_PERSON_PER_DAY</b> or <b>PER_ROOM_PER_DAY</b>.
        </div>
      </form>

      <% } %>
    </div>

    <!-- RIGHT: Room summary -->
    <div class="panel right">
      <h3 style="margin:0 0 6px;">Room Summary</h3>
      <p class="sub">Quick overview of selected room.</p>

      <% if (room != null) { %>
        <div class="summary">
          <div class="box">
            <p class="k">Room Type</p>
            <p class="v"><%= room.getRoomType() %></p>
          </div>
          <div class="box">
            <p class="k">Max Guests</p>
            <p class="v"><%= room.getCapacity() %></p>
          </div>
          <div class="box">
            <p class="k">Price / Night</p>
            <p class="v">Rs. <%= room.getPricePerNight() %></p>
          </div>
          <div class="box">
            <p class="k">Status</p>
            <p class="v"><%= room.getStatus() %></p>
          </div>
        </div>

        <div class="hint" style="margin-top:12px;">
          After you submit, your reservation request will be sent to reception staff for confirmation.
        </div>
      <% } else { %>
        <div class="alert">Room summary not available.</div>
      <% } %>
    </div>
  </div>
</div>

</body>
</html>