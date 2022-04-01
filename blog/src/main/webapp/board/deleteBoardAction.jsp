<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import ="dao.*" %>
<%
	//널체크
	if(request.getParameter("boardNo")==null){ // boardNo가 없으면 리스트로 보냄
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	return;
	}

	//요청값 받기
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); //boardNo을 변수에 저장
	String boardPw = request.getParameter("boardPw"); //boardPw 저장
	System.out.println(boardNo+"<--boardNo");//디버깅
	System.out.println(boardPw+"<--boardPw");//디버깅
	//dao에 삭제 요청 및 행 결과 받기
	BoardDao boardDao = new BoardDao();
	int row = boardDao.deleteBoard(boardNo, boardPw);
	
	
	//디버깅
	//form에 비밀번호가 틀렸습니다. 메세지 출력
	if(row == 1){ //삭제 성공
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp"); // 성공하면 list로 보냄
		System.out.println("삭제성공");
	}else{//삭제 실패
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo+"&msg=error"); // 실패하면 delteboardform으로 게시판번호와 함께 돌려보냄
		System.out.println("삭제실패");
	}
%>