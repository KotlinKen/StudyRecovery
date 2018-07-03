<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="rootPath" value="${pageContext.request.contextPath}" />
<c:set var="encoding" value="${pageContext.request.characterEncoding}"/>
<c:set var="method" value="${pageContext.request.method}"/>
<c:set var="where" value="${pageContext.request.requestURL}"/>
<c:set var="mber" value="${memberLoggedIn}"/>
<c:set var="nowDate"><fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd"/></c:set> 
<c:set var="pastDate"><fmt:formatDate value="<%= new java.util.Date(new java.util.Date().getTime() - 60*60*24*1000) %>" pattern="yyyy-MM-dd"/></c:set> 

