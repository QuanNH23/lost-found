<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin: Blacklist - Lost & Found</title>
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
            <span class="current">Blacklist SĐT</span>
        </div>

        <h1 class="lf-page-header__title mb-lg">Quản lý Blacklist SĐT</h1>

        <!-- FLASH MESSAGES -->
        <c:if test="${not empty sessionScope.message}">
            <div class="lf-alert lf-alert-success mb-md">
                <div>${sessionScope.message}</div>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>

        <div class="lf-grid-2">
            <div>
                <div class="lf-card mb-lg">
                    <div class="lf-card__title">Thêm số vào Blacklist</div>
                    <form action="blacklist" method="POST" class="lf-form">
                        <input type="hidden" name="action" value="add">
                        <div class="lf-form-group">
                            <label class="lf-label">Số điện thoại lừa đảo <span class="req">*</span></label>
                            <input type="text" name="phone" class="lf-input" placeholder="VD: 0987654321" required>
                        </div>
                        <button type="submit" class="btn btn-primary mt-sm">Thêm vào Blacklist</button>
                    </form>
                </div>
            </div>

            <div>
                <div class="lf-card">
                    <div class="lf-card__title">Danh sách SĐT Blacklist</div>
                    
                    <c:choose>
                        <c:when test="${not empty blacklistPhones}">
                            <div class="lf-table-wrap">
                                <table class="lf-table">
                                    <thead>
                                        <tr>
                                            <th>Số điện thoại</th>
                                            <th style="width:100px; text-align:right;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="phone" items="${blacklistPhones}">
                                            <tr>
                                                <td><span class="fw-bold text-danger">${phone}</span></td>
                                                <td style="text-align:right;">
                                                    <form method="POST" action="blacklist" style="display:inline;">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="phone" value="${phone}">
                                                        <button class="btn btn-sm btn-ghost" onclick="return confirm('Bỏ chặn SĐT này?');">Xóa</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <lf:emptyState title="Blacklist trống" sub="Chưa có SDT nào bị chặn."/>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="lf-card mt-md">
                    <div class="lf-card__title">Danh sách từ cấm (Chỉ đọc)</div>
                    <div class="flex flex-wrap gap-xs">
                        <c:forEach var="word" items="${badWords}">
                            <span class="badge badge-muted">${word}</span>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
