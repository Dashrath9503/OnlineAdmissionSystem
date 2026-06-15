package com.admission.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;

@WebServlet("/uploads/*")
public class DocumentViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String filename = pathInfo.substring(1);
        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        File file = new File(uploadPath + File.separator + filename);

        if (!file.exists()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND,
                "Document not found!");
            return;
        }

        String mimeType = Files.probeContentType(file.toPath());
        resp.setContentType(mimeType != null ? 
            mimeType : "application/octet-stream");
        resp.setContentLength((int) file.length());
        resp.setHeader("Content-Disposition", 
            "inline; filename=\"" + filename + "\"");

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
}