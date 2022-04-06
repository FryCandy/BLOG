package dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import vo.Board;

public class BoardDao {
	public BoardDao() {}
	
	//1. 카테고리명 + all,과 각 카테고리마다 행의 갯수가 나오는 메서드
	//쿼리에 결과를 category, board vo로 저장할 수 없다. -> hashmap을 사용하자
	// categoryName, count 모두 String 값이므로 object - > String으로 보냄
	public ArrayList<HashMap<String, String>> categoryList() throws Exception{
	//데이터베이스 자원 준비
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs =null;
	
	//db와 연결
	Class.forName("org.mariadb.jdbc.Driver");
	String dburl = "jdbc:mariadb://localhost:3306/blog";
	String dbuser ="root";
	String dbpw = "java1234";
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
	//쿼리 작성 및 입력	
	String categoryListSql ="SELECT* FROM (SELECT  COALESCE (category_name,'전체') categoryName, count(*) cnt from board  group by category_name WITH ROLLUP) c ORDER BY cnt DESC";
	stmt = conn.prepareStatement(categoryListSql);
	rs = stmt.executeQuery();
	//데이터 베이스 로직 끝
	//데이터 가공
	ArrayList<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
	while(rs.next()) {
		HashMap<String,String> map = new HashMap<String,String>();
		map.put("categoryName",rs.getString("categoryName"));
		map.put("categoryCount",rs.getString("cnt"));
		list.add(map);
	}
	//데이터베이스 자원 반환
	rs.close();
	stmt.close();
	conn.close();
	return list;
	}
	
	//2.categoryName에 따른 게시판 리스트가 나오는 메서드
	public ArrayList<Board> boardList(String categoryName,String title, int beginRow, int rowPerPage) throws Exception {
		ArrayList<Board> list = new ArrayList<Board>(); //boardList가 될 Arraylist 선언
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs =null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성
		String categoryAll ="SELECT board_no boardNo, category_name categoryName, board_title boardTitle, create_date createDate FROM board WHERE board_title like ? ORDER BY create_date DESC LIMIT ?, ?";
		String categoryNameIn ="SELECT board_no boardNo, category_name categoryName, board_title boardTitle, create_date createDate FROM board WHERE category_name=? AND board_title like ? ORDER BY create_date DESC LIMIT ?, ?";
		//categoryName = null 여부에 따른 쿼리 입력
		/*페이지 바뀌면 끝이 아니고, 가지고 오는 데이터가 변경되어야 한다.
			알고리즘 select ...... Limit0,10
			1page 0 10 2page 10 20 3page 20 30 ... n page = 10*(currentPage-1) 10*currentPage
		*/
		if (categoryName.equals("전체") ){ // categoryName이 전체일경우 쿼리 입력
			stmt=conn.prepareStatement(categoryAll);
			stmt.setString(1, "%"+title+"%"); // where like ?
			stmt.setInt(2, beginRow);// 쿼리 안 ? = beginRow
			stmt.setInt(3, rowPerPage);// 쿼리 안 ? = rowPerPage
		}else{//categoryName 이 전체가 아닐 경우의 쿼리 입력
			stmt = conn.prepareStatement(categoryNameIn);
			stmt.setString(1, categoryName);// 쿼리 안 ? = categoryName
			stmt.setString(2, "%"+title+"%"); // where like ?
			stmt.setInt(3, beginRow);// 쿼리 안 ? = beginRow
			stmt.setInt(4, rowPerPage);// 쿼리 안 ? = rowPerPage
			
		}
		//결과 가공
		rs = stmt.executeQuery();
		while (rs.next()){
			Board b = new Board();
			b.setBoardNo(rs.getInt("boardNo"));
			b.setCategoryName(rs.getString("categoryName"));
			b.setBoardTitle(rs.getString("boardTitle"));
			b.setCreateDate(rs.getString("createDate"));
			list.add(b);
		}
		//데이터베이스 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		return list;
	}
	//2-1.검색기능 추가에 따른 totalRow을 구하는 메서드
	public int totalRow(String categoryName,String title) throws Exception {
		int totalRow = 0; //전체행의 수가 들어갈 변수 초기화
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs =null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성
		String categoryAll ="SELECT count(*) cnt FROM board WHERE board_title like ? ";
		String categoryNameIn ="SELECT count(*) cnt FROM board WHERE category_name=? AND board_title like ? ";
		//categoryName = null 여부에 따른 쿼리 입력
		if (categoryName.equals("전체") ){ // categoryName이 전체일경우 쿼리 입력
			stmt=conn.prepareStatement(categoryAll);
			stmt.setString(1, "%"+title+"%"); // where like ?
		}else{//categoryName 이 전체가 아닐 경우의 쿼리 입력
			stmt = conn.prepareStatement(categoryNameIn);
			stmt.setString(1, categoryName);// 쿼리 안 ? = categoryName
			stmt.setString(2, "%"+title+"%"); // where like ?
		}
		//결과 가공
		rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt("cnt");
		}
		//데이터베이스 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		return totalRow;
	}

	//3. 게시판 작성 메서드 insertBoardAction.jsp에서 요청
	public int insertBoard (Board board) throws Exception{
		int row =0; // 작성된 총 행의수 리턴할 변수
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--insertDB커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 입력
		String insertSql ="insert into board(category_name,board_title,board_content,board_pw,create_date,update_date) values(?,?,?,?,now(),now())";
		stmt = conn.prepareStatement(insertSql);
		stmt.setString(1, board.getCategoryName());
		stmt.setString(2, board.getBoardTitle());
		stmt.setString(3, board.getBoardContent());
		stmt.setString(4, board.getBoardPw());
		row =stmt.executeUpdate(); // 쿼리 결과 저장
		//데이터베이스 자원 반납
		stmt.close();
		conn.close();
		return row;
	}
	//4. 게시판 수정 메서드 - updateBoardAction.jsp에서 요청
	public int updateBoard (Board board) throws Exception{
		int row = 0; // 행 결과수 넣을 변수 초기화
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 입력
		String updateSql ="update board set category_name=?, board_title=? ,board_content = ?,update_date = now() where board_no=? and board_pw =?";
		stmt = conn.prepareStatement(updateSql);
		stmt.setString(1, board.getCategoryName());
		stmt.setString(2, board.getBoardTitle());
		stmt.setString(3, board.getBoardContent());
		stmt.setInt(4, board.getBoardNo());
		stmt.setString(5, board.getBoardPw());
		row =stmt.executeUpdate(); // 쿼리 결과 저장
		//데이터베이스 자원 반납
		stmt.close();
		conn.close();
		
		return row; //행결과와 함께 리턴 
	}
	//5.게시판 삭제 메서드
	public int deleteBoard (int boardNo, String boardPw) throws Exception{
		int row = 0; // 행 결과수 넣을 변수 초기화
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 입력
		String deleteSql = "delete from board where board_no =? and board_Pw=?";
		stmt = conn.prepareStatement(deleteSql);
		stmt.setInt(1, boardNo);
		stmt.setString(2, boardPw);
		row =stmt.executeUpdate(); // 쿼리 결과 저장
		//데이터베이스 자원 반납
		stmt.close();
		conn.close();
		
		return row; //행결과와 함께 리턴 
	}
	//6.게시물 상세보기 메서드 boardOne.jsp에서 요청
	public Board boardOne (int boardNo) throws Exception{
		Board b = new Board();
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 입력
		String boardOneSql ="select board_no boardNo, category_name categoryName, board_title boardTitle, board_content boardContent,board_Pw boardPw, create_date createDate,update_date updateDate FROM board where board_no = ?";
		stmt = conn.prepareStatement(boardOneSql);
		stmt.setInt(1, boardNo);
		//결과 가공 - 만일에 대비 모든 정보를 다 저장
		rs = stmt.executeQuery();
		if(rs.next()) {
			b.setBoardNo(rs.getInt("boardNo"));
			b.setCategoryName(rs.getString("categoryName"));
			b.setBoardTitle(rs.getString("boardTitle"));
			b.setBoardContent(rs.getString("boardContent"));
			b.setBoardPw(rs.getString("boardPw"));
			b.setCreateDate(rs.getString("createDate"));
			b.setUpdateDate(rs.getString("updateDate"));
		}
		
		//데이터베이스 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		
		return b; // 상세보기 데이터 리턴
	}
	
	
	
	
	
}











