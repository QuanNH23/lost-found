<%@tag description="Navbar user menu (profile/logout)" pageEncoding="UTF-8"%>
<%@attribute name="fullName" required="true" rtexprvalue="true" type="java.lang.String"%>
<%@attribute name="role" required="true" rtexprvalue="true" type="java.lang.String"%>
<%@attribute name="contextPath" required="true" rtexprvalue="true" type="java.lang.String"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>

<c:set var="__roleKey" value="${empty role ? 'student' : role}" />
<c:choose>
    <c:when test="${__roleKey eq 'admin'}">
        <c:set var="__roleLabel" value="admin" />
        <c:set var="__roleHint" value="Toàn quyền hệ thống" />
    </c:when>
    <c:otherwise>
        <c:set var="__roleLabel" value="Student" />
        <c:set var="__roleHint" value="Tài khoản người dùng" />
    </c:otherwise>
</c:choose>

<div class="lf-user-menu" data-user-menu>
    <button type="button"
            class="lf-user-menu__btn"
            aria-haspopup="true"
            aria-expanded="false"
            aria-label="Mở menu tài khoản"
            data-user-menu-btn>
        <div class="lf-user-menu__avatar-shell">
            <lf:avatar fullName="${fullName}" className="lf-navbar__avatar"/>
        </div>
        <div class="lf-user-menu__meta">
            <div class="lf-navbar__uname">${fullName}</div>
            <span class="lf-navbar__role ${__roleKey}">${__roleLabel}</span>
        </div>
        <span class="lf-user-menu__chevron" aria-hidden="true">
            <span class="lf-user-menu__chevron-line"></span>
        </span>
    </button>

    <div class="lf-user-menu__panel" role="menu" data-user-menu-panel>
        <div class="lf-user-menu__summary">
            <div class="lf-user-menu__summary-avatar">
                <lf:avatar fullName="${fullName}" className="lf-navbar__avatar lf-user-menu__summary-avatar-badge"/>
            </div>
            <div class="lf-user-menu__summary-content">
                <div class="lf-user-menu__summary-name">${fullName}</div>
                <div class="lf-user-menu__summary-hint">${__roleHint}</div>
                <span class="lf-navbar__role ${__roleKey}">${__roleLabel}</span>
            </div>
        </div>

        <div class="lf-user-menu__sep"></div>

        <a class="lf-user-menu__item" role="menuitem" href="${contextPath}/edit_profile">
            <span class="lf-user-menu__item-icon">&#128100;</span>
            <span class="lf-user-menu__item-copy">
                <span class="lf-user-menu__item-title">Sửa tài khoản</span>
                <span class="lf-user-menu__item-sub">Cập nhật thông tin cá nhân</span>
            </span>
        </a>

        <a class="lf-user-menu__item danger" role="menuitem" href="${contextPath}/logout">
            <span class="lf-user-menu__item-icon">&#9211;</span>
            <span class="lf-user-menu__item-copy">
                <span class="lf-user-menu__item-title">Đăng xuất</span>
                <span class="lf-user-menu__item-sub">Thoát khỏi phiên đăng nhập</span>
            </span>
        </a>
    </div>
</div>
