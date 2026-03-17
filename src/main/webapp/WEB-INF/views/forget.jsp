<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Forget Password</title>
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
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 450px;
                }

                .card-header {
                    background: #34495e;
                    color: white;
                    text-align: center;
                    padding: 20px;
                    border-radius: 12px 12px 0 0 !important;
                    border-bottom: none;
                }

                .card-body {
                    padding: 30px;
                }

                .form-control {
                    border-radius: 8px;
                    padding: 10px 15px;
                }

                .input-group-text {
                    background-color: transparent;
                }

                .btn-primary {
                    background-color: #3498db;
                    border: none;
                    border-radius: 8px;
                    padding: 10px;
                    font-weight: 600;
                }

                .btn-primary:hover {
                    background-color: #2980b9;
                }
            </style>
        </head>

        <body>
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0"><i class="bi bi-key-fill me-2"></i>Password Recovery</h3>
                </div>
                <div class="card-body">

                    <p class="text-center text-muted mb-4">Enter your email address and we'll send you a password hint
                        or recovery link.</p>

                    <form action="getPassword" method="post">
                        <!-- CSRF Token -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <div class="mb-4 input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" name="email" placeholder="Enter Registration Email"
                                required />
                        </div>

                        <div class="d-grid gap-2 mb-4">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-send me-2"></i>Get Password
                                Hint</button>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mt-3 shadow-sm border-0" role="alert">
                                <h6 class="alert-heading fw-bold"><i
                                        class="bi bi-exclamation-triangle-fill me-2"></i>Error:</h6>
                                <p class="mb-0 text-break">${error}</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty password}">
                            <div class="alert alert-info mt-3 shadow-sm border-0" role="alert">
                                <h6 class="alert-heading fw-bold"><i class="bi bi-info-circle-fill me-2"></i>Notice:
                                </h6>
                                <p class="mb-0 text-break">${password}</p>
                            </div>
                        </c:if>

                        <div class="text-center mt-4 border-top pt-3">
                            <a href="login" class="text-decoration-none text-secondary"><i class="bi bi-arrow-left"></i>
                                Back to Login</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>