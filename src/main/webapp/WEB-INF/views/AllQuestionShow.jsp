<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>All Questions</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
            <style>
                body {
                    background-color: #f4f6f9;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .question-card {
                    border: none;
                    border-radius: 12px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04);
                    margin-bottom: 16px;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .question-card:hover {
                    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.09);
                    transform: translateY(-2px);
                }

                .question-badge {
                    background: #34495e;
                    color: white;
                    border-radius: 5px;
                    padding: 4px 10px;
                    font-size: 0.85rem;
                    margin-right: 12px;
                }

                .correct-badge {
                    background: #27ae60;
                    color: white;
                    border-radius: 5px;
                    padding: 2px 10px;
                    font-size: 0.8rem;
                }

                .option-item {
                    padding: 7px 14px;
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 6px;
                    margin-bottom: 6px;
                    font-size: 0.9rem;
                }

                .option-item.correct-opt {
                    background: #d4edda;
                    border-color: #28a745;
                }

                .search-card {
                    border: none;
                    border-radius: 12px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                }
            </style>
        </head>

        <body>
            <div class="container py-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                    <h3 class="m-0 text-secondary"><i class="bi bi-ui-checks-grid me-2"></i>Question Bank</h3>
                    <div class="d-flex gap-2">
                        <a href="bulkImportQuestions" class="btn btn-outline-success btn-sm"><i
                                class="bi bi-upload me-1"></i>Bulk Import</a>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary btn-sm"><i
                                class="bi bi-arrow-left me-1"></i>Back</a>
                    </div>
                </div>

                <!-- Search & Filter Card -->
                <div class="card search-card mb-4 p-3">
                    <form action="AllQuestion" method="get" class="row g-2 align-items-end">
                        <div class="col-md-5">
                            <label class="form-label fw-semibold small text-muted mb-1">Search Questions</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                <input type="text" class="form-control" name="keyword"
                                    placeholder="Search by keyword..." value="${keyword}">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small text-muted mb-1">Filter by Subject</label>
                            <select class="form-select" name="techId">
                                <option value="">-- All Subjects --</option>
                                <c:forEach var="t" items="${technos}">
                                    <option value="${t.techId}" ${selectedTechId==t.techId ? 'selected' : '' }>
                                        ${t.techName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-grow-1"><i
                                    class="bi bi-funnel me-1"></i>Filter</button>
                            <a href="AllQuestion" class="btn btn-outline-secondary"><i class="bi bi-x-circle"></i></a>
                        </div>
                    </form>
                </div>

                <!-- Result info -->
                <c:if test="${not empty keyword}">
                    <div class="alert alert-info py-2 mb-3">
                        <i class="bi bi-search me-1"></i>Showing results for "<b>${keyword}</b>" — ${all.size()} found
                    </div>
                </c:if>

                <!-- Questions List -->
                <div class="row">
                    <c:forEach var="one" items="${all}" varStatus="loop">
                        <div class="col-12">
                            <div class="card question-card">
                                <div class="card-body p-4">
                                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                                        <div class="flex-grow-1">
                                            <h6 class="card-title text-dark mb-0">
                                                <span class="question-badge">Q ${one.qid}</span>${one.qname}
                                                <c:if test="${not empty one.techId}">
                                                    <span class="badge bg-secondary ms-2"
                                                        style="font-size:0.75rem;">${one.techId.techName}</span>
                                                </c:if>
                                            </h6>
                                            <c:if test="${not empty one.imagePath}">
                                                <div class="mt-3">
                                                    <a href="/uploads/${one.imagePath}" target="_blank">
                                                        <img src="/uploads/${one.imagePath}" alt="Question Diagram"
                                                            class="img-fluid rounded border shadow-sm"
                                                            style="max-height: 140px; object-fit: contain; background: #fff;">
                                                    </a>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="d-flex gap-2 ms-2">
                                            <a href="editQuestion?qid=${one.qid}" class="btn btn-sm btn-outline-primary"
                                                title="Edit"><i class="bi bi-pencil-square"></i></a>
                                            <form action="deleteQuestion" method="post" class="m-0">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <input type="hidden" name="qid" value="${one.qid}">
                                                <button type="submit" onclick="return confirm('Delete this question?')"
                                                    class="btn btn-sm btn-outline-danger" title="Delete"><i
                                                        class="bi bi-trash"></i></button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="row mt-3 g-2">
                                        <div class="col-md-6">
                                            <div
                                                class="option-item ${one.correct_Opt == one.opt1 ? 'correct-opt' : ''}">
                                                <span class="fw-bold me-2 text-primary">A.</span>${one.opt1}
                                                <c:if test="${one.correct_Opt == one.opt1}"><span
                                                        class="correct-badge float-end">✓ Correct</span></c:if>
                                            </div>
                                            <div
                                                class="option-item ${one.correct_Opt == one.opt2 ? 'correct-opt' : ''}">
                                                <span class="fw-bold me-2 text-primary">B.</span>${one.opt2}
                                                <c:if test="${one.correct_Opt == one.opt2}"><span
                                                        class="correct-badge float-end">✓ Correct</span></c:if>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div
                                                class="option-item ${one.correct_Opt == one.opt3 ? 'correct-opt' : ''}">
                                                <span class="fw-bold me-2 text-primary">C.</span>${one.opt3}
                                                <c:if test="${one.correct_Opt == one.opt3}"><span
                                                        class="correct-badge float-end">✓ Correct</span></c:if>
                                            </div>
                                            <div
                                                class="option-item ${one.correct_Opt == one.opt4 ? 'correct-opt' : ''}">
                                                <span class="fw-bold me-2 text-primary">D.</span>${one.opt4}
                                                <c:if test="${one.correct_Opt == one.opt4}"><span
                                                        class="correct-badge float-end">✓ Correct</span></c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty all}">
                        <div class="col-12 text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                            <h5>No Questions Found</h5>
                            <p>Try a different search term or <a href="AllQuestion">clear filters</a>.</p>
                        </div>
                    </c:if>
                </div>

                <!-- Pagination (shown only if no active search) -->
                <c:if test="${page != null && page.totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${!page.hasPrevious() ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${page.number - 1}">Previous</a>
                            </li>
                            <c:forEach var="i" begin="0" end="${page.totalPages - 1}">
                                <li class="page-item ${i == page.number ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${!page.hasNext() ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${page.number + 1}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>