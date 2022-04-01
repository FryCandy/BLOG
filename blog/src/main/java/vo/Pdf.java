package vo;

public class Pdf {
	public Pdf(){}
	private int pdfNo;
	private String pdfName; //pdf 이름
	private String pdfOriginalName; //pdf 원본 이름
	private String pdfPw;//비밀번호
	private String writer;//작성자
	private String createDate;//생성된 날짜
	private String updateDate;//수정된 날짜
	//get/set
	public int getPdfNo() {
		return pdfNo;
	}
	public void setPdfNo(int pdfNo) {
		this.pdfNo = pdfNo;
	}
	public String getPdfName() {
		return pdfName;
	}
	public void setPdfName(String pdfName) {
		this.pdfName = pdfName;
	}
	public String getPdfOriginalName() {
		return pdfOriginalName;
	}
	public void setPdfOriginalName(String pdfOriginalName) {
		this.pdfOriginalName = pdfOriginalName;
	}
	public String getPdfPw() {
		return pdfPw;
	}
	public void setPdfPw(String pdfPw) {
		this.pdfPw = pdfPw;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	
	

}
