<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*" %>
<%@ page import="model.FoodPackage" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container">
  <div class="card">
    <h2>Manage Food Packages</h2>
  </div>

  <%
    FoodPackage editFood = (FoodPackage) request.getAttribute("editFood");
    boolean isEdit = (editFood != null);
  %>

  <div class="card">
    <h3><%= isEdit ? "Edit Food Package" : "Add Food Package" %></h3>

    <form method="post" action="<%= request.getContextPath() %>/manager/food-packages">
      <input type="hidden" name="food_id" value="<%= isEdit ? editFood.getFoodId() : "" %>">

      <label>Name</label><br>
      <input type="text" name="name" required value="<%= isEdit ? editFood.getName() : "" %>"><br><br>

      <label>Price per day</label><br>
      <input type="number" name="price_per_day" step="0.01" min="0" required
             value="<%= isEdit ? editFood.getPricePerDay() : 0 %>"><br><br>

      <label>Pricing type</label><br>
      <select name="pricing_type">
        <option value="PER_PERSON_PER_DAY" <%= (isEdit && "PER_PERSON_PER_DAY".equals(editFood.getPricingType())) ? "selected" : "" %>>
          PER_PERSON_PER_DAY
        </option>
        <option value="PER_ROOM_PER_DAY" <%= (isEdit && "PER_ROOM_PER_DAY".equals(editFood.getPricingType())) ? "selected" : "" %>>
          PER_ROOM_PER_DAY
        </option>
      </select><br><br>

      <label>Active</label><br>
      <select name="is_active">
        <option value="1" <%= (!isEdit || editFood.isActive()) ? "selected" : "" %>>Yes</option>
        <option value="0" <%= (isEdit && !editFood.isActive()) ? "selected" : "" %>>No</option>
      </select><br><br>

      <label>Description</label><br>
      <input type="text" name="description"
             value="<%= isEdit ? (editFood.getDescription()==null ? "" : editFood.getDescription()) : "" %>"><br><br>

      <button class="btn" type="submit"><%= isEdit ? "Update" : "Add" %></button>
      <% if (isEdit) { %>
        <a style="margin-left:10px;" href="<%= request.getContextPath() %>/manager/food-packages">Cancel</a>
      <% } %>
    </form>
  </div>

  <div class="card">
    <h3>Food Packages List</h3>
    <table border="1" cellpadding="10" cellspacing="0" style="width:100%; border-collapse:collapse;">
      <tr>
        <th>Name</th>
        <th>Price/Day</th>
        <th>Pricing Type</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>

      <%
        List<FoodPackage> foods = (List<FoodPackage>) request.getAttribute("foods");
        if (foods != null) {
          for (FoodPackage f : foods) {
      %>
      <tr>
        <td><%= f.getName() %></td>
        <td><%= f.getPricePerDay() %></td>
        <td><%= f.getPricingType() %></td>
        <td><%= f.isActive() ? "Yes" : "No" %></td>
        <td>
          <a href="<%= request.getContextPath() %>/manager/food-packages?edit=<%= f.getFoodId() %>">Edit</a>
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