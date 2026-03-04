<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manager Reports</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
  <style>
    body{background:#f6f7fb;}
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    .card{background:#fff;border:1px solid #eee;border-radius:14px;padding:18px;box-shadow:0 6px 18px rgba(0,0,0,.04)}
    .row{display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap}
    .btn{display:inline-block;padding:10px 14px;border-radius:10px;border:1px solid #ddd;background:#f7f7f7;text-decoration:none;color:#111;cursor:pointer}
    .btns{display:flex;gap:10px;flex-wrap:wrap}
    .muted{color:#777}
    table{width:100%;border-collapse:collapse}
    th,td{padding:10px;border-bottom:1px solid #eee;text-align:left}
    th{background:#fafafa}
    .right{text-align:right}
    .kpis{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px}
    @media (max-width:900px){ .kpis{grid-template-columns:repeat(2,1fr);} .grid{grid-template-columns:1fr;} }
    .kpi{border:1px solid #eee;border-radius:14px;padding:14px;background:#fafafa}
    .kpi .label{color:#666;font-size:12px}
    .kpi .value{font-size:22px;font-weight:800;margin-top:6px}
  </style>
</head>
<body>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">

  <%
    Integer year = (Integer) request.getAttribute("year");
    if (year == null) year = java.time.LocalDate.now().getYear();

    Map<String,Integer> monthData  = (Map<String,Integer>) request.getAttribute("monthData");
    Map<String,Integer> statusData = (Map<String,Integer>) request.getAttribute("statusData");
    Map<String,Double>  revenueData= (Map<String,Double>)  request.getAttribute("revenueData");

    if(monthData == null) monthData = new LinkedHashMap<>();
    if(statusData == null) statusData = new LinkedHashMap<>();
    if(revenueData == null) revenueData = new LinkedHashMap<>();

    int totalReservations = 0;
    for(Integer v : monthData.values()) totalReservations += (v == null ? 0 : v);

    int totalStatus = 0;
    for(Integer v : statusData.values()) totalStatus += (v == null ? 0 : v);

    double totalRevenue = 0;
    for(Double v : revenueData.values()) totalRevenue += (v == null ? 0 : v);

    // top month
    String topMonth = "-";
    int topMonthVal = -1;
    for(Map.Entry<String,Integer> e : monthData.entrySet()){
      int v = (e.getValue()==null?0:e.getValue());
      if(v > topMonthVal){ topMonthVal = v; topMonth = e.getKey(); }
    }

    // top status
    String topStatus = "-";
    int topStatusVal = -1;
    for(Map.Entry<String,Integer> e : statusData.entrySet()){
      int v = (e.getValue()==null?0:e.getValue());
      if(v > topStatusVal){ topStatusVal = v; topStatus = e.getKey(); }
    }
  %>

  <div class="card">
    <div class="row">
      <div>
        <h2 style="margin:0;">Reservation Reports (Year: <%=year%>)</h2>
        <p class="muted" style="margin:6px 0 0;">Numbers summary (no charts).</p>

        <% if (request.getAttribute("error") != null) { %>
          <div class="alert error" style="margin-top:10px;"><%= request.getAttribute("error") %></div>
        <% } %>
      </div>

      <div class="btns">
        <!-- If you have CSV servlet -->
        <a class="btn" href="<%=request.getContextPath()%>/manager/reports/download?year=<%=year%>">Download CSV</a>

        <a class="btn" href="<%=request.getContextPath()%>/manager/dashboard">← Back</a>
      </div>
    </div>
  </div>

  <div class="card">
    <h3 style="margin-top:0;">Summary</h3>
    <div class="kpis">
      <div class="kpi">
        <div class="label">Total Reservations</div>
        <div class="value"><%= totalReservations %></div>
      </div>
      <div class="kpi">
        <div class="label">Total Revenue (Confirmed/Completed)</div>
        <div class="value"><%= String.format("%,.2f", totalRevenue) %></div>
      </div>
      <div class="kpi">
        <div class="label">Top Month</div>
        <div class="value"><%= topMonth %> (<%= topMonthVal < 0 ? 0 : topMonthVal %>)</div>
      </div>
      <div class="kpi">
        <div class="label">Top Status</div>
        <div class="value"><%= topStatus %> (<%= topStatusVal < 0 ? 0 : topStatusVal %>)</div>
      </div>
    </div>
  </div>

  <div class="grid">

    <div class="card">
      <h3 style="margin-top:0;">Reservations per Month</h3>

      <% if(monthData.isEmpty()) { %>
        <p class="muted">No data found.</p>
      <% } else { %>
      <table>
        <tr>
          <th>Month</th>
          <th class="right">Reservations</th>
        </tr>
        <% for(Map.Entry<String,Integer> e : monthData.entrySet()) { %>
        <tr>
          <td><%= e.getKey() %></td>
          <td class="right"><%= e.getValue() %></td>
        </tr>
        <% } %>
        <tr>
          <th>Total</th>
          <th class="right"><%= totalReservations %></th>
        </tr>
      </table>
      <% } %>
    </div>

    <div class="card">
      <h3 style="margin-top:0;">Reservations by Status</h3>

      <% if(statusData.isEmpty()) { %>
        <p class="muted">No data found.</p>
      <% } else { %>
      <table>
        <tr>
          <th>Status</th>
          <th class="right">Count</th>
        </tr>
        <% for(Map.Entry<String,Integer> e : statusData.entrySet()) { %>
        <tr>
          <td><%= e.getKey() %></td>
          <td class="right"><%= e.getValue() %></td>
        </tr>
        <% } %>
        <tr>
          <th>Total</th>
          <th class="right"><%= totalStatus %></th>
        </tr>
      </table>
      <% } %>
    </div>

    <div class="card" style="grid-column:1 / -1;">
      <h3 style="margin-top:0;">Revenue per Month (CONFIRMED/COMPLETED)</h3>

      <% if(revenueData.isEmpty()) { %>
        <p class="muted">No revenue data found.</p>
      <% } else { %>
      <table>
        <tr>
          <th>Month</th>
          <th class="right">Revenue</th>
        </tr>
        <% for(Map.Entry<String,Double> e : revenueData.entrySet()) { %>
        <tr>
          <td><%= e.getKey() %></td>
          <td class="right"><%= String.format("%,.2f", e.getValue()) %></td>
        </tr>
        <% } %>
        <tr>
          <th>Total</th>
          <th class="right"><%= String.format("%,.2f", totalRevenue) %></th>
        </tr>
      </table>
      <% } %>
    </div>

  </div>

</div>

</body>
</html>