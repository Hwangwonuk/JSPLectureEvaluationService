<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="likey.LikeyDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%!
	public static String getClientIP(HttpServletRequest request) { // 사용자가 프록시 서버를 사용해도 IP를 가져오게 코딩
		String ip = request.getHeader("X-FORWARDED-FOR");
		if (ip == null || ip.length() == 0) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0) {
			ip = request.getRemoteAddr(); // request에 적혀있는 기본적인 IP주소를 가져옴
		}
		return ip;
	}
%>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) { // 현재 사용자가 로그인한 상태, 즉 session값이 유효한 상태일 때
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) { // 사용자가 로그인하지 않은 상태라면 좋아요를 누를 수 없다
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
	String evaluationID = null;  // 어떠한 게시글을 삭제할 것인지
	if (request.getParameter("evaluationID") != null) { // 사용자로부터 게시글을
		evaluationID = request.getParameter("evaluationID");
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	LikeyDAO likeyDAO = new LikeyDAO();
	int result = likeyDAO.like(userID, evaluationID, getClientIP(request));
	// likeyDAO크래스에 있는 like함수를 실행 특정산 사용자가 특정한 평가글을 좋아요를 누르는데 IP주소를 담아서 함께 저장함
	if (result == 1) { // 성공적으로 추천이 완료 되었다면
		result = evaluationDAO.like(evaluationID); // 실제로 강의평가 글의 추천개수를 늘려준다
		if (result == 1) { // 성공적으로 추천이 완료 되었다면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('추천이 완료 되었습니다.');");
			script.println("location.href = 'index.jsp';");
			script.println("</script>");
			script.close();
			return;
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	} else { // 이미 추천을 누른 상태라면
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 추천을 누른 글입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} 
%>