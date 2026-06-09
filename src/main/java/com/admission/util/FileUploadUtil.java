package com.admission.util;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class FileUploadUtil {

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_EXTENSIONS = {".pdf", ".jpg", ".jpeg", ".png"};

    public static Map<String, String> uploadDocuments(HttpServletRequest request, String uploadPath) throws Exception {
        Map<String, String> uploadedFiles = new HashMap<>();
        Map<String, String> formFields = new HashMap<>();

        // Create upload directory
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(1024 * 1024);
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);

        List<FileItem> items = upload.parseRequest(request);
        for (FileItem item : items) {
            if (item.isFormField()) {
                formFields.put(item.getFieldName(), item.getString("UTF-8"));
            } else {
                if (item.getName() != null && !item.getName().isEmpty()) {
                    String originalName = item.getName();
                    String ext = originalName.substring(originalName.lastIndexOf(".")).toLowerCase();

                    if (!isAllowedExtension(ext)) {
                        throw new Exception("File type not allowed: " + ext);
                    }

                    String uniqueName = UUID.randomUUID().toString() + ext;
                    File destFile = new File(uploadPath + File.separator + uniqueName);
                    item.write(destFile);
                    uploadedFiles.put(item.getFieldName(), uniqueName);
                }
            }
        }
        uploadedFiles.putAll(formFields);
        return uploadedFiles;
    }

    private static boolean isAllowedExtension(String ext) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(ext)) return true;
        }
        return false;
    }

    public static String generateApplicationNumber() {
        long timestamp = System.currentTimeMillis();
        return "APP" + timestamp;
    }
}
