<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="likey.LikeyDTO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) { // 현재 사용자가 로그인한 상태, 즉 session값이 유효한 상태일 때
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) { // 사용자가 로그인하지 않은 상태라면 특정 게시글을 삭제할 수 없기때문에
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
	if (userID.equals(evaluationDAO.getUserID(evaluationID))) { // 게시글을 삭제하려는 사용자가 실제 평가글 작성자라면
		int result = new EvaluationDAO().delete(evaluationID);
		if (result == 1) { // 성공적으로 삭제가 완료 되었다면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('삭제가 완료 되었습니다.');");
			script.println("location.href = 'index.jsp';");
			script.println("</script>");
			script.close();
			return;
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();");
			// 입력이 되지 않았으면 이전화면으로
			script.println("</script>");
			script.close();
			return;
		} 
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('자신이 쓴 글만 삭제 가능합니다.');");
		script.println("history.back();");
		// 입력이 되지 않았으면 이전화면으로
		script.println("</script>");
		script.close();
		return;
	}
%>