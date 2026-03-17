<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <% if(!"Student".equals(session.getAttribute("role"))) { response.sendRedirect("login"); return; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Profile</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        body {
                            background-color: #f4f6f9;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        }

                        .profile-card {
                            border: none;
                            border-radius: 16px;
                            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                            overflow: hidden;
                        }

                        .profile-header {
                            background: linear-gradient(135deg, #3498db, #2c3e50);
                            color: white;
                            padding: 40px 30px;
                            text-align: center;
                        }

                        .avatar-circle {
                            width: 90px;
                            height: 90px;
                            border-radius: 50%;
                            background: rgba(255, 255, 255, 0.2);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto 16px;
                            font-size: 2.5rem;
                        }

                        .stat-badge {
                            border-radius: 12px;
                            padding: 18px;
                            background: white;
                            text-align: center;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                        }

                        .stat-badge .num {
                            font-size: 2rem;
                            font-weight: 700;
                        }

                        .result-row {
                            transition: background 0.2s;
                        }

                        .result-row:hover {
                            background: #f8f9fa;
                        }
                    </style>
                </head>

                <body>
                    <nav class="navbar navbar-expand-lg sticky-top"
                        style="background:#fff; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
                        <div class="container-fluid px-4">
                            <a class="navbar-brand fw-bold text-primary" href="Student"><i
                                    class="bi bi-mortarboard-fill me-1"></i>Student Portal</a>
                            <div class="collapse navbar-collapse">
                                <ul class="navbar-nav me-auto">
                                    <li class="nav-item"><a class="nav-link" href="getQuestion"><i
                                                class="bi bi-pencil-square me-1"></i>Start Exam</a></li>
                                    <li class="nav-item"><a class="nav-link" href="resultHistory"><i
                                                class="bi bi-journal-text me-1"></i>My Results</a></li>
                                    <li class="nav-item"><a class="nav-link active" href="studentProfile"><i
                                                class="bi bi-person-circle me-1"></i>Profile</a></li>
                                </ul>
                                <ul class="navbar-nav ms-auto">
                                    <li class="nav-item"><span
                                            class="nav-link text-muted">${sessionScope.userEmail}</span></li>
                                    <li class="nav-item"><a class="nav-link text-danger" href="logout"><i
                                                class="bi bi-box-arrow-right me-1"></i>Logout</a></li>
                                </ul>
                            </div>
                        </div>
                    </nav>

                    <div class="container py-5">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">

                                <!-- Profile Card -->
                                <div class="profile-card mb-4">
                                    <div class="profile-header">
                                        <div class="avatar-circle"><i class="bi bi-person-fill"></i></div>
                                        <h4 class="mb-1">${user.username}</h4>
                                        <p class="opacity-75 mb-0"><i class="bi bi-envelope me-1"></i>${user.email}</p>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="row g-3">
                                            <div class="col-4">
                                                <div class="stat-badge">
                                                    <div class="num text-primary">${totalTaken}</div>
                                                    <small class="text-muted">Quizzes Taken</small>
                                                </div>
                                            </div>
                                            <div class="col-4">
                                                <div class="stat-badge">
                                                    <div class="num text-success">${avgScore}%</div>
                                                    <small class="text-muted">Average Score</small>
                                                </div>
                                            </div>
                                            <div class="col-4">
                                                <div class="stat-badge">
                                                    <div class="num text-warning">${bestScore}%</div>
                                                    <small class="text-muted">Best Score</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Quiz History -->
                                <div class="card border-0 rounded-3 shadow-sm">
                                    <div class="card-header bg-white border-0 pt-4 px-4 pb-0">
                                        <h6 class="fw-bold"><i class="bi bi-clock-history text-primary me-2"></i>Quiz
                                            History</h6>
                                    </div>
                                    <div class="card-body p-0">
                                        <c:if test="${empty history}">
                                            <div class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                                <p>No quizzes attempted yet.</p>
                                                <a href="getQuestion" class="btn btn-primary btn-sm">Start a Quiz</a>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty history}">
                                            <table class="table table-hover mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Quiz Name</th>
                                                        <th>Score</th>
                                                        <th>Percentage</th>
                                                        <th>Date</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="r" items="${history}" varStatus="s">
                                                        <tr class="result-row">
                                                            <td>${s.count}</td>
                                                            <td>${r.quizName != null ? r.quizName : 'N/A'}</td>
                                                            <td>${r.score != null ? r.score : 0} / ${r.totalQuestions !=
                                                                null ? r.totalQuestions : 0}</td>
                                                            <td>
                                                                <c:set var="pct"
                                                                    value="${r.percentage != null ? r.percentage : 0}" />
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <div class="progress flex-grow-1"
                                                                        style="height:8px;">
                                                                        <div class="progress-bar ${pct >= 70 ? 'bg-success' : pct >= 40 ? 'bg-warning' : 'bg-danger'}"
                                                                            style="width:${pct}%"></div>
                                                                    </div>
                                                                    <small class="text-muted">${pct}%</small>
                                                                </div>
                                                            </td>
                                                            <td><small class="text-muted">
                                                                    ${r.attemptDate}
                                                                </small></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:if>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>