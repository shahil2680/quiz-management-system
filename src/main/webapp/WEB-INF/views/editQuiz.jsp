<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Edit Quiz</title>
            <!-- Bootstrap 5 CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Bootstrap Icons -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
            <style>
                body {
                    background-color: #f4f6f9;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .form-card {
                    border: none;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                }

                .form-header {
                    background: #34495e;
                    color: white;
                    border-radius: 12px 12px 0 0;
                    padding: 20px;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: #3498db;
                    box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
                }
            </style>
        </head>

        <body>

            <div class="container py-5">
                <div class="row justify-content-center">
                    <div class="col-lg-6 col-md-8">
                        <div class="card form-card">
                            <div class="form-header d-flex align-items-center">
                                <i class="bi bi-pencil-square fs-3 me-3"></i>
                                <div>
                                    <h4 class="mb-0">Edit Quiz</h4>
                                    <small class="opacity-75">Update quiz details</small>
                                </div>
                            </div>

                            <div class="card-body p-4">
                                <form action="updateQuiz" method="post">
                                    <input type="hidden" name="quizId" value="${quiz.quizId}">

                                    <div class="mb-4">
                                        <label for="quizName" class="form-label fw-bold">Quiz Name <span
                                                class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i
                                                    class="bi bi-card-text"></i></span>
                                            <input type="text" class="form-control" id="quizName" name="quizName"
                                                value="${quiz.quizName}" required placeholder="e.g. Core Java Midterm">
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="techId" class="form-label fw-bold">Subject / Technology <span
                                                class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i class="bi bi-book"></i></span>
                                            <select class="form-select" id="techId" name="techId" required>
                                                <c:forEach var="tech" items="${technos}">
                                                    <option value="${tech.techId}" ${quiz.techno.techId==tech.techId
                                                        ? 'selected' : '' }>${tech.techName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="timeInMinutes" class="form-label fw-bold">Time Limit (Minutes) <span
                                                class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light"><i
                                                    class="bi bi-stopwatch"></i></span>
                                            <input type="number" class="form-control" id="timeInMinutes"
                                                name="timeInMinutes" value="${quiz.timeInMinutes}" required min="1"
                                                placeholder="e.g. 15">
                                        </div>
                                        <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i>The quiz will
                                            automatically submit when this time limit is reached.</div>
                                    </div>

                                    <div class="d-flex justify-content-end gap-3 pt-3 border-top mt-4">
                                        <a href="manageQuizzes" class="btn btn-outline-secondary px-4"><i
                                                class="bi bi-x-circle me-2"></i>Cancel</a>
                                        <button type="submit" class="btn btn-primary px-4"><i
                                                class="bi bi-save me-2"></i>Save Changes</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>