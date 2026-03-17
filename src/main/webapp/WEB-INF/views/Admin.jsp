<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <% if(!"Admin".equals(session.getAttribute("role"))) { response.sendRedirect("login"); return; } %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Admin Dashboard</title>
      <%@ include file="AdminNavbar.jsp" %>
    </head>

    <body>
      <div class="container mt-4">
        <div class="row text-center mb-4">
          <h2 class="page-title"><i class="bi bi-shield-lock-fill text-primary me-2"></i>Admin Dashboard</h2>
          <p class="text-muted">Overview of the entire system</p>
        </div>

        <!-- Stat Cards Row -->
        <div class="row g-4 justify-content-center">
          <!-- Students Card -->
          <div class="col-md-3">
            <div class="card card-dashboard text-center h-100">
              <div class="card-header card-header-custom bg-primary text-white">
                <i class="bi bi-mortarboard fs-4 d-block mb-2"></i>
                Total Students
              </div>
              <div class="card-body card-body-custom">
                <div class="stat-number">${studentCount}</div>
                <p class="text-muted">Registered in system</p>
                <a href="ShowAllStudent?name=student"
                  class="btn btn-outline-primary btn-sm mt-3 w-100 stretched-link">View Students</a>
              </div>
            </div>
          </div>

          <!-- Faculty Card -->
          <div class="col-md-3">
            <div class="card card-dashboard text-center h-100">
              <div class="card-header card-header-custom bg-success text-white">
                <i class="bi bi-person-video3 fs-4 d-block mb-2"></i>
                Total Faculty
              </div>
              <div class="card-body card-body-custom">
                <div class="stat-number">${Staffs}</div>
                <p class="text-muted">Registered in system</p>
                <a href="ShowAllStudent?name=faculty"
                  class="btn btn-outline-success btn-sm mt-3 w-100 stretched-link">View Faculty</a>
              </div>
            </div>
          </div>

          <!-- Questions Card -->
          <div class="col-md-3">
            <div class="card card-dashboard text-center h-100">
              <div class="card-header card-header-custom bg-info text-white">
                <i class="bi bi-question-square fs-4 d-block mb-2"></i>
                Total Questions
              </div>
              <div class="card-body card-body-custom">
                <div class="stat-number">${qnCount}</div>
                <p class="text-muted">In question bank</p>
                <a href="AllQuestion" class="btn btn-outline-info btn-sm mt-3 w-100 stretched-link">Manage Questions</a>
              </div>
            </div>
          </div>

          <!-- Quizzes Card -->
          <div class="col-md-3">
            <div class="card card-dashboard text-center h-100">
              <div class="card-header card-header-custom bg-warning text-dark">
                <i class="bi bi-collection fs-4 d-block mb-2"></i>
                Total Quizzes
              </div>
              <div class="card-body card-body-custom">
                <div class="stat-number">${quizCount}</div>
                <p class="text-muted">Created quizzes</p>
                <a href="AllResults" class="btn btn-outline-warning text-dark btn-sm mt-3 w-100 stretched-link">View
                  Results</a>
              </div>
            </div>
          </div>
        </div>

        <!-- Charts Row -->
        <div class="row g-4 mt-4">
          <div class="col-md-6">
            <div class="card card-dashboard p-3">
              <h6 class="fw-bold mb-3"><i class="bi bi-pie-chart-fill text-primary me-2"></i>User Distribution</h6>
              <canvas id="userChart" height="200"></canvas>
            </div>
          </div>
          <div class="col-md-6">
            <div class="card card-dashboard p-3">
              <h6 class="fw-bold mb-3"><i class="bi bi-bar-chart-fill text-success me-2"></i>Content Overview</h6>
              <canvas id="contentChart" height="200"></canvas>
            </div>
          </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4 mb-5">
          <div class="col-12">
            <div class="card card-dashboard p-3">
              <h6 class="fw-bold mb-3"><i class="bi bi-lightning-fill text-warning me-2"></i>Quick Actions</h6>
              <div class="d-flex flex-wrap gap-2">
                <a href="AddUser" class="btn btn-primary btn-sm"><i class="bi bi-person-plus me-1"></i>Add New User</a>
                <a href="AddQuestion" class="btn btn-success btn-sm"><i class="bi bi-patch-plus me-1"></i>Add
                  Question</a>
                <a href="AllResults" class="btn btn-info btn-sm text-white"><i class="bi bi-graph-up me-1"></i>View All
                  Results</a>
                <a href="ShowAllStudent?name=student" class="btn btn-outline-secondary btn-sm"><i
                    class="bi bi-mortarboard me-1"></i>All Students</a>
                <a href="ShowAllStudent?name=faculty" class="btn btn-outline-secondary btn-sm"><i
                    class="bi bi-person-workspace me-1"></i>All Faculty</a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Chart.js -->
      <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
      <script>
        // User Distribution Pie Chart
        const userCtx = document.getElementById('userChart').getContext('2d');
        new Chart(userCtx, {
          type: 'doughnut',
          data: {
            labels: ['Students', 'Faculty'],
            datasets: [{
              data: [${ studentCount }, ${ Staffs }],
              backgroundColor: ['#3498db', '#2ecc71'],
              borderWidth: 0,
              hoverOffset: 8
            }]
          },
          options: {
            responsive: true,
            plugins: {
              legend: { position: 'bottom' }
            }
          }
        });

        // Content Overview Bar Chart
        const contentCtx = document.getElementById('contentChart').getContext('2d');
        new Chart(contentCtx, {
          type: 'bar',
          data: {
            labels: ['Questions', 'Quizzes'],
            datasets: [{
              label: 'Count',
              data: [${ qnCount }, ${ quizCount }],
              backgroundColor: ['#27ae60', '#e67e22'],
              borderRadius: 8,
              borderWidth: 0
            }]
          },
          options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
              y: { beginAtZero: true, grid: { color: '#f0f0f0' } },
              x: { grid: { display: false } }
            }
          }
        });
      </script>

      <!-- Global Polish Features -->
      <%@ include file="global-utils.jsp" %>
    </body>

    </html>