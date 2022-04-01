package dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import vo.Photo;

public class PhotoDao {
	public PhotoDao() {}
	//사진 입력
	public int insertPhoto (Photo photo) throws Exception{
		int row =0;
		//데이터베이스 자원 준비
		Connection conn =null;
		PreparedStatement stmt = null;
		//db 연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--사진입력DB커넥션"); // db와 잘 연결 되었는지 디버깅
	
		//쿼리 작성 및 입력
		String sql = "insert into photo(photo_name, photo_original_name,photo_type,photo_Pw, writer,create_date ,update_date) values (?,?,?,?,?,now(),now())";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, photo.getPhotoName());
		stmt.setString(2,photo.getPhotoOriginalName());
		stmt.setString(3, photo.getPhotoType());
		stmt.setString(4, photo.getPhotoPw());
		stmt.setString(5, photo.getWriter());
		
		row = stmt.executeUpdate(); // 몇행을 입력했는지 return
		//데이터베이스 자원들 반환
		stmt.close();
		conn.close();
		return row;
	}
	
	//이미지 삭제
	public int deletePhoto(int photoNo,String photoPw) throws Exception {// 입력 PhotoNo, photoPw
		int row = 0; // 행 성공 여부 변수
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt =null;
		//db연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--deletePhoto"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성 및 입력
		String sql="delete from photo where photo_No =? and photo_Pw = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, photoNo);
		stmt.setString(2, photoPw);
		//결과 값 입력
		row = stmt.executeUpdate();
		//데이터베이스 자원반납
		stmt.close();
		conn.close();
		return row; // 행 성공 여부 리턴
	}
	
	//이미지 목록 출력
	public ArrayList<Photo> selectPhotoListByPage(int beginRow, int totalPerPage) throws Exception {//
		ArrayList<Photo> list = new ArrayList<Photo>();
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs =null;
		//db연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--photoList"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성 및 입력
		String sql ="select photo_no photoNo,photo_name photoName,writer, create_date createDate,update_date updateDate from photo order by create_date desc limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, totalPerPage);
		//결과 처리 Photo로 묶어서 전송
		rs =stmt.executeQuery();
		while(rs.next()) {
			Photo p = new Photo();
			p.setPhotoNo(rs.getInt("photoNo"));
			p.setPhotoName(rs.getString("photoName"));
			p.setWriter(rs.getString("writer"));
			p.setCreateDate(rs.getString("createDate"));
			list.add(p);
		}
		return list;
	}
	//전체 행의 수 메서드
	public int selectPhotoTotalRow() throws Exception{
		int total = 0;
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs =null;
		//db연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--photoList"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성 및 입력
		String sql ="select count(*) cnt from photo";
		stmt = conn.prepareStatement(sql);
		//결과 처리
		rs =stmt.executeQuery();
		if(rs.next()) {
			total = rs.getInt("cnt");
		}
		System.out.println(total+"<totalphoto");//디버깅
		//데이터베이스 자원 반환
		rs.close();
		stmt.close();
		conn.close();
		
		return total; //photo 전체 행의 수 반환
	}
	//이미지 하나 상세보기 메서드 selectPhotoOne.jsp 에서 요청
	public Photo selectPhotoOne(int photoNo) throws Exception {
		Photo photo =new Photo();
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs =null;
		//db연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "java1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--photoOne"); // db와 잘 연결 되었는지 디버깅
		
		//쿼리 작성 및 입력
		String sql ="select photo_no photoNo,photo_name photoName,writer, create_date createDate,update_date updateDate from photo where photo_no = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, photoNo);
		
		//결과 처리
		rs =stmt.executeQuery();
		if(rs.next()) {
			photo.setPhotoNo( rs.getInt("photoNo"));
			photo.setPhotoName(rs.getString("photoName"));
			photo.setWriter(rs.getString("writer"));
			photo.setCreateDate(rs.getString("createDate"));
			photo.setUpdateDate(rs.getString("updateDate"));
		}
		
		//데이터 베이스 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		
		return photo; // photo 한개 상세보기 데이터 리턴
	}

	
	
	
}
