<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Quiz — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body {
            background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0;
            min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 24px;
        }
        .form-card {
            width: 100%; max-width: 540px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 22px; overflow: hidden;
            box-shadow: 0 24px 60px rgba(0,0,0,0.4);
            animation: slideUp 0.5s ease;
        }
        @keyframes slideUp { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
        .form-header {
            background: linear-gradient(135deg, rgba(99,102,241,0.3), rgba(139,92,246,0.2));
            border-bottom: 1px solid rgba(255,255,255,0.08);
            padding: 28px 32px;
        }
        .form-header h4 { font-weight: 800; font-size: 1.25rem; color: white; margin: 0; }
        .form-header p { color: rgba(255,255,255,0.4); font-size: 0.85rem; margin: 5px 0 0; }
        .form-body { padding: 32px; }
        .form-label { color: rgba(255,255,255,0.65); font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .input-group-text { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12); border-right: none; color: rgba(255,255,255,0.4); }
        .form-control, .form-select {
            background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12);
            border-left: none; color: white; padding: 11px 14px; font-family: 'Inter', sans-serif;
        }
        .form-control:not(.standalone) { border-left: none; }
        .form-control.standalone { border-left: 1px solid rgba(255,255,255,0.12); border-radius: 10px !important; }
        .form-control::placeholder { color: rgba(255,255,255,0.2); }
        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.09); border-color: rgba(99,102,241,0.5);
            color: white; box-shadow: 0 0 0 3px rgba(99,102,241,0.12);
        }
        .form-select option { background: #1a1a2e; color: white; }
        .input-group .input-group-text { border-radius: 10px 0 0 10px; }
        .input-group .form-control, .input-group .form-select { border-radius: 0 10px 10px 0; }
        .btn-submit {
            background: linear-gradient(135deg, #6366f1, #8b5cf6); border: none; color: white;
            font-weight: 700; font-size: 0.9rem; padding: 13px; border-radius: 12px; width: 100%;
            box-shadow: 0 6px 18px rgba(99,102,241,0.35); transition: all 0.25s;
        }
        .btn-submit:hover { opacity: 0.9; transform: translateY(-1px); color: white; }
        .btn-back {
            background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.6); border-radius: 12px; padding: 13px; width: 100%;
            font-weight: 600; font-size: 0.875rem; text-decoration: none;
            display: flex; align-items: center; justify-content: center; gap: 7px; transition: all 0.2s;
        }
        .btn-back:hover { background: rgba(255,255,255,0.09); color: white; }
        .section-divider { color: rgba(255,255,255,0.2); font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; display: flex; align-items: center; gap: 10px; margin: 20px 0 16px; }
        .section-divider::before, .section-divider::after { content:''; flex:1; height:1px; background:rgba(255,255,255,0.07); }
    </style>
</head>
<body>
    <div class="form-card">
        <div class="form-header">
            <h4><i class="bi bi-plus-circle-fill me-2" style="color:#818cf8;"></i>Create New Quiz</h4>
            <p>Set up a new exam for your students</p>
        </div>
        <div class="form-body">
            <form action="saveQuiz" method="post">
                <div class="mb-4">
                    <label class="form-label">Quiz Name</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-journal-text"></i></span>
                        <input type="text" class="form-control" name="quizName" placeholder="e.g. Java Midterm Exam" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label">Subject / Technology</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-book"></i></span>
                        <input type="text" class="form-control" name="techName" placeholder="e.g. Core Java, Data Structures, etc." required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label">Time Limit (minutes)</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-clock"></i></span>
                        <input type="number" class="form-control" name="timeInMinutes" value="10" min="1" max="180" required>
                    </div>
                </div>
                <div class="section-divider">Optional Scheduling</div>
                <div class="row g-3 mb-4">
                    <div class="col-6">
                        <label class="form-label">Start Date/Time</label>
                        <input type="datetime-local" class="form-control standalone" name="startDateTime">
                    </div>
                    <div class="col-6">
                        <label class="form-label">End Date/Time</label>
                        <input type="datetime-local" class="form-control standalone" name="endDateTime">
                    </div>
                </div>
                <div class="d-grid gap-3">
                    <button type="submit" class="btn-submit"><i class="bi bi-check-circle me-2"></i>Create Quiz</button>
                    <a href="manageQuizzes" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Quizzes</a>
                </div>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>