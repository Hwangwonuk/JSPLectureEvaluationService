<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 회원가입을 처리하는 함수 -->
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	String userEmail = null;
	if (request.getParameter("userID") != null) { 
		// userID를 사용자가 잘 제출했다면
		userID = request.getParameter("userID");  
		// userID에 사용자가 입력한 ID를 담는다
	}
	if (request.getParameter("userPassword") != null) { 
		// userPassword를 사용자가 잘 제출했다면
		userPassword = request.getParameter("userPassword");  
		// userPassword에 사용자가 입력한 userPassword를 담는다
	}
	if (request.getParameter("userEmail") != null) { 
		// userEmail를 사용자가 잘 제출했다면
		userEmail = request.getParameter("userEmail");  
		// userEmail에 사용자가 입력한 ID를 담는다
	}
	if (userID == null || userPassword == null || userEmail == null) {
		// ID,pwd,Email 중에 하나라도 비어있다면 메세지를 출력
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		// 입력이 되지 않았으면 뒤로가기
		script.println("</script>");
		script.close();
		return;
		// 오류가 발생하면 jsp 페이지 종료
	}
	UserDAO userDAO = new UserDAO();
	int result = userDAO.join(new UserDTO(userID, userPassword, userEmail, SHA256.getSHA256(userEmail), false));
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 존재하는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		session.setAttribute("userID", userID);
		// 회원가입 이후에 바로 로그인 시킴
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendAction.jsp'");
		// 사용자가 회원가입을 하자마자 이메일 인증
		script.println("</script>");
		script.close();
		return;
	}
%>