<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ page import="java.util.*" %>
            <% if(!"Faculty".equals(session.getAttribute("role"))) { response.sendRedirect("login"); return; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <title>Bulk Import Questions</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        body {
                            background: #f4f6f9;
                            font-family: 'Segoe UI', sans-serif;
                        }

                        .card {
                            border: none;
                            border-radius: 14px;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.07);
                        }

                        .card-header-custom {
                            background: linear-gradient(135deg, #2c3e50, #3498db);
                            color: white;
                            border-radius: 14px 14px 0 0;
                            padding: 18px 24px;
                        }

                        .upload-area {
                            border: 2px dashed #3498db;
                            border-radius: 10px;
                            padding: 40px;
                            text-align: center;
                            background: #f8fbff;
                            transition: background 0.2s;
                            cursor: pointer;
                        }

                        .upload-area:hover {
                            background: #eaf3fb;
                        }

                        .format-table th {
                            background: #f0f0f0;
                        }

                        .sample-link {
                            color: #3498db;
                            cursor: pointer;
                            text-decoration: underline;
                        }
                    </style>
                </head>

                <body>
                    <nav class="navbar navbar-expand-lg sticky-top"
                        style="background:#fff;box-shadow:0 2px 10px rgba(0,0,0,0.05);">
                        <div class="container-fluid px-4">
                            <a class="navbar-brand fw-bold" href="Faculty"><i
                                    class="bi bi-person-video3 text-success me-1"></i>Faculty Portal</a>
                            <div class="collapse navbar-collapse">
                                <ul class="navbar-nav me-auto">
                                    <li class="nav-item"><a class="nav-link" href="AllQuestion"><i
                                                class="bi bi-list-task me-1"></i>All Questions</a></li>
                                    <li class="nav-item"><a class="nav-link active" href="bulkImportQuestions"><i
                                                class="bi bi-upload me-1"></i>Bulk Import</a></li>
                                    <li class="nav-item"><a class="nav-link" href="manageQuizzes"><i
                                                class="bi bi-collection me-1"></i>Quizzes</a></li>
                                </ul>
                                <ul class="navbar-nav ms-auto">
                                    <li class="nav-item"><a class="nav-link text-danger" href="logout"><i
                                                class="bi bi-box-arrow-right me-1"></i>Logout</a></li>
                                </ul>
                            </div>
                        </div>
                    </nav>

                    <div class="container py-5">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-header-custom">
                                        <h5 class="mb-0"><i class="bi bi-file-earmark-spreadsheet me-2"></i>Bulk Import
                                            Questions via CSV</h5>
                                    </div>
                                    <div class="card-body p-4">

                                        <!-- Alerts -->
                                        <c:if test="${not empty success}">
                                            <div class="alert alert-success d-flex align-items-center gap-2">
                                                <i class="bi bi-check-circle-fill"></i>${success}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger d-flex align-items-center gap-2">
                                                <i class="bi bi-exclamation-triangle-fill"></i>${error}
                                            </div>
                                        </c:if>

                                        <!-- CSV Format Info -->
                                        <div class="alert alert-info mb-4">
                                            <b><i class="bi bi-info-circle me-1"></i>CSV Format — one question per
                                                row:</b>
                                            <p class="mb-1 mt-2 small">
                                                Column order:
                                                <code>question, opt1, opt2, opt3, opt4, correct_opt, tech_name</code>
                                            </p>
                                            <p class="mb-0 small text-muted">First row is treated as a header and
                                                skipped. <span class="sample-link" onclick="downloadSample()">Download
                                                    sample CSV</span></p>
                                        </div>

                                        <table class="table table-sm table-bordered format-table mb-4">
                                            <thead>
                                                <tr>
                                                    <th>question</th>
                                                    <th>opt1</th>
                                                    <th>opt2</th>
                                                    <th>opt3</th>
                                                    <th>opt4</th>
                                                    <th>correct_opt</th>
                                                    <th>tech_name</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>What is JVM?</td>
                                                    <td>Java Virtual Machine</td>
                                                    <td>Java Visual Module</td>
                                                    <td>Joint Virtual Memory</td>
                                                    <td>None</td>
                                                    <td>Java Virtual Machine</td>
                                                    <td>Java</td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <!-- Upload Form -->
                                        <form action="processBulkImport" method="post" enctype="multipart/form-data"
                                            id="uploadForm">
                                            <div class="upload-area mb-4"
                                                onclick="document.getElementById('csvFile').click()">
                                                <i class="bi bi-cloud-upload fs-1 text-primary"></i>
                                                <p class="mt-2 mb-0 fw-bold">Click to select CSV file</p>
                                                <small class="text-muted" id="fileName">No file chosen</small>
                                                <input type="file" id="csvFile" name="csvFile" accept=".csv"
                                                    class="d-none" onchange="updateFileName(this)">
                                            </div>
                                            <div class="d-grid gap-2">
                                                <button type="submit" class="btn btn-primary" id="importBtn">
                                                    <i class="bi bi-upload me-2"></i>Import Questions
                                                </button>
                                                <a href="AllQuestion" class="btn btn-outline-secondary">
                                                    <i class="bi bi-arrow-left me-2"></i>Back to Questions
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function updateFileName(input) {
                            document.getElementById('fileName').textContent = input.files[0] ? input.files[0].name : 'No file chosen';
                        }
                        document.getElementById('uploadForm').addEventListener('submit', function () {
                            const btn = document.getElementById('importBtn');
                            btn.disabled = true;
                            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Importing...';
                        });
                        function downloadSample() {
                            const csv = "question,opt1,opt2,opt3,opt4,correct_opt,tech_name\n" +
                                "What is JVM?,Java Virtual Machine,Java Visual Module,Joint Virtual Memory,None,Java Virtual Machine,Java\n" +
                                "What does HTML stand for?,Hyper Text Markup Language,High Text Machine Language,Hyper Tabular Markup Language,None,Hyper Text Markup Language,HTML\n";
                            const blob = new Blob([csv], { type: 'text/csv' });
                            const a = document.createElement('a');
                            a.href = URL.createObjectURL(blob);
                            a.download = 'sample_questions.csv';
                            a.click();
                        }
                    </script>
                </body>

                </html>