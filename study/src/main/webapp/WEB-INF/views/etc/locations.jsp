<%@page import="java.util.Map"%>
<jsp:include page ="/WEB-INF/views/common/header.jsp"><jsp:param value="위치" name="pageTitle"/></jsp:include>
<div class="container">
<div id="map" style="width:100%; height:400px;"></div>
privacy
</div>




<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0876641f2867b62cc533b0fbdc8d861c"></script>
<script>

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = { 
	center: new daum.maps.LatLng(37.499043, 127.032916), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};

var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

//마커가 표시될 위치입니다 
var markerPosition  = new daum.maps.LatLng(37.499043, 127.032916); 

//마커를 생성합니다
var marker = new daum.maps.Marker({
position: markerPosition
});

//마커가 지도 위에 표시되도록 설정합니다
marker.setMap(map);




</script>
<jsp:include page ="/WEB-INF/views/common/footer.jsp" />

