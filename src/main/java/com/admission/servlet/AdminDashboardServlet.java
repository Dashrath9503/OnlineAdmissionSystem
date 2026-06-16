package com.admission.servlet;

import com.admission.dao.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("totalStudents", studentDAO.getTotalStudents());
            req.setAttribute("totalApps", appDAO.countByStatus(null));
            req.setAttribute("pendingApps", appDAO.countByStatus("PENDING"));
            req.setAttribute("approvedApps", appDAO.countByStatus("APPROVED"));
            req.setAttribute("rejectedApps", appDAO.countByStatus("REJECTED"));
            req.setAttribute("underReviewApps", appDAO.countByStatus("UNDER_REVIEW"));
            req.setAttribute("totalRevenue", paymentDAO.getTotalRevenue());
            req.setAttribute("recentApplications", appDAO.getAllApplications());
            req.setAttribute("courses", courseDAO.getAllCourses());
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
