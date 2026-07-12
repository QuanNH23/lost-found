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
                    <li><a href="${pageContext.request.contextPath}/report_lost" class="lf-navbar__link ${activeMenu == 'report_lost' ? 'active' : ''}">Đăng tin</a></li>
                    <li><a href="${pageContext.request.contextPath}/my_items"                 class="lf-navbar__link ${activeMenu == 'my_items' ? 'active' : ''}">Tin của tôi</a></li>
                    <li style="position: relative;">
                        <a href="javascript:void(0)" id="notificationToggleBtn" class="lf-navbar__link" style="display:flex; align-items:center; gap:6px;">
                            Hộp thư
                            <c:if test="${not empty requestScope.unreadInboxCount and requestScope.unreadInboxCount > 0}">
                                <span class="badge" id="notificationBadge" style="background:#f97316; color:white; border-radius:10px; padding:2px 6px; font-size:0.75rem; display:inline-block; line-height:1;">
                                    ${requestScope.unreadInboxCount > 99 ? '99+' : requestScope.unreadInboxCount}
                                </span>
                            </c:if>
                        </a>

                        <!-- Facebook-style Notification Dropdown -->
                        <div class="fb-notif-dropdown" id="fbNotifDropdown">
                            <div class="fb-notif-header">
                                <h3>Thông báo</h3>
                                <button onclick="markAllNotificationsAsRead(event)" class="fb-notif-read-all-btn">Đánh dấu tất cả đã đọc</button>
                            </div>
                            <div class="fb-notif-list">
                                <c:choose>
                                    <c:when test="${not empty requestScope.inboxNotificationsList}">
                                        <c:forEach var="msg" items="${requestScope.inboxNotificationsList}">
                                            <c:set var="itemBg" value="white"/>
                                            <c:set var="textColor" value="var(--txt-primary)"/>
                                            <c:choose>
                                                <c:when test="${not msg.isRead}">
                                                    <c:choose>
                                                        <c:when test="${msg.title == 'Support_Resolved'}">
                                                            <c:set var="itemBg" value="#e6f4ea"/>
                                                            <c:set var="textColor" value="#137333"/>
                                                        </c:when>
                                                        <c:when test="${msg.title == 'Support_Rejected'}">
                                                            <c:set var="itemBg" value="#fce8e6"/>
                                                            <c:set var="textColor" value="#c5221f"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="itemBg" value="#f0f2f5"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                            </c:choose>

                                            <div class="fb-notif-item" style="background-color: ${itemBg};" 
                                                 onclick="handleNotificationClick(event, ${msg.messageId}, '${msg.itemId}', '${msg.title}')">
                                                <div class="fb-notif-avatar">
                                                    <c:choose>
                                                        <c:when test="${not empty msg.itemId}">💬</c:when>
                                                        <c:otherwise>🔔</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="fb-notif-body">
                                                    <div class="fb-notif-text" style="color: ${textColor}; font-weight: ${msg.isRead ? 'normal' : '600'};">
                                                        ${msg.message}
                                                    </div>
                                                    <div class="fb-notif-time">${msg.createdAt}</div>
                                                </div>
                                                <c:if test="${not msg.isRead}">
                                                    <span class="fb-notif-unread-dot"></span>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="padding: 24px; text-align: center; color: var(--txt-muted); font-size: 0.9rem;">
                                            Chưa có thông báo nào.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
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

<style>
.fb-notif-dropdown {
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    width: 360px;
    background: white;
    border: 1px solid #cbd5e1;
    border-radius: 12px;
    box-shadow: 0 12px 28px 0 rgba(0, 0, 0, 0.15), 0 2px 4px 0 rgba(0, 0, 0, 0.05);
    display: none;
    z-index: 9999;
}
.fb-notif-dropdown.show {
    display: block;
}
.fb-notif-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 16px;
    border-bottom: 1px solid #e2e8f0;
}
.fb-notif-header h3 {
    margin: 0;
    font-size: 1rem;
    font-weight: 700;
    color: var(--txt-primary);
}
.fb-notif-read-all-btn {
    background: none;
    border: none;
    color: var(--clr-primary);
    font-size: 0.8rem;
    font-weight: 600;
    cursor: pointer;
    padding: 0;
}
.fb-notif-read-all-btn:hover {
    text-decoration: underline;
}
.fb-notif-list {
    max-height: 360px;
    overflow-y: auto;
}
.fb-notif-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 12px 16px;
    cursor: pointer;
    transition: background-color 0.15s;
    position: relative;
    border-bottom: 1px solid #f1f5f9;
}
.fb-notif-item:hover {
    background-color: #f8fafc !important;
}
.fb-notif-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background-color: #f1f5f9;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.95rem;
    flex-shrink: 0;
}
.fb-notif-body {
    flex-grow: 1;
}
.fb-notif-text {
    font-size: 0.82rem;
    line-height: 1.35;
    word-break: break-word;
}
.fb-notif-time {
    font-size: 0.72rem;
    color: var(--txt-muted);
    margin-top: 4px;
}
.fb-notif-unread-dot {
    width: 8px;
    height: 8px;
    background-color: var(--clr-primary);
    border-radius: 50%;
    align-self: center;
    margin-left: auto;
    flex-shrink: 0;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const toggleBtn = document.getElementById('notificationToggleBtn');
    const dropdown = document.getElementById('fbNotifDropdown');
    
    if (toggleBtn && dropdown) {
        toggleBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            e.preventDefault();
            dropdown.classList.toggle('show');
        });
        
        document.addEventListener('click', function(e) {
            if (!dropdown.contains(e.target) && e.target !== toggleBtn) {
                dropdown.classList.remove('show');
            }
        });
    }
});

function handleNotificationClick(event, messageId, itemId, title) {
    event.stopPropagation();
    
    fetch('${pageContext.request.contextPath}/mark_notification_read?messageId=' + messageId)
        .then(response => {
            if (response.ok) {
                if (itemId && itemId.trim() !== '' && itemId !== '0') {
                    window.location.href = '${pageContext.request.contextPath}/item_detail?id=' + itemId;
                } else {
                    window.location.reload();
                }
            }
        });
}

function markAllNotificationsAsRead(event) {
    event.stopPropagation();
    fetch('${pageContext.request.contextPath}/mark_all_notifications_read')
        .then(response => {
            if (response.ok) {
                window.location.reload();
            }
        });
}
</script>
