<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% if(!"Student".equals(session.getAttribute("role"))){ response.sendRedirect("login"); return; }%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        :root {
            --bg: #0a0f1e;
            --surface: rgba(255,255,255,0.04);
            --border: rgba(255,255,255,0.09);
            --accent: #6366f1;
            --accent2: #8b5cf6;
            --text: #e2e8f0;
            --muted: rgba(255,255,255,0.4);
        }
        body { background: var(--bg); font-family: 'Inter', sans-serif; color: var(--text); min-height: 100vh; }

        /* NAVBAR */
        .navbar-pro {
            background: rgba(10,15,30,0.85);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 12px 24px;
        }
        .navbar-brand-pro {
            font-weight: 800; font-size: 1.15rem; color: white; text-decoration: none; display: flex; align-items: center; gap: 10px;
        }
        .brand-icon {
            width: 34px; height: 34px; border-radius: 9px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center; font-size: 1rem; color: white;
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
        }
        .nav-link-pro {
            color: rgba(255,255,255,0.6) !important; font-weight: 500; font-size: 0.9rem;
            padding: 7px 14px !important; border-radius: 8px; transition: all 0.2s; text-decoration: none;
        }
        .nav-link-pro:hover, .nav-link-pro.active {
            color: white !important; background: rgba(255,255,255,0.08);
        }
        .nav-link-pro i { margin-right: 6px; }

        /* PAGE */
        .page-container { max-width: 1200px; margin: 0 auto; padding: 40px 24px 60px; }
        .welcome-head {
            margin-bottom: 40px;
            padding-bottom: 28px;
            border-bottom: 1px solid var(--border);
        }
        .welcome-head h1 { font-weight: 800; font-size: 2rem; color: white; letter-spacing: -0.5px; margin: 0; }
        .welcome-head p { color: var(--muted); font-size: 0.95rem; margin: 6px 0 0; }

        /* STAT CARDS */
        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 28px 24px;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            position: relative;
            overflow: hidden;
            text-decoration: none;
            display: block;
            color: var(--text);
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 3px;
            background: var(--card-accent, linear-gradient(90deg, var(--accent), var(--accent2)));
            border-radius: 18px 18px 0 0;
        }
        .stat-card:hover {
            transform: translateY(-6px);
            border-color: rgba(99,102,241,0.35);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3), 0 0 0 1px rgba(99,102,241,0.15);
            color: var(--text);
        }
        .stat-card .card-icon {
            width: 52px; height: 52px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; margin-bottom: 18px;
        }
        .stat-card h3 { font-weight: 700; font-size: 1.15rem; color: white; margin: 0 0 6px; }
        .stat-card p { color: var(--muted); font-size: 0.875rem; margin: 0 0 18px; line-height: 1.5; }
        .stat-btn {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 0.85rem; font-weight: 600;
            padding: 8px 16px; border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.12);
            color: rgba(255,255,255,0.75);
            transition: all 0.2s; background: rgba(255,255,255,0.05);
        }
        .stat-btn:hover { background: rgba(255,255,255,0.12); color: white; border-color: rgba(255,255,255,0.25);}

        /* SECTION LABEL */
        .section-label {
            font-size: 0.75rem; font-weight: 700; letter-spacing: 1.5px;
            text-transform: uppercase; color: var(--muted); margin-bottom: 16px;
        }

        /* RECOMMENDATIONS */
        .rec-card {
            background: linear-gradient(135deg, rgba(99,102,241,0.12), rgba(139,92,246,0.08));
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 18px; padding: 28px;
        }
        .rec-item {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 14px; padding: 18px;
            transition: border-color 0.3s, background 0.3s;
        }
        .rec-item:hover { background: rgba(255,255,255,0.08); border-color: rgba(99,102,241,0.4); }
        .rec-item h6 { color: white; font-weight: 600; margin: 0 0 4px; }
        .rec-item small { color: var(--muted); }
        .btn-rec {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none; color: white; font-size: 0.8rem; font-weight: 600;
            padding: 7px 14px; border-radius: 8px; text-decoration: none;
            transition: opacity 0.2s; display: inline-flex; align-items: center; gap: 5px;
        }
        .btn-rec:hover { opacity: 0.9; color: white; }

        /* CHART CARD */
        .chart-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px; padding: 28px;
        }
        .chart-card h5 { color: white; font-weight: 700; margin-bottom: 20px; }

        /* EMAIL BADGE */
        .email-badge {
            background: rgba(255,255,255,0.07);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 5px 14px;
            font-size: 0.82rem;
            color: rgba(255,255,255,0.6);
        }
        .logout-btn {
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.25);
            color: #f87171;
            border-radius: 8px;
            padding: 7px 14px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        .logout-btn:hover { background: rgba(239,68,68,0.2); color: #fca5a5; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar-pro d-flex align-items-center justify-content-between sticky-top">
        <div class="d-flex align-items-center gap-4">
            <a class="navbar-brand-pro" href="Student">
                <div class="brand-icon"><i class="bi bi-mortarboard-fill"></i></div>
                EduQuiz AI
            </a>
            <div class="d-flex gap-1">
                <a class="nav-link-pro" href="getQuestion"><i class="bi bi-pencil-square"></i>Start Exam</a>
                <a class="nav-link-pro" href="resultHistory"><i class="bi bi-journal-text"></i>My Results</a>
                <a class="nav-link-pro" href="studentProfile"><i class="bi bi-person-circle"></i>Profile</a>
            </div>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span class="email-badge"><i class="bi bi-circle-fill text-success me-2" style="font-size:0.5rem;"></i>${sessionScope.userEmail}</span>
            <a class="logout-btn" href="logout"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
        </div>
    </nav>

    <div class="page-container">
        <!-- Welcome Header -->
        <div class="welcome-head">
            <h1>👋 Welcome back!</h1>
            <p>Ready to level up today? Pick up where you left off.</p>
        </div>

        <!-- Action Cards -->
        <p class="section-label">Quick Actions</p>
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <a href="getQuestion" class="stat-card" style="--card-accent: linear-gradient(90deg, #6366f1, #818cf8);">
                    <div class="card-icon" style="background:rgba(99,102,241,0.15);color:#818cf8;">
                        <i class="bi bi-pencil-square"></i>
                    </div>
                    <h3>Start New Exam</h3>
                    <p>Test your knowledge across subjects and track your progress over time.</p>
                    <span class="stat-btn"><i class="bi bi-play-fill"></i> Begin Now →</span>
                </a>
            </div>
            <div class="col-md-4">
                <a href="resultHistory" class="stat-card" style="--card-accent: linear-gradient(90deg, #10b981, #34d399);">
                    <div class="card-icon" style="background:rgba(16,185,129,0.15);color:#34d399;">
                        <i class="bi bi-trophy-fill"></i>
                    </div>
                    <h3>My Results</h3>
                    <p>Review all your past quiz scores, breakdowns, and performance trends.</p>
                    <span class="stat-btn"><i class="bi bi-bar-chart-line"></i> View History →</span>
                </a>
            </div>
            <div class="col-md-4">
                <a href="studentProfile" class="stat-card" style="--card-accent: linear-gradient(90deg, #f59e0b, #fbbf24);">
                    <div class="card-icon" style="background:rgba(245,158,11,0.15);color:#fbbf24;">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <h3>My Profile</h3>
                    <p>View your stats, manage your account and see your learning journey.</p>
                    <span class="stat-btn"><i class="bi bi-arrow-right-circle"></i> Open Profile →</span>
                </a>
            </div>
        </div>

        <!-- AI Personalized Recommendations -->
        <c:if test="${not empty recommendedQuizzes}">
            <p class="section-label">✨ AI Personalized Recommendations</p>
            <div class="rec-card mb-5">
                <div class="d-flex align-items-center gap-3 mb-4">
                    <div style="width:44px;height:44px;border-radius:12px;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;font-size:1.3rem;color:white;box-shadow:0 6px 16px rgba(99,102,241,0.35);">
                        <i class="bi bi-stars"></i>
                    </div>
                    <div>
                        <h5 class="text-white fw-bold mb-0">Recommended For You</h5>
                        <c:choose>
                            <c:when test="${not empty weakArea}">
                                <small class="text-warning">AI detected weak area: <strong>${weakArea}</strong> (${weakScore}%) — these quizzes will help you improve!</small>
                            </c:when>
                            <c:otherwise>
                                <small style="color:var(--muted)">Based on your quiz history, here are quizzes you haven't tried yet</small>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row g-3">
                    <c:forEach items="${recommendedQuizzes}" var="rq">
                        <div class="col-md-4">
                            <div class="rec-item d-flex flex-column h-100">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <i class="bi bi-book-fill" style="color:#818cf8;"></i>
                                    <h6>${rq.quizName}</h6>
                                </div>
                                <small class="mb-3">${rq.techno.techName}</small>
                                <a href="startQuiz?quizId=${rq.quizId}" class="btn-rec mt-auto align-self-start">
                                    <i class="bi bi-play-fill"></i> Start Quiz
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Performance Chart -->
        <p class="section-label">My Performance Over Time</p>
        <div class="chart-card">
            <h5><i class="bi bi-graph-up-arrow me-2" style="color:#818cf8;"></i>Exam Performance</h5>
            <c:choose>
                <c:when test="${not empty quizScores and quizScores.size() > 0}">
                    <canvas id="studentPerformanceChart" height="100"></canvas>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5" style="color:var(--muted);">
                        <i class="bi bi-bar-chart-line-fill d-block mb-3" style="font-size:2.5rem;opacity:0.3;"></i>
                        <p class="mb-0">Take your first exam to see your performance chart here!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const ctxEl = document.getElementById('studentPerformanceChart');
            if (ctxEl) {
                const labels = [<c:forEach items="${quizLabels}" var="label" varStatus="loop">"${label}"${!loop.last ? ',' : ''}</c:forEach>];
                const data = [<c:forEach items="${quizScores}" var="score" varStatus="loop">${score}${!loop.last ? ',' : ''}</c:forEach>];
                new Chart(ctxEl.getContext('2d'), {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Score (%)', data: data,
                            borderColor: '#818cf8',
                            backgroundColor: 'rgba(99,102,241,0.12)',
                            pointBackgroundColor: '#818cf8',
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2, pointRadius: 5, pointHoverRadius: 7,
                            borderWidth: 2.5, fill: true, tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                backgroundColor: 'rgba(15,20,40,0.9)',
                                borderColor: 'rgba(99,102,241,0.3)',
                                borderWidth: 1,
                                titleColor: '#e2e8f0',
                                bodyColor: '#818cf8',
                                callbacks: { label: ctx => ' Score: ' + ctx.raw + '%' }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true, max: 100,
                                grid: { color: 'rgba(255,255,255,0.05)' },
                                ticks: { color: 'rgba(255,255,255,0.4)', callback: v => v + '%' },
                                title: { display: false }
                            },
                            x: {
                                grid: { color: 'rgba(255,255,255,0.04)' },
                                ticks: { color: 'rgba(255,255,255,0.4)', maxTicksLimit: 8 }
                            }
                        }
                    }
                });
            }
        });
    </script>
    <%@ include file="global-utils.jsp" %>
</body>
</html>