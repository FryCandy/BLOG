<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import ="vo.*"%>
<%@ page import = "dao.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 한글 안깨지게 인코딩
	
	//널체크 boardTitle이 없으면 상세보기가 불가능 함으로 돌려보냄
	if(request.getParameter("boardTitle") == ""){
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg=null&boardNo="+Integer.parseInt(request.getParameter("boardNo")));
		return;
	}

	//요청값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
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
	board.setBoardNo(boardNo);
	board.setCategoryName(categoryName);
	board.setBoardTitle(boardTitle);
	board.setBoardContent(boardContent);
	board.setBoardPw(boardPw);
	
	//dao에 수정 요청 및 행 결과 값 받기
	BoardDao boardDao = new BoardDao();
	int row = boardDao.updateBoard(board);
	//디버깅
	if(row==1){
		System.out.println(row + "행 수정성공"); // 수정 성공 후 boardOne으로 이동
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	}else{
		System.out.println("수정실패"); //입력 실패시, 에러 코드와 함께 updateBoardForm.jsp로 이동
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+boardNo+"&msg=error");
	}
	
%>
