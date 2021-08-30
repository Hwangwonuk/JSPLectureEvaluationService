<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	if (request.getParameter("code") != null) {
		code = request.getParameter("code");
	}
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if (session.getAttribute("userID") != null) { 
		// userID가 로그인이 되어있다면
		userID = (String) session.getAttribute("userID");  
		// userID 변수를 초기화, session값은 기본적으로 obj객체를 반환하기 때문에 String으로 형변환 해야한다.
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		// 로그인 되지 않았으면 다시 로그인 페이지로
		script.println("</script>");
		script.close();
		return;
		// 오류가 발생하면 jsp 페이지 종료
	}
	String userEmail = userDAO.getUserEmail(userID);
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false;
	// 현재 사용자가 보낸 코드가 정확히 해당사용자의 이메일 주소(해쉬값을 적용한)와 일치하는지 확인 
	
	if(isRight == true) {
		userDAO.setUserEmailChecked(userID); // 실제로 해당 사용자의 이메일 인증 처리
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>