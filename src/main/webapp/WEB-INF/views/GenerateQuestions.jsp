<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% if(!"Faculty".equals(session.getAttribute("role")) ){ response.sendRedirect("login"); return; }%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AI Question Generator</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #1a1a2e, #16213e, #0f3460); min-height: 100vh; font-family: 'Segoe UI', sans-serif; }
        .glass-card {
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .ai-header { background: linear-gradient(135deg, #6c63ff, #3d9be9); border-radius: 16px; padding: 30px; margin-bottom: 30px; }
        .form-control, .form-select { background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2); color: white; border-radius: 10px; }
        .form-control:focus, .form-select:focus { background: rgba(255,255,255,0.15); color: white; border-color: #6c63ff; box-shadow: 0 0 0 3px rgba(108,99,255,0.2); }
        .form-control::placeholder { color: rgba(255,255,255,0.5); }
        .form-select option { background: #16213e; color: white; }
        label { color: rgba(255,255,255,0.85); font-weight: 600; }
        .btn-ai { background: linear-gradient(135deg, #6c63ff, #3d9be9); border: none; border-radius: 12px; padding: 12px 30px; font-weight: 700; font-size: 1rem; color: white; transition: all 0.3s; }
        .btn-ai:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(108,99,255,0.4); color: white; }
        .alert-ai { border-radius: 12px; border: none; }
        .spinner-border-sm { width: 1rem; height: 1rem; }
        .ai-note { color: rgba(255,255,255,0.6); font-size: 0.85rem; }
        .step-badge { background: rgba(108,99,255,0.3); color: #a89fff; border-radius: 50%; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; font-weight: 700; flex-shrink: 0; }
    </style>
</head>
<body>
    <jsp:include page="FacultyNavbar.jsp" />
    <div class="container py-5">
        <!-- Header -->
        <div class="ai-header text-white text-center">
            <i class="bi bi-magic fs-1 d-block mb-3"></i>
            <h2 class="fw-bold mb-1">AI Question Generator</h2>
            <p class="mb-0 opacity-75">Generate high-quality MCQ questions instantly using Google Gemini AI</p>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-ai d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-3 fs-4"></i>
                <div><strong>Success!</strong> ${successMsg}</div>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-ai d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-3 fs-4"></i>
                <div><strong>Error:</strong> ${error}</div>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Form Card -->
            <div class="col-lg-6">
                <div class="glass-card p-4 p-lg-5 h-100">
                    <h5 class="text-white fw-bold mb-4"><i class="bi bi-sliders me-2 text-primary"></i>Generation Settings</h5>
                    <form action="generateQuestions" method="post" onsubmit="showLoader()">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="mb-4">
                            <label class="form-label">Topic / Subject *</label>
                            <input type="text" name="topic" class="form-control" placeholder="e.g. Java OOP, SQL Joins, Data Structures..." required maxlength="200">
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Difficulty Level *</label>
                            <select name="difficulty" class="form-select" required>
                                <option value="Easy">🟢 Easy (Beginner)</option>
                                <option value="Medium" selected>🟡 Medium (Intermediate)</option>
                                <option value="Hard">🔴 Hard (Advanced)</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Number of Questions *</label>
                            <select name="questionCount" class="form-select" required>
                                <option value="3">3 Questions</option>
                                <option value="5" selected>5 Questions</option>
                                <option value="10">10 Questions</option>
                                <option value="15">15 Questions</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Assign to Technology (Optional)</label>
                            <select name="technoName" class="form-select">
                                <option value="">-- No Category --</option>
                                <c:forEach items="${technos}" var="t">
                                    <option value="${t.techName}">${t.techName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-ai w-100" id="generateBtn">
                            <i class="bi bi-stars me-2"></i>Generate Questions with AI
                        </button>
                        <div id="loader" class="text-center mt-3" style="display:none;">
                            <div class="spinner-border text-primary me-2"></div>
                            <span class="text-white-50">Gemini AI is thinking...</span>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Info Card -->
            <div class="col-lg-6">
                <div class="glass-card p-4 p-lg-5 h-100 d-flex flex-column">
                    <h5 class="text-white fw-bold mb-4"><i class="bi bi-info-circle me-2 text-info"></i>How It Works</h5>
                    <div class="d-flex gap-3 mb-4 align-items-start">
                        <div class="step-badge">1</div>
                        <div><p class="text-white mb-1 fw-semibold">Enter Your Topic</p><p class="ai-note">Be specific! E.g., "Java Exception Handling mechanisms" generates better questions than just "Java".</p></div>
                    </div>
                    <div class="d-flex gap-3 mb-4 align-items-start">
                        <div class="step-badge">2</div>
                        <div><p class="text-white mb-1 fw-semibold">Choose Settings</p><p class="ai-note">Select difficulty and question count. Gemini will tailor questions to the exact level.</p></div>
                    </div>
                    <div class="d-flex gap-3 mb-4 align-items-start">
                        <div class="step-badge">3</div>
                        <div><p class="text-white mb-1 fw-semibold">AI Generates & Saves</p><p class="ai-note">Questions are automatically created with 4 options and a correct answer, then saved to your Question Bank.</p></div>
                    </div>
                    <div class="d-flex gap-3 align-items-start">
                        <div class="step-badge">4</div>
                        <div><p class="text-white mb-1 fw-semibold">Assign to Quizzes</p><p class="ai-note">Find your generated questions in the Question Bank and assign them to any exam.</p></div>
                    </div>
                    <div class="mt-auto">
                        <hr style="border-color: rgba(255,255,255,0.1);">
                        <p class="ai-note mt-3"><i class="bi bi-key-fill me-2 text-warning"></i><strong class="text-warning">API Key Required:</strong> This feature uses Google Gemini. Add your key to <code>application.properties</code> (<code>gemini.api.key=...</code>). Without a key, a demo mode is active.</p>
                        <a href="AllQuestion" class="btn btn-outline-light btn-sm w-100 mt-2"><i class="bi bi-grid me-2"></i>View Generated Questions in Question Bank</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showLoader() {
            document.getElementById('generateBtn').disabled = true;
            document.getElementById('loader').style.display = 'block';
        }
    </script>
    <%@ include file="global-utils.jsp" %>
</body>
</html>
