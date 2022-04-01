<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import ="vo.*"%>
<%@ page import = "dao.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 한글 안깨지게 인코딩
	//널체크 boardTitle이 없으면 상세보기가 불가능 함으로 돌려보냄
	if(request.getParameter("boardTitle") == ""){
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg=space");
		return;
	}
	//요청값 받기
	String categoryName = request.getParameter("categoryName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	//디버깅 코드
	System.out.println(categoryName+"<-categoryName");
	System.out.println(boardTitle+"<-boardTitle");
	System.out.println(boardContent+"<-boardContent");
	System.out.println(boardPw+"<-boardPw");
	
	//요청값 가공
	Board board = new Board();
	board.setCategoryName(categoryName);
	board.setBoardTitle(boardTitle);
	board.setBoardContent(boardContent);
	board.setBoardPw(boardPw);
	
	//dao 값 받기
	BoardDao boardDao = new BoardDao();
	//dao에 db 입력 요청
	int row =0;
	row= boardDao.insertBoard(board);

		
	//디버깅
	if(row==1){
		System.out.println(row + "행 입력성공");
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	}else{
		System.out.println("입력실패");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg=error");
		//입력 실패시 msg와 함께 insertBoardForm로 이동	
	}
	
%>
