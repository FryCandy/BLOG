<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import ="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import ="com.oreilly.servlet.MultipartRequest"%>
<%@ page import = "vo.Pdf" %>
<%@ page import ="java.io.File" %>
<%@ page import = "dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	DefaultFileRenamePolicy rp = new DefaultFileRenamePolicy();//이름 중복 방지
	String path = application.getRealPath("upload");//업로드 파일 위치 설정
	MultipartRequest multiReq = new MultipartRequest(request,path,1024*1024*100,"utf-8",rp); // 최대 100MB
	//요청값 받기
	Pdf pdf = new Pdf();
	pdf.setPdfPw(multiReq.getParameter("pdfPw"));
	pdf.setWriter(multiReq.getParameter("writer"));
	//input type ="file" name ="pdf"에서의 요청값 받기
	pdf.setPdfOriginalName(multiReq.getOriginalFileName("pdf")); //파일 업로드시 원본의 이름
	pdf.setPdfName(multiReq.getFilesystemName("pdf"));// new defaltfilerenamepolicy로 변경된 객체 이름
	String pdfType = multiReq.getContentType("pdf"); //파일 타입 insertAction에서만 사용
	//디버깅
	System.out.println(pdf.getPdfPw()+"<-pdfPw");
	System.out.println(pdf.getWriter()+"<-writer");
	System.out.println(pdf.getPdfOriginalName()+"<-pdfOrigin");
	System.out.println(pdf.getPdfName()+"<-pdfName");
	System.out.println(pdfType+"<-pdfType");
	
	int row = 0 ; // 성공 행 수 나타낼 변수 초기화
	if(pdfType.equals("application/pdf")){ //파일 타입이 PDF가 맞으면
	//dao에 요청
		PdfDao pdfDao = new PdfDao();
		row = pdfDao.insertPdf(pdf);
		if(row == 1){//입력 성공시 list로 돌려보냄
			System.out.println("pdf입력성공");
			response.sendRedirect(request.getContextPath()+"/pdf/pdfList.jsp");
			return;
		}else{ //입력 실패시 잘못 저장된 파일을 삭제하고 insertForm으로 돌려보냄
			System.out.println("pdf입력실패");
			File file = new File(path+"\\"+pdf.getPdfName()); //잘못된 파일을 불러온다.
			file.delete(); //잘 못 업로드 된 불러온 파일 삭제
			response.sendRedirect(request.getContextPath()+"/pdf/insertPdfForm.jsp");
			return;
		}
	}else{// pdf 파일 형식이 아니면 오류 메세지와 함꼐 잘못 저장된 파일 지우고 폼으로 이동
			System.out.println("pdf파일이 아닙니다");
			File file = new File(path+"\\"+pdf.getPdfName()); //잘못된 파일을 불러온다.
			file.delete(); //잘 못 업로드 된 불러온 파일 삭제
			response.sendRedirect(request.getContextPath()+"/pdf/insertPdfForm.jsp");
			return;
		
	}
%>