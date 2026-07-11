<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="status" required="true" type="java.lang.String"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${status == 'approved'}"><span class="badge badge-success">Đã duyệt</span></c:when>
    <c:when test="${status == 'pending'}"><span class="badge badge-warning">Chờ duyệt</span></c:when>
    <c:when test="${status == 'completed'}"><span class="badge badge-success">Hoàn thành</span></c:when>
    <c:when test="${status == 'cancel'}"><span class="badge badge-muted">Đã hủy</span></c:when>
    <c:otherwise><span class="badge badge-primary">${status}</span></c:otherwise>
</c:choose>
