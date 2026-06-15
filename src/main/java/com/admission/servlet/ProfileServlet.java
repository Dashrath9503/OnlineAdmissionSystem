package com.admission.servlet;

import com.admission.dao.StudentDAO;
import com.admission.model.Student;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/student/profile")
public class ProfileServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Student student = (Student) session.getAttribute("student");
        req.setAttribute("student", student);
        req.getRequestDispatcher("/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Student student = (Student) session.getAttribute("student");

        student.setFullName(req.getParameter("fullName"));
        student.setPhone(req.getParameter("phone"));
        student.setGender(req.getParameter("gender"));
        student.setAddress(req.getParameter("address"));
        student.setCity(req.getParameter("city"));
        student.setState(req.getParameter("state"));
        student.setPincode(req.getParameter("pincode"));

        String dobStr = req.getParameter("dob");
        if (dobStr != null && !dobStr.isEmpty()) {
            student.setDob(Date.valueOf(dobStr));
        }

        try {
            if (studentDAO.updateStudent(student)) {
                session.setAttribute("student", student);
                session.setAttribute("successMsg", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMsg", "Update failed. Try again!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/student/profile");
    }
}