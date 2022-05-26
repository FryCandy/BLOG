package dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import vo.Pdf;

public class PdfDao {
	public PdfDao() {}
	//pdf 리스트 불러오기
	public ArrayList<Pdf> pdfList(int beginRow, int rowPerPage) throws Exception{
		ArrayList<Pdf> list = new ArrayList<Pdf>();
		//데이터베이스 자원 준비
		Connection conn =null;
		PreparedStatement stmt =null;
		ResultSet rs = null;
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--ListDB커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성 및 입력
		String sql = "select pdf_no pdfNo,pdf_name pdfName, writer,create_date createDate, update_date updateDate from pdf order by create_date desc limit ?,? ";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		
		//결과 처리
		rs = stmt.executeQuery();
		while (rs.next()) {
			Pdf p = new Pdf();
			p.setPdfNo(rs.getInt("pdfNo"));
			p.setPdfName(rs. getString("pdfName"));
			p.setWriter(rs.getString("writer"));
			p.setCreateDate(rs.getString("createDate"));
			p.setUpdateDate(rs.getString("updateDate"));
			list.add(p);
		}
		//데이터 베이스 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		
		return list;
	}
	//총 게시물 숫자 구하기
	public int totalRow () throws Exception{
		int totalRow = 0; // 전체 게시물 수가 들어갈 변수
		//데이터베이스 자원 준비
		Connection conn =null;
		PreparedStatement stmt =null;
		ResultSet rs = null;
		//db와 연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--totalrow커넥션"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성 및 입력
		String sql = "select count(*) cnt from pdf";
		stmt = conn.prepareStatement(sql);
		//결과 처리
		rs = stmt.executeQuery();
		if(rs.next()) {
			totalRow = rs.getInt("cnt");
		}
		//데이터 베이스 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		
		return totalRow;
	}
	
	//pdf 입력
	public int insertPdf (Pdf pdf) throws Exception{
		int row = 0; // 행 성공 여부 변수 초기화
		//데이터 베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		
		//db 연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--pdf입력DB커넥션"); // db와 잘 연결 되었는지 디버깅

		//쿼리 작성 및 입력
		String sql ="insert into pdf(pdf_name,pdf_original_name,pdf_Pw,writer,create_date,update_date) values (?,?,?,?,now(),now())";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, pdf.getPdfName());
		stmt.setString(2, pdf.getPdfOriginalName());
		stmt.setString(3, pdf.getPdfPw());
		stmt.setString(4, pdf.getWriter());
		
		//행 성공 여부 도출
		row = stmt.executeUpdate();
		//데이터 베이스 자원반납
		stmt.close();
		conn.close();
		
		return row;
	}
	// pdf 게시판 상세보기 selectpdfOne.jsp 에서 요청
	public Pdf selectPdfOne (int pdfNo) throws Exception {
		Pdf pdf = new Pdf(); //상세보기 데이터를 담을 vo
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		//db 연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--pdf상세보기DB커넥션"); // db와 잘 연결 되었는지 디버깅

		//쿼리 작성 및 입력
		String sql = "select* from pdf where pdf_no = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, pdfNo);
		
		//결과 값 가공
		rs = stmt.executeQuery();
		if(rs.next()) {
			pdf.setPdfNo(rs.getInt("pdf_No"));
			pdf.setPdfName(rs.getString("pdf_name"));
			pdf.setWriter(rs. getString("writer"));
			pdf.setCreateDate(rs.getString("create_date"));
			pdf.setUpdateDate(rs.getString("update_date"));
		}
		//데이터 자원 반납
		rs.close();
		stmt.close();
		conn.close();
		
		return pdf; //데이터 리턴
	}
	//pdf 파일 삭제
	public int deletePdf(int pdfNo,String pdfPw) throws Exception {// 입력 pdfNo, pdfPw
		int row = 0; // 행 성공 여부 변수
		//데이터베이스 자원 준비
		Connection conn = null;
		PreparedStatement stmt =null;
		//db연결
		Class.forName("org.mariadb.jdbc.Driver");
		String dburl = "jdbc:mariadb://localhost:3306/blog";
		String dbuser ="root";
		String dbpw = "mariadb1234";
		conn = DriverManager.getConnection(dburl,dbuser,dbpw);
		System.out.println(conn+"<--deletepdf"); // db와 잘 연결 되었는지 디버깅
		//쿼리 작성 및 입력
		String sql="delete from pdf where pdf_No =? and pdf_Pw = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, pdfNo);
		stmt.setString(2, pdfPw);
		//결과 값 입력
		row = stmt.executeUpdate();
		//데이터베이스 자원반납
		stmt.close();
		conn.close();
		return row; // 행 성공 여부 리턴
	}

}
