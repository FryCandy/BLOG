<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import ="dao.*" %>
<%@ page import ="vo.*" %>
<%

	//변수선언 및 요청 값 저장
	int currentPage = 1; //현재 페이지 변수
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+"<-currentPage");
	int rowPerPage = 5; // 페이지 당 행 수
	if(request.getParameter("rowPerPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	System.out.println(rowPerPage+"<-rowPerPage");
	int beginRow = (currentPage-1)*rowPerPage; // 페이지에서 시작 행
	int lastPage = 0; //마지막 페이지 변수 선언
	int totalRow =0; // 총 행의 수 변수 선언
	int minPage =1; // 맨밑 숫자목록 첫 표시 숫자
	
	//Dao 받기
	GuestbookDao  guestbookDao = new GuestbookDao();
	//list 데이터 받기
	ArrayList<Guestbook> list = guestbookDao.selectGuestBookList(beginRow,rowPerPage);
	//총 행의 수
	totalRow = guestbookDao.selectGuestbookTotalRow();
	System.out.println(totalRow+"<-totalRow");
	//마지막 페이지
	//Math.ceil = 올림하는 메서드 반환 값 double
	lastPage = (int)(Math.ceil((double)totalRow/(double)rowPerPage));
	System.out.println(lastPage+"<-lastPage");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>guestbookList</title>
</head>
<body class = container>
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>방명록</h1>
			<!-- 메인 메뉴 -->
			<!-- request.getC..(컨텍스명,프로젝트명)을 안써도 된다. include는 내부 요청이기 때문이다. -->
			<jsp:include page="/inc/upMenu.jsp"></jsp:include>
			<!-- 메인 메뉴 끝 -->
		</div>
	</div>
	<!--List 부분 -->
	<table class="table table-hover">
			<%
				for( Guestbook g : list){
			%>
		<tr>
			<td>
				<!-- table 내 상단, 작성자와 업데이트 날짜 -->
				<div class ="row">
					<div class = "col-sm-6">작성자 : <%=g.getWriter()%></div>
					<div  class = "col-sm-6"><P class="text-right"><%=g.getUpdateDate()%></P></div>
				</div>
				<!-- table 내 중단, content -->
				<div class="row">
					<textarea cols ="120"><%=g.getGuestbookContent() %></textarea>
				</div>
				<!-- table 내 하단, 수정, 삭제 -->
				<div class="row">
					<div class = "col-sm-12">
						<P class ="text-right">
							<a  type = "button" href ="<%=request.getContextPath()%>/guestbook/updateGuestbookForm.jsp?guestbookNo=<%=g.getGuestbookNo()%>" class="btn btn-link">수정</a>
							<a  type = "button" href ="<%=request.getContextPath()%>/guestbook/deleteGuestbookForm.jsp?guestbookNo=<%=g.getGuestbookNo()%>" class="btn btn-link">삭제</a>
						</P>
					</div>
				</div>
					<%					
						}
					%>
			</td>
		</tr>	
	</table>
	<!-- 페이지 목록 표시 부분 -->
	<form method ="post" action = "<%=request.getContextPath()%>/guestbook/guestbookList.jsp">
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
	</form>
	<!--  하단, 방명록 입력 form 부분 -->
	<form method = "post" action="<%=request.getContextPath()%>/guestbook/insertGuestbookAction.jsp">
		<table class="table">
			<tr>
				<td>글쓴이 :</td>
				<td>
					 <input type = "text" name ="writer">
				</td>
			</tr>
			<tr>	
				<td>	내용 :</td>
				<td>
				 	<textarea cols="120" name ="guestbookContent"></textarea>
				</td>
			</tr>
			<tr>	
				<td>비밀번호 :</td>
				<td>
					 <input type ="password" name ="guestbookPw">
				</td>
			</tr>
		</table>
		<button type ="submit" class="btn btn-link"> 등록</button>
	</form>
</body>
</html>