<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

  <div class="auth-card">
    <h2 class="auth-title">Customer Registration</h2>
    <p class="auth-subtitle">Create your customer account</p>

    <% String err = (String) request.getAttribute("error"); %>
    <% String ok  = (String) request.getAttribute("success"); %>

    <% if (err != null) { %>
      <div class="msg error"><%= err %></div>
    <% } %>

    <% if (ok != null) { %>
      <div class="msg success"><%= ok %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/register" method="post">

      <div class="form-group">
        <label>Full Name</label>
        <input type="text" name="full_name" required>
      </div>

      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" required>
      </div>

      <div class="form-group">
        <label>Phone</label>
        <input type="text" name="phone">
      </div>

      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" required>
      </div>

      <div class="form-group">
        <label>Confirm Password</label>
        <input type="password" name="confirm_password" required>
      </div>

      <button class="btn" type="submit">Register</button>

    </form>

    <div class="auth-footer">
      Already have an account?
      <a href="<%= request.getContextPath() %>/auth/login.jsp">Login</a>
    </div>
  </div>

</body>
</html>