<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="file.FileDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%
	String userID = null;
	if(session.getAttribute("userID") != null) { // 로그인을 한 상태라서 userID session의 값이 존재한다면
		userID = (String) session.getAttribute("userID"); // userID에 해당 session의 값을 넣는다
	}
	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID); // 사용자가 이메일 인증을 받았는지
	if(emailChecked == false) { // 인증을 받지 않은 경우
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendConfirm.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	String directory = application.getRealPath("/upload/");
	int maxSize = 1024 * 1024 * 100;
	String encoding = "UTF-8";
	
	MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, 
			new DefaultFileRenamePolicy());
	// multipartRequest 객체를 활용해서 사용자가 전송한 request(파일정보)를 토대로 우리가 만든 upload폴더 안에 maxSize만큼만 utf-8인코딩을 적용해서
	// 실제로 파일업로드를 수행할 수 있도록 만들어 줌
	
	String fileName = multipartRequest.getOriginalFileName("file");
	// 사용자가 전송한 file(upload.jsp의 name=file)에서 파라미터 값을 받아서 실제로 사용자가 업로드하고자 하는 파일이름을 fileName 변수에 넣는다
	String fileRealName =  multipartRequest.getFilesystemName("file");
	// 실제로 서버에 업로드가된 파일 이름을 가져온다
	
	
	
	if (!fileName.endsWith(".doc") && !fileName.endsWith(".hwp") && !fileName.endsWith(".pdf") &&
			!fileName.endsWith(".xls")) {
		// 위의 네가지 확장자만 업로드 할수있도록 만들어줌
		File file = new File(directory + fileRealName);
		file.delete(); // 올바른 확장자가 아니라면 지워버린다
		out.write("업로드할 수 없는 확장자입니다.");
	} else {
		new FileDAO().upload(fileName, fileRealName);
		// 실제로 업로드를 수행할 수 있도록 만듬
		out.write("파일명: " + fileName + "<br />");
		out.write("실제 파일명: " + fileRealName + "<br />");
	}
%>