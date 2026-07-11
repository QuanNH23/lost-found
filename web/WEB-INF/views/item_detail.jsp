<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết bài đăng — Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">

    <!-- NAVBAR -->
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
                <li><a href="${pageContext.request.contextPath}/inbox"    class="lf-navbar__link">Hộp thư</a></li>
            </ul>
            <div class="lf-navbar__user">
                <lf:userMenu fullName="${sessionScope.currentUser.fullName}"
                             role="${sessionScope.userRole}"
                             contextPath="${pageContext.request.contextPath}"/>
            </div>
        </div>
    </nav>

    <c:if test="${not empty sessionScope.message}">
        <script>
            window.addEventListener('DOMContentLoaded', function() {
                window.LF && window.LF.toast('${fn:escapeXml(sessionScope.message)}', 'info');
            });
        </script>
        <c:remove var="message" scope="session"/>
    </c:if>

    <main class="lf-main">
        <!-- Breadcrumb -->
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="sep">›</span>
            <a href="${pageContext.request.contextPath}/my_items">Tin của tôi</a>
            <span class="sep">›</span>
            <span class="current">Chi tiết bài đăng</span>
        </div>

        <c:if test="${not empty ERROR}">
            <div class="lf-alert lf-alert-error mb-md">
                <span>${ERROR}</span>
            </div>
        </c:if>

        <c:if test="${not empty itemDetail}">
            <!-- Item Info Card -->
            <div class="lf-card mb-lg">
                <div class="flex flex-between flex-wrap gap-md mb-md">
                    <div class="lf-page-header__title">${itemDetail.title}</div>
                    <div style="display:flex; gap:8px; align-items:center;">
                        <lf:statusBadge status="${itemDetail.status}"/>
                        <lf:typeBadge type="${itemType}"/>
                        <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.userId != itemOwnerId}">
                            <button class="lf-report-btn" onclick="document.getElementById('reportModal').classList.add('open')">Báo cáo</button>
                        </c:if>
                    </div>
                </div>

                <table class="lf-detail-table">
                    <tr>
                        <td>Người đăng</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/user_detail?id=${itemOwnerId}">
                                <strong>${itemOwnerName}</strong>
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td>Danh mục</td>
                        <td><strong>${empty itemDetail.categoryName ? '—' : itemDetail.categoryName}</strong></td>
                    </tr>
                    <tr>
                        <td>Địa điểm</td>
                        <td><strong>${empty itemDetail.locationName ? '—' : itemDetail.locationName}</strong></td>
                    </tr>
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${itemType eq 'lost'}">Ngày giờ báo mất</c:when>
                                <c:otherwise>Ngày giờ nhặt được</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty itemDetail.dateIncident}">
                                        <fmt:formatDate value="${itemDetail.dateIncident}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </strong>
                        </td>
                    </tr>
                    <tr>
                        <td>Ngày giờ đăng bài</td>
                        <td>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty itemDetail.createdAt}">
                                        <fmt:formatDate value="${itemDetail.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </strong>
                        </td>
                    </tr>
                    <tr>
                        <td>Mô tả</td>
                        <td>${itemDetail.description}</td>
                    </tr>
                </table>

                <!-- Images -->
                <c:if test="${not empty imagePaths}">
                    <div class="lf-item-images mt-md">
                        <c:forEach var="imgPath" items="${imagePaths}">
                            <img src="${pageContext.request.contextPath}/${imgPath}" alt="Hình ảnh đồ vật" height="160">
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty imagePaths}">
                    <div class="mt-md" style="color:var(--txt-muted);font-size:.85rem;">Không có hình ảnh</div>
                </c:if>
            </div>

            <!-- Messages -->
            <div class="lf-section-title"><span class="dot"></span>Tin nhắn &amp; Yêu cầu</div>

            <c:choose>
                <c:when test="${not empty itemMessages}">
                    <c:forEach var="m" items="${itemMessages}">
                        <c:set var="msgClaim" value="${claimByClaimer[m.userId]}"/>
                        <div class="lf-message">
                            <div class="lf-message__header">
                                <a class="lf-message__sender"
                                   href="${pageContext.request.contextPath}/user_detail?id=${m.userId}">
                                    ${senderNames[m.userId]}
                                </a>
                                <span class="lf-message__time">${m.createdAt}</span>
                            </div>
                            <div class="lf-message__title">${m.title}</div>
                            <div class="lf-message__body">${m.message}</div>

                            <!-- Claim status -->
                            <div class="mt-sm flex flex-wrap gap-sm" style="align-items:center;">
                                <c:choose>
                                    <c:when test="${not empty msgClaim}">
                                            <lf:statusBadge status="${msgClaim.status}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-muted">— Chưa có claim</span>
                                    </c:otherwise>
                                </c:choose>

                                <!-- ACTIONS -->
                                <c:choose>
                                    <c:when test="${isItemOwner}">
                                        <c:choose>
                                            <c:when test="${itemType eq 'found'}">
                                                <c:if test="${not empty msgClaim and msgClaim.status eq 'pending'}">
                                                    <form action="${pageContext.request.contextPath}/item_detail" method="post" class="flex gap-sm">
                                                        <input type="hidden" name="action"   value="respond_claim">
                                                        <input type="hidden" name="item_id"  value="${itemDetail.itemId}">
                                                        <input type="hidden" name="claim_id" value="${msgClaim.claimId}">
                                                        <button type="submit" name="decision" value="accept"
                                                                class="btn btn-success btn-sm"
                                                                onclick="return confirm('Bạn đồng ý duyệt trả đồ cho người này?')">
                                                            ✅ Approve
                                                        </button>
                                                        <button type="submit" name="decision" value="reject"
                                                                class="btn btn-danger btn-sm"
                                                                onclick="return confirm('Bạn muốn từ chối yêu cầu này?')">
                                                            ❌ Reject
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${not empty msgClaim and msgClaim.status ne 'pending'}">
                                                    <span class="text-sm text-muted">Đã xử lý xong</span>
                                                </c:if>
                                            </c:when>
                                            <c:when test="${itemType eq 'lost'}">
                                                <c:choose>
                                                    <c:when test="${empty msgClaim}">
                                                        <form action="${pageContext.request.contextPath}/item_detail" method="post" class="flex gap-sm">
                                                            <input type="hidden" name="action"     value="owner_request_lost">
                                                            <input type="hidden" name="item_id"    value="${itemDetail.itemId}">
                                                            <input type="hidden" name="claimer_id" value="${m.userId}">
                                                            <button type="submit" name="decision" value="request"
                                                                    class="btn btn-primary btn-sm"
                                                                    onclick="return confirm('Gửi yêu cầu nhận lại đồ?')">
                                                                📦 Yêu cầu nhận lại
                                                            </button>
                                                            <button type="submit" name="decision" value="reject"
                                                                    class="btn btn-ghost btn-sm"
                                                                    onclick="return confirm('Xác nhận đây không phải đồ của bạn?')">
                                                                🚫 Không phải đồ tôi
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${msgClaim.status eq 'pending'}">
                                                        <span class="text-sm text-muted">⏳ Đang chờ người tìm thấy xác nhận...</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-sm text-muted">Đã xử lý xong</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${itemType eq 'lost'}">
                                                <c:choose>
                                                    <c:when test="${empty msgClaim}">
                                                        <span class="text-sm text-muted">⏳ Chờ chủ bài xác nhận...</span>
                                                    </c:when>
                                                    <c:when test="${msgClaim.status eq 'pending'}">
                                                        <form action="${pageContext.request.contextPath}/item_detail" method="post" class="flex gap-sm">
                                                            <input type="hidden" name="action"   value="finder_respond_lost">
                                                            <input type="hidden" name="item_id"  value="${itemDetail.itemId}">
                                                            <input type="hidden" name="claim_id" value="${msgClaim.claimId}">
                                                            <div class="text-sm fw-bold text-muted" style="align-self:center;">Yêu cầu nhận lại đồ:</div>
                                                            <button type="submit" name="decision" value="accept"
                                                                    class="btn btn-success btn-sm"
                                                                    onclick="return confirm('Bạn đồng ý trả lại đồ cho chủ?')">
                                                                ✅ Accept
                                                            </button>
                                                            <button type="submit" name="decision" value="reject"
                                                                    class="btn btn-danger btn-sm"
                                                                    onclick="return confirm('Bạn muốn từ chối yêu cầu này?')">
                                                                ❌ Reject
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-sm text-muted">Đã xử lý</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:if test="${not empty msgClaim}">
                                                    <span class="text-sm text-muted">📤 Đã gửi yêu cầu</span>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <lf:emptyState title="Chưa có tin nhắn nào" sub="" icon="💬"/>
                </c:otherwise>
            </c:choose>

            <!-- Send Message Form -->
            <c:choose>
                <c:when test="${!isItemOwner}">
                    <div class="lf-send-box">
                        <div class="lf-section-title mb-md"><span class="dot"></span>Gửi tin nhắn</div>
                        <c:choose>
                            <c:when test="${itemType eq 'lost'}">
                                <div class="lf-alert lf-alert-info mb-md">
                                    <span class="lf-alert__icon">ℹ️</span>
                                    <span>Sau khi gửi tin nhắn, chủ bài sẽ xem xét và gửi yêu cầu nhận lại đồ nếu đây là đồ của họ.</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="lf-alert lf-alert-info mb-md">
                                    <span class="lf-alert__icon">ℹ️</span>
                                    <span>Khi gửi tin nhắn, hệ thống sẽ tạo luôn yêu cầu nhận lại đồ cho bạn.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <form action="${pageContext.request.contextPath}/item_detail" method="post" class="lf-form">
                            <input type="hidden" name="action"  value="send_message">
                            <input type="hidden" name="item_id" value="${itemDetail.itemId}">
                            <div class="lf-form-group">
                                <label class="lf-label" for="title">Tiêu đề <span class="req">*</span></label>
                                <input type="text" id="title" name="title" class="lf-input" required
                                       placeholder="Vd: Đây là đồ của tôi">
                            </div>
                            <div class="lf-form-group">
                                <label class="lf-label" for="message">Nội dung <span class="req">*</span></label>
                                <textarea id="message" name="message" class="lf-textarea" required
                                          placeholder="Đây là đồ của tôi, cho tôi xin nhận lại."></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">📤 Gửi tin nhắn</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="lf-alert lf-alert-info">
                        <span class="lf-alert__icon">ℹ️</span>
                        <span>Bạn là chủ bài đăng, không thể tự gửi tin nhắn cho chính bài viết của mình.</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>
    </main>

    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.</footer>
</div>
<!-- Report Modal -->
<div class="lf-modal-overlay" id="reportModal">
    <div class="lf-modal">
        <button class="lf-modal__close" onclick="document.getElementById('reportModal').classList.remove('open')">&times;</button>
        <h3 class="lf-modal__title">Báo Cáo Vi Phạm</h3>
        <p class="text-muted text-sm mb-md">Vui lòng cho chúng tôi biết lý do bạn báo cáo bài viết này. Nếu nhận đủ báo cáo, bài viết sẽ tạm ẩn.</p>
        <form method="POST" action="${pageContext.request.contextPath}/report_item" class="lf-form">
            <input type="hidden" name="itemId" value="${itemDetail.itemId}">
            <div class="lf-form-group">
                <label class="lf-label">Lý do báo cáo <span class="req">*</span></label>
                <textarea name="reason" class="lf-textarea" placeholder="Nội dung thô tục, lừa đảo, sai sự thật..." required minlength="5"></textarea>
            </div>
            <div class="flex gap-sm mt-sm">
                <button type="button" class="btn btn-secondary flex-1" onclick="document.getElementById('reportModal').classList.remove('open')">Hủy</button>
                <button type="submit" class="btn btn-danger flex-1">Gửi Báo Cáo</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
