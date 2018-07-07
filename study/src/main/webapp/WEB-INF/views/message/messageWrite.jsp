<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="" name="pageTitle"/></jsp:include>




<form action="${rootPath }/message/messageWriteEnd" method="POST">
	<input type="text" name="receivermno"/>
	<input type="text" name="content"/>
	<input type="submit" value="눌러" />
</form>










<jsp:include page ="/WEB-INF/views/common/footer.jsp" />
