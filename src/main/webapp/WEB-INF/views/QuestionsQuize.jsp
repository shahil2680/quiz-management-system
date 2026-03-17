<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty quizName ? quizName : 'Quiz'} — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0; min-height: 100vh; padding: 0; margin: 0; }

        /* TOP BAR */
        .quiz-topbar {
            background: rgba(10,15,30,0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255,255,255,0.08);
            padding: 14px 28px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
        }
        .quiz-title { font-weight: 700; font-size: 1rem; color: white; }
        .quiz-subtitle { font-size: 0.75rem; color: rgba(255,255,255,0.4); }

        /* TIMER */
        .timer-chip {
            display: flex; align-items: center; gap: 8px;
            background: rgba(239,68,68,0.12);
            border: 1px solid rgba(239,68,68,0.3);
            border-radius: 24px; padding: 8px 18px;
            font-weight: 700; font-size: 1.2rem; color: #f87171;
            font-variant-numeric: tabular-nums;
            transition: all 0.3s;
        }
        .timer-chip.warn { background: rgba(245,158,11,0.15); border-color: rgba(245,158,11,0.4); color: #fbbf24; animation: pulse-timer 1s ease infinite; }
        .timer-chip.danger { background: rgba(239,68,68,0.2); border-color: rgba(239,68,68,0.5); color: #fca5a5; animation: pulse-timer 0.5s ease infinite; }
        @keyframes pulse-timer { 0%,100%{opacity:1;} 50%{opacity:0.6;} }

        /* PROGRESS BAR */
        .progress-container { padding: 0 28px 0; margin-top: -1px; }
        .progress-track { height: 4px; background: rgba(255,255,255,0.08); }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #6366f1, #8b5cf6); transition: width 0.4s ease; border-radius: 0; }

        /* QUESTION NAVIGATOR DOTS */
        .q-dots { display: flex; gap: 6px; flex-wrap: wrap; padding: 14px 28px; justify-content: center; }
        .q-dot {
            width: 32px; height: 32px; border-radius: 8px; font-size: 0.72rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center; cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.05);
            color: rgba(255,255,255,0.4); transition: all 0.2s;
        }
        .q-dot.answered { background: rgba(16,185,129,0.2); border-color: rgba(16,185,129,0.4); color: #34d399; }
        .q-dot.current { background: rgba(99,102,241,0.3); border-color: #818cf8; color: white; }
        .q-dot.skipped { background: rgba(245,158,11,0.15); border-color: rgba(245,158,11,0.3); color: #fbbf24; }

        /* MAIN CONTENT */
        .quiz-content { max-width: 760px; margin: 0 auto; padding: 28px 24px 100px; }

        /* QUESTION PANEL */
        .q-panel { display: none; animation: fadeIn 0.3s ease; }
        .q-panel.active { display: block; }
        @keyframes fadeIn { from{opacity:0;transform:translateX(20px);} to{opacity:1;transform:translateX(0);} }

        .q-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 20px; overflow: hidden;
            box-shadow: 0 16px 40px rgba(0,0,0,0.3);
        }
        .q-header {
            background: linear-gradient(135deg, rgba(99,102,241,0.2), rgba(139,92,246,0.1));
            border-bottom: 1px solid rgba(255,255,255,0.07);
            padding: 22px 28px;
        }
        .q-number { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1.5px; color: #818cf8; margin-bottom: 8px; }
        .q-type-badge { display: inline-flex; align-items: center; gap: 4px; background: rgba(99,102,241,0.15); border: 1px solid rgba(99,102,241,0.25); color: #a5b4fc; border-radius: 20px; padding: 3px 10px; font-size: 0.7rem; font-weight: 700; margin-left: 8px; }
        .q-text { font-size: 1.1rem; font-weight: 600; color: white; line-height: 1.6; margin: 0; }
        .q-body { padding: 28px; }

        /* QUESTION IMAGE */
        .q-image { margin-bottom: 20px; }
        .q-image img { max-height: 220px; width: 100%; object-fit: contain; border-radius: 12px; border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.03); }

        /* MCQ OPTIONS */
        .option-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 18px; border-radius: 12px; margin-bottom: 10px;
            border: 1.5px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.03);
            cursor: pointer; transition: all 0.2s;
        }
        .option-item:hover { border-color: rgba(99,102,241,0.4); background: rgba(99,102,241,0.07); }
        .option-item.selected { border-color: #6366f1; background: rgba(99,102,241,0.15); }
        .option-letter {
            width: 32px; height: 32px; border-radius: 8px; flex-shrink: 0;
            border: 1.5px solid rgba(255,255,255,0.2);
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.85rem; color: rgba(255,255,255,0.6);
            transition: all 0.2s;
        }
        .option-item.selected .option-letter { background: #6366f1; border-color: #6366f1; color: white; }
        .option-text { font-size: 0.95rem; color: #e2e8f0; flex: 1; }
        input[type="radio"].hidden-radio, input[type="checkbox"].hidden-radio { display: none; }

        /* TRUE/FALSE */
        .tf-options { display: flex; gap: 14px; }
        .tf-btn {
            flex: 1; padding: 18px; border-radius: 14px; border: 1.5px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.04); cursor: pointer; text-align: center;
            font-weight: 700; font-size: 1rem; color: rgba(255,255,255,0.6); transition: all 0.2s;
        }
        .tf-btn:hover { border-color: rgba(99,102,241,0.4); background: rgba(99,102,241,0.08); }
        .tf-btn.selected.true-btn { border-color: #10b981; background: rgba(16,185,129,0.15); color: #34d399; }
        .tf-btn.selected.false-btn { border-color: #ef4444; background: rgba(239,68,68,0.15); color: #f87171; }
        .tf-btn i { display: block; font-size: 1.5rem; margin-bottom: 6px; }

        /* SHORT ANSWER */
        .short-answer-input {
            width: 100%; background: rgba(255,255,255,0.06);
            border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: 12px; padding: 14px 18px; color: white;
            font-family: 'Inter', sans-serif; font-size: 0.95rem; resize: vertical; min-height: 100px;
            transition: border-color 0.2s;
        }
        .short-answer-input:focus { outline: none; border-color: rgba(99,102,241,0.5); background: rgba(255,255,255,0.08); }
        .short-answer-input::placeholder { color: rgba(255,255,255,0.2); }

        /* NAVIGATION BUTTONS */
        .q-nav { display: flex; justify-content: space-between; align-items: center; margin-top: 28px; gap: 12px; }
        .btn-nav {
            display: flex; align-items: center; gap: 7px;
            padding: 12px 22px; border-radius: 12px; font-weight: 700; font-size: 0.875rem;
            border: 1.5px solid rgba(255,255,255,0.12);
            background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.7);
            cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
        }
        .btn-nav:hover { background: rgba(255,255,255,0.1); color: white; }
        .btn-nav:disabled { opacity: 0.3; cursor: not-allowed; }
        .btn-next {
            background: linear-gradient(135deg, #6366f1, #8b5cf6); border: none; color: white;
            box-shadow: 0 4px 14px rgba(99,102,241,0.35);
        }
        .btn-next:hover { opacity: 0.9; color: white; transform: translateX(2px); }
        .btn-submit-final {
            background: linear-gradient(135deg, #10b981, #059669); border: none; color: white;
            box-shadow: 0 4px 14px rgba(16,185,129,0.35); flex: 1;
        }
        .btn-submit-final:hover { opacity: 0.9; color: white; }
        .btn-skip {
            background: rgba(245,158,11,0.1); border-color: rgba(245,158,11,0.25); color: #fbbf24;
        }
        .btn-skip:hover { background: rgba(245,158,11,0.18); color: #fde68a; }

        /* SAVE INDICATOR */
        .save-indicator { font-size: 0.72rem; color: rgba(255,255,255,0.3); display: flex; align-items: center; gap: 4px; }
        .save-dot { width: 6px; height: 6px; border-radius: 50%; background: #34d399; margin-right: 2px; }

        /* BOTTOM FIXED PANEL */
        .quiz-bottom { position: fixed; bottom: 0; left: 0; right: 0; background: rgba(10,15,30,0.97); border-top: 1px solid rgba(255,255,255,0.08); padding: 12px 24px; display: flex; justify-content: center; gap: 8px; z-index: 50; flex-wrap: wrap; }
        .summary-stat { display: flex; align-items: center; gap: 6px; font-size: 0.8rem; color: rgba(255,255,255,0.4); }
        .summary-dot { width: 8px; height: 8px; border-radius: 50%; }
    </style>
</head>
<body>

    <!-- TOP BAR -->
    <div class="quiz-topbar">
        <div>
            <div class="quiz-title"><i class="bi bi-laptop me-2" style="color:#818cf8;"></i>${not empty quizName ? quizName : 'Quiz Examination'}</div>
            <div class="quiz-subtitle">Answer all questions carefully</div>
        </div>
        <div class="timer-chip" id="timerChip">
            <i class="bi bi-stopwatch-fill"></i>
            <span id="timerDisplay">--:--</span>
        </div>
    </div>

    <!-- PROGRESS BAR -->
    <div class="progress-track">
        <div class="progress-fill" id="progressFill" style="width:0%;"></div>
    </div>

    <!-- QUESTION NAVIGATOR DOTS -->
    <div class="q-dots" id="qDots"></div>

    <!-- MAIN FORM -->
    <form action="checkAns" method="post" id="quizForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="quizId" value="${quizId}" />

        <div class="quiz-content">
            <c:forEach var="question" items="${Questions}" varStatus="loop">
                <div class="q-panel ${loop.index == 0 ? 'active' : ''}" id="panel_${loop.index}" data-index="${loop.index}">

                    <!-- Hidden question ID -->
                    <input type="hidden" name="questionIds" value="${question.qid}">

                    <div class="q-card">
                        <div class="q-header">
                            <div class="q-number">
                                Question ${loop.index + 1} of ${fn:length(Questions)}
                                <span class="q-type-badge">
                                    <c:choose>
                                        <c:when test="${question.questionType == 'TRUE_FALSE'}"><i class="bi bi-check2-circle"></i> True/False</c:when>
                                        <c:when test="${question.questionType == 'SHORT_ANSWER' or question.questionType == 'SUBJECTIVE'}"><i class="bi bi-pencil"></i> Short Answer</c:when>
                                        <c:otherwise><i class="bi bi-list-ul"></i> Multiple Choice</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <p class="q-text">${question.qname}</p>
                        </div>
                        <div class="q-body">
                            <!-- QUESTION IMAGE -->
                            <c:if test="${not empty question.imagePath}">
                                <div class="q-image">
                                    <a href="/uploads/${question.imagePath}" target="_blank">
                                        <img src="/uploads/${question.imagePath}" alt="Question Image">
                                    </a>
                                </div>
                            </c:if>

                            <!-- ===================== MCQ OPTIONS ===================== -->
                            <c:if test="${question.questionType == 'MCQ' or empty question.questionType}">
                                <div class="options-group" id="opts_${question.qid}">
                                    <c:set var="opts" value="${[question.opt1, question.opt2, question.opt3, question.opt4]}" />
                                    <c:set var="letters" value="${['A','B','C','D']}" />
                                    <c:forEach var="opt" items="${[question.opt1, question.opt2, question.opt3, question.opt4]}" varStatus="oi">
                                        <c:if test="${not empty opt}">
                                            <label class="option-item" id="lbl_${question.qid}_${oi.index}" onclick="selectMCQ(${question.qid}, ${oi.index}, 'Option ${oi.index + 1}', ${loop.index})">
                                                <input type="radio" class="hidden-radio" name="${question.qid}" value="Option ${oi.index + 1}" id="r_${question.qid}_${oi.index}">
                                                <span class="option-letter" id="ol_${question.qid}_${oi.index}">${['A','B','C','D'][oi.index]}</span>
                                                <span class="option-text">${opt}</span>
                                            </label>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- ===================== TRUE/FALSE ===================== -->
                            <c:if test="${question.questionType == 'TRUE_FALSE'}">
                                <div class="tf-options">
                                    <div class="tf-btn true-btn" id="tf_true_${question.qid}" onclick="selectTF(${question.qid}, 'Option 1', ${loop.index}, this)">
                                        <input type="radio" class="hidden-radio" name="${question.qid}" value="Option 1" id="tf_r_true_${question.qid}">
                                        <i class="bi bi-check-circle-fill" style="color:#34d399;"></i>
                                        True
                                    </div>
                                    <div class="tf-btn false-btn" id="tf_false_${question.qid}" onclick="selectTF(${question.qid}, 'Option 2', ${loop.index}, this)">
                                        <input type="radio" class="hidden-radio" name="${question.qid}" value="Option 2" id="tf_r_false_${question.qid}">
                                        <i class="bi bi-x-circle-fill" style="color:#f87171;"></i>
                                        False
                                    </div>
                                </div>
                            </c:if>

                            <!-- ===================== SHORT ANSWER / SUBJECTIVE ===================== -->
                            <c:if test="${question.questionType == 'SHORT_ANSWER' or question.questionType == 'SUBJECTIVE'}">
                                <div>
                                    <textarea class="short-answer-input" name="${question.qid}_text" id="sa_${question.qid}"
                                        placeholder="Type your answer here..."
                                        oninput="markShortAnswer(${loop.index}, ${question.qid}, this.value)"></textarea>
                                    <!-- Hidden radio for form compatibility - short answers use option 1 -->
                                    <input type="hidden" name="${question.qid}" value="" id="sa_hidden_${question.qid}">
                                    <p style="color:rgba(255,255,255,0.3);font-size:0.78rem;margin-top:8px;"><i class="bi bi-info-circle me-1"></i>This answer will be AI-graded based on accuracy and completeness.</p>
                                </div>
                            </c:if>

                            <!-- SAVE INDICATOR -->
                            <div class="save-indicator mt-3" id="saveInd_${loop.index}">
                                <span class="save-dot" id="saveDot_${loop.index}" style="background:rgba(255,255,255,0.2);"></span>
                                <span id="saveText_${loop.index}">Not answered yet</span>
                            </div>
                        </div>
                    </div>

                    <!-- NAVIGATION BUTTONS -->
                    <div class="q-nav">
                        <button type="button" class="btn-nav" onclick="goTo(${loop.index - 1})" ${loop.index == 0 ? 'disabled' : ''}>
                            <i class="bi bi-arrow-left"></i> Previous
                        </button>
                        <button type="button" class="btn-nav btn-skip" onclick="skipQuestion(${loop.index})">
                            <i class="bi bi-skip-forward"></i> Skip
                        </button>
                        <c:choose>
                            <c:when test="${loop.last}">
                                <button type="button" class="btn-nav btn-submit-final" onclick="confirmSubmit()">
                                    <i class="bi bi-check2-all"></i> Submit Exam
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn-nav btn-next" onclick="goTo(${loop.index + 1})">
                                    Next <i class="bi bi-arrow-right"></i>
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </c:forEach>
        </div>
    </form>

    <!-- BOTTOM SUMMARY BAR -->
    <div class="quiz-bottom">
        <span class="summary-stat"><span class="summary-dot" style="background:#34d399;"></span><span id="answeredCount">0</span> Answered</span>
        <span class="summary-stat"><span class="summary-dot" style="background:#fbbf24;"></span><span id="skippedCount">0</span> Skipped</span>
        <span class="summary-stat"><span class="summary-dot" style="background:rgba(255,255,255,0.2);"></span><span id="unansweredCount">${fn:length(Questions)}</span> Remaining</span>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const TOTAL = ${fn:length(Questions)};
        const QUIZ_KEY = 'quiz_${quizId}_progress';
        const TOTAL_SECONDS = ${ not empty timeInMinutes ? timeInMinutes : 10 } * 60;

        // State tracking
        const answeredState = {}; // index -> 'answered' | 'skipped' | null
        const savedAnswers = {};  // index -> answer value
        let currentIndex = 0;

        /* ============ INITIALIZATION ============ */
        document.addEventListener('DOMContentLoaded', () => {
            buildDots();
            restoreFromLocalStorage();
            updateProgress();
            startTimer();
            goTo(0);
        });

        /* ============ NAVIGATOR DOTS ============ */
        function buildDots() {
            const container = document.getElementById('qDots');
            for (let i = 0; i < TOTAL; i++) {
                const dot = document.createElement('div');
                dot.className = 'q-dot';
                dot.id = 'dot_' + i;
                dot.textContent = i + 1;
                dot.onclick = () => goTo(i);
                container.appendChild(dot);
            }
        }

        function updateDot(index) {
            for (let i = 0; i < TOTAL; i++) {
                const dot = document.getElementById('dot_' + i);
                dot.className = 'q-dot';
                if (i === currentIndex) dot.classList.add('current');
                else if (answeredState[i] === 'answered') dot.classList.add('answered');
                else if (answeredState[i] === 'skipped') dot.classList.add('skipped');
            }
        }

        /* ============ NAVIGATION ============ */
        function goTo(index) {
            if (index < 0 || index >= TOTAL) return;
            document.querySelectorAll('.q-panel').forEach(p => p.classList.remove('active'));
            const panel = document.getElementById('panel_' + index);
            if (panel) { panel.classList.add('active'); panel.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
            currentIndex = index;
            updateDot();
            updateProgress();
        }

        function skipQuestion(index) {
            if (answeredState[index] !== 'answered') {
                answeredState[index] = 'skipped';
                updateSaveIndicator(index, 'skipped');
            }
            updateSummaryBar();
            if (index < TOTAL - 1) goTo(index + 1);
        }

        /* ============ PROGRESS ============ */
        function updateProgress() {
            const pct = ((currentIndex + 1) / TOTAL) * 100;
            document.getElementById('progressFill').style.width = pct + '%';
        }

        /* ============ MCQ SELECTION ============ */
        function selectMCQ(qid, optIndex, value, panelIndex) {
            // Update radio
            document.getElementById('r_' + qid + '_' + optIndex).checked = true;
            // Visual feedback
            const opts = document.querySelectorAll('#opts_' + qid + ' .option-item');
            opts.forEach((o, i) => {
                o.classList.toggle('selected', i === optIndex);
            });
            markAnswered(panelIndex, value);
            saveToLocalStorage(panelIndex, qid, value);
        }

        /* ============ TRUE/FALSE ============ */
        function selectTF(qid, value, panelIndex, clickedBtn) {
            document.querySelector('[name="' + qid + '"][value="' + value + '"]').checked = true;
            const trueBtn = document.getElementById('tf_true_' + qid);
            const falseBtn = document.getElementById('tf_false_' + qid);
            trueBtn.classList.remove('selected');
            falseBtn.classList.remove('selected');
            clickedBtn.classList.add('selected');
            markAnswered(panelIndex, value);
            saveToLocalStorage(panelIndex, qid, value);
        }

        /* ============ SHORT ANSWER ============ */
        function markShortAnswer(panelIndex, qid, value) {
            const hidden = document.getElementById('sa_hidden_' + qid);
            if (value.trim().length > 0) {
                if (hidden) hidden.value = value;
                markAnswered(panelIndex, value);
            } else {
                if (hidden) hidden.value = '';
                answeredState[panelIndex] = null;
                updateSaveIndicator(panelIndex, null);
            }
            saveToLocalStorage(panelIndex, qid, value);
        }

        /* ============ STATE HELPERS ============ */
        function markAnswered(index, value) {
            answeredState[index] = 'answered';
            savedAnswers[index] = value;
            updateSaveIndicator(index, 'answered');
            updateSummaryBar();
            updateDot();
        }

        function updateSaveIndicator(index, state) {
            const dot = document.getElementById('saveDot_' + index);
            const text = document.getElementById('saveText_' + index);
            if (!dot || !text) return;
            if (state === 'answered') {
                dot.style.background = '#34d399'; text.textContent = 'Answer saved';
            } else if (state === 'skipped') {
                dot.style.background = '#fbbf24'; text.textContent = 'Skipped — come back later';
            } else {
                dot.style.background = 'rgba(255,255,255,0.2)'; text.textContent = 'Not answered yet';
            }
        }

        function updateSummaryBar() {
            const answered = Object.values(answeredState).filter(s => s === 'answered').length;
            const skipped = Object.values(answeredState).filter(s => s === 'skipped').length;
            const remaining = TOTAL - answered - skipped;
            document.getElementById('answeredCount').textContent = answered;
            document.getElementById('skippedCount').textContent = skipped;
            document.getElementById('unansweredCount').textContent = remaining;
        }

        /* ============ LOCAL STORAGE - AUTO SAVE ============ */
        function saveToLocalStorage(panelIndex, qid, value) {
            try {
                const data = JSON.parse(localStorage.getItem(QUIZ_KEY) || '{}');
                data['q_' + qid] = value;
                data['state_' + panelIndex] = answeredState[panelIndex];
                localStorage.setItem(QUIZ_KEY, JSON.stringify(data));
            } catch (e) {}
        }

        function restoreFromLocalStorage() {
            try {
                const data = JSON.parse(localStorage.getItem(QUIZ_KEY) || '{}');
                if (!data || Object.keys(data).length === 0) return;
                // Restore answered states from saved data (visual restore)
                // Full restoration would need panel-specific qid info; mark dots if state saved
                Object.keys(data).forEach(key => {
                    if (key.startsWith('state_')) {
                        const idx = parseInt(key.replace('state_', ''));
                        if (!isNaN(idx) && data[key]) {
                            answeredState[idx] = data[key];
                        }
                    }
                });
                updateSummaryBar();
                updateDot();
            } catch (e) {}
        }

        /* ============ SUBMIT ============ */
        function confirmSubmit() {
            const answered = Object.values(answeredState).filter(s => s === 'answered').length;
            const unanswered = TOTAL - answered;
            let msg = 'Ready to submit?\n\n';
            msg += '✅ Answered: ' + answered + ' of ' + TOTAL;
            if (unanswered > 0) msg += '\n⚠️ Unanswered/Skipped: ' + unanswered;
            msg += '\n\nYou cannot change your answers after submitting.';
            if (confirm(msg)) {
                localStorage.removeItem(QUIZ_KEY);
                window.onbeforeunload = null;
                document.getElementById('quizForm').submit();
            }
        }

        /* ============ TIMER ============ */
        function startTimer() {
            // Persist timer across reload with sessionStorage
            const timerKey = 'quizTimer_' + '${quizId}';
            let timeLeft;
            const saved = sessionStorage.getItem(timerKey);
            timeLeft = saved !== null ? parseInt(saved) : TOTAL_SECONDS;

            const chip = document.getElementById('timerChip');
            const display = document.getElementById('timerDisplay');

            display.textContent = formatTime(timeLeft);

            const countdown = setInterval(() => {
                timeLeft--;
                sessionStorage.setItem(timerKey, timeLeft);
                display.textContent = formatTime(timeLeft);

                if (timeLeft <= 120 && timeLeft > 30) {
                    chip.className = 'timer-chip warn';
                } else if (timeLeft <= 30) {
                    chip.className = 'timer-chip danger';
                }

                if (timeLeft <= 0) {
                    clearInterval(countdown);
                    sessionStorage.removeItem(timerKey);
                    localStorage.removeItem(QUIZ_KEY);
                    display.textContent = '0:00';
                    alert('⏰ Time is up! Your answers are being submitted.');
                    window.onbeforeunload = null;
                    document.getElementById('quizForm').submit();
                }
            }, 1000);
        }

        function formatTime(s) {
            const m = Math.floor(s / 60);
            const sec = s % 60;
            return m + ':' + (sec < 10 ? '0' : '') + sec;
        }

        /* ============ BEFOREUNLOAD GUARD ============ */
        window.onbeforeunload = () => 'Your quiz progress is saved locally, but leaving will stop your timer. Are you sure?';
        document.getElementById('quizForm').addEventListener('submit', () => { window.onbeforeunload = null; });
    </script>
</body>
</html>