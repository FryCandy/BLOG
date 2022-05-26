package dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import vo.Guestbook;
public class GuestbookDao {
	//생성자 메서드
	public GuestbookDao() {}// 모든 클래스는 생성자를 가지고 있다
	
	//guestbook 전체 행의 수를 반환 메서드
	public int selectGuestbookTotalRow() throws Exception {
		int row =0;
		//구현
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs =null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--전체 행의 수 반환 DB커넥션"); // db와 잘 연결 되었는지 디버깅
		
		//쿼리 작성 및 입력
		//방명록 목록 총 행의 수 쿼리
		String sql="select count(*) cnt from guestbook";
		stmt = conn.prepareStatement(sql);
		//결과 셋팅
		rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt("cnt");
		}
		//데이터베이스 자원들 반환
		rs.close();
		stmt.close();
		conn.close(); // 커넥션 사용 끝 
		
		return row;
	}
	
	// guestbook 입력 메서드
	public void insertGuestbook(Guestbook guestbook) throws Exception {
	//데이터베이스 자원 준비
	Connection conn = null;
	PreparedStatement insertStmt = null;
	//db 연결
	Class.forName("org.mariadb.jdbc.Driver");
	String dburl = "jdbc:mariadb://localhost:3306/blog";
	String dbuser ="root";
	String dbpw = "mariadb1234";
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	System.out.println(conn+"<--입력DB커넥션"); // db와 잘 연결 되었는지 디버깅
	
	//방명록 입력 쿼리 작성 및 입력
	String guestbookInsertsql = "INSERT  INTO guestbook(guestbook_content,writer,guestbook_pw,create_date,UPDATE_date) VALUES (?,?,?,NOW(),NOW())";
	insertStmt = conn.prepareStatement(guestbookInsertsql);
	insertStmt.setString(1, guestbook.getGuestbookContent());
	insertStmt.setString(2, guestbook.getWriter());
	insertStmt.setString(3, guestbook.getGuestbookPw());
	
	//디버깅
	int row = insertStmt.executeUpdate(); // 몇행을 입력했는지 return
	if(row==1){
		System.out.println(row + "행 입력성공");
	}else{
			System.out.println("입력실패");
	}
	//데이터베이스 자원들 반환
	insertStmt.close();
	conn.close();
	}
	
	//guestbook 수정 메서드
	//updateGuestbookForm.jsp에서 호출, 내용보기
	public Guestbook selectGuestbookOne(int guestbookNo) throws Exception{
		//데이터베이스 자원준비
		Guestbook guestbook = null;
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		
		//쿼리 작성, 입력, 결과 도출
		String sql = "select guestbook_no guestbookNo, guestbook_content guestbookContent,writer, guestbook_pw guestbookPw, create_date createDate, update_date updateDate from guestbook where guestbook_no =?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, guestbookNo);
		System.out.println(stmt+"<-SelectOnee spl"); // 쿼리가 맞는지 알기 위해 중요
		rs = stmt.executeQuery();
		if(rs.next()) { //추후에 쓰기 좋게 일단 모두 출력
			guestbook = new Guestbook();
			guestbook.setGuestbookNo(rs.getInt("guestbookNo"));
			guestbook.setGuestbookContent(rs.getString("guestbookContent"));
			guestbook.setWriter(rs.getString("writer"));
			guestbook.setGuestbookPw(rs.getString("guestbookPw"));
			guestbook.setCreateDate(rs.getString("createDate"));
			guestbook.setUpdateDate(rs.getString("updateDate"));
		}
		//데이터베이스 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		return guestbook;
	}
	
	//updateGuestbookAction.jsp 에서 호출
	//이름 updateGuestbook 
	//반환타입 - 수정한 행의 수 반환 -> 0 수정실패, 1 수정성공 -> int
	//입력 매개변수 guestbookNo,guestbookContent,guestbookPw -> 하나의 타입 매개변수로 받자 -> Guestbook 타입을 사용
	
	public int updateGuestbook(Guestbook guestbook) throws Exception {
	//데이터베이스 자원 준비
	int row=0;//수정한 행의 수
	Connection conn = null;
	PreparedStatement updateStmt = null;
	//db 연결
	Class.forName("org.mariadb.jdbc.Driver");
	String dburl = "jdbc:mariadb://localhost:3306/blog";
	String dbuser ="root";
	String dbpw = "mariadb1234";
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	System.out.println(conn+"<--수정DB커넥션"); // db와 잘 연결 되었는지 디버깅
	
	//방명록 수정 쿼리 작성 및 입력
	String updateGuestbooksql = "UPDATE guestbook SET guestbook_content = ?,update_date = NOW() WHERE guestbook_no = ? AND guestbook_pw = ?";
	updateStmt = conn.prepareStatement(updateGuestbooksql);
	updateStmt.setString(1, guestbook.getGuestbookContent());
	updateStmt.setInt(2, guestbook.getGuestbookNo());
	updateStmt.setString(3, guestbook.getGuestbookPw());
	System.out.println(updateStmt+"<--sql updateGuestbook");
	
	//디버깅
	row = updateStmt.executeUpdate(); // 몇행을 입력했는지 return

	//데이터베이스 자원들 반환
	updateStmt.close();
	conn.close();
	
	return row;
	
		
	}
	//guestbook 삭제 프로세스

	public int deleteGuestbook(int guestbookNo, String guestbookPw) throws Exception {
	//데이터베이스 자원 준비
	int row = 0; //삭제한 행의 수
	Connection conn = null;
	PreparedStatement deleteStmt = null;
	//db 연결
	Class.forName("org.mariadb.jdbc.Driver");
	String dburl = "jdbc:mariadb://localhost:3306/blog";
	String dbuser ="root";
	String dbpw = "mariadb1234";
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	System.out.println(conn+"<--삭제DB커넥션"); // db와 잘 연결 되었는지 디버깅
	
	//방명록 수정 쿼리 작성 및 입력
	String guestbookDeletesql = "delete from guestbook WHERE guestbook_no = ? AND guestbook_pw = ?";
	deleteStmt = conn.prepareStatement(guestbookDeletesql);
	deleteStmt.setInt(1, guestbookNo);
	deleteStmt.setString(2, guestbookPw);
	
	//디버깅
	row = deleteStmt.executeUpdate(); // 몇행을 입력했는지 return

	//데이터베이스 자원들 반환
	deleteStmt.close();
	conn.close();
	
	return row;
	}
	//guestbooklist 반환 메서드
	public ArrayList<Guestbook> selectGuestBookList(int beginRow, int rowPerPage) throws Exception{ //예외는 일단 무시
	//비지니스 로직(모델계층)
		//	beginRow 	 // 리스트 시작 행 변수
		//	rowPerPage// 화면당 보여지는 행수 변수
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement listStmt = null;
		ResultSet listRs =null;
		
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
		
		//쿼리 작성 및 입력
		//방명록 목록 쿼리
		String guestbookListsql="select guestbook_no guestbookNo, guestbook_content guestbookContent,writer,create_date createDate,update_date updateDate from guestbook order by createDate desc Limit ?, ?";
		listStmt = conn.prepareStatement(guestbookListsql);
		listStmt.setInt(1, beginRow);	
		listStmt.setInt(2, rowPerPage);	
		//결과 셋팅
		listRs = listStmt.executeQuery();
		//데이터 베이스 로직 끝
		
		//데이터 변환(가공)
		//반환할 타입의 변수
		ArrayList<Guestbook> list = new ArrayList<Guestbook>();
		while(listRs.next()){
			Guestbook g = new Guestbook();
			g.setGuestbookNo(listRs.getInt("guestbookNo"));
			g.setGuestbookContent(listRs.getString("guestbookContent"));
			g.setWriter(listRs.getString("writer"));
			g.setCreateDate(listRs.getString("createDate"));
			g.setUpdateDate(listRs.getString("updateDate"));
			list.add(g);
		}
		//데이터베이스 자원들 반환
		listRs.close();
		listStmt.close();
		conn.close(); // 커넥션 사용 끝 
		
		return list;// 위의 list를 리턴
	}
}
