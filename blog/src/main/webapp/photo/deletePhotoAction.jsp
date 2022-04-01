<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="java.io.File" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("UTF-8");//인코딩
	//요청값 받기
	int photoNo =0; // 이미지 번호
	if(request.getParameter("photoNo")!=null){
		photoNo = Integer.parseInt(request.getParameter("photoNo"));
	}else{ // photoNo 값이 없으면 list로
		response.sendRedirect(request.getContextPath()+"/photo/photoList.jsp?msg=null");
		return;
	}
	String photoPw = "";
	if(request.getParameter("photoPw")!=null){
		photoPw = request.getParameter("photoPw");
	}
	System.out.println(photoNo+"<-photoNo");
	System.out.println(photoPw+"<-photoPw");
	//dao에 요청
	PhotoDao photoDao = new PhotoDao();
	//이미지 이름 받기
	Photo photo = new Photo();
	photo = photoDao.selectPhotoOne(photoNo);
	// 삭제 요청 및 행 성공 여부 받기
	int row = photoDao.deletePhoto(photoNo, photoPw);
	// upload 경로를 나타내는 변수 선언
	String path = application.getRealPath("upload"); 
	
	if(row == 1){//성공시 실제 파일도 삭제 하고리스트로 돌아가기
		System.out.println("삭제 성공");
		File file = new File(path+"\\"+photo.getPhotoName()); //파일을 불러온다.
		file.delete(); //불러온 파일 삭제
		response.sendRedirect(request.getContextPath()+"/photo/photoList.jsp");
	}else { //실패시 deleteform으로 돌아가기, 비밀번호 틀림
		System.out.println("삭제 실패");
		response.sendRedirect(request.getContextPath()+"/photo/deletePhotoForm.jsp?photoNo="+photoNo+"&msg=error");
	}
%>