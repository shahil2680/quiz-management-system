<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Quizzes — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0; min-height: 100vh; }
        .page-container { max-width: 1200px; margin: 0 auto; padding: 36px 24px 60px; }
        .page-header {
            display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;
            margin-bottom: 28px;
        }
        .page-header h1 { font-weight: 800; font-size: 1.6rem; color: white; margin: 0; }
        .page-header p { color: rgba(255,255,255,0.4); font-size: 0.85rem; margin: 4px 0 0; }
        .btn-create {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none; color: white; font-weight: 700; font-size: 0.875rem;
            padding: 11px 20px; border-radius: 10px; text-decoration: none;
            display: inline-flex; align-items: center; gap: 7px;
            box-shadow: 0 6px 18px rgba(99,102,241,0.35);
            transition: all 0.25s;
        }
        .btn-create:hover { color: white; opacity: 0.9; transform: translateY(-1px); }
        .quiz-table-wrap {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 18px; overflow: hidden;
        }
        .quiz-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .quiz-table thead tr { background: rgba(255,255,255,0.04); }
        .quiz-table thead th {
            padding: 14px 18px; font-size: 0.72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            color: rgba(255,255,255,0.35); border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .quiz-table tbody tr {
            border-bottom: 1px solid rgba(255,255,255,0.05);
            transition: background 0.2s;
        }
        .quiz-table tbody tr:last-child { border-bottom: none; }
        .quiz-table tbody tr:hover { background: rgba(255,255,255,0.03); }
        .quiz-table td { padding: 16px 18px; font-size: 0.875rem; color: #e2e8f0; vertical-align: middle; }
        .quiz-name { font-weight: 600; color: white; }
        .quiz-num { color: rgba(255,255,255,0.3); font-size: 0.8rem; }
        .subject-badge {
            background: rgba(6,182,212,0.15); color: #22d3ee;
            border: 1px solid rgba(6,182,212,0.2);
            border-radius: 20px; padding: 3px 10px; font-size: 0.75rem; font-weight: 600;
        }
        .count-badge {
            background: rgba(99,102,241,0.2); color: #a5b4fc;
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 8px; padding: 3px 10px; font-size: 0.8rem; font-weight: 700;
            display: inline-block;
        }
        .time-text { color: rgba(255,255,255,0.5); font-size: 0.82rem; }
        /* ACTION BUTTONS */
        .act-btn {
            width: 32px; height: 32px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.6);
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 0.85rem; cursor: pointer; text-decoration: none;
            transition: all 0.2s;
        }
        .act-btn:hover { background: rgba(255,255,255,0.1); color: white; border-color: rgba(255,255,255,0.2); }
        .act-btn.primary:hover { background: rgba(99,102,241,0.2); color: #a5b4fc; border-color: rgba(99,102,241,0.3); }
        .act-btn.success:hover { background: rgba(16,185,129,0.2); color: #34d399; border-color: rgba(16,185,129,0.3); }
        .act-btn.danger:hover { background: rgba(239,68,68,0.2); color: #f87171; border-color: rgba(239,68,68,0.3); }
        /* STUDENT ACCESS BUTTONS */
        .assign-btn {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 6px 12px; border-radius: 8px; font-size: 0.78rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s;
            background: rgba(16,185,129,0.15); color: #34d399;
            border: 1px solid rgba(16,185,129,0.25);
        }
        .assign-btn:hover { background: rgba(16,185,129,0.25); color: #6ee7b7; }
        .reassign-btn {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 6px 12px; border-radius: 8px; font-size: 0.78rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s;
            background: rgba(245,158,11,0.15); color: #fbbf24;
            border: 1px solid rgba(245,158,11,0.25);
        }
        .reassign-btn:hover { background: rgba(245,158,11,0.25); color: #fde68a; }
        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 72px 24px; color: rgba(255,255,255,0.3); }
        .empty-state i { font-size: 3rem; opacity: 0.3; display: block; margin-bottom: 16px; }
        /* BACK BTN */
        .btn-back {
            background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.6); border-radius: 10px;
            padding: 10px 18px; font-size: 0.85rem; font-weight: 500;
            text-decoration: none; display: inline-flex; align-items: center; gap: 7px;
            transition: all 0.2s;
        }
        .btn-back:hover { background: rgba(255,255,255,0.09); color: white; }
    </style>
</head>
<body>
    <jsp:include page="FacultyNavbar.jsp" />

    <div class="page-container">
        <!-- Header -->
        <div class="page-header">
            <div>
                <h1><i class="bi bi-collection-fill me-2" style="color:#818cf8;"></i>Manage Quizzes</h1>
                <p>Create, edit, assign and reassign quizzes to students</p>
            </div>
            <a href="createQuiz" class="btn-create"><i class="bi bi-plus-circle-fill"></i>Create New Quiz</a>
        </div>

        <!-- Table -->
        <div class="quiz-table-wrap">
            <c:if test="${empty quizzes}">
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <p class="mb-0">No quizzes yet. Click "Create New Quiz" to get started!</p>
                </div>
            </c:if>
            <c:if test="${not empty quizzes}">
                <table class="quiz-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Quiz Name</th>
                            <th>Subject</th>
                            <th>Questions</th>
                            <th>Time</th>
                            <th>Actions</th>
                            <th>Student Access</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="q" items="${quizzes}" varStatus="i">
                            <tr>
                                <td class="quiz-num">${i.count}</td>
                                <td class="quiz-name">${q.quizName}</td>
                                <td><span class="subject-badge">${q.techno.techName}</span></td>
                                <td><span class="count-badge">${fn:length(q.questions)}</span></td>
                                <td class="time-text"><i class="bi bi-clock me-1"></i>${q.timeInMinutes} min</td>
                                <td>
                                    <div class="d-flex gap-2 align-items-center">
                                        <a href="assignQuestions?quizId=${q.quizId}" class="act-btn primary" title="Assign Questions">
                                            <i class="bi bi-list-check"></i>
                                        </a>
                                        <a href="editQuiz?quizId=${q.quizId}" class="act-btn success" title="Edit Quiz">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="quizAnalytics?quizId=${q.quizId}" class="act-btn" title="View Analytics" style="background:rgba(99,102,241,0.08);border-color:rgba(99,102,241,0.2);color:#818cf8;">
                                            <i class="bi bi-bar-chart-line-fill"></i>
                                        </a>
                                        <a href="exportResults?quizId=${q.quizId}" class="act-btn" title="Export CSV">
                                            <i class="bi bi-download"></i>
                                        </a>
                                        <form action="deleteQuiz" method="post" class="m-0">
                                            <input type="hidden" name="quizId" value="${q.quizId}">
                                            <button type="submit" class="act-btn danger"
                                                onclick="return confirm('Delete quiz: ${q.quizName}?')" title="Delete Quiz">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="reassignQuiz" class="assign-btn" title="Assign to student">
                                            <i class="bi bi-person-check-fill"></i>Assign
                                        </a>
                                        <a href="reassignQuiz?quizId=${q.quizId}" class="reassign-btn" title="Reset a student's attempt">
                                            <i class="bi bi-arrow-repeat"></i>Reassign
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <div class="mt-4">
            <a href="Faculty" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Dashboard</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>