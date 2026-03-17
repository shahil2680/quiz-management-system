<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="UTF-8">
      <title>Select Subject</title>
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

        .tech-card {
          border: none;
          border-radius: 12px;
          box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
          transition: transform 0.2s, box-shadow 0.2s;
          background: white;
          height: 100%;
          cursor: pointer;
          text-decoration: none !important;
        }

        .tech-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .card-icon {
          font-size: 3rem;
          color: #0d6efd;
          margin-bottom: 15px;
        }

        .tech-title {
          color: #2c3e50;
          font-weight: 600;
          text-decoration: none;
        }
      </style>
    </head>

    <body>

      <div class="container">
        <div class="mb-5 text-center">
          <h2 class="fw-bold text-secondary"><i class="bi bi-book-half me-2"></i>Select Quiz Subject</h2>
          <p class="text-muted">Choose a technology below to start your exam.</p>
        </div>

        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4 justify-content-center">
          <c:forEach var="nm" items="${name}">
            <div class="col">
              <a href="getQuestion?name=${nm.getTechName()}" class="tech-card card text-center p-4 d-block">
                <div class="card-body p-0">
                  <i class="bi bi-laptop card-icon"></i>
                  <h5 class="card-title tech-title mb-0">${nm.getTechName()}</h5>
                </div>
              </a>
            </div>
          </c:forEach>
        </div>

        <div class="text-center mt-5">
          <a href="Student" class="btn btn-outline-secondary px-4"><i class="bi bi-arrow-left me-2"></i>Back to
            Dashboard</a>
        </div>
      </div>

      <!-- Bootstrap JS -->
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>