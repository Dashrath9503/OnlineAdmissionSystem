package com.admission.servlet;

import com.admission.dao.CourseDAO;
import com.admission.model.Course;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/courses")
public class AdminCourseServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("courses", courseDAO.getAllCourses());
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/admin/courses.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                Course course = new Course();
                course.setCourseName(req.getParameter("courseName"));
                course.setCourseCode(req.getParameter("courseCode"));
                course.setDuration(req.getParameter("duration"));
                course.setTotalSeats(Integer.parseInt(req.getParameter("totalSeats")));
                course.setFees(Double.parseDouble(req.getParameter("fees")));
                course.setDescription(req.getParameter("description"));
                courseDAO.addCourse(course);
                req.getSession().setAttribute("successMsg", "Course added successfully!");

            } else if ("update".equals(action)) {
                Course course = new Course();
                course.setId(Integer.parseInt(req.getParameter("courseId")));
                course.setCourseName(req.getParameter("courseName"));
                course.setDuration(req.getParameter("duration"));
                course.setTotalSeats(Integer.parseInt(req.getParameter("totalSeats")));
                course.setFees(Double.parseDouble(req.getParameter("fees")));
                course.setDescription(req.getParameter("description"));
                course.setActive("on".equals(req.getParameter("isActive")));
                courseDAO.updateCourse(course);
                req.getSession().setAttribute("successMsg", "Course updated successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", "Error: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/courses");
    }
}