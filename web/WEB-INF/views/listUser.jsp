<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script>
        function doDelete(id) {
            if (confirm("Bạn chắc chắn muốn xóa người dùng ID = " + id + "?")) {
                window.location = "${pageContext.request.contextPath}/deleteuser?id=" + id;
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
                <li><a href="${pageContext.request.contextPath}/home" class="lf-navbar__link">🏠 Home</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_users" class="lf-navbar__link active">👥 Users</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_categories" class="lf-navbar__link">🏷️ Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_locations" class="lf-navbar__link">📍 Vị trí</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_items" class="lf-navbar__link">📦 Items</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_claims" class="lf-navbar__link">📋 Claims</a></li>
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
            <h1 class="lf-page-header__title">👥 Quản lý Người dùng</h1>
            <p class="lf-page-header__sub">Xem và quản lý tất cả tài khoản trong hệ thống</p>
        </div>

        <c:if test="${not empty requestScope.success}">
            <div class="lf-alert lf-alert-success mb-md">
                <span class="lf-alert__icon">✅</span><span>${requestScope.success}</span>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="lf-alert lf-alert-error mb-md">
                <span class="lf-alert__icon">❌</span><span>${requestScope.error}</span>
            </div>
        </c:if>

        <div class="lf-table-wrap">
            <table class="lf-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>SĐT</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.data}" var="c">
                        <c:set var="id" value="${c.userId}"/>
                        <tr>
                            <td><span class="badge badge-muted">#${id}</span></td>
                            <td class="fw-bold">${c.username}</td>
                            <td>${c.fullName}</td>
                            <td class="text-sm" style="color: white;">${c.email}</td>
                            <td class="text-sm">${c.phoneNumber}</td>
                            <td>
                                <lf:roleBadge role="${c.role}"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.isActive}"><span class="badge badge-success">✅ Active</span></c:when>
                                    <c:otherwise><span class="badge badge-muted">🔒 Inactive</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-sm" style="color: white;">${c.createdAt}</td>
                            <td>
                                <div class="flex gap-sm">
                                    <a href="${pageContext.request.contextPath}/updateuser?id=${id}" class="btn btn-secondary btn-sm">✏️ Sửa</a>
                                    <button type="button" onclick="doDelete('${id}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requestScope.data}">
                        <tr><td colspan="9" class="td-empty">Chưa có người dùng nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
    <lf:footer />
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>

