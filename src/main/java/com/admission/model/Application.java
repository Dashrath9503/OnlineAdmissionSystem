package com.admission.model;

import java.sql.Timestamp;

public class Application {
    private int id;
    private int studentId;
    private int courseId;
    private String applicationNumber;
    private double tenthPercent;
    private double twelfthPercent;
    private double graduationPercent;
    private String status;
    private String remarks;
    private Timestamp appliedAt;
    private Timestamp updatedAt;

    // Joined fields for display
    private String studentName;
    private String studentEmail;
    private String studentPhone;
    private String courseName;
    private String courseCode;
    private double courseFees;

    public Application() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getApplicationNumber() { return applicationNumber; }
    public void setApplicationNumber(String applicationNumber) { this.applicationNumber = applicationNumber; }

    public double getTenthPercent() { return tenthPercent; }
    public void setTenthPercent(double tenthPercent) { this.tenthPercent = tenthPercent; }

    public double getTwelfthPercent() { return twelfthPercent; }
    public void setTwelfthPercent(double twelfthPercent) { this.twelfthPercent = twelfthPercent; }

    public double getGraduationPercent() { return graduationPercent; }
    public void setGraduationPercent(double graduationPercent) { this.graduationPercent = graduationPercent; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

    public double getCourseFees() { return courseFees; }
    public void setCourseFees(double courseFees) { this.courseFees = courseFees; }
}
