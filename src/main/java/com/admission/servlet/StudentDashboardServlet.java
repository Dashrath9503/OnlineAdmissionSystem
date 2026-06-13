package com.admission.servlet;

import com.admission.dao.ApplicationDAO;
import com.admission.dao.PaymentDAO;
import com.admission.model.Student;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Student student = (Student) session.getAttribute("student");

        try {
            int studentId = student.getId();
            req.setAttribute("applications", appDAO.getApplicationsByStudent(studentId));
            req.setAttribute("payments", paymentDAO.getPaymentsByStudent(studentId));
            req.setAttribute("totalApps", appDAO.getApplicationsByStudent(studentId).size());
            int pending = 0, approved = 0, rejected = 0;
            for (var app : appDAO.getApplicationsByStudent(studentId)) {
                if ("PENDING".equals(app.getStatus()) || "UNDER_REVIEW".equals(app.getStatus())) pending++;
                else if ("APPROVED".equals(app.getStatus())) approved++;
                else if ("REJECTED".equals(app.getStatus())) rejected++;
            }
            req.setAttribute("pendingCount", pending);
            req.setAttribute("approvedCount", approved);
            req.setAttribute("rejectedCount", rejected);
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
    }
}
