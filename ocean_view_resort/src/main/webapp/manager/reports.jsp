<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manager Reports</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
  <style>
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    .card{background:#fff;border:1px solid #eee;border-radius:14px;padding:18px}
    .row{display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap}
    .btn{display:inline-block;padding:10px 14px;border-radius:10px;border:1px solid #ddd;background:#f7f7f7;text-decoration:none;color:#111;cursor:pointer}
    canvas{width:100% !important; height:320px !important;}
    .btns{display:flex;gap:10px;flex-wrap:wrap}
  </style>
</head>
<body>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">

  <div class="card">
    <div class="row">
      <div>
        <h2>Reservation Reports (Year: <%=request.getAttribute("year")%>)</h2>
        <% if (request.getAttribute("error") != null) { %>
          <div class="alert error"><%= request.getAttribute("error") %></div>
        <% } %>
      </div>

      <div class="btns">
        <button class="btn" type="button" onclick="downloadPDF()">Download PDF</button>
        <button class="btn" type="button" onclick="downloadPNGs()">Download PNG</button>

        <!-- CSV download (server-side servlet below) -->
        <a class="btn"
           href="<%=request.getContextPath()%>/manager/reports/download?year=<%=request.getAttribute("year")%>">
          Download CSV
        </a>

        <!-- change to your real manager dashboard path -->
        <a class="btn" href="<%=request.getContextPath()%>/manager/dashboard">← Back</a>
      </div>
    </div>
  </div>

  <div class="grid">
    <div class="card">
      <h3>Reservations per Month</h3>
      <canvas id="chartMonth"></canvas>
    </div>

    <div class="card">
      <h3>Reservations by Status</h3>
      <canvas id="chartStatus"></canvas>
    </div>

    <div class="card" style="grid-column:1 / -1;">
      <h3>Revenue per Month (CONFIRMED/COMPLETED)</h3>
      <canvas id="chartRevenue"></canvas>
    </div>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- jsPDF for PDF download -->
<script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>

<script>
  // Data from servlet (already JSON arrays)
  const monthLabels  = <%= (String)request.getAttribute("monthLabels") %>;
  const monthCounts  = <%= (String)request.getAttribute("monthCounts") %>;

  const statusLabels = <%= (String)request.getAttribute("statusLabels") %>;
  const statusCounts = <%= (String)request.getAttribute("statusCounts") %>;

  const revLabels    = <%= (String)request.getAttribute("revLabels") %>;
  const revTotals    = <%= (String)request.getAttribute("revTotals") %>;

  const chartMonth = new Chart(document.getElementById("chartMonth"), {
    type: "bar",
    data: { labels: monthLabels, datasets: [{ label: "Reservations", data: monthCounts }] },
    options: { responsive: true }
  });

  const chartStatus = new Chart(document.getElementById("chartStatus"), {
    type: "doughnut",
    data: { labels: statusLabels, datasets: [{ label: "Count", data: statusCounts }] },
    options: { responsive: true }
  });

  const chartRevenue = new Chart(document.getElementById("chartRevenue"), {
    type: "line",
    data: { labels: revLabels, datasets: [{ label: "Revenue", data: revTotals, tension: 0.2 }] },
    options: { responsive: true }
  });

  function downloadChartPNG(chart, filename){
    const a = document.createElement("a");
    a.href = chart.toBase64Image();
    a.download = filename;
    a.click();
  }

  function downloadPNGs(){
    const year = "<%=request.getAttribute("year")%>";
    downloadChartPNG(chartMonth, `reservations_per_month_${year}.png`);
    downloadChartPNG(chartStatus, `reservations_by_status_${year}.png`);
    downloadChartPNG(chartRevenue, `revenue_per_month_${year}.png`);
  }

  async function downloadPDF(){
    const year = "<%=request.getAttribute("year")%>";
    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF("p", "mm", "a4");

    pdf.setFontSize(16);
    pdf.text(`Manager Reports - ${year}`, 14, 15);

    // helper: add chart image
    function addChart(chart, title, yStart){
      pdf.setFontSize(12);
      pdf.text(title, 14, yStart);
      const img = chart.toBase64Image();
      pdf.addImage(img, "PNG", 14, yStart + 5, 180, 80);
    }

    addChart(chartMonth, "Reservations per Month", 25);
    pdf.addPage();
    addChart(chartStatus, "Reservations by Status", 25);
    pdf.addPage();
    addChart(chartRevenue, "Revenue per Month", 25);

    pdf.save(`manager_reports_${year}.pdf`);
  }
</script>

</body>
</html>