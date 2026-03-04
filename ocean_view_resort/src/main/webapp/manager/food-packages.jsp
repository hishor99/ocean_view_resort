<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.FoodPackage" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Food Packages</title>

<style>

body{
  font-family:Arial, sans-serif;
  background:#f6f7fb;
  margin:0;
}

.container{
  max-width:1100px;
  margin:24px auto;
  padding:0 16px;
}

.card{
  background:#fff;
  border:1px solid #eee;
  border-radius:14px;
  padding:18px;
  margin-bottom:18px;
  box-shadow:0 6px 18px rgba(0,0,0,.04);
}

h2,h3{
  margin-top:0;
}

.form-grid{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:14px;
}

.field{
  display:flex;
  flex-direction:column;
  gap:6px;
}

input,select{
  padding:10px;
  border-radius:10px;
  border:1px solid #ddd;
}

textarea{
  padding:10px;
  border-radius:10px;
  border:1px solid #ddd;
}

.btn{
  padding:10px 16px;
  border-radius:10px;
  border:none;
  cursor:pointer;
  font-weight:600;
}

.btn.primary{
  background:#111;
  color:#fff;
}

.btn.primary:hover{
  background:#000;
}

.btn.secondary{
  background:#f1f1f1;
  color:#111;
  text-decoration:none;
  padding:10px 14px;
  border-radius:10px;
}

.btn.secondary:hover{
  background:#e6e6e6;
}

table{
  width:100%;
  border-collapse:collapse;
}

th,td{
  padding:12px;
  border-bottom:1px solid #eee;
  text-align:left;
}

th{
  background:#fafafa;
}

.edit-link{
  padding:6px 10px;
  border-radius:8px;
  background:#1677ff;
  color:#fff;
  text-decoration:none;
  font-size:13px;
}

.edit-link:hover{
  background:#125fd1;
}

</style>

</head>
<body>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">

<div class="card">
<h2>Manage Food Packages</h2>
<p>Create and update food packages offered to resort guests.</p>
</div>

<div class="actions">
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/manager/dashboard">← Back to Dashboard</a>
      </div>
<%
FoodPackage editFood = (FoodPackage) request.getAttribute("editFood");
boolean isEdit = (editFood != null);
%>

<div class="card">

<h3><%= isEdit ? "Edit Food Package" : "Add Food Package" %></h3>

<form method="post" action="<%= request.getContextPath() %>/manager/food-packages">

<input type="hidden" name="food_id"
value="<%= isEdit ? editFood.getFoodId() : "" %>">

<div class="form-grid">

<div class="field">
<label>Package Name</label>
<input type="text" name="name" required
value="<%= isEdit ? editFood.getName() : "" %>">
</div>

<div class="field">
<label>Price Per Day</label>
<input type="number" name="price_per_day" step="0.01" min="0" required
value="<%= isEdit ? editFood.getPricePerDay() : 0 %>">
</div>

<div class="field">
<label>Pricing Type</label>
<select name="pricing_type">
<option value="PER_PERSON_PER_DAY"
<%= (isEdit && "PER_PERSON_PER_DAY".equals(editFood.getPricingType())) ? "selected" : "" %>>
Per Person / Day
</option>

<option value="PER_ROOM_PER_DAY"
<%= (isEdit && "PER_ROOM_PER_DAY".equals(editFood.getPricingType())) ? "selected" : "" %>>
Per Room / Day
</option>
</select>
</div>

<div class="field">
<label>Active</label>
<select name="is_active">
<option value="1" <%= (!isEdit || editFood.isActive()) ? "selected" : "" %>>Yes</option>
<option value="0" <%= (isEdit && !editFood.isActive()) ? "selected" : "" %>>No</option>
</select>
</div>

<div class="field" style="grid-column:1 / span 2;">
<label>Description</label>
<textarea name="description" rows="3"><%= isEdit ? (editFood.getDescription()==null ? "" : editFood.getDescription()) : "" %></textarea>
</div>

</div>

<div style="margin-top:16px; display:flex; gap:10px;">

<button class="btn primary" type="submit">
<%= isEdit ? "Update Package" : "Add Package" %>
</button>

<% if(isEdit){ %>
<a class="btn secondary"
href="<%= request.getContextPath() %>/manager/food-packages">
Cancel
</a>
<% } %>

</div>

</form>

</div>

<div class="card">

<h3>Food Packages List</h3>

<table>

<tr>
<th>Name</th>
<th>Price / Day</th>
<th>Pricing Type</th>
<th>Status</th>
<th>Edit</th>
</tr>

<%
List<FoodPackage> foods = (List<FoodPackage>) request.getAttribute("foods");

if (foods != null) {
for (FoodPackage f : foods) {
%>

<tr>

<td><%= f.getName() %></td>
<td>$ <%= f.getPricePerDay() %></td>
<td><%= f.getPricingType() %></td>
<td><%= f.isActive() ? "Active" : "Inactive" %></td>

<td>
<a class="edit-link"
href="<%= request.getContextPath() %>/manager/food-packages?edit=<%= f.getFoodId() %>">
Edit
</a>
</td>

</tr>

<%
}
}
%>

</table>

</div>

</div>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>