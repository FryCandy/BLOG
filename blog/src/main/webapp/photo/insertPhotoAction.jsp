<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import ="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import ="com.oreilly.servlet.MultipartRequest"%>
<%@ page import = "vo.Photo" %>
<%@ page import ="java.io.File" %>
<%@ page import = "dao.PhotoDao" %>
<%
	// form 태그에 enctype = multipart/form-data인 경우 
	// request.getParameter() api 은 null로 받는다. 사용할 수 없다.
	//getParameter() API 대신 다른 것을 사용해야하는데 너무 복잡
	// request를 단순하게 사용하게 해주는 -> cos.jar같은 API(외부라이브러리)를 사용
	
	request.setCharacterEncoding("utf-8");
	DefaultFileRenamePolicy rp = new DefaultFileRenamePolicy();//이름중복 방지, rp대신 new~policy()넣어도 됨
	//업로드 파일 위치 설정 톰켓 임시 경로를 쓰지 않기 위해 serve without publishing 체크
	String path = application.getRealPath("upload"); // applicaton변수 톰켓을 가르키는 변수
	MultipartRequest multiReq = new MultipartRequest(request, path,1024*1024*100,"utf-8",rp);
	// 숫자 부분는 byte 단위의 최대 용량 설정 지금 설정은 100MB
	//2^10 byte = 1kbyte = 1024 byte
	//2^10 kbyte = 1 mbyte = 1024*1024byte
	Photo photo = new Photo(); // photo 정보 묶기
	photo.setPhotoPw(multiReq.getParameter("photoPw"));
	photo.setWriter(multiReq.getParameter("writer"));
	// input type="file" name="photo"
	photo.setPhotoOriginalName(multiReq.getOriginalFileName("photo")); //파일 업로드시 원본의 이름
	photo.setPhotoName(multiReq.getFilesystemName("photo"));// new defaltfilerenamepolicy로 변경된 객체 이름
	photo.setPhotoType(multiReq.getContentType("photo"));// 파일 타입

	//디버깅
	System.out.println(photo.getPhotoPw()+"<-photoPw");
	System.out.println(photo.getWriter()+"<-writer");
	System.out.println(photo.getPhotoOriginalName()+"<-photoOrigin");
	System.out.println(photo.getPhotoName()+"<-photoName");
	System.out.println(photo.getPhotoType()+"<-photoType");
	
	//파일 업로드의 경우 100MB이하의 img/gif, img/png, image/jpeg 3가지 이미지만 허용
	int row =0; //성공 행 수 나타낼 변수 초기화
	if(photo.getPhotoType().equals("image/gif")||photo.getPhotoType().equals("image/png")||photo.getPhotoType().equals("image/jpeg")){
		//db에 저장 후 list로 이동
		PhotoDao photoDao = new PhotoDao(); 
		row = photoDao.insertPhoto(photo);
		if(row==1){
			System.out.println("이미지 파일 업로드 성공");
			response.sendRedirect(request.getContextPath()+"/photo/photoList.jsp");
			return;
		}else{ // 업로드 실패시 업로드 되어버린 파일도 삭제
			System.out.println("이미지 파일 업로드 실패");
			File file = new File(path+"\\"+photo.getPhotoName()); //잘못된 파일을 불러온다.
			file.delete(); //잘 못 업로드 된 불러온 파일 삭제
			response.sendRedirect(request.getContextPath()+"/photo/insertPhotoForm.jsp?msg=Error");
			return;
		}
			
	}else{ // 파일 형식이 맞지 않으면 오류메세지와 함께 잘못저장된 업로드된 파일 지우고 폼으로 이동
		System.out.println("이미지 파일만 업로드!");
		File file = new File(path+"\\"+photo.getPhotoName()); //잘못된 파일을 불러온다.
		file.delete(); //잘 못 업로드 된 불러온 파일 삭제
		response.sendRedirect(request.getContextPath()+"/photo/insertPhotoForm.jsp?msg=typeError");
		return;
	}

%>