package com.admission.servlet;

import com.admission.dao.PaymentDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/payments")
public class AdminPaymentServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("payments", paymentDAO.getAllPayments());
            req.setAttribute("totalRevenue", paymentDAO.getTotalRevenue());
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/admin/payments.jsp").forward(req, resp);
    }
}