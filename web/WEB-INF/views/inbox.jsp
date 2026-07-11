<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hộp thư — Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">
    <!-- ── NAVBAR ── -->
    <lf:navbar activeMenu="inbox" />

    <main class="lf-main">
        <div class="lf-page-header">
            <h1 class="lf-page-header__title">Hộp thư</h1>
            <p class="lf-page-header__sub">Tin nhắn đến và đã gửi</p>
        </div>

        <!-- INBOX -->
        <div class="lf-section-title mb-md"><span class="dot"></span>Tin nhắn đến</div>
        <c:choose>
            <c:when test="${not empty inbox}">
                <c:forEach var="msg" items="${inbox}">
                    <div class="lf-inbox-msg" style="cursor:pointer;" onclick="window.location.href='${pageContext.request.contextPath}/item_detail?id=${msg.itemId}'">
                        <c:set var="__sn" value="${fn:trim(msg.senderName)}"/>
                        <c:set var="__st" value="${fn:split(__sn, ' ')}"/>
                        <c:set var="__sl" value="${__st[fn:length(__st)-1]}"/>
                        <c:set var="__si" value="${fn:toUpperCase(fn:substring(__sl, 0, 1))}"/>
                        <div class="lf-inbox-msg__avatar">${__si}</div>
                        <div class="lf-inbox-msg__body-wrap">
                            <div class="lf-inbox-msg__head">
                                <a class="lf-inbox-msg__sender"
                                   href="${pageContext.request.contextPath}/user_detail?id=${msg.senderId}">
                                    👤 ${msg.senderName}
                                </a>
                                <span class="lf-inbox-msg__date">${msg.createdAt}</span>
                            </div>
                            <div class="lf-inbox-msg__subject">📦 ${msg.itemTitle} — ${msg.title}</div>
                            <div class="lf-inbox-msg__preview">${msg.message}</div>
                            <div class="mt-sm">
                                <a href="${pageContext.request.contextPath}/item_detail?id=${msg.itemId}"
                                   class="btn btn-primary btn-sm">💬 Phản hồi</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <lf:emptyState title="Chưa có tin nhắn nào" sub="Hộp thư của bạn đang trống."/>
            </c:otherwise>
        </c:choose>

        <!-- OUTBOX -->
        <div class="lf-section-title mb-md mt-md"><span class="dot" style="background:var(--clr-teal);box-shadow:0 0 8px rgba(20,184,166,.6);"></span>Tin nhắn đã gửi</div>
        <c:choose>
            <c:when test="${not empty outbox}">
                <c:forEach var="msg" items="${outbox}">
                    <div class="lf-inbox-msg" style="border-color:rgba(20,184,166,0.15); cursor:pointer;" onclick="window.location.href='${pageContext.request.contextPath}/item_detail?id=${msg.itemId}'">
                        <div class="lf-inbox-msg__avatar" style="background:linear-gradient(135deg,#0d9488,#14b8a6);">📤</div>
                        <div class="lf-inbox-msg__body-wrap">
                            <div class="lf-inbox-msg__head">
                                <span class="lf-inbox-msg__sender">📦 ${msg.itemTitle}</span>
                                <span class="lf-inbox-msg__date">${msg.createdAt}</span>
                            </div>
                            <div class="lf-inbox-msg__subject">${msg.title}</div>
                            <div class="lf-inbox-msg__preview">${msg.message}</div>
                            <div class="mt-sm">
                                <a href="${pageContext.request.contextPath}/item_detail?id=${msg.itemId}"
                                   class="btn btn-ghost btn-sm">🔍 Xem lại bài</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <lf:emptyState title="Bạn chưa gửi tin nhắn nào" sub="" icon="📤"/>
            </c:otherwise>
        </c:choose>
    </main>
    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Add fn:substring support if needed
</script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
