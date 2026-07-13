<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — Hệ thống Quản lý Đồ thất lạc</title>
    <meta name="description" content="Đăng nhập vào hệ thống quản lý đồ thất lạc trong trường học">
    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-auth-bg">
    <div class="lf-auth-card">

        <!-- Logo -->
        <div class="lf-auth-logo">
            <div class="lf-auth-logo__icon" style="background: var(--clr-primary); border-radius: var(--r-md); width:48px; height:48px; display:flex; align-items:center; justify-content:center; margin-bottom:8px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="color:white; display:block;">
                    <circle cx="11" cy="11" r="8"/>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
            </div>
            <div class="lf-auth-logo__name">Lost &amp; Found</div>
            <div class="lf-auth-logo__sub">Hệ thống quản lý đồ thất lạc trường học</div>
        </div>

        <!-- Alerts -->
        <c:if test="${param.msg == 'success'}">
            <div class="lf-alert lf-alert-success">
                <span>Đăng ký thành công! Vui lòng đăng nhập.</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="lf-alert lf-alert-error">
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/login" method="post" class="lf-form" novalidate autocomplete="off">
            <div class="lf-form-group">
                <label class="lf-label" for="username">Tên đăng nhập</label>
                <input type="text" id="username" name="username" class="lf-input"
                       placeholder="Nhập tên đăng nhập" required autocomplete="new-password">
            </div>
            <div class="lf-form-group">
                <label class="lf-label" for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" class="lf-input"
                       placeholder="Nhập mật khẩu" required autocomplete="new-password">
            </div>
            <button type="submit" class="btn btn-vibrant btn-lg btn-full" style="margin-top:8px;">
                Đăng nhập
            </button>
        </form>

        <div class="lf-auth-divider">hoặc</div>

        <div class="lf-auth-footer">
            Chưa có tài khoản?
            <a href="${pageContext.request.contextPath}/register" class="fw-bold" style="color:var(--clr-primary);">
                Đăng ký ngay →
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
