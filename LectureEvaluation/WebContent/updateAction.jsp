<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="util.SHA256" %>
<%@ page import="util.*" %>
<%@ page import="java.io.PrintWriter" %>
<%!
/*
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
*/
%>
<%
	request.setCharacterEncoding("UTF-8");
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
			
	int bbsID = 0;
	String bbsTitle = null;
	String bbsDate = null;
	String bbsContent = null;
	int bbsAvailable = 0;
	
	if (request.getParameter("bbsID") != null) { 
		try {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		} catch(Exception e) {
			System.out.println("글 번호 오류");
		}
	}
	
	if (request.getParameter("bbsTitle") != null) { 
		bbsTitle = request.getParameter("bbsTitle");  
	}
	
	if (request.getParameter("userID") != null) { 
		userID = request.getParameter("userID");  
	}
	
	if (request.getParameter("bbsDate") != null) { 
		bbsDate = request.getParameter("bbsDate");  
	}
	
	if (request.getParameter("bbsContent") != null) { 
		bbsContent = request.getParameter("bbsContent");  
	}
	
	if (request.getParameter("bbsAvailable") != null) { 
		try {
			bbsAvailable = Integer.parseInt(request.getParameter("bbsAvailable"));
		} catch(Exception e) {
			System.out.println("작성 불가");
		}  
	}
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	if (!userID.equals(bbs.getUserID())) { // 글 작성자의 ID와 실제 유저의 ID 일치하지 않으면
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다');");
		script.println("location.href = 'bbs.jsp';");
		script.println("</script>");
		script.close();
		return;
	} else {
		if (request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
			|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안된 사항이 있습니다');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		} else {
			BbsDAO bbsDAO = new BbsDAO();
			int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"),request.getParameter("bbsContent"));
			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글 수정에 실패했습니다.');");
				script.println("history.back();");
				script.println("</script>");
				script.close();
				return;
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
				script.close();
				return;
			}
		}
	}
	

	
%>