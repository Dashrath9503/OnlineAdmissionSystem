package com.admission.servlet;

import com.admission.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/reset-admin")
public class AdminResetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String newPassword = req.getParameter("pass");
        if (newPassword == null || newPassword.isEmpty()) {
            resp.getWriter().println("Pass parameter missing! " +
                "Use: /reset-admin?pass=yourpassword");
            return;
        }

        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt(10));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE admins SET password=? WHERE username='admin'")) {
            ps.setString(1, hashed);
            int rows = ps.executeUpdate();
            resp.getWriter().println(rows > 0 ?
                "✅ Password reset successful! New password: " + newPassword :
                "❌ Admin not found!");
        } catch (Exception e) {
            resp.getWriter().println("Error: " + e.getMessage());
        }
    }
}