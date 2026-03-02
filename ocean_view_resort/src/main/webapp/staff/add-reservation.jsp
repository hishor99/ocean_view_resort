<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Staff - Add Reservation</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
  <style>
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    .card{background:#fff;border:1px solid #eee;border-radius:14px;padding:18px}
    .field{display:flex;flex-direction:column;gap:6px;margin-bottom:12px}
    input,textarea{padding:10px;border:1px solid #ddd;border-radius:10px}
    .actions{display:flex;gap:10px;justify-content:flex-end;margin-top:10px}
    .btn{padding:10px 14px;border-radius:10px;border:0;cursor:pointer}
    .btn-primary{background:#111;color:#fff}
    .msg{padding:10px;border-radius:10px;margin-bottom:12px}
    .err{background:#ffecec;border:1px solid #ffb3b3}
  </style>
</head>
<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="container" style="max-width:1100px;margin:auto;padding:20px">
  <h2>Add New Reservation (Staff)</h2>

  <c:if test="${not empty error}">
    <div class="msg err">${error}</div>
  </c:if>

  <form method="post" action="<%=request.getContextPath()%>/staff/add-reservation">
    <input type="hidden" name="step" value="checkRooms">

    <div class="grid">

      <div class="card">
        <h3>Guest Details</h3>

        <div class="field">
          <label>Guest Name *</label>
          <input name="full_name" required>
        </div>

        <div class="field">
          <label>Address</label>
          <textarea name="address" rows="3"></textarea>
        </div>

        <div class="field">
          <label>Contact Number *</label>
          <input name="phone" required>
        </div>

        <div class="field">
          <label>Email</label>
          <input type="email" name="email">
        </div>
      </div>

      <div class="card">
        <h3>Booking Details</h3>

        <div class="field">
          <label>Check-in *</label>
          <input type="date" name="check_in" required>
        </div>

        <div class="field">
          <label>Check-out *</label>
          <input type="date" name="check_out" required>
        </div>

        <div class="field">
          <label>Guests *</label>
          <input type="number" name="guests" min="1" value="1" required>
        </div>

        <div class="actions">
          <button type="submit" class="btn btn-primary">Search Available Rooms</button>
        </div>
      </div>

    </div>
  </form>
  <button type="button"
        onclick="history.back()"
        style="padding:8px 14px;
               border-radius:10px;
               background:#f1f5f9;
               border:1px solid #e2e8f0;
               font-weight:800;
               cursor:pointer;">
  ← Go Back
</button>
</div>

</body>
</html>