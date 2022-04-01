<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	//널체크 photoNo 정보가 없으면 list로 돌려보냄
	if (request.getParameter("photoNo")==null){
		response.sendRedirect(request.getContextPath()+"/photo/photoList.jsp?msg=null");
		return;
	}
	//변수 선언 및 요청값 받기
	int photoNo = Integer.parseInt(request.getParameter("photoNo"));	
	System.out.println(photoNo+"<-photoNo");
	
	// Dao 요청
	PhotoDao photoDao = new PhotoDao();
	Photo photo = new Photo();
	photo = photoDao.selectPhotoOne(photoNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>selectPhotoOne</title>
</head>
<body class ="container">
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>이미지 상세보기</h1>
			<!-- 메인 메뉴 -->
			<!-- request.getC..(컨텍스명,프로젝트명)을 안써도 된다. include는 내부 요청이기 때문이다. -->
			<jsp:include page="/inc/upMenu.jsp"></jsp:include>
			<!-- 메인 메뉴 끝 -->
		</div>
	</div>
	<!-- 중단자리 -->
	<!-- 리스트, 삭제 버튼 -->
	<p class = "text-right">
		<a type ="button" href="<%=request.getContextPath()%>/photo/photoList.jsp" class="btn btn-secondary" >리스트</a>
		<a type ="button" href="<%=request.getContextPath()%>/photo/deletePhotoForm.jsp?photoNo=<%=photo.getPhotoNo()%>" class="btn btn-danger">삭제</a>
	</p>
	<!-- 이미지 상세보기 테이블 -->
	<table class = "table">
		<tr>
			<td>이미지 이름</td>
			<td><%=photo.getPhotoName() %></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><%=photo.getWriter() %></td>
		</tr>
		<tr>
			<td>생성된 날짜</td>
			<td><%=photo.getCreateDate() %></td>
		</tr>
		<tr>
			<td>수정된 날짜</td>
			<td><%=photo.getUpdateDate()%></td>
		</tr>
		<tr>
			<td colspan = "2">
				<img src="<%=request.getContextPath()%>/upload/<%=photo.getPhotoName()%>">
			</td>
		</tr>
	</table>
</body>
</html>