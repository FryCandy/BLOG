<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.PdfDao" %>
<%@ page import = "vo.Pdf" %>
<%@ page import = "java.util.*" %>
<%
	//변수 선언 및 요청 값 저장
	int currentPage = 1; // 현재 페이지
	if (request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		System.out.println(currentPage+"<-currentPage");
	}
	int rowPerPage = 10; //페이지당 게시물 수
	if (request.getParameter("rowPerPage")!=null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
		System.out.println(rowPerPage+"<-rowPerPage");
	}
	int minPage = 1; // 페이징 첫번째 숫자 값
	if (request.getParameter("minPage")!=null){
		minPage = Integer.parseInt(request.getParameter("minPage"));
		System.out.println(minPage+"<-minPage");
	}
	int beginRow = (currentPage -1)*rowPerPage; //페이지당 시작 게시물 번호
		System.out.println(rowPerPage+"<-rowPerPage");
	
	//Dao 요청
	PdfDao pdfDao = new PdfDao();
	//Pdf 리스트 받기
	ArrayList<Pdf> pdfList = new ArrayList<Pdf>();
	pdfList = pdfDao.pdfList(beginRow, rowPerPage);
	//총 게시물 수 받기
	int totalRow = pdfDao.totalRow();
	
	//마지막 페이지 구하기
	int lastPage =  ((totalRow - 1) / rowPerPage + 1);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>PDFList</title>
</head>
<body class ="container">
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>PDF 자료실</h1>
			<!-- 메인 메뉴 -->
			<jsp:include page="/inc/upMenu.jsp"></jsp:include>
			<!-- 메인 메뉴 끝 -->
		</div>
	</div>
	<!-- 중단 자리 -->
	<!-- 페이징용 form 선언 -->
	<form method ="post" action = "<%=request.getContextPath()%>/pdf/pdfList.jsp">
	<!-- 이미지 등록 -->
	<div class ="row"><!-- pdf 등록이랑 게시물수 변경이 한줄에 나오게 div 나눔  -->
		<div class="col">
			<a href = "<%=request.getContextPath()%>/pdf/insertPdfForm.jsp" type = button >PDF 등록</a>
		</div>
	<!-- 게시물 수 변경 -->
		<div class ="col text-right">
			<select name = "rowPerPage" onchange = "this.form.submit()">
				<option value = <%=rowPerPage%>>게시물 수을 선택하세요</option>
				<option value = "2">2</option>
				<option value = "5">5</option>
				<option value ="10" >10</option>
				<option value = "20">20</option>
			</select>
		</div>
	</div>
	<!-- 게시판 목록 -->
	<table class = "table">
		<thead>
			<tr>
				<th>파일 이름</th>
				<th>작성자</th>
				<th>생성된 날짜</th>
				<th>수정된 날짜</th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Pdf p : pdfList){
			%>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/pdf/selectPdfOne.jsp?pdfNo=<%=p.getPdfNo()%>">
							<%=p.getPdfName() %>
						</a>
					</td>
				</tr>
			<%
					}
			%>
		</tbody>
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