<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #0d47a1, #1565c0); min-height: 100vh; width: 260px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 260px; padding: 25px; }
        .stat-card { border: none; border-radius: 16px; color: white; padding: 20px; }
        .table-card { background: white; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .topbar { background: white; border-radius: 16px; padding: 15px 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); margin-bottom: 25px; }
        .badge-PENDING { background: #fff3cd; color: #856404; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-UNDER_REVIEW { background: #cff4fc; color: #055160; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-APPROVED { background: #d1e7dd; color: #0a3622; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-REJECTED { background: #f8d7da; color: #58151c; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
    </style>
</head>
<body>
<!-- Admin Sidebar -->
<div class="sidebar">
    <div class="brand text-white">
        <i class="fas fa-shield-alt me-2"></i><strong>Admin Panel</strong>
        <p class="small mb-0 mt-1 opacity-75">System Administrator</p>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
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
        <a href="${pageContext.request.contextPath}/admin/courses" class="nav-link">
            <i class="fas fa-book me-2"></i>Manage Courses
        </a>
        <hr style="border-color: rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="fas fa-sign-out-alt me-2"></i>Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <!-- Top Bar -->
    <div class="topbar d-flex justify-content-between align-items-center">
        <div>
            <h5 class="mb-0 fw-bold">Admin Dashboard</h5>
            <small class="text-muted">Manage admissions and applications</small>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span class="badge bg-success"><i class="fas fa-circle me-1" style="font-size:0.5rem;"></i>Online</span>
            <strong>${sessionScope.adminUsername}</strong>
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

    <!-- Stat Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-2">
            <div class="stat-card" style="background: linear-gradient(135deg, #1a73e8, #0d47a1);">
                <div class="text-center">
                    <i class="fas fa-users fa-2x mb-2 opacity-80"></i>
                    <h3 class="fw-bold mb-0">${totalStudents}</h3>
                    <small>Students</small>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="stat-card" style="background: linear-gradient(135deg, #6366f1, #4338ca);">
                <div class="text-center">
                    <i class="fas fa-file-alt fa-2x mb-2 opacity-80"></i>
                    <h3 class="fw-bold mb-0">${totalApps}</h3>
                    <small>Total Apps</small>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="stat-card" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                <div class="text-center">
                    <i class="fas fa-clock fa-2x mb-2 opacity-80"></i>
                    <h3 class="fw-bold mb-0">${pendingApps}</h3>
                    <small>Pending</small>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="stat-card" style="background: linear-gradient(135deg, #06b6d4, #0891b2);">
                <div class="text-center">
                    <i class="fas fa-search fa-2x mb-2 opacity-80"></i>
                    <h3 class="fw-bold mb-0">${underReviewApps}</h3>
                    <small>In Review</small>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="stat-card" style="background: linear-gradient(135deg, #10b981, #059669);">
                <div class="text-center">
                    <i class="fas fa-check-circle fa-2x mb-2 opacity-80"></i>
                    <h3 class="fw-bold mb-0">${approvedApps}</h3>
                    <small>Approved</small>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="stat-card" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                <div class="text-center">
                    <i class="fas fa-times-circle fa-2x mb-2 opacity-80"></i>
                    <h3 class="fw-bold mb-0">${rejectedApps}</h3>
                    <small>Rejected</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Revenue + Chart -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="table-card p-4 text-center">
                <i class="fas fa-rupee-sign fa-3x text-success mb-3"></i>
                <h6 class="text-muted">Total Revenue Collected</h6>
                <h2 class="fw-bold text-success">₹<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></h2>
                <small class="text-muted">From successful payments</small>
            </div>
        </div>
        <div class="col-md-8">
            <div class="table-card p-4">
                <h6 class="fw-bold mb-3"><i class="fas fa-chart-pie me-2 text-primary"></i>Application Status Overview</h6>
                <canvas id="statusChart" height="120"></canvas>
            </div>
        </div>
    </div>

    <!-- Recent Applications -->
    <div class="table-card p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h6 class="fw-bold mb-0"><i class="fas fa-list me-2 text-primary"></i>Recent Applications</h6>
            <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-outline-primary btn-sm rounded-pill">View All</a>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr><th>App No.</th><th>Student</th><th>Course</th><th>Applied</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="app" items="${recentApplications}" varStatus="i">
                    <c:if test="${i.index < 10}">
                    <tr>
                        <td><code>${app.applicationNumber}</code></td>
                        <td>
                            <div class="fw-semibold">${app.studentName}</div>
                            <small class="text-muted">${app.studentEmail}</small>
                        </td>
                        <td>${app.courseName}</td>
                        <td><fmt:formatDate value="${app.appliedAt}" pattern="dd MMM yyyy"/></td>
                        <td><span class="badge-${app.status}">${app.status}</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/applications?view=${app.id}" class="btn btn-sm btn-primary rounded-pill">
                                <i class="fas fa-eye me-1"></i>Review
                            </a>
                        </td>
                    </tr>
                    </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
const ctx = document.getElementById('statusChart').getContext('2d');
new Chart(ctx, {
    type: 'doughnut',
    data: {
        labels: ['Pending', 'Under Review', 'Approved', 'Rejected'],
        datasets: [{
            data: [${pendingApps}, ${underReviewApps}, ${approvedApps}, ${rejectedApps}],
            backgroundColor: ['#f59e0b', '#06b6d4', '#10b981', '#ef4444'],
            borderWidth: 0, hoverOffset: 4
        }]
    },
    options: { plugins: { legend: { position: 'right' } }, cutout: '65%' }
});
</script>
</body>
</html>
