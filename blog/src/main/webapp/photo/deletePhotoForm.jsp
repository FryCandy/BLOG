<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
	//널체크
	//이미지 번호가 없으면 리스트로 돌려보냄
	if (request.getParameter("photoNo")==null){
		response.sendRedirect(request.getContextPath()+"/photo/photoList.jsp?msg=null");
		return;
	}
	//요청 값 받기
	int photoNo = Integer.parseInt(request.getParameter("photoNo"));
	System.out.println(photoNo+"<-photoNo");
	//에러 값 받기
	String msg = "";
	if(request.getParameter("msg")!=null){
		msg = request.getParameter("msg");
		System.out.println(msg+"<-msg");
		if(msg.equals("error")){
			msg="비밀번호가 맞지 않습니다.";
		}
	}
	
 %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>deletePhotoForm</title>
</head>
<body class = container>
	<h1>이미지 삭제</h1>
	<h2><%=msg %></h2>
	<form method ="post" action ="<%=request.getContextPath()%>/photo/deletePhotoAction.jsp">
		<table class ="table">
			<tr>
				<td>이미지 번호</td>
				<td>
					<input type ="text" name="photoNo" value="<%=photoNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type ="password" name="photoPw">
				</td>
			</tr>
		</table>
		<button type ="submit" class="btn btn-danger">삭제</button>
		<a type ="button" href= "<%=request.getContextPath()%>/photo/selectPhotoOne.jsp?photoNo=<%=photoNo%>" class="btn btn-success">뒤로</a>
		<a type ="button" href="<%=request.getContextPath()%>/photo/photoList.jsp" class="btn btn-secondary" >리스트</a>
	</form>
</body>
</html>