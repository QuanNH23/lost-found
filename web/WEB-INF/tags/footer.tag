<%@tag description="Shared Footer" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<footer class="lf-footer" style="padding: 24px 0; background: white; border-top: 1px solid var(--clr-border); text-align: center; margin-top: 40px;">
    <div class="footer-links" style="display: flex; justify-content: center; gap: 24px; margin-bottom: 12px; font-weight: 500;">
        <c:if test="${sessionScope.userRole != 'admin'}">
            <a href="${pageContext.request.contextPath}/support" style="color: var(--txt-muted); text-decoration: none; font-size: 0.9rem;" onmouseover="this.style.color='var(--clr-primary)'" onmouseout="this.style.color='var(--txt-muted)'">Hỗ trợ</a>
        </c:if>
        <a href="#" style="color: var(--txt-muted); text-decoration: none; font-size: 0.9rem;" onmouseover="this.style.color='var(--clr-primary)'" onmouseout="this.style.color='var(--txt-muted)'">Mẹo tìm kiếm</a>
        <a href="#" style="color: var(--txt-muted); text-decoration: none; font-size: 0.9rem;" onmouseover="this.style.color='var(--clr-primary)'" onmouseout="this.style.color='var(--txt-muted)'">Chính sách bảo mật</a>
        <a href="#" style="color: var(--txt-muted); text-decoration: none; font-size: 0.9rem;" onmouseover="this.style.color='var(--clr-primary)'" onmouseout="this.style.color='var(--txt-muted)'">Điều khoản sử dụng</a>
    </div>
    <div style="font-size: 0.85rem; color: var(--txt-muted);">
        © 2026 PRJ301.2, FPT University. All rights reserved. School Lost &amp; Found Management System.
    </div>
</footer>
