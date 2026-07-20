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
    <style>
        /* Premium Detail Page Styles */
        .lf-detail-header-block {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .lf-detail-title {
            font-family: 'Inter', sans-serif;
            font-size: 2.2rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0;
            line-height: 1.25;
        }
        .lf-detail-grid {
            display: flex;
            gap: 30px;
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .lf-detail-image-sec {
            flex: 1;
            max-width: 45%;
            border: 1px solid #f1f5f9;
            border-radius: 8px;
            overflow: hidden;
            background: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 350px;
        }
        .lf-detail-main-img {
            width: 100%;
            height: auto;
            max-height: 400px;
            object-fit: contain;
        }
        .lf-detail-no-img {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            font-size: 1.1rem;
        }
        .lf-detail-info-sec {
            flex: 1.2;
            display: flex;
            flex-direction: column;
        }
        .lf-info-item {
            margin-bottom: 12px;
        }
        .lf-info-label {
            display: block;
            font-size: 0.75rem;
            font-weight: 800;
            color: #64748b;
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }
        .lf-info-val {
            font-size: 1.05rem;
            font-weight: 500;
            color: #334155;
        }
        .lf-info-desc {
            color: #334155;
            font-size: 1rem;
            line-height: 1.6;
            background: #f8fafc;
            padding: 16px;
            border-radius: 8px;
            margin-top: 10px;
            border-left: 4px solid #cbd5e1;
        }
        .lf-user-box {
            display: flex;
            align-items: center;
            gap: 16px;
            background: #f0f9ff;
            padding: 14px 18px;
            border-radius: 8px;
            border: 1px solid #e0f2fe;
            margin-top: 15px;
        }
        .lf-user-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            overflow: hidden;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .lf-user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .lf-user-meta {
            display: flex;
            flex-direction: column;
        }
        .btn-phone-call {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            width: 100%;
            background: #ffc107;
            color: #000 !important;
            font-size: 1.25rem;
            font-weight: 800;
            padding: 12px;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            transition: background 0.2s, transform 0.1s;
            border: none;
            margin-top: 20px;
            box-shadow: 0 4px 6px -1px rgba(251,191,36,0.2);
        }
        .btn-phone-call:hover {
            background: #e0a800;
            transform: translateY(-1px);
        }
        .btn-phone-call:active {
            transform: translateY(0);
        }
        
        /* Comments & Related layout */
        .lf-bottom-container {
            display: flex;
            gap: 30px;
            margin-top: 30px;
        }
        .lf-comments-column {
            flex: 1.8;
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .lf-related-column {
            flex: 1.2;
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
        .lf-comment-item {
            padding: 16px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .lf-comment-item:last-child {
            border-bottom: none;
        }
        .lf-comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 6px;
        }
        .lf-comment-user {
            font-weight: 700;
            color: #0f172a;
            font-size: 0.95rem;
        }
        .lf-comment-time {
            font-size: 0.8rem;
            color: #94a3b8;
        }
        .lf-comment-body {
            color: #475569;
            font-size: 0.95rem;
            line-height: 1.5;
        }
        .lf-related-item {
            display: flex;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
            align-items: center;
        }
        .lf-related-item:last-child {
            border-bottom: none;
        }
        .lf-related-img {
            width: 80px;
            height: 60px;
            border-radius: 6px;
            object-fit: cover;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }
        .lf-related-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .lf-related-title {
            font-weight: 600;
            color: #1e293b;
            font-size: 0.9rem;
            line-height: 1.3;
            text-decoration: none;
        }
        .lf-related-title:hover {
            color: var(--clr-primary);
            text-decoration: underline;
        }
        .lf-related-meta {
            font-size: 0.75rem;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>
<div class="lf-wrapper">

    <!-- ── NAVBAR ── -->
    <lf:navbar activeMenu="detail" />

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
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <a href="${pageContext.request.contextPath}/my_items">Tin của tôi</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/items?type=lost">Danh sách tin</a>
                </c:otherwise>
            </c:choose>
            <span class="sep">›</span>
            <span class="current">Chi tiết bài đăng</span>
        </div>

        <c:if test="${not empty ERROR}">
            <div class="lf-alert lf-alert-error mb-md">
                <span>${ERROR}</span>
            </div>
        </c:if>

        <c:if test="${not empty itemDetail}">
            <!-- Header Block -->
            <div class="lf-detail-header-block">
                <div class="flex flex-between flex-wrap gap-md align-items-center">
                    <h1 class="lf-detail-title">${itemDetail.title}</h1>
                    <div style="display:flex; gap:8px; align-items:center;">
                        <lf:statusBadge status="${itemDetail.status}"/>
                        <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.userId != itemOwnerId}">
                            <button class="lf-report-btn" onclick="document.getElementById('reportModal').classList.add('open')">🚨 Báo cáo</button>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Two-Column Main Grid -->
            <div class="lf-detail-grid">
                <!-- Left: Large Image Section -->
                <div class="lf-detail-image-sec">
                    <c:if test="${not empty imagePaths}">
                        <img src="${pageContext.request.contextPath}/${imagePaths[0]}" alt="${itemDetail.title}" class="lf-detail-main-img">
                    </c:if>
                    <c:if test="${empty imagePaths}">
                        <c:set var="demoIdx" value="${(itemDetail.itemId % 4) + 1}"/>
                        <img src="${pageContext.request.contextPath}/uploads/demo/demo_${demoIdx}.png" alt="${itemDetail.title}" class="lf-detail-main-img">
                    </c:if>
                </div>
                
                <!-- Right: Information Details Section -->
                <div class="lf-detail-info-sec">
                    <div class="lf-info-item">
                        <span class="lf-info-label">ĐỊA CHỈ</span>
                        <span class="lf-info-val" style="color:#0284c7; font-weight:700;">📍 ${empty itemDetail.locationName ? 'Chưa xác định' : itemDetail.locationName}</span>
                    </div>
                    
                    <c:if test="${not empty itemDetail.locationDetails}">
                        <div class="lf-info-item mt-sm">
                            <span class="lf-info-label">CHI TIẾT ĐỊA ĐIỂM</span>
                            <span class="lf-info-val" style="font-weight:600; color:#334155;">🏠 ${itemDetail.locationDetails}</span>
                        </div>
                    </c:if>
                    
                    <div class="lf-info-item mt-xs">
                        <span class="badge" style="background:#f1f5f9; color:#475569; padding:6px 12px; border-radius:4px; font-weight:600; font-size:0.85rem;">🏷️ ${empty itemDetail.categoryName ? 'Đồ vật' : itemDetail.categoryName}</span>
                    </div>
                    
                    <div class="lf-info-item mt-md" style="font-size:1.05rem;">
                        <strong>Tin: </strong>
                        <span style="color:#0284c7; font-weight:800; font-size:1.1rem;">
                            <c:choose>
                                <c:when test="${itemType eq 'lost'}">Tìm đồ</c:when>
                                <c:otherwise>Đồ nhặt được</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <div class="lf-info-desc mt-sm">
                        ${cleanDescription}
                    </div>
                    
                    <!-- Owner Contact Box -->
                    <div class="lf-user-box">
                        <div class="lf-user-avatar">
                            <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Avatar">
                        </div>
                        <div class="lf-user-meta">
                            <span style="color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase;">Người đăng</span>
                            <span style="font-weight: 700; color: #0f172a; font-size: 1.1rem;">${itemOwnerName}</span>
                        </div>
                    </div>
                    
                    <!-- Views / Date incident -->
                    <div class="text-sm mt-md" style="color: #64748b;">
                        👁️ 407 lượt xem • 
                        <c:choose>
                            <c:when test="${not empty itemDetail.dateIncident}">
                                <fmt:formatDate value="${itemDetail.dateIncident}" pattern="dd/MM/yyyy"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate value="${itemDetail.createdAt}" pattern="dd/MM/yyyy"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Phone Button clickable (only for logged-in users) -->
                    <c:if test="${not empty sessionScope.currentUser && not empty itemOwnerPhone}">
                        <a href="tel:${itemOwnerPhone}" class="btn-phone-call">
                            📞 ${itemOwnerPhone}
                        </a>
                    </c:if>
                    <c:if test="${empty sessionScope.currentUser && not empty itemOwnerPhone}">
                        <a href="${pageContext.request.contextPath}/login" class="btn-phone-call" style="text-decoration:none;">
                            📞 Đăng nhập để xem SĐT
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Bottom: Comments Section and Related Posts Sidebar -->
            <div class="lf-bottom-container">
                <!-- Left: Comments Box -->
                <div class="lf-comments-column">
                    <h3 class="lf-section-title mb-md" style="border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">Bình luận</h3>
                    
                    <!-- Comment Input Box -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <form action="${pageContext.request.contextPath}/item_detail" method="post" class="lf-form mb-lg" style="background:#f8fafc; padding:16px; border-radius:8px; border:1px solid #e2e8f0;">
                                <input type="hidden" name="action" value="send_message">
                                <input type="hidden" name="item_id" value="${itemDetail.itemId}">
                                <div class="lf-form-group mb-sm">
                                    <textarea name="message" class="lf-textarea" style="background:white; min-height:80px; border-radius:6px;" placeholder="Viết bình luận..." required minlength="2"></textarea>
                                </div>
                                <div style="text-align:right;">
                                    <button type="submit" class="btn btn-primary btn-sm" style="background:#0284c7; border-color:#0284c7; padding:6px 20px;">Đăng</button>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div style="background:#f8fafc; padding:20px; border-radius:8px; border:1px solid #e2e8f0; text-align:center; margin-bottom:20px;">
                                <p style="color:#64748b; margin:0 0 10px 0; font-size:0.95rem;">🔒 Vui lòng đăng nhập để gửi bình luận hoặc liên hệ.</p>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm" style="background:#0284c7; border-color:#0284c7; padding:6px 24px; text-decoration:none; color:white; border-radius:6px;">Đăng nhập ngay</a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Comments List -->
                    <div class="lf-comments-list">
                        <c:choose>
                            <c:when test="${not empty commentTree}">
                                <c:forEach var="node" items="${commentTree}">
                                    <c:set var="c" value="${node.comment}"/>
                                    <div class="lf-comment-item" id="comment-${c.messageId}" style="border-bottom:1px solid #f1f5f9; padding: 16px 0;">
                                        <!-- Root Comment -->
                                        <div class="lf-comment-main">
                                            <div class="lf-comment-header" style="display:flex; justify-content:space-between; margin-bottom:6px;">
                                                <a href="javascript:void(0);" onclick="showContactInfo('${fn:escapeXml(senderNames[c.userId])}', '${fn:escapeXml(commenters[c.userId].phoneNumber)}', ${not empty sessionScope.currentUser})" class="lf-comment-user" style="font-weight:700; color:#0f172a; text-decoration:none; cursor:pointer;">
                                                    👤 ${senderNames[c.userId]}
                                                </a>
                                                <span class="lf-comment-time" style="font-size:0.8rem; color:#94a3b8;">${c.createdAt}</span>
                                            </div>
                                            <div class="lf-comment-body" style="color:#334155; line-height:1.5; font-size:0.95rem;">${c.message}</div>
                                            
                                            <!-- Reply Button -->
                                            <c:if test="${not empty sessionScope.currentUser}">
                                                <div style="margin-top: 8px;">
                                                    <a href="javascript:void(0);" onclick="toggleReplyForm(${c.messageId})" style="font-size:0.85rem; font-weight:600; color:#0284c7; text-decoration:none;">↩️ Trả lời</a>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Nested Replies -->
                                        <div class="lf-comment-replies" style="margin-left: 36px; margin-top: 12px; padding-left: 14px; border-left: 2px solid #e2e8f0;">
                                            <c:forEach var="replyNode" items="${node.replies}">
                                                <c:set var="r" value="${replyNode.comment}"/>
                                                <div class="lf-reply-item" id="comment-${r.messageId}" style="margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px dashed #f1f5f9;">
                                                    <div class="lf-comment-header" style="display:flex; justify-content:space-between; margin-bottom:4px;">
                                                        <a href="javascript:void(0);" onclick="showContactInfo('${fn:escapeXml(senderNames[r.userId])}', '${fn:escapeXml(commenters[r.userId].phoneNumber)}', ${not empty sessionScope.currentUser})" class="lf-comment-user" style="font-weight:700; color:#475569; font-size:0.9rem; text-decoration:none; cursor:pointer;">
                                                            👤 ${senderNames[r.userId]}
                                                        </a>
                                                        <span class="lf-comment-time" style="font-size:0.75rem; color:#94a3b8;">${r.createdAt}</span>
                                                    </div>
                                                    <div class="lf-comment-body" style="color:#475569; line-height:1.4; font-size:0.9rem;">${r.message}</div>
                                                </div>
                                            </c:forEach>

                                            <!-- Inline Reply Form (hidden by default) -->
                                            <c:if test="${not empty sessionScope.currentUser}">
                                                <div id="reply-form-box-${c.messageId}" style="display:none; margin-top: 12px; background:#f8fafc; padding:12px; border-radius:6px; border:1px solid #e2e8f0;">
                                                    <form action="${pageContext.request.contextPath}/item_detail" method="post" class="lf-form">
                                                        <input type="hidden" name="action" value="send_message">
                                                        <input type="hidden" name="item_id" value="${itemDetail.itemId}">
                                                        <input type="hidden" name="parent_id" value="${c.messageId}">
                                                        <div class="lf-form-group mb-sm" style="margin-bottom:8px;">
                                                            <textarea name="message" class="lf-textarea" style="background:white; min-height:60px; border-radius:6px; font-size:0.9rem; padding:8px;" placeholder="Viết phản hồi..." required minlength="2"></textarea>
                                                        </div>
                                                        <div style="text-align:right;">
                                                            <button type="button" onclick="toggleReplyForm(${c.messageId})" class="btn btn-ghost btn-sm" style="padding:4px 12px; font-size:0.8rem; margin-right:8px;">Hủy</button>
                                                            <button type="submit" class="btn btn-primary btn-sm" style="background:#0284c7; border-color:#0284c7; padding:4px 16px; font-size:0.8rem; color:white; border-radius:6px; border:1px solid #0284c7;">Gửi</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align:center; color:#94a3b8; padding:30px 0;">Chưa có bình luận nào. Hãy là người đầu tiên!</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Right: Related Posts Sidebar -->
                <div class="lf-related-column">
                    <h3 class="lf-section-title mb-md" style="border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; display:flex; align-items:center; gap:8px;">
                        <span style="width:4px; height:18px; background:red; display:inline-block; border-radius:2px;"></span> BÀI VIẾT LIÊN QUAN
                    </h3>
                    
                    <div class="lf-related-list">
                        <c:choose>
                            <c:when test="${not empty relatedItems}">
                                <c:forEach var="rit" items="${relatedItems}">
                                    <div class="lf-related-item">
                                        <c:choose>
                                            <c:when test="${not empty relatedImages[rit.itemId]}">
                                                <img src="${pageContext.request.contextPath}/${relatedImages[rit.itemId]}" alt="${rit.title}" class="lf-related-img">
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="demoIdx" value="${(rit.itemId % 4) + 1}"/>
                                                <img src="${pageContext.request.contextPath}/uploads/demo/demo_${demoIdx}.png" alt="${rit.title}" class="lf-related-img">
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="lf-related-info">
                                            <a href="${pageContext.request.contextPath}/item_detail?id=${rit.itemId}" class="lf-related-title">${rit.title}</a>
                                            <div class="lf-related-meta">
                                                <span class="badge" style="background:#e2e8f0; color:#475569; padding:2px 6px; font-size:0.7rem;">
                                                    <c:choose>
                                                        <c:when test="${rit.type eq 'lost'}">Đồ mất</c:when>
                                                        <c:otherwise>Đồ nhặt được</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span style="font-size:0.75rem; color:#94a3b8;">
                                                    <fmt:formatDate value="${rit.createdAt}" pattern="dd/MM/yyyy"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align:center; color:#94a3b8; padding:30px 0; font-size:0.9rem;">Không có bài viết liên quan</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>
    </main>

    <lf:footer />
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

<!-- Contact User Modal -->
<div id="contactModal" class="lf-modal-overlay">
    <div class="lf-modal" style="max-width:400px; padding: 24px; text-align: center;">
        <button class="lf-modal__close" onclick="closeContactModal()">&times;</button>
        <h3 style="font-weight: 800; color: var(--txt-primary); margin-top: 10px; margin-bottom: 8px; font-size:1.3rem;">Thông tin liên hệ</h3>
        <div style="font-size: 1.05rem; font-weight: 700; color: #475569; margin-bottom: 20px;" id="contactUserName">Người dùng</div>
        <div style="background: #f1f5f9; padding: 16px; border-radius: 8px; font-size: 1.5rem; font-weight: 800; color: #0284c7; margin-bottom: 24px; letter-spacing: 1px;" id="contactPhoneNumber">0123456789</div>
        <div style="display: flex; gap: 12px;">
            <button type="button" class="btn btn-secondary flex-1" style="background:#f3f4f6; color:#374151; border:1px solid #d1d5db;" onclick="closeContactModal()">Đóng</button>
            <a href="#" id="contactCallBtn" class="btn btn-primary flex-1" style="background:#0284c7; border-color:#0284c7; text-decoration:none; display:flex; align-items:center; justify-content:center; gap:8px; font-weight:700; color:white; border-radius:6px;">
                📞 Gọi ngay
            </a>
        </div>
    </div>
</div>

<!-- Custom Confirm Modal -->
<div class="lf-modal-overlay" id="confirmModal">
    <div class="lf-modal" style="max-width:400px;">
        <button class="lf-modal__close" onclick="closeConfirmModal()">&times;</button>
        <h3 class="lf-modal__title">Xác nhận</h3>
        <p class="text-sm mb-md" id="confirmText" style="color:var(--txt-primary); margin-top:15px; margin-bottom:20px; font-size:0.95rem;">Bạn chắc chắn muốn thực hiện hành động này?</p>
        <div class="flex gap-sm mt-sm">
            <button type="button" class="btn btn-secondary flex-1" style="background:#f3f4f6; color:#374151; border:1px solid #d1d5db;" onclick="closeConfirmModal()">Hủy</button>
            <button type="button" class="btn btn-primary flex-1" id="confirmBtn" style="background:#fd7e14; border-color:#fd7e14;">Đồng ý</button>
        </div>
    </div>
</div>

<script>
    let pendingFormToSubmit = null;
    let pendingButtonVal = null;

    function showConfirm(event, text, buttonValue) {
        event.preventDefault();
        pendingFormToSubmit = event.target.closest('form');
        pendingButtonVal = buttonValue;
        
        document.getElementById('confirmText').innerText = text;
        document.getElementById('confirmModal').classList.add('open');
    }

    function closeConfirmModal() {
        document.getElementById('confirmModal').classList.remove('open');
        pendingFormToSubmit = null;
        pendingButtonVal = null;
    }

    document.getElementById('confirmBtn').addEventListener('click', function() {
        if (pendingFormToSubmit) {
            if (pendingButtonVal) {
                let hiddenInput = pendingFormToSubmit.querySelector('input[name="decision"]');
                if (!hiddenInput) {
                    hiddenInput = document.createElement('input');
                    hiddenInput.type = 'hidden';
                    hiddenInput.name = 'decision';
                    pendingFormToSubmit.appendChild(hiddenInput);
                }
                hiddenInput.value = pendingButtonVal;
            }
            pendingFormToSubmit.submit();
        }
        closeConfirmModal();
    });

    function toggleReplyForm(commentId) {
        const formBox = document.getElementById('reply-form-box-' + commentId);
        if (formBox) {
            if (formBox.style.display === 'none' || formBox.style.display === '') {
                formBox.style.display = 'block';
                formBox.querySelector('textarea').focus();
            } else {
                formBox.style.display = 'none';
            }
        }
    }

    function showContactInfo(fullName, phoneNumber, isLoggedIn) {
        if (!isLoggedIn) {
            alert('Bạn cần đăng nhập để xem số điện thoại liên hệ!');
            return;
        }
        if (!phoneNumber || phoneNumber.trim() === '' || phoneNumber.trim() === 'null') {
            alert('Người dùng này chưa cập nhật số điện thoại.');
            return;
        }
        document.getElementById('contactUserName').innerText = fullName;
        document.getElementById('contactPhoneNumber').innerText = phoneNumber;
        document.getElementById('contactCallBtn').href = 'tel:' + phoneNumber;
        document.getElementById('contactModal').classList.add('open');
    }

    function closeContactModal() {
        document.getElementById('contactModal').classList.remove('open');
    }
</script>
</body>
</html>

