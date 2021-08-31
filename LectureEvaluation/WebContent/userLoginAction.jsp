<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
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
	if (userID == null || userPassword == null) {
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
	int result = userDAO.login(userID, userPassword);
	if (result == 1) { // 로그인이 잘 되었을 때
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else if(result == 0) { // 비밀번호 오류
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -1) { // 아이디 오류
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -2) { // 데이터베이스 오류
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>