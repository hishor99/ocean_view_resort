<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Staff</title>
  <style>
    body{font-family:Arial, sans-serif;background:#f6f7fb;margin:0}
    .container{max-width:980px;margin:24px auto;padding:0 16px}
    .card{background:#fff;border:1px solid #e9e9e9;border-radius:12px;padding:16px;margin-bottom:16px}
    .row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
    .field{display:flex;flex-direction:column;gap:6px}
    input{padding:10px;border:1px solid #ddd;border-radius:10px}
    button{padding:10px 14px;border:0;border-radius:10px;cursor:pointer}
    .btn{background:#1677ff;color:#fff}
    .btn-danger{background:#ff4d4f;color:#fff;text-decoration:none;padding:8px 10px;border-radius:10px;display:inline-block}
    .btn-ghost{
      display:inline-flex;align-items:center;gap:8px;
      padding:10px 14px;border-radius:10px;border:1px solid #ddd;
      background:#fff;color:#111;text-decoration:none;cursor:pointer;
    }
    .btn-ghost:hover{background:#f1f1f1;}
    table{width:100%;border-collapse:collapse}
    th,td{padding:10px;border-bottom:1px solid #eee;text-align:left}
    th{background:#fafafa}
    .alert{padding:10px;border-radius:10px;margin-bottom:12px}
    .success{border:1px solid #b7eb8f;background:#f6ffed}
    .error{border:1px solid #ffa39e;background:#fff1f0}
    .muted{color:#777}
  </style>
</head>
<body>

<div class="container">

  <div class="card">
    <h2 style="margin:0 0 10px 0;">Manage Reception Staff</h2>

    <div style="display:flex;gap:10px;flex-wrap:wrap;margin:10px 0 12px 0;">
      <a class="btn-ghost" href="<%=request.getContextPath()%>/manager/dashboard">← Back to Dashboard</a>
   
    </div>

    <%
      // success message (from session, after redirect)
      String success = (String) session.getAttribute("success");
      if (success != null) {
    %>
      <div class="alert success"><%= success %></div>
    <%
        session.removeAttribute("success");
      }

      // error message (from request)
      Object errObj = request.getAttribute("error");
      if (errObj != null) {
    %>
      <div class="alert error"><%= errObj %></div>
    <%
      }
    %>

    <p class="muted" style="margin:0;">Add new reception staff accounts and manage existing ones.</p>
  </div>

  <div class="card">
    <h3 style="margin-top:0;">Add Staff</h3>

    <form method="post" action="<%=request.getContextPath()%>/manager/manage-staff">
      <div class="row">
        <div class="field">
          <label>Name</label>
          <input type="text" name="name" required>
        </div>

        <div class="field">
          <label>Email</label>
          <input type="email" name="email" required>
        </div>

        <div class="field">
          <label>Phone</label>
          <input type="text" name="phone">
        </div>

        <div class="field">
          <label>Password</label>
          <input type="password" name="password" required>
        </div>
      </div>

      <div style="margin-top:12px;">
        <button class="btn" type="submit">Add Staff</button>
      </div>
    </form>
  </div>

  <div class="card">
    <h3 style="margin-top:0;">Staff List</h3>

    <%
      List<Map<String,Object>> list = (List<Map<String,Object>>) request.getAttribute("staffList");
      if (list == null || list.isEmpty()) {
    %>
      <p class="muted">No staff found.</p>
    <%
      } else {
    %>

    <table>
      <tr>
        <th>Staff ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Status</th>
        <th>Action</th>
      </tr>

      <%
        for (Map<String,Object> s : list) {

          // ✅ Safe name fallback (works even if your column name is different)
          Object staffName = s.get("name");
          if (staffName == null) staffName = s.get("full_name");
          if (staffName == null) staffName = s.get("staff_name");
          if (staffName == null) staffName = "-";

          Object staffIdObj = s.get("staff_id"); // must exist if your DAO selects from staff table
      %>
      <tr>
        <td><%= staffIdObj %></td>
        <td><%= staffName %></td>
        <td><%= s.get("email") %></td>
        <td><%= s.get("phone") == null ? "-" : s.get("phone") %></td>
        <td><%= s.get("status") %></td>
        <td>
          <a class="btn-danger"
             href="<%=request.getContextPath()%>/manager/delete-staff?id=<%= staffIdObj %>"
             onclick="return confirm('Are you sure you want to delete this staff member?');">
             Delete
          </a>
        </td>
      </tr>
      <%
        }
      %>
    </table>

    <%
      }
    %>
  </div>

</div>

</body>
</html>