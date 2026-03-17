<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reassign Quiz | Faculty</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f2027, #203a43, #2c5364); min-height: 100vh; font-family: 'Segoe UI', sans-serif; }
        .glass-card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .page-header { background: linear-gradient(135deg, #e74c3c, #c0392b); border-radius: 16px; padding: 28px; margin-bottom: 30px; }
        .form-control, .form-select { background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2); color: white; border-radius: 10px; padding: 12px; }
        .form-control:focus, .form-select:focus { background: rgba(255,255,255,0.15); color: white; box-shadow: 0 0 0 3px rgba(231,76,60,0.3); border-color: #e74c3c; }
        .form-select option { background: #1a1a2e; color: white; }
        label { color: rgba(255,255,255,0.85); font-weight: 600; margin-bottom: 6px; display: block; }
        .btn-reassign { background: linear-gradient(135deg, #e74c3c, #c0392b); border: none; border-radius: 12px; padding: 12px 30px; color: white; font-weight: 700; font-size: 1rem; transition: all 0.3s; width: 100%; }
        .btn-reassign:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(231,76,60,0.4); color: white; }
        .alert-card { border-radius: 14px; border: none; }
        .info-box { background: rgba(255,255,255,0.06); border-radius: 14px; border: 1px solid rgba(255,255,255,0.08); padding: 22px; }
        .rule-item { display: flex; gap: 12px; align-items: flex-start; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.07); }
        .rule-item:last-child { border-bottom: none; }
        .rule-icon { font-size: 1.3rem; flex-shrink: 0; }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.6} }
    </style>
</head>
<body>
    <jsp:include page="FacultyNavbar.jsp" />
    <div class="container py-5">

        <!-- Header -->
        <div class="page-header text-white text-center">
            <i class="bi bi-arrow-repeat fs-1 d-block mb-3"></i>
            <h2 class="fw-bold mb-1">Reassign Quiz to Student</h2>
            <p class="mb-0 opacity-75">Reset a student's previous attempt so they can retake the quiz with updated questions</p>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-card d-flex align-items-center mb-4">
                <i class="bi bi-check-circle-fill fs-4 me-3"></i>
                <div>${successMsg}</div>
            </div>
        </c:if>
        <c:if test="${not empty infoMsg}">
            <div class="alert alert-info alert-card d-flex align-items-center mb-4">
                <i class="bi bi-info-circle-fill fs-4 me-3"></i>
                <div>${infoMsg}</div>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-card d-flex align-items-center mb-4">
                <i class="bi bi-exclamation-triangle-fill fs-4 me-3"></i>
                <div>${error}</div>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Reassign Form -->
            <div class="col-lg-7">
                <div class="glass-card p-4 p-lg-5">
                    <h5 class="text-white fw-bold mb-4"><i class="bi bi-sliders me-2 text-danger"></i>Reassignment Settings</h5>
                    <form action="reassignQuiz" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="mb-4">
                            <label><i class="bi bi-person-fill me-2"></i>Select Student *</label>
                            <select name="studentId" class="form-select" required id="studentSelect">
                                <option value="">-- Choose a Student --</option>
                                <option value="all" style="background:#1a3a1a; color:#4caf50; font-weight:700;">🌐 ALL Students (Reset quiz for everyone)</option>
                                <c:forEach items="${students}" var="st">
                                    <option value="${st.id}">${st.username} — ${st.email}</option>
                                </c:forEach>
                            </select>
                            <small class="text-white-50 mt-1 d-block">Only students who have registered are listed.</small>
                        </div>

                        <div class="mb-4">
                            <label><i class="bi bi-collection-fill me-2"></i>Select Quiz to Reassign *</label>
                            <select name="quizId" class="form-select" required id="quizSelect">
                                <option value="">-- Choose a Quiz --</option>
                                <c:forEach items="${quizzes}" var="qz">
                                    <option value="${qz.quizId}" ${selectedQuizId == qz.quizId ? 'selected' : ''}>${qz.quizName} (${qz.techno.techName})</option>
                                </c:forEach>
                            </select>
                            <small class="text-white-50 mt-1 d-block">All available quizzes are listed. The student's previous result will be cleared to allow retake.</small>
                        </div>

                        <div class="mb-4 p-3 rounded-3" style="background:rgba(231,76,60,0.1); border: 1px solid rgba(231,76,60,0.3);">
                            <div class="d-flex align-items-center gap-2 text-warning">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                                <strong>Warning:</strong>
                            </div>
                            <p class="text-white-50 mb-0 mt-1 small">This will permanently delete the student's previous score for this quiz. The student will start fresh with the current questions in the quiz (including any newly added questions).</p>
                        </div>

                        <button type="submit" class="btn btn-reassign" onclick="return confirm('Are you sure? This will delete the student\'s previous attempt and let them retake the quiz.')">
                            <i class="bi bi-arrow-repeat me-2"></i>Reassign Quiz
                        </button>
                    </form>
                </div>
            </div>

            <!-- Info Panel -->
            <div class="col-lg-5">
                <div class="glass-card p-4 h-100">
                    <h5 class="text-white fw-bold mb-4"><i class="bi bi-lightbulb me-2 text-warning"></i>How Reassignment Works</h5>
                    <div class="info-box">
                        <div class="rule-item">
                            <span class="rule-icon">🔍</span>
                            <div><p class="text-white mb-1 fw-semibold">Select Student & Quiz</p><p class="text-white-50 small mb-0">Choose the student and which quiz you want to allow them to retake.</p></div>
                        </div>
                        <div class="rule-item">
                            <span class="rule-icon">🗑️</span>
                            <div><p class="text-white mb-1 fw-semibold">Old Score is Cleared</p><p class="text-white-50 small mb-0">The previous result is deleted from the database. Their old score will not appear in history.</p></div>
                        </div>
                        <div class="rule-item">
                            <span class="rule-icon">✨</span>
                            <div><p class="text-white mb-1 fw-semibold">Fresh Attempt with New Questions</p><p class="text-white-50 small mb-0">The student will see all current questions in the quiz — including any you've added recently!</p></div>
                        </div>
                        <div class="rule-item">
                            <span class="rule-icon">📊</span>
                            <div><p class="text-white mb-1 fw-semibold">New Score Recorded</p><p class="text-white-50 small mb-0">After retake, the new score is recorded normally in the system.</p></div>
                        </div>
                    </div>

                    <div class="mt-4">
                        <a href="Faculty" class="btn btn-outline-light btn-sm w-100 mb-2"><i class="bi bi-arrow-left me-2"></i>Back to Dashboard</a>
                        <a href="AllQuestion" class="btn btn-outline-warning btn-sm w-100"><i class="bi bi-plus-circle me-2"></i>Add More Questions to a Quiz</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
