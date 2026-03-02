<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Help - Ocean View Resort</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

    <style>
        body {
            background: #f5f7fa;
        }

        .help-container {
            max-width: 900px;
            margin: 30px auto;
        }

        .help-card {
            background: #fff;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .help-card h3 {
            margin-bottom: 10px;
            color: #0b3d91;
        }

        .help-card p {
            color: #555;
            line-height: 1.6;
        }

        .faq-item {
            margin-bottom: 15px;
        }

        .faq-item strong {
            color: #222;
        }

        .btn-back {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 16px;
            background: #0b3d91;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
        }

        .btn-back:hover {
            background: #062c6e;
        }
    </style>
</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<div class="help-container">

    <div class="help-card">
        <h2>Staff Help & Support</h2>
        <p>
            This page provides guidance on how to use the Ocean View Resort
            Reservation Management System effectively.
        </p>
    </div>

    <div class="help-card">
        <h3>📌 Dashboard</h3>
        <p>
            The dashboard gives an overview of reservations and system activities.
            You can monitor pending confirmations and manage bookings from here.
        </p>
    </div>

    <div class="help-card">
        <h3>📅 View Reservations</h3>
        <p>
            Use this section to review customer reservations.
            You can confirm, cancel, or update reservation status.
        </p>
    </div>

    <div class="help-card">
        <h3>➕ Add Reservation</h3>
        <p>
            Staff can manually create reservations for walk-in customers.
            Fill in customer details, select room, and confirm booking.
        </p>
    </div>

    <div class="help-card">
        <h3>❓ Frequently Asked Questions</h3>

        <div class="faq-item">
            <strong>Q: How do I confirm a reservation?</strong>
            <p>A: Go to "View Reservations" and click the Confirm button.</p>
        </div>

        <div class="faq-item">
            <strong>Q: How do I print an invoice?</strong>
            <p>A: Open reservation details and click the Print button.</p>
        </div>

        <div class="faq-item">
            <strong>Q: What if a room is not available?</strong>
            <p>A: Inform the customer and suggest alternative room options.</p>
        </div>
    </div>

    <a href="<%=request.getContextPath()%>/staff/dashboard" class="btn-back">
        ← Back to Dashboard
    </a>

</div>

</body>
</html>