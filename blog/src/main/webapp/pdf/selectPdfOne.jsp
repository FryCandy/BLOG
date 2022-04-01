<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	//널체크 pdfNo 정보가 없으면 list로 돌려보냄
	if (request.getParameter("pdfNo")==null){
		response.sendRedirect(request.getContextPath()+"/pdf/pdfList.jsp?msg=null");
		return;
	}
	//변수 선언 및 요청값 받기
	int pdfNo = Integer.parseInt(request.getParameter("pdfNo"));	
	System.out.println(pdfNo+"<-pdfNo");
	
	// Dao 요청
	PdfDao pdfDao = new PdfDao();
	Pdf pdf = new Pdf();
	pdf = pdfDao.selectPdfOne(pdfNo);
	//upload 경로지정 변수 선언
	String path = application.getRealPath("upload"); 
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
	<title>selectpdfOne</title>
</head>
<body class ="container">
	<!-- 상단 자리-->
	<div class="row container" >
		<div class = "col-sm-12 text-center">
			<h1>PDF 상세보기</h1>
			<!-- 메인 메뉴 -->
			<jsp:include page="/inc/upMenu.jsp"></jsp:include>
			<!-- 메인 메뉴 끝 -->
		</div>
	</div>
	<!-- 중단자리 -->
	<!-- 리스트, 삭제 버튼 -->
	<p class = "text-right">
		<a type ="button" href="<%=request.getContextPath()%>/pdf/pdfList.jsp" class="btn btn-secondary" >리스트</a>
		<a type ="button" href="<%=request.getContextPath()%>/pdf/deletePdfForm.jsp?pdfNo=<%=pdf.getPdfNo()%>" class="btn btn-danger">삭제</a>
	</p>
	<!-- PDF 상세보기 테이블 -->
	<table class = "table">
		<tr>
			<td>PDF 이름</td>
			<td><%=pdf.getPdfName() %></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><%=pdf.getWriter() %></td>
		</tr>
		<tr>
			<td>생성된 날짜</td>
			<td><%=pdf.getCreateDate() %></td>
		</tr>
		<tr>
			<td>수정된 날짜</td>
			<td><%=pdf.getUpdateDate()%></td>
		</tr>
		<tr>
			<td colspan = "2">
			<!-- 저장된 PDF파일 불러오는 자리 -->
			</td>
		</tr>
	</table>
</body>
</html>