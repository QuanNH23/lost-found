<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="role" required="true" type="java.lang.String"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${role eq 'admin'}"><span class="badge badge-danger">⚙️ Admin</span></c:when>
    <c:otherwise><span class="badge badge-primary">🎓 Student</span></c:otherwise>
</c:choose>
