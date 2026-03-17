<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — EduQuiz AI Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body {
            min-height: 100vh;
            font-family: 'Inter', sans-serif;
            background: #0a0f1e;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        /* Animated background blobs */
        .bg-blob {
            position: fixed;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.15;
            animation: float 8s ease-in-out infinite;
            pointer-events: none;
        }
        .blob1 { width: 500px; height: 500px; background: #6366f1; top: -150px; left: -100px; animation-delay: 0s; }
        .blob2 { width: 400px; height: 400px; background: #8b5cf6; bottom: -100px; right: -80px; animation-delay: 3s; }
        .blob3 { width: 300px; height: 300px; background: #06b6d4; top: 50%; left: 50%; animation-delay: 1.5s; }
        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-30px) scale(1.05); }
        }
        .login-card {
            width: 100%;
            max-width: 440px;
            background: rgba(255,255,255,0.04);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid rgba(255,255,255,0.10);
            border-radius: 24px;
            padding: 48px 40px;
            box-shadow: 0 32px 80px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.1);
            position: relative;
            z-index: 10;
            animation: slideUp 0.6s ease-out;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .brand-logo {
            width: 52px; height: 52px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; color: white;
            box-shadow: 0 8px 20px rgba(99,102,241,0.4);
            margin: 0 auto 20px;
        }
        .login-title {
            color: #ffffff;
            font-weight: 700;
            font-size: 1.75rem;
            text-align: center;
            letter-spacing: -0.5px;
            margin-bottom: 6px;
        }
        .login-subtitle {
            color: rgba(255,255,255,0.45);
            text-align: center;
            font-size: 0.9rem;
            margin-bottom: 32px;
        }
        .form-label {
            color: rgba(255,255,255,0.75);
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .input-group-text {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.12);
            border-right: none;
            color: rgba(255,255,255,0.5);
        }
        .form-control, .form-select {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.12);
            border-left: none;
            color: white;
            padding: 12px 16px;
            font-size: 0.95rem;
            transition: all 0.3s;
        }
        .form-control::placeholder { color: rgba(255,255,255,0.25); }
        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.10);
            border-color: rgba(99,102,241,0.6);
            color: white;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
        }
        .form-select option { background: #1e1b3a; color: white; }
        .input-group-text.rounded-start { border-radius: 12px 0 0 12px !important; }
        .form-control.rounded-end, .form-select.rounded-end { border-radius: 0 12px 12px 0 !important; }
        .btn-login {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 700;
            font-size: 0.95rem;
            color: white;
            letter-spacing: 0.3px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 24px rgba(99,102,241,0.35);
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(99,102,241,0.5);
            color: white;
        }
        .btn-login:active { transform: translateY(0); }
        .auth-link { color: #818cf8; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .auth-link:hover { color: #a5b4fc; }
        .divider { border-color: rgba(255,255,255,0.08); margin: 28px 0; }
        .role-pills { display: flex; gap: 8px; margin-bottom: 24px; }
        .role-pill {
            flex: 1; text-align: center; padding: 10px 8px; border-radius: 10px;
            background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.10);
            color: rgba(255,255,255,0.5); font-size: 0.8rem; font-weight: 600;
            cursor: pointer; transition: all 0.3s;
        }
        .role-pill.active, .role-pill:hover {
            background: rgba(99,102,241,0.2); border-color: #6366f1; color: #a5b4fc;
        }
        .role-pill i { display: block; font-size: 1.2rem; margin-bottom: 4px; }
    </style>
</head>
<body>
    <!-- Animated background -->
    <div class="bg-blob blob1"></div>
    <div class="bg-blob blob2"></div>
    <div class="bg-blob blob3"></div>

    <div class="login-card">
        <div class="brand-logo"><i class="bi bi-mortarboard-fill"></i></div>
        <h1 class="login-title">Welcome Back</h1>
        <p class="login-subtitle">Sign in to continue to EduQuiz AI Platform</p>

        <c:if test="${not empty error}">
            <div class="alert d-flex align-items-center gap-2 mb-4" style="background:rgba(239,68,68,0.15);border:1px solid rgba(239,68,68,0.3);color:#fca5a5;border-radius:12px;font-size:0.88rem;">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <form action="checkLogin" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <div class="mb-4">
                <label class="form-label">Sign in as</label>
                <div class="input-group">
                    <span class="input-group-text rounded-start"><i class="bi bi-person-badge"></i></span>
                    <select name="role" class="form-select rounded-end" id="roleSelect" required>
                        <option value="student">Student</option>
                        <option value="faculty">Faculty</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text rounded-start"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control rounded-end" placeholder="you@example.com" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text rounded-start"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" id="passwordInput" class="form-control" placeholder="Your password" required minlength="6" style="border-radius:0;">
                    <button type="button" class="input-group-text" style="border-left:none;border-radius:0 12px 12px 0;cursor:pointer;" onclick="togglePwd()">
                        <i class="bi bi-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <div class="d-grid mt-2">
                <button type="submit" class="btn btn-login">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Sign In Securely
                </button>
            </div>
        </form>

        <hr class="divider">

        <div class="text-center" style="font-size:0.88rem;">
            <a href="forget" class="auth-link d-block mb-2"><i class="bi bi-key me-1"></i>Forgot your password?</a>
            <span style="color:rgba(255,255,255,0.3);">Don't have an account?</span>
            <a href="javascript:void(0);" onclick="redirectToSignup()" class="auth-link ms-1">Create account →</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function redirectToSignup() {
            const role = document.querySelector('select[name="role"]')?.value || 'student';
            window.location.href = 'signUp?role=' + encodeURIComponent(role);
        }
        function togglePwd() {
            const input = document.getElementById('passwordInput');
            const icon = document.getElementById('eyeIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }
    </script>
</body>
</html>