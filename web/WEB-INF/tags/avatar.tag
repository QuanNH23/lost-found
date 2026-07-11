<%@tag description="Avatar initial (last word of full name)" pageEncoding="UTF-8"%>
<%@attribute name="fullName" required="true" rtexprvalue="true" type="java.lang.String"%>
<%@attribute name="className" required="false" rtexprvalue="true" type="java.lang.String"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="__name" value="${fn:trim(fullName)}" />
<c:set var="__tokens" value="${fn:split(__name, ' ')}" />
<c:set var="__last" value="${__tokens[fn:length(__tokens)-1]}" />
<c:set var="__initial" value="${fn:toUpperCase(fn:substring(__last, 0, 1))}" />

<div class="${empty className ? 'lf-navbar__avatar' : className}">
    ${__initial}
</div>

