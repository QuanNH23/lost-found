<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Claims — Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script>
        function doDelete(id) {
            if (confirm("Bạn chắc chắn muốn xóa claim ID = " + id + "?")) {
                window.location = "deleteclaim?id=" + id;
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
                <li><a href="${pageContext.request.contextPath}/manage_items"      class="lf-navbar__link">📦 Items</a></li>
                <li><a href="${pageContext.request.contextPath}/manage_claims"     class="lf-navbar__link active">📋 Claims</a></li>
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
            <h1 class="lf-page-header__title">📋 Quản lý Yêu cầu (Claims)</h1>
            <p class="lf-page-header__sub">Xem và xử lý tất cả các yêu cầu nhận lại đồ</p>
        </div>

        <div class="lf-table-wrap">
            <table class="lf-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Item ID</th>
                        <th>Claimer ID</th>
                        <th>Trạng thái</th>
                        <th>Mô tả bằng chứng</th>
                        <th>Phản hồi</th>
                        <th>Xử lý bởi</th>
                        <th>Ngày tạo</th>
                        <th>Cập nhật</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.data}" var="c">
                        <c:set var="id" value="${c.claimId}"/>
                        <tr>
                            <td><span class="badge badge-muted">#${id}</span></td>
                            <td><span class="badge badge-primary">#${c.itemId}</span></td>
                            <td class="text-sm" style="color: white;">${c.claimerId}</td>
                            <td>
                                <lf:statusBadge status="${c.status}"/>
                            </td>
                            <td class="text-sm">${c.proofDescription}</td>
                            <td class="text-sm">${c.responseMessage}</td>
                            <td class="text-sm" style="color: white;">${c.respondedBy}</td>
                            <td class="text-sm" style="color: white;">${c.createdAt}</td>
                            <td class="text-sm" style="color: white;">${c.updatedAt}</td>
                            <td>
                                <button onclick="doDelete('${id}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requestScope.data}">
                        <tr><td colspan="10" class="td-empty">Chưa có yêu cầu nào.</td></tr>
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

