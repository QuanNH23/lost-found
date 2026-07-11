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

    <!-- ── NAVBAR ── -->
    <lf:navbar activeMenu="items" />

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
            <aside class="lf-card" style="flex:0 0 280px;max-width:320px; padding:20px;">
                <form action="${pageContext.request.contextPath}/items" method="get" class="lf-form" id="filterForm">
                    <input type="hidden" name="type" value="${type}"/>

                    <div class="flex flex-between flex-center-y" style="border-bottom:1px solid #e5e7eb; padding-bottom:12px; margin-bottom:20px;">
                        <h3 style="font-size:1.1rem; margin:0; font-weight:700;">Bộ lọc</h3>
                        <a href="${pageContext.request.contextPath}/items?type=${type}" style="color:var(--clr-primary); font-size:0.85rem; text-decoration:none;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:-2px; margin-right:2px;"><path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8"></path><polyline points="21 3 21 8 16 8"></polyline></svg>Xóa bộ lọc
                        </a>
                    </div>

                    <div class="lf-form-group" style="margin-bottom:20px;">
                        <label class="lf-label" style="font-size:1.05rem; margin-bottom:8px;">Từ khóa</label>
                        <input type="text" name="search" class="lf-input" value="${searchKeyword}" placeholder="Nhập từ khóa cần tìm kiếm...">
                    </div>

                    <div class="lf-form-group" style="margin-bottom:20px;">
                        <label class="lf-label" style="font-size:1.05rem; margin-bottom:8px;">Danh mục</label>
                        <div style="display:flex; flex-direction:column; gap:10px;">
                            <c:forEach var="c" items="${categories}">
                                <label style="display:flex; align-items:center; gap:8px; cursor:pointer; font-size:0.95rem; color:#374151;">
                                    <input type="radio" name="categoryId" value="${c.categoryId}" style="width:18px; height:18px; accent-color:var(--clr-primary);" onchange="this.form.submit()" ${selectedCategoryId == c.categoryId ? 'checked' : ''}>
                                    ${c.name}
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="lf-form-group" style="margin-bottom:24px;">
                        <label class="lf-label" for="locationId" style="font-size:1.05rem; margin-bottom:8px;">Chọn khu vực</label>
                        <select id="locationId" name="locationId" class="lf-select" style="padding:10px;" onchange="this.form.submit()">
                            <option value="">Toàn quốc</option>
                            <c:forEach var="l" items="${locations}">
                                <option value="${l.locationId}" ${selectedLocationId == l.locationId ? 'selected' : ''}>
                                    ${l.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="flex gap-md" style="margin-top:20px;">
                        <button type="button" class="btn btn-secondary" style="flex:1; background:white; color:#374151; border:1px solid #d1d5db;" onclick="window.location.href='${pageContext.request.contextPath}/items?type=${type}'">Đặt lại</button>
                        <button type="submit" class="btn btn-primary" style="flex:1; background:#047857; border-color:#047857;">Tìm kiếm</button>
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

