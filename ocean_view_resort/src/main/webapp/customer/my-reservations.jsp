<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Reservations</title>
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

  .panel{
    margin-top:16px;
    background:var(--card);
    border:1px solid var(--border);
    border-radius:var(--radius);
    box-shadow:var(--shadow2);
    padding:18px;
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
  .btn-outline{
    background:#fff; color:var(--primary2);
    border:1px solid rgba(37,99,235,.22);
  }
  .btn-outline:hover{ background:rgba(37,99,235,.06); }

  .actions{ display:flex; gap:10px; flex-wrap:wrap; margin-top:12px; }

  table{ width:100%; border-collapse:separate; border-spacing:0; }
  .table th, .table td{
    padding:12px 10px;
    border-bottom:1px solid var(--border);
    text-align:left;
    vertical-align:middle;
    font-size:13px;
  }
  .table th{ color:#334155; font-weight:950; font-size:12px; text-transform:uppercase; letter-spacing:.04em; }

  .badge{
    display:inline-flex; align-items:center; gap:8px;
    padding:6px 10px; border-radius:999px;
    font-weight:950; font-size:12px;
    border:1px solid transparent;
    white-space:nowrap;
  }
  .b-pending{ background:rgba(234,179,8,.12); color:#92400e; border-color:rgba(234,179,8,.25); }
  .b-confirmed{ background:rgba(34,197,94,.12); color:#166534; border-color:rgba(34,197,94,.25); }
  .b-cancelled{ background:rgba(239,68,68,.10); color:#991b1b; border-color:rgba(239,68,68,.20); }
  .b-other{ background:rgba(100,116,139,.10); color:#334155; border-color:rgba(100,116,139,.18); }

  .muted{ color:var(--muted); }
  .empty{
    padding:14px;
    border:1px dashed rgba(100,116,139,.35);
    border-radius:14px;
    background:rgba(255,255,255,.7);
  }
</style>
</head>

<body>
<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">

  <div class="hero">
    <div>
      <h2>My Reservations</h2>
      <p>View your reservation history and status.</p>
    </div>
    <div class="badge b-confirmed">Customer</div>
  </div>

  <div class="panel">
    <%
      List<Map<String,Object>> reservations =
          (List<Map<String,Object>>) request.getAttribute("reservations");
    %>

    <div class="actions">
      <a class="btn" href="<%= request.getContextPath() %>/customer/rooms">Book a Room</a>
      <a class="btn btn-outline" href="<%= request.getContextPath() %>/customer/dashboard">Back</a>
    </div>

    <hr style="border:none;border-top:1px solid var(--border); margin:14px 0;">

    <%
      if (reservations == null || reservations.isEmpty()) {
    %>
      <div class="empty">
        <b>No reservations found.</b>
        <div class="muted" style="margin-top:6px;">
          Your reservations will appear here after you place a booking.
        </div>
      </div>
    <%
      } else {
    %>

    <table class="table">
      <thead>
        <tr>
          <th>Reservation</th>
          <th>Room</th>
          <th>Check-In</th>
          <th>Check-Out</th>
          <th>Guests</th>
          <th>Total</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
      <%
        for (Map<String,Object> r : reservations) {
          String status = (r.get("status") == null) ? "" : String.valueOf(r.get("status"));
          String cls = "b-other";
          if ("PENDING".equalsIgnoreCase(status)) cls = "b-pending";
          else if ("CONFIRMED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) cls = "b-confirmed";
          else if ("CANCELLED".equalsIgnoreCase(status)) cls = "b-cancelled";
      %>
        <tr>
          <td>
            <div style="font-weight:950;">
              <%= (r.get("reservationNo") != null && !String.valueOf(r.get("reservationNo")).isBlank())
                    ? r.get("reservationNo")
                    : ("#" + r.get("reservationId")) %>
            </div>
            <div class="muted" style="font-size:12px;">Created: <%= r.get("createdAt") %></div>
          </td>

          <td>
            <b><%= r.get("roomNumber") %></b>
            <div class="muted" style="font-size:12px;"><%= r.get("roomType") %></div>
          </td>

          <td><%= r.get("checkIn") %></td>
          <td><%= r.get("checkOut") %></td>
          <td><%= r.get("guests") %></td>
          <td>Rs. <%= r.get("grandTotal") %></td>

          <td>
            <span class="badge <%= cls %>"><%= status %></span>
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
</body>
</html>