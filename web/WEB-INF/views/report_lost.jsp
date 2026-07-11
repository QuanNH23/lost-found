<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty formTitle ? 'Đăng tin báo Mất đồ' : formTitle} — Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">
    <!-- ── NAVBAR ── -->
    <lf:navbar activeMenu="report_lost" />

    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="sep">›</span>
            <span class="current">${empty formTitle ? 'Đăng tin báo Mất đồ' : formTitle}</span>
        </div>

        <div class="lf-page-header">
            <h1 class="lf-page-header__title">
                ${empty formTitle ? 'Đăng tin báo Mất đồ' : formTitle}
            </h1>
            <p class="lf-page-header__sub">Điền đầy đủ thông tin để hệ thống có thể hỗ trợ bạn tốt nhất</p>
        </div>

        <c:if test="${not empty ERROR}">
            <div class="lf-alert lf-alert-error mb-md" style="max-width:720px; margin: 0 auto;">
                <span class="lf-alert__icon">❌</span><span>${ERROR}</span>
            </div>
        </c:if>

        <div class="lf-card" style="max-width:720px; margin: 0 auto;">
            <form action="${pageContext.request.contextPath}/report_lost" method="post"
                  enctype="multipart/form-data" class="lf-form" novalidate>
                <input type="hidden" name="report_type" value="${empty reportType ? 'lost' : reportType}">

                <div class="lf-form-group">
                    <label class="lf-label" for="title">Tiêu đề đồ vật <span class="req">*</span></label>
                    <input type="text" id="title" name="title" class="lf-input"
                           value="${oldTitle}" required
                           placeholder="Vd: Ví da màu đen, Điện thoại iPhone 14...">
                </div>

                <div class="lf-form-group">
                    <label class="lf-label" for="description">Mô tả chi tiết <span class="req">*</span></label>
                    <textarea id="description" name="description" class="lf-textarea" required
                              placeholder="Mô tả đặc điểm nhận dạng, màu sắc, nhãn hiệu...">${oldDescription}</textarea>
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
                        <label class="lf-label" for="location_id">
                            ${empty locationLabel ? 'Vị trí' : locationLabel} <span class="req">*</span>
                        </label>
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
                    <label class="lf-label" for="date_incident">
                        ${empty dateLabel ? 'Thời điểm xảy ra' : dateLabel} <span class="req">*</span>
                    </label>
                    <input type="datetime-local" id="date_incident" name="date_incident"
                           class="lf-input" value="${oldDateIncident}" required>
                </div>

                <div class="lf-form-group">
                    <label class="lf-label">Hình ảnh (tùy chọn)</label>
                    <div class="lf-file-wrap" onclick="document.getElementById('images').click()">
                        <input type="file" id="images" name="images" accept="image/*" multiple
                               style="position:absolute;width:1px;height:1px;opacity:0;">
                        <div class="lf-file-icon">🖼️</div>
                        <div class="lf-file-text">Nhấn để chọn ảnh</div>
                        <div class="lf-file-hint">Mỗi ảnh tối đa 5MB • JPG, PNG, WEBP</div>
                    </div>
                </div>

                <div class="flex gap-md" style="margin-top:8px;">
                    <button type="submit" class="btn btn-vibrant btn-lg">
                        📤 ${empty submitLabel ? 'Gửi báo mất' : submitLabel}
                    </button>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-ghost btn-lg">← Quay lại</a>
                </div>
            </form>
        </div>
    </main>
    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    // File input label update
    document.getElementById('images').addEventListener('change', function() {
        var text = this.closest('.lf-file-wrap').querySelector('.lf-file-text');
        if (this.files.length > 0) {
            text.textContent = 'Đã chọn: ' + Array.from(this.files).map(f => f.name).join(', ');
        }
    });
</script>
</body>
</html>
