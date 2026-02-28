<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reception Dashboard</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>

<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">

    <div class="card">
        <h2>Reception Staff Dashboard</h2>
        <p>Manage reservation operations from this panel.</p>
    </div>

    <div class="card">
        <h3>Staff Actions</h3>
        <ul>
            <li>
                <a href="<%= request.getContextPath() %>/staff/view-reservations.jsp">
                    View Reservation Requests
                </a>
            </li>

            <li>
                <a href="<%= request.getContextPath() %>/staff/add-reservation.jsp">
                    Add New Reservation
                </a>
            </li>

            <li>
                <a href="<%= request.getContextPath() %>/staff/reservation-details.jsp">
                    Display Reservation Details
                </a>
            </li>

            <li>
                <a href="<%= request.getContextPath() %>/staff/help.jsp">
                    Help Section
                </a>
            </li>
        </ul>
    </div>

</div>




</body>
<jsp:include page="/includes/footer.jsp" />
</html>