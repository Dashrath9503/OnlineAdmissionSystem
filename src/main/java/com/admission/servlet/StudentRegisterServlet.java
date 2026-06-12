package com.admission.servlet;

import java.io.IOException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.admission.dao.StudentDAO;
import com.admission.model.Student;
import com.admission.util.EmailUtil;

@WebServlet("/register")
public class StudentRegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String dobStr = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String pincode = req.getParameter("pincode");

        try {
            if (studentDAO.isEmailExists(email)) {
                req.setAttribute("error", "Email already registered! Please login.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            Student student = new Student();
            student.setFullName(fullName);
            student.setEmail(email);
            student.setPassword(password);
            student.setPhone(phone);
            student.setDob(Date.valueOf(dobStr));
            student.setGender(gender);
            student.setAddress(address);
            student.setCity(city);
            student.setState(state);
            student.setPincode(pincode);

            if (studentDAO.registerStudent(student)) {
                // Send welcome email (async-like)
                new Thread(() -> {
                    String subject = "Welcome to Online Admission Portal";
                    String msg = "<html><body><h2>Welcome, " + fullName + "!</h2>"
                        + "<p>Your registration was successful. You can now login and apply for courses.</p>"
                        + "<p>Email: " + email + "</p></body></html>";
                    EmailUtil.sendEmail(email, subject, msg);
                }).start();

                req.getSession().setAttribute("successMsg", "Registration successful! Please login.");
                resp.sendRedirect(req.getContextPath() + "/login");
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
