<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="status" required="true" type="java.lang.String"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${status == 'active'}"><span class="badge" style="background:#d1fae5; color:#065f46; border:1px solid #10b981; font-weight:600; padding:4px 8px; border-radius:4px;">ACTIVE</span></c:when>
    <c:when test="${status == 'processing'}"><span class="badge" style="background:#fff7ed; color:#c2410c; border:1px solid #f97316; font-weight:600; padding:4px 8px; border-radius:4px;">PROCESSING</span></c:when>
    <c:when test="${status == 'completed'}"><span class="badge" style="background:#f3f4f6; color:#374151; border:1px solid #9ca3af; font-weight:600; padding:4px 8px; border-radius:4px;">COMPLETED</span></c:when>
    <c:otherwise><span class="badge" style="background:#e0f2fe; color:#0369a1; border:1px solid #38bdf8; font-weight:600; padding:4px 8px; border-radius:4px;">${status.toUpperCase()}</span></c:otherwise>
</c:choose>
