<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý yêu cầu hỗ trợ | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        :root {
            --clr-primary: #fd7e14;
            --clr-success: #10b981;
            --clr-danger: #ef4444;
            --clr-warning: #f59e0b;
            --clr-bg: #f8fafc;
            --clr-border: #e2e8f0;
            --txt-main: #0f172a;
            --txt-muted: #64748b;
        }

        body {
            background-color: var(--clr-bg);
            color: var(--txt-main);
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
        }

        .admin-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 24px;
        }

        .admin-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--clr-border);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            padding: 32px;
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
            padding: 14px 16px;
            font-size: 0.85rem;
            border-bottom: 2px solid var(--clr-border);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .lf-table td {
            padding: 16px;
            border-bottom: 1px solid var(--clr-border);
            font-size: 0.9rem;
            color: var(--txt-main);
            vertical-align: middle;
        }

        .lf-table tbody tr:hover {
            background-color: #f8fafc;
        }

        .badge-processing {
            background-color: #fef3c7;
            color: #d97706;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .badge-resolved {
            background-color: #dcfce7;
            color: #15803d;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .badge-rejected {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
        }

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

        .text-expandable {
            cursor: pointer;
            transition: color 0.15s ease;
            max-width: 100%;
            word-wrap: break-word;
            display: inline-block;
        }
        .text-expandable:hover {
            color: var(--clr-primary);
        }
        .text-primary-sm {
            font-size: 0.78rem;
            color: var(--clr-primary);
            font-weight: 600;
            margin-left: 4px;
            white-space: nowrap;
        }
    </style>
</head>
<body>

<lf:navbar activeMenu="support" />

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

        <!-- Khung Tìm kiếm và Bộ lọc hỗ trợ -->
        <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3 p-3 bg-light rounded" style="border: 1px solid var(--clr-border);">
            <div class="d-flex align-items-center gap-3 flex-wrap">
                <!-- Bộ lọc theo trạng thái (checkbox tick) -->
                <label class="d-flex align-items-center gap-2" style="font-size: 0.88rem; cursor: pointer; color: var(--txt-main); font-weight: 600; margin: 0;">
                    <input type="checkbox" id="showProcessing" checked onchange="filterSupportsByStatus()" style="accent-color: var(--clr-primary); width: 18px; height: 18px;">
                    Chờ xử lý
                </label>
                <label class="d-flex align-items-center gap-2" style="font-size: 0.88rem; cursor: pointer; color: var(--txt-main); font-weight: 600; margin: 0;">
                    <input type="checkbox" id="showProcessed" checked onchange="filterSupportsByStatus()" style="accent-color: var(--clr-primary); width: 18px; height: 18px;">
                    Đã xử lý &amp; Từ chối
                </label>
            </div>
            
            <div class="d-flex align-items-center gap-2 flex-wrap flex-grow-1 justify-content-end" style="max-width: 500px;">
                <!-- Tìm kiếm nhanh -->
                <div style="position: relative; max-width: 280px; width: 100%; min-width: 180px; flex: 1;">
                    <input type="text" class="form-control" id="supportSearchInput" placeholder="Tìm kiếm yêu cầu hỗ trợ..." 
                           onkeyup="filterSupportsByStatus()" 
                           style="padding-left: 36px; border-radius: 8px; border: 1px solid var(--clr-border); font-size: 0.88rem; height: 38px; width: 100%;">
                    <span style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--txt-muted); font-size: 0.9rem;">🔍</span>
                </div>

                <!-- Sắp xếp theo ngày tháng (nằm bên phải ô tìm kiếm) -->
                <select class="form-select" id="sortDateSelect" onchange="sortSupportTable(this)" style="max-width: 180px; min-width: 140px; font-size: 0.88rem; height: 38px; flex: 0 0 auto;">
                    <option value="newest">Mới nhất trước</option>
                    <option value="oldest">Cũ nhất trước</option>
                </select>
            </div>
        </div>

        <table class="lf-table" id="supportTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User ID</th>
                    <th>Lý do</th>
                    <th>Liên hệ</th>
                    <th>Thời gian gửi</th>
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
                            <tr data-status="${req.status}" data-created-at="${req.createdAt != null ? req.createdAt.time : 0}">
                                <td><strong>#${req.supportId}</strong></td>
                                <td>User #${req.userId}</td>
                                <td>
                                    <div class="text-expandable" onclick="viewDetail(this, 'Lý do hỗ trợ', '${req.supportId}', '${req.status}')">
                                        <c:choose>
                                            <c:when test="${fn:length(req.reason) > 25}">
                                                ${fn:substring(req.reason, 0, 25)}... <span class="text-primary-sm">[Xem]</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${req.reason}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="d-none full-text-content">${req.reason}</div>
                                </td>
                                <td>
                                    <div class="text-sm">E: ${req.email != null && req.email != '' ? req.email : '--'}</div>
                                    <div class="text-sm">P: ${req.phone != null && req.phone != '' ? req.phone : '--'}</div>
                                </td>
                                <td>
                                    <div style="font-size:0.85rem; color:#475569; font-weight: 500;">
                                        <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty req.imageUrl and (fn:startsWith(req.imageUrl, 'http://') or fn:startsWith(req.imageUrl, 'https://') or fn:startsWith(req.imageUrl, '/'))}">
                                            <a href="${req.imageUrl}" target="_blank">
                                                <img src="${req.imageUrl}" style="width:40px; height:40px; object-fit:cover; border-radius:6px; border:1px solid #cbd5e1;" alt="support-img">
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted text-sm" style="font-style: italic;">Không có</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="text-expandable" onclick="viewDetail(this, 'Mô tả chi tiết', '${req.supportId}', '${req.status}')">
                                        <c:choose>
                                            <c:when test="${fn:length(req.description) > 30}">
                                                ${fn:substring(req.description, 0, 30)}... <span class="text-primary-sm">[Xem]</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${req.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="d-none full-text-content">${req.description}</div>
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
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty req.adminFeedback}">
                                            <div class="text-expandable" onclick="viewDetail(this, 'Phản hồi của Admin', '${req.supportId}', '${req.status}')">
                                                <c:choose>
                                                    <c:when test="${fn:length(req.adminFeedback) > 25}">
                                                        ${fn:substring(req.adminFeedback, 0, 25)}... <span class="text-primary-sm">[Xem]</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${req.adminFeedback}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="d-none full-text-content">${req.adminFeedback}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">--</span>
                                        </c:otherwise>
                                    </c:choose>
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
                            <td colspan="10" class="text-center text-muted" style="padding: 40px;">Không có yêu cầu hỗ trợ nào.</td>
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

<!-- Text Detail Modal -->
<div class="lf-modal-overlay" id="detailModal">
    <div class="lf-modal" style="max-width: 550px;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="lf-modal__title" id="detailModalTitle" style="margin: 0;">Nội dung chi tiết</h3>
            <button type="button" onclick="closeDetailModal()" style="border:none; background:none; font-size:1.6rem; line-height:1; cursor:pointer; color:var(--txt-muted);">&times;</button>
        </div>
        
        <div class="mb-4" id="detailModalBody" style="max-height: 300px; overflow-y: auto; white-space: pre-wrap; word-break: break-word; color: var(--txt-main); font-size: 0.95rem; line-height: 1.5; padding: 12px; background: #f8fafc; border-radius: 8px; border: 1px solid var(--clr-border);">
        </div>

        <div class="d-flex gap-2 justify-content-end" id="detailModalActions">
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
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

    function viewDetail(element, title, supportId, status) {
        const parent = element.parentElement;
        const fullText = parent.querySelector('.full-text-content').innerText;
        
        document.getElementById('detailModalTitle').innerText = title;
        document.getElementById('detailModalBody').innerText = fullText;
        
        const actionsContainer = document.getElementById('detailModalActions');
        actionsContainer.innerHTML = '';
        
        if (supportId && status === 'processing') {
            actionsContainer.innerHTML = `
                <button type="button" class="btn btn-success" style="font-size:0.85rem; font-weight:600; padding: 6px 16px;" onclick="closeDetailModal(); openActionModal(${supportId}, 'resolve')">Duyệt</button>
                <button type="button" class="btn btn-danger" style="font-size:0.85rem; font-weight:600; padding: 6px 16px;" onclick="closeDetailModal(); openActionModal(${supportId}, 'reject')">Từ chối</button>
                <button type="button" class="btn btn-secondary" style="font-size:0.85rem; font-weight:600; padding: 6px 16px; background:#e2e8f0; color:#334155; border:none;" onclick="closeDetailModal()">Đóng</button>
            `;
        } else {
            actionsContainer.innerHTML = `
                <button type="button" class="btn btn-secondary" style="font-size:0.85rem; font-weight:600; padding: 6px 16px; background:#e2e8f0; color:#334155; border:none;" onclick="closeDetailModal()">Đóng</button>
            `;
        }
        
        document.getElementById('detailModal').classList.add('open');
    }

    function closeDetailModal() {
        document.getElementById('detailModal').classList.remove('open');
    }

    function filterSupportsByStatus() {
        const showProcessing = document.getElementById('showProcessing').checked;
        const showProcessed = document.getElementById('showProcessed').checked;
        const searchQuery = document.getElementById('supportSearchInput').value.toLowerCase().trim();
        
        const rows = document.querySelectorAll('#supportTable tbody tr');
        rows.forEach(row => {
            if (row.querySelector('td[colspan]')) return;
            
            const status = row.getAttribute('data-status');
            const isProcessingRow = (status === 'processing');
            const isProcessedRow = (status === 'resolved' || status === 'rejected');
            
            let matchStatus = false;
            if (isProcessingRow && showProcessing) matchStatus = true;
            if (isProcessedRow && showProcessed) matchStatus = true;
            
            let matchSearch = false;
            let text = '';
            row.querySelectorAll('td').forEach(cell => {
                text += cell.innerText.toLowerCase() + ' ';
            });
            if (text.includes(searchQuery)) {
                matchSearch = true;
            }
            
            if (matchStatus && matchSearch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function sortSupportTable(select) {
        const sortBy = select.value;
        const tbody = document.querySelector('#supportTable tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        
        rows.sort((a, b) => {
            if (a.querySelector('td[colspan]') || b.querySelector('td[colspan]')) return 0;
            const timeA = parseFloat(a.getAttribute('data-created-at')) || 0;
            const timeB = parseFloat(b.getAttribute('data-created-at')) || 0;
            return sortBy === 'newest' ? timeB - timeA : timeA - timeB;
        });
        
        rows.forEach(row => tbody.appendChild(row));
    }
</script>
</body>
</html>
