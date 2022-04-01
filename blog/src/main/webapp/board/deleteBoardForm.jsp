<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	//널 체크
	if(request.getParameter("boardNo")==null){ // boardNo가 null일경우 boardList로 돌려보냄
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}

	//요청값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // boardNo 받기
	System.out.println(boardNo+"<--boardNo");//디버깅
	String msg = " "; //에러 값 받기
	if(request.getParameter("msg") != null){
		msg = "비밀번호가 맞지 않습니다.다시 입력해주세요";
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<title>deleteBoardForm</title>
</head>
<body>
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
		<h1>blog 게시글 삭제</h1>
		<h2><%=msg %></h2><!-- 오류메세지 출력 -->
		</div>
	</div>
	<!-- 중단자리 -->
	<div class ="row container">
		<div class = "col-sm-12">
		<form method = "post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">
			<div class = "form-group text-center">
			게시글 번호:
			<input type = "text" name="boardNo" value ="<%=boardNo%>" readonly = "readonly"> <!-- 읽기전용 -->
			</div>
			<div class = "form-group text-center">
			비밀번호:
			<input type = "password" name="boardPw">
			</div>
			<div class = "form-group text-center">
			<button type = "submit" class="btn btn-danger">삭제</button>
			<a type ="button" class="btn btn-success" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>">뒤로</a>
			<a type ="button" class="btn btn-secondary" href="<%=request.getContextPath()%>/board/boardList.jsp">리스트</a>
			</div>
		</form>
		</div>
	</div>	
</body>
</html>