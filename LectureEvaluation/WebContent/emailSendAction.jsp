<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="java.util.Properties" %> <!-- 속성을 정의할때 사용하는 일종의 라이브러리 -->>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="util.Gmail" %>
<%@ page import="java.io.PrintWriter" %>
<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if (session.getAttribute("userID") != null) { // 현재 사용자가 로그인한 상태, 즉 session값이 유효한 상태일 때
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) { // 사용자가 로그인하지 않은 상태라면
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		// 입력이 되지 않았으면 userLogin.jsp로 이동
		script.println("</script>");
		script.close();
		return;
	}
	
	boolean emailChecked = userDAO.getUserEmailChecked(userID); // 이메일 인증확인
	if (emailChecked == true) { // 인증을 한 상태라면
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증된 회원입니다.');");
		script.println("location.href = 'index.jsp'");
		// 입력이 되지 않았으면 index.jsp 로 이동
		script.println("</script>");
		script.close();
		return;
	}
	
	// 구글 smtp가 기본적으로 제공하는 양식을 사용
	String host = "http://localhost:8080/LectureEvaluation";
	String from = "hok0173@gmail.com";
	String to = userDAO.getUserEmail(userID); // 이메일을 받는 사람
	String subject = "강의평가를 위한 이메일 인증 메일입니다."; // 이메일 제목
	String content = "다음 링크에 접속하여 이메일 인증을 진행하세요." +
		"<a href='" + host + "/emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";
	// 사용자가 이메일에서 링크를 눌러서 이메일 인증을 시도하도록 해줌
	
	// 실제로 smtp에 접속하기 위한 정보를 넣어야함
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.gmail.com"); // 구글에서 제공하는 서버
	p.put("mail.smtp.port", "587" ); // 포트, 구글에서 사용하도록 제공해줌
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.ssl.protocols", "TLSv1.2");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactor.port", "587");
	p.put("mail.smtp.socketFactor.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactor.fallback", "false");
	
	// 이메일을 전송하는 부분
	try {
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses); // MimeMessage 객체를 이용해서 메일을 보냄
		msg.setSubject(subject); // 메일의 제목
		Address fromAddr = new InternetAddress(from); // 보내는 사람의 정보
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to); // 받는 사람의 정보
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF8");
		Transport.send(msg);
	} catch (Exception e) {
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');");
		script.println("history.back();");
		// 입력이 되지 않았으면 index.jsp 로 이동
		script.println("</script>");
		script.close();
		return;
	}
%>
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
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> 회원 관리 </a>
						<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if(userID == null) { // 로그인이 안된 상태라면
%>
							<a class="dropdown-item" href="userLogin.jsp">로그인</a> 
							<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
<%
	} else { // 로그인이 된 상태라면
%>
							<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
	}
%>
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
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-success mt-4" role="alert">
			이메일 주소 인증 메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가셔서 인증해주세요.
		</div>
	</section>		
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