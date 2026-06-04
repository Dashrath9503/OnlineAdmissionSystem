-- ============================================================
-- Online Admission System - Database Schema
-- Run this file in MySQL before starting the application
-- ============================================================

CREATE DATABASE IF NOT EXISTS admission_db;
USE admission_db;

-- Students / Users table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    dob DATE,
    gender ENUM('Male','Female','Other'),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses table
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    duration VARCHAR(50),
    total_seats INT DEFAULT 60,
    available_seats INT DEFAULT 60,
    fees DECIMAL(10,2),
    description TEXT,
    is_active TINYINT(1) DEFAULT 1
);

-- Admission Applications table
CREATE TABLE IF NOT EXISTS applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    application_number VARCHAR(20) UNIQUE NOT NULL,
    tenth_percent DECIMAL(5,2),
    twelfth_percent DECIMAL(5,2),
    graduation_percent DECIMAL(5,2),
    status ENUM('PENDING','UNDER_REVIEW','APPROVED','REJECTED') DEFAULT 'PENDING',
    remarks TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Documents table
CREATE TABLE IF NOT EXISTS documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- Fee Payments table
CREATE TABLE IF NOT EXISTS fee_payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_mode ENUM('ONLINE','CASH','DD') DEFAULT 'ONLINE',
    transaction_id VARCHAR(100),
    payment_status ENUM('PENDING','SUCCESS','FAILED') DEFAULT 'PENDING',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- Admin table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications / Email Log
CREATE TABLE IF NOT EXISTS email_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_email VARCHAR(100),
    subject VARCHAR(255),
    message TEXT,
    status ENUM('SENT','FAILED') DEFAULT 'SENT',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===================== SAMPLE DATA =====================

-- Insert Sample Courses
INSERT INTO courses (course_name, course_code, duration, total_seats, available_seats, fees, description) VALUES
('Bachelor of Computer Applications', 'BCA', '3 Years', 60, 60, 45000.00, 'Undergraduate program in Computer Applications'),
('Master of Computer Applications', 'MCA', '2 Years', 40, 40, 60000.00, 'Postgraduate program in Computer Applications'),
('Bachelor of Business Administration', 'BBA', '3 Years', 60, 60, 40000.00, 'Undergraduate program in Business Administration'),
('Bachelor of Science (CS)', 'BSC-CS', '3 Years', 50, 50, 35000.00, 'B.Sc. Computer Science Program'),
('MBA - Information Technology', 'MBA-IT', '2 Years', 30, 30, 80000.00, 'MBA with IT Specialization');

-- Insert Default Admin (password: admin@123)
-- BCrypt hash of 'admin@123'
INSERT INTO admins (username, password, full_name, email) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh', 'System Administrator', 'admin@admission.com');

-- =====================================================
-- NOTE: BCrypt hash above is for password: admin@123
-- You can change it using BCrypt online generator
-- =====================================================
