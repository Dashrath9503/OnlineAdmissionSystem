package com.admission.servlet;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.admission.dao.ApplicationDAO;
import com.admission.dao.PaymentDAO;
import com.admission.model.Application;
import com.admission.model.Payment;
import com.admission.model.Student;
import com.admission.util.EmailUtil;

@WebServlet("/student/payment")
public class PaymentServlet extends HttpServlet {

    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String appIdStr = req.getParameter("appId");
        if (appIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }
        try {
            int appId = Integer.parseInt(appIdStr);
            Application app = appDAO.getApplicationById(appId);
            boolean alreadyPaid = paymentDAO.hasAlreadyPaid(appId);
            req.setAttribute("application", app);
            req.setAttribute("alreadyPaid", alreadyPaid);
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/student/payment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Student student = (Student) session.getAttribute("student");

        int appId = Integer.parseInt(req.getParameter("appId"));
        double amount = Double.parseDouble(req.getParameter("amount"));
        String paymentMode = req.getParameter("paymentMode");

        try {
            // Check duplicate payment
            if (paymentDAO.hasAlreadyPaid(appId)) {
                session.setAttribute("errorMsg", "Fee already paid for this application!");
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
                return;
            }

            // Generate mock transaction ID
            String txnId = "TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            Payment payment = new Payment();
            payment.setApplicationId(appId);
            payment.setAmount(amount);
            payment.setPaymentMode(paymentMode);
            payment.setTransactionId(txnId);
            payment.setPaymentStatus("SUCCESS");

            if (paymentDAO.savePayment(payment)) {
                Application app = appDAO.getApplicationById(appId);
                // Email receipt
                new Thread(() -> {
                    String msg = "<html><body style='font-family:Arial;'>"
                        + "<div style='max-width:600px;margin:auto;border:1px solid #ddd;border-radius:8px;overflow:hidden;'>"
                        + "<div style='background:#28a745;padding:20px;text-align:center;'>"
                        + "<h2 style='color:white;'>Payment Successful ✓</h2></div>"
                        + "<div style='padding:30px;'>"
                        + "<p>Dear <strong>" + student.getFullName() + "</strong>,</p>"
                        + "<p>Your fee payment was received successfully.</p>"
                        + "<table style='width:100%;border-collapse:collapse;'>"
                        + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'>Transaction ID</td>"
                        + "<td style='padding:8px;border:1px solid #ddd;'><strong>" + txnId + "</strong></td></tr>"
                        + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'>Amount Paid</td>"
                        + "<td style='padding:8px;border:1px solid #ddd;'>₹" + amount + "</td></tr>"
                        + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'>Course</td>"
                        + "<td style='padding:8px;border:1px solid #ddd;'>" + app.getCourseName() + "</td></tr>"
                        + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'>Payment Mode</td>"
                        + "<td style='padding:8px;border:1px solid #ddd;'>" + paymentMode + "</td></tr>"
                        + "</table></div></div></body></html>";
                    EmailUtil.sendEmail(student.getEmail(), "Payment Receipt - " + txnId, msg);
                }).start();

                session.setAttribute("successMsg", "Payment of ₹" + amount + " successful! Transaction ID: " + txnId);
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Payment failed: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/student/payment?appId=" + appId);
        }
    }
}
