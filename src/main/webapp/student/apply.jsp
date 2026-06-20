<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Apply for Admission</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #1a73e8, #0d47a1); min-height: 100vh; width: 250px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        .form-control, .form-select { border-radius: 10px; border: 2px solid #e9ecef; }
        .form-control:focus, .form-select:focus { border-color: #1a73e8; box-shadow: none; }
        .card { border: none; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .course-card { cursor: pointer; transition: all 0.3s; border: 2px solid transparent !important; }
        .course-card:hover { border-color: #1a73e8 !important; transform: translateY(-3px); }
        .course-card.selected { border-color: #1a73e8 !important; background: #f0f7ff; }
        .step-indicator { display: flex; gap: 10px; margin-bottom: 25px; }
        .step { flex: 1; text-align: center; padding: 10px; border-radius: 10px; background: #e9ecef; color: #6c757d; font-size: 0.85rem; }
        .step.active { background: #1a73e8; color: white; font-weight: 600; }
        .step.done { background: #10b981; color: white; }
        .file-upload-box { border: 2px dashed #1a73e8; border-radius: 10px; padding: 20px; text-align: center; cursor: pointer; transition: background 0.3s; }
        .file-upload-box:hover { background: #f0f7ff; }
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
        <a href="${pageContext.request.contextPath}/student/apply" class="nav-link active">
            <i class="fas fa-file-alt me-2"></i> Apply for Admission
        </a>
        <a href="${pageContext.request.contextPath}/student/profile" class="nav-link">
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
            <h5 class="fw-bold mb-0">Apply for Admission</h5>
            <small class="text-muted">Fill the form carefully with correct details</small>
        </div>
        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-secondary rounded-pill">
            <i class="fas fa-arrow-left me-2"></i>Back
        </a>
    </div>

    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("errorMsg"); %>
    </c:if>

    <!-- Steps -->
    <div class="step-indicator">
        <div class="step active" id="step1-ind"><i class="fas fa-book me-1"></i>1. Select Course</div>
        <div class="step" id="step2-ind"><i class="fas fa-graduation-cap me-1"></i>2. Academic Details</div>
        <div class="step" id="step3-ind"><i class="fas fa-upload me-1"></i>3. Upload Documents</div>
    </div>

    <form action="${pageContext.request.contextPath}/student/apply" method="post" enctype="multipart/form-data" id="applyForm">

        <!-- Step 1: Course Selection -->
        <div id="step1">
            <div class="card p-4 mb-4">
                <h6 class="section-title"><i class="fas fa-book-open me-2"></i>Select Course</h6>
                <div class="row g-3">
                    <c:forEach var="course" items="${courses}">
                    <div class="col-md-4">
                        <div class="card course-card p-3" onclick="selectCourse(${course.id}, '${course.courseName}', ${course.fees})">
                            <div class="d-flex align-items-start">
                                <div class="me-3 mt-1" style="font-size: 2rem;">🎓</div>
                                <div>
                                    <h6 class="fw-bold mb-1">${course.courseName}</h6>
                                    <small class="text-muted">${course.courseCode} | ${course.duration}</small>
                                    <div class="mt-2">
                                        <span class="badge bg-primary me-1">Seats: ${course.availableSeats}</span>
                                        <span class="badge bg-success">₹<fmt:formatNumber value="${course.fees}" pattern="#,##0"/></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                </div>
                <input type="hidden" name="courseId" id="courseId" required>
                <div id="selectedCourseInfo" class="mt-3 p-3 bg-primary bg-opacity-10 rounded-3 d-none">
                    <i class="fas fa-check-circle text-primary me-2"></i>Selected: <strong id="selectedCourseName"></strong>
                    | Fee: <strong id="selectedCourseFee"></strong>
                </div>
            </div>
            <div class="text-end">
                <button type="button" class="btn btn-primary px-5 rounded-pill" onclick="nextStep(2)">
                    Next <i class="fas fa-arrow-right ms-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 2: Academic Details -->
        <div id="step2" class="d-none">
            <div class="card p-4 mb-4">
                <h6 class="section-title"><i class="fas fa-graduation-cap me-2"></i>Academic Information</h6>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">10th Percentage *</label>
                        <div class="input-group">
                            <input type="number" class="form-control" name="tenthPercent" min="0" max="100" step="0.01" placeholder="e.g. 85.50" required>
                            <span class="input-group-text">%</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">12th Percentage *</label>
                        <div class="input-group">
                            <input type="number" class="form-control" name="twelfthPercent" min="0" max="100" step="0.01" placeholder="e.g. 78.00" required>
                            <span class="input-group-text">%</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Graduation Percentage</label>
                        <div class="input-group">
                            <input type="number" class="form-control" name="graduationPercent" min="0" max="100" step="0.01" placeholder="If applicable">
                            <span class="input-group-text">%</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="d-flex justify-content-between">
                <button type="button" class="btn btn-outline-secondary rounded-pill px-4" onclick="nextStep(1)">
                    <i class="fas fa-arrow-left me-2"></i>Back
                </button>
                <button type="button" class="btn btn-primary px-5 rounded-pill" onclick="nextStep(3)">
                    Next <i class="fas fa-arrow-right ms-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 3: Document Upload -->
        <div id="step3" class="d-none">
            <div class="card p-4 mb-4">
                <h6 class="section-title"><i class="fas fa-upload me-2"></i>Upload Documents</h6>
                <p class="text-muted small mb-4">Supported formats: PDF, JPG, PNG | Max size: 5MB each</p>
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">10th Marksheet *</label>
                        <div class="file-upload-box" onclick="document.getElementById('tenthMarksheet').click()">
                            <i class="fas fa-file-upload fa-2x text-primary mb-2"></i>
                            <p class="mb-0 small" id="tenthLabel">Click to upload</p>
                        </div>
                        <input type="file" class="d-none" id="tenthMarksheet" name="tenthMarksheet" accept=".pdf,.jpg,.jpeg,.png" onchange="updateLabel(this,'tenthLabel')">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">12th Marksheet *</label>
                        <div class="file-upload-box" onclick="document.getElementById('twelfthMarksheet').click()">
                            <i class="fas fa-file-upload fa-2x text-primary mb-2"></i>
                            <p class="mb-0 small" id="twelfthLabel">Click to upload</p>
                        </div>
                        <input type="file" class="d-none" id="twelfthMarksheet" name="twelfthMarksheet" accept=".pdf,.jpg,.jpeg,.png" onchange="updateLabel(this,'twelfthLabel')">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Graduation Marksheet <span class="text-muted">(if applicable)</span></label>
                        <div class="file-upload-box" onclick="document.getElementById('graduationMarksheet').click()">
                            <i class="fas fa-file-upload fa-2x text-secondary mb-2"></i>
                            <p class="mb-0 small" id="gradLabel">Click to upload</p>
                        </div>
                        <input type="file" class="d-none" id="graduationMarksheet" name="graduationMarksheet" accept=".pdf,.jpg,.jpeg,.png" onchange="updateLabel(this,'gradLabel')">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Passport Photo *</label>
                        <div class="file-upload-box" onclick="document.getElementById('photo').click()">
                            <i class="fas fa-camera fa-2x text-primary mb-2"></i>
                            <p class="mb-0 small" id="photoLabel">Click to upload</p>
                        </div>
                        <input type="file" class="d-none" id="photo" name="photo" accept=".jpg,.jpeg,.png" onchange="updateLabel(this,'photoLabel')">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">ID Proof *</label>
                        <div class="file-upload-box" onclick="document.getElementById('idProof').click()">
                            <i class="fas fa-id-card fa-2x text-primary mb-2"></i>
                            <p class="mb-0 small" id="idLabel">Aadhar / PAN / Passport</p>
                        </div>
                        <input type="file" class="d-none" id="idProof" name="idProof" accept=".pdf,.jpg,.jpeg,.png" onchange="updateLabel(this,'idLabel')">
                    </div>
                </div>
            </div>
            <div class="d-flex justify-content-between">
                <button type="button" class="btn btn-outline-secondary rounded-pill px-4" onclick="nextStep(2)">
                    <i class="fas fa-arrow-left me-2"></i>Back
                </button>
                <button type="submit" class="btn btn-success px-5 rounded-pill fw-bold">
                    <i class="fas fa-paper-plane me-2"></i>Submit Application
                </button>
            </div>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
let currentStep = 1;

function selectCourse(id, name, fee) {
    document.getElementById('courseId').value = id;
    document.querySelectorAll('.course-card').forEach(c => c.classList.remove('selected'));
    event.currentTarget.classList.add('selected');
    document.getElementById('selectedCourseName').textContent = name;
    document.getElementById('selectedCourseFee').textContent = '₹' + fee.toLocaleString('en-IN');
    document.getElementById('selectedCourseInfo').classList.remove('d-none');
}

function nextStep(step) {
    if (step > currentStep && step === 2 && !document.getElementById('courseId').value) {
        alert('Please select a course!'); return;
    }
    document.getElementById('step' + currentStep).classList.add('d-none');
    document.getElementById('step' + step).classList.remove('d-none');
    // Update indicators
    for (let i = 1; i <= 3; i++) {
        const ind = document.getElementById('step' + i + '-ind');
        ind.className = 'step';
        if (i < step) ind.classList.add('done');
        else if (i === step) ind.classList.add('active');
    }
    currentStep = step;
}

function updateLabel(input, labelId) {
    document.getElementById(labelId).textContent = input.files[0] ? '✓ ' + input.files[0].name : 'Click to upload';
}
</script>
</body>
</html>
