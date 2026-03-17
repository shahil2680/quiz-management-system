<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Reset Password</title>
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
                background: #198754;
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

            .btn-success {
                border: none;
                border-radius: 8px;
                padding: 10px;
                font-weight: 600;
            }
        </style>
    </head>

    <body>
        <div class="card">
            <div class="card-header">
                <h3 class="mb-0"><i class="bi bi-key-fill me-2"></i>Create New Password</h3>
            </div>
            <div class="card-body">

                <p class="text-center text-muted mb-4">Your email has been verified. Please enter your new password
                    below.</p>

                <form action="updatePassword" method="post">
                    <div class="mb-4 input-group">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <input type="password" class="form-control" name="newPassword" placeholder="Enter New Password"
                            minlength="6" required />
                    </div>

                    <div class="d-grid gap-2 mb-4">
                        <button type="submit" class="btn btn-success"><i class="bi bi-save2 me-2"></i>Update
                            Password</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>