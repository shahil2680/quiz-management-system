<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Update Entry</title>
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

		.btn-success {
			border-radius: 8px;
			padding: 10px;
			font-weight: 600;
		}
	</style>
</head>

<body>
	<div class="card">
		<div class="card-header">
			<h3 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Update Data</h3>
		</div>
		<div class="card-body">
			<form action="updateSubmit" method="post">
				<!-- CSRF Token (assuming Spring Security is active) -->
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

				<input type="hidden" name="role" value="${student.role}">

				<div class="mb-3 input-group">
					<span class="input-group-text"><i class="bi bi-hash"></i></span>
					<input type="text" class="form-control" name="id" value="${student.id}" required readonly>
				</div>

				<div class="mb-3 input-group">
					<span class="input-group-text"><i class="bi bi-person"></i></span>
					<input type="text" class="form-control" placeholder="Enter Name" name="username"
						value="${student.username}" required>
				</div>

				<div class="mb-3 input-group">
					<span class="input-group-text"><i class="bi bi-envelope"></i></span>
					<input type="email" class="form-control" placeholder="Enter Email" name="email"
						value="${student.email}" required>
				</div>

				<div class="mb-4 input-group">
					<span class="input-group-text"><i class="bi bi-lock"></i></span>
					<input type="password" class="form-control" placeholder="Enter Password" name="password"
						value="${student.password}" required minlength="6">
				</div>

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-success"><i class="bi bi-save2 me-2"></i>Update Entry</button>
				</div>
			</form>

			<div class="text-center mt-4">
				<a href="javascript:history.back()" class="text-decoration-none text-secondary"><i
						class="bi bi-arrow-left"></i> Cancel</a>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>