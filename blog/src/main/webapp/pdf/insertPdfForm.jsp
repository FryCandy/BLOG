<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//오류 메세지 처리
	String msg = "";
	if(request.getParameter("msg")!=null){
		msg ="이름이 비어있습니다.";
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>Insert Pdf form</title>
</head>
<body class="container">
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>PDF등록</h1>
			<h2><%=msg%></h2>
		</div>
	</div>
	<!-- 중단 자리 -->
	<form method="post" action="<%=request.getContextPath()%>/pdf/insertPdfAction.jsp" enctype="multipart/form-data">
		<table class = table>
			<tr>
				<td>PDF파일</td>
				<td>
					<input type ="file" name = "pdf">
				</td>
			</tr>
			<tr>
				<td>글쓴이</td>
				<td>
					<input type ="text" name = "writer">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type ="password" name = "pdfPw">
				</td>
			</tr>
		</table>
		<button type ="submit" class="btn btn-primary">PDF 등록</button>
	</form>
</body>
</html>