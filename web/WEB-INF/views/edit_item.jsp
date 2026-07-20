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
            <div class="lf-alert lf-alert-error mb-md" style="max-width:1140px; margin: 0 auto;">
                <span class="lf-alert__icon">❌</span><span>${ERROR}</span>
            </div>
        </c:if>

        <div style="display:flex; gap:32px; max-width:1140px; margin:0 auto; align-items:flex-start; flex-wrap:wrap;">
            <!-- Left Form Column -->
            <div class="lf-card" style="flex:1 1 650px; margin: 0;">
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

                <div class="lf-form-group">
                    <label class="lf-label" for="phone">Số điện thoại liên hệ <span class="req">*</span></label>
                    <input type="text" id="phone" name="phone" class="lf-input" required
                           value="${oldPhone}" readonly style="background-color: #f3f4f6; cursor: not-allowed;" maxlength="10">
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
                    <label class="lf-label" for="location_details">Địa Điểm Rơi/Thất Lạc/ Nhận Được :</label>
                    <input type="text" id="location_details" name="location_details" class="lf-input"
                           value="${oldLocationDetails}" placeholder="Nhập chi tiết địa điểm cụ thể (Vd: Bàn số 3, tầng 1...)">
                </div>

                <div class="lf-form-group">
                    <label class="lf-label" for="date_incident">Thời điểm <span class="req">*</span></label>
                    <input type="datetime-local" id="date_incident" name="date_incident"
                           class="lf-input" value="${oldDateIncident}" required
                           oninput="if(this.value && this.value.length >= 16) this.blur();">
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

        <!-- Right Instruction Column -->
        <div style="flex:0 0 350px; width:350px; background:#f0f7ff; border:1px solid #bfdbfe; border-radius:12px; padding:24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); font-family:'Inter', sans-serif;">
            <h3 style="font-size:1.25rem; font-weight:800; color:#1e3a8a; margin-top:0; margin-bottom:20px; border-bottom:2px solid #dbeafe; padding-bottom:10px;">Hướng dẫn</h3>
            
            <div style="display:flex; flex-direction:column; gap:16px; font-size:0.9rem; color:#1e40af; line-height:1.5;">
                <div>
                    <strong style="color:#1e3a8a;">Tiêu đề:</strong> Nhập tiêu đề ngắn gọn, thể hiện rõ ràng mục đích
                    <div style="font-size:0.8rem; font-style:italic; color:#3b82f6; margin-top:4px;">*VD: Rơi ví, giấy tờ tuỳ thân mang tên Nguyễn Văn A 1996 rơi ở Cầu Giấy, Hà Nội</div>
                </div>
                
                <div style="border-top:1px solid #dbeafe; padding-top:12px;">
                    <strong style="color:#1e3a8a;">Loại tin:</strong> Chọn loại tin đang thực hiện
                </div>
                
                <div style="border-top:1px solid #dbeafe; padding-top:12px;">
                    <strong style="color:#1e3a8a;">Danh mục:</strong> Lựa chọn danh mục đồ vật bị mất hoặc nhặt được
                </div>
                
                <div style="border-top:1px solid #dbeafe; padding-top:12px;">
                    <strong style="color:#1e3a8a;">Khu vực:</strong> Chọn khu vực rơi đồ hoặc nhặt được,
                    <div style="font-size:0.8rem; font-style:italic; color:#3b82f6; margin-top:4px;">*Càng chỉ định khu vực chi tiết thì người khác sẽ tìm thấy bài đăng này nhanh hơn.</div>
                </div>
                
                <div style="border-top:1px solid #dbeafe; padding-top:12px;">
                    <strong style="color:#1e3a8a;">Ảnh đại diện bài đăng:</strong> Chụp ảnh đồ vật bị mất hoặc nhặt được
                    <div style="font-size:0.8rem; font-style:italic; color:#3b82f6; margin-top:4px;">*Lưu ý: Để đảm bảo bảo mật thông tin cá nhân, tất cả ảnh tải lên phải che các mã số (VD: Căn cước công dân phải làm mờ Mã số CCCD và làm mờ ảnh trên CCCD), nếu ảnh tải lên không đảm bảo yếu tố bảo mật thì tin sẽ không được phê duyệt</div>
                </div>
            </div>
            
            <div style="text-align:center; font-weight:700; color:#2563eb; margin-top:24px; border-top:2px solid #dbeafe; padding-top:16px;">
                Chúc bạn may mắn!
            </div>
        </div>
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

