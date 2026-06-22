<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Application Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #0d47a1, #1565c0); min-height: 100vh; width: 260px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 260px; padding: 25px; }
        .card { border: none; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .info-label { font-size: 0.8rem; color: #6c757d; font-weight: 600; text-transform: uppercase; }
        .info-value { font-size: 1rem; font-weight: 500; }
        .doc-item { border: 1px solid #e9ecef; border-radius: 10px; padding: 12px 15px; display: flex; align-items: center; gap: 12px; }
        .status-PENDING { color: #856404; background: #fff3cd; }
        .status-APPROVED { color: #0a3622; background: #d1e7dd; }
        .status-REJECTED { color: #58151c; background: #f8d7da; }
        .status-UNDER_REVIEW { color: #055160; background: #cff4fc; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand text-white"><i class="fas fa-shield-alt me-2"></i><strong>Admin Panel</strong></div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/applications" class="nav-link active"><i class="fas fa-file-alt me-2"></i>Applications</a>
        <hr style="border-color: rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h5 class="fw-bold mb-0">Application Detail</h5>
            <small class="text-muted">Review all submitted information</small>
        </div>
        <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-outline-secondary rounded-pill">
            <i class="fas fa-arrow-left me-2"></i>Back to List
        </a>
    </div>

    <div class="row g-4">
        <!-- Application Info -->
        <div class="col-md-8">
            <div class="card p-4 mb-4">
                <div class="d-flex justify-content-between align-items-start mb-4">
                    <div>
                        <h6 class="fw-bold">Application #${application.applicationNumber}</h6>
                        <small class="text-muted">Applied on <fmt:formatDate value="${application.appliedAt}" pattern="dd MMM yyyy, hh:mm a"/></small>
                    </div>
                    <span class="badge px-3 py-2 status-${application.status} rounded-pill">${application.status}</span>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <p class="info-label mb-1">Student Name</p>
                        <p class="info-value">${application.studentName}</p>
                    </div>
                    <div class="col-md-6">
                        <p class="info-label mb-1">Email</p>
                        <p class="info-value">${application.studentEmail}</p>
                    </div>
                    <div class="col-md-6">
                        <p class="info-label mb-1">Phone</p>
                        <p class="info-value">${application.studentPhone}</p>
                    </div>
                    <div class="col-md-6">
                        <p class="info-label mb-1">Course Applied</p>
                        <p class="info-value fw-bold">${application.courseName} (${application.courseCode})</p>
                    </div>
                </div>

                <hr>
                <h6 class="fw-bold mb-3"><i class="fas fa-graduation-cap me-2 text-primary"></i>Academic Details</h6>
                <div class="row g-3">
                    <div class="col-md-4 text-center">
                        <div class="p-3 rounded-3" style="background: #f0f7ff;">
                            <p class="info-label">10th</p>
                            <h4 class="fw-bold text-primary">${application.tenthPercent}%</h4>
                        </div>
                    </div>
                    <div class="col-md-4 text-center">
                        <div class="p-3 rounded-3" style="background: #f0fdf4;">
                            <p class="info-label">12th</p>
                            <h4 class="fw-bold text-success">${application.twelfthPercent}%</h4>
                        </div>
                    </div>
                    <div class="col-md-4 text-center">
                        <div class="p-3 rounded-3" style="background: #fef9ec;">
                            <p class="info-label">Graduation</p>
                            <h4 class="fw-bold text-warning">
							    <c:choose>
							        <c:when test="${application.graduationPercent > 0}">
							            ${application.graduationPercent}%
							        </c:when>
							        <c:otherwise>N/A</c:otherwise>
							    </c:choose>
							</h4>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Documents -->
            <div class="card p-4">
                <h6 class="fw-bold mb-3"><i class="fas fa-paperclip me-2 text-primary"></i>Uploaded Documents</h6>
                <c:choose>
                    <c:when test="${empty documents}">
                        <p class="text-muted">No documents uploaded yet.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column gap-2">
                            <c:forEach var="doc" items="${documents}">
                            <div class="doc-item">
                                <i class="fas fa-file-pdf text-danger fa-lg"></i>
                                <div class="flex-grow-1">
                                    <div class="fw-semibold">${doc.documentType}</div>
                                    <small class="text-muted">${doc.fileName}</small>
                                </div>
                                <a href="${pageContext.request.contextPath}/uploads/${doc.fileName}" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill">
                                    <i class="fas fa-eye me-1"></i>View
                                </a>
                            </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Action Panel -->
        <div class="col-md-4">
            <div class="card p-4">
                <h6 class="fw-bold mb-4"><i class="fas fa-cog me-2 text-primary"></i>Update Status</h6>
                <form action="${pageContext.request.contextPath}/admin/applications" method="post">
                    <input type="hidden" name="appId" value="${application.id}">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">New Status</label>
                        <select class="form-select" name="status" required>
                            <option value="PENDING" ${application.status == 'PENDING' ? 'selected' : ''}>⏳ Pending</option>
                            <option value="UNDER_REVIEW" ${application.status == 'UNDER_REVIEW' ? 'selected' : ''}>🔍 Under Review</option>
                            <option value="APPROVED" ${application.status == 'APPROVED' ? 'selected' : ''}>✅ Approved</option>
                            <option value="REJECTED" ${application.status == 'REJECTED' ? 'selected' : ''}>❌ Rejected</option>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Remarks</label>
                        <textarea class="form-control" name="remarks" rows="4" placeholder="Add remarks for the student (will be sent via email)">${application.remarks}</textarea>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 rounded-pill fw-bold">
                        <i class="fas fa-save me-2"></i>Update & Notify Student
                    </button>
                </form>
            </div>

            <div class="card p-4 mt-4">
                <h6 class="fw-bold mb-3">Course Fee Info</h6>
                <div class="text-center p-3 bg-success bg-opacity-10 rounded-3">
                    <small class="text-muted d-block">Course Fee</small>
                    <h3 class="fw-bold text-success">₹<fmt:formatNumber value="${application.courseFees}" pattern="#,##0"/></h3>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
