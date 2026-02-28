<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>

  <div class="auth-card">
    <h2 class="auth-title">User Login</h2>
    <p class="auth-subtitle">Login to Ocean View Resort system</p>

    <% String err = (String) request.getAttribute("error"); %>
    <% if (err != null) { %>
      <div class="msg error"><%= err %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">

      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" required>
      </div>

      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" required>
      </div>

      <button class="btn" type="submit">Login</button>

    </form>

    <div class="auth-footer">
      Don't have an account?
      <a href="<%= request.getContextPath() %>/auth/register.jsp">Register</a>
    </div>
  </div>

</body>
</html>