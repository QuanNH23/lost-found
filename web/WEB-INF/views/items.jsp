<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${type == 'all'}">Kết quả tìm kiếm</c:when>
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
                    <c:when test="${type == 'all'}">Kết quả tìm kiếm</c:when>
                    <c:when test="${type == 'found'}">Tất cả đồ nhặt được</c:when>
                    <c:otherwise>Tất cả đồ báo mất</c:otherwise>
                </c:choose>
            </h1>
            <p class="lf-page-header__sub">
                <c:choose>
                    <c:when test="${type == 'all'}">Hiển thị cả đồ nhặt được và đồ báo mất, ưu tiên đồ nhặt được.</c:when>
                    <c:when test="${type == 'found'}">Danh sách đầy đủ các tin đồ nhặt được trong hệ thống.</c:when>
                    <c:otherwise>Danh sách đầy đủ các tin đồ báo mất trong hệ thống.</c:otherwise>
                </c:choose>
            </p>
        </div>

        <div class="flex gap-lg" style="align-items:flex-start;">
            <!-- Bộ lọc (sidebar ~30%) -->
            <aside class="lf-card" style="flex:0 0 320px; max-width:360px; padding:24px; border:1px solid #e5e7eb; border-radius:12px; box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);">
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
                        <div class="lf-filter-select-container" style="width: 100%;">
                            <select id="locationId" name="locationId" class="lf-filter-select" style="width: 100%;" onchange="this.form.submit()">
                                <option value="">Khu vực</option>
                                <c:forEach var="l" items="${locations}">
                                    <option value="${l.locationId}" ${selectedLocationId == l.locationId ? 'selected' : ''}>
                                        ${l.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="lf-filter-select-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            </div>
                        </div>
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
                                <div class="lf-item-card ${type == 'found' ? 'border-found' : 'border-lost'}">
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
                                                <div class="lf-item-card__thumb-placeholder">
                                                    <c:choose>
                                                        <c:when test="${type == 'found'}">🟢</c:when>
                                                        <c:otherwise>📦</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </a>
                                        </c:if>
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

                        <!-- Paging Navigation -->
                        <c:if test="${totalPages > 1}">
                            <div class="lf-pagination" style="display:flex; justify-content:center; gap:16px; margin-top:40px; margin-bottom:20px;">
                                <c:if test="${currentPage > 1}">
                                    <a href="?type=${type}&search=${searchKeyword}&categoryId=${selectedCategoryId}&locationId=${selectedLocationId}&page=${currentPage - 1}" class="lf-page-btn" style="border:1.5px solid #fd7e14; border-radius:8px; padding:10px 24px; color:#fd7e14; text-decoration:none; font-weight:600; font-size:0.95rem; display:inline-flex; align-items:center; gap:8px; cursor:pointer;">
                                        &lt; Trước
                                    </a>
                                </c:if>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?type=${type}&search=${searchKeyword}&categoryId=${selectedCategoryId}&locationId=${selectedLocationId}&page=${currentPage + 1}" class="lf-page-btn" style="border:1.5px solid #fd7e14; border-radius:8px; padding:10px 24px; color:#fd7e14; text-decoration:none; font-weight:600; font-size:0.95rem; display:inline-flex; align-items:center; gap:8px; cursor:pointer;">
                                        Tiếp &gt;
                                    </a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <lf:emptyState title="Chưa có tin nào." sub="Hãy quay lại sau hoặc đăng tin mới nhé!"/>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>

    <lf:footer />
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>


