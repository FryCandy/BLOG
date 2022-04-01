<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import = "java.util.*" %>
<%@ page import= "vo.*" %>
<%
	//변수 선언 및 요청 값 저장
	int currentPage =1; //현재 페이지
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+"<-cuurentPage");
	int rowPerPage=3; // 한페이지의 행의 수
	int colPerPage=5; // 한행의 열의 수
	int imageArray = 0; // 이미지 나열 방식을 받을 변수
	if(request.getParameter("imageArray")!=null){
		imageArray = Integer.parseInt(request.getParameter("imageArray"));
	}
	System.out.println(imageArray+"<-imageArray");
	switch (imageArray){ // imageArray값에 따라 이미지 배열 변경
	case 22 : //2행 2열로 설정
		rowPerPage=2;
		colPerPage=2;
		break;
	case 33 : // 3행 3열로 설정
		rowPerPage=3;
		colPerPage=3;
		break;
	case 44 ://4행 4열로 설정
		rowPerPage=4;
		colPerPage=4;
		break;
	case 55 ://5행 5열로 설정
		rowPerPage=5;
		colPerPage=5;
		break;
	}
	System.out.println(rowPerPage+"<-rowPerPage");
	System.out.println(colPerPage+"<-colPerPage");
	int minPage=1; // 맨 밑 숫자목록 첫 표시 문자
	if (request.getParameter("minPage")!=null){
		minPage = Integer.parseInt(request.getParameter("minPage"));
	}
	System.out.println(minPage+"<-MinPage");
	int totalPerPage=rowPerPage*colPerPage; //한페이지의 총 이미지 수
	int beginRow=(currentPage-1)*totalPerPage; // 시작 행
	
	//Dao 요청
	//1. photoList 받기
	PhotoDao photoDao = new PhotoDao();
	ArrayList<Photo> list = photoDao.selectPhotoListByPage(beginRow, totalPerPage);
 	//2. TotalRow 받기
 	int totalRow = photoDao.selectPhotoTotalRow(); 
 	//데이터 가공
	int lastPage = ((totalRow - 1) / totalPerPage + 1); //마지막 페이지를 구하는 연산식
 	
 	%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>photoList</title>
</head>
<body class ="container">
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>이미지 목록</h1>
			<!-- 메인 메뉴 -->
			<!-- request.getC..(컨텍스명,프로젝트명)을 안써도 된다. include는 내부 요청이기 때문이다. -->
			<jsp:include page="/inc/upMenu.jsp"></jsp:include>
			<!-- 메인 메뉴 끝 -->
		</div>
	</div>
	<!-- 중단 자리 -->
	<!-- 페이징용 form 선언 -->
	<form method ="post" action = "<%=request.getContextPath()%>/photo/photoList.jsp">
	<!-- 이미지 등록 -->
	<div class ="row"><!--이미지 등록이랑 나열select가 한줄에 나오게 div 나눔  -->
		<div class="col">
			<a href = "<%=request.getContextPath()%>/photo/insertPhotoForm.jsp" type = button >이미지 등록</a>
		</div>
	<!-- 이미지가 나열되는 모습 변경 -->
		<div class ="col text-right">
			<select name = "imageArray" onchange = "this.form.submit()">
				<option value = <%=imageArray%>>나열될 모양을 선택하세요</option>
				<option value = "22">2 X 2</option>
				<option value = "33">3 X 3</option>
				<option value ="44" >4 X 4</option>
				<option value = "55">5 X 5</option>
			</select>
		</div>
	</div>
	<!-- 이미지 목록 -->
	<table class = "table">
		<tr>
	<%
		for(int i =0;i<list.size();i=i+1){
	%>
			<td>
				<a href="<%=request.getContextPath()%>/photo/selectPhotoOne.jsp?photoNo=<%=list.get(i).getPhotoNo()%>">
					<img src="<%=request.getContextPath()%>/upload/<%=list.get(i).getPhotoName()%>" width=<%=900/colPerPage%> height=<%=900/rowPerPage %>>
					<!-- 상세보기에서는 원본 이미지 크기로 -->
				</a>
			</td>
	<%
			if(i !=totalPerPage && (i+1)%colPerPage == 0){
	%>
		</tr><tr>
	<%
			}
		}
	%>
		</tr>
	</table>
	<!-- 페이지 목록 표시 부분 -->
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
</body>
</html>








