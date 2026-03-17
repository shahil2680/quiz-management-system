<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Assign Questions - ${quiz.quizName}</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
            <style>
                body {
                    background-color: #f4f6f9;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    padding: 30px;
                }

                .card {
                    border: none;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                }

                .card-header {
                    background: #34495e;
                    color: white;
                    border-radius: 12px 12px 0 0 !important;
                }

                .question-row {
                    transition: background 0.2s;
                }

                .question-row:hover {
                    background: #eaf2ff;
                }

                .form-check-input:checked {
                    background-color: #0d6efd;
                    border-color: #0d6efd;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="card">
                    <div class="card-header p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0"><i class="bi bi-list-check me-2"></i>Assign Questions to:
                                    ${quiz.quizName}</h4>
                                <small class="text-light">Subject: ${quiz.techno.techName} | Time: ${quiz.timeInMinutes}
                                    min</small>
                            </div>
                            <a href="getAllTech" class="btn btn-warning btn-sm"><i
                                    class="bi bi-plus-circle me-1"></i>Add New Question</a>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty allQuestions}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-question-circle" style="font-size: 3rem;"></i>
                                <p class="mt-3">No questions found in the question bank. Add some questions first!</p>
                                <a href="getAllTech" class="btn btn-primary"><i class="bi bi-plus-circle me-1"></i>Add
                                    Questions</a>
                            </div>
                        </c:if>
                        <c:if test="${not empty allQuestions}">
                            <form action="saveQuizQuestions" method="post">
                                <input type="hidden" name="quizId" value="${quiz.quizId}">

                                <div class="mb-3 d-flex justify-content-between align-items-center">
                                    <span class="text-muted">${fn:length(allQuestions)} questions available. Check the
                                        ones to include in this quiz.</span>
                                    <div>
                                        <button type="button" class="btn btn-outline-primary btn-sm"
                                            onclick="selectAll()"><i class="bi bi-check-all me-1"></i>Select
                                            All</button>
                                        <button type="button" class="btn btn-outline-secondary btn-sm"
                                            onclick="deselectAll()"><i class="bi bi-x-circle me-1"></i>Deselect
                                            All</button>
                                    </div>
                                </div>

                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 50px;"><i class="bi bi-check2-square"></i></th>
                                            <th>Question</th>
                                            <th>Subject</th>
                                            <th>Options</th>
                                            <th>Answer</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="q" items="${allQuestions}">
                                            <tr class="question-row">
                                                <td>
                                                    <input class="form-check-input q-checkbox" type="checkbox"
                                                        name="questionIds" value="${q.qid}" <c:forEach var="assigned"
                                                        items="${quiz.questions}">
                                                    <c:if test="${assigned.qid == q.qid}">checked</c:if>
                                        </c:forEach>
                                        >
                                        </td>
                                        <td class="fw-bold">${q.qname}</td>
                                        <td><span class="badge bg-info text-dark">${q.techId.techName}</span></td>
                                        <td class="small text-muted">
                                            ${q.opt1}, ${q.opt2}, ${q.opt3}, ${q.opt4}
                                        </td>
                                        <td><span class="badge bg-success">${q.correct_Opt}</span></td>
                                        </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <div class="d-grid gap-2 mt-3">
                                    <button type="submit" class="btn btn-primary"><i class="bi bi-save me-2"></i>Save
                                        Question Assignment</button>
                                </div>
                            </form>
                        </c:if>
                        <div class="text-center mt-4">
                            <a href="manageQuizzes" class="btn btn-outline-secondary px-4"><i
                                    class="bi bi-arrow-left me-2"></i>Back to Quizzes</a>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                function selectAll() { document.querySelectorAll('.q-checkbox').forEach(cb => cb.checked = true); }
                function deselectAll() { document.querySelectorAll('.q-checkbox').forEach(cb => cb.checked = false); }
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>