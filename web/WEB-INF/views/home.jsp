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
                <div class="lf-stat">
                    <div class="lf-stat__icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                    <div>
                        <div class="lf-stat__val">${totalUsers}</div>
                        <div class="lf-stat__label">Người dùng</div>
                    </div>
                </div>
                <div class="lf-stat">
                    <div class="lf-stat__icon danger">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/></svg>
                    </div>
                    <div>
                        <div class="lf-stat__val">${totalLostItems}</div>
                        <div class="lf-stat__label">Đồ báo mất</div>
                    </div>
                </div>
                <div class="lf-stat">
                    <div class="lf-stat__icon success">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    </div>
                    <div>
                        <div class="lf-stat__val">${totalFoundItems}</div>
                        <div class="lf-stat__label">Đồ nhặt được</div>
                    </div>
                </div>
                <div class="lf-stat">
                    <div class="lf-stat__icon success">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    </div>
                    <div>
                        <div class="lf-stat__val">${totalCompletedItems}</div>
                        <div class="lf-stat__label">Đã hoàn thành</div>
                    </div>
                </div>
                <div class="lf-stat">
                    <div class="lf-stat__icon warn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    </div>
                    <div>
                        <div class="lf-stat__val">${totalProcessingItems}</div>
                        <div class="lf-stat__label">Đang xử lý</div>
                    </div>
                </div>
            </div>

            <!-- Quick access -->
            <div class="lf-card">
                <div class="lf-card__title">Quản lý nhanh</div>
                <div class="flex flex-wrap gap-md">
                    <a href="${pageContext.request.contextPath}/manage_users"      class="btn btn-secondary">Tài khoản</a>
                    <a href="${pageContext.request.contextPath}/manage_categories" class="btn btn-secondary">Danh mục</a>
                    <a href="${pageContext.request.contextPath}/manage_locations"  class="btn btn-secondary">Vị trí</a>
                    <a href="${pageContext.request.contextPath}/manage_items"      class="btn btn-secondary">Vật phẩm</a>
                    <a href="${pageContext.request.contextPath}/manage_claims"     class="btn btn-secondary">Yêu cầu</a>
                    <a href="${pageContext.request.contextPath}/admin/moderation"  class="btn btn-warning" style="color:#000;">Kiểm duyệt</a>
                    <a href="${pageContext.request.contextPath}/admin/blacklist"   class="btn btn-danger">Blacklist</a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="lf-grid-2">
                <!-- SIDEBAR BÊN TRÁI -->
                <aside class="lf-sidebar">
                    <div class="lf-sidebar__title">0711.vn - Tìm là thấy</div>
                    <ul class="lf-menu">
                        <li class="lf-menu__item">
                            <a href="${pageContext.request.contextPath}/report_lost?type=lost" class="active" style="background:var(--clr-primary); color:white;">
                                <span class="menu-icon" style="color:var(--clr-primary);">➕</span> Đăng tin mới
                            </a>
                        </li>
                        <li class="lf-menu__item">
                            <a href="${pageContext.request.contextPath}/items?type=lost">
                                <span class="menu-icon">🔴</span> Mất đồ
                            </a>
                        </li>
                        <li class="lf-menu__item">
                            <a href="${pageContext.request.contextPath}/items?type=found">
                                <span class="menu-icon">🟢</span> Nhặt được
                            </a>
                        </li>
                        
                        <div class="lf-sidebar__title" style="margin-top:15px;">Danh mục đồ vật</div>
                        <c:forEach var="cat" items="${categories}">
                            <li class="lf-menu__item">
                                <a href="${pageContext.request.contextPath}/items?type=lost&categoryId=${cat.categoryId}">
                                    <span class="menu-icon">📦</span> ${cat.name}
                                </a>
                            </li>
                        </c:forEach>

                        <div class="lf-sidebar__title" style="margin-top:15px;">Cộng đồng</div>
                        <li class="lf-menu__item">
                            <a href="${pageContext.request.contextPath}/my_items">
                                <span class="menu-icon">📂</span> Tin của tôi
                            </a>
                        </li>
                        <li class="lf-menu__item">
                            <a href="${pageContext.request.contextPath}/inbox">
                                <span class="menu-icon">✉</span> Hộp thư
                            </a>
                        </li>
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
                        <div>
                            <select onchange="if(this.value) { window.location.href='${pageContext.request.contextPath}/items?type=lost&locationId=' + this.value; }" class="lf-select" style="min-width:180px; padding:6px 12px; font-size:0.85rem;">
                                <option value="">Toàn quốc / Khu vực</option>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc.locationId}">${loc.name}</option>
                                </c:forEach>
                            </select>
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
                                    <div class="lf-item-card">
                                        <!-- Thumbnail Image -->
                                        <c:set var="firstImg" value="${it.imagesJSON}"/>
                                        <c:if test="${not empty firstImg}">
                                            <!-- parse image path -->
                                            <c:set var="imgToShow" value="${fn:replace(fn:replace(fn:split(firstImg, ',')[0], '\"', ''), '[', '')}"/>
                                            <img src="${pageContext.request.contextPath}/${imgToShow}" class="lf-item-card__thumb" alt="Ảnh đồ vật">
                                        </c:if>
                                        <c:if test="${empty firstImg}">
                                            <div class="lf-item-card__thumb-placeholder">📦</div>
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
                                            <span class="lf-item-card__time">Mới đăng</span>
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
                                    <div class="lf-item-card">
                                        <!-- Thumbnail Image -->
                                        <c:set var="firstImg" value="${it.imagesJSON}"/>
                                        <c:if test="${not empty firstImg}">
                                            <c:set var="imgToShow" value="${fn:replace(fn:replace(fn:split(firstImg, ',')[0], '\"', ''), '[', '')}"/>
                                            <img src="${pageContext.request.contextPath}/${imgToShow}" class="lf-item-card__thumb" alt="Ảnh đồ vật">
                                        </c:if>
                                        <c:if test="${empty firstImg}">
                                            <div class="lf-item-card__thumb-placeholder">🟢</div>
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
                                            <span class="lf-item-card__time">Mới đăng</span>
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

    <footer class="lf-footer">
        © 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
