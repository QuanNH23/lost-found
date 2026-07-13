<%@tag description="Navbar user menu (profile/logout)" pageEncoding="UTF-8"%>
<%@attribute name="fullName" required="false" rtexprvalue="true" type="java.lang.String"%>
<%@attribute name="avatarUrl" required="false" rtexprvalue="true" type="java.lang.String"%>
<%@attribute name="role" required="false" rtexprvalue="true" type="java.lang.String"%>
<%@attribute name="contextPath" required="true" rtexprvalue="true" type="java.lang.String"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>

<c:choose>
    <c:when test="${empty fullName}">
        <!-- GUEST STATE -->
        <div class="lf-user-menu" data-user-menu>
            <button type="button"
                    class="lf-user-menu__btn"
                    aria-haspopup="true"
                    aria-expanded="false"
                    aria-label="Mở menu tài khoản khách"
                    data-user-menu-btn>
                <div class="lf-user-menu__avatar-shell">
                    <div class="lf-navbar__avatar" style="background: #e2e8f0; color: #475569; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; border-radius: 50%; width:32px; height:32px;">
                        👤
                    </div>
                </div>
                <div class="lf-user-menu__meta">
                    <div class="lf-navbar__uname">Khách</div>
                    <span class="lf-navbar__role student">Guest</span>
                </div>
                <span class="lf-user-menu__chevron" aria-hidden="true">
                    <span class="lf-user-menu__chevron-line"></span>
                </span>
            </button>

            <div class="lf-user-menu__panel" role="menu" data-user-menu-panel>
                <div class="lf-user-menu__summary">
                    <div class="lf-user-menu__summary-avatar">
                        <div class="lf-navbar__avatar" style="background: #e2e8f0; color: #475569; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border-radius: 50%; width:40px; height:40px;">
                            👤
                        </div>
                    </div>
                    <div class="lf-user-menu__summary-content">
                        <div class="lf-user-menu__summary-name">Chào bạn!</div>
                        <div class="lf-user-menu__summary-hint">Hãy đăng nhập để đăng bài mới</div>
                    </div>
                </div>

                <div class="lf-user-menu__sep"></div>

                <a class="lf-user-menu__item" role="menuitem" href="${contextPath}/login">
                    <span class="lf-user-menu__item-icon">🔑</span>
                    <span class="lf-user-menu__item-copy">
                        <span class="lf-user-menu__item-title">Đăng nhập</span>
                        <span class="lf-user-menu__item-sub">Truy cập tài khoản của bạn</span>
                    </span>
                </a>

                <a class="lf-user-menu__item" role="menuitem" href="${contextPath}/register">
                    <span class="lf-user-menu__item-icon">📝</span>
                    <span class="lf-user-menu__item-copy">
                        <span class="lf-user-menu__item-title">Đăng ký</span>
                        <span class="lf-user-menu__item-sub">Tạo tài khoản mới</span>
                    </span>
                </a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <!-- LOGGED-IN STATE -->
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
                    <lf:avatar fullName="${fullName}" avatarUrl="${avatarUrl}" className="lf-navbar__avatar"/>
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
                        <lf:avatar fullName="${fullName}" avatarUrl="${avatarUrl}" className="lf-navbar__avatar lf-user-menu__summary-avatar-badge"/>
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
    </c:otherwise>
</c:choose>
