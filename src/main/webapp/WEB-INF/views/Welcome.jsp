<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Welcome to Quiz Management</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            /* If the image doesn't exist, we fall back to a nice gradient */
            background-color: #2c3e50;
            background-image: linear-gradient(135deg, rgba(44, 62, 80, 0.9) 0%, rgba(52, 152, 219, 0.8) 100%), url('/image/wel.png');
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-position: center;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container-box {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-width: 400px;
            color: white;
            animation: fadeIn 1s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 15px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            letter-spacing: 1px;
        }

        p {
            font-size: 1.1rem;
            margin-bottom: 35px;
            opacity: 0.9;
        }

        .btn-custom {
            width: 240px;
            font-size: 1.1rem;
            padding: 12px;
            border-radius: 50px;
            transition: all 0.3s ease;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
        }

        .btn-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25);
        }

        .btn-primary.btn-custom {
            background-color: #0d6efd;
            border: none;
        }

        .btn-primary.btn-custom:hover {
            background-color: #0b5ed7;
        }

        .btn-success.btn-custom {
            background-color: #198754;
            border: none;
        }

        .btn-success.btn-custom:hover {
            background-color: #157347;
        }

        .btn-container {
            display: flex;
            flex-direction: column;
            gap: 18px;
            width: 100%;
            align-items: center;
        }

        .header-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            text-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>

<body>

    <div class="container-box">
        <i class="bi bi-mortarboard-fill header-icon text-warning"></i>
        <h1>Quiz Management</h1>
        <p>Test your knowledge with our interactive quiz system!</p>

        <div class="btn-container">
            <a href="login" class="btn btn-primary btn-custom"><i class="bi bi-box-arrow-in-right me-2"></i>Login</a>
            <a href="signUp" class="btn btn-success btn-custom"><i class="bi bi-person-plus-fill me-2"></i>Register</a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>