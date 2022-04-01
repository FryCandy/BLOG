<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@page import ="java.sql.*" %>
 <%@page import = "vo.*" %>
 <%@page import ="dao.*" %>
<%
	request.setCharacterEncoding("utf-8"); //인코딩
	
	//널체크 하나라도 공백이면 돌려보내기
	if(request.getParameter("guestbookPw").equals("")||request.getParameter("guestbookContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/guestbook/updateGuestbookForm.jsp?msg=null");	
		return;
	}

	//디버깅
	System.out.println(request.getParameter("guestbookContent")+"<-Content");
	System.out.println(request.getParameter("guestbookPw")+"<-Pw");
		
	//요청값 처리
	Guestbook guestbook = new Guestbook();
	guestbook.setGuestbookNo(Integer.parseInt(request.getParameter("guestbookNo")));
	guestbook.setGuestbookContent(request.getParameter("guestbookContent"));
	guestbook.setGuestbookPw(request.getParameter("guestbookPw"));
	//Dao 선언
	GuestbookDao  guestbookDao = new GuestbookDao();
	//Dao에 요청
	int row = guestbookDao.updateGuestbook(guestbook);
	
	if(row==1){//수정 성공 후 list로 돌아감
		System.out.println(row + "행 수정성공");
		response.sendRedirect(request.getContextPath()+"/guestbook/guestbookList.jsp");
		return;
	}else{//수정 실패시 form으로 돌려보냄
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath()+"/guestbook/updateGuestbookForm.jsp?guestbookNo="+guestbook.getGuestbookNo()+"&msg=error");
		return;
	}

%>