<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Edit Question</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
                    <div class="col-lg-8">
                        <div class="card form-card">
                            <div class="form-header d-flex align-items-center">
                                <i class="bi bi-pencil-square fs-3 me-3"></i>
                                <h4 class="mb-0">Edit Question</h4>
                            </div>

                            <div class="card-body p-4">
                                <form action="updateQuestion" method="post" id="editForm" enctype="multipart/form-data">
                                    <input type="hidden" name="qid" value="${question.qid}">

                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Select Subject/Technology <span
                                                class="text-danger">*</span></label>
                                        <select class="form-select" name="techId" required>
                                            <c:forEach var="tech" items="${technos}">
                                                <option value="${tech.techId}" ${question.techId.techId==tech.techId
                                                    ? 'selected' : '' }>${tech.techName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Question Text <span
                                                class="text-danger">*</span></label>
                                        <textarea class="form-control" name="qname" rows="3" required
                                            placeholder="Enter the question here...">${question.qname}</textarea>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Update Question Image (Optional)</label>
                                        <c:if test="${not empty question.imagePath}">
                                            <div class="mb-2">
                                                <img src="/uploads/${question.imagePath}" alt="Question Image"
                                                    class="img-thumbnail" style="max-height: 150px;">
                                                <p class="text-muted small">Current image</p>
                                            </div>
                                        </c:if>
                                        <input type="file" class="form-control" name="imageFile" accept="image/*">
                                    </div>

                                    <div class="row g-3 mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label text-muted small mb-1">Option 1</label>
                                            <textarea class="form-control" name="opt1" rows="2" required
                                                placeholder="Option 1 text">${question.opt1}</textarea>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label text-muted small mb-1">Option 2</label>
                                            <textarea class="form-control" name="opt2" rows="2" required
                                                placeholder="Option 2 text">${question.opt2}</textarea>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label text-muted small mb-1">Option 3</label>
                                            <textarea class="form-control" name="opt3" rows="2" required
                                                placeholder="Option 3 text">${question.opt3}</textarea>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label text-muted small mb-1">Option 4</label>
                                            <textarea class="form-control" name="opt4" rows="2" required
                                                placeholder="Option 4 text">${question.opt4}</textarea>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Correct Option <span
                                                class="text-danger">*</span></label>
                                        <select class="form-select" name="correct_Opt" required>
                                            <option value="Option 1" ${question.correct_Opt=='Option 1' ? 'selected'
                                                : '' }>Option 1</option>
                                            <option value="Option 2" ${question.correct_Opt=='Option 2' ? 'selected'
                                                : '' }>Option 2</option>
                                            <option value="Option 3" ${question.correct_Opt=='Option 3' ? 'selected'
                                                : '' }>Option 3</option>
                                            <option value="Option 4" ${question.correct_Opt=='Option 4' ? 'selected'
                                                : '' }>Option 4</option>
                                        </select>
                                    </div>

                                    <div class="d-flex justify-content-end gap-3 pt-3 border-top">
                                        <a href="AllQuestion" class="btn btn-outline-secondary px-4"><i
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

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>