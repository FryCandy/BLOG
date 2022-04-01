package vo;
	//category 테이블 vo(도메인객체) : vo, dto:분산처리 가능, domain :테이블이랑 똑같이 생김
public class Category {
	public Category() {}
	private String CategoryName;
	private String createDate;
	private String updateDate;
	public String getCategoryName() {
		return CategoryName;
	}
	public void setCategoryName(String categoryName) {
		CategoryName = categoryName;
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
