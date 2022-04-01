<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import ="vo.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="dao.*" %>
<%
	//널 체크
	if(request.getParameter("boardNo")==null){ // boardNo가 null일경우 boardList로 돌려보냄
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	//에러코드 받기
	String msg = " "; //msg가 들어갈 변수 선언 
	if(request.getParameter("msg") != null){
		if(request.getParameter("msg").equals("null")){//1. boardTitle 이 ""인 경우
			msg = "boardTitle을 입력해주세요";
		}else if(request.getParameter("msg").equals("error")){//2. 쿼리에 오류가 있어 입력이 안된경우
			msg = "비밀번호가 맞지 않습니다";
		}
	}
	
	
	//요청값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // boardNo 받기
	System.out.println(boardNo+"<--boardNo");//디버깅
	
	//dao 값 받기
	BoardDao boardDao = new BoardDao();
	//1. 카테고리 리스트 값 받기
	 ArrayList<HashMap<String,String>> categoryList = new ArrayList<HashMap<String,String>>();
	categoryList = boardDao.categoryList();
	
	//2. 수정전 boardOne 정보 가져오기
	Board board = new Board();
	board = boardDao.boardOne(boardNo);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>updateBoardForm</title>
</head>
<body>
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
	<h1> blog 게시글 수정</h1>
	<h2><%=msg %></h2>
		</div>
	</div>
	<!-- 중단자리 -->
	<div class = "row container">
		<!--카테고리 출력 -->
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
		<!-- 게시글 수정 -->
		<div class = "col-sm-10">
		<!-- 기존 게시물 출력 및 form-->
		<form method ="post" action="<%=request.getContextPath()%>/board/updateBoardAction.jsp">
		<table class="table table-bordered">
			<tr>
				<td class="font-weight-bold">boardNo</td>
				<td>
					<input type = "number" name ="boardNo" value=<%=board.getBoardNo()%> readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="font-weight-bold">categoryName</td>
				<td>
					<select name ="categoryName">
					<%
							for(HashMap<String,String> m : categoryList){
								if(m.get("categoryName").equals(board.getCategoryName())){ // 수정시 현재 카테고리 자동 체크
						%>
								<option selected="selected" value="<%=m.get("categoryName")%>"><%=m.get("categoryName") %></option>						
						<%
								}else if(m.get("categoryName").equals("전체")){ //전체는 선택하면 안됨으로 빈공간
									continue;
								}else{//자동 체크 안된 카테고리 name 출력
						%>
								<option value="<%=m.get("categoryName") %>"><%=m.get("categoryName") %></option>						
						<%
								}
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
					<td class="font-weight-bold">boardTitle</td>
					<td>
						<input type ="text" name="boardTitle"  value ="<%=board.getBoardTitle() %>" >
					</td>
			</tr>
			<tr>
				<td class="font-weight-bold">boardContent</td>
				<td>
					<textarea rows="5" cols="80" name="boardContent" ><%=board.getBoardContent() %> </textarea>
				</td>
			</tr>
			<tr>
				<td class="font-weight-bold">boardPw</td>
				<td>
					<input type ="password" name="boardPw" >
				</td>
			</tr>
		</table>
		<button type ="submit" class="btn btn-primary">수정</button>
		<a type ="button" class="btn btn-success" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>">뒤로</a>
		<a type ="button" class="btn btn-secondary" href="<%=request.getContextPath()%>/board/boardList.jsp">리스트</a>
		</form>
		</div>
	</div>
</body>
</html>























