<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${displayRole} Registration — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body {
            background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0;
            min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 24px;
            position: relative;
        }
        .bg-blob { position:fixed;border-radius:50%;filter:blur(80px);opacity:0.12;pointer-events:none; }
        .blob1 { width:500px;height:500px;background:#6366f1;top:-150px;left:-100px; }
        .blob2 { width:400px;height:400px;background:#8b5cf6;bottom:-100px;right:-80px; }
        .reg-card {
            width:100%;max-width:440px;
            background:rgba(255,255,255,0.04);
            backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);
            border:1px solid rgba(255,255,255,0.10);
            border-radius:24px;padding:48px 40px;
            box-shadow:0 32px 80px rgba(0,0,0,0.4);
            position:relative;z-index:10;
            animation:slideUp 0.6s ease-out;
        }
        @keyframes slideUp { from{opacity:0;transform:translateY(30px);}to{opacity:1;transform:translateY(0);} }
        .brand-logo { width:52px;height:52px;background:linear-gradient(135deg,#6366f1,#8b5cf6);border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;color:white;box-shadow:0 8px 20px rgba(99,102,241,0.4);margin:0 auto 20px; }
        .reg-title { color:white;font-weight:800;font-size:1.6rem;text-align:center;letter-spacing:-0.5px;margin-bottom:6px; }
        .reg-sub { color:rgba(255,255,255,0.4);text-align:center;font-size:0.875rem;margin-bottom:32px; }
        .form-label { color:rgba(255,255,255,0.65);font-size:0.78rem;font-weight:700;text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px; }
        .input-group-text { background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-right:none;color:rgba(255,255,255,0.45);border-radius:12px 0 0 12px; }
        .form-control {
            background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-left:none;
            color:white;padding:12px 14px;border-radius:0 12px 12px 0;
        }
        .form-control::placeholder { color:rgba(255,255,255,0.2); }
        .form-control:focus { background:rgba(255,255,255,0.09);border-color:rgba(99,102,241,0.5);color:white;box-shadow:0 0 0 3px rgba(99,102,241,0.12); }
        .form-control:disabled { color:rgba(255,255,255,0.3); }
        .btn-register { background:linear-gradient(135deg,#6366f1,#8b5cf6);border:none;border-radius:12px;padding:14px;font-weight:700;font-size:0.95rem;color:white;width:100%;box-shadow:0 8px 24px rgba(99,102,241,0.35);transition:all 0.3s ease; }
        .btn-register:hover { transform:translateY(-2px);box-shadow:0 12px 32px rgba(99,102,241,0.5);color:white; }
        .divider { border-color:rgba(255,255,255,0.08);margin:28px 0; }
        .auth-link { color:#818cf8;text-decoration:none;font-weight:500;transition:color 0.2s; }
        .auth-link:hover { color:#a5b4fc; }
        .alert-success-dark { background:rgba(16,185,129,0.12);border:1px solid rgba(16,185,129,0.25);color:#34d399;border-radius:12px;padding:12px 16px;margin-bottom:20px;font-size:0.875rem;display:flex;align-items:center;gap:8px; }
    </style>
</head>
<body>
    <div class="bg-blob blob1"></div>
    <div class="bg-blob blob2"></div>

    <div class="reg-card">
        <div class="brand-logo"><i class="bi bi-person-plus-fill"></i></div>
        <h1 class="reg-title">Create Account</h1>
        <p class="reg-sub">Register as <strong style="color:#a5b4fc;">${displayRole}</strong> on EduQuiz AI</p>

        <c:if test="${not empty message}">
            <div class="alert-success-dark">
                <i class="bi bi-check-circle-fill"></i> ${message}
            </div>
        </c:if>

        <form action="/saveData" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="role" value="${signUpDto.role}" />

            <div class="mb-4">
                <label class="form-label">Registering As</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                    <input type="text" class="form-control" value="${displayRole}" disabled>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label">Full Name</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" name="username" class="form-control" placeholder="Your full name" required autofocus>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
                </div>
            </div>
            <div class="mb-5">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="Min. 6 characters" required minlength="6">
                </div>
            </div>
            <button type="submit" class="btn-register">
                <i class="bi bi-person-check me-2"></i>Create Account
            </button>
        </form>

        <hr class="divider">
        <div class="text-center" style="font-size:0.875rem;">
            <span style="color:rgba(255,255,255,0.35);">Already have an account?</span>
            <a href="/login" class="auth-link ms-1">Sign in →</a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>