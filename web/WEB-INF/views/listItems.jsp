<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Vật phẩm — Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script>
        function doDelete(id) {
            if (confirm("Bạn chắc chắn muốn xóa item ID = " + id + "?")) {
                window.location = "deleteitem?id=" + id;
            }
        }
    </script>
</head>
<body>
<div class="lf-wrapper">
    <nav class="lf-navbar">
        <div class="lf-navbar__inner">
            <a href="${pageContext.request.contextPath}/home" class="lf-navbar__brand">
                <div class="lf-navbar__logo">🔍</div>
                <span class="lf-navbar__title">Lost &amp; Found</span>
            </a>
            <button class="lf-navbar__toggle" id="navToggle" aria-label="Menu">☰</button>
            <ul class="lf-navbar__nav" id="mainNav">
                <li><a href="${pageContext.request.contextPath}/home"             class="lf-navbar__link">🏠 Home</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_users"      class="lf-navbar__link">👥 Users</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_categories" class="lf-navbar__link">🏷️ Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_locations"  class="lf-navbar__link">📍 Vị trí</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_items"      class="lf-navbar__link active">📦 Items</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_claims"     class="lf-navbar__link">📋 Claims</a></li>
            </ul>
            <div class="lf-navbar__user">
                <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                             role="${sessionScope.userRole}"
                             contextPath="${pageContext.request.contextPath}"/>
            </div>
        </div>
    </nav>

    <main class="lf-main">
        <div class="lf-admin-header">
            <div class="lf-admin-badge">⚙️ Admin Panel</div>
            <h1 class="lf-page-header__title">📦 Quản lý Vật phẩm</h1>
            <p class="lf-page-header__sub">Danh sách vật phẩm đã được tách riêng thành đồ báo mất và đồ nhặt được để quản lý dễ hơn.</p>
        </div>

        <div class="lf-stats mb-lg">
            <div class="lf-stat">
                <div class="lf-stat__icon">📦</div>
                <div>
                    <div class="lf-stat__val">${totalCount}</div>
                    <div class="lf-stat__label">Tổng vật phẩm</div>
                </div>
            </div>
            <div class="lf-stat">
                <div class="lf-stat__icon danger">🔴</div>
                <div>
                    <div class="lf-stat__val">${lostCount}</div>
                    <div class="lf-stat__label">Đồ báo mất</div>
                </div>
            </div>
            <div class="lf-stat">
                <div class="lf-stat__icon success">🟢</div>
                <div>
                    <div class="lf-stat__val">${foundCount}</div>
                    <div class="lf-stat__label">Đồ nhặt được</div>
                </div>
            </div>
        </div>

        <div class="lf-card mb-lg">
            <div class="flex flex-between flex-center-y mb-md">
                <div class="lf-section-title">
                    <span class="dot"></span> Danh sách đồ báo mất
                </div>
                <span class="badge badge-danger">${lostCount} mục</span>
            </div>

            <c:choose>
                <c:when test="${not empty lostItems}">
                    <div class="lf-table-wrap">
                        <table class="lf-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tiêu đề</th>
                                    <th>Trạng thái</th>
                                    <th>User ID</th>
                                    <th>Cat ID</th>
                                    <th>Loc ID</th>
                                    <th>Ngày xảy ra</th>
                                    <th>Ngày tạo</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${lostItems}" var="i">
                                    <c:set var="id" value="${i.itemId}"/>
                                    <tr>
                                        <td><span class="badge badge-muted">#${id}</span></td>
                                        <td class="fw-bold">${i.title}</td>
                                        <td><lf:statusBadge status="${i.status}"/></td>
                                        <td class="text-sm" style="color: white;">${i.userId}</td>
                                        <td class="text-sm" style="color: white;">${i.categoryId}</td>
                                        <td class="text-sm" style="color: white;">${i.locationId}</td>
                                        <td class="text-sm" style="color: white;">${i.dateIncident}</td>
                                        <td class="text-sm" style="color: white;">${i.createdAt}</td>
                                        <td>
                                            <div class="flex gap-sm">
                                                <a href="${pageContext.request.contextPath}/item_detail?id=${id}" class="btn btn-secondary btn-sm">🔍 Xem chi tiết</a>
                                                <button onclick="doDelete('${id}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <lf:emptyState title="Chưa có đồ báo mất nào" sub="Khi có bài báo mất mới, danh sách này sẽ hiển thị tại đây."/>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="lf-card">
            <div class="flex flex-between flex-center-y mb-md">
                <div class="lf-section-title">
                    <span class="dot"></span> Danh sách đồ nhặt được
                </div>
                <span class="badge badge-success">${foundCount} mục</span>
            </div>

            <c:choose>
                <c:when test="${not empty foundItems}">
                    <div class="lf-table-wrap">
                        <table class="lf-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tiêu đề</th>
                                    <th>Trạng thái</th>
                                    <th>User ID</th>
                                    <th>Cat ID</th>
                                    <th>Loc ID</th>
                                    <th>Ngày xảy ra</th>
                                    <th>Ngày tạo</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${foundItems}" var="i">
                                    <c:set var="id" value="${i.itemId}"/>
                                    <tr>
                                        <td><span class="badge badge-muted">#${id}</span></td>
                                        <td class="fw-bold">${i.title}</td>
                                        <td><lf:statusBadge status="${i.status}"/></td>
                                        <td class="text-sm" style="color: white;">${i.userId}</td>
                                        <td class="text-sm" style="color: white;">${i.categoryId}</td>
                                        <td class="text-sm" style="color: white;">${i.locationId}</td>
                                        <td class="text-sm" style="color: white;">${i.dateIncident}</td>
                                        <td class="text-sm" style="color: white;">${i.createdAt}</td>
                                        <td>
                                            <div class="flex gap-sm">
                                                <a href="${pageContext.request.contextPath}/item_detail?id=${id}" class="btn btn-secondary btn-sm">🔍 Xem chi tiết</a>
                                                <button onclick="doDelete('${id}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <lf:emptyState title="Chưa có đồ nhặt được nào" sub="Khi có bài báo nhặt được mới, danh sách này sẽ hiển thị tại đây."/>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost &amp; Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
