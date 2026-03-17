<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Users — EduQuiz AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { background: #0a0f1e; font-family: 'Inter', sans-serif; color: #e2e8f0; min-height: 100vh; padding: 36px 24px 60px; }
        .page-container { max-width: 1100px; margin: 0 auto; }
        .page-header { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; margin-bottom: 28px; }
        .page-header h1 { font-weight: 800; font-size: 1.5rem; color: white; margin: 0; }
        .btn-back {
            background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.6); border-radius: 10px; padding: 9px 16px;
            font-size: 0.85rem; font-weight: 500; text-decoration: none;
            display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s;
        }
        .btn-back:hover { background: rgba(255,255,255,0.09); color: white; }
        .table-wrap { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 18px; overflow: hidden; }
        .dark-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .dark-table thead tr { background: rgba(255,255,255,0.04); }
        .dark-table thead th {
            padding: 13px 18px; font-size: 0.72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            color: rgba(255,255,255,0.35); border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .dark-table tbody tr { border-bottom: 1px solid rgba(255,255,255,0.05); transition: background 0.2s; }
        .dark-table tbody tr:last-child { border-bottom: none; }
        .dark-table tbody tr:hover { background: rgba(255,255,255,0.03); }
        .dark-table td { padding: 14px 18px; font-size: 0.875rem; color: #e2e8f0; vertical-align: middle; }
        .user-id { color: rgba(255,255,255,0.3); font-size: 0.8rem; font-weight: 600; }
        .avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.85rem; color: white; flex-shrink: 0;
        }
        .user-name { font-weight: 600; color: white; }
        .role-badge {
            background: rgba(99,102,241,0.15); color: #a5b4fc;
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 20px; padding: 3px 10px; font-size: 0.75rem; font-weight: 600;
            text-transform: capitalize;
        }
        .pwd-hash { color: rgba(255,255,255,0.3); font-size: 0.78rem; font-family: monospace; max-width: 160px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .at-risk-badge {
            display: inline-flex; align-items: center; gap: 4px;
            background: linear-gradient(135deg, rgba(239,68,68,0.2), rgba(185,28,28,0.1));
            border: 1px solid rgba(239,68,68,0.3);
            color: #f87171; border-radius: 8px; padding: 2px 8px; font-size: 0.7rem; font-weight: 700;
            animation: pulse-red 1.5s ease infinite;
        }
        @keyframes pulse-red { 0%,100% { opacity:1; } 50% { opacity:0.7; } }
        .act-btn {
            width: 30px; height: 30px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.6);
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 0.8rem; cursor: pointer; text-decoration: none; transition: all 0.2s;
        }
        .act-btn.edit:hover { background: rgba(99,102,241,0.2); color: #a5b4fc; border-color: rgba(99,102,241,0.3); }
        .act-btn.del:hover { background: rgba(239,68,68,0.2); color: #f87171; border-color: rgba(239,68,68,0.3); }
    </style>
</head>
<body>
    <div class="page-container">
        <div class="page-header">
            <div>
                <h1><i class="bi bi-people-fill me-2" style="color:#818cf8;"></i>All <span class="text-capitalize">${name}</span> Data</h1>
            </div>
            <c:choose>
                <c:when test="${name eq 'faculty' or name eq 'admin'}">
                    <a href="/Admin" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Dashboard</a>
                </c:when>
                <c:otherwise>
                    <a href="Faculty" class="btn-back"><i class="bi bi-arrow-left"></i>Back to Dashboard</a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="table-wrap">
            <table class="dark-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Password Hash</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="one" items="${users}">
                        <tr>
                            <td class="user-id">#${one.id}</td>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="avatar">${one.username.substring(0,1).toUpperCase()}</div>
                                    <div>
                                        <div class="user-name">${one.username}</div>
                                        <c:if test="${not empty atRiskIds and atRiskIds.contains(one.id)}">
                                            <span class="at-risk-badge">
                                                <i class="bi bi-exclamation-triangle-fill"></i> ML: At Risk
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </td>
                            <td style="color:rgba(255,255,255,0.55);">${one.email}</td>
                            <td><span class="pwd-hash">${one.password}</span></td>
                            <td><span class="role-badge">${one.role_Entity.name}</span></td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="update?id=${one.id}&roleName=${one.role_Entity.name}" class="act-btn edit" title="Edit"><i class="bi bi-pencil"></i></a>
                                    <form action="delete" method="post" class="m-0">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <input type="hidden" name="id" value="${one.id}">
                                        <button type="submit" class="act-btn del" onclick="return confirm('Delete ${one.username}?')" title="Delete">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr><td colspan="6" class="text-center py-5" style="color:rgba(255,255,255,0.3);">
                            <i class="bi bi-inbox d-block mb-2" style="font-size:2rem;opacity:0.3;"></i> No records found
                        </td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>