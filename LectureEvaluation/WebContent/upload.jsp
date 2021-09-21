<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="file.FileDAO"%>
<%@ page import="file.FileDTO"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!doctype html>
<html>
<head>
<title>강의평가 웹 사이트</title>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- 부트스트랩 CSS 추가하기 -->
<link rel="stylesheet" href="./css/bootstrap.min.css">
<!-- 커스텀 CSS 추가하기 -->
<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
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
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbar">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="bbs.jsp">게시판</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="main.jsp">웹 사이트 소개</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="upload.jsp">파일 업로드</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> 회원 관리 </a>
						<div class="dropdown-menu" aria-labelledby="dropdown">
							<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
						</div>
				</li>
			</ul>
			<form action="./index.jsp" method="get"
				class="form-inline my-2 my-lg-0">
				<input type="text" name="search" class="form-control mr-sm-2"
					placeholder="내용을 입력하세요.">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<form action="uploadAction.jsp" method="post" enctype="multipart/form-data">
		파일: <input type="file" name="file1" /><br />
		파일: <input type="file" name="file2" /><br />
		파일: <input type="file" name="file3" /><br />
		<input type="submit" value="업로드" /><br />
	</form>
<%
	ArrayList<FileDTO> fileList = new FileDAO().getList();

	for(FileDTO file : fileList) {
		out.write("<a href=\"" + request.getContextPath() + "/downloadAction?file=" + 
			java.net.URLEncoder.encode(file.getFileRealName(), "UTF-8") + "\">" +
				file.getFileName() + "(다운로드 횟수:  " + file.getDownloadCount() + ")</a><br />");
	}


/* String directory = application.getRealPath("/upload/");
String files[] = new File(directory).list();

for(String file : files) {
	out.write("<a href=\"" + request.getContextPath() + "/downloadAction?file=" + 
		java.net.URLEncoder.encode(file, "UTF-8") + "\">" + file + "</a><br />");
} */
%>

	
	<footer class="bg-dark mt-4 mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2021 황원욱 All Rights Reserved.
	</footer>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- pooper 자바스크립트 추가하기
	<script src="./js/popper.js"></script> -->

	<!-- bootstrap 자바스크립트 추가하기 -->
	<!-- <script src="./js/bootsrap.min.js"></script> -->
	<script src="./js/bootstrap.bundle.min.js"></script>

</body>
</html>