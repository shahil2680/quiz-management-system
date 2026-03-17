<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Result — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body {
            background: #0a0f1e;
            font-family: 'Inter', sans-serif;
            color: #e2e8f0;
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            padding: 24px;
        }
        .result-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 24px;
            width: 100%; max-width: 560px;
            padding: 48px 40px;
            text-align: center;
            box-shadow: 0 32px 80px rgba(0,0,0,0.4);
            animation: slideUp 0.5s ease;
        }
        @keyframes slideUp { from { opacity:0; transform:translateY(24px); } to { opacity:1; transform:translateY(0); } }
        .result-icon { font-size: 4rem; margin-bottom: 12px; display: block; }
        .result-title { font-weight: 800; font-size: 1.5rem; margin-bottom: 28px; }
        .score-display {
            font-size: 3.5rem; font-weight: 800; color: white; line-height: 1;
            margin-bottom: 4px; letter-spacing: -2px;
        }
        .score-label { color: rgba(255,255,255,0.35); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 24px; }
        .progress-dark { height: 12px; border-radius: 6px; background: rgba(255,255,255,0.08); overflow: hidden; margin-bottom: 6px; }
        .progress-fill-pass { height: 100%; border-radius: 6px; background: linear-gradient(90deg, #10b981, #34d399); }
        .progress-fill-fail { height: 100%; border-radius: 6px; background: linear-gradient(90deg, #ef4444, #f87171); }
        .pct-text { font-weight: 700; font-size: 1.1rem; margin-bottom: 24px; }
        .message-text { color: rgba(255,255,255,0.45); font-size: 0.9rem; margin-bottom: 28px; }
        .btn-dark-outline {
            display: inline-flex; align-items: center; gap: 7px;
            padding: 11px 22px; border-radius: 10px; font-weight: 600; font-size: 0.875rem;
            border: 1px solid rgba(255,255,255,0.12); color: rgba(255,255,255,0.7);
            background: rgba(255,255,255,0.05); text-decoration: none; transition: all 0.2s;
        }
        .btn-dark-outline:hover { color: white; background: rgba(255,255,255,0.1); }
        .btn-primary-dark {
            display: inline-flex; align-items: center; gap: 7px;
            padding: 11px 22px; border-radius: 10px; font-weight: 700; font-size: 0.875rem;
            background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; text-decoration: none;
            box-shadow: 0 6px 18px rgba(99,102,241,0.35); transition: all 0.25s;
        }
        .btn-primary-dark:hover { color: white; opacity: 0.9; transform: translateY(-1px); }
        /* ANSWER BREAKDOWN ACCORDION */
        .acc-btn {
            background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.7); border-radius: 12px; padding: 12px 20px;
            font-weight: 600; font-size: 0.875rem; width: 100%; text-align: left;
            display: flex; align-items: center; justify-content: space-between;
            cursor: pointer; transition: all 0.2s;
        }
        .acc-btn:hover { color: white; background: rgba(255,255,255,0.09); }
        .acc-body { padding-top: 16px; }
        .dark-table { width: 100%; border-collapse: separate; border-spacing: 0; font-size: 0.82rem; }
        .dark-table thead th {
            padding: 10px 12px; font-size: 0.68rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.8px;
            color: rgba(255,255,255,0.3); border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .dark-table tbody tr { border-bottom: 1px solid rgba(255,255,255,0.04); }
        .dark-table tbody tr:last-child { border-bottom: none; }
        .dark-table td { padding: 10px 12px; color: #e2e8f0; vertical-align: middle; }
        .dark-table tr.correct { background: rgba(16,185,129,0.07); }
        .dark-table tr.wrong { background: rgba(239,68,68,0.07); }
    </style>
</head>
<body>
    <div class="result-card">
        <c:choose>
            <c:when test="${percentage >= 90}">
                <i class="bi bi-trophy-fill result-icon" style="color:#fbbf24;"></i>
                <h2 class="result-title" style="color:#fbbf24;">Outstanding!</h2>
            </c:when>
            <c:when test="${percentage >= 70}">
                <i class="bi bi-star-fill result-icon" style="color:#818cf8;"></i>
                <h2 class="result-title" style="color:#818cf8;">Great Job!</h2>
            </c:when>
            <c:when test="${percentage >= 40}">
                <i class="bi bi-check-circle-fill result-icon" style="color:#34d399;"></i>
                <h2 class="result-title" style="color:#34d399;">You Passed!</h2>
            </c:when>
            <c:otherwise>
                <i class="bi bi-x-circle-fill result-icon" style="color:#f87171;"></i>
                <h2 class="result-title" style="color:#f87171;">Keep Trying!</h2>
            </c:otherwise>
        </c:choose>

        <div class="score-display"><c:out value="${score}" /> / <c:out value="${totalQuestions}" /></div>
        <div class="score-label">Your Score</div>

        <div class="progress-dark mb-2">
            <div class="${percentage >= 40 ? 'progress-fill-pass' : 'progress-fill-fail'}" style="width:${percentage}%;"></div>
        </div>
        <div class="pct-text" style="color:${percentage >= 40 ? '#34d399' : '#f87171'};">${percentage}% Correct</div>

        <c:choose>
            <c:when test="${percentage >= 90}"><p class="message-text">Fantastic work! Keep maintaining this standard.</p></c:when>
            <c:when test="${percentage >= 70}"><p class="message-text">Very good! With a little more effort, you can hit 100%.</p></c:when>
            <c:when test="${percentage >= 40}"><p class="message-text">You passed, but there's definitely room for improvement!</p></c:when>
            <c:otherwise><p class="message-text">Don't give up — review the material and try again!</p></c:otherwise>
        </c:choose>

        <div class="d-flex justify-content-center gap-3 mb-4">
            <a href="Student" class="btn-dark-outline"><i class="bi bi-house-door"></i>Dashboard</a>
            <a href="getQuestion" class="btn-primary-dark"><i class="bi bi-arrow-repeat"></i>More Quizzes</a>
        </div>

        <c:if test="${not empty answerBreakdown}">
            <div class="text-start">
                <button class="acc-btn" type="button" onclick="toggleAcc(this)">
                    <span><i class="bi bi-list-check me-2"></i>View Answer Breakdown</span>
                    <i class="bi bi-chevron-down" id="accChevron"></i>
                </button>
                <div class="acc-body" id="accBody" style="display:none;">
                    <div style="background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.07);border-radius:12px;overflow:hidden;">
                        <table class="dark-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Question</th>
                                    <th>Your Answer</th>
                                    <th>Correct</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ans" items="${answerBreakdown}" varStatus="status">
                                    <tr class="${ans.correct ? 'correct' : 'wrong'}">
                                        <td style="color:rgba(255,255,255,0.35);">${status.index + 1}</td>
                                        <td style="max-width:160px;word-wrap:break-word;">${ans.question.qname}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty ans.selectedAnswer}"><span style="color:rgba(255,255,255,0.3);font-style:italic;">Not answered</span></c:when>
                                                <c:otherwise>${ans.selectedAnswer}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="font-weight:700;color:#34d399;">${ans.question.correct_Opt}</td>
                                        <td>
                                            <c:if test="${ans.correct}"><i class="bi bi-check-circle-fill" style="color:#34d399;"></i></c:if>
                                            <c:if test="${!ans.correct}"><i class="bi bi-x-circle-fill" style="color:#f87171;"></i></c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleAcc(btn) {
            const body = document.getElementById('accBody');
            const chevron = document.getElementById('accChevron');
            const open = body.style.display === 'block';
            body.style.display = open ? 'none' : 'block';
            chevron.className = open ? 'bi bi-chevron-down' : 'bi bi-chevron-up';
        }
    </script>
</body>
</html>