package com.admission.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.admission.dao.ApplicationDAO;
import com.admission.dao.CourseDAO;
import com.admission.dao.DocumentDAO;
import com.admission.model.Application;
import com.admission.model.Document;
import com.admission.model.Student;
import com.admission.util.EmailUtil;
import com.admission.util.FileUploadUtil;

@WebServlet("/student/apply")
public class ApplyServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final DocumentDAO docDAO = new DocumentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("courses", courseDAO.getAllActiveCourses());
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/student/apply.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Student student = (Student) session.getAttribute("student");

        String uploadPath = getServletContext().getRealPath("/") + "uploads";

        try {
            Map<String, String> data = FileUploadUtil.uploadDocuments(req, uploadPath);

            int courseId = Integer.parseInt(data.get("courseId"));

            // Check duplicate application
            if (appDAO.hasAlreadyApplied(student.getId(), courseId)) {
                session.setAttribute("errorMsg", "You have already applied for this course!");
                resp.sendRedirect(req.getContextPath() + "/student/apply");
                return;
            }

            // Create Application
            Application app = new Application();
            app.setStudentId(student.getId());
            app.setCourseId(courseId);
            app.setApplicationNumber(FileUploadUtil.generateApplicationNumber());
            app.setTenthPercent(Double.parseDouble(data.getOrDefault("tenthPercent", "0")));
            app.setTwelfthPercent(Double.parseDouble(data.getOrDefault("twelfthPercent", "0")));
            app.setGraduationPercent(Double.parseDouble(data.getOrDefault("graduationPercent", "0")));

            int appId = appDAO.submitApplication(app);
            if (appId > 0) {
                // Save uploaded documents
                String[] docTypes = {"tenthMarksheet", "twelfthMarksheet", "graduationMarksheet", "photo", "idProof"};
                for (String docType : docTypes) {
                    if (data.containsKey(docType)) {
                        Document doc = new Document();
                        doc.setApplicationId(appId);
                        doc.setDocumentType(docType);
                        doc.setFileName(data.get(docType));
                        doc.setFilePath("uploads/" + data.get(docType));
                        docDAO.saveDocument(doc);
                    }
                }

                // Send confirmation email
                var course = courseDAO.getCourseById(courseId);
                new Thread(() -> {
                    String emailBody = EmailUtil.getApplicationSubmittedTemplate(
                        student.getFullName(), app.getApplicationNumber(), course.getCourseName());
                    EmailUtil.sendEmail(student.getEmail(), "Application Submitted - " + app.getApplicationNumber(), emailBody);
                }).start();

                session.setAttribute("successMsg", "Application submitted successfully! Application No: " + app.getApplicationNumber());
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            } else {
                session.setAttribute("errorMsg", "Failed to submit application. Please try again.");
                resp.sendRedirect(req.getContextPath() + "/student/apply");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/student/apply");
        }
    }
}
