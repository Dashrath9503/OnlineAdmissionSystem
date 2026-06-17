package com.admission.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.admission.dao.ApplicationDAO;
import com.admission.dao.DocumentDAO;
import com.admission.model.Application;
import com.admission.util.EmailUtil;

@WebServlet("/admin/applications")
public class AdminApplicationServlet extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final DocumentDAO docDAO = new DocumentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String filter = req.getParameter("status");
        String appIdStr = req.getParameter("view");

        try {
            if (appIdStr != null) {
                // View single application detail
                int appId = Integer.parseInt(appIdStr);
                Application app = appDAO.getApplicationById(appId);
                req.setAttribute("application", app);
                req.setAttribute("documents", docDAO.getDocumentsByApplication(appId));
                req.getRequestDispatcher("/admin/application-detail.jsp").forward(req, resp);
                return;
            }

            if (filter != null && !filter.isEmpty()) {
                req.setAttribute("applications", appDAO.getApplicationsByStatus(filter));
                req.setAttribute("activeFilter", filter);
            } else {
                req.setAttribute("applications", appDAO.getAllApplications());
                req.setAttribute("activeFilter", "ALL");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/admin/applications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int appId = Integer.parseInt(req.getParameter("appId"));
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");

        try {
            appDAO.updateApplicationStatus(appId, status, remarks);
            Application app = appDAO.getApplicationById(appId);

            // Send email notification
            new Thread(() -> {
                String emailBody = EmailUtil.getStatusUpdateTemplate(
                    app.getStudentName(), app.getApplicationNumber(),
                    app.getCourseName(), status, remarks);
                EmailUtil.sendEmail(app.getStudentEmail(),
                    "Application Status Update - " + app.getApplicationNumber(), emailBody);
            }).start();

            HttpSession session = req.getSession();
            session.setAttribute("successMsg", "Application status updated to " + status);
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/admin/applications");
    }
}
