<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Admission Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%); min-height: 100vh; padding: 30px 0; }
        .card { border: none; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .card-header { background: linear-gradient(135deg, #1a73e8, #0d47a1); border-radius: 20px 20px 0 0 !important; }
        .form-control, .form-select { border-radius: 10px; padding: 10px 15px; border: 2px solid #e9ecef; }
        .form-control:focus, .form-select:focus { border-color: #1a73e8; box-shadow: 0 0 0 0.2rem rgba(26,115,232,0.25); }
        .btn-register { background: linear-gradient(135deg, #1a73e8, #0d47a1); border: none; border-radius: 10px; padding: 12px; }
        .section-title { font-weight: 700; color: #1a73e8; border-bottom: 2px solid #e9ecef; padding-bottom: 8px; margin-bottom: 20px; }
        .password-strength { height: 5px; border-radius: 5px; transition: all 0.3s; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none">
                    <i class="fas fa-graduation-cap fa-3x mb-2"></i>
                    <h3 class="fw-bold">AdmissionPortal</h3>
                </a>
            </div>
            <div class="card">
                <div class="card-header text-white text-center py-4">
                    <h4 class="mb-0 fw-bold"><i class="fas fa-user-plus me-2"></i>Student Registration</h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                        <!-- Personal Info -->
                        <h6 class="section-title"><i class="fas fa-user me-2"></i>Personal Information</h6>
                        <div class="row g-3 mb-4">
                            <div class="col-md-12">
                                <label class="form-label fw-semibold">Full Name *</label>
                                <input type="text" class="form-control" name="fullName" placeholder="Enter full name as per documents" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email Address *</label>
                                <input type="email" class="form-control" name="email" placeholder="your@email.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Mobile Number *</label>
                                <input type="tel" class="form-control" name="phone" placeholder="10-digit mobile" pattern="[0-9]{10}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Date of Birth *</label>
                                <input type="date" class="form-control" name="dob" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Gender *</label>
                                <select class="form-select" name="gender" required>
                                    <option value="">Select Gender</option>
                                    <option>Male</option>
                                    <option>Female</option>
                                    <option>Other</option>
                                </select>
                            </div>
                        </div>

                        <!-- Address -->
                        <h6 class="section-title"><i class="fas fa-map-marker-alt me-2"></i>Address</h6>
                        <div class="row g-3 mb-4">
                            <div class="col-12">
                                <label class="form-label fw-semibold">Address *</label>
                                <textarea class="form-control" name="address" rows="2" placeholder="Street, Area" required></textarea>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">City *</label>
                                <input type="text" class="form-control" name="city" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">State *</label>
                                <select class="form-select" name="state" required>
                                    <option value="">Select State</option>
                                    <option>Maharashtra</option><option>Delhi</option><option>Karnataka</option>
                                    <option>Tamil Nadu</option><option>Telangana</option><option>Gujarat</option>
                                    <option>Rajasthan</option><option>Uttar Pradesh</option><option>Other</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Pincode *</label>
                                <input type="text" class="form-control" name="pincode" pattern="[0-9]{6}" placeholder="6-digit pincode" required>
                            </div>
                        </div>

                        <!-- Password -->
                        <h6 class="section-title"><i class="fas fa-lock me-2"></i>Set Password</h6>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Password *</label>
                                <input type="password" class="form-control" name="password" id="password" placeholder="Min 6 characters" minlength="6" required oninput="checkStrength(this.value)">
                                <div class="mt-2">
                                    <div class="password-strength bg-secondary" id="strengthBar" style="width:0%"></div>
                                    <small id="strengthText" class="text-muted"></small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Confirm Password *</label>
                                <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" placeholder="Re-enter password" required>
                                <small id="matchMsg" class="text-muted"></small>
                            </div>
                        </div>

                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="terms" required>
                            <label class="form-check-label" for="terms">I agree to the <a href="#" class="text-primary">Terms & Conditions</a></label>
                        </div>

                        <button type="submit" class="btn btn-register text-white w-100 fw-bold fs-5">
                            <i class="fas fa-user-plus me-2"></i>Register Now
                        </button>
                    </form>
                    <hr>
                    <p class="text-center mb-0">Already registered? <a href="${pageContext.request.contextPath}/login" class="text-primary fw-bold">Login here</a></p>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function checkStrength(val) {
    const bar = document.getElementById('strengthBar');
    const txt = document.getElementById('strengthText');
    if (val.length < 4) { bar.style.width='25%'; bar.className='password-strength bg-danger'; txt.textContent='Weak'; }
    else if (val.length < 8) { bar.style.width='50%'; bar.className='password-strength bg-warning'; txt.textContent='Fair'; }
    else if (/[A-Z]/.test(val) && /[0-9]/.test(val)) { bar.style.width='100%'; bar.className='password-strength bg-success'; txt.textContent='Strong'; }
    else { bar.style.width='75%'; bar.className='password-strength bg-info'; txt.textContent='Good'; }
}
document.getElementById('confirmPassword').addEventListener('input', function() {
    const msg = document.getElementById('matchMsg');
    if (this.value === document.getElementById('password').value) {
        msg.textContent = '✓ Passwords match'; msg.className = 'text-success small';
    } else {
        msg.textContent = '✗ Passwords do not match'; msg.className = 'text-danger small';
    }
});
document.getElementById('registerForm').addEventListener('submit', function(e) {
    if (document.getElementById('password').value !== document.getElementById('confirmPassword').value) {
        e.preventDefault();
        alert('Passwords do not match!');
    }
});
</script>
</body>
</html>
