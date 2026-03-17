<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Add New User</title>
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

                .form-control,
                .form-select {
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
                    <h3 class="mb-0"><i class="bi bi-person-plus-fill me-2"></i>Add New User</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <div class="alert alert-info text-center" role="alert">
                            ${message}
                        </div>
                    </c:if>

                    <form action="AdminAddUser" method="post" modelAttribute="AdminSignUpDto">
                        <!-- CSRF Token -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <div class="mb-3 input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" name="email" placeholder="Email Address" required>
                        </div>

                        <div class="mb-3 input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="username" placeholder="Full Name" required>
                        </div>

                        <div class="mb-3 input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" name="password"
                                placeholder="Password (min 6 chars)" required minlength="6">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Select Role:</label>
                            <div class="d-flex gap-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="role" id="roleFaculty"
                                        value="faculty" required>
                                    <label class="form-check-label" for="roleFaculty">Faculty</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="role" id="roleStudent"
                                        value="student">
                                    <label class="form-check-label" for="roleStudent">Student</label>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Register User</button>
                        </div>
                    </form>

                    <div class="text-center mt-4">
                        <a href="/Admin" class="text-decoration-none"><i class="bi bi-arrow-left"></i> Back to
                            Dashboard</a>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>