<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% if(!"Faculty".equals(session.getAttribute("role"))){ response.sendRedirect("login"); return; }%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard — EduQuiz AI</title>
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

        .page-container { max-width: 1280px; margin: 0 auto; padding: 40px 24px 60px; }

        /* HERO */
        .dash-hero {
            background: linear-gradient(135deg, rgba(99,102,241,0.15), rgba(139,92,246,0.08));
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 20px;
            padding: 36px 40px;
            margin-bottom: 40px;
            display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 20px;
        }
        .dash-hero h1 { font-weight: 800; font-size: 1.8rem; color: white; margin: 0; letter-spacing: -0.5px; }
        .dash-hero p { color: var(--muted); font-size: 0.9rem; margin: 6px 0 0; }

        /* STAT NUMBERS */
        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 24px;
            transition: transform 0.3s, box-shadow 0.3s, border-color 0.3s;
            position: relative; overflow: hidden;
        }
        .kpi-card::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0; height: 3px;
            background: var(--kpi-color, linear-gradient(90deg,#6366f1,#8b5cf6));
            border-radius: 0 0 16px 16px;
        }
        .kpi-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.3);
            border-color: rgba(99,102,241,0.25);
        }
        .kpi-icon {
            width: 44px; height: 44px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.25rem; margin-bottom: 14px;
        }
        .kpi-number { font-size: 2.4rem; font-weight: 800; color: white; line-height: 1; margin-bottom: 4px; }
        .kpi-label { color: var(--muted); font-size: 0.82rem; font-weight: 500; margin-bottom: 14px; }
        .kpi-link {
            font-size: 0.8rem; font-weight: 600; color: rgba(255,255,255,0.5);
            text-decoration: none; display: inline-flex; align-items: center; gap: 4px;
            transition: color 0.2s;
        }
        .kpi-link:hover { color: white; }

        /* SECTION */
        .section-label {
            font-size: 0.72rem; font-weight: 700; letter-spacing: 1.5px;
            text-transform: uppercase; color: var(--muted); margin-bottom: 16px;
        }

        /* ACTION CARDS */
        .action-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px; padding: 22px;
            text-decoration: none; color: var(--text); display: block;
            transition: transform 0.25s, box-shadow 0.25s, border-color 0.25s;
        }
        .action-card:hover {
            transform: translateY(-4px);
            color: var(--text);
            border-color: rgba(99,102,241,0.3);
            box-shadow: 0 12px 30px rgba(0,0,0,0.25);
        }
        .action-card h6 { font-weight: 700; font-size: 0.9rem; color: white; margin: 10px 0 4px; }
        .action-card small { color: var(--muted); font-size: 0.8rem; }
        .action-icon {
            width: 38px; height: 38px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; font-size: 1rem;
        }

        /* CHART CARDS */
        .chart-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px; padding: 28px; height: 100%;
        }
        .chart-card h6 { color: white; font-weight: 700; margin-bottom: 20px; font-size: 0.95rem; }
    </style>
</head>
<body>
    <jsp:include page="FacultyNavbar.jsp" />

    <div class="page-container">

        <!-- Hero -->
        <div class="dash-hero">
            <div>
                <h1>📊 Faculty Dashboard</h1>
                <p>Manage students, quizzes, and AI-powered question generation from here.</p>
            </div>
            <a href="generateQuestions" style="background:linear-gradient(135deg,#6366f1,#8b5cf6);border:none;color:white;border-radius:12px;padding:12px 22px;font-weight:700;font-size:0.9rem;text-decoration:none;box-shadow:0 6px 20px rgba(99,102,241,0.4);transition:all 0.3s;display:inline-flex;align-items:center;gap:8px;">
                <i class="bi bi-stars"></i> AI Generate Questions
            </a>
        </div>

        <!-- KPI Row -->
        <p class="section-label">Overview</p>
        <div class="row g-4 mb-5">
            <div class="col-6 col-md-3">
                <div class="kpi-card" style="--kpi-color: linear-gradient(90deg,#6366f1,#818cf8);">
                    <div class="kpi-icon" style="background:rgba(99,102,241,0.15);color:#818cf8;"><i class="bi bi-mortarboard-fill"></i></div>
                    <div class="kpi-number">${studentCount}</div>
                    <div class="kpi-label">Registered Students</div>
                    <a href="ShowAllStudent?name=student" class="kpi-link">View all <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="kpi-card" style="--kpi-color: linear-gradient(90deg,#06b6d4,#22d3ee);">
                    <div class="kpi-icon" style="background:rgba(6,182,212,0.15);color:#22d3ee;"><i class="bi bi-question-circle-fill"></i></div>
                    <div class="kpi-number">${qnCount}</div>
                    <div class="kpi-label">Questions in Bank</div>
                    <a href="AllQuestion" class="kpi-link">Manage <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="kpi-card" style="--kpi-color: linear-gradient(90deg,#10b981,#34d399);">
                    <div class="kpi-icon" style="background:rgba(16,185,129,0.15);color:#34d399;"><i class="bi bi-collection-fill"></i></div>
                    <div class="kpi-number">${quizCount}</div>
                    <div class="kpi-label">Active Quizzes</div>
                    <a href="manageQuizzes" class="kpi-link">Manage <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="kpi-card" style="--kpi-color: linear-gradient(90deg,#f59e0b,#fbbf24);">
                    <div class="kpi-icon" style="background:rgba(245,158,11,0.15);color:#fbbf24;"><i class="bi bi-clipboard-data-fill"></i></div>
                    <div class="kpi-number"><i class="bi bi-graph-up-arrow" style="font-size:1.8rem;"></i></div>
                    <div class="kpi-label">Student Results</div>
                    <a href="AllResults" class="kpi-link">View all <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <p class="section-label">Quick Actions</p>
        <div class="row g-3 mb-5">
            <div class="col-6 col-md-3">
                <a href="ShowAllStudent?name=student" class="action-card">
                    <div class="action-icon" style="background:rgba(99,102,241,0.15);color:#818cf8;"><i class="bi bi-people-fill"></i></div>
                    <h6>All Students</h6>
                    <small>Monitor & manage student accounts</small>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="createQuiz" class="action-card">
                    <div class="action-icon" style="background:rgba(16,185,129,0.15);color:#34d399;"><i class="bi bi-plus-circle-fill"></i></div>
                    <h6>Create Quiz</h6>
                    <small>Build a new exam for students</small>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="manageQuizzes" class="action-card">
                    <div class="action-icon" style="background:rgba(6,182,212,0.15);color:#22d3ee;"><i class="bi bi-collection-fill"></i></div>
                    <h6>Manage Quizzes</h6>
                    <small>Edit, assign & reassign quizzes</small>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="AllResults" class="action-card">
                    <div class="action-icon" style="background:rgba(245,158,11,0.15);color:#fbbf24;"><i class="bi bi-bar-chart-fill"></i></div>
                    <h6>Student Results</h6>
                    <small>Review all exam scores & predictions</small>
                </a>
            </div>
        </div>

        <!-- Charts -->
        <p class="section-label">Analytics</p>
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="chart-card">
                    <h6><i class="bi bi-bar-chart-fill me-2" style="color:#818cf8;"></i>Average Scores Per Quiz</h6>
                    <canvas id="quizChart"></canvas>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="chart-card d-flex flex-column">
                    <h6><i class="bi bi-pie-chart-fill me-2" style="color:#22d3ee;"></i>Quiz Attempt Distribution</h6>
                    <div class="d-flex justify-content-center align-items-center flex-grow-1">
                        <canvas id="attemptsChart" style="max-height:240px;"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
        const darkTooltip = {
            backgroundColor: 'rgba(10,15,30,0.92)',
            borderColor: 'rgba(99,102,241,0.3)', borderWidth: 1,
            titleColor: '#e2e8f0', bodyColor: '#818cf8'
        };
        document.addEventListener("DOMContentLoaded", function () {
            const labels = [<c:forEach items="${quizLabels}" var="label" varStatus="loop">"${label}"${!loop.last ? ',' : ''}</c:forEach>];
            const dataPoints = [<c:forEach items="${quizAverages}" var="avg" varStatus="loop">${avg}${!loop.last ? ',' : ''}</c:forEach>];
            const attemptsPoints = [<c:forEach items="${quizAttempts}" var="attempt" varStatus="loop">${attempt}${!loop.last ? ',' : ''}</c:forEach>];

            new Chart(document.getElementById('quizChart').getContext('2d'), {
                type: 'bar',
                data: { labels, datasets: [{ label: 'Avg Score (%)', data: dataPoints,
                    backgroundColor: 'rgba(99,102,241,0.55)', borderColor: '#818cf8',
                    borderWidth: 1.5, borderRadius: 8, borderSkipped: false }] },
                options: { responsive: true,
                    plugins: { legend: { display: false }, tooltip: { ... darkTooltip, callbacks: { label: c => ' ' + c.raw + '%' } } },
                    scales: {
                        y: { beginAtZero:true, max:100, grid:{color:'rgba(255,255,255,0.05)'}, ticks:{color:'rgba(255,255,255,0.4)', callback: v => v+'%'} },
                        x: { grid:{color:'rgba(255,255,255,0.04)'}, ticks:{color:'rgba(255,255,255,0.4)'} }
                    }
                }
            });

            new Chart(document.getElementById('attemptsChart').getContext('2d'), {
                type: 'doughnut',
                data: { labels, datasets: [{ data: attemptsPoints,
                    backgroundColor: ['#6366f1','#10b981','#f59e0b','#06b6d4','#8b5cf6','#ef4444','#14b8a6'],
                    borderWidth: 0, hoverOffset: 6 }] },
                options: { responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { position:'bottom', labels:{ color:'rgba(255,255,255,0.5)', padding:12, font:{size:11} } }, tooltip: darkTooltip }
                }
            });
        });
    </script>
    <%@ include file="global-utils.jsp" %>
</body>
</html>