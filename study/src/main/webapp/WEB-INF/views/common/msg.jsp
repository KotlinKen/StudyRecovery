<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="" name="pageTitle"/></jsp:include>

<script>
if(${msg ne null})
	alert("${msg}");
	
	location.href="${rootPath}${loc}";
</script>

<jsp:include page ="/WEB-INF/views/common/footer.jsp" />
