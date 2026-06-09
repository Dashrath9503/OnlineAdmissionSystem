package com.admission.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL = "deshmukh3615@gmail.com"; // Change this
    private static final String FROM_PASSWORD = "xrdwljfgwhjydatj";  // Use Gmail App Password

    public static boolean sendEmail(String toEmail, String subject, String messageBody) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);

            // HTML Email
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(messageBody, "text/html; charset=UTF-8");

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(htmlPart);
            message.setContent(multipart);

            Transport.send(message);

            // Log to DB
            logEmail(toEmail, subject, messageBody, "SENT");
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            logEmail(toEmail, subject, messageBody, "FAILED");
            return false;
        }
    }

    private static void logEmail(String email, String subject, String message, String status) {
        String sql = "INSERT INTO email_logs (recipient_email, subject, message, status) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, subject);
            ps.setString(3, message);
            ps.setString(4, status);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Email Templates
    public static String getApplicationSubmittedTemplate(String studentName, String appNumber, String courseName) {
        return "<html><body style='font-family:Arial,sans-serif;'>"
            + "<div style='max-width:600px;margin:auto;border:1px solid #ddd;border-radius:8px;overflow:hidden;'>"
            + "<div style='background:#1a73e8;padding:20px;text-align:center;'>"
            + "<h2 style='color:white;margin:0;'>Admission Application Submitted</h2></div>"
            + "<div style='padding:30px;'>"
            + "<p>Dear <strong>" + studentName + "</strong>,</p>"
            + "<p>Your admission application has been submitted successfully.</p>"
            + "<table style='width:100%;border-collapse:collapse;'>"
            + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'><strong>Application No.</strong></td>"
            + "<td style='padding:8px;border:1px solid #ddd;'>" + appNumber + "</td></tr>"
            + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'><strong>Course</strong></td>"
            + "<td style='padding:8px;border:1px solid #ddd;'>" + courseName + "</td></tr>"
            + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'><strong>Status</strong></td>"
            + "<td style='padding:8px;border:1px solid #ddd;color:orange;'><strong>PENDING</strong></td></tr>"
            + "</table>"
            + "<p style='margin-top:20px;'>We will notify you once your application is reviewed.</p>"
            + "<p>Regards,<br/><strong>Admission Office</strong></p>"
            + "</div></div></body></html>";
    }

    public static String getStatusUpdateTemplate(String studentName, String appNumber, String courseName, String status, String remarks) {
        String statusColor = status.equals("APPROVED") ? "green" : "red";
        return "<html><body style='font-family:Arial,sans-serif;'>"
            + "<div style='max-width:600px;margin:auto;border:1px solid #ddd;border-radius:8px;overflow:hidden;'>"
            + "<div style='background:#1a73e8;padding:20px;text-align:center;'>"
            + "<h2 style='color:white;margin:0;'>Application Status Updated</h2></div>"
            + "<div style='padding:30px;'>"
            + "<p>Dear <strong>" + studentName + "</strong>,</p>"
            + "<p>Your admission application status has been updated.</p>"
            + "<table style='width:100%;border-collapse:collapse;'>"
            + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'><strong>Application No.</strong></td>"
            + "<td style='padding:8px;border:1px solid #ddd;'>" + appNumber + "</td></tr>"
            + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'><strong>Course</strong></td>"
            + "<td style='padding:8px;border:1px solid #ddd;'>" + courseName + "</td></tr>"
            + "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'><strong>Status</strong></td>"
            + "<td style='padding:8px;border:1px solid #ddd;color:" + statusColor + ";'><strong>" + status + "</strong></td></tr>"
            + (remarks != null && !remarks.isEmpty() ? 
               "<tr><td style='padding:8px;border:1px solid #ddd;background:#f5f5f5;'><strong>Remarks</strong></td>"
             + "<td style='padding:8px;border:1px solid #ddd;'>" + remarks + "</td></tr>" : "")
            + "</table>"
            + "<p style='margin-top:20px;'>For queries, contact the Admission Office.</p>"
            + "<p>Regards,<br/><strong>Admission Office</strong></p>"
            + "</div></div></body></html>";
    }
}
