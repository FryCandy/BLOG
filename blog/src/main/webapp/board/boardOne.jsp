<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "dao.*" %>
<%
	//널체크
	if(request.getParameter("boardNo")==null){ // boardNo가 null일경우 boardList로 돌려보냄
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		//request.getContextPath()는 현재 프로젝트 명을 나타냄
		return;
	}

	//요청값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // boardNo 받기
	System.out.println(boardNo+"<--boardNo");//디버깅
	
	//dao 값 받기
	BoardDao boardDao = new BoardDao();
	//카테고리 목록 받기
	ArrayList<HashMap<String,String>> categoryList = new ArrayList<HashMap<String,String>>();
	categoryList = boardDao.categoryList();
	//상세보기 데이터 받기
	Board board = new Board();
	board = boardDao.boardOne(boardNo);
	
		
		
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>Board 상세보기</title>
</head>
<body>
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>blog</h1>
		</div>
	</div>
	<!-- 중단 자리 -->
	<div class="row container">
		<!-- 좌측 카테고리 목록 출력 -->
		<div class="col-sm-2">
			<ul class="list-group">
			<%
				for( HashMap<String,String> m : categoryList){
			%>
				<li class="list-group-item d-flex justify-content-between align-items-center">
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?categoryName=<%=m.get("categoryName")%>"><%=m.get("categoryName")%><span class="badge badge-primary badge-pill"><%=m.get("categoryCount") %></span></a>
				</li>
			<%
				}
			%>
		</ul>
		</div>
		<!-- 우측 상세보기 출력 -->
		<div class="col-sm-10">
			<table class="table table-bordered">
				<tr>
					<td class="font-weight-bold">boardNo</td>
					<td><%=board.getBoardNo() %></td>
				</tr>
				<tr>
					<td class="font-weight-bold">category</td>
					<td><%=board.getCategoryName() %></td>
				</tr>
				<tr>
					<td class="font-weight-bold">boardTitle</td>
					<td><%=board.getBoardTitle() %></td>
				</tr>
				<tr>
					<td class="font-weight-bold">boardContent</td>
					<td><%=board.getBoardContent() %></td>
				</tr>
				<tr>
					<td class="font-weight-bold">createDate</td>
					<td><%=board.getCreateDate() %></td>
				</tr>
				<tr>
					<td class="font-weight-bold">updateDate</td>
					<td><%=board.getUpdateDate() %></td>
				</tr>
			</table>
			<a type ="button" class="btn btn-primary" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=board.getBoardNo()%>">수정</a>
			<a type ="button" class="btn btn-danger" href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=board.getBoardNo()%>">삭제</a>
			<a type ="button" class="btn btn-secondary" href="<%=request.getContextPath()%>/board/boardList.jsp?categoryName=<%=board.getCategoryName()%>">리스트</a>
		</div>
	</div>
</body>
</html>


















