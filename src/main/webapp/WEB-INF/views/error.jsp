<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Application Error</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background-color: #f4f6f9;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .error-card {
                border: none;
                border-radius: 12px;
                text-align: center;
            }

            .error-icon {
                font-size: 5rem;
                color: #dc3545;
                margin-bottom: 20px;
                display: block;
            }
        </style>
    </head>

    <body>
        <div class="container" style="max-width: 500px;">
            <div class="card error-card shadow-lg p-5">
                <i class="bi bi-exclamation-triangle-fill error-icon"></i>
                <h1 class="text-dark fw-bold mb-3">Oops!</h1>
                <p class="lead text-secondary mb-4">Something went wrong or the page you requested cannot be found.</p>
                <div>
                    <a href="/" class="btn btn-primary rounded-pill px-4 py-2"><i
                            class="bi bi-house-door me-2"></i>Return Home</a>
                </div>
            </div>
        </div>
    </body>

    </html>