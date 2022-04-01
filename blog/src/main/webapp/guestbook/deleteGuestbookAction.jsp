<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import ="vo.*" %>
<%@page import ="dao.*" %>
<%
	//null 체크
	if(request.getParameter("guestbookNo")==null){
		response.sendRedirect(request.getContextPath()+"/guestbook/guestbookList.jsp?msg=null");
		return;
	}

	//요청값 받기
	
	Guestbook g = new Guestbook();
	g.setGuestbookNo(Integer.parseInt(request.getParameter("guestbookNo")));
	g.setGuestbookPw(request.getParameter("guestbookPw"));
	
	//디버깅
	System.out.println(g.getGuestbookNo()+"<-No");
	System.out.println(g.getGuestbookPw()+"<-Pw");
	
	//dao에 요청
	GuestbookDao guestbookDao = new GuestbookDao();
	int row = guestbookDao.deleteGuestbook(g.getGuestbookNo(), g.getGuestbookPw());
	
	if(row==1){//삭제 성공 후 list로 돌아감
		System.out.println(row + "행 삭제성공");
		response.sendRedirect(request.getContextPath()+"/guestbook/guestbookList.jsp");
		return;
	}else{//삭제 실패시 form으로 돌려보냄
		System.out.println("삭제실패");
		response.sendRedirect(request.getContextPath()+"/guestbook/deleteGuestbookForm.jsp?guestbookNo="+g.getGuestbookNo()+"&msg=error");
		return;
	}
	
%>