<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@page import ="java.sql.*" %>
 <%@page import = "vo.*" %>
 <%@page import ="dao.*" %>
<%
	request.setCharacterEncoding("utf-8"); //인코딩
	
	//널체크 하나라도 공백이면 돌려보내기
	if(request.getParameter("guestbookContent").equals("")||request.getParameter("writer").equals("")||request.getParameter("guestbookPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/guestbook/guestbookList.jsp?msg=null");	
		return;
	}

	//디버깅
	System.out.println(request.getParameter("guestbookContent")+"<-Content");
	System.out.println(request.getParameter("writer")+"<-writer");
	System.out.println(request.getParameter("guestbookPw")+"<-Pw");
		
	//요청값 처리
	Guestbook guestbook = new Guestbook();
	guestbook.setGuestbookContent(request.getParameter("guestbookContent"));
	guestbook.setWriter(request.getParameter("writer"));
	guestbook.setGuestbookPw(request.getParameter("guestbookPw"));
	//Dao 선언
	GuestbookDao  guestbookDao = new GuestbookDao();
	//Dao에 요청
	guestbookDao.insertGuestbook(guestbook);
	
	//요청 후 guestbookList로 이동
	response.sendRedirect(request.getContextPath()+"/guestbook/guestbookList.jsp");

%>