<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Student Results — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0; min-height: 100vh; padding: 36px 24px 60px; }
        .page-container { max-width: 1200px; margin: 0 auto; }
        .page-header { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; margin-bottom: 28px; }
        .page-header h1 { font-weight: 800; font-size: 1.5rem; color: white; margin: 0; }
        .btn-back { background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);color:rgba(255,255,255,0.6);border-radius:10px;padding:9px 16px;font-size:0.85rem;font-weight:500;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:all 0.2s; }
        .btn-back:hover { background:rgba(255,255,255,0.09);color:white; }
        .table-wrap { background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:18px;overflow:hidden; }
        .dark-table { width:100%;border-collapse:separate;border-spacing:0; }
        .dark-table thead tr { background:rgba(255,255,255,0.04); }
        .dark-table thead th { padding:13px 16px;font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:rgba(255,255,255,0.35);border-bottom:1px solid rgba(255,255,255,0.07);text-align:center; }
        .dark-table thead th:first-child { text-align:left; }
        .dark-table tbody tr { border-bottom:1px solid rgba(255,255,255,0.05);transition:background 0.2s; }
        .dark-table tbody tr:last-child { border-bottom:none; }
        .dark-table tbody tr:hover { background:rgba(255,255,255,0.03); }
        .dark-table td { padding:14px 16px;font-size:0.875rem;color:#e2e8f0;vertical-align:middle;text-align:center; }
        .dark-table td:first-child { text-align:left; }
        .avatar { width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.8rem;color:white;flex-shrink:0; }
        .user-name { font-weight:600;color:white; }
        .score-val { font-weight:800;font-size:1.2rem;color:white; }
        .pct-wrap { display:flex;align-items:center;gap:8px;justify-content:center; }
        .pct-bar { height:7px;width:80px;background:rgba(255,255,255,0.08);border-radius:4px;overflow:hidden; }
        .pct-pass { background:linear-gradient(90deg,#10b981,#34d399);height:100%;border-radius:4px; }
        .pct-fail { background:linear-gradient(90deg,#ef4444,#f87171);height:100%;border-radius:4px; }
        .pass-b { display:inline-flex;align-items:center;gap:4px;background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.25);color:#34d399;border-radius:20px;padding:4px 12px;font-size:0.75rem;font-weight:700; }
        .fail-b { display:inline-flex;align-items:center;gap:4px;background:rgba(239,68,68,0.15);border:1px solid rgba(239,68,68,0.25);color:#f87171;border-radius:20px;padding:4px 12px;font-size:0.75rem;font-weight:700; }
        .email-text { color:rgba(255,255,255,0.4);font-size:0.8rem; }
        .date-text { color:rgba(255,255,255,0.35);font-size:0.8rem; }
        .empty-state { text-align:center;padding:72px 24px;color:rgba(255,255,255,0.3); }
        .empty-state i { font-size:3rem;opacity:0.3;display:block;margin-bottom:16px; }
    </style>
</head>
<body>
    <div class="page-container">
        <div class="page-header">
            <h1><i class="bi bi-journal-text me-2" style="color:#818cf8;"></i>All Student Quiz Results</h1>
            <c:choose>
                <c:when test="${sessionScope.role eq 'Admin'}">
                    <a href="Admin" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Dashboard</a>
                </c:when>
                <c:otherwise>
                    <a href="Faculty" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Dashboard</a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="table-wrap">
            <c:if test="${empty allResults}">
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <p class="mb-0">No students have taken any quizzes yet.</p>
                </div>
            </c:if>
            <c:if test="${not empty allResults}">
                <table class="dark-table">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Email</th>
                            <th>Date &amp; Time</th>
                            <th>Score</th>
                            <th>Questions</th>
                            <th>Percentage</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="result" items="${allResults}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="avatar">${result.user.username.substring(0,1).toUpperCase()}</div>
                                        <span class="user-name">${result.user.username}</span>
                                    </div>
                                </td>
                                <td class="email-text">${result.user.email}</td>
                                <td class="date-text">${result.attemptDate}</td>
                                <td><span class="score-val">${result.score}</span></td>
                                <td style="color:rgba(255,255,255,0.5);">${result.totalQuestions}</td>
                                <td>
                                    <div class="pct-wrap">
                                        <div class="pct-bar">
                                            <div class="${result.percentage >= 40 ? 'pct-pass' : 'pct-fail'}" style="width:${result.percentage}%;"></div>
                                        </div>
                                        <span style="font-weight:700;font-size:0.85rem;color:${result.percentage >= 40 ? '#34d399' : '#f87171'};">${result.percentage}%</span>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${result.percentage >= 40}">
                                            <span class="pass-b"><i class="bi bi-check-circle-fill"></i>Pass</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="fail-b"><i class="bi bi-x-circle-fill"></i>Fail</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>