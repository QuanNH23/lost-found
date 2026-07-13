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

        <!-- Ô tìm kiếm giữa Navbar kiểu mẫu (chỉ hiện đối với User thường) -->
        <c:if test="${sessionScope.userRole != 'admin'}">
            <div class="lf-navbar__search-wrap">
                <form action="${pageContext.request.contextPath}/items" method="GET" class="lf-navbar__search-form">
                    <input type="hidden" name="type" value="all">
                    <input type="text" name="search" class="lf-navbar__search-input" placeholder="Tìm kiếm giấy tờ, thú cưng..." required>
                    <button type="submit" class="lf-navbar__search-btn" title="Tìm kiếm">
                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    </button>
                </form>
            </div>
        </c:if>

        <button class="lf-navbar__toggle" id="navToggle" aria-label="Menu" aria-expanded="false">☰</button>

        <ul class="lf-navbar__nav" id="mainNav">
            <li><a href="${pageContext.request.contextPath}/home" class="lf-navbar__link ${activeMenu == 'home' ? 'active' : ''}">Trang chủ</a></li>
            <c:choose>
                <c:when test="${sessionScope.userRole == 'admin'}">
                    <li><a href="${pageContext.request.contextPath}/admin/data_management" class="lf-navbar__link ${activeMenu == 'admin' ? 'active' : ''}">Quản lý dữ liệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/moderation"  class="lf-navbar__link ${activeMenu == 'moderation' ? 'active' : ''}">Kiểm duyệt</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/blacklist"   class="lf-navbar__link ${activeMenu == 'blacklist' ? 'active' : ''}">Blacklist</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/support"     class="lf-navbar__link ${activeMenu == 'support' ? 'active' : ''}">Hỗ trợ</a></li>
                    <li style="position: relative;">
                        <a href="javascript:void(0)" id="adminNotifToggleBtn" class="lf-navbar__link" style="display:flex; align-items:center; gap:6px;">
                            🔔 Thông báo
                            <c:if test="${not empty requestScope.adminUnreadCount and requestScope.adminUnreadCount > 0}">
                                <span class="badge" id="adminNotifBadge" style="background:#ef4444; color:white; border-radius:10px; padding:2px 6px; font-size:0.75rem; display:inline-block; line-height:1;">
                                    ${requestScope.adminUnreadCount}
                                </span>
                            </c:if>
                        </a>
                        
                        <!-- Dropdown Thông báo Admin -->
                        <div class="fb-notif-dropdown" id="adminNotifDropdown" style="right: 0; left: auto; width: 320px;">
                            <div class="fb-notif-header">
                                <h3>Thông báo hệ thống</h3>
                            </div>
                            <div class="fb-notif-list">
                                <c:choose>
                                    <c:when test="${not empty requestScope.adminNotifications}">
                                        <c:forEach var="notif" items="${requestScope.adminNotifications}">
                                            <c:set var="isAdminRead" value="${notif.isRead == 'true'}" />
                                            <div class="fb-notif-item" style="background-color: ${isAdminRead ? '#ffffff' : '#fff5eb'}; padding: 12px; border-bottom: 1px solid #f1f5f9; cursor: pointer; display: flex; align-items: start;" onclick="window.location='${pageContext.request.contextPath}${notif.link}'">
                                                <div class="fb-notif-avatar" style="background: ${isAdminRead ? '#e2e8f0' : '#fd7e14'}; color: ${isAdminRead ? '#64748b' : 'white'}; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: bold; flex-shrink: 0; margin-right: 12px;">🔔</div>
                                                <div class="fb-notif-body" style="flex: 1;">
                                                    <div class="fb-notif-text" style="color: ${isAdminRead ? '#64748b' : 'var(--txt-primary)'}; font-weight: ${isAdminRead ? 'normal' : '600'}; font-size: 0.85rem; line-height: 1.4;">
                                                        ${notif.message}
                                                    </div>
                                                    <div class="fb-notif-time" style="color: ${isAdminRead ? '#94a3b8' : '#fd7e14'}; font-size:0.75rem; margin-top:4px; font-weight: 700;">${notif.title}</div>
                                                </div>
                                                <c:if test="${!isAdminRead}">
                                                    <span class="fb-notif-unread-dot" style="background: #fd7e14; width: 8px; height: 8px; border-radius: 50%; align-self: center; margin-left: 8px; flex-shrink: 0;"></span>
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
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <%-- Logged-in user: full menu --%>
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
                                                         onclick="handleNotificationClick(this, event, ${msg.messageId}, '${msg.itemId}', '${msg.title}')">
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
                        </c:when>
                        <c:otherwise>
                            <%-- Guest user: only show "Đăng tin" redirecting to login --%>
                            <li><a href="${pageContext.request.contextPath}/login" class="lf-navbar__link">Đăng tin</a></li>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </ul>

        <div class="lf-navbar__user">
            <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                         avatarUrl="${sessionScope.currentUser.avatarUrl}"
                         role="${sessionScope.userRole}"
                         contextPath="${pageContext.request.contextPath}"/>
        </div>
    </div>
</nav>

<style>
/* Notification Badges */
.badge {
    line-height: 1;
}
.fb-notif-dropdown {
    display: none;
    position: absolute;
    top: 100%;
    right: 0;
    width: 360px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1);
    border: 1px solid var(--clr-border);
    margin-top: 12px;
    z-index: 1000;
    overflow: hidden;
}
.fb-notif-dropdown.show {
    display: block;
}
.fb-notif-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px;
    border-bottom: 1px solid var(--clr-border);
}
.fb-notif-header h3 {
    margin: 0;
    font-size: 1.1rem;
    font-weight: 700;
    color: var(--txt-primary);
}
.fb-notif-read-all-btn {
    border: none;
    background: none;
    color: var(--clr-primary);
    font-size: 0.8rem;
    font-weight: 600;
    cursor: pointer;
}
.fb-notif-list {
    max-height: 350px;
    overflow-y: auto;
}
.fb-notif-item {
    display: flex;
    padding: 12px 16px;
    border-bottom: 1px solid #f1f5f9;
    align-items: start;
    cursor: pointer;
    transition: background 0.15s ease;
}
.fb-notif-item:hover {
    background: #f8fafc !important;
}
.fb-notif-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: #f1f5f9;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    margin-right: 12px;
    flex-shrink: 0;
}
.fb-notif-body {
    flex: 1;
}
.fb-notif-text {
    font-size: 0.85rem;
    line-height: 1.4;
    color: var(--txt-primary);
}
.fb-notif-time {
    font-size: 0.75rem;
    color: var(--txt-muted);
    margin-top: 4px;
}
.fb-notif-unread-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--clr-primary);
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

    const adminToggleBtn = document.getElementById('adminNotifToggleBtn');
    const adminDropdown = document.getElementById('adminNotifDropdown');
    
    if (adminToggleBtn && adminDropdown) {
        adminToggleBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            e.preventDefault();
            adminDropdown.classList.toggle('show');
        });
        
        document.addEventListener('click', function(e) {
            if (!adminDropdown.contains(e.target) && e.target !== adminToggleBtn) {
                adminDropdown.classList.remove('show');
            }
        });
    }
});

function handleNotificationClick(element, event, messageId, itemId, title) {
    event.stopPropagation();
    
    // Check if the item is already marked read in JS
    if (element.classList.contains('fb-notif-read-cached')) {
        if (itemId && itemId.trim() !== '' && itemId !== '0') {
            window.location.href = '${pageContext.request.contextPath}/item_detail?id=' + itemId;
        }
        return;
    }
    
    element.classList.add('fb-notif-read-cached');

    fetch('${pageContext.request.contextPath}/mark_notification_read?messageId=' + messageId)
        .then(response => {
            if (response.ok) {
                // Realtime UI updates without reload
                element.style.backgroundColor = 'white';
                
                const textEl = element.querySelector('.fb-notif-text');
                if (textEl) {
                    textEl.style.fontWeight = 'normal';
                }
                
                const dot = element.querySelector('.fb-notif-unread-dot');
                if (dot) {
                    dot.remove();
                }
                
                const badge = document.getElementById('notificationBadge');
                if (badge) {
                    let count = parseInt(badge.innerText.trim());
                    if (!isNaN(count)) {
                        count = count - 1;
                        if (count > 0) {
                            badge.innerText = count > 99 ? '99+' : count;
                        } else {
                            badge.style.display = 'none';
                        }
                    }
                }
                
                if (itemId && itemId.trim() !== '' && itemId !== '0') {
                    window.location.href = '${pageContext.request.contextPath}/item_detail?id=' + itemId;
                }
            }
        });
}

function markAllNotificationsAsRead(event) {
    event.stopPropagation();
    fetch('${pageContext.request.contextPath}/mark_all_notifications_read')
        .then(response => {
            if (response.ok) {
                const items = document.querySelectorAll('.fb-notif-item');
                items.forEach(element => {
                    element.classList.add('fb-notif-read-cached');
                    element.style.backgroundColor = 'white';
                    const textEl = element.querySelector('.fb-notif-text');
                    if (textEl) textEl.style.fontWeight = 'normal';
                    const dot = element.querySelector('.fb-notif-unread-dot');
                    if (dot) dot.remove();
                });
                
                const badge = document.getElementById('notificationBadge');
                if (badge) {
                    badge.style.display = 'none';
                }
            }
        });
}
</script>
