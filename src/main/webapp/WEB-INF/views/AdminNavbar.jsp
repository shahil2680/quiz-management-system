<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<!-- Custom Styles -->
<style>
    body {
        background-color: #f4f6f9;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .navbar-custom {
        background-color: #ffffff;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        padding: 10px 20px;
    }

    .navbar-custom .navbar-brand {
        font-weight: 700;
        color: #2c3e50;
        font-size: 1.25rem;
    }

    .navbar-custom .nav-link {
        color: #5a6268;
        font-weight: 500;
        transition: color 0.3s;
        margin: 0 5px;
    }

    .navbar-custom .nav-link:hover {
        color: #3498db;
    }

    .navbar-custom .nav-link i {
        margin-right: 5px;
    }

    .card-dashboard {
        border: none;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        background: white;
    }

    .card-dashboard:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    }

    .card-header-custom {
        border-radius: 12px 12px 0 0 !important;
        padding: 15px 20px;
        font-weight: 600;
        border-bottom: none;
    }

    .card-body-custom {
        padding: 25px;
    }

    .stat-number {
        font-size: 2.5rem;
        font-weight: 700;
        color: #2c3e50;
    }

    .page-title {
        color: #2c3e50;
        font-weight: 700;
        margin-top: 30px;
        margin-bottom: 30px;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.05);
    }
</style>

<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="Admin"><i class="bi bi-shield-lock text-primary"></i> Admin Portal</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar"
            aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="AddUser"><i class="bi bi-person-plus"></i> Add User</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="ShowAllStudent?name=faculty"><i class="bi bi-person-video3"></i> All
                        Faculty</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="ShowAllStudent?name=student"><i class="bi bi-mortarboard"></i> All
                        Students</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="AddQuestion"><i class="bi bi-patch-question"></i> Add Question</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="AllQuestion"><i class="bi bi-list-task"></i> All Questions</a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link text-danger" href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Global Polish Features -->
<%@ include file="global-utils.jsp" %>