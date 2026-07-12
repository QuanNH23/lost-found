<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gửi yêu cầu hỗ trợ | Lost & Found</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --clr-primary: #fd7e14;
            --clr-primary-hover: #e06d0f;
            --clr-bg: #f8fafc;
            --clr-card-bg: #ffffff;
            --clr-border: #e2e8f0;
            --txt-primary: #0f172a;
            --txt-muted: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--clr-bg);
            color: var(--txt-primary);
            margin: 0;
            padding: 0;
        }

        .support-container {
            max-width: 680px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .support-card {
            background-color: var(--clr-card-bg);
            border: 1px solid var(--clr-border);
            border-radius: 16px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);
            padding: 40px;
        }

        .support-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--txt-primary);
            margin-bottom: 8px;
            text-align: center;
        }

        .support-subtitle {
            color: var(--txt-muted);
            font-size: 0.95rem;
            margin-bottom: 32px;
            text-align: center;
        }

        .form-label {
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .form-control, .form-select {
            border: 1px solid var(--clr-border);
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 0.95rem;
            transition: all 0.2s ease-in-out;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--clr-primary);
            box-shadow: 0 0 0 3px rgba(253, 126, 20, 0.15);
        }

        .btn-submit {
            background-color: var(--clr-primary);
            border: none;
            color: white;
            padding: 14px 28px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 8px;
            width: 100%;
            transition: background-color 0.2s;
            margin-top: 16px;
        }

        .btn-submit:hover {
            background-color: var(--clr-primary-hover);
        }

        /* Modern Modal Confirmation Styles */
        .lf-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.25s ease-out;
        }

        .lf-modal-overlay.open {
            opacity: 1;
            pointer-events: auto;
        }

        .lf-modal {
            background: white;
            border-radius: 16px;
            width: 100%;
            max-width: 500px;
            padding: 32px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
            transform: scale(0.9);
            transition: transform 0.25s ease-out;
        }

        .lf-modal-overlay.open .lf-modal {
            transform: scale(1);
        }

        .lf-modal__title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: var(--txt-primary);
        }

        .confirm-field {
            margin-bottom: 12px;
            font-size: 0.95rem;
        }

        .confirm-field strong {
            color: var(--txt-muted);
            display: inline-block;
            width: 130px;
        }

        .confirm-field span {
            color: var(--txt-primary);
            font-weight: 500;
        }
    </style>
</head>
<body>

<div class="support-container">
    <div class="support-card">
        <h2 class="support-title">💌 Hỗ trợ & Giải đáp</h2>
        <p class="support-subtitle">Gửi yêu cầu trợ giúp đến ban quản trị để giải quyết các vấn đề tài khoản, bài đăng hoặc lỗi hệ thống.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-4" role="alert">
                ⚠️ ${error}
            </div>
        </c:if>

        <form id="supportForm" action="${pageContext.request.contextPath}/support" method="POST">
            <div class="mb-4">
                <label for="reason" class="form-label">Lý do hỗ trợ</label>
                <select id="reason" name="reason" class="form-select" required>
                    <option value="Xác thực tài khoản">Xác thực tài khoản</option>
                    <option value="Xử lý vấn đề">Xử lý vấn đề</option>
                    <option value="Web lỗi">Web lỗi</option>
                    <option value="Khác">Khác</option>
                </select>
            </div>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <label for="email" class="form-label">Địa chỉ Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="example@gmail.com">
                </div>
                <div class="col-md-6 mb-4">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="text" id="phone" name="phone" class="form-control" placeholder="09xxxxxxx">
                </div>
            </div>
            <div class="text-sm text-muted mb-4" style="margin-top: -12px; font-size: 0.85rem;">
                * Bắt buộc phải điền ít nhất Email hoặc Số điện thoại để Admin có thể phản hồi cho bạn.
            </div>

            <div class="mb-4">
                <label for="imageUrl" class="form-label">Link ảnh minh họa (Nếu có)</label>
                <input type="url" id="imageUrl" name="imageUrl" class="form-control" placeholder="https://example.com/image.jpg">
            </div>

            <div class="mb-4">
                <label for="description" class="form-label">Nội dung mô tả chi tiết</label>
                <textarea id="description" name="description" rows="5" class="form-control" placeholder="Vui lòng trình bày rõ vấn đề cần hỗ trợ..." required></textarea>
            </div>

            <button type="button" onclick="showConfirm()" class="btn btn-submit">Gửi yêu cầu hỗ trợ</button>
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/home" style="color:var(--txt-muted); text-decoration:none; font-size:0.9rem;">&larr; Quay về trang chủ</a>
            </div>
        </form>
    </div>
</div>

<!-- Support Confirmation Modal -->
<div class="lf-modal-overlay" id="confirmModal">
    <div class="lf-modal">
        <h3 class="lf-modal__title">🔍 Xác nhận thông tin gửi hỗ trợ</h3>
        
        <div class="confirm-field">
            <strong>Lý do:</strong>
            <span id="cReason"></span>
        </div>
        <div class="confirm-field">
            <strong>Email:</strong>
            <span id="cEmail">--</span>
        </div>
        <div class="confirm-field">
            <strong>Số điện thoại:</strong>
            <span id="cPhone">--</span>
        </div>
        <div class="confirm-field">
            <strong>Ảnh đính kèm:</strong>
            <span id="cImage">Không có</span>
        </div>
        <div class="confirm-field" style="margin-top:16px;">
            <strong style="display:block; margin-bottom:4px;">Nội dung mô tả:</strong>
            <div id="cDesc" style="background:#f1f5f9; padding:12px; border-radius:8px; font-size:0.9rem; max-height:150px; overflow-y:auto; color:#334155;"></div>
        </div>

        <div class="d-flex gap-3 mt-4">
            <button type="button" class="btn btn-secondary w-50" style="background:#e2e8f0; color:#334155; border:none;" onclick="closeConfirm()">Hủy sửa lại</button>
            <button type="button" class="btn w-50" style="background:var(--clr-primary); color:white; border:none;" onclick="submitForm()">Xác nhận gửi</button>
        </div>
    </div>
</div>

<script>
    function showConfirm() {
        const reason = document.getElementById('reason').value;
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const imageUrl = document.getElementById('imageUrl').value.trim();
        const description = document.getElementById('description').value.trim();

        if (!email && !phone) {
            alert('Bạn bắt buộc phải nhập ít nhất Email hoặc Số điện thoại để nhận phản hồi!');
            return;
        }

        if (!description) {
            alert('Vui lòng điền nội dung mô tả chi tiết!');
            return;
        }

        // Fill modal fields
        document.getElementById('cReason').innerText = reason;
        document.getElementById('cEmail').innerText = email ? email : 'Chưa điền';
        document.getElementById('cPhone').innerText = phone ? phone : 'Chưa điền';
        document.getElementById('cImage').innerText = imageUrl ? imageUrl : 'Không có';
        document.getElementById('cDesc').innerText = description;

        document.getElementById('confirmModal').classList.add('open');
    }

    function closeConfirm() {
        document.getElementById('confirmModal').classList.remove('open');
    }

    function submitForm() {
        document.getElementById('supportForm').submit();
    }
</script>
</body>
</html>
