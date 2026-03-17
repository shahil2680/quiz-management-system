<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <% if(!"Admin".equals(session.getAttribute("role"))) { response.sendRedirect("login"); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Profile</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    body {
                        background-color: #f4f6f9;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    }

                    .profile-card {
                        border: none;
                        border-radius: 16px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                        overflow: hidden;
                    }

                    .profile-header {
                        background: linear-gradient(135deg, #e74c3c, #c0392b);
                        color: white;
                        padding: 40px 30px;
                        text-align: center;
                    }

                    .avatar-circle {
                        width: 90px;
                        height: 90px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.2);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto 16px;
                        font-size: 2.5rem;
                    }

                    .info-group {
                        margin-bottom: 20px;
                        padding-bottom: 20px;
                        border-bottom: 1px solid #eee;
                    }

                    .info-group:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        font-size: 0.85rem;
                        color: #6c757d;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        margin-bottom: 5px;
                        font-weight: 600;
                    }

                    .info-value {
                        font-size: 1.1rem;
                        color: #2b2d42;
                        font-weight: 500;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="AdminNavbar.jsp" />

                <div class="container py-5">
                    <div class="row justify-content-center">
                        <div class="col-lg-6 col-md-8">
                            <div class="profile-card">
                                <div class="profile-header">
                                    <div class="avatar-circle"><i class="bi bi-shield-lock-fill"></i></div>
                                    <h4 class="mb-1">${user.username}</h4>
                                    <span
                                        class="badge bg-light text-danger rounded-pill px-3 py-1 mt-2">Administrator</span>
                                </div>
                                <div class="card-body p-4 p-md-5 bg-white">
                                    <h5 class="fw-bold mb-4 text-primary"><i
                                            class="bi bi-person-lines-fill me-2"></i>Account Details</h5>

                                    <div class="info-group">
                                        <div class="info-label"><i class="bi bi-person me-2"></i>Username</div>
                                        <div class="info-value">${user.username}</div>
                                    </div>

                                    <div class="info-group">
                                        <div class="info-label"><i class="bi bi-envelope me-2"></i>Email Address</div>
                                        <div class="info-value">${user.email}</div>
                                    </div>

                                    <div class="info-group">
                                        <div class="info-label"><i class="bi bi-fingerprint me-2"></i>Account ID</div>
                                        <div class="info-value">#${user.id}</div>
                                    </div>

                                    <div class="info-group mt-4 text-center">
                                        <a href="Admin" class="btn btn-outline-danger px-4 rounded-pill"><i
                                                class="bi bi-arrow-left me-2"></i>Back to Dashboard</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Global Polish Features -->
                <%@ include file="global-utils.jsp" %>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>