package controller.manager;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

import dao.StaffDAO;

@WebServlet("/manager/manage-staff")
public class ManageStaffServlet extends HttpServlet {

    StaffDAO dao=new StaffDAO();

    protected void doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException{

        try{

            List<Map<String,Object>> staff=dao.getAllStaff();

            request.setAttribute("staffList",staff);

            request.getRequestDispatcher("/manager/manage-staff.jsp").forward(request,response);

        }catch(Exception e){
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException{

        try{

            String name=request.getParameter("name");
            String email=request.getParameter("email");
            String phone=request.getParameter("phone");
            String password=request.getParameter("password");

            dao.addStaff(name,email,phone,password);

            response.sendRedirect(request.getContextPath()+"/manager/manage-staff");

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}