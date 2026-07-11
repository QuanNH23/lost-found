<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${type == 'found'}">Tất cả đồ nhặt được</c:when>
            <c:otherwise>Tất cả đồ báo mất</c:otherwise>
        </c:choose>
        — Lost &amp; Found
    </title>
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

            <button class="lf-navbar__toggle" id="navToggle" aria-label="Menu" aria-expanded="false">☰</button>

            <ul class="lf-navbar__nav" id="mainNav">
                <li><a href="${pageContext.request.contextPath}/home" class="lf-navbar__link">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/report_lost?type=lost" class="lf-navbar__link">Báo mất</a></li>
                <li><a href="${pageContext.request.contextPath}/report_found" class="lf-navbar__link">Báo nhặt</a></li>
                <li><a href="${pageContext.request.contextPath}/my_items" class="lf-navbar__link">Tin của tôi</a></li>
                <li><a href="${pageContext.request.contextPath}/inbox" class="lf-navbar__link">Hộp thư</a></li>
            </ul>

            <div class="lf-navbar__user">
                <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                             role="${sessionScope.userRole}"
                             contextPath="${pageContext.request.contextPath}"/>
            </div>
        </div>
    </nav>

    <main class="lf-main">
        <div class="lf-page-header">
            <h1 class="lf-page-header__title">
                <c:choose>
                    <c:when test="${type == 'found'}">Tất cả đồ nhặt được</c:when>
                    <c:otherwise>Tất cả đồ báo mất</c:otherwise>
                </c:choose>
            </h1>
            <p class="lf-page-header__sub">
                Danh sách đầy đủ các tin
                <c:choose>
                    <c:when test="${type == 'found'}">đồ nhặt được</c:when>
                    <c:otherwise>đồ báo mất</c:otherwise>
                </c:choose>
                trong hệ thống.
            </p>
        </div>

        <div class="flex gap-lg" style="align-items:flex-start;">
            <!-- Bộ lọc (sidebar ~30%) -->
            <aside class="lf-card" style="flex:0 0 280px;max-width:320px;">
                <div class="lf-card__title">Bộ lọc</div>
                <form action="${pageContext.request.contextPath}/items" method="get" class="lf-form">
                    <input type="hidden" name="type" value="${type}"/>

                    <div class="lf-form-group">
                        <label class="lf-label" for="categoryId">Danh mục</label>
                        <select id="categoryId" name="categoryId" class="lf-select">
                            <option value="">Tất cả</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${selectedCategoryId == c.categoryId ? 'selected' : ''}>
                                    ${c.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="lf-form-group">
                        <label class="lf-label" for="locationId">Vị trí</label>
                        <select id="locationId" name="locationId" class="lf-select">
                            <option value="">Tất cả</option>
                            <c:forEach var="l" items="${locations}">
                                <option value="${l.locationId}" ${selectedLocationId == l.locationId ? 'selected' : ''}>
                                    ${l.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="lf-form-group">
                        <label class="lf-label" for="fromDate">Từ ngày</label>
                        <input id="fromDate" type="date" name="fromDate" class="lf-input" value="${fromDate}"/>
                    </div>

                    <div class="lf-form-group">
                        <label class="lf-label" for="toDate">Đến ngày</label>
                        <input id="toDate" type="date" name="toDate" class="lf-input" value="${toDate}"/>
                    </div>

                    <div class="lf-form-group">
                        <button type="submit" class="btn btn-primary btn-full">Lọc</button>
                        <a href="${pageContext.request.contextPath}/items?type=${type}" class="btn btn-ghost btn-full" style="margin-top:8px;">Xóa lọc</a>
                    </div>
                </form>
            </aside>

            <!-- Danh sách items (~70%) -->
            <section style="flex:1 1 auto;min-width:0;margin-left:5vw;">
                <c:choose>
                    <c:when test="${not empty items}">
                        <div class="lf-items-grid">
                            <c:forEach var="it" items="${items}">
                                <div class="lf-item-card">
                                    <div class="flex flex-between gap-sm" style="padding: 12px 12px 0;">
                                        <lf:typeBadge type="${type}"/>
                                        <span class="text-xs text-muted"><fmt:formatDate value="${it.createdAt}" pattern="dd/MM/yyyy"/></span>
                                    </div>
                                    <div class="lf-item-card__body">
                                        <div class="lf-item-card__title">${it.title}</div>
                                        <div class="lf-item-card__meta">
                                            Ngày xảy ra: <fmt:formatDate value="${it.dateIncident}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                    <div class="lf-item-card__foot">
                                        <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}"
                                           class="btn btn-primary btn-sm btn-full">
                                            Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <lf:emptyState title="Chưa có tin nào." sub="Hãy quay lại sau hoặc đăng tin mới nhé!"/>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>

    <footer class="lf-footer">
        © 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>

