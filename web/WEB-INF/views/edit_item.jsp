<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa bài đăng — Lost &amp; Found</title>
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
            <button class="lf-navbar__toggle" id="navToggle" aria-label="Menu">☰</button>
            <ul class="lf-navbar__nav" id="mainNav">
                <li><a href="${pageContext.request.contextPath}/home"     class="lf-navbar__link">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/my_items" class="lf-navbar__link">Tin của tôi</a></li>
            </ul>
            <div class="lf-navbar__user">
                <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                             role="${sessionScope.userRole}"
                             contextPath="${pageContext.request.contextPath}"/>
            </div>
        </div>
    </nav>

    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="sep">›</span>
            <a href="${pageContext.request.contextPath}/my_items">Tin của tôi</a>
            <span class="sep">›</span>
            <span class="current">Sửa bài đăng</span>
        </div>

        <div class="lf-page-header">
            <h1 class="lf-page-header__title">Sửa bài đăng</h1>
            <p class="lf-page-header__sub">Cập nhật thông tin cho bài đăng của bạn</p>
        </div>

        <c:if test="${not empty ERROR}">
            <div class="lf-alert lf-alert-error mb-md">
                <span class="lf-alert__icon">❌</span><span>${ERROR}</span>
            </div>
        </c:if>

        <div class="lf-card" style="max-width:680px;">
            <form action="${pageContext.request.contextPath}/edit_item" method="post"
                  enctype="multipart/form-data" class="lf-form" novalidate>
                <input type="hidden" name="item_id" value="${itemId}">

                <div class="lf-form-group">
                    <label class="lf-label" for="title">Tiêu đề đồ vật <span class="req">*</span></label>
                    <input type="text" id="title" name="title" class="lf-input"
                           value="${oldTitle}" required placeholder="Tên đồ vật...">
                </div>

                <div class="lf-form-group">
                    <label class="lf-label" for="description">Mô tả <span class="req">*</span></label>
                    <textarea id="description" name="description" class="lf-textarea" required>${oldDescription}</textarea>
                </div>

                <div class="lf-form-row">
                    <div class="lf-form-group">
                        <label class="lf-label" for="category_id">Danh mục <span class="req">*</span></label>
                        <select id="category_id" name="category_id" class="lf-select" required>
                            <option value="">— Chọn danh mục —</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${oldCategoryId == c.categoryId ? 'selected' : ''}>
                                    ${c.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="lf-form-group">
                        <label class="lf-label" for="location_id">Vị trí <span class="req">*</span></label>
                        <select id="location_id" name="location_id" class="lf-select" required>
                            <option value="">— Chọn vị trí —</option>
                            <c:forEach var="l" items="${locations}">
                                <option value="${l.locationId}" ${oldLocationId == l.locationId ? 'selected' : ''}>
                                    ${l.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="lf-form-group">
                    <label class="lf-label" for="date_incident">Thời điểm <span class="req">*</span></label>
                    <input type="datetime-local" id="date_incident" name="date_incident"
                           class="lf-input" value="${oldDateIncident}" required>
                </div>

                <!-- Existing Images -->
                <c:if test="${not empty existingImagePaths}">
                    <div class="lf-form-group">
                        <label class="lf-label">Hình ảnh hiện tại</label>
                        <div class="lf-item-images">
                            <c:forEach var="imgPath" items="${existingImagePaths}">
                                <img src="${pageContext.request.contextPath}/${imgPath}" alt="Hình ảnh" width="120">
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <div class="lf-form-group">
                    <label class="lf-label">Upload hình mới (tùy chọn)</label>
                    <div class="lf-file-wrap" onclick="document.getElementById('images').click()">
                        <input type="file" id="images" name="images" accept="image/*" multiple
                               style="position:absolute;width:1px;height:1px;opacity:0;">
                        <div class="lf-file-icon">🖼️</div>
                        <div class="lf-file-text">Nhấn để chọn ảnh mới</div>
                        <div class="lf-file-hint">⚠️ Chọn ảnh mới sẽ thay thế toàn bộ ảnh cũ</div>
                    </div>
                </div>

                <div class="flex gap-md" style="margin-top:8px;">
                    <button type="submit" class="btn btn-primary btn-lg">💾 Lưu cập nhật</button>
                    <a href="${pageContext.request.contextPath}/my_items" class="btn btn-ghost btn-lg">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>
    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    document.getElementById('images').addEventListener('change', function() {
        var text = this.closest('.lf-file-wrap').querySelector('.lf-file-text');
        if (this.files.length > 0) {
            text.textContent = 'Đã chọn: ' + Array.from(this.files).map(f => f.name).join(', ');
        }
    });
</script>
</body>
</html>
