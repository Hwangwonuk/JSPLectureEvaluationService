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
// 신고기능 구현하기
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
	
	request.setCharacterEncoding("UTF-8"); // 사용자한테 요청을 받되 그 요청은 한글이 포함될 수 있게 UTF-8로 설정
	String reportTitle = null; // 신고 제목
	String reportContent = null; // 신고 내용
	if (request.getParameter("reportTitle") != null) { // 사용자로부터 제목을 입력 받았다면
		reportTitle = request.getParameter("reportTitle");
	}
	if (request.getParameter("reportContent") != null) { // 사용자로부터 내용을 입력 받았다면
		reportContent = request.getParameter("reportContent");
	}
	if (reportTitle == null || reportContent == null) { // 둘중에 하나라도 입력이 되지 않았다면
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안된 사항이 있습니다.');");
		script.println("history.back();");
		// 입력이 되지 않았으면 이전화면으로
		script.println("</script>");
		script.close();
		return;
	}
	
	// 구글 smtp가 기본적으로 제공하는 양식을 사용
	String host = "http://localhost:8080/LectureEvaluation";
	String from = "hok0173@gmail.com";
	String to = "hok0173@naver.com";
	String subject = "강의평가 사이트에서 접수된 신고 메일입니다.";
	String content = "신고자 : " + userID + 
					 "<br>제목: " + reportTitle + 
					 "<br>내용: " + reportContent;
	
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
	
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('정상적으로 신고되었습니다.');");
	script.println("history.back();");
	// 입력이 되지 않았으면 index.jsp 로 이동
	script.println("</script>");
	script.close();
	return;
%>