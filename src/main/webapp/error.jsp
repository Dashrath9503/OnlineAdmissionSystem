<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body { background: #f4f6ff; display: flex; align-items: center; justify-content: center; min-height: 100vh; }</style>
</head>
<body>
<div class="text-center">
    <div style="font-size: 6rem;">😕</div>
    <h2 class="fw-bold mt-3">Oops! Something went wrong</h2>
    <p class="text-muted">The page you're looking for doesn't exist or an error occurred.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill px-4">Go Home</a>
</div>
</body>
</html>
