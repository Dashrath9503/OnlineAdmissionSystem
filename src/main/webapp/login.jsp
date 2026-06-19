<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Admission Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%); min-height: 100vh; display: flex; align-items: center; }
        .card { border: none; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .card-header { background: linear-gradient(135deg, #1a73e8, #0d47a1); border-radius: 20px 20px 0 0 !important; }
        .form-control { border-radius: 10px; padding: 12px 15px; border: 2px solid #e9ecef; }
        .form-control:focus { border-color: #1a73e8; box-shadow: 0 0 0 0.2rem rgba(26,115,232,0.25); }
        .btn-login { background: linear-gradient(135deg, #1a73e8, #0d47a1); border: none; border-radius: 10px; padding: 12px; font-size: 1.1rem; font-weight: 600; }
        .role-tab { cursor: pointer; padding: 10px 20px; border-radius: 10px; transition: all 0.3s; }
        .role-tab.active { background: #1a73e8; color: white; }
        .role-tab:not(.active) { background: #f0f4ff; color: #1a73e8; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none">
                    <i class="fas fa-graduation-cap fa-3x mb-2"></i>
                    <h3 class="fw-bold">AdmissionPortal</h3>
                </a>
            </div>
            <div class="card">
                <div class="card-header text-white text-center py-4">
                    <h4 class="mb-0 fw-bold">
                        <i class="fas fa-sign-in-alt me-2"></i>Welcome Back
                    </h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.successMsg}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("successMsg"); %>
                    </c:if>

                    <!-- Role Selector -->
                    <div class="d-flex gap-2 mb-4">
                        <div class="role-tab active flex-fill text-center" 
                             id="studentTab" onclick="setRole('student')">
                            <i class="fas fa-user-graduate me-1"></i> Student
                        </div>
                        <div class="role-tab flex-fill text-center" 
                             id="adminTab" onclick="setRole('admin')">
                            <i class="fas fa-user-shield me-1"></i> Admin
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <input type="hidden" name="role" id="roleInput" value="student">

                        <div class="mb-3">
                            <label class="form-label fw-semibold" id="emailLabel">
                                Email Address
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light">
                                    <i class="fas fa-envelope text-muted" id="emailIcon"></i>
                                </span>
                                <input type="text" class="form-control" name="email" 
                                       id="emailInput"
                                       placeholder="Enter your email" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light">
                                    <i class="fas fa-lock text-muted"></i>
                                </span>
                                <input type="password" class="form-control" 
                                       name="password" id="passwordInput" 
                                       placeholder="Enter password" required>
                                <button class="btn btn-outline-secondary" 
                                        type="button" onclick="togglePassword()">
                                    <i class="fas fa-eye" id="eyeIcon"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-login text-white w-100">
                            <i class="fas fa-sign-in-alt me-2"></i>Login
                        </button>
                    </form>

                    <hr class="my-4">
                    <p class="text-center mb-0">Don't have an account?
                        <a href="${pageContext.request.contextPath}/register" 
                           class="text-primary fw-bold text-decoration-none">
                           Register Now
                        </a>
                    </p>
                    <div id="adminHint" class="d-none mt-3 p-3 bg-light rounded-3">
                        <small class="text-muted">
                            <i class="fas fa-info-circle me-1 text-primary"></i>
                            Admin credentials:<br>
                            Username: <code>admin</code> | 
                            Password: <code>admin@123</code>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function setRole(role) {
    document.getElementById('roleInput').value = role;
    document.getElementById('studentTab').classList.toggle('active', role === 'student');
    document.getElementById('adminTab').classList.toggle('active', role === 'admin');

    // Label + placeholder change
    if (role === 'admin') {
        document.getElementById('emailLabel').textContent = 'Username';
        document.getElementById('emailInput').placeholder = 'Enter username (admin)';
        document.getElementById('emailIcon').className = 'fas fa-user text-muted';
        document.getElementById('adminHint').classList.remove('d-none');
    } else {
        document.getElementById('emailLabel').textContent = 'Email Address';
        document.getElementById('emailInput').placeholder = 'Enter your email';
        document.getElementById('emailIcon').className = 'fas fa-envelope text-muted';
        document.getElementById('adminHint').classList.add('d-none');
    }
}

function togglePassword() {
    const input = document.getElementById('passwordInput');
    const icon = document.getElementById('eyeIcon');
    input.type = input.type === 'password' ? 'text' : 'password';
    icon.classList.toggle('fa-eye');
    icon.classList.toggle('fa-eye-slash');
}
</script>
</body>
</html>