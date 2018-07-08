<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="" name="pageTitle"/></jsp:include>




<form action="${rootPath }/message/messageWriteEnd" method="POST">
	<input type="text" name="receivermno" id="receiver"/>
	<input type="text" id="message" name="content"/>
	<input id ="sendBtn" type="submit" value="눌러" />
</form>










<jsp:include page ="/WEB-INF/views/common/footer.jsp" />
