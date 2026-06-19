<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Admission System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --primary: #1a73e8; --secondary: #0d47a1; }
        body { font-family: 'Segoe UI', sans-serif; }
        .hero-section {
            background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .hero-section h1 { font-size: 3rem; font-weight: 700; }
        .feature-card {
            border: none;
            border-radius: 16px;
            transition: transform 0.3s, box-shadow 0.3s;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .feature-card:hover { transform: translateY(-8px); box-shadow: 0 12px 40px rgba(0,0,0,0.15); }
        .feature-icon { width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; margin: 0 auto 1rem; }
        .step-number { width: 50px; height: 50px; border-radius: 50%; background: #1a73e8; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; font-weight: bold; margin: 0 auto 1rem; }
        .navbar-brand { font-size: 1.4rem; font-weight: 700; }
        .stats-section { background: #f8f9ff; }
        .stat-box { text-align: center; padding: 2rem; }
        .stat-box h2 { font-size: 2.5rem; font-weight: 700; color: #1a73e8; }
        footer { background: #0d47a1; color: white; }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark" style="background: rgba(0,0,0,0.2); position: absolute; width: 100%; z-index: 10;">
    <div class="container">
        <a class="navbar-brand" href="#"><i class="fas fa-graduation-cap me-2"></i>AdmissionPortal</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="#features">Features</a></li>
                <li class="nav-item"><a class="nav-link" href="#courses">Courses</a></li>
                <li class="nav-item"><a class="nav-link" href="#how-it-works">How It Works</a></li>
                <li class="nav-item ms-2"><a class="btn btn-outline-light" href="${pageContext.request.contextPath}/login">Login</a></li>
                <li class="nav-item ms-2"><a class="btn btn-warning text-dark fw-bold" href="${pageContext.request.contextPath}/register">Register</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero -->
<section class="hero-section text-white">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="mb-4">Your Future Starts<br>Here 🎓</h1>
                <p class="lead mb-4">Apply online for admission to your dream course. Fast, paperless, and transparent process.</p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-warning btn-lg fw-bold px-4">
                        <i class="fas fa-user-plus me-2"></i>Apply Now
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-lg px-4">
                        <i class="fas fa-sign-in-alt me-2"></i>Track Application
                    </a>
                </div>
            </div>
            <div class="col-lg-6 d-none d-lg-flex justify-content-center">
                <div style="font-size: 12rem; opacity: 0.15;">🎓</div>
            </div>
        </div>
    </div>
</section>

<!-- Stats -->
<section class="stats-section py-5">
    <div class="container">
        <div class="row">
            <div class="col-md-3"><div class="stat-box"><h2>5+</h2><p class="text-muted">Courses Available</p></div></div>
            <div class="col-md-3"><div class="stat-box"><h2>100%</h2><p class="text-muted">Online Process</p></div></div>
            <div class="col-md-3"><div class="stat-box"><h2>24/7</h2><p class="text-muted">Portal Access</p></div></div>
            <div class="col-md-3"><div class="stat-box"><h2>Fast</h2><p class="text-muted">Result Notification</p></div></div>
        </div>
    </div>
</section>

<!-- Features -->
<section id="features" class="py-5">
    <div class="container">
        <h2 class="text-center fw-bold mb-2">Why Choose Us?</h2>
        <p class="text-center text-muted mb-5">Everything you need for a smooth admission process</p>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card feature-card p-4 text-center h-100">
                    <div class="feature-icon bg-primary bg-opacity-10 text-primary">📄</div>
                    <h5 class="fw-bold">Online Application</h5>
                    <p class="text-muted">Fill your admission form online from anywhere, anytime.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card p-4 text-center h-100">
                    <div class="feature-icon bg-success bg-opacity-10 text-success">📁</div>
                    <h5 class="fw-bold">Document Upload</h5>
                    <p class="text-muted">Upload marksheets and ID proof digitally. No physical copies needed.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card p-4 text-center h-100">
                    <div class="feature-icon bg-warning bg-opacity-10 text-warning">💳</div>
                    <h5 class="fw-bold">Online Fee Payment</h5>
                    <p class="text-muted">Pay admission fees securely online. Instant receipt via email.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card p-4 text-center h-100">
                    <div class="feature-icon bg-info bg-opacity-10 text-info">📧</div>
                    <h5 class="fw-bold">Email Notifications</h5>
                    <p class="text-muted">Get instant updates on your application status via email.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card p-4 text-center h-100">
                    <div class="feature-icon bg-danger bg-opacity-10 text-danger">🔍</div>
                    <h5 class="fw-bold">Application Tracking</h5>
                    <p class="text-muted">Track your application status in real-time from your dashboard.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card p-4 text-center h-100">
                    <div class="feature-icon bg-secondary bg-opacity-10 text-secondary">🔒</div>
                    <h5 class="fw-bold">Secure & Safe</h5>
                    <p class="text-muted">Your data is encrypted and stored securely.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- How it Works -->
<section id="how-it-works" class="py-5 bg-light">
    <div class="container">
        <h2 class="text-center fw-bold mb-2">How It Works</h2>
        <p class="text-center text-muted mb-5">4 simple steps to complete your admission</p>
        <div class="row g-4 text-center">
            <div class="col-md-3">
                <div class="step-number">1</div>
                <h6 class="fw-bold">Register</h6>
                <p class="text-muted small">Create your account with basic details</p>
            </div>
            <div class="col-md-3">
                <div class="step-number">2</div>
                <h6 class="fw-bold">Fill Form</h6>
                <p class="text-muted small">Select course and fill application form</p>
            </div>
            <div class="col-md-3">
                <div class="step-number">3</div>
                <h6 class="fw-bold">Upload Docs</h6>
                <p class="text-muted small">Upload required documents digitally</p>
            </div>
            <div class="col-md-3">
                <div class="step-number">4</div>
                <h6 class="fw-bold">Pay Fees</h6>
                <p class="text-muted small">Pay fees online and get confirmation</p>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="py-4">
    <div class="container text-center">
        <p class="mb-0">&copy; 2024 Online Admission System. Built with Java Servlet + JSP + JDBC</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
