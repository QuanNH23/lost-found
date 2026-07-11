<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin người dùng — Lost &amp; Found</title>
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
        <div class="lf-page-header">
            <h1 class="lf-page-header__title">👤 Thông tin người dùng</h1>
            <p class="lf-page-header__sub">Chi tiết tài khoản của người đăng/tương tác</p>
        </div>

        <c:set var="u" value="${requestScope.userDetail}"/>
        <div class="lf-card" style="max-width:720px;">
            <div class="flex gap-md" style="align-items:center;margin-bottom:var(--sp-md);">
                <lf:avatar fullName="${u.fullName}" className="lf-navbar__avatar"/>
                <div>
                    <div class="fw-bold" style="font-size:1.1rem;">${u.fullName}</div>
                    <div class="text-sm text-muted">@${u.username}</div>
                </div>
            </div>

            <table class="lf-detail-table">
                <tr>
                    <td>Email</td>
                    <td><strong>${u.email}</strong></td>
                </tr>
                <tr>
                    <td>Số điện thoại</td>
                    <td><strong>${empty u.phoneNumber ? '—' : u.phoneNumber}</strong></td>
                </tr>
            </table>

            <div class="mt-md">
                <a class="btn btn-ghost" href="${pageContext.request.contextPath}/home">← Quay lại</a>
            </div>
        </div>
    </main>

    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>

