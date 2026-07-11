<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<%@ attribute name="activeMenu" required="false" type="java.lang.String" description="active menu item" %>

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

        <button class="lf-navbar__toggle" id="navToggle" aria-label="Menu" aria-expanded="false">☰</button>

        <ul class="lf-navbar__nav" id="mainNav">
            <li><a href="${pageContext.request.contextPath}/home" class="lf-navbar__link ${activeMenu == 'home' ? 'active' : ''}">Trang chủ</a></li>
            <c:choose>
                <c:when test="${sessionScope.userRole == 'admin'}">
                    <li><a href="${pageContext.request.contextPath}/manage_users"    class="lf-navbar__link ${activeMenu == 'manage_users' ? 'active' : ''}">Người dùng</a></li>
                    <li><a href="${pageContext.request.contextPath}/manage_categories" class="lf-navbar__link ${activeMenu == 'manage_categories' ? 'active' : ''}">Danh mục</a></li>
                    <li><a href="${pageContext.request.contextPath}/manage_locations"  class="lf-navbar__link ${activeMenu == 'manage_locations' ? 'active' : ''}">Vị trí</a></li>
                    <li><a href="${pageContext.request.contextPath}/manage_items"      class="lf-navbar__link ${activeMenu == 'manage_items' ? 'active' : ''}">Vật phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/manage_claims"     class="lf-navbar__link ${activeMenu == 'manage_claims' ? 'active' : ''}">Yêu cầu</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${pageContext.request.contextPath}/report_lost?type=lost"   class="lf-navbar__link ${activeMenu == 'report_lost' ? 'active' : ''}">Báo mất</a></li>
                    <li><a href="${pageContext.request.contextPath}/report_found"             class="lf-navbar__link ${activeMenu == 'report_found' ? 'active' : ''}">Báo nhặt</a></li>
                    <li><a href="${pageContext.request.contextPath}/my_items"                 class="lf-navbar__link ${activeMenu == 'my_items' ? 'active' : ''}">Tin của tôi</a></li>
                    <li>
                        <a href="${pageContext.request.contextPath}/inbox" class="lf-navbar__link ${activeMenu == 'inbox' ? 'active' : ''}" style="display:flex; align-items:center; gap:6px;">
                            Hộp thư
                            <c:if test="${not empty requestScope.unreadInboxCount and requestScope.unreadInboxCount > 0}">
                                <span class="badge" style="background:#f97316; color:white; border-radius:10px; padding:2px 6px; font-size:0.75rem; display:inline-block; line-height:1;">
                                    ${requestScope.unreadInboxCount > 99 ? '99+' : requestScope.unreadInboxCount}
                                </span>
                            </c:if>
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>

        <div class="lf-navbar__user">
            <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                         role="${sessionScope.userRole}"
                         contextPath="${pageContext.request.contextPath}"/>
        </div>
    </div>
</nav>
