<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Dashboard</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="container">

    <div class="card">
        <h2 class="dashboard-title">Customer Dashboard</h2>
        <p>Welcome to your customer panel.</p>
    </div>

    <div class="card">
        <h3>Available Actions</h3>
        <ul>
            <li>View Rooms</li>
            <li>Request Quotation</li>
            <li>Make Reservation</li>
        </ul>
    </div>

</div>

<div class="footer">
    © 2026 Ocean View Resort. All rights reserved.
</div>

</body>
</html>