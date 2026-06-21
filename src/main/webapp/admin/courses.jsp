<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #0d47a1, #1565c0); min-height: 100vh; width: 260px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 260px; padding: 25px; }
        .card { border: none; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .form-control, .form-select { border-radius: 10px; border: 2px solid #e9ecef; }
        .form-control:focus { border-color: #1a73e8; box-shadow: none; }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar">
    <div class="brand text-white">
        <i class="fas fa-shield-alt me-2"></i><strong>Admin Panel</strong>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/applications" class="nav-link">
            <i class="fas fa-file-alt me-2"></i>Applications
        </a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=PENDING" class="nav-link">
            <i class="fas fa-clock me-2"></i>Pending Review
        </a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=APPROVED" class="nav-link">
            <i class="fas fa-check-circle me-2"></i>Approved
        </a>
        <a href="${pageContext.request.contextPath}/admin/courses" class="nav-link active">
            <i class="fas fa-book me-2"></i>Manage Courses
        </a>
        <hr style="border-color: rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="fas fa-sign-out-alt me-2"></i>Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h5 class="fw-bold mb-0">Manage Courses</h5>
            <small class="text-muted">Add, edit and manage courses</small>
        </div>
        <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addCourseModal">
            <i class="fas fa-plus me-2"></i>Add New Course
        </button>
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

    <!-- Courses Table -->
    <div class="card p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Course Name</th>
                        <th>Code</th>
                        <th>Duration</th>
                        <th>Total Seats</th>
                        <th>Available</th>
                        <th>Fees</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="course" items="${courses}">
                    <tr>
                        <td>
                            <div class="fw-semibold">${course.courseName}</div>
                            <small class="text-muted">${course.description}</small>
                        </td>
                        <td><code>${course.courseCode}</code></td>
                        <td>${course.duration}</td>
                        <td>${course.totalSeats}</td>
                        <td>
                            <span class="badge ${course.availableSeats > 10 ? 'bg-success' : 'bg-warning'}">
                                ${course.availableSeats}
                            </span>
                        </td>
                        <td class="fw-bold">₹<fmt:formatNumber value="${course.fees}" pattern="#,##0"/></td>
                        <td>
                            <span class="badge ${course.active ? 'bg-success' : 'bg-danger'}">
                                ${course.active ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary rounded-pill"
                                onclick="editCourse(${course.id},'${course.courseName}','${course.duration}',
                                ${course.totalSeats},${course.fees},'${course.description}',${course.active})">
                                <i class="fas fa-edit"></i>
                            </button>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Course Modal -->
<div class="modal fade" id="addCourseModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 rounded-4">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold">Add New Course</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/courses" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-8">
                            <label class="form-label fw-semibold">Course Name *</label>
                            <input type="text" class="form-control" name="courseName" required>
                        </div>
                        <div class="col-4">
                            <label class="form-label fw-semibold">Code *</label>
                            <input type="text" class="form-control" name="courseCode" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Duration *</label>
                            <input type="text" class="form-control" name="duration" placeholder="e.g. 3 Years">
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Total Seats *</label>
                            <input type="number" class="form-control" name="totalSeats" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Fees (₹) *</label>
                            <input type="number" class="form-control" name="fees" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea class="form-control" name="description" rows="2"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Add Course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Course Modal -->
<div class="modal fade" id="editCourseModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 rounded-4">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold">Edit Course</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/courses" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="courseId" id="editCourseId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Course Name *</label>
                            <input type="text" class="form-control" name="courseName" id="editCourseName" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Duration</label>
                            <input type="text" class="form-control" name="duration" id="editDuration">
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Total Seats</label>
                            <input type="number" class="form-control" name="totalSeats" id="editSeats">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Fees (₹)</label>
                            <input type="number" class="form-control" name="fees" id="editFees">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Description</label>
                            <textarea class="form-control" name="description" id="editDesc" rows="2"></textarea>
                        </div>
                        <div class="col-12">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isActive" id="editActive">
                                <label class="form-check-label fw-semibold">Active</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">Update Course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function editCourse(id, name, duration, seats, fees, desc, active) {
    document.getElementById('editCourseId').value = id;
    document.getElementById('editCourseName').value = name;
    document.getElementById('editDuration').value = duration;
    document.getElementById('editSeats').value = seats;
    document.getElementById('editFees').value = fees;
    document.getElementById('editDesc').value = desc;
    document.getElementById('editActive').checked = active;
    new bootstrap.Modal(document.getElementById('editCourseModal')).show();
}
</script>
</body>
</html>