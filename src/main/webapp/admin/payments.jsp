<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Records</title>
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
        .form-control { border-radius: 10px; border: 2px solid #e9ecef; }
    </style>
</head>
<body>
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
        <a href="${pageContext.request.contextPath}/admin/courses" class="nav-link">
            <i class="fas fa-book me-2"></i>Manage Courses
        </a>
        <a href="${pageContext.request.contextPath}/admin/payments" class="nav-link active">
            <i class="fas fa-rupee-sign me-2"></i>Payments
        </a>
        <hr style="border-color: rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="fas fa-sign-out-alt me-2"></i>Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="mb-4">
        <h5 class="fw-bold mb-0">Payment Records</h5>
        <small class="text-muted">All fee payment transactions</small>
    </div>

    <!-- Revenue Card -->
    <div class="card p-4 mb-4" 
         style="background: linear-gradient(135deg,#10b981,#059669); color:white;">
        <div class="d-flex align-items-center">
            <i class="fas fa-rupee-sign fa-3x me-3 opacity-75"></i>
            <div>
                <small class="opacity-75">Total Revenue Collected</small>
                <h2 class="fw-bold mb-0">
                    ₹<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/>
                </h2>
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="card p-4">
        <div class="mb-3">
            <input type="text" class="form-control w-25"
                   placeholder="🔍 Search..."
                   onkeyup="filterTable(this)">
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle" id="payTable">
                <thead class="table-light">
                    <tr>
                        <th>Transaction ID</th>
                        <th>Student</th>
                        <th>App No.</th>
                        <th>Course</th>
                        <th>Amount</th>
                        <th>Mode</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pay" items="${payments}">
                    <tr>
                        <td><code>${pay.transactionId}</code></td>
                        <td class="fw-semibold">${pay.studentName}</td>
                        <td><code>${pay.applicationNumber}</code></td>
                        <td>${pay.courseName}</td>
                        <td class="fw-bold text-success">
                            ₹<fmt:formatNumber value="${pay.amount}" pattern="#,##0"/>
                        </td>
                        <td>${pay.paymentMode}</td>
                        <td>
                            <fmt:formatDate value="${pay.paymentDate}" 
                                           pattern="dd MMM yyyy"/>
                        </td>
                        <td>
                            <span class="badge ${pay.paymentStatus == 'SUCCESS' ? 
                                  'bg-success' : 'bg-danger'}">
                                ${pay.paymentStatus}
                            </span>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function filterTable(input) {
    const q = input.value.toLowerCase();
    document.querySelectorAll('#payTable tbody tr').forEach(row => {
        row.style.display =
            row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>