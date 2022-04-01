<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="vo.*" %>
<%
	//null 체크
	if(request.getParameter("guestbookNo")==null){//guestbookNo가 없으면 list로 돌려보냄
		response.sendRedirect(request.getContextPath()+"/guestbook/guestbookList.jsp?msg=null");
		return;
	}
	
	//요청값 받기
	int guestbookNo = Integer.parseInt(request.getParameter("guestbookNo"));
	System.out.println(guestbookNo+"<-no");
	
	String msg =""; // 에러메세지 받을 변수 초기화
	if (request.getParameter("msg")!=null){
		System.out.println(request.getParameter("msg")+"<msg");
		msg = "비밀번호가 맞지 않습니다.";
	}
	
	//dao값 받기
	GuestbookDao guestbookDao = new GuestbookDao();
	Guestbook g = new Guestbook();
	g = guestbookDao.selectGuestbookOne(guestbookNo);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>방명록 수정 form</title>
</head>
<body class = "container">
	<h1>방명록 수정 폼</h1>
	<h2><%=msg%></h2>
	<form method = "post" action = "<%=request.getContextPath()%>/guestbook/updateGuestbookAction.jsp">
		<table class = "table">
			<tr>
				<td>방명록 번호</td>
				<td><input type = "text" name ="guestbookNo"  value="<%=g.getGuestbookNo() %>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>방명록 내용</td>
				<td>
				<textarea cols="120" name ="guestbookContent"><%=g.getGuestbookContent()%></textarea>
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name ="guestbookPw"></td>
			</tr>
			<tr>
				<td colspan = "2">
					<button type ="submit" class = "btn btn-info">수정</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>