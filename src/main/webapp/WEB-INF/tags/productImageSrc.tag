<%@ tag pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ attribute name="url" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="u" value="${url}" />
<c:if test="${u != null}"><c:set var="u" value="${fn:trim(u)}" /></c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:choose>
    <c:when test="${empty u}"></c:when>
    <c:when test="${fn:startsWith(u, 'http://') or fn:startsWith(u, 'https://')}"><c:out value="${u}" /></c:when>
    <c:when test="${fn:startsWith(u, '/')}"><c:out value="${ctx}${u}" /></c:when>
    <c:when test="${fn:contains(u, 'assets/images/products')}"><c:out value="${ctx}/${u}" /></c:when>
    <c:otherwise><c:out value="${ctx}/assets/images/products/${u}" /></c:otherwise>
</c:choose>
