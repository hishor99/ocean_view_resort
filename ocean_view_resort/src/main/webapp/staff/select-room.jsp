<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Staff - Available Rooms</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">

  <style>
    body{background:#f6f8fb}
    .wrap{max-width:1200px;margin:0 auto;padding:20px}

    .headerCard{
      background: linear-gradient(135deg, #eef4ff, #ffffff);
      border: 1px solid #e9eef5;
      border-radius: 18px;
      padding: 22px;
      display:flex;justify-content:space-between;align-items:center;gap:16px;
      box-shadow: 0 10px 25px rgba(16,24,40,.08);
    }
    .headerCard h2{margin:0;font-size:28px}
    .headerCard p{margin:6px 0 0;color:#64748b}

    .rolePill{
      display:inline-flex;align-items:center;gap:10px;
      padding:10px 14px;border-radius:999px;
      border:1px solid #c7d2fe;background:#eef2ff;
      color:#1d4ed8;font-weight:900;white-space:nowrap;
    }
    .dot{width:10px;height:10px;border-radius:50%;background:#22c55e;box-shadow:0 0 0 4px rgba(34,197,94,.18)}

    .topbar{margin:16px 0;display:flex;justify-content:space-between;align-items:center;gap:12px}
    .tip{color:#64748b;font-weight:700}
    .btnBack{
      display:inline-flex;align-items:center;gap:8px;
      padding:10px 14px;border-radius:12px;
      border:1px solid #e9eef5;background:#fff;
      text-decoration:none;color:#0f172a;font-weight:900;
      box-shadow: 0 6px 18px rgba(16,24,40,.06);
    }

    .summary{
      margin-top:14px;
      padding:14px 16px;
      border-radius:14px;
      border:1px solid #e9eef5;
      background:#ffffffcc;
      display:grid;
      grid-template-columns: repeat(4, minmax(0,1fr));
      gap:12px;
    }
    .sumItem{border:1px dashed #dbe5f5;border-radius:12px;padding:12px}
    .sumItem .k{font-size:12px;color:#64748b;margin-bottom:4px}
    .sumItem .v{font-weight:900}

    .grid{margin-top:18px;display:grid;grid-template-columns: repeat(3, minmax(0,1fr));gap:18px}
    @media(max-width:1000px){ .grid{grid-template-columns:repeat(2,1fr)} .summary{grid-template-columns:repeat(2,1fr)} }
    @media(max-width:650px){ .grid{grid-template-columns:1fr} }

    .roomCard{
      background:#fff;border:1px solid #e9eef5;border-radius:18px;padding:18px;
      box-shadow: 0 10px 25px rgba(16,24,40,.08);
      display:flex;flex-direction:column;gap:14px;
    }

    .thumb{
      height:110px;border-radius:16px;border:1px solid #e9eef5;
      background: radial-gradient(circle at 20% 30%, #dbeafe, #ffffff 55%, #eef2ff);
      display:flex;align-items:center;justify-content:center;
      font-weight:900;font-size:28px;color:#1d4ed8;
    }

    .roomHeader{display:flex;justify-content:space-between;align-items:flex-start;gap:12px}
    .roomTitle{margin:0;font-size:22px}
    .roomType{margin-top:4px;color:#64748b;font-weight:800}

    .statusPill{
      padding:8px 12px;border-radius:999px;font-weight:900;font-size:13px;white-space:nowrap;
      border:1px solid #b9f1cb;background:#e9f9ef;color:#0f7a35;
    }
    .statusBooked{border-color:#ffd7aa;background:#fff7ed;color:#9a3412;}
    .statusMaint{border-color:#fecaca;background:#fef2f2;color:#991b1b;}

    .miniGrid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
    .mini{border:1px solid #dbe5f5;border-radius:14px;padding:12px;background:#fbfdff}
    .mini .k{color:#64748b;font-weight:900;font-size:12px;letter-spacing:.2px}
    .mini .v{margin-top:6px;font-size:18px;font-weight:900}

    .footerRow{display:flex;justify-content:space-between;align-items:center;gap:12px}
    .reserveBtn{
      padding:11px 16px;border-radius:12px;border:0;
      background:#111827;color:#fff;font-weight:900;cursor:pointer;
    }
    .reserveBtn:hover{opacity:.92}
    .hint{color:#64748b;font-weight:900}

    .empty{
      margin-top:18px;padding:18px;background:#fff;border:1px solid #e9eef5;border-radius:16px;
      box-shadow: 0 10px 25px rgba(16,24,40,.08);color:#64748b;font-weight:800;
    }

    /* ✅ Add-ons card */
    .addonsCard h3{margin:0 0 12px;font-size:18px}
    .addonsGrid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
    @media(max-width:650px){ .addonsGrid{grid-template-columns:1fr} }
    .addonsCard label{display:block;font-weight:900;margin-bottom:6px;color:#0f172a}
    .addonsCard select{
      width:100%;padding:10px 12px;border-radius:12px;
      border:1px solid #e9eef5;background:#fff;font-weight:800;
    }
    .addonsNote{margin:10px 0 0;color:#64748b;font-weight:700}
  </style>
</head>

<body>
<jsp:include page="/includes/navbar.jsp" />

<div class="wrap">

  <div class="headerCard">
    <div>
      <h2>Available Rooms</h2>
      <p>Select a room to confirm the reservation and generate the invoice.</p>
    </div>
    <div class="rolePill"><span class="dot"></span> Staff</div>
  </div>

  <div class="topbar">
    <div class="tip">Select add-ons (optional), then click <b>Reserve</b> on a room card.</div>
    <a class="btnBack" href="<%=request.getContextPath()%>/staff/add-reservation">← Back</a>
  </div>

  <div class="summary">
    <div class="sumItem">
      <div class="k">Guest</div>
      <div class="v">${sessionScope.tmp_full_name}</div>
    </div>
    <div class="sumItem">
      <div class="k">Phone</div>
      <div class="v">${sessionScope.tmp_phone}</div>
    </div>
    <div class="sumItem">
      <div class="k">Dates</div>
      <div class="v">${sessionScope.tmp_check_in} → ${sessionScope.tmp_check_out}</div>
    </div>
    <div class="sumItem">
      <div class="k">Guests</div>
      <div class="v">${sessionScope.tmp_guests}</div>
    </div>
  </div>

  <!-- ✅ Add-ons (Food + Vehicle) shown ONCE -->
  <div class="roomCard addonsCard" style="margin-top:16px;">
    <h3>Add-ons (Optional)</h3>

    <div class="addonsGrid">
      <div>
        <label for="food_id">Food Package</label>
        <select id="food_id">
          <option value="">-- None --</option>
          <c:forEach var="f" items="${foodPackages}">
            <option value="${f.foodId}">
              ${f.name} - Rs.
              <fmt:formatNumber value="${f.pricePerDay}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
              / day (${f.pricingType})
            </option>
          </c:forEach>
        </select>
      </div>

      <div>
        <label for="vehicle_id">Vehicle</label>
        <select id="vehicle_id">
          <option value="">-- None --</option>
          <c:forEach var="v" items="${vehicles}">
            <option value="${v.vehicleId}">
              ${v.type} ${v.model} (${v.plateNo}) - Rs.
              <fmt:formatNumber value="${v.pricePerDay}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
              / day
            </option>
          </c:forEach>
        </select>
      </div>
    </div>

    <div class="addonsNote">
      These selections will be applied to whichever room you reserve.
    </div>
  </div>

  <c:if test="${empty rooms}">
    <div class="empty">No rooms available for selected dates/guests. Please go back and try different dates or guest count.</div>
  </c:if>

  <c:if test="${not empty rooms}">
    <div class="grid">

      <c:forEach var="r" items="${rooms}">
        <div class="roomCard">

          <div class="thumb">
            ${r.roomType.substring(0,1)}
          </div>

          <div class="roomHeader">
            <div>
              <h3 class="roomTitle">Room ${r.roomNumber}</h3>
              <div class="roomType">${r.roomType}</div>
            </div>

            <c:set var="st" value="${r.status}" />
            <span class="statusPill
              <c:if test='${st == "BOOKED"}'> statusBooked</c:if>
              <c:if test='${st == "MAINTENANCE"}'> statusMaint</c:if>
            ">
              ${st}
            </span>
          </div>

          <div class="miniGrid">
            <div class="mini">
              <div class="k">PRICE / NIGHT</div>
              <div class="v">
                Rs. <fmt:formatNumber value="${r.pricePerNight}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
              </div>
            </div>
            <div class="mini">
              <div class="k">CAPACITY</div>
              <div class="v">${r.capacity} persons</div>
            </div>
          </div>

          <div class="footerRow">
            <form method="post" action="<%=request.getContextPath()%>/staff/add-reservation" class="reserveForm" style="margin:0;">
              <input type="hidden" name="step" value="createReservation">
              <input type="hidden" name="room_id" value="${r.roomId}">

              <!-- ✅ add-ons copied by JS -->
              <input type="hidden" name="food_id" class="foodHidden" value="">
              <input type="hidden" name="vehicle_id" class="vehicleHidden" value="">

              <button type="submit" class="reserveBtn">Reserve</button>
            </form>

            <div class="hint">Confirm booking</div>
          </div>

        </div>
      </c:forEach>

    </div>
  </c:if>

</div>

<script>
  // ✅ Copy selected add-ons into every room form hidden inputs
  const foodSelect = document.getElementById("food_id");
  const vehicleSelect = document.getElementById("vehicle_id");

  function syncAddonValues() {
    const foodVal = foodSelect ? foodSelect.value : "";
    const vehicleVal = vehicleSelect ? vehicleSelect.value : "";

    document.querySelectorAll(".reserveForm").forEach(form => {
      const f = form.querySelector(".foodHidden");
      const v = form.querySelector(".vehicleHidden");
      if (f) f.value = foodVal;
      if (v) v.value = vehicleVal;
    });
  }

  if (foodSelect) foodSelect.addEventListener("change", syncAddonValues);
  if (vehicleSelect) vehicleSelect.addEventListener("change", syncAddonValues);

  // initial
  syncAddonValues();
</script>

</body>
</html>