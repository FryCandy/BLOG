package vo;

public class Photo {
	public Photo() {}
	private int photoNo;
	private String photoName; //이미지 이름
	private String photoOriginalName; //이미지 원본 이름
	private String photoType; //이미지 타입
	private String photoPw;
	private String writer;
	private String createDate;
	private String updateDate;
	//get/set
	public int getPhotoNo() {
		return photoNo;
	}
	public void setPhotoNo(int photoNo) {
		this.photoNo = photoNo;
	}
	public String getPhotoName() {
		return photoName;
	}
	public void setPhotoName(String photoName) {
		this.photoName = photoName;
	}
	public String getPhotoOriginalName() {
		return photoOriginalName;
	}
	public void setPhotoOriginalName(String photoOriginalName) {
		this.photoOriginalName = photoOriginalName;
	}
	public String getPhotoType() {
		return photoType;
	}
	public void setPhotoType(String photoType) {
		this.photoType = photoType;
	}
	public String getPhotoPw() {
		return photoPw;
	}
	public void setPhotoPw(String photoPw) {
		this.photoPw = photoPw;
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
