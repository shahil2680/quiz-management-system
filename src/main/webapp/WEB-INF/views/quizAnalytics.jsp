<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Analytics — ${quiz.quizName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0; min-height: 100vh; padding: 36px 24px 60px; }
        .page-container { max-width: 1100px; margin: 0 auto; }
        .page-header { margin-bottom: 36px; }
        .page-header h1 { font-weight: 800; font-size: 1.6rem; color: white; margin-bottom: 4px; }
        .page-header p { color: rgba(255,255,255,0.4); font-size: 0.875rem; margin: 0; }
        .btn-back { background:rgba(255,255,255,0.05);border:1px solid rgba(255,255,255,0.1);color:rgba(255,255,255,0.6);border-radius:10px;padding:9px 16px;font-size:0.85rem;font-weight:500;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:all 0.2s; }
        .btn-back:hover { background:rgba(255,255,255,0.09);color:white; }
        /* KPI STAT CARDS */
        .stat-card { background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.09);border-radius:16px;padding:24px;text-align:center; }
        .stat-num { font-size:2.4rem;font-weight:800;color:white;line-height:1;margin-bottom:4px; }
        .stat-label { color:rgba(255,255,255,0.4);font-size:0.8rem;font-weight:600;text-transform:uppercase;letter-spacing:1px; }
        /* SECTION HEADING */
        .section-label { font-size:0.72rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:rgba(255,255,255,0.35);margin:32px 0 16px; }
        /* CHART CARD */
        .chart-card { background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:18px;padding:28px;margin-bottom:20px; }
        .chart-card h6 { font-weight:700;font-size:0.95rem;color:white;margin-bottom:6px; }
        .chart-card .q-text { color:rgba(255,255,255,0.55);font-size:0.85rem;margin-bottom:20px; }
        /* CORRECT BAR */
        .bar-row { display:flex;align-items:center;gap:12px;margin-bottom:10px; }
        .bar-label { width:60px;font-size:0.75rem;font-weight:700;color:rgba(255,255,255,0.5);flex-shrink:0; }
        .bar-track { flex:1;height:28px;background:rgba(255,255,255,0.06);border-radius:8px;overflow:hidden;position:relative; }
        .bar-fill-pass { height:100%;background:linear-gradient(90deg,#10b981,#34d399);border-radius:8px;display:flex;align-items:center;justify-content:flex-end;padding-right:8px;font-size:0.75rem;font-weight:700;color:white;transition:width 1s ease; }
        .bar-fill-fail { height:100%;background:linear-gradient(90deg,#ef4444,#f87171);border-radius:8px;display:flex;align-items:center;justify-content:flex-end;padding-right:8px;font-size:0.75rem;font-weight:700;color:white;transition:width 1s ease; }
        /* RESULT TABLE */
        .dark-table { width:100%;border-collapse:separate;border-spacing:0; }
        .dark-table thead th { padding:12px 16px;font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:rgba(255,255,255,0.35);border-bottom:1px solid rgba(255,255,255,0.07); }
        .dark-table tbody tr { border-bottom:1px solid rgba(255,255,255,0.05);transition:background 0.2s; }
        .dark-table tbody tr:last-child { border-bottom:none; }
        .dark-table tbody tr:hover { background:rgba(255,255,255,0.03); }
        .dark-table td { padding:13px 16px;font-size:0.875rem;color:#e2e8f0;vertical-align:middle; }
        .pass-b { display:inline-flex;align-items:center;gap:4px;background:rgba(16,185,129,0.15);border:1px solid rgba(16,185,129,0.25);color:#34d399;border-radius:20px;padding:3px 10px;font-size:0.75rem;font-weight:700; }
        .fail-b { display:inline-flex;align-items:center;gap:4px;background:rgba(239,68,68,0.15);border:1px solid rgba(239,68,68,0.25);color:#f87171;border-radius:20px;padding:3px 10px;font-size:0.75rem;font-weight:700; }
        .empty-state { text-align:center;padding:60px;color:rgba(255,255,255,0.3); }
        .empty-state i { font-size:3rem;opacity:0.3;display:block;margin-bottom:16px; }
    </style>
</head>
<body>
    <div class="page-container">
        <!-- HEADER -->
        <div class="page-header d-flex align-items-start justify-content-between flex-wrap gap-3">
            <div>
                <h1><i class="bi bi-bar-chart-fill me-2" style="color:#818cf8;"></i>${quiz.quizName} — Analytics</h1>
                <p>View response summary, per-question performance, and all student results</p>
            </div>
            <a href="manageQuizzes" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Quizzes</a>
        </div>

        <!-- KPI CARDS -->
        <div class="row g-4 mb-2">
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-num">${totalStudents}</div>
                    <div class="stat-label">Total Submissions</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-num">${avgPct}%</div>
                    <div class="stat-label">Avg Score</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-num">${fn:length(questions)}</div>
                    <div class="stat-label">Questions</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-num">${quiz.timeInMinutes}m</div>
                    <div class="stat-label">Time Limit</div>
                </div>
            </div>
        </div>

        <!-- PER-QUESTION ANALYTICS -->
        <p class="section-label"><i class="bi bi-list-check me-1"></i>Per-Question Performance</p>
        <c:if test="${empty questions}">
            <div class="empty-state"><i class="bi bi-inbox"></i><p>No questions found for this quiz.</p></div>
        </c:if>
        <c:forEach var="q" items="${questions}" varStatus="s">
            <div class="chart-card">
                <h6>Q${s.count}. ${q.qname}</h6>
                <p class="q-text">
                    <c:if test="${q.questionType == 'TRUE_FALSE'}">True/False</c:if>
                    <c:if test="${q.questionType == 'SHORT_ANSWER' or q.questionType == 'SUBJECTIVE'}">Short Answer</c:if>
                    <c:if test="${q.questionType == 'MCQ' or empty q.questionType}">
                        Options: A) ${q.opt1} &nbsp;·&nbsp; B) ${q.opt2}
                        <c:if test="${not empty q.opt3}">&nbsp;·&nbsp; C) ${q.opt3}</c:if>
                        <c:if test="${not empty q.opt4}">&nbsp;·&nbsp; D) ${q.opt4}</c:if>
                    </c:if>
                    &nbsp;|&nbsp; <strong style="color:#10b981">Correct: ${q.correct_Opt}</strong>
                </p>
                <c:if test="${totalStudents > 0}">
                    <div class="bar-row">
                        <span class="bar-label" style="color:#34d399;">Correct</span>
                        <div class="bar-track">
                            <div class="bar-fill-pass" style="width:${correctPct[q.qid]}%;">${correctPct[q.qid]}%</div>
                        </div>
                    </div>
                    <div class="bar-row">
                        <span class="bar-label" style="color:#f87171;">Incorrect</span>
                        <div class="bar-track">
                            <div class="bar-fill-fail" style="width:${incorrectPct[q.qid]}%;">${incorrectPct[q.qid]}%</div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${totalStudents == 0}">
                    <p style="color:rgba(255,255,255,0.3);font-size:0.82rem;">No submissions yet.</p>
                </c:if>
            </div>
        </c:forEach>

        <!-- STUDENT RESULTS TABLE -->
        <p class="section-label"><i class="bi bi-people me-1"></i>All Student Submissions</p>
        <div style="background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:18px;overflow:hidden;">
            <c:if test="${empty quizResults}">
                <div class="empty-state"><i class="bi bi-clipboard-x"></i><p>No students have submitted this quiz yet.</p></div>
            </c:if>
            <c:if test="${not empty quizResults}">
                <table class="dark-table">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Email</th>
                            <th>Score</th>
                            <th>Percentage</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${quizResults}">
                            <tr>
                                <td style="font-weight:600;color:white;">${r.user.username}</td>
                                <td style="color:rgba(255,255,255,0.45);font-size:0.82rem;">${r.user.email}</td>
                                <td style="font-weight:800;font-size:1.1rem;color:white;">${r.score}/${r.totalQuestions}</td>
                                <td>
                                    <div style="display:flex;align-items:center;gap:8px;">
                                        <div style="flex:1;height:7px;background:rgba(255,255,255,0.08);border-radius:4px;overflow:hidden;max-width:80px;">
                                            <div style="height:100%;border-radius:4px;width:${r.percentage}%;background:${r.percentage >= 40 ? 'linear-gradient(90deg,#10b981,#34d399)' : 'linear-gradient(90deg,#ef4444,#f87171)'};"></div>
                                        </div>
                                        <span style="font-weight:700;font-size:0.85rem;color:${r.percentage >= 40 ? '#34d399' : '#f87171'};">${r.percentage}%</span>
                                    </div>
                                </td>
                                <td style="color:rgba(255,255,255,0.35);font-size:0.8rem;">${r.attemptDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.percentage >= 40}"><span class="pass-b"><i class="bi bi-check-circle-fill"></i>Pass</span></c:when>
                                        <c:otherwise><span class="fail-b"><i class="bi bi-x-circle-fill"></i>Fail</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
        <div class="mt-4"><a href="manageQuizzes" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Quizzes</a></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
        // Animate bars on load
        document.addEventListener('DOMContentLoaded', () => {
            const fills = document.querySelectorAll('.bar-fill-pass, .bar-fill-fail');
            fills.forEach(f => {
                const target = f.style.width;
                f.style.width = '0%';
                setTimeout(() => { f.style.width = target; }, 100);
            });
        });
    </script>
</body>
</html>
