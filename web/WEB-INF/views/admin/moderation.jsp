<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin: Kiểm duyệt - Lost & Found</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">
    <lf:navbar activeMenu="moderation" />

    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="sep">/</span>
            <span class="current">Kiểm duyệt vi phạm</span>
        </div>

        <h1 class="lf-page-header__title mb-lg">Bài viết cần kiểm tra</h1>

        <c:catch var="ex">
        <!-- FLASH MESSAGES -->
        <c:if test="${not empty sessionScope.message}">
            <div class="lf-alert lf-alert-success mb-md">
                <div>${sessionScope.message}</div>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>

        <div class="lf-grid-2">
            <div>
                <h2 class="lf-section-title"><span class="dot"></span> Bị ẩn bởi hệ thống (Đã tạm ẩn)</h2>
                <c:choose>
                    <c:when test="${not empty processingItems}">
                        <c:forEach var="item" items="${processingItems}">
                            <div class="lf-mod-card">
                                <div class="lf-mod-card__info">
                                    <div class="lf-mod-card__title">${item.title}</div>
                                    <div class="lf-mod-card__meta">
                                        Đăng bởi: <a href="javascript:void(0)" onclick="showUserDetail('${fn:escapeXml(item.ownerFullName)}', '${item.ownerPhone}', true)" style="text-decoration:underline; font-weight:600; color:var(--txt-main);">${item.ownerFullName}</a> | Lĩnh vực: ${item.type} | Ngày đăng: <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </div>
                                    <div class="lf-mod-card__reason" style="background:#f1f5f9; color:#475569; padding: 10px; border-radius: 8px; margin-top: 8px; font-size: 0.88rem; font-weight: 500;">
                                        Lý do ẩn: ${item.reason}
                                        <c:if test="${not empty item.reportersList}">
                                            <div style="color:var(--clr-danger); margin-top: 4px; font-size: 0.82rem;">
                                                Người báo cáo: 
                                                <c:forEach var="repUser" items="${item.reportersList}" varStatus="status">
                                                    <a href="javascript:void(0)" onclick="showUserDetail('${fn:escapeXml(repUser.fullName)}', '${repUser.phoneNumber}', false)" class="text-danger" style="text-decoration: underline; font-weight: 600;">
                                                        ${repUser.fullName}
                                                    </a><c:if test="${!status.last}">, </c:if>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="lf-mod-card__actions" style="margin-top: 12px;">
                                        <a href="${pageContext.request.contextPath}/item_detail?id=${item.itemId}" class="btn btn-sm btn-ghost">Xem bài đăng</a>
                                        <form method="POST" action="moderation" style="display:inline;">
                                            <input type="hidden" name="itemId" value="${item.itemId}">
                                            <input type="hidden" name="action" value="approve">
                                            <button class="btn btn-sm btn-success">Duyệt lại bài</button>
                                        </form>
                                        <form method="POST" action="moderation" style="display:inline;" onsubmit="return showModConfirm(event, 'Chắc chắn xóa bài này?');">
                                            <input type="hidden" name="itemId" value="${item.itemId}">
                                            <input type="hidden" name="action" value="delete">
                                            <button class="btn btn-sm btn-danger">Xóa bài</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <lf:emptyState title="Không có bài viết nào bị ẩn" sub="Hệ thống đang hoạt động bình thường."/>
                    </c:otherwise>
                </c:choose>
            </div>

            <div>
                <h2 class="lf-section-title"><span class="dot" style="background:var(--clr-warning)"></span> Bị báo cáo bởi cộng đồng (Vẫn hiển thị)</h2>
                <c:choose>
                    <c:when test="${not empty reportedItems}">
                        <c:forEach var="rep" items="${reportedItems}">
                            <div class="lf-mod-card" style="border-left: 3px solid var(--clr-warning);">
                                <div class="lf-mod-card__info">
                                    <div class="lf-mod-card__title">${rep.title}</div>
                                    <div class="lf-mod-card__meta">
                                        Người đăng: <strong><a href="javascript:void(0)" onclick="showUserDetail('${fn:escapeXml(rep.ownerName)}', '${rep.ownerPhone}', true)" style="text-decoration:underline; color:var(--txt-main);">${rep.ownerName}</a></strong>
                                        <c:if test="${not empty rep.reportersList}">
                                            | Người báo cáo: 
                                            <c:forEach var="repUser" items="${rep.reportersList}" varStatus="status">
                                                <a href="javascript:void(0)" onclick="showUserDetail('${fn:escapeXml(repUser.fullName)}', '${repUser.phoneNumber}', false)" class="text-danger" style="text-decoration: underline; font-weight: 600;">
                                                    ${repUser.fullName}
                                                </a><c:if test="${!status.last}">, </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                    <div class="lf-mod-card__meta" style="margin-top: 4px; font-size: 0.82rem; color: var(--txt-muted);">
                                        Báo cáo gần nhất: <strong style="color:var(--txt-main);"><fmt:formatDate value="${rep.latestReportTime}" pattern="dd/MM/yyyy HH:mm:ss"/></strong> | Bị báo cáo: <strong style="color:var(--clr-danger);">${rep.reportCount}</strong> lần
                                    </div>
                                    <div class="lf-mod-card__reason text-expandable-card" onclick="viewTextDetail(this, 'Lý do báo cáo')" style="background:var(--clr-warning-l); color:#b45309; cursor:pointer; padding: 10px; border-radius: 8px; margin-top: 8px; font-size: 0.88rem;">
                                        Lý do báo cáo gần nhất: 
                                        <c:choose>
                                            <c:when test="${fn:length(rep.latestReason) > 40}">
                                                ${fn:substring(rep.latestReason, 0, 40)}... <span style="font-weight:700; text-decoration:underline;">[Xem]</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${rep.latestReason}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="d-none full-text-content">${rep.latestReason}</div>
                                    <div class="lf-mod-card__actions" style="margin-top: 12px;">
                                        <a href="${pageContext.request.contextPath}/item_detail?id=${rep.itemId}" class="btn btn-sm btn-ghost">Xem bài đăng</a>
                                        <form method="POST" action="moderation" style="display:inline;">
                                            <input type="hidden" name="itemId" value="${rep.itemId}">
                                            <input type="hidden" name="action" value="approve">
                                            <button class="btn btn-sm btn-success">Giữ lại bài</button>
                                        </form>
                                        <form method="POST" action="moderation" style="display:inline;" onsubmit="return showModConfirm(event, 'Xóa bài vi phạm này?');">
                                            <input type="hidden" name="itemId" value="${rep.itemId}">
                                            <input type="hidden" name="action" value="delete">
                                            <button class="btn btn-sm btn-danger">Xóa bài</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <lf:emptyState title="Không có bài viết nào bị báo cáo" sub="Cộng đồng đang rất yên bình..."/>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        </c:catch>
        <c:if test="${not empty ex}">
            <div class="alert alert-danger" style="margin: 20px; padding: 20px; border-radius: 8px; background: #fff1f2; border: 1px solid #f43f5e; color: #9f1239;">
                <h4 style="margin-top:0;">🔴 Đã xảy ra lỗi hiển thị ở trang Kiểm Duyệt:</h4>
                <p><strong>Lỗi:</strong> ${ex}</p>
                <p><strong>Chi tiết:</strong> ${ex.message}</p>
                <pre style="background: #ffe4e6; color: #9f1239; padding: 15px; border-radius: 6px; overflow-x: auto; margin-top: 15px; font-family: monospace; font-size: 0.85rem;"><%
                    Throwable t = (Throwable) pageContext.getAttribute("ex");
                    if (t != null) {
                        java.io.StringWriter sw = new java.io.StringWriter();
                        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                        t.printStackTrace(pw);
                        out.print(sw.toString());
                    }
                %></pre>
            </div>
        </c:if>
    </main>
</div>

<!-- Custom Confirm Modal -->
<div class="lf-modal-overlay" id="confirmModal">
    <div class="lf-modal" style="max-width:400px;">
        <button class="lf-modal__close" onclick="closeConfirmModal()">&times;</button>
        <h3 class="lf-modal__title">Xác nhận</h3>
        <p class="text-sm mb-md" id="confirmText" style="color:var(--txt-primary); margin-top:15px; margin-bottom:20px; font-size:0.95rem;">Bạn chắc chắn muốn thực hiện hành động này?</p>
        <div class="flex gap-sm mt-sm">
            <button type="button" class="btn btn-secondary flex-1" style="background:#f3f4f6; color:#374151; border:1px solid #d1d5db;" onclick="closeConfirmModal()">Hủy</button>
            <button type="button" class="btn btn-primary flex-1" id="confirmBtn" style="background:#fd7e14; border-color:#fd7e14; color:white;">Đồng ý</button>
        </div>
    </div>
</div>

<!-- Modal hiển thị nội dung to -->
<div class="lf-modal-overlay" id="detailModal">
    <div class="lf-modal" style="max-width: 550px;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="lf-modal__title" id="detailModalTitle" style="margin: 0;">Nội dung chi tiết</h3>
            <button type="button" onclick="closeDetailModal()" style="border:none; background:none; font-size:1.6rem; line-height:1; cursor:pointer; color:var(--txt-muted);">&times;</button>
        </div>
        
        <div class="mb-4" id="detailModalBody" style="max-height: 300px; overflow-y: auto; white-space: pre-wrap; word-break: break-word; color: #1f2937; font-size: 0.95rem; line-height: 1.5; padding: 12px; background: #f8fafc; border-radius: 8px; border: 1px solid var(--clr-border);">
        </div>

        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-secondary" style="font-size:0.85rem; font-weight:600; padding: 6px 16px; background:#e2e8f0; color:#334155; border:none;" onclick="closeDetailModal()">Đóng</button>
        </div>
    </div>
</div>

<!-- User Detail Modal -->
<div class="lf-modal-overlay" id="userDetailModal">
    <div class="lf-modal" style="max-width: 420px; border-radius: 12px; padding: 24px;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="lf-modal__title" style="margin: 0; font-size: 1.25rem; font-weight: 700; color: var(--txt-main);">👤 Thông tin tài khoản</h3>
            <button type="button" onclick="closeUserDetailModal()" style="border:none; background:none; font-size:1.6rem; line-height:1; cursor:pointer; color:var(--txt-muted);">&times;</button>
        </div>
        
        <div class="mb-4" style="background: #f8fafc; padding: 16px; border-radius: 8px; border: 1px solid var(--clr-border);">
            <div class="mb-2" style="font-size: 0.95rem;">
                <strong style="color: var(--txt-muted);">Họ và tên:</strong> 
                <span id="udFullName" style="font-weight: 600; color: var(--txt-main); margin-left: 6px;"></span>
            </div>
            <div style="font-size: 0.95rem;">
                <strong style="color: var(--txt-muted);">Số điện thoại:</strong> 
                <span id="udPhone" style="font-weight: 600; color: var(--clr-primary); margin-left: 6px;"></span>
            </div>
        </div>

        <div class="d-flex gap-2 justify-content-end" id="userDetailActions">
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    let pendingForm = null;
    function showModConfirm(event, text) {
        event.preventDefault();
        pendingForm = event.target.closest('form');
        document.getElementById('confirmText').innerText = text;
        document.getElementById('confirmModal').classList.add('open');
        return false;
    }

    function closeConfirmModal() {
        document.getElementById('confirmModal').classList.remove('open');
        pendingForm = null;
    }

    document.getElementById('confirmBtn').addEventListener('click', function() {
        if (pendingForm) {
            pendingForm.submit();
        }
        closeConfirmModal();
    });

    function viewTextDetail(element, title) {
        const parent = element.parentElement;
        const fullText = parent.querySelector('.full-text-content').innerText;
        
        document.getElementById('detailModalTitle').innerText = title;
        document.getElementById('detailModalBody').innerText = fullText;
        document.getElementById('detailModal').classList.add('open');
    }

    function closeDetailModal() {
        document.getElementById('detailModal').classList.remove('open');
    }

    function showUserDetail(fullName, phoneNumber, isOwner) {
        document.getElementById('udFullName').innerText = fullName;
        document.getElementById('udPhone').innerText = (phoneNumber && phoneNumber.trim() !== '') ? phoneNumber : 'Không có SĐT';
        
        const actionsContainer = document.getElementById('userDetailActions');
        actionsContainer.innerHTML = '';
        
        if (isOwner && phoneNumber && phoneNumber.trim() !== '') {
            actionsContainer.innerHTML = `
                <form method="POST" action="moderation" style="margin:0;" onsubmit="return confirm('Bạn chắc chắn muốn BAN người dùng này, thêm SĐT ${phoneNumber} vào Blacklist và tạm ẩn toàn bộ tin đăng của họ?');">
                    <input type="hidden" name="action" value="blacklist">
                    <input type="hidden" name="phone" value="${phoneNumber}">
                    <button type="submit" class="btn btn-danger" style="font-size: 0.85rem; font-weight: 600; padding: 8px 16px;">🚫 Đưa vào Blacklist (Ban)</button>
                </form>
                <button type="button" class="btn btn-secondary" style="font-size: 0.85rem; font-weight: 600; padding: 8px 16px; background:#e2e8f0; color:#334155; border:none;" onclick="closeUserDetailModal()">Đóng</button>
            `;
        } else {
            actionsContainer.innerHTML = `
                <button type="button" class="btn btn-secondary" style="font-size: 0.85rem; font-weight: 600; padding: 8px 16px; background:#e2e8f0; color:#334155; border:none;" onclick="closeUserDetailModal()">Đóng</button>
            `;
        }
        
        document.getElementById('userDetailModal').classList.add('open');
    }

    function closeUserDetailModal() {
        document.getElementById('userDetailModal').classList.remove('open');
    }
</script>
</body>
</html>
