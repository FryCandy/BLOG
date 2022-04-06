<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "dao.*" %>
<%
	request.setCharacterEncoding("utf-8");//인코딩
	
	//변수 선언
	String categoryName = "전체";//cateName 기본값 ="전체"
	int currentPage =1; // 현재페이지의 기본값이 1페이지
	int minPage =1; // 목록 첫 페이지 표시 숫자 1
	int rowPerPage = 10; //페이지당 게시글 수 기본 값 10
	int totalRow = 0; //전체 행의 수 변수 초기화
	int lastPage = 0; // 마지막 페이지 변수 초기화
	
	//요청값 받기
	//1. categoryName 값 받기
	if(request.getParameter("categoryName")!=null){
		categoryName = request.getParameter("categoryName");
	}
	//2. currentPage 받기
	//boardList페이지 실행하면 최근 10개의 목록을 보여주고 1page로 설정
	if(request.getParameter("currentPage")!=null){ //currentPage값이 null이 아니라면
		currentPage = Integer.parseInt(request.getParameter("currentPage")); //currentPage값 수정
	}
	System.out.println(currentPage+"<--currentPage");
	//3. rowPerPage 받기
	if(request.getParameter("rowPerPage")!= null){//rowPerPage가 null이 아니면 요청값 저장
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	//4. minPage 받기
	if(request.getParameter("minPage")!= null){//minPage가 null이 아니면 요청값 저장
		minPage = Integer.parseInt(request.getParameter("minPage"));
		currentPage = minPage; //목록이 넘겨졌을때 가장 작은수의 페이지로 보여주기
	}else{
	minPage=(currentPage-1)/10*10+1; //페이지를 눌러서 왔을때 minPage 값 설정
	}
	//디버깅
	System.out.println(categoryName+"<-categoryName"); //categoryName 디버깅
	System.out.println(currentPage+"<-currentPage");//현재 페이지 디버깅
	System.out.println(rowPerPage+"<-rowPerPage");//게시글 수 디버깅
	System.out.println(minPage+"<-minPage");//목록 첫페이지 표시 숫자 디버깅
	
	//title 검색기능 추가
	String title = "";
	if(request.getParameter("title")!=null){
		title = request.getParameter("title");
		System.out.println(title+"title");
	}
	
	//dao 값 받기
	BoardDao boardDao = new BoardDao();
	//1. 카테고리 리스트 받기
	ArrayList<HashMap<String,String>> categoryList = boardDao.categoryList();
	//2.categoryName에 따른 게시판 리스트 받기 //+title 검색기능 추가
	int beginRow = (currentPage-1)*rowPerPage; //현재페이지가 변경되면 beginRow도 변경된다.
	ArrayList<Board> boardList = boardDao.boardList(categoryName,title, beginRow, rowPerPage);

	
	//데이터 가공
	//1.카테고리 별 전체 행의 수 ----- 검색기능 추가로 totalRow 구하는 메서드 새로 생성
	//전체 행의 수 = 그 카테고리 내의 cnt 수
	//categoryName이 일치하는 행을 찾으면 그 categoryName에 따른 행의 수 출력
	/* 
	for( HashMap<String,String> m : categoryList){	
		if(m.get("categoryName").equals(categoryName)){
		System.out.println(m.get("categoryName")+"<-totalrow관련카테고리이름");//디버깅
		totalRow = Integer.parseInt(m.get("categoryCount")); // totalRow에 카테고리 전체 행의 수 저장
		}
	}
	*/
	//BoardDao 에서 totalRow 값 호출
	totalRow=boardDao.totalRow(categoryName, title);
	//2.totalRow 결과 값으로 마지막 페이지 구하기
	lastPage = ((totalRow - 1) / rowPerPage + 1); //마지막 페이지를 구하는 연산식
	System.out.println(totalRow+"<-totalRow"); //총 게시물의 갯수 디버깅
	System.out.println(lastPage+"<-lastPage");//마지막 페이지 디버깅
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>boardList</title>
	<!-- category별 게시글 링크 메뉴 -->
	<style>

	</style>
	
</head>
<body>
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>게시판</h1>
			<!-- 메인 메뉴 -->
			<!-- request.getC..(컨텍스명,프로젝트명)을 안써도 된다. include는 내부 요청이기 때문이다. -->
			<jsp:include page="/inc/upMenu.jsp"></jsp:include>
			<!-- 메인 메뉴 끝 -->
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
						<!-- reqest.getContextPath() : 현재 프로젝트 명을 가지고온다. -->
					</li>
				<%
					}
				%>
			</ul>
		</div>
		<!-- 우측 메인 게시판 -->
		<div class="col-sm-10">
			<!-- 게시글 갯수 변경하기 -->
			<form method ="post" action ="<%=request.getContextPath()%>/board/boardList.jsp">
				<div class="row"> <!--현재 보여지는 게시글수, 게시글수 변경 한줄에 나오게 쪼개기  -->
					<div class ="col-sm-6">
					<!-- 게시글수 변경시 카테고리명도 같이 넘어가게 끔 같이 보냄-->
					현재 카테고리 : <input name = "categoryName" value =<%=categoryName%> readonly="readonly">
					<br>
					현재 보여지는 게시글 수 : <%=rowPerPage %>개
					</div>
					<div class ="col-sm-6 text-left">
						<p class ="text-right"> 게시글 수 변경 :
							<select name ="rowPerPage" onchange ="this.form.submit()" >
								<option value = <%=rowPerPage%>>게시글수를 선택하세요</option>
								<option value ="2">	2</option>
								<option value ="10">10</option>
								<option value ="20">20</option>
								<option value ="30">30</option>
								<option value ="50">50</option>
							</select>
						<p>
					</div>
				</div>
				<!-- 게시글 리스트 -->
				<table class="table table-bordered">
					<thead>
						<tr>
							<th>category_name</th>
							<th>board_title</th>
							<th>create_date</th>
						</tr>
					</thead>
					<tbody>
						<%
							for(Board b : boardList) {
						%>
						<tr>
							<td><%=b.getCategoryName()%></td>
							<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>"><%=b.getBoardTitle()%></a></td>
							<td><%=b.getCreateDate() %></td>
						</tr>
						<%
							}
						%>
					</tbody>
				</table>
				<!--board 입력과 검색입력, 현재페이지가 모두 나올수 있게 쪼개기  -->
				<div	class ="row">
					<div class = "col-sm-2">
						<strong>현재 페이지 : <%=currentPage %></strong>
					</div>
					<!-- title검색기능 -->
					<div class = "col-sm-7">
						<strong>title 검색:  </strong>
						<input type="text" name="title" value="<%=title%>" size="50">
					</div>
					<div class = "col-sm-3">
					<!-- 검색,게시글 생성 버튼  -->
					<p class="text-right"><button type = "submit" class="btn btn-outline-info">검색</button><a type = "button" class="btn btn-primary" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">board 입력</a></p>
					</div>
				</div>
				<!-- 페이지 목록 표시 부분 -->
				<div>
				<!-- 이전 목록 표시 -->
				<%
					if(minPage > 10){
				 %>
				 		<button type = "submit" value ="<%=minPage-10%>" name = "minPage" class="btn btn-outline-secondary" >이전목록</button>
				 <%
					}
				 %>
				<!-- 이전 부분 -->
				<%
					if(currentPage>1){
				%>
				 		<button type = "submit" value ="<%=currentPage-1%>" name = "currentPage" class="btn btn-outline-secondary" >이전</button>
				<%
					}
				%>
				<!-- 목록 사이 번호 표시 -->
				<%
					for(int i = minPage; i<minPage+10; i=i+1){
						if(i<=lastPage){
							if(currentPage==i){
				%>
							<button type = "submit" value ="<%=i%>" name = "currentPage" class="btn btn-outline-primary"><%=i%></button>
				<%
							}else{
				%>
							<button type = "submit" value ="<%=i%>" name = "currentPage" class="btn btn-light"><%=i%></button>
				<%
							}
						}
					}	
				%>
				<!-- 다음 부분 -->
				<%
					if(currentPage<lastPage){
				%>
			 		<button type = "submit" value ="<%=currentPage+1%>" name = "currentPage" class="btn btn-outline-secondary" >다음</button>
				<%
					}
				%>
				<!-- 다음목록 표시 -->
				<%
					if(minPage+10<=lastPage){
				 %>
				 		<button type = "submit" value ="<%=minPage+10%>" name = "minPage" class="btn btn-outline-secondary">다음목록</button>
				 <%
					}
				 %>
				 </div>
			</form>	
		</div>
	</div>
</body>
</html>