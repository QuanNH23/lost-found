<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="type" required="true" type="java.lang.String"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${type eq 'lost'}"><span class="badge badge-danger">Mất đồ</span></c:when>
    <c:otherwise><span class="badge badge-success">Nhặt được</span></c:otherwise>
</c:choose>
