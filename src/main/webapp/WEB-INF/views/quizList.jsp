<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Quizzes — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0; min-height: 100vh; }
        .top-nav {
            background: rgba(10,15,30,0.92); backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255,255,255,0.08);
            padding: 12px 24px; display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
        }
        .nav-brand { font-weight: 800; font-size: 1.05rem; color: white; text-decoration: none; display: flex; align-items: center; gap: 9px; }
        .brand-dot { width: 30px; height: 30px; border-radius: 8px; background: linear-gradient(135deg,#6366f1,#8b5cf6); display:flex; align-items:center; justify-content:center; color:white; font-size:0.85rem; }
        .nav-link-s { color:rgba(255,255,255,0.55); font-size:0.875rem; font-weight:500; text-decoration:none; padding:6px 12px; border-radius:8px; display:inline-flex; align-items:center; gap:5px; transition:all 0.2s; }
        .nav-link-s:hover { color:white; background:rgba(255,255,255,0.08); }
        .page-container { max-width: 1200px; margin: 0 auto; padding: 40px 24px 60px; }
        .page-title { font-weight: 800; font-size: 1.6rem; color: white; margin-bottom: 6px; }
        .page-sub { color: rgba(255,255,255,0.4); font-size: 0.9rem; margin-bottom: 32px; }
        .alert-warning-dark {
            background: rgba(245,158,11,0.12); border: 1px solid rgba(245,158,11,0.3);
            color: #fbbf24; border-radius: 12px; padding: 14px 18px; margin-bottom: 24px;
            display: flex; align-items: center; gap: 10px; font-size: 0.875rem;
        }
        /* QUIZ CARDS */
        .quiz-card {
            background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.09);
            border-radius: 18px; padding: 28px 24px; height: 100%;
            display: flex; flex-direction: column;
            transition: transform 0.3s, box-shadow 0.3s, border-color 0.3s;
        }
        .quiz-card:hover { transform: translateY(-5px); box-shadow: 0 20px 50px rgba(0,0,0,0.3); border-color: rgba(99,102,241,0.3); }
        .quiz-icon { width:52px; height:52px; border-radius:14px; background:rgba(99,102,241,0.15); color:#818cf8; display:flex; align-items:center; justify-content:center; font-size:1.4rem; margin-bottom:16px; }
        .quiz-name { font-weight: 700; font-size: 1.05rem; color: white; margin-bottom: 14px; }
        .tag { display:inline-flex; align-items:center; gap:4px; padding:4px 10px; border-radius:20px; font-size:0.75rem; font-weight:600; }
        .tag-tech { background:rgba(6,182,212,0.15); color:#22d3ee; border:1px solid rgba(6,182,212,0.2); }
        .tag-q { background:rgba(99,102,241,0.15); color:#a5b4fc; border:1px solid rgba(99,102,241,0.2); }
        .tag-time { background:rgba(245,158,11,0.15); color:#fbbf24; border:1px solid rgba(245,158,11,0.2); }
        .btn-start {
            background: linear-gradient(135deg,#6366f1,#8b5cf6); border:none; color:white;
            font-weight:700; font-size:0.875rem; padding:12px; border-radius:10px; width:100%;
            text-decoration:none; display:flex; align-items:center; justify-content:center; gap:7px;
            box-shadow:0 6px 16px rgba(99,102,241,0.3); transition:all 0.25s; margin-top:auto;
        }
        .btn-start:hover { color:white; opacity:0.9; transform:translateY(-1px); }
        .btn-done { background:rgba(16,185,129,0.15); border:1px solid rgba(16,185,129,0.25); color:#34d399; font-weight:700; font-size:0.875rem; padding:12px; border-radius:10px; width:100%; display:flex; align-items:center; justify-content:center; gap:7px; margin-top:auto; cursor:default; }
        .btn-no-q { background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.1); color:rgba(255,255,255,0.3); font-weight:600; font-size:0.875rem; padding:12px; border-radius:10px; width:100%; display:flex; align-items:center; justify-content:center; gap:7px; margin-top:auto; cursor:default; }
        .btn-back { background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:rgba(255,255,255,0.6); border-radius:10px; padding:10px 18px; font-size:0.85rem; font-weight:500; text-decoration:none; display:inline-flex; align-items:center; gap:6px; transition:all 0.2s; }
        .btn-back:hover { background:rgba(255,255,255,0.09); color:white; }
        .empty-state { text-align:center; padding:80px 24px; color:rgba(255,255,255,0.3); }
        .empty-state i { font-size:3rem; opacity:0.3; display:block; margin-bottom:16px; }
    </style>
</head>
<body>
    <div class="top-nav">
        <a class="nav-brand" href="Student">
            <div class="brand-dot"><i class="bi bi-mortarboard-fill"></i></div>
            Student Portal
        </a>
        <div class="d-flex gap-1">
            <a class="nav-link-s" href="resultHistory"><i class="bi bi-clock-history"></i>My Results</a>
            <a class="nav-link-s" href="logout" style="color:#f87171;"><i class="bi bi-box-arrow-right"></i>Logout</a>
        </div>
    </div>

    <div class="page-container">
        <h1 class="page-title"><i class="bi bi-collection-fill me-2" style="color:#818cf8;"></i>Available Quizzes</h1>
        <p class="page-sub">Select a quiz to test your knowledge. Good luck!</p>

        <c:if test="${not empty param.error and param.error == 'alreadyAttempted'}">
            <div class="alert-warning-dark">
                <i class="bi bi-exclamation-triangle-fill"></i>
                You have already attempted this quiz. Please choose a different one.
            </div>
        </c:if>

        <c:if test="${empty quizzes}">
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <p class="mb-4">No quizzes are currently available. Please check back later.</p>
                <a href="Student" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Dashboard</a>
            </div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="q" items="${quizzes}">
                <div class="col-md-4">
                    <div class="quiz-card">
                        <div class="quiz-icon"><i class="bi bi-journal-richtext"></i></div>
                        <div class="quiz-name">${q.quizName}</div>
                        <div class="d-flex flex-wrap gap-2 mb-4">
                            <span class="tag tag-tech"><i class="bi bi-book"></i>${q.techno.techName}</span>
                            <span class="tag tag-q"><i class="bi bi-question-circle"></i>${fn:length(q.questions)} Qs</span>
                            <span class="tag tag-time"><i class="bi bi-clock"></i>${q.timeInMinutes} min</span>
                        </div>
                        <c:choose>
                            <c:when test="${attemptedQuizzes[q.quizId]}">
                                <div class="btn-done"><i class="bi bi-check-circle-fill"></i>Already Attempted</div>
                            </c:when>
                            <c:when test="${fn:length(q.questions) > 0}">
                                <a href="startQuiz?quizId=${q.quizId}" class="btn-start">
                                    <i class="bi bi-play-fill"></i>Start Quiz
                                </a>
                            </c:when>
                            <c:otherwise>
                                <div class="btn-no-q"><i class="bi bi-exclamation-circle"></i>No Questions Yet</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="mt-5">
            <a href="Student" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Dashboard</a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <%@ include file="global-utils.jsp" %>
</body>
</html>