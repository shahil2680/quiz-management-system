<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
    .fac-nav {
        background: rgba(10,15,30,0.92);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(255,255,255,0.08);
        padding: 10px 24px;
        position: sticky;
        top: 0;
        z-index: 1000;
        font-family: 'Inter', sans-serif;
    }
    .fac-brand {
        font-weight: 800; font-size: 1.1rem; color: white;
        text-decoration: none; display: flex; align-items: center; gap: 10px;
    }
    .fac-brand-icon {
        width: 32px; height: 32px; border-radius: 8px;
        background: linear-gradient(135deg, #6366f1, #8b5cf6);
        display: flex; align-items: center; justify-content: center;
        font-size: 0.9rem; color: white;
        box-shadow: 0 4px 10px rgba(99,102,241,0.4);
    }
    .fac-nav-link {
        color: rgba(255,255,255,0.6);
        font-weight: 500; font-size: 0.875rem;
        padding: 7px 12px; border-radius: 8px;
        text-decoration: none; display: inline-flex; align-items: center; gap: 6px;
        transition: all 0.2s;
    }
    .fac-nav-link:hover { color: white; background: rgba(255,255,255,0.08); }
    .fac-nav-link.ai-link { color: #fbbf24; }
    .fac-nav-link.ai-link:hover { background: rgba(251,191,36,0.1); color: #fde68a; }
    .fac-email {
        background: rgba(255,255,255,0.06);
        border: 1px solid rgba(255,255,255,0.1);
        border-radius: 20px;
        padding: 5px 12px;
        font-size: 0.8rem;
        color: rgba(255,255,255,0.5);
        font-family: 'Inter', sans-serif;
    }
    .fac-logout {
        background: rgba(239,68,68,0.1);
        border: 1px solid rgba(239,68,68,0.25);
        color: #f87171; border-radius: 8px;
        padding: 6px 13px; font-size: 0.82rem; font-weight: 600;
        text-decoration: none; display: inline-flex; align-items: center; gap: 5px;
        transition: all 0.2s;
    }
    .fac-logout:hover { background: rgba(239,68,68,0.2); color: #fca5a5; }
    .navbar-toggler-fac {
        background: rgba(255,255,255,0.08);
        border: 1px solid rgba(255,255,255,0.12);
        border-radius: 8px;
        padding: 6px 10px;
        color: rgba(255,255,255,0.7);
        cursor: pointer;
    }
</style>

<nav class="fac-nav d-flex align-items-center justify-content-between flex-wrap gap-2">
    <div class="d-flex align-items-center gap-3">
        <a class="fac-brand" href="Faculty">
            <div class="fac-brand-icon"><i class="bi bi-person-workspace"></i></div>
            Faculty Portal
        </a>
        <div class="d-flex flex-wrap gap-1">
            <a class="fac-nav-link" href="ShowAllStudent?name=student"><i class="bi bi-mortarboard"></i>All Students</a>
            <a class="fac-nav-link" href="createQuiz"><i class="bi bi-plus-square"></i>Create Quiz</a>
            <a class="fac-nav-link" href="manageQuizzes"><i class="bi bi-collection"></i>Manage Quizzes</a>
            <a class="fac-nav-link ai-link" href="generateQuestions"><i class="bi bi-stars"></i>AI Generate</a>
        </div>
    </div>
    <div class="d-flex align-items-center gap-2">
        <a class="fac-nav-link" href="facultyProfile"><i class="bi bi-person-circle"></i>My Profile</a>
        <span class="fac-email d-none d-md-inline">${sessionScope.userEmail}</span>
        <a class="fac-logout" href="logout"><i class="bi bi-box-arrow-right"></i>Logout</a>
    </div>
</nav>