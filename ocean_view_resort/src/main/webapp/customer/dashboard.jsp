<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Dashboard</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

<style>
  :root{
    --bg:#f5f7fb; --card:#fff; --text:#0f172a; --muted:#64748b;
    --primary:#2563eb; --primary2:#1d4ed8; --border:#e5e7eb;
    --shadow:0 10px 25px rgba(2,6,23,.08); --shadow2:0 6px 16px rgba(2,6,23,.07);
    --radius:16px;
  }
  body{ background:var(--bg); color:var(--text); }

  .topbar{
    background: linear-gradient(90deg, #0b2b5c, #0f3b7a);
    padding:10px 18px; display:flex; justify-content:flex-end; align-items:center;
  }
  .topbar a{
    color:#fff; text-decoration:none; font-weight:700; font-size:14px;
    padding:6px 10px; border-radius:10px;
    background: rgba(255,255,255,.12);
    border: 1px solid rgba(255,255,255,.18);
  }
  .topbar a:hover{ background: rgba(255,255,255,.18); }

  .dash-wrap{ max-width:1100px; margin:18px auto 70px; padding:0 16px; }

  .hero{
    background: radial-gradient(1200px 300px at 20% 0%, rgba(37,99,235,.20), transparent 60%),
                linear-gradient(180deg, #fff, #fff);
    border:1px solid var(--border); border-radius:var(--radius);
    box-shadow:var(--shadow);
    padding:22px; display:flex; justify-content:space-between; align-items:center; gap:16px;
  }
  .hero h2{ margin:0; font-size:22px; }
  .hero p{ margin:6px 0 0; color:var(--muted); }
  .hero-badge{
    display:inline-flex; align-items:center; gap:8px;
    padding:10px 12px; border-radius:999px;
    border:1px solid rgba(37,99,235,.25);
    background: rgba(37,99,235,.08);
    color:var(--primary2); font-weight:800; font-size:13px;
  }
  .dot{ width:10px; height:10px; border-radius:50%; background:#22c55e; box-shadow:0 0 0 4px rgba(34,197,94,.18); }

  .grid{ margin-top:16px; display:grid; grid-template-columns:repeat(12,1fr); gap:16px; }

  .panel{
    grid-column:span 12; background:var(--card);
    border:1px solid var(--border); border-radius:var(--radius);
    box-shadow:var(--shadow2); padding:18px;
  }
  .panel h3{ margin:0 0 4px; font-size:16px; }
  .panel .sub{ margin:0 0 14px; color:var(--muted); font-size:13px; }

  .actions{ display:grid; grid-template-columns:repeat(12,1fr); gap:14px; }
  .action-card{
    grid-column:span 12;
    display:flex; align-items:center; justify-content:space-between; gap:14px;
    border:1px solid var(--border); border-radius:14px; padding:14px;
    background:#fff; transition:transform .15s ease, box-shadow .15s ease, border-color .15s ease;
  }
  .action-card:hover{ transform:translateY(-2px); box-shadow:0 12px 25px rgba(2,6,23,.10); border-color: rgba(37,99,235,.35); }

  .action-left{ display:flex; align-items:center; gap:12px; min-width:0; }
  .icon{
    width:44px; height:44px; border-radius:12px;
    display:grid; place-items:center;
    background:rgba(37,99,235,.10);
    border:1px solid rgba(37,99,235,.18);
    flex:0 0 auto;
  }
  .icon svg{ width:22px; height:22px; fill:var(--primary2); }

  .action-title{ margin:0; font-weight:900; font-size:14px; }
  .action-desc{ margin:3px 0 0; color:var(--muted); font-size:12.5px; line-height:1.35; }

  .btn{
    display:inline-flex; align-items:center; justify-content:center; gap:8px;
    background: var(--primary); color:#fff;
    border:1px solid rgba(37,99,235,.45);
    border-radius:12px; padding:10px 14px;
    font-weight:900; text-decoration:none; font-size:13px;
    transition:transform .15s ease, background .15s ease; white-space:nowrap;
  }
  .btn:hover{ background:var(--primary2); transform:translateY(-1px); }
  .btn svg{ width:16px; height:16px; fill:#fff; }

  @media (min-width: 700px){ .action-card{ grid-column:span 6; } }
  @media (min-width: 980px){ .action-card{ grid-column:span 4; } }

  .panel-head{ display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:12px; }
  .panel-head a{ text-decoration:none; font-weight:900; color:var(--primary2); font-size:13px; }
  .panel-head a:hover{ text-decoration:underline; }

  .table-wrap{ overflow:auto; border:1px solid var(--border); border-radius:14px; }
  table{ width:100%; border-collapse:collapse; min-width: 720px; }
  th, td{ padding:12px; text-align:left; border-bottom:1px solid var(--border); font-size:13px; }
  th{ background:#f8fafc; color:#334155; font-weight:900; }
  tr:hover td{ background:#fafcff; }

  .badge{
    display:inline-flex; align-items:center; gap:6px;
    padding:6px 10px; border-radius:999px;
    border:1px solid var(--border); background:#f8fafc;
    font-weight:900; font-size:12px; color:#334155;
  }
  .badge.ok{ border-color: rgba(34,197,94,.25); background: rgba(34,197,94,.10); color:#15803d; }
  .badge.wait{ border-color: rgba(245,158,11,.25); background: rgba(245,158,11,.12); color:#92400e; }
  .badge.no{ border-color: rgba(239,68,68,.25); background: rgba(239,68,68,.10); color:#b91c1c; }

  .empty{
    border:1px dashed rgba(100,116,139,.35);
    background: rgba(255,255,255,.7);
    border-radius:14px;
    padding:18px;
    display:flex; gap:12px; align-items:flex-start;
    color:var(--muted);
  }
  .empty .bigicon{
    width:44px; height:44px; border-radius:12px;
    display:grid; place-items:center;
    background: rgba(100,116,139,.10);
    border: 1px solid rgba(100,116,139,.18);
    flex:0 0 auto;
  }
  .empty .bigicon svg{ width:22px; height:22px; fill:#475569; }

  .footer{ margin-top:22px; color:var(--muted); text-align:center; padding:20px 10px; }
</style>
</head>

<body>

<div class="topbar">
  <a href="<%= request.getContextPath() %>/help.jsp">Help</a>
</div>

<jsp:include page="/includes/navbar.jsp" />

<div class="dash-wrap">

  <div class="hero">
    <div>
      <h2 class="dashboard-title">Customer Dashboard</h2>
      <p>Quick access to rooms, your profile, and your reservations.</p>
    </div>
    <div class="hero-badge"><span class="dot"></span> Logged In</div>
  </div>

  <div class="grid">

    <!-- Quick Actions -->
    <div class="panel">
      <h3>Quick Actions</h3>
      <p class="sub">Use these shortcuts to navigate faster.</p>

      <div class="actions">

        <!-- View Rooms -->
        <div class="action-card">
          <div class="action-left">
            <div class="icon">
              <svg viewBox="0 0 24 24"><path d="M7 13c-1.1 0-2-.9-2-2V9c0-1.1.9-2 2-2h3c1.1 0 2 .9 2 2v4H7zm7-2V9c0-1.1.9-2 2-2h1c1.66 0 3 1.34 3 3v1h-6zM3 14c0-.55.45-1 1-1h16c.55 0 1 .45 1 1v5h-2v-2H5v2H3v-5z"/></svg>
            </div>
            <div>
              <p class="action-title">View Rooms</p>
              <p class="action-desc">Browse rooms, prices, and availability.</p>
            </div>
          </div>
          <a class="btn" href="<%= request.getContextPath() %>/customer/rooms">
            Open
            <svg viewBox="0 0 24 24"><path d="M14 3h7v7h-2V6.41l-9.29 9.3-1.42-1.42 9.3-9.29H14V3zM5 5h6v2H7v10h10v-4h2v6H5V5z"/></svg>
          </a>
        </div>

        <!-- My Reservations -->
        <div class="action-card">
          <div class="action-left">
            <div class="icon" style="background: rgba(34,197,94,.10); border-color: rgba(34,197,94,.18);">
              <svg viewBox="0 0 24 24" style="fill:#16a34a;">
                <path d="M7 2h2v2h6V2h2v2h3v18H4V4h3V2zm13 6H6v12h14V8z"/>
              </svg>
            </div>
            <div>
              <p class="action-title">My Reservations</p>
              <p class="action-desc">View your reservation history and status.</p>
            </div>
          </div>
          <a class="btn" href="<%= request.getContextPath() %>/customer/myreservations">Open</a>
        </div>

        <!-- Help -->
        <div class="action-card">
          <div class="action-left">
            <div class="icon" style="background: rgba(245,158,11,.12); border-color: rgba(245,158,11,.22);">
              <svg viewBox="0 0 24 24" style="fill:#b45309;">
                <path d="M12 2C6.49 2 2 6.49 2 12s4.49 10 10 10 
                  10-4.49 10-10S17.51 2 12 2zm0 17c-.83 0-1.5-.67-1.5-1.5S11.17 16 12 16s1.5.67 1.5 1.5S12.83 19 12 19zm2.1-7.75-.9.92c-.6.6-.7 1.06-.7 1.83h-2v-.5c0-1.1.2-1.84 1.05-2.7l1.24-1.26c.3-.3.46-.7.46-1.14 0-.9-.73-1.63-1.63-1.63-.9 0-1.63.73-1.63 1.63H8c0-2 1.62-3.63 3.63-3.63S15.26 7.33 15.26 9.33c0 .8-.31 1.53-.96 2.0z"/>
              </svg>
            </div>
            <div>
              <p class="action-title">Help & Support</p>
              <p class="action-desc">FAQ and contact details.</p>
            </div>
          </div>
          <a class="btn" href="<%= request.getContextPath() %>/customer/help.jsp">Open</a>
        </div>

      </div>
    </div>

    <!-- Reservation History -->
    <div class="panel">
      <div class="panel-head">
        <div>
          <h3 style="margin:0;">Reservation History</h3>
          <p class="sub" style="margin:4px 0 0;">Your latest reservations and status.</p>
        </div>
        <a href="<%= request.getContextPath() %>/customer/reservations">View All</a>
      </div>

      <%
        // Expect: request.setAttribute("reservations", List<Map<String,Object>> or List<Reservation>)
        Object obj = request.getAttribute("reservations");
        List<?> reservations = null;
        if (obj instanceof List) reservations = (List<?>) obj;

        boolean hasRows = (reservations != null && !reservations.isEmpty());
      %>

      <% if (hasRows) { %>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Reservation No</th>
                <th>Room</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <%
                for (Object row : reservations) {
                  // Works if row is Map OR a JavaBean with getters.
                  String reservationNo = "";
                  String roomName = "";
                  String checkIn = "";
                  String checkOut = "";
                  String status = "";

                  if (row instanceof Map) {
                    Map m = (Map) row;
                    reservationNo = String.valueOf(m.get("reservationNo"));
                    roomName = String.valueOf(m.get("roomName"));
                    checkIn = String.valueOf(m.get("checkIn"));
                    checkOut = String.valueOf(m.get("checkOut"));
                    status = String.valueOf(m.get("status"));
                  } else {
                    // Try reflection getters safely
                    try { reservationNo = String.valueOf(row.getClass().getMethod("getReservationNo").invoke(row)); } catch(Exception e){}
                    try { roomName = String.valueOf(row.getClass().getMethod("getRoomName").invoke(row)); } catch(Exception e){}
                    try { checkIn = String.valueOf(row.getClass().getMethod("getCheckIn").invoke(row)); } catch(Exception e){}
                    try { checkOut = String.valueOf(row.getClass().getMethod("getCheckOut").invoke(row)); } catch(Exception e){}
                    try { status = String.valueOf(row.getClass().getMethod("getStatus").invoke(row)); } catch(Exception e){}
                  }

                  String badgeClass = "badge";
                  String label = status;

                  if ("CONFIRMED".equalsIgnoreCase(status)) { badgeClass = "badge ok"; label = "Confirmed"; }
                  else if ("PENDING".equalsIgnoreCase(status)) { badgeClass = "badge wait"; label = "Pending"; }
                  else if ("CANCELLED".equalsIgnoreCase(status)) { badgeClass = "badge no"; label = "Cancelled"; }
              %>
                <tr>
                  <td><%= reservationNo %></td>
                  <td><%= roomName %></td>
                  <td><%= checkIn %></td>
                  <td><%= checkOut %></td>
                  <td><span class="<%= badgeClass %>"><%= label %></span></td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } else { %>
        <div class="empty">
          <div class="bigicon">
            <svg viewBox="0 0 24 24"><path d="M19 3H4.99C3.89 3 3 3.9 3 5v14c0 1.1.89 2 1.99 2H19c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 12h-4c0 1.66-1.34 3-3 3s-3-1.34-3-3H5V5h14v10z"/></svg>
          </div>
          <div>
            <div style="font-weight:900; color:#334155;">No reservations yet</div>
            <div style="margin-top:4px;">Go to <b>View Rooms</b> and book your first stay.</div>
            <div style="margin-top:10px;">
              <a class="btn" href="<%= request.getContextPath() %>/customer/rooms">Browse Rooms</a>
            </div>
          </div>
        </div>
      <% } %>

    </div>

  </div>

</div>

<div class="footer">© 2026 Ocean View Resort. All rights reserved.</div>

</body>
</html>