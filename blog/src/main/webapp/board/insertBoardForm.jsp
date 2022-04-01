<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="dao.*" %>
<%
	//에러코드 받기
	String msg = " "; //msg가 들어갈 변수 선언 
	if(request.getParameter("msg") != null){
		msg =request.getParameter("msg");
	}
	if(msg.equals("space")){
		msg = "boardTitle을 입력해주세요";
	}else if(msg.equals("error")){
		msg="알수없는오류";
		}

	//dao 값 받기
	BoardDao boardDao = new BoardDao();
	//카테고리 리스트 값 받기
	 ArrayList<HashMap<String,String>> categoryList = new ArrayList<HashMap<String,String>>();
	categoryList = boardDao.categoryList();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>InsertBoardForm</title>
</head>
<body>	
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
		<h1>게시글 작성</h1>
		<h2><%=msg %></h2>
		</div>
	</div>
	<!-- 중단자리 -->
	<div class="row container">
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
		<!--게시물 작성란 출력  -->
		<div class = "col-sm-6">	
		<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
			<table class="table table-bordered">
				<tr>
					<td>categoryName</td>
					<td>
						<select name ="categoryName">
							<%
								for(HashMap<String,String> m : categoryList){ 
									if(m.get("categoryName").equals("전체")){ //전체는 출력하면 안됨으로 for문을 나감
										continue;
									}else {
							%>
									<option value="<%=m.get("categoryName")%>"><%=m.get("categoryName")%></option>						
							<%
									}
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td>boardTitle</td>
					<td>
						<input type = text name = "boardTitle">
					</td>
				</tr>
				<tr>
					<td>boardContent</td>
					<td>
						<textarea name="boardContent" rows="5"  cols="80"></textarea>
					</td>
				</tr>
				<tr>
					<td>boardPw</td>
					<td>
						<input type = password name = "boardPw">
					</td>
				</tr>
			</table>
				<div>
					<button type = "submit" class="btn btn-primary" >게시글 작성</button>
					<a type= "button" class="btn btn-secondary" href = "<%=request.getContextPath()%>/board/boardList.jsp">리스트로 돌아가기</a>
				</div>
			</form>
			</div>
		</div>
</body>
</html>