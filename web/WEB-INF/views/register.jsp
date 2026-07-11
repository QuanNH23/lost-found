<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký — Hệ thống Quản lý Đồ thất lạc</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-auth-bg">
    <div class="lf-auth-card" style="max-width:520px;">

        <div class="lf-auth-logo">
            <div class="lf-auth-logo__icon" style="background: var(--clr-primary); border-radius: var(--r-md); width:48px; height:48px; display:flex; align-items:center; justify-content:center; margin-bottom:8px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="color:white; display:block;">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                </svg>
            </div>
            <div class="lf-auth-logo__name">Tạo tài khoản</div>
            <div class="lf-auth-logo__sub">Tham gia hệ thống Lost &amp; Found của trường</div>
        </div>

        <c:if test="${not empty ERROR}">
            <div class="lf-alert lf-alert-error">
                <span>${ERROR}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="lf-form" novalidate>
            <div class="lf-form-row">
                <div class="lf-form-group">
                    <label class="lf-label" for="username">Tên đăng nhập <span class="req">*</span></label>
                    <input type="text" id="username" name="username"
                           class="lf-input" value="${param.username}"
                           placeholder="vd: nguyenvana" required autocomplete="username">
                </div>
                <div class="lf-form-group">
                    <label class="lf-label" for="full_name">Họ và tên <span class="req">*</span></label>
                    <input type="text" id="full_name" name="full_name"
                           class="lf-input" value="${param.full_name}"
                           placeholder="Nguyễn Văn A" required>
                </div>
            </div>

            <div class="lf-form-group">
                <label class="lf-label" for="email">Email <span class="req">*</span></label>
                <input type="email" id="email" name="email"
                       class="lf-input" value="${param.email}"
                       placeholder="email@truong.edu.vn" required>
            </div>

            <div class="lf-form-group">
                <label class="lf-label" for="phone_number">Số điện thoại</label>
                <input type="text" id="phone_number" name="phone_number"
                       class="lf-input" value="${param.phone_number}"
                       placeholder="0xxxxxxxxx">
            </div>

            <div class="lf-form-row">
                <div class="lf-form-group">
                    <label class="lf-label" for="password">Mật khẩu <span class="req">*</span></label>
                    <input type="password" id="password" name="password"
                           class="lf-input" placeholder="Ít nhất 6 ký tự" required>
                </div>
                <div class="lf-form-group">
                    <label class="lf-label" for="confirm_password">Xác nhận mật khẩu <span class="req">*</span></label>
                    <input type="password" id="confirm_password" name="confirm_password"
                           class="lf-input" placeholder="Nhập lại mật khẩu" required>
                </div>
            </div>

            <button type="submit" class="btn btn-vibrant btn-lg btn-full" style="margin-top:8px;">
                Tạo tài khoản
            </button>
        </form>

        <div class="lf-auth-divider">đã có tài khoản?</div>

        <div class="lf-auth-footer">
            <a href="${pageContext.request.contextPath}/login" class="fw-bold" style="color:var(--clr-primary);">
                ← Quay lại Đăng nhập
            </a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
