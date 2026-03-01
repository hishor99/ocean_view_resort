<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Room" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Available Rooms</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  :root{
    --bg:#f5f7fb; --card:#fff; --text:#0f172a; --muted:#64748b;
    --primary:#2563eb; --primary2:#1d4ed8; --border:#e5e7eb;
    --shadow:0 10px 25px rgba(2,6,23,.08); --shadow2:0 6px 16px rgba(2,6,23,.07);
    --radius:16px;
  }
  body{ background:var(--bg); color:var(--text); }

  .wrap{ max-width:1150px; margin:18px auto 70px; padding:0 16px; }

  .hero{
    background: radial-gradient(1200px 300px at 20% 0%, rgba(37,99,235,.18), transparent 60%),
                linear-gradient(180deg, #fff, #fff);
    border:1px solid var(--border); border-radius:var(--radius);
    box-shadow:var(--shadow);
    padding:20px; display:flex; justify-content:space-between; align-items:center; gap:16px;
  }
  .hero h2{ margin:0; font-size:22px; }
  .hero p{ margin:6px 0 0; color:var(--muted); }

  .chip{
    display:inline-flex; align-items:center; gap:8px;
    padding:10px 12px; border-radius:999px;
    border:1px solid rgba(37,99,235,.25);
    background: rgba(37,99,235,.08);
    color:var(--primary2); font-weight:900; font-size:13px;
  }
  .dot{ width:10px; height:10px; border-radius:50%; background:#22c55e; box-shadow:0 0 0 4px rgba(34,197,94,.18); }

  .toolbar{
    margin-top:14px;
    display:flex; gap:12px; align-items:center; justify-content:space-between; flex-wrap:wrap;
  }
  .toolbar .hint{ color:var(--muted); font-size:13px; }
  .back{
    text-decoration:none; font-weight:900; color:var(--primary2);
    background:#fff; border:1px solid rgba(37,99,235,.18);
    padding:10px 12px; border-radius:12px; box-shadow:var(--shadow2);
  }
  .back:hover{ background:rgba(37,99,235,.06); }

  .grid{
    margin-top:14px;
    display:grid;
    grid-template-columns:repeat(12, 1fr);
    gap:16px;
  }

  .room-card{
    grid-column:span 12;
    background:var(--card);
    border:1px solid var(--border);
    border-radius:var(--radius);
    box-shadow:var(--shadow2);
    padding:16px;
    transition:transform .15s ease, box-shadow .15s ease, border-color .15s ease;
  }
  .room-card:hover{
    transform:translateY(-2px);
    box-shadow:0 12px 25px rgba(2,6,23,.10);
    border-color: rgba(37,99,235,.28);
  }

  @media (min-width: 720px){ .room-card{ grid-column:span 6; } }
  @media (min-width: 1024px){ .room-card{ grid-column:span 4; } }

  .room-head{
    display:flex; justify-content:space-between; align-items:flex-start; gap:10px;
    margin-bottom:10px;
  }
  .room-title{ margin:0; font-size:16px; font-weight:950; }
  .room-sub{ margin:4px 0 0; color:var(--muted); font-size:13px; }

  .badge{
    display:inline-flex; align-items:center; gap:6px;
    padding:6px 10px; border-radius:999px;
    font-weight:900; font-size:12px;
    border:1px solid var(--border); background:#f8fafc; color:#334155;
    white-space:nowrap;
  }
  .badge.ok{ border-color: rgba(34,197,94,.25); background: rgba(34,197,94,.10); color:#15803d; }
  .badge.warn{ border-color: rgba(245,158,11,.25); background: rgba(245,158,11,.12); color:#92400e; }
  .badge.no{ border-color: rgba(239,68,68,.25); background: rgba(239,68,68,.10); color:#b91c1c; }

  .meta{
    display:grid; grid-template-columns:repeat(2,1fr); gap:10px;
    margin-top:10px;
  }
  .meta .item{
    border:1px solid var(--border);
    border-radius:14px;
    padding:10px;
    background:#fff;
  }
  .meta .k{ color:var(--muted); font-size:12px; margin:0 0 2px; font-weight:800; }
  .meta .v{ margin:0; font-weight:950; font-size:13px; }

  .actions{
    margin-top:14px;
    display:flex; justify-content:space-between; align-items:center; gap:10px; flex-wrap:wrap;
  }
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
  .muted{
    color:#64748b; font-weight:800; font-size:13px;
  }

  .empty{
    grid-column:span 12;
    border:1px dashed rgba(100,116,139,.35);
    background: rgba(255,255,255,.8);
    border-radius:var(--radius);
    padding:18px;
    color:var(--muted);
    box-shadow:var(--shadow2);
  }
</style>
</head>

<body>
<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">

  <div class="hero">
    <div>
      <h2>Available Rooms</h2>
      <p>Select a room and continue to reservation options (food package, vehicle, quote).</p>
    </div>
    <div class="chip"><span class="dot"></span> Customer</div>
  </div>

  <div class="toolbar">
    <div class="hint">Tip: Click <b>Reserve</b> to choose dates + services and get the final quote.</div>
    <a class="back" href="<%= request.getContextPath() %>/customer/dashboard.jsp">← Back to Dashboard</a>
  </div>

  <div class="grid">
    <%
      List<Room> rooms = (List<Room>) request.getAttribute("rooms");

      if (rooms == null || rooms.isEmpty()) {
    %>
      <div class="empty">
        <b>No available rooms at the moment.</b>
        <div style="margin-top:6px;">Please check again later.</div>
      </div>
    <%
      } else {
        for (Room r : rooms) {
          String status = (r.getStatus() == null) ? "" : r.getStatus();
          boolean canReserve = "AVAILABLE".equalsIgnoreCase(status);

          String badgeClass = "badge";
          if ("AVAILABLE".equalsIgnoreCase(status)) badgeClass = "badge ok";
          else if ("MAINTENANCE".equalsIgnoreCase(status)) badgeClass = "badge warn";
          else badgeClass = "badge no";
    %>

      <div class="room-card">
        <div class="room-head">
          <div>
            <p class="room-title">Room <%= r.getRoomNumber() %></p>
            <p class="room-sub"><%= r.getRoomType() %></p>
          </div>
          <span class="<%= badgeClass %>"><%= status %></span>
        </div>

        <div class="meta">
          <div class="item">
            <p class="k">Price / night</p>
            <p class="v">Rs. <%= r.getPricePerNight() %></p>
          </div>
          <div class="item">
            <p class="k">Capacity</p>
            <p class="v"><%= r.getCapacity() %> persons</p>
          </div>
        </div>

        <div class="actions">
          <% if (canReserve) { %>
            <a class="btn"
               href="<%= request.getContextPath() %>/customer/reserve?roomId=<%= r.getRoomId() %>">
              Reserve
            </a>
            <span class="muted">Choose dates & services</span>
          <% } else { %>
            <span class="muted">Not available for reservation</span>
          <% } %>
        </div>
      </div>

    <%
        }
      }
    %>
  </div>

</div>

</body>
</html>