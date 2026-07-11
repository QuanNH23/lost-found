<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa tài khoản — Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">
    <nav class="lf-navbar">
        <div class="lf-navbar__inner">
            <a href="${pageContext.request.contextPath}/home" class="lf-navbar__brand">
                <div class="lf-navbar__logo">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="color:white; display:block;">
                        <circle cx="11" cy="11" r="8"/>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                </div>
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
            <h1 class="lf-page-header__title">Sửa tài khoản</h1>
            <p class="lf-page-header__sub">Cập nhật thông tin cá nhân của bạn</p>
        </div>

        <c:if test="${not empty ERROR}">
            <div class="lf-alert lf-alert-error mb-md">
                <span>${ERROR}</span>
            </div>
        </c:if>

        <div class="lf-card" style="max-width:680px;">
            <form action="${pageContext.request.contextPath}/edit_profile" method="post" class="lf-form" novalidate>
                <div class="lf-form-row">
                    <div class="lf-form-group">
                        <label class="lf-label" for="username">Tên đăng nhập</label>
                        <input type="text" id="username" name="username"
                               class="lf-input lf-input--readonly"
                               value="${sessionScope.currentUser.username}"
                               readonly aria-readonly="true" autocomplete="username">
                        <small class="lf-help-text">Username không thể thay đổi.</small>
                    </div>
                    <div class="lf-form-group">
                        <label class="lf-label" for="full_name">Họ và tên <span class="req">*</span></label>
                        <input type="text" id="full_name" name="full_name"
                               class="lf-input"
                               value="${param.full_name != null ? param.full_name : sessionScope.currentUser.fullName}"
                               required>
                    </div>
                </div>

                <div class="lf-form-group">
                    <label class="lf-label" for="email">Email <span class="req">*</span></label>
                    <input type="email" id="email" name="email"
                           class="lf-input"
                           value="${param.email != null ? param.email : sessionScope.currentUser.email}"
                           required>
                </div>

                <div class="lf-form-group">
                    <label class="lf-label" for="phone_number">Số điện thoại</label>
                    <input type="text" id="phone_number" name="phone_number"
                           class="lf-input"
                           value="${param.phone_number != null ? param.phone_number : sessionScope.currentUser.phoneNumber}"
                           placeholder="0xxxxxxxxx">
                </div>

                <div class="lf-alert lf-alert-info mb-md">
                    <span class="lf-alert__icon">ℹ️</span>
                    <span>Nếu bạn không muốn đổi mật khẩu thì để trống 2 ô bên dưới.</span>
                </div>

                <div class="lf-form-row">
                    <div class="lf-form-group">
                        <label class="lf-label" for="password">Mật khẩu mới</label>
                        <input type="password" id="password" name="password"
                               class="lf-input" placeholder="Ít nhất 6 ký tự" autocomplete="new-password">
                    </div>
                    <div class="lf-form-group">
                        <label class="lf-label" for="confirm_password">Xác nhận mật khẩu mới</label>
                        <input type="password" id="confirm_password" name="confirm_password"
                               class="lf-input" placeholder="Nhập lại mật khẩu" autocomplete="new-password">
                    </div>
                </div>

                <div class="flex gap-md flex-wrap">
                    <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-ghost">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>

    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost &amp; Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
