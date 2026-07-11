<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật Người dùng — Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">
    <nav class="lf-navbar">
        <div class="lf-navbar__inner">
            <a href="${pageContext.request.contextPath}/home" class="lf-navbar__brand">
                <div class="lf-navbar__logo">🔍</div>
                <span class="lf-navbar__title">Lost &amp; Found</span>
            </a>
            <div class="lf-navbar__user">
                <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                             role="${sessionScope.userRole}"
                             contextPath="${pageContext.request.contextPath}"/>
            </div>
        </div>
    </nav>
    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/manage_users">👥 Người dùng</a>
            <span class="sep">›</span><span class="current">Cập nhật</span>
        </div>
        <div class="lf-page-header">
            <h1 class="lf-page-header__title">✏️ Cập nhật Người dùng</h1>
        </div>
        <c:set var="u" value="${requestScope.user}"/>
        <div class="lf-card" style="max-width:500px;">
            <div class="mb-md" style="display:flex;align-items:center;gap:12px;padding:12px;background:rgba(91,141,238,.06);border-radius:var(--r-md);border:1px solid var(--clr-border);">
                <lf:avatar fullName="${u.fullName}" className="lf-navbar__avatar" />
                <div>
                    <div class="fw-bold">${u.username}</div>
                    <div class="text-sm text-muted">${u.email}</div>
                </div>
            </div>
            <form action="updateuser" method="post" class="lf-form">
                <input type="hidden" name="id" value="${u.userId}"/>
                <div class="lf-form-group">
                    <label class="lf-label" for="role">Vai trò</label>
                    <select id="role" name="role" class="lf-select">
                        <option value="student" ${u.role eq 'student' ? 'selected' : ''}>🎓 Student</option>
                        <option value="admin"   ${u.role eq 'admin'   ? 'selected' : ''}>⚙️ Admin</option>
                    </select>
                </div>
                <div class="lf-form-group">
                    <label class="lf-label" for="isactive">Trạng thái hoạt động</label>
                    <select id="isactive" name="isactive" class="lf-select">
                        <option value="true"  ${u.isActive ? 'selected' : ''}>✅ Active</option>
                        <option value="false" ${!u.isActive ? 'selected' : ''}>🔒 Inactive</option>
                    </select>
                </div>
                <div class="flex gap-md">
                    <button type="submit" class="btn btn-primary">💾 Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/manage_users" class="btn btn-ghost">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>
    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
