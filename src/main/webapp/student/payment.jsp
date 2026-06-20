<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Fee Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6ff; }
        .sidebar { background: linear-gradient(180deg, #1a73e8, #0d47a1); min-height: 100vh; width: 250px; position: fixed; left: 0; top: 0; z-index: 100; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 20px; border-radius: 10px; margin: 4px 10px; transition: all 0.3s; }
        .sidebar .nav-link:hover { background: rgba(255,255,255,0.2); color: white; }
        .sidebar .brand { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        .payment-card { border: none; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }
        .form-control { border-radius: 10px; border: 2px solid #e9ecef; }
        .form-control:focus { border-color: #1a73e8; box-shadow: none; }
        .payment-method { border: 2px solid #e9ecef; border-radius: 12px; padding: 15px; cursor: pointer; transition: all 0.3s; }
        .payment-method:hover, .payment-method.selected { border-color: #1a73e8; background: #f0f7ff; }
        .card-input { background: linear-gradient(135deg, #1a73e8, #0d47a1); border-radius: 16px; padding: 25px; color: white; }
        .secure-badge { background: #d1fae5; color: #065f46; padding: 6px 15px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand text-white">
        <i class="fas fa-graduation-cap me-2"></i><strong>AdmissionPortal</strong>
    </div>
    <nav class="mt-3">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link">
            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/student/apply" class="nav-link">
            <i class="fas fa-file-alt me-2"></i> Apply for Admission
        </a>
        <hr style="border-color: rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="fas fa-sign-out-alt me-2"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold">Fee Payment</h5>
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-secondary rounded-pill">
                    <i class="fas fa-arrow-left me-2"></i>Back
                </a>
            </div>

            <c:if test="${alreadyPaid}">
                <div class="alert alert-success rounded-3 text-center py-4">
                    <i class="fas fa-check-circle fa-3x text-success mb-3 d-block"></i>
                    <h5>Fee Already Paid!</h5>
                    <p class="mb-0">You have already paid the admission fee for this application.</p>
                </div>
            </c:if>

            <c:if test="${not alreadyPaid}">
            <!-- Application Summary -->
            <div class="card mb-4 p-4" style="border: none; border-radius: 16px; background: linear-gradient(135deg, #1a73e8, #0d47a1); color: white;">
                <h6 class="opacity-75 mb-3"><i class="fas fa-file-alt me-2"></i>Application Summary</h6>
                <div class="row">
                    <div class="col-6">
                        <small class="opacity-75">Application No.</small>
                        <p class="fw-bold mb-2">${application.applicationNumber}</p>
                        <small class="opacity-75">Course</small>
                        <p class="fw-bold mb-0">${application.courseName}</p>
                    </div>
                    <div class="col-6 text-end">
                        <small class="opacity-75">Amount to Pay</small>
                        <h2 class="fw-bold">₹<fmt:formatNumber value="${application.courseFees}" pattern="#,##0"/></h2>
                        <span class="badge bg-warning text-dark">${application.status}</span>
                    </div>
                </div>
            </div>

            <div class="payment-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h6 class="fw-bold mb-0"><i class="fas fa-credit-card me-2 text-primary"></i>Payment Details</h6>
                    <span class="secure-badge"><i class="fas fa-lock me-1"></i>Secure Payment</span>
                </div>

                <form action="${pageContext.request.contextPath}/student/payment" method="post" id="paymentForm">
                    <input type="hidden" name="appId" value="${application.id}">
                    <input type="hidden" name="amount" value="${application.courseFees}">

                    <!-- Payment Method -->
                    <label class="form-label fw-semibold mb-3">Select Payment Method</label>
                    <div class="row g-3 mb-4">
                        <div class="col-4">
                            <div class="payment-method selected text-center" onclick="selectPayment('ONLINE', this)">
                                <i class="fas fa-globe fa-2x text-primary mb-2"></i>
                                <p class="mb-0 small fw-semibold">Online</p>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="payment-method text-center" onclick="selectPayment('CASH', this)">
                                <i class="fas fa-money-bill fa-2x text-success mb-2"></i>
                                <p class="mb-0 small fw-semibold">Cash</p>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="payment-method text-center" onclick="selectPayment('DD', this)">
                                <i class="fas fa-university fa-2x text-warning mb-2"></i>
                                <p class="mb-0 small fw-semibold">DD / Cheque</p>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" name="paymentMode" id="paymentMode" value="ONLINE">

                    <!-- Mock Card UI -->
                    <div id="cardSection">
                        <div class="card-input mb-4">
                            <div class="d-flex justify-content-between mb-3">
                                <span class="opacity-75">DEMO CARD</span>
                                <i class="fab fa-cc-visa fa-2x"></i>
                            </div>
                            <p class="fs-5 letter-spacing">4532 •••• •••• 1234</p>
                            <div class="d-flex justify-content-between">
                                <div>
                                    <small class="opacity-75">CARD HOLDER</small>
                                    <p class="mb-0 fw-bold">${sessionScope.student.fullName}</p>
                                </div>
                                <div class="text-end">
                                    <small class="opacity-75">EXPIRES</small>
                                    <p class="mb-0 fw-bold">12/26</p>
                                </div>
                            </div>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-8">
                                <label class="form-label fw-semibold">Card Number</label>
                                <input type="text" class="form-control" placeholder="4532 1234 5678 9012" maxlength="19">
                            </div>
                            <div class="col-4">
                                <label class="form-label fw-semibold">CVV</label>
                                <input type="password" class="form-control" placeholder="•••" maxlength="3">
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold">Card Holder Name</label>
                                <input type="text" class="form-control" value="${sessionScope.student.fullName}">
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold">Expiry Date</label>
                                <input type="text" class="form-control" placeholder="MM/YY">
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted">Total Amount</span>
                        <h4 class="fw-bold text-primary mb-0">₹<fmt:formatNumber value="${application.courseFees}" pattern="#,##0"/></h4>
                    </div>

                    <button type="submit" class="btn btn-success w-100 py-3 fw-bold fs-5 rounded-3" onclick="return confirmPayment()">
                        <i class="fas fa-lock me-2"></i>Pay ₹<fmt:formatNumber value="${application.courseFees}" pattern="#,##0"/> Now
                    </button>
                    <p class="text-center text-muted small mt-3">
                        <i class="fas fa-shield-alt me-1"></i>This is a demo payment. No real money will be charged.
                    </p>
                </form>
            </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function selectPayment(mode, el) {
    document.querySelectorAll('.payment-method').forEach(e => e.classList.remove('selected'));
    el.classList.add('selected');
    document.getElementById('paymentMode').value = mode;
    document.getElementById('cardSection').style.display = mode === 'ONLINE' ? 'block' : 'none';
}
function confirmPayment() {
    return confirm('Confirm fee payment? This action cannot be undone.');
}
</script>
</body>
</html>
