<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tin của tôi — Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="lf-wrapper">
    <!-- ── NAVBAR ── -->
    <lf:navbar activeMenu="my_items" />

    <c:if test="${not empty sessionScope.message}">
        <script>
            window.addEventListener('DOMContentLoaded', function() {
                window.LF && window.LF.toast('${fn:escapeXml(sessionScope.message)}', 'success');
            });
        </script>
        <c:remove var="message" scope="session"/>
    </c:if>

    <main class="lf-main">
        <div class="lf-page-header">
            <h1 class="lf-page-header__title">Tin của tôi</h1>
            <p class="lf-page-header__sub">Quản lý tất cả các bài đăng của bạn</p>
        </div>

        <!-- Action bar -->
        <div class="flex flex-wrap gap-md mb-lg">
            <a href="${pageContext.request.contextPath}/report_lost?type=lost" class="btn btn-danger">🔴 Thêm báo mất mới</a>
            <a href="${pageContext.request.contextPath}/report_found"          class="btn btn-success">🟢 Thêm báo nhặt mới</a>
        </div>

        <!-- LOST ITEMS -->
        <div class="lf-section-title mb-md"><span class="dot"></span>Danh sách tin báo mất</div>
        <div class="lf-table-wrap mb-lg">
            <table class="lf-table">
                <thead>
                    <tr>
                        <th>ID</th><th>Tiêu đề</th><th>Danh mục</th><th>Vị trí</th>
                        <th>Loại</th><th>Trạng thái</th><th>Ngày tạo</th><th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="it" items="${lostMyItems}">
                        <tr>
                            <td><span class="badge badge-muted">#${it.itemId}</span></td>
                            <td class="fw-bold">${it.title}</td>
                            <td>${categoryNames[it.itemId]}</td>
                            <td>${locationNames[it.itemId]}</td>
                            <td><span class="badge badge-danger">🔴 ${it.type}</span></td>
                            <td>
                                <lf:statusBadge status="${it.status}" />
                            </td>
                            <td class="text-sm" style="color: white;">${it.createdAt}</td>
                            <td>
                                <div class="flex gap-sm flex-wrap">
                                    <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" class="btn btn-secondary btn-sm">🔍 Xem</a>
                                    <a href="${pageContext.request.contextPath}/edit_item?id=${it.itemId}"   class="btn btn-ghost btn-sm">✏️ Sửa</a>
                                    <form action="${pageContext.request.contextPath}/my_items" method="post"
                                          onsubmit="return confirm('Bạn chắc chắn muốn xóa bài đăng này?');" style="display:inline;">
                                        <input type="hidden" name="action"  value="delete">
                                        <input type="hidden" name="item_id" value="${it.itemId}">
                                        <button type="submit" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty lostMyItems}">
                        <tr><td colspan="8" class="td-empty">📭 Bạn chưa có tin báo mất nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- FOUND ITEMS -->
        <div class="lf-section-title mb-md"><span class="dot" style="background:var(--clr-success);box-shadow:0 0 8px rgba(16,185,129,.6);"></span>Danh sách tin báo nhặt</div>
        <div class="lf-table-wrap">
            <table class="lf-table">
                <thead>
                    <tr>
                        <th>ID</th><th>Tiêu đề</th><th>Danh mục</th><th>Vị trí</th>
                        <th>Loại</th><th>Trạng thái</th><th>Ngày tạo</th><th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="it" items="${foundMyItems}">
                        <tr>
                            <td><span class="badge badge-muted">#${it.itemId}</span></td>
                            <td class="fw-bold">${it.title}</td>
                            <td>${categoryNames[it.itemId]}</td>
                            <td>${locationNames[it.itemId]}</td>
                            <td><span class="badge badge-success">🟢 ${it.type}</span></td>
                            <td>
                                <lf:statusBadge status="${it.status}" />
                            </td>
                            <td class="text-sm" style="color: white;">${it.createdAt}</td>
                            <td>
                                <div class="flex gap-sm flex-wrap">
                                    <a href="${pageContext.request.contextPath}/item_detail?id=${it.itemId}" class="btn btn-secondary btn-sm">🔍 Xem</a>
                                    <a href="${pageContext.request.contextPath}/edit_item?id=${it.itemId}"   class="btn btn-ghost btn-sm">✏️ Sửa</a>
                                    <form action="${pageContext.request.contextPath}/my_items" method="post"
                                          onsubmit="return confirm('Bạn chắc chắn muốn xóa bài đăng này?');" style="display:inline;">
                                        <input type="hidden" name="action"  value="delete">
                                        <input type="hidden" name="item_id" value="${it.itemId}">
                                        <button type="submit" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty foundMyItems}">
                        <tr><td colspan="8" class="td-empty">📭 Bạn chưa có tin báo nhặt nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
    <footer class="lf-footer">© 2026 Group 8, SE2022, FPT University. All rights reserved. School Lost & Found Management System.</footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
