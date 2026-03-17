<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Add New Technology</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background-color: #f4f6f9;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                width: 100%;
                max-width: 500px;
            }

            .card-header {
                background: #34495e;
                color: white;
                border-radius: 12px 12px 0 0 !important;
                padding: 15px 20px;
            }

            .card-body {
                padding: 30px;
            }
        </style>
    </head>

    <body>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h4 class="mb-0"><i class="bi bi-cpu me-2"></i>Add a New Technology</h4>
            </div>
            <div class="card-body">

                <form action="newTech" method="get">
                    <div class="mb-4">
                        <label for="techInput" class="form-label text-secondary fw-bold">Technology Name</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-tags"></i></span>
                            <input type="text" id="techInput" name="tech" class="form-control"
                                placeholder="e.g. Java, Python, React" required>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-plus-circle me-2"></i>Add
                            Technology</button>
                        <a href="Faculty" class="btn btn-outline-secondary mt-2"><i
                                class="bi bi-arrow-left me-2"></i>Back to Dashboard</a>
                    </div>
                </form>

                <%-- Display Message --%>
                    <% String msg=(String) request.getAttribute("msg"); if(msg !=null && !msg.isEmpty()) { %>
                        <div class="alert alert-info mt-4 pb-0 text-center" role="alert">
                            <p><i class="bi bi-info-circle me-2"></i>
                                <%= msg %>
                            </p>
                        </div>
                        <% } %>

            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>