<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ocean View Resort</title>

<!-- Link your main CSS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <h1>Ocean View Resort</h1>

    <div>
        Welcome,
        <%= (session.getAttribute("full_name") != null
            ? session.getAttribute("full_name")
            : "Guest") %>
        <a href="<%=request.getContextPath()%>/staff/dashboard">Home</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

</body>
</html>