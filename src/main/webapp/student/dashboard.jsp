<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #1a73e8, #0d47a1); min-height: 100vh; width: 250px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        .stat-card { border: none; border-radius: 16px; transition: transform 0.3s; }
        .stat-card:hover { transform: translateY(-5px); }
        .topbar { background: white; border-radius: 16px; padding: 15px 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); margin-bottom: 25px; }
        .table-card { background: white; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .badge-status { padding: 6px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .badge-PENDING { background: #fff3cd; color: #856404; }
        .badge-UNDER_REVIEW { background: #cff4fc; color: #055160; }
        .badge-APPROVED { background: #d1e7dd; color: #0a3622; }
        .badge-REJECTED { background: #f8d7da; color: #58151c; }
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main-content { margin-left: 0; } }
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
        <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link active">
            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/student/apply" class="nav-link">
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

<!-- Main Content -->
<div class="main-content">
    <!-- Top Bar -->
    <div class="topbar d-flex justify-content-between align-items-center">
        <div>
            <h5 class="mb-0 fw-bold">Student Dashboard</h5>
            <small class="text-muted">Welcome back, ${sessionScope.student.fullName}!</small>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/student/apply" class="btn btn-primary rounded-pill px-4">
                <i class="fas fa-plus me-2"></i>New Application
            </a>
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

    <!-- Stats -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="card stat-card p-4" style="background: linear-gradient(135deg, #1a73e8, #0d47a1); color: white;">
                <div class="d-flex align-items-center">
                    <div class="me-3" style="font-size: 2.5rem; opacity:0.8;">📄</div>
                    <div>
                        <h2 class="mb-0 fw-bold">${totalApps}</h2>
                        <small>Total Applications</small>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-4" style="background: linear-gradient(135deg, #f59e0b, #d97706); color: white;">
                <div class="d-flex align-items-center">
                    <div class="me-3" style="font-size: 2.5rem; opacity:0.8;">⏳</div>
                    <div>
                        <h2 class="mb-0 fw-bold">${pendingCount}</h2>
                        <small>Pending</small>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-4" style="background: linear-gradient(135deg, #10b981, #059669); color: white;">
                <div class="d-flex align-items-center">
                    <div class="me-3" style="font-size: 2.5rem; opacity:0.8;">✅</div>
                    <div>
                        <h2 class="mb-0 fw-bold">${approvedCount}</h2>
                        <small>Approved</small>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-4" style="background: linear-gradient(135deg, #ef4444, #dc2626); color: white;">
                <div class="d-flex align-items-center">
                    <div class="me-3" style="font-size: 2.5rem; opacity:0.8;">❌</div>
                    <div>
                        <h2 class="mb-0 fw-bold">${rejectedCount}</h2>
                        <small>Rejected</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Applications Table -->
    <div class="table-card p-4 mb-4">
        <h6 class="fw-bold mb-4"><i class="fas fa-list me-2 text-primary"></i>My Applications</h6>
        <c:choose>
            <c:when test="${empty applications}">
                <div class="text-center py-5">
                    <div style="font-size: 4rem;">📋</div>
                    <h5 class="text-muted mt-3">No applications yet</h5>
                    <a href="${pageContext.request.contextPath}/student/apply" class="btn btn-primary mt-2">Apply Now</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>App. No</th><th>Course</th><th>Applied On</th><th>Status</th><th>Fee</th><th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${applications}">
                            <tr>
                                <td><code>${app.applicationNumber}</code></td>
                                <td>
                                    <div class="fw-semibold">${app.courseName}</div>
                                    <small class="text-muted">${app.courseCode}</small>
                                </td>
                                <td><fmt:formatDate value="${app.appliedAt}" pattern="dd MMM yyyy"/></td>
                                <td>
                                    <span class="badge-status badge-${app.status}">${app.status}</span>
                                </td>
                                <td>
                                    <span class="fw-semibold">₹<fmt:formatNumber value="${app.courseFees}" pattern="#,##0"/></span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/student/payment?appId=${app.id}" class="btn btn-sm btn-success rounded-pill">
                                        <i class="fas fa-credit-card me-1"></i>Pay Fee
                                    </a>
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Payment History -->
    <div class="table-card p-4">
        <h6 class="fw-bold mb-4"><i class="fas fa-receipt me-2 text-success"></i>Payment History</h6>
        <c:choose>
            <c:when test="${empty payments}">
                <p class="text-muted text-center py-3">No payments yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr><th>Transaction ID</th><th>Course</th><th>Amount</th><th>Mode</th><th>Date</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pay" items="${payments}">
                            <tr>
                                <td><code>${pay.transactionId}</code></td>
                                <td>${pay.courseName}</td>
                                <td class="fw-bold text-success">₹<fmt:formatNumber value="${pay.amount}" pattern="#,##0"/></td>
                                <td>${pay.paymentMode}</td>
                                <td><fmt:formatDate value="${pay.paymentDate}" pattern="dd MMM yyyy"/></td>
                                <td><span class="badge bg-success">${pay.paymentStatus}</span></td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
