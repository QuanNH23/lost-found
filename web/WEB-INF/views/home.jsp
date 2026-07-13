<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ — Hệ thống Quản lý Đồ thất lạc</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">

    <!-- ── NAVBAR ── -->
    <lf:navbar activeMenu="home" />

    <!-- Flash message handled by toast (JS overrides alert) -->
    <c:if test="${not empty sessionScope.message}">
        <script>
            window.addEventListener('DOMContentLoaded', function() {
                window.LF && window.LF.toast('${fn:escapeXml(sessionScope.message)}', 'success');
            });
        </script>
        <c:remove var="message" scope="session"/>
    </c:if>

    <!-- ── MAIN ── -->
    <main class="lf-main">

        <c:choose>
        <c:when test="${sessionScope.userRole == 'admin'}">
            <div class="lf-admin-header">
                <div class="lf-admin-badge">Admin Panel</div>
                <h1 class="lf-page-header__title">Bảng Điều Khiển Hệ Thống</h1>
                <p class="lf-page-header__sub">Quản lý toàn bộ hệ thống đồ thất lạc trong trường học</p>
            </div>

            <!-- Stats -->
            <div class="lf-stats mb-lg">
                <a href="${pageContext.request.contextPath}/admin/data_management?tab=users" style="text-decoration: none; color: inherit; display: block;">
                    <div class="lf-stat">
                        <div class="lf-stat__icon">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        </div>
                        <div>
                            <div class="lf-stat__val">${totalUsers}</div>
                            <div class="lf-stat__label">Người dùng</div>
                        </div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/data_management?tab=items" style="text-decoration: none; color: inherit; display: block;">
                    <div class="lf-stat">
                        <div class="lf-stat__icon danger">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/></svg>
                        </div>
                        <div>
                            <div class="lf-stat__val">${totalLostItems}</div>
                            <div class="lf-stat__label">Đồ báo mất</div>
                        </div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/data_management?tab=items" style="text-decoration: none; color: inherit; display: block;">
                    <div class="lf-stat">
                        <div class="lf-stat__icon success">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                        </div>
                        <div>
                            <div class="lf-stat__val">${totalFoundItems}</div>
                            <div class="lf-stat__label">Đồ nhặt được</div>
                        </div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/moderation" style="text-decoration: none; color: inherit; display: block;">
                    <div class="lf-stat">
                        <div class="lf-stat__icon success">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                        </div>
                        <div>
                            <div class="lf-stat__val">${pendingModerationsCount}</div>
                            <div class="lf-stat__label">Bài viết cần kiểm tra</div>
                        </div>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/support" style="text-decoration: none; color: inherit; display: block;">
                    <div class="lf-stat">
                        <c:if test="${not empty pendingSupportsCount and pendingSupportsCount > 0}">
                            <span class="lf-stat__badge">+${pendingSupportsCount}</span>
                        </c:if>
                        <div class="lf-stat__icon warn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                        </div>
                        <div>
                            <div class="lf-stat__val">${pendingSupportsCount}</div>
                            <div class="lf-stat__label">Yêu cầu hỗ trợ</div>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Quick access -->
            <div class="lf-card">
                <div class="lf-card__title">Quản lý nhanh</div>
                <div class="flex flex-wrap gap-md">
                    <a href="${pageContext.request.contextPath}/admin/data_management" class="btn btn-secondary">📁 Quản lý dữ liệu</a>
                    <a href="${pageContext.request.contextPath}/admin/moderation"  class="btn btn-warning" style="color:#000;">🛡️ Kiểm duyệt</a>
                    <a href="${pageContext.request.contextPath}/admin/blacklist"   class="btn btn-danger">🚫 Blacklist</a>
                    <a href="${pageContext.request.contextPath}/admin/support"     class="btn btn-info" style="color:white;">💬 Hỗ trợ</a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="lf-grid-2">
                <!-- SIDEBAR BÊN TRÁI -->
                <aside class="lf-sidebar" style="background:#ffffff; border:1px solid #e5e7eb; border-radius:12px; padding:16px 8px; flex:0 0 260px; min-height:fit-content; height:fit-content; box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);">
                    <div style="padding:12px 16px 20px; border-bottom:1px solid #e5e7eb; color:var(--clr-primary); font-weight:700; font-size:1.05rem; text-align:center;">
                        Lost&Found — Tìm là thấy
                    </div>
                    <ul class="lf-menu" style="list-style:none; padding:12px 0; margin:0;">
                        <li style="padding:4px 16px;">
                            <a href="${pageContext.request.contextPath}/report_lost" style="display:flex; align-items:center; gap:12px; color:#1f2937; text-decoration:none; padding:8px; border-radius:6px; font-weight:500;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                                Đăng tin
                            </a>
                        </li>
                        <li style="padding:4px 16px;">
                            <a href="${pageContext.request.contextPath}/items?type=lost" style="display:flex; align-items:center; gap:12px; color:#1f2937; text-decoration:none; padding:8px; border-radius:6px; font-weight:500;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"></circle><path d="M16 16s-1.5-2-4-2-4 2-4 2"></path><line x1="9" y1="9" x2="9.01" y2="9"></line><line x1="15" y1="9" x2="15.01" y2="9"></line></svg>
                                Mất đồ
                            </a>
                        </li>
                        <li style="padding:4px 16px;">
                            <a href="${pageContext.request.contextPath}/items?type=found" style="display:flex; align-items:center; gap:12px; color:#1f2937; text-decoration:none; padding:8px; border-radius:6px; font-weight:500;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="8" width="18" height="12" rx="1"></rect><path d="M12 8v12"></path><path d="M19 12H5"></path><path d="M12 8c0-3-2-5-5-5a3 3 0 0 0 0 6"></path><path d="M12 8c0-3 2-5 5-5a3 3 0 0 1 0 6"></path></svg>
                                Nhặt được
                            </a>
                        </li>
                        <c:forEach var="cat" items="${categories}">
                            <li style="padding:4px 16px;">
                                <a href="${pageContext.request.contextPath}/items?type=lost&categoryId=${cat.categoryId}" style="display:flex; align-items:center; gap:12px; color:#1f2937; text-decoration:none; padding:8px; border-radius:6px; font-weight:500;">
                                    <c:choose>
                                        <c:when test="${cat.categoryId == 1}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect><line x1="12" y1="18" x2="12.01" y2="18"></line></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 2}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 3}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 4}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="7"></circle><polyline points="12 9 12 12 13.5 13.5"></polyline><path d="M16.51 17.35l-.35 3.83a2 2 0 0 1-2 1.82H9.83a2 2 0 0 1-2-1.82l-.35-3.83m.01-10.7l.35-3.83A2 2 0 0 1 9.83 1h4.35a2 2 0 0 1 2 1.82l.35 3.83"></path></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 5}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20.38 3.46L16 2a8 8 0 0 1-8 0L3.62 3.46a2 2 0 0 0-1.34 2.23l.58 3.47a1 1 0 0 0 .99.84H6v10c0 1.1.9 2 2 2h8a2 2 0 0 0 2-2V10h2.15a1 1 0 0 0 .99-.84l.58-3.47a2 2 0 0 0-1.34-2.23z"></path></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 6}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 7}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20 12V8H6a2 2 0 0 1-2-2c0-1.1.9-2 2-2h12v4"></path><path d="M4 6v12c0 1.1.9 2 2 2h14v-4"></path><path d="M18 12a2 2 0 0 0-2 2c0 1.1.9 2 2 2h4v-4h-4z"></path></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 8}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="4" y="2" width="16" height="20" rx="2" ry="2"></rect><rect x="8" y="6" width="8" height="4" rx="1" ry="1"></rect><line x1="8" y1="14" x2="8.01" y2="14"></line><line x1="12" y1="14" x2="12.01" y2="14"></line><line x1="16" y1="14" x2="16.01" y2="14"></line><line x1="8" y1="18" x2="8.01" y2="18"></line><line x1="12" y1="18" x2="12.01" y2="18"></line><line x1="16" y1="18" x2="16.01" y2="18"></line></svg>
                                        </c:when>
                                        <c:when test="${cat.categoryId == 9}">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path><line x1="6" y1="1" x2="6" y2="4"></line><line x1="10" y1="1" x2="10" y2="4"></line><line x1="14" y1="1" x2="14" y2="4"></line></svg>
                                        </c:when>
                                        <c:otherwise>
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                                        </c:otherwise>
                                    </c:choose>
                                    ${cat.name}
                                </a>
                            </li>
                        </c:forEach>

                    </ul>
                </aside>

                <!-- PHẦN CONTENT BÊN PHẢI -->
                <div>
                    <!-- Bộ lọc vị trí trên cùng -->
                    <div class="flex flex-between flex-center-y mb-lg" style="background:white; padding:12px; border-radius:var(--r-md); border:1px solid var(--clr-border);">
                        <div>
                            <h1 class="lf-page-header__title" style="font-size:1.1rem; margin-bottom:0;">Bảng tin trường học</h1>
                            <span class="text-muted text-sm">Tìm kiếm đồ thất lạc nhanh chóng</span>
                        </div>
                        <div class="lf-filter-select-container">
                            <select onchange="if(this.value) { window.location.href='${pageContext.request.contextPath}/items?type=lost&locationId=' + this.value; }" class="lf-filter-select">
                                <option value="">Khu vực</option>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc.locationId}">${loc.name}</option>
                                </c:forEach>
                            </select>
                            <div class="lf-filter-select-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            </div>
                        </div>
                    </div>

                    <!-- Feed: Đồ báo mất gần đây -->
                    <div class="flex flex-between flex-center-y mb-sm">
                        <h2 class="lf-section-title" style="margin-bottom:0;">
                            <span class="dot"></span> Đồ báo mất mới nhất
                        </h2>
                        <a href="${pageContext.request.contextPath}/items?type=lost" class="text-sm text-link">
                            Xem tất cả →
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty latestLostItems}">
                            <div class="lf-items-grid mb-lg">
                                <c:forEach var="it" items="${latestLostItems}">
                                    <div class="lf-item-card border-lost">
                                        <!-- Thumbnail Image -->
                                        <c:set var="firstImg" value="${it.imagesJSON}"/>
                                        <c:if test="${not empty firstImg}">
                                            <!-- parse image path -->
                                            <c:set var="imgToShow" value="${fn:replace(fn:replace(fn:replace(fn:split(firstImg, ',')[0], '\"', ''), '[', ''), ']', '')}"/>
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" style="display:block; text-decoration:none;">
                                                <img src="${pageContext.request.contextPath}/${imgToShow}" class="lf-item-card__thumb" alt="Ảnh đồ vật">
                                            </a>
                                        </c:if>
                                        <c:if test="${empty firstImg}">
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" style="display:block; text-decoration:none;">
                                                <div class="lf-item-card__thumb-placeholder">📦</div>
                                            </a>
                                        </c:if>
                                        
                                        <div class="lf-item-card__body">
                                            <div style="margin-bottom: 4px;">
                                                <span class="badge badge-danger">Mất đồ</span>
                                            </div>
                                            <div class="lf-item-card__title">${it.title}</div>
                                            <div class="lf-item-card__meta">
                                                📍 ${it.locationName}
                                            </div>
                                        </div>
                                        <div class="lf-item-card__footer" style="padding:0 12px 12px;">
                                            <span class="lf-item-card__time">${it.friendlyTime}</span>
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" class="btn btn-primary btn-sm" style="background:var(--clr-primary); border:none; padding:4px 10px;">
                                                Chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <lf:emptyState title="Chưa có đồ báo mất nào" sub="Hệ thống đang cập nhật."/>
                        </c:otherwise>
                    </c:choose>

                    <!-- Feed: Đồ nhặt được gần đây -->
                    <div class="flex flex-between flex-center-y mb-sm" style="margin-top:20px;">
                        <h2 class="lf-section-title" style="margin-bottom:0;">
                            <span class="dot" style="background:var(--clr-green);"></span> Đồ nhặt được mới nhất
                        </h2>
                        <a href="${pageContext.request.contextPath}/items?type=found" class="text-sm text-link">
                            Xem tất cả →
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty latestFoundItems}">
                            <div class="lf-items-grid">
                                <c:forEach var="it" items="${latestFoundItems}">
                                    <div class="lf-item-card border-found">
                                        <!-- Thumbnail Image -->
                                        <c:set var="firstImg" value="${it.imagesJSON}"/>
                                        <c:if test="${not empty firstImg}">
                                            <c:set var="imgToShow" value="${fn:replace(fn:replace(fn:replace(fn:split(firstImg, ',')[0], '\"', ''), '[', ''), ']', '')}"/>
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" style="display:block; text-decoration:none;">
                                                <img src="${pageContext.request.contextPath}/${imgToShow}" class="lf-item-card__thumb" alt="Ảnh đồ vật">
                                            </a>
                                        </c:if>
                                        <c:if test="${empty firstImg}">
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" style="display:block; text-decoration:none;">
                                                <div class="lf-item-card__thumb-placeholder">🟢</div>
                                            </a>
                                        </c:if>
                                        
                                        <div class="lf-item-card__body">
                                            <div style="margin-bottom: 4px;">
                                                <span class="badge badge-success">Nhặt được</span>
                                            </div>
                                            <div class="lf-item-card__title">${it.title}</div>
                                            <div class="lf-item-card__meta">
                                                📍 ${it.locationName}
                                            </div>
                                        </div>
                                        <div class="lf-item-card__footer" style="padding:0 12px 12px;">
                                            <span class="lf-item-card__time">${it.friendlyTime}</span>
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" class="btn btn-primary btn-sm" style="background:var(--clr-primary); border:none; padding:4px 10px;">
                                                Chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <lf:emptyState title="Chưa có đồ nhặt được nào" sub="Hệ thống đang cập nhật."/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    </main>

    <lf:footer />
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
