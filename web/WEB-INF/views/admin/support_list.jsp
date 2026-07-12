<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý yêu cầu hỗ trợ | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --clr-primary: #fd7e14;
            --clr-success: #10b981;
            --clr-danger: #ef4444;
            --clr-warning: #f59e0b;
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

        /* Navbar Layout */
        .lf-header {
            background-color: white;
            border-bottom: 1px solid var(--clr-border);
            padding: 14px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .admin-card {
            background: white;
            border: 1px solid var(--clr-border);
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            padding: 24px;
        }

        .lf-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }

        .lf-table th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
            text-align: left;
            padding: 12px 16px;
            font-size: 0.85rem;
            border-bottom: 1px solid var(--clr-border);
        }

        .lf-table td {
            padding: 16px;
            border-bottom: 1px solid var(--clr-border);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .badge-processing {
            background-color: #fef3c7;
            color: #d97706;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .badge-resolved {
            background-color: #d1fae5;
            color: #059669;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .badge-rejected {
            background-color: #fee2e2;
            color: #dc2626;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        /* Modal custom styles */
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
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>

<header class="lf-header">
    <div class="d-flex align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: inherit;">
            <strong style="color:var(--clr-primary); font-size:1.3rem;">Lost & Found Admin</strong>
        </a>
    </div>
    <div class="d-flex align-items-center gap-3">
        <a href="${pageContext.request.contextPath}/manage_users" class="btn btn-sm btn-outline-secondary">Quản lý User</a>
        <a href="${pageContext.request.contextPath}/admin/blacklist" class="btn btn-sm btn-outline-secondary">Blacklist</a>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-primary" style="background:var(--clr-primary); border-color:var(--clr-primary);">Về Home</a>
    </div>
</header>

<div class="admin-container">
    <div class="admin-card">
        <h2 style="font-weight: 700; margin-bottom: 24px;">📥 Danh sách yêu cầu hỗ trợ</h2>

        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>

        <table class="lf-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User ID</th>
                    <th>Lý do</th>
                    <th>Liên hệ</th>
                    <th>Ảnh</th>
                    <th>Mô tả</th>
                    <th>Trạng thái</th>
                    <th>Phản hồi Admin</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty requests}">
                        <c:forEach var="req" items="${requests}">
                            <tr>
                                <td><strong>#${req.supportId}</strong></td>
                                <td>${req.userId}</td>
                                <td><span style="font-weight: 600; color: #334155;">${req.reason}</span></td>
                                <td>
                                    <div class="text-sm">E: ${req.email != null && req.email != '' ? req.email : '--'}</div>
                                    <div class="text-sm">P: ${req.phone != null && req.phone != '' ? req.phone : '--'}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty req.imageUrl}">
                                            <a href="${req.imageUrl}" target="_blank">
                                                <img src="${req.imageUrl}" style="width:40px; height:40px; object-fit:cover; border-radius:6px; border:1px solid #cbd5e1;" alt="support-img">
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted text-sm">Không có</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="max-width:250px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" title="${req.description}">
                                    ${req.description}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${req.status == 'processing'}">
                                            <span class="badge-processing">Chờ xử lý</span>
                                        </c:when>
                                        <c:when test="${req.status == 'resolved'}">
                                            <span class="badge-resolved">Đã xử lý</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-rejected">Từ chối</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="max-width:180px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" title="${req.adminFeedback}">
                                    ${req.adminFeedback != null ? req.adminFeedback : '--'}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${req.status == 'processing'}">
                                            <div class="d-flex gap-2">
                                                <button type="button" class="btn btn-sm btn-success" style="font-size:0.8rem; font-weight:600;" onclick="openActionModal(${req.supportId}, 'resolve')">Duyệt</button>
                                                <button type="button" class="btn btn-sm btn-danger" style="font-size:0.8rem; font-weight:600;" onclick="openActionModal(${req.supportId}, 'reject')">Từ chối</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted text-sm">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="9" class="text-center text-muted" style="padding: 40px;">Không có yêu cầu hỗ trợ nào.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- Support Action Modal -->
<div class="lf-modal-overlay" id="actionModal">
    <div class="lf-modal">
        <h3 class="lf-modal__title" id="modalTitle">Xử lý yêu cầu hỗ trợ</h3>
        
        <form id="actionForm" action="${pageContext.request.contextPath}/admin/support" method="POST">
            <input type="hidden" name="supportId" id="modalSupportId">
            <input type="hidden" name="action" id="modalAction">
            
            <div class="mb-3">
                <label for="adminFeedback" class="form-label" id="feedbackLabel">Lý do xử lý / Phản hồi cho User:</label>
                <textarea class="form-control" name="adminFeedback" id="adminFeedback" rows="4" placeholder="Nhập lý do/phản hồi chi tiết (bắt buộc)..." required></textarea>
            </div>

            <div class="d-flex gap-3">
                <button type="button" class="btn btn-secondary w-50" style="background:#e2e8f0; color:#334155; border:none;" onclick="closeActionModal()">Hủy</button>
                <button type="submit" class="btn btn-primary w-50" style="background:var(--clr-primary); border-color:var(--clr-primary); color:white;" id="modalSubmitBtn">Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openActionModal(supportId, action) {
        document.getElementById('modalSupportId').value = supportId;
        document.getElementById('modalAction').value = action;
        
        if (action === 'resolve') {
            document.getElementById('modalTitle').innerText = '✅ Duyệt xử lý yêu cầu #' + supportId;
            document.getElementById('feedbackLabel').innerText = 'Phản hồi chi tiết cho User sau khi xử lý:';
            document.getElementById('modalSubmitBtn').className = 'btn btn-success w-50';
            document.getElementById('modalSubmitBtn').style.background = '#10b981';
        } else {
            document.getElementById('modalTitle').innerText = '❌ Từ chối yêu cầu #' + supportId;
            document.getElementById('feedbackLabel').innerText = 'Lý do từ chối (bắt buộc):';
            document.getElementById('modalSubmitBtn').className = 'btn btn-danger w-50';
            document.getElementById('modalSubmitBtn').style.background = '#ef4444';
        }

        document.getElementById('adminFeedback').value = '';
        document.getElementById('actionModal').classList.add('open');
    }

    function closeActionModal() {
        document.getElementById('actionModal').classList.remove('open');
    }
</script>
</body>
</html>
