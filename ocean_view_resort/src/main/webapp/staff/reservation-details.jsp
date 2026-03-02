<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservation Details</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">

<style>
body{background:#f6f8fb}
.wrap{max-width:1100px;margin:0 auto;padding:20px}

.headerCard{
  background: linear-gradient(135deg, #eef4ff, #ffffff);
  border: 1px solid #e9eef5;
  border-radius: 18px;
  padding: 22px;
  box-shadow: 0 10px 25px rgba(16,24,40,.08);
}

.searchBox{
  margin-top:15px;
  display:flex;
  gap:10px;
}

.searchBox input{
  flex:1;
  padding:12px;
  border-radius:12px;
  border:1px solid #e9eef5;
  font-weight:800;
}

.searchBtn{
  padding:12px 18px;
  border-radius:12px;
  border:0;
  background:#111827;
  color:#fff;
  font-weight:900;
  cursor:pointer;
}

.searchBtn:hover{opacity:.9}

.card{
  margin-top:18px;
  background:#fff;
  border:1px solid #e9eef5;
  border-radius:18px;
  padding:20px;
  box-shadow: 0 10px 25px rgba(16,24,40,.08);
}

.sectionTitle{
  font-size:18px;
  font-weight:900;
  margin-bottom:10px;
}

.grid{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:18px;
}

.infoBox{
  border:1px dashed #dbe5f5;
  border-radius:14px;
  padding:12px;
  background:#fbfdff;
}

.k{color:#64748b;font-size:13px;font-weight:900}
.v{margin-top:4px;font-size:16px;font-weight:900}

.statusBadge{
  display:inline-block;
  padding:6px 12px;
  border-radius:999px;
  font-weight:900;
  font-size:13px;
  margin-left:10px;
}

.statusCONFIRMED{background:#e9f9ef;color:#0f7a35;border:1px solid #b9f1cb}
.statusPENDING{background:#fff7ed;color:#9a3412;border:1px solid #ffd7aa}
.statusCANCELLED{background:#fef2f2;color:#991b1b;border:1px solid #fecaca}

.totalBox{
  margin-top:15px;
  padding:16px;
  border-radius:16px;
  background:#111827;
  color:#fff;
  font-weight:900;
  text-align:center;
  font-size:20px;
}

.alert{
  margin-top:10px;
  padding:10px;
  border-radius:10px;
  background:#fef2f2;
  color:#991b1b;
  font-weight:800;
}
</style>
</head>

<body>
<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">

  <!-- Header -->
  <div class="headerCard">
    <h2>Reservation Details</h2>
    <p>Search and view reservation details using reservation number.</p>

    <form method="post" action="<%=request.getContextPath()%>/staff/reservation-details" class="searchBox">
      <input type="text" name="reservation_no" placeholder="Enter reservation number (RES-2026-000001)" required>
      <button type="submit" class="searchBtn">View Details →</button>
    </form>

    <c:if test="${not empty error}">
      <div class="alert">${error}</div>
    </c:if>
  </div>

  <!-- Details Section -->
  <c:if test="${not empty details}">
    <div class="card">

      <div style="display:flex;justify-content:space-between;align-items:center;">
        <h3>Reservation ${details.reservationNo}</h3>
        <span class="statusBadge status${details.status}">
          ${details.status}
        </span>
      </div>

      <hr style="margin:15px 0;">

      <!-- Guest + Stay -->
      <div class="grid">

        <div>
          <div class="sectionTitle">Guest Information</div>
          <div class="infoBox">
            <div class="k">Name</div>
            <div class="v">${details.guestName}</div>

            <div class="k" style="margin-top:8px;">Phone</div>
            <div class="v">${details.guestPhone}</div>

            <div class="k" style="margin-top:8px;">Email</div>
            <div class="v">${details.guestEmail}</div>

            <div class="k" style="margin-top:8px;">Address</div>
            <div class="v">${details.guestAddress}</div>
          </div>
        </div>

        <div>
          <div class="sectionTitle">Stay Details</div>
          <div class="infoBox">
            <div class="k">Room</div>
            <div class="v">Room ${details.roomNumber} (${details.roomType})</div>

            <div class="k" style="margin-top:8px;">Check-in / Check-out</div>
            <div class="v">${details.checkIn} → ${details.checkOut}</div>

            <div class="k" style="margin-top:8px;">Nights / Guests</div>
            <div class="v">${details.nights} Nights | ${details.guests} Guests</div>
          </div>
        </div>

      </div>

      <hr style="margin:20px 0;">

      <!-- Add-ons -->
      <div class="sectionTitle">Add-ons</div>
      <div class="grid">

        <div class="infoBox">
          <div class="k">Food Package</div>
          <div class="v">
            <c:choose>
              <c:when test="${not empty details.foodId}">
                ${details.foodName}
                <br>
                Rs.
                <fmt:formatNumber value="${details.foodPricePerDay}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                / day (${details.foodPricingType})
              </c:when>
              <c:otherwise>None</c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="infoBox">
          <div class="k">Vehicle</div>
          <div class="v">
            <c:choose>
              <c:when test="${not empty details.vehicleId}">
                ${details.vehicleType} ${details.vehicleModel}
                <br>
                (${details.plateNo})
                <br>
                Rs.
                <fmt:formatNumber value="${details.vehiclePricePerDay}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                / day
              </c:when>
              <c:otherwise>None</c:otherwise>
            </c:choose>
          </div>
        </div>

      </div>

      <hr style="margin:20px 0;">

      <!-- Totals -->
      <div class="sectionTitle">Totals</div>
      <div class="grid">
        <div class="infoBox">
          <div class="k">Room Total</div>
          <div class="v">Rs. <fmt:formatNumber value="${details.roomTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
        </div>

        <div class="infoBox">
          <div class="k">Food Total</div>
          <div class="v">Rs. <fmt:formatNumber value="${details.foodTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
        </div>

        <div class="infoBox">
          <div class="k">Vehicle Total</div>
          <div class="v">Rs. <fmt:formatNumber value="${details.vehicleTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
        </div>
      </div>

      <div class="totalBox">
        Grand Total: Rs.
        <fmt:formatNumber value="${details.grandTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
      </div>

    </div>
  </c:if>

</div>

</body>
</html>