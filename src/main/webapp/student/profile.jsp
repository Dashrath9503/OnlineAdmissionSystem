<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #1a73e8, #0d47a1); min-height: 100vh; width: 250px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        .card { border: none; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .form-control, .form-select { border-radius: 10px; border: 2px solid #e9ecef; padding: 10px 15px; }
        .form-control:focus, .form-select:focus { border-color: #1a73e8; box-shadow: none; }
        .avatar { width: 100px; height: 100px; border-radius: 50%; background: linear-gradient(135deg, #1a73e8, #0d47a1); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; color: white; margin: 0 auto; }
        .section-title { font-weight: 700; color: #1a73e8; border-bottom: 2px solid #e9ecef; padding-bottom: 8px; margin-bottom: 20px; }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar">
    <div class="brand text-white">
        <i class="fas fa-graduation-cap me-2"></i><strong>AdmissionPortal</strong>
        <p class="small mb-0 mt-1 opacity-75">${sessionScope.student.fullName}</p>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link">
            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/student/apply" class="nav-link">
            <i class="fas fa-file-alt me-2"></i> Apply for Admission
        </a>
        <a href="${pageContext.request.contextPath}/student/profile" class="nav-link active">
            <i class="fas fa-user me-2"></i> My Profile
        </a>
        <hr style="border-color: rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="fas fa-sign-out-alt me-2"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h5 class="fw-bold mb-0">My Profile</h5>
            <small class="text-muted">Update your personal information</small>
        </div>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show rounded-3">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("successMsg"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("errorMsg"); %>
    </c:if>

    <div class="row g-4">
        <!-- Avatar Card -->
        <div class="col-md-3">
            <div class="card p-4 text-center">
                <div class="avatar mb-3">
                    ${sessionScope.student.fullName.substring(0,1).toUpperCase()}
                </div>
                <h6 class="fw-bold">${sessionScope.student.fullName}</h6>
                <p class="text-muted small">${sessionScope.student.email}</p>
                <span class="badge bg-primary rounded-pill">Student</span>
            </div>
        </div>

        <!-- Profile Form -->
        <div class="col-md-9">
            <div class="card p-4">
                <form action="${pageContext.request.contextPath}/student/profile" method="post">

                    <h6 class="section-title"><i class="fas fa-user me-2"></i>Personal Information</h6>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Full Name</label>
                            <input type="text" class="form-control" name="fullName" 
                                   value="${sessionScope.student.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email</label>
                            <input type="email" class="form-control" 
                                   value="${sessionScope.student.email}" disabled>
                            <small class="text-muted">Email cannot be changed</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Mobile Number</label>
                            <input type="tel" class="form-control" name="phone" 
                                   value="${sessionScope.student.phone}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Date of Birth</label>
                            <input type="date" class="form-control" name="dob" 
                                   value="${sessionScope.student.dob}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Gender</label>
                            <select class="form-select" name="gender">
                                <option ${sessionScope.student.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option ${sessionScope.student.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option ${sessionScope.student.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>

                    <h6 class="section-title"><i class="fas fa-map-marker-alt me-2"></i>Address</h6>
                    <div class="row g-3 mb-4">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Address</label>
                            <textarea class="form-control" name="address" rows="2">${sessionScope.student.address}</textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">City</label>
                            <input type="text" class="form-control" name="city" 
                                   value="${sessionScope.student.city}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">State</label>
                            <select class="form-select" name="state">
                                <option ${sessionScope.student.state == 'Maharashtra' ? 'selected' : ''}>Maharashtra</option>
                                <option ${sessionScope.student.state == 'Delhi' ? 'selected' : ''}>Delhi</option>
                                <option ${sessionScope.student.state == 'Karnataka' ? 'selected' : ''}>Karnataka</option>
                                <option ${sessionScope.student.state == 'Tamil Nadu' ? 'selected' : ''}>Tamil Nadu</option>
                                <option ${sessionScope.student.state == 'Telangana' ? 'selected' : ''}>Telangana</option>
                                <option ${sessionScope.student.state == 'Gujarat' ? 'selected' : ''}>Gujarat</option>
                                <option ${sessionScope.student.state == 'Rajasthan' ? 'selected' : ''}>Rajasthan</option>
                                <option ${sessionScope.student.state == 'Uttar Pradesh' ? 'selected' : ''}>Uttar Pradesh</option>
                                <option ${sessionScope.student.state == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Pincode</label>
                            <input type="text" class="form-control" name="pincode" 
                                   value="${sessionScope.student.pincode}">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold">
                        <i class="fas fa-save me-2"></i>Update Profile
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>