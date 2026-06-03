# Online Admission System
### Java Servlet + JSP + JDBC + MySQL | Full Stack Project

---

## 🚀 Tech Stack
- **Backend:** Java Servlet, JDBC
- **Frontend:** JSP, Bootstrap 5, Font Awesome, Chart.js
- **Database:** MySQL 8.x
- **Build:** Maven
- **Server:** Apache Tomcat 9+
- **Security:** BCrypt password hashing, Session-based auth, Filter-based protection

---

## ✨ Features

### Student Side
- Registration with full profile
- Login/Logout with session management
- Multi-step admission application form
- Document upload (10th/12th marksheet, photo, ID proof)
- Online fee payment (mock) with receipt
- Dashboard with application tracking
- Email notifications on every action

### Admin Side
- Secure admin login
- Dashboard with stats + Chart.js donut chart
- View all applications with filter (Pending/Approved/Rejected)
- Review application details with documents
- Quick approve/reject from list view
- Update status + send email notification to student
- Revenue tracking

---

## ⚙️ Setup Instructions

### Step 1: Database Setup
```sql
-- Open MySQL Workbench or CLI
-- Run the database.sql file
source /path/to/database.sql
```

### Step 2: Configure DB Connection
Edit `src/main/java/util/DBConnection.java`:
```java
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password";
```

### Step 3: Configure Email (Gmail)
Edit `src/main/java/util/EmailUtil.java`:
```java
private static final String FROM_EMAIL = "your_email@gmail.com";
private static final String FROM_PASSWORD = "your_app_password"; // Gmail App Password
```
> **Note:** Go to Gmail → Security → 2FA → App Passwords → Generate for "Mail"

### Step 4: Build & Deploy
```bash
# Build WAR
mvn clean package

# Deploy to Tomcat
# Copy target/OnlineAdmissionSystem-1.0-SNAPSHOT.war to tomcat/webapps/
```

### Step 5: Access
- **Home:** http://localhost:8080/OnlineAdmissionSystem/
- **Admin Login:** username=`admin`, password=`admin@123`

---

## 📁 Project Structure
```
OnlineAdmissionSystem/
├── src/main/java/
│   ├── model/          Student, Course, Application, Document, Payment
│   ├── dao/            StudentDAO, CourseDAO, ApplicationDAO, DocumentDAO, PaymentDAO, AdminDAO
│   ├── servlet/        Register, Login, Logout, StudentDashboard, Apply, Payment, AdminDashboard, AdminApplication
│   ├── filter/         StudentAuthFilter, AdminAuthFilter
│   └── util/           DBConnection, EmailUtil, FileUploadUtil
├── src/main/webapp/
│   ├── index.jsp       Landing page
│   ├── login.jsp       Login (Student + Admin)
│   ├── register.jsp    Student registration
│   ├── student/        dashboard.jsp, apply.jsp, payment.jsp
│   ├── admin/          dashboard.jsp, applications.jsp, application-detail.jsp
│   └── WEB-INF/web.xml
├── database.sql        DB schema + sample data
└── pom.xml
```

---

## 🎤 Interview Points to Highlight

1. **MVC Architecture** - Clear separation: Model (POJO), View (JSP), Controller (Servlet)
2. **JDBC with PreparedStatement** - Prevents SQL injection
3. **BCrypt password hashing** - Secure password storage
4. **Filter-based auth** - StudentAuthFilter + AdminAuthFilter protect routes
5. **File upload** - Apache Commons FileUpload, stores in /uploads
6. **Email notifications** - JavaMail API with HTML templates
7. **Session management** - HttpSession for login state
8. **Multi-step form** - JS-powered step wizard for better UX
9. **Chart.js integration** - Admin dashboard with donut chart
10. **Responsive UI** - Bootstrap 5, mobile-friendly
