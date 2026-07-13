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
                             avatarUrl="${sessionScope.currentUser.avatarUrl}"
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
        <c:if test="${not empty message}">
            <div class="lf-alert lf-alert-success mb-md" style="background:#f0fdf4; border-color:#bbf7d0; color:#166534;">
                <span>${message}</span>
            </div>
        </c:if>

        <div class="lf-card" style="max-width:680px;">
            <form action="${pageContext.request.contextPath}/edit_profile" method="post" enctype="multipart/form-data" class="lf-form" novalidate>
                <input type="hidden" name="action" value="update">
                
                <!-- Avatar Section -->
                <div class="mb-4 d-flex align-items-center gap-3 p-3" style="background:#f8fafc; border:1px dashed #cbd5e1; border-radius:8px;">
                    <div style="width: 80px; height: 80px; font-size: 2.2rem; display: flex; align-items: center; justify-content: center; border-radius: 50%; overflow: hidden; background: #e2e8f0; flex-shrink: 0;">
                        <lf:avatar fullName="${sessionScope.currentUser.fullName}" avatarUrl="${sessionScope.currentUser.avatarUrl}" className="w-100 h-100" />
                    </div>
                    <div style="flex: 1;">
                        <label class="lf-label" for="avatar" style="font-weight:600;">Ảnh đại diện</label>
                        <input type="file" id="avatar" name="avatar" class="form-control form-control-sm" accept="image/*">
                        <small class="lf-help-text">Chấp nhận JPG, PNG, GIF, WEBP. Dung lượng tối đa 2MB.</small>
                    </div>
                </div>

                <div class="lf-form-row">
                    <div class="lf-form-group">
                        <label class="lf-label" for="username">Tên đăng nhập <span class="req">*</span></label>
                        <input type="text" id="username" name="username"
                               class="lf-input"
                               value="${param.username != null ? param.username : sessionScope.currentUser.username}"
                               required autocomplete="username">
                        <small class="lf-help-text">Bạn có thể thay đổi tên đăng nhập tại đây.</small>
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

                <div class="lf-form-group mb-4" style="border: 1px solid var(--clr-border); padding: 16px; border-radius: 8px; background: #fafafa;">
                    <label class="lf-label" style="font-weight: 600; font-size: 0.95rem; margin-bottom: 8px; display: block;">📱 Số điện thoại &amp; Xác thực</label>
                    <c:choose>
                        <%-- Case 1: Current phone is empty or null - allow direct editing --%>
                        <c:when test="${empty sessionScope.currentUser.phoneNumber}">
                            <input type="text" id="phone_number" name="phone_number"
                                   class="lf-input"
                                   value="${param.phone_number != null ? param.phone_number : sessionScope.currentUser.phoneNumber}"
                                   placeholder="Nhập số điện thoại mới" required
                                   maxlength="10" pattern="^0\d{9}$" 
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '')" 
                                   title="Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0">
                            <small class="lf-help-text text-success">Bạn có thể tự do điền SĐT vì chưa đăng ký SĐT trước đó.</small>
                        </c:when>
                        
                        <%-- Case 2: Current phone is verified and unlocked for changing --%>
                        <c:when test="${sessionScope.phone_verified eq true or requestScope.phone_unlocked eq true}">
                            <div class="mb-2">
                                <label class="lf-label" for="phone_number" style="font-size:0.85rem; color:#16a34a;">✅ Đã xác thực OTP. Nhập SĐT mới bên dưới:</label>
                                <input type="text" id="phone_number" name="phone_number"
                                       class="lf-input" style="border-color: #22c55e;"
                                       value="${param.phone_number != null ? param.phone_number : sessionScope.currentUser.phoneNumber}"
                                       placeholder="Nhập số điện thoại mới" required
                                       maxlength="10" pattern="^0\d{9}$" 
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '')" 
                                       title="Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0">
                            </div>
                        </c:when>
                        
                        <%-- Case 3: Current phone exists and is locked - needs OTP verification to change --%>
                        <c:otherwise>
                            <div class="d-flex gap-2 align-items-center mb-2">
                                <input type="text" class="lf-input lf-input--readonly" style="flex: 1; background: #e2e8f0; color: #475569;"
                                       value="${sessionScope.currentUser.phoneNumber}" readonly aria-readonly="true">
                                <c:if test="${not (otp_sent eq true)}">
                                    <button type="button" class="btn btn-secondary btn-sm" style="font-size:0.82rem; padding: 10px 16px; background:var(--clr-primary); border-color:var(--clr-primary); color:white;" onclick="requestOtp()">
                                        Thay đổi số điện thoại (Nhận OTP)
                                    </button>
                                </c:if>
                            </div>
                            
                            <c:if test="${otp_sent eq true}">
                                <div class="mt-3 p-3" style="background:#fff7ed; border:1px solid #fed7aa; border-radius:6px;">
                                    <label class="lf-label" for="otpInput" style="font-size:0.85rem; color:#c2410c;">Mã OTP đã gửi về SĐT trên:</label>
                                    <div class="d-flex gap-2">
                                        <input type="text" id="otpInput" class="lf-input" placeholder="Nhập mã OTP 6 số" maxlength="6" style="flex:1;">
                                        <button type="button" class="btn btn-success" style="padding: 10px 20px; font-weight:600;" onclick="verifyOtp()">Xác minh OTP</button>
                                    </div>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="lf-alert lf-alert-info mb-md">
                    <span class="lf-alert__icon">ℹ️</span>
                    <span>Nếu bạn không muốn đổi mật khẩu thì để trống 2 ô bên dưới.</span>
                </div>

                <div class="lf-form-row">
                    <div class="lf-form-group">
                        <label class="lf-label" for="password">Mật khẩu mới</label>
                        <input type="password" id="password" name="password"
                               class="lf-input" placeholder="Ít nhất 6 ký tự" autocomplete="new-password"
                               minlength="6" title="Mật khẩu phải có ít nhất 6 ký tự">
                    </div>
                    <div class="lf-form-group">
                        <label class="lf-label" for="confirm_password">Xác nhận mật khẩu mới</label>
                        <input type="password" id="confirm_password" name="confirm_password"
                               class="lf-input" placeholder="Nhập lại mật khẩu" autocomplete="new-password"
                               minlength="6">
                    </div>
                </div>

                <div class="flex gap-md flex-wrap">
                    <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-ghost">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>

    <lf:footer />
</div>

<form id="hiddenOtpForm" method="post" action="${pageContext.request.contextPath}/edit_profile" style="display:none;">
    <input type="hidden" name="action" id="hiddenOtpAction" value="">
    <input type="hidden" name="otp" id="hiddenOtpVal" value="">
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    function requestOtp() {
        document.getElementById('hiddenOtpAction').value = 'send_otp';
        document.getElementById('hiddenOtpForm').submit();
    }
    function verifyOtp() {
        const otpInput = document.getElementById('otpInput');
        if (!otpInput || !otpInput.value || otpInput.value.trim() === '') {
            alert('Vui lòng nhập mã OTP!');
            return;
        }
        document.getElementById('hiddenOtpAction').value = 'verify_otp';
        document.getElementById('hiddenOtpVal').value = otpInput.value.trim();
        document.getElementById('hiddenOtpForm').submit();
    }
</script>
</body>
</html>

