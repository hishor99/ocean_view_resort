package controller.manager;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import dao.StaffDAO;

@WebServlet("/manager/delete-staff")
public class DeleteStaffServlet extends HttpServlet {

    StaffDAO dao=new StaffDAO();

    protected void doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException{

        try{

            int id=Integer.parseInt(request.getParameter("id"));

            dao.deleteStaff(id);

            response.sendRedirect(request.getContextPath()+"/manager/manage-staff");

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}