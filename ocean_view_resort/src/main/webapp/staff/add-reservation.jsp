<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Room" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Reservation (Walk-in)</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

  <style>
    /* page-only UI enhancements */
    .hero {
      padding:18px;
      border:1px solid #e9e9e9;
      border-radius:16px;
      background:#fff;
      margin-bottom:14px;
      display:flex;
      justify-content:space-between;
      gap:16px;
      align-items:flex-start;
    }
    .hero h2 { margin:0 0 6px 0; font-size:22px; }
    .hero p { margin:0; color:#666; }
    .badge {
      display:inline-flex;
      gap:8px;
      align-items:center;
      padding:10px 12px;
      border-radius:999px;
      border:1px solid #e9e9e9;
      background:#f6f6f6;
      color:#333;
      font-size:14px;
      white-space:nowrap;
    }

    .card2{
      background:#fff;
      border:1px solid #e9e9e9;
      border-radius:16px;
      padding:16px;
      margin-bottom:14px;
    }

    .grid{
      display:grid;
      grid-template-columns:repeat(2, minmax(0, 1fr));
      gap:12px;
    }
    @media (max-width: 900px){ .grid{ grid-template-columns:1fr; } }

    .field label{
      display:block;
      font-size:14px;
      margin:0 0 6px 0;
      color:#333;
    }
    .field input, .field select, .field textarea{
      width:100%;
      padding:10px 12px;
      border:1px solid #ddd;
      border-radius:12px;
      outline:none;
      font-size:14px;
      background:#fff;
    }
    .field textarea{ min-height:84px; resize:vertical; }

    .hint{ font-size:12px; color:#777; margin-top:6px; }
    .muted{ color:#666; }

    .summary{
      display:grid;
      grid-template-columns:repeat(4, minmax(0, 1fr));
      gap:10px;
      margin-top:10px;
    }
    @media (max-width: 900px){ .summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }

    .stat{
      border:1px solid #eee;
      border-radius:14px;
      padding:12px;
      background:#fafafa;
    }
    .stat .k{ font-size:12px; color:#777; }
    .stat .v{ font-size:16px; font-weight:600; margin-top:4px; }

    .actions{
      display:flex;
      gap:10px;
      align-items:center;
      margin-top:12px;
      flex-wrap:wrap;
    }
    .btn{
      padding:10px 14px;
      border-radius:12px;
      border:1px solid #e0e0e0;
      background:#f4f4f4;
      cursor:pointer;
      text-decoration:none;
      color:#111;
      font-size:14px;
      display:inline-flex;
      gap:8px;
      align-items:center;
    }
    .btn:hover{ background:#eee; }
    .btn-primary{
      background:#111;
      color:#fff;
      border-color:#111;
    }
    .btn-primary:hover{ background:#000; }

    .alert{
      padding:10px 12px;
      border-radius:12px;
      margin-top:10px;
      border:1px solid #e9e9e9;
    }
    .alert.error{ background:#ffe3e3; border-color:#ffd0d0; }
    .alert.success{ background:#dff7df; border-color:#c9efc9; }

    .req{ color:#d00; font-weight:700; }
  </style>
</head>

<body>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<%
  List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>

<div class="container">

  <!-- Header -->
  <div class="hero">
    <div>
      <h2>Add Reservation (Walk-in)</h2>
      <p class="muted">Enter guest details, pick an available room, and confirm dates. Add-ons can be added in the next step.</p>

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert error">❌ <%= request.getAttribute("error") %></div>
      <% } %>
      <% if (request.getAttribute("success") != null) { %>
        <div class="alert success">✅ <%= request.getAttribute("success") %></div>
      <% } %>
    </div>

    <div class="badge">🧾 Step 1 of 2</div>
  </div>

  <!-- Form -->
  <div class="card2">
    <form method="post" action="<%= request.getContextPath() %>/staff/add-reservation" id="resForm">

      <h3 style="margin:0 0 10px 0;">Guest Information</h3>
      <div class="grid">
        <div class="field">
          <label>Guest Full Name <span class="req">*</span></label>
          <input type="text" name="guestName" required placeholder="e.g., Nimal Perera">
        </div>

        <div class="field">
          <label>Contact Number <span class="req">*</span></label>
          <input type="text" name="guestPhone" required placeholder="e.g., 0771234567">
          <div class="hint">Use a reachable mobile number.</div>
        </div>

        <div class="field">
          <label>Email (optional)</label>
          <input type="email" name="guestEmail" placeholder="e.g., nimal@gmail.com">
        </div>

        <div class="field">
          <label>Address <span class="req">*</span></label>
          <input type="text" name="guestAddress" required placeholder="e.g., No 12, Main Street, Colombo">
        </div>
      </div>

      <hr style="border:none;border-top:1px solid #eee;margin:14px 0;">

      <h3 style="margin:0 0 10px 0;">Stay & Room Selection</h3>
      <div class="grid">
        <div class="field">
          <label>Check-in Date <span class="req">*</span></label>
          <input type="date" name="checkIn" id="checkIn" required>
        </div>

        <div class="field">
          <label>Check-out Date <span class="req">*</span></label>
          <input type="date" name="checkOut" id="checkOut" required>
        </div>

        <div class="field">
          <label>Number of Guests <span class="req">*</span></label>
          <input type="number" name="guests" id="guests" min="1" value="1" required>
        </div>

        <div class="field">
          <label>Select Available Room <span class="req">*</span></label>
          <select name="roomId" id="roomId" required>
            <option value="" disabled selected>-- Choose a room --</option>
            <%
              if (rooms != null) {
                for (Room r : rooms) {
            %>
              <option value="<%= r.getRoomId() %>"
                      data-price="<%= r.getPricePerNight() %>"
                      data-capacity="<%= r.getCapacity() %>"
                      data-type="<%= r.getRoomType() %>"
                      data-number="<%= r.getRoomNumber() %>">
                Room <%= r.getRoomNumber() %> - <%= r.getRoomType() %>
                (Cap: <%= r.getCapacity() %>, Rs: <%= r.getPricePerNight() %>/night)
              </option>
            <%
                }
              }
            %>
          </select>
          <div class="hint">Only rooms with status <b>AVAILABLE</b> are shown.</div>
        </div>
      </div>

      <!-- Live Summary -->
      <div class="summary">
        <div class="stat">
          <div class="k">Selected Room</div>
          <div class="v" id="sRoom">—</div>
        </div>
        <div class="stat">
          <div class="k">Room Price / Night</div>
          <div class="v" id="sPrice">—</div>
        </div>
        <div class="stat">
          <div class="k">Nights</div>
          <div class="v" id="sNights">0</div>
        </div>
        <div class="stat">
          <div class="k">Estimated Room Total</div>
          <div class="v" id="sTotal">Rs. 0.00</div>
        </div>
      </div>

      <!-- Hidden fields (optional if your DAO calculates itself, but useful if you want to store) -->
      <input type="hidden" name="nights" id="nights" value="1">
      <input type="hidden" name="roomTotal" id="roomTotal" value="0">

      <div class="actions">
        <button type="submit" class="btn btn-primary">➕ Create Reservation</button>
        <a class="btn" href="<%= request.getContextPath() %>/staff/dashboard.jsp">← Back to Dashboard</a>
      </div>

      <p class="hint">After creating, you will be taken to Step 2 to add optional food and vehicle services.</p>
    </form>
  </div>

</div>

<jsp:include page="/includes/footer.jsp" />

<script>
  const roomSel  = document.getElementById('roomId');
  const inEl     = document.getElementById('checkIn');
  const outEl    = document.getElementById('checkOut');

  const sRoom   = document.getElementById('sRoom');
  const sPrice  = document.getElementById('sPrice');
  const sNights = document.getElementById('sNights');
  const sTotal  = document.getElementById('sTotal');

  const nightsHidden = document.getElementById('nights');
  const roomTotalHidden = document.getElementById('roomTotal');

  function daysBetween(a, b){
    const d1 = new Date(a + 'T00:00:00');
    const d2 = new Date(b + 'T00:00:00');
    const ms = d2 - d1;
    return Math.floor(ms / (1000*60*60*24));
  }

  function fmtMoney(v){
    return 'Rs. ' + (isNaN(v) ? 0 : v).toFixed(2);
  }

  function updateSummary(){
    const opt = roomSel.options[roomSel.selectedIndex];
    const price = opt ? parseFloat(opt.getAttribute('data-price') || '0') : 0;

    const ci = inEl.value;
    const co = outEl.value;
    let nights = 0;

    if (ci && co) nights = daysBetween(ci, co);
    if (nights < 0) nights = 0;

    const total = price * nights;

    if (opt && roomSel.value) {
      const number = opt.getAttribute('data-number') || '';
      const type = opt.getAttribute('data-type') || '';
      const cap = opt.getAttribute('data-capacity') || '';
      sRoom.textContent = `Room ${number} (${type}) • Cap ${cap}`;
      sPrice.textContent = fmtMoney(price) + ' / night';
    } else {
      sRoom.textContent = '—';
      sPrice.textContent = '—';
    }

    sNights.textContent = String(nights);
    sTotal.textContent  = fmtMoney(total);

    nightsHidden.value = String(Math.max(nights, 1));
    roomTotalHidden.value = String(isNaN(total) ? 0 : total.toFixed(2));
  }

  roomSel.addEventListener('change', updateSummary);
  inEl.addEventListener('change', updateSummary);
  outEl.addEventListener('change', updateSummary);

  // Initialize
  updateSummary();
</script>

</body>
</html>