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
                <div class="lf-form-group">
                    <label class="lf-label">Loại tin <span class="req">*</span></label>
                    <div style="display:flex; gap:24px; align-items:center; margin-top:8px; margin-bottom:16px;">
                        <label style="display:flex; align-items:center; gap:8px; cursor:pointer; font-weight:500; color:var(--txt-primary);">
                            <input type="radio" name="report_type" value="lost" ${empty reportType or reportType eq 'lost' ? 'checked' : ''} style="width:18px; height:18px; accent-color:var(--clr-danger);">
                            Tìm đồ (Báo mất)
                        </label>
                        <label style="display:flex; align-items:center; gap:8px; cursor:pointer; font-weight:500; color:var(--txt-primary);">
                            <input type="radio" name="report_type" value="found" ${reportType eq 'found' ? 'checked' : ''} style="width:18px; height:18px; accent-color:var(--clr-green);">
                            Nhặt được (Báo nhặt)
                        </label>
                    </div>
                </div>

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

                <div class="lf-form-group">
                    <label class="lf-label" for="phone">Số điện thoại liên hệ <span class="req">*</span></label>
                    <input type="text" id="phone" name="phone" class="lf-input" required
                           value="${sessionScope.currentUser.phoneNumber}" readonly style="background-color: #f3f4f6; cursor: not-allowed;" maxlength="10">
                    <span id="phoneError" style="color: #ef4444; font-size: 0.85rem; margin-top: 4px; display: none; font-weight: 500;">⚠️ Số điện thoại liên hệ phải bắt đầu bằng số 0!</span>
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
                    <label class="lf-label" for="location_details">Địa Điểm Rơi/Thất Lạc/ Nhận Được :</label>
                    <input type="text" id="location_details" name="location_details" class="lf-input"
                           value="${oldLocationDetails}" placeholder="Nhập chi tiết địa điểm cụ thể (Vd: Bàn số 3, tầng 1...)">
                </div>

                <div class="lf-form-group">
                    <label class="lf-label" for="date_incident">
                        ${empty dateLabel ? 'Thời điểm xảy ra' : dateLabel} <span class="req">*</span>
                    </label>
                    <input type="datetime-local" id="date_incident" name="date_incident"
                           class="lf-input" value="${oldDateIncident}" required
                           oninput="if(this.value && this.value.length >= 16) this.blur();">
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
    <lf:footer />
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    document.getElementById('images').addEventListener('change', function() {
        const wrap = this.closest('.lf-file-wrap');
        if (!wrap) return;
        const icon = wrap.querySelector('.lf-file-icon');
        const text = wrap.querySelector('.lf-file-text');
        
        let previewDiv = wrap.querySelector('.lf-file-preview-grid');
        if (previewDiv) previewDiv.remove();

        if (this.files.length > 5) {
            alert("Bạn chỉ được chọn tối đa 5 hình ảnh cho mỗi bài viết.");
            this.value = '';
            if (text) text.textContent = 'Nhấn để chọn ảnh';
            if (icon) icon.style.display = 'block';
            return;
        }

        if (this.files.length > 0) {
            const names = Array.from(this.files).map(f => f.name).join(', ');
            if (text) text.textContent = 'Đã chọn: ' + names;
            if (icon) icon.style.display = 'none';

            previewDiv = document.createElement('div');
            previewDiv.className = 'lf-file-preview-grid';
            previewDiv.style.cssText = 'display:flex; justify-content:center; gap:8px; margin-bottom:12px; flex-wrap:wrap;';

            Array.from(this.files).forEach(file => {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.style.cssText = 'width:80px; height:80px; object-fit:cover; border-radius:6px; border:1px solid #d1d5db;';
                    previewDiv.appendChild(img);
                };
                reader.readAsDataURL(file);
            });

            wrap.insertBefore(previewDiv, text);
        } else {
            if (text) text.textContent = 'Nhấn để chọn ảnh';
            if (icon) icon.style.display = 'block';
        }
    });

    // Phone validation
    const phoneInput = document.getElementById('phone');
    const phoneError = document.getElementById('phoneError');
    if (phoneInput && phoneError) {
        phoneInput.addEventListener('input', function() {
            // Keep only numbers
            this.value = this.value.replace(/[^0-9]/g, '');

            if (this.value.length > 0 && this.value[0] !== '0') {
                phoneError.textContent = '⚠️ Số điện thoại liên hệ phải bắt đầu bằng số 0!';
                phoneError.style.display = 'block';
            } else {
                phoneError.style.display = 'none';
            }
        });

        const form = phoneInput.closest('form');
        form.addEventListener('submit', function(e) {
            if (phoneInput.value.length !== 10 || phoneInput.value[0] !== '0') {
                e.preventDefault();
                phoneError.textContent = '⚠️ Số điện thoại liên hệ phải bắt đầu bằng số 0 và gồm đúng 10 chữ số!';
                phoneError.style.display = 'block';
                phoneInput.focus();
            }
        });
    }
</script>
</body>
</html>
