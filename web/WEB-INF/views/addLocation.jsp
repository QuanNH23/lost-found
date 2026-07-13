<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Vị trí — Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">
    <nav class="lf-navbar">
        <div class="lf-navbar__inner">
            <a href="${pageContext.request.contextPath}/home" class="lf-navbar__brand">
                <div class="lf-navbar__logo">🔍</div>
                <span class="lf-navbar__title">Lost &amp; Found</span>
            </a>
            <div class="lf-navbar__user">
                <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                             role="${sessionScope.userRole}"
                             contextPath="${pageContext.request.contextPath}"/>
            </div>
        </div>
    </nav>
    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/data_management?tab=locations">📍 Vị trí</a>
            <span class="sep">›</span><span class="current">Thêm mới</span>
        </div>
        <div class="lf-page-header">
            <h1 class="lf-page-header__title">➕ Thêm Vị trí mới</h1>
        </div>
        <c:if test="${not empty requestScope.error}">
            <div class="lf-alert lf-alert-error mb-md">
                <span class="lf-alert__icon">❌</span><span>${requestScope.error}</span>
            </div>
        </c:if>
        <div class="lf-card" style="max-width:500px;">
            <form action="${pageContext.request.contextPath}/addlocations" method="post" class="lf-form">
                <div class="lf-form-group">
                    <label class="lf-label" for="name">Tên vị trí <span class="req">*</span></label>
                    <input type="text" id="name" name="name" class="lf-input"
                           value="${requestScope.oldName}" required placeholder="Vd: Thư viện, Sân A...">
                </div>
                <div class="flex gap-md">
                    <button type="submit" class="btn btn-primary">💾 Lưu</button>
                    <a href="${pageContext.request.contextPath}/admin/data_management?tab=locations" class="btn btn-ghost">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>
    <lf:footer />
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>

