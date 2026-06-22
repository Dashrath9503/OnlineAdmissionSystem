<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Applications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #0d47a1, #1565c0); min-height: 100vh; width: 260px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 260px; padding: 25px; }
        .table-card { background: white; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .badge-PENDING { background: #fff3cd; color: #856404; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-UNDER_REVIEW { background: #cff4fc; color: #055160; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-APPROVED { background: #d1e7dd; color: #0a3622; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-REJECTED { background: #f8d7da; color: #58151c; padding: 5px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .filter-btn.active { background: #1a73e8; color: white; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand text-white">
        <i class="fas fa-shield-alt me-2"></i><strong>Admin Panel</strong>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/applications" class="nav-link active"><i class="fas fa-file-alt me-2"></i>Applications</a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=PENDING" class="nav-link"><i class="fas fa-clock me-2"></i>Pending Review</a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=APPROVED" class="nav-link"><i class="fas fa-check-circle me-2"></i>Approved</a>
        <a href="${pageContext.request.contextPath}/admin/courses" class="nav-link"><i class="fas fa-book me-2"></i>Manage Courses</a>
        <hr style="border-color: rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h5 class="fw-bold mb-0">All Applications</h5>
            <small class="text-muted">Review and update application statuses</small>
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

    <!-- Filter Buttons -->
    <div class="d-flex gap-2 mb-4 flex-wrap">
        <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-outline-secondary rounded-pill filter-btn ${activeFilter == 'ALL' ? 'active' : ''}">All</a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=PENDING" class="btn btn-outline-warning rounded-pill filter-btn ${activeFilter == 'PENDING' ? 'active' : ''}">Pending</a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=UNDER_REVIEW" class="btn btn-outline-info rounded-pill filter-btn ${activeFilter == 'UNDER_REVIEW' ? 'active' : ''}">Under Review</a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=APPROVED" class="btn btn-outline-success rounded-pill filter-btn ${activeFilter == 'APPROVED' ? 'active' : ''}">Approved</a>
        <a href="${pageContext.request.contextPath}/admin/applications?status=REJECTED" class="btn btn-outline-danger rounded-pill filter-btn ${activeFilter == 'REJECTED' ? 'active' : ''}">Rejected</a>
    </div>

    <div class="table-card p-4">
        <div class="mb-3">
            <input type="text" class="form-control w-25" id="searchInput" placeholder="🔍 Search by name or app no..." onkeyup="filterTable()">
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle" id="appTable">
                <thead class="table-light">
                    <tr><th>App No.</th><th>Student</th><th>Course</th><th>10th %</th><th>12th %</th><th>Applied</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="app" items="${applications}">
                    <tr>
                        <td><code>${app.applicationNumber}</code></td>
                        <td>
                            <div class="fw-semibold">${app.studentName}</div>
                            <small class="text-muted">${app.studentEmail}</small>
                        </td>
                        <td>${app.courseName}</td>
                        <td>${app.tenthPercent}%</td>
                        <td>${app.twelfthPercent}%</td>
                        <td><fmt:formatDate value="${app.appliedAt}" pattern="dd MMM yy"/></td>
                        <td><span class="badge-${app.status}">${app.status}</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/applications?view=${app.id}" class="btn btn-sm btn-primary rounded-pill">
                                <i class="fas fa-eye"></i>
                            </a>
                            <!-- Quick Action -->
                            <button class="btn btn-sm btn-outline-success rounded-pill ms-1"
                                onclick="quickAction(${app.id}, 'APPROVED')" title="Approve">✓</button>
                            <button class="btn btn-sm btn-outline-danger rounded-pill ms-1"
                                onclick="quickAction(${app.id}, 'REJECTED')" title="Reject">✗</button>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Quick Action Modal -->
<div class="modal fade" id="actionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 rounded-4">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold" id="actionModalTitle">Update Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/applications" method="post">
                <div class="modal-body">
                    <input type="hidden" name="appId" id="modalAppId">
                    <input type="hidden" name="status" id="modalStatus">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Remarks (Optional)</label>
                        <textarea class="form-control" name="remarks" rows="3" placeholder="Add remarks for the student..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4" id="actionSubmitBtn">Confirm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function quickAction(appId, status) {
    document.getElementById('modalAppId').value = appId;
    document.getElementById('modalStatus').value = status;
    document.getElementById('actionModalTitle').textContent = status === 'APPROVED' ? '✅ Approve Application' : '❌ Reject Application';
    document.getElementById('actionSubmitBtn').className = 'btn rounded-pill px-4 ' + (status === 'APPROVED' ? 'btn-success' : 'btn-danger');
    new bootstrap.Modal(document.getElementById('actionModal')).show();
}
function filterTable() {
    const q = document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('#appTable tbody tr').forEach(row => {
        row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
