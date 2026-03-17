<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="ISO-8859-1">
            <title>Add Question</title>
            <!-- Bootstrap 5 CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Bootstrap Icons -->
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
                    max-width: 600px;
                    margin: auto;
                }

                .card-header {
                    background: #34495e;
                    color: white;
                    border-radius: 12px 12px 0 0 !important;
                    padding: 20px;
                    text-align: center;
                }

                .form-control,
                .form-select {
                    border-radius: 8px;
                }

                .btn-success {
                    border-radius: 8px;
                    padding: 10px 20px;
                    font-weight: 600;
                }
            </style>
        </head>

        <body>

            <div class="container">

                <div class="mb-4 d-flex align-items-center">
                    <a href="javascript:history.back()" class="btn btn-outline-secondary me-3"><i
                            class="bi bi-arrow-left"></i> Back</a>
                    <h3 class="m-0 text-secondary"><i class="bi bi-patch-question me-2"></i>Question Management</h3>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Add New Question</h4>
                    </div>
                    <div class="card-body p-4">

                        <c:if test="${not empty msg}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i> ${msg}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="saveQuestion" method="POST" enctype="multipart/form-data">
                            <!-- CSRF Token -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <!-- Question Input -->
                            <div class="mb-4">
                                <label for="question" class="form-label fw-bold">Question Text</label>
                                <textarea class="form-control" id="question" name="qname" rows="3" required
                                    placeholder="Enter the question here..."></textarea>
                            </div>

                            <!-- Optional Image Input -->
                            <div class="mb-4">
                                <label for="imageFile" class="form-label fw-bold">Question Image (Optional)</label>
                                <input type="file" class="form-control" id="imageFile" name="imageFile"
                                    accept="image/*">
                            </div>

                            <!-- Options Input -->
                            <label class="form-label fw-bold">Answer Options</label>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-primary fw-bold">1</span>
                                        <input type="text" class="form-control" name="opt1" placeholder="Option 1"
                                            required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-primary fw-bold">2</span>
                                        <input type="text" class="form-control" name="opt2" placeholder="Option 2"
                                            required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-primary fw-bold">3</span>
                                        <input type="text" class="form-control" name="opt3" placeholder="Option 3"
                                            required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-primary fw-bold">4</span>
                                        <input type="text" class="form-control" name="opt4" placeholder="Option 4"
                                            required>
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <!-- Correct Solution Dropdown -->
                                <div class="col-md-6">
                                    <label for="correctSolution" class="form-label fw-bold">Correct Solution</label>
                                    <select class="form-select border-success border-2 pr-4" id="correctSolution"
                                        name="correct_Opt">
                                        <option value="Option 1">Option 1</option>
                                        <option value="Option 2">Option 2</option>
                                        <option value="Option 3">Option 3</option>
                                        <option value="Option 4">Option 4</option>
                                    </select>
                                </div>

                                <!-- Technology Dropdown -->
                                <div class="col-md-6">
                                    <label for="technology" class="form-label fw-bold">Category / Technology</label>
                                    <select class="form-select" id="technology" name="technoName">
                                        <c:forEach var="one" items="${techName}">
                                            <option value="${one }">${one }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-success btn-lg"><i class="bi bi-save me-2"></i>Save
                                    Question</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>