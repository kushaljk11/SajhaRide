<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:forward page="/WEB-INF/views/landing/landing.jsp" /><%
    response.sendRedirect(request.getContextPath() + "/landing");
%>
