<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <nav class="lf-navbar">
        <div class="lf-navbar__inner">
            <a href="${pageContext.request.contextPath}/home" class="lf-navbar__brand">
                <div class="lf-navbar__logo">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="color:white; display:block;">
                        <circle cx="11" cy="11" r="8"/>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                </div>
                <span class="lf-navbar__title">Lost &amp; Found (Admin)</span>
            </a>
            <div class="lf-navbar__user">
                <lf:userMenu fullName="${sessionScope.currentUser.fullName}" role="${sessionScope.userRole}" contextPath="${pageContext.request.contextPath}"/>
            </div>
        </div>
    </nav>

    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="sep">/</span>
            <span class="current">Kiểm duyệt vi phạm</span>
        </div>

        <h1 class="lf-page-header__title mb-lg">Hàng Đợi Kiểm Duyệt</h1>

        <!-- FLASH MESSAGES -->
        <c:if test="${not empty sessionScope.message}">
            <div class="lf-alert lf-alert-success mb-md">
                <div>${sessionScope.message}</div>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>

        <div class="lf-grid-2">
            <div>
                <h2 class="lf-section-title"><span class="dot"></span> Bị ẩn bởi hệ thống (Chờ xử lý)</h2>
                <c:choose>
                    <c:when test="${not empty processingItems}">
                        <c:forEach var="item" items="${processingItems}">
                            <div class="lf-mod-card">
                                <div class="lf-mod-card__info">
                                    <div class="lf-mod-card__title">${item.title}</div>
                                    <div class="lf-mod-card__meta">
                                        Đăng bởi: ${item.ownerFullName} | Lĩnh vực: ${item.type}
                                    </div>
                                    <div class="lf-mod-card__reason">
                                        Hệ thống phát hiện từ cấm hoặc số điện thoại blacklist
                                    </div>
                                    <div class="lf-mod-card__actions">
                                        <a href="${pageContext.request.contextPath}/item_detail?id=${item.itemId}" class="btn btn-sm btn-ghost" target="_blank">Xem bài đăng</a>
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
                <h2 class="lf-section-title"><span class="dot" style="background:var(--clr-warning)"></span> Bị báo cáo bởi cộng đồng</h2>
                <c:choose>
                    <c:when test="${not empty reportedItems}">
                        <c:forEach var="rep" items="${reportedItems}">
                            <div class="lf-mod-card" style="border-left: 3px solid var(--clr-warning);">
                                <div class="lf-mod-card__info">
                                    <div class="lf-mod-card__title">${rep.title}</div>
                                    <div class="lf-mod-card__meta">
                                        Người đăng: ${rep.ownerName} | Bị báo cáo: <strong>${rep.reportCount}</strong> lần
                                    </div>
                                    <div class="lf-mod-card__reason" style="background:var(--clr-warning-l); color:#b45309;">
                                        Lý do báo cáo: ${rep.latestReason}
                                    </div>
                                    <div class="lf-mod-card__actions">
                                        <a href="${pageContext.request.contextPath}/item_detail?id=${rep.itemId}" class="btn btn-sm btn-ghost" target="_blank">Xem bài đăng</a>
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
</script>
</body>
</html>
