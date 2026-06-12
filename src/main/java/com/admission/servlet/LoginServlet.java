package com.admission.servlet;

import com.admission.dao.AdminDAO;
import com.admission.dao.StudentDAO;
import com.admission.model.Student;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role"); // "student" or "admin"

        try {
            if ("admin".equals(role)) {
                if (adminDAO.loginAdmin(email, password)) {
                    HttpSession session = req.getSession();
                    session.setAttribute("adminLoggedIn", true);
                    session.setAttribute("adminUsername", email);
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else {
                    req.setAttribute("error", "Invalid admin credentials!");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                }
            } else {
                Student student = studentDAO.loginStudent(email, password);
                if (student != null) {
                    HttpSession session = req.getSession();
                    session.setAttribute("student", student);
                    session.setAttribute("studentId", student.getId());
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard");
                } else {
                    req.setAttribute("error", "Invalid email or password!");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Login error: " + e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
