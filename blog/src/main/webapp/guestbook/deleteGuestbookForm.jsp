<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import ="vo.*" %>
<%@page import ="dao.*" %>
<%
	//null 체크
	if(request.getParameter("guestbookNo")==null){
		response.sendRedirect(request.getContextPath()+"/guestbook/guestbookList.jsp?msg=null");
		return;
	}

	//요청값 받기
	//guestNo 받기
	int guestbookNo = Integer.parseInt(request.getParameter("guestbookNo"));
	System.out.println(guestbookNo+"<-guestbookNo");
	//에러 메세지 받기
	String msg =""; // 에러메세지를 넣을 변수 초기화 
	if(request.getParameter("msg")!=null){
		System.out.println(request.getParameter("msg")+"<msg");
		msg = "비밀번호가 맞지 않습니다";
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>deleteGuestbookForm</title>
</head>
<body class ="container">
	<h1>방명록 삭제 폼</h1>
	<h2><%=msg %></h2>
	<form method ="post" action ="<%=request.getContextPath()%>/guestbook/deleteGuestbookAction.jsp">
		<table class = "table">
			<tr>
				<td>방명록 번호 :</td>
				<td>
					<input type = "text" name = "guestbookNo" value ="<%=guestbookNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>	비밀번호를 입력해주세요 :</td>
				<td>
				<input type = "password" name = "guestbookPw">
				</td>
			</tr>
			<tr>
				<td colspan ="2">
					<button type = "submit" class = "btn btn-danger">삭제</button>
				</td>
			</tr>
		</table>
	</form>

</body>
</html>