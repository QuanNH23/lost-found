<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="icon" required="false" type="java.lang.String" %>
<%@ attribute name="title" required="true" type="java.lang.String" %>
<%@ attribute name="sub" required="true" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="lf-card mb-lg">
    <div class="lf-empty">
        <div class="lf-empty__icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linecap="round" class="text-muted" style="opacity: 0.5;">
                <path d="M22 12h-6l-2 3h-4l-2-3H2"/>
                <path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/>
            </svg>
        </div>
        <div class="lf-empty__title">${title}</div>
        <div class="lf-empty__sub">${sub}</div>
    </div>
</div>
