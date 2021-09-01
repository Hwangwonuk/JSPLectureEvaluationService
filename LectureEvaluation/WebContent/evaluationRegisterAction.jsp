<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
// 강의평가글 등록

	request.setCharacterEncoding("UTF-8");
	String userID = null;
	if(session.getAttribute("userID") != null) { // 로그인을 한 상태라서 userID session의 값이 존재한다면
		userID = (String) session.getAttribute("userID"); // userID에 해당 session의 값을 넣는다
	}
	if(userID == null) {	// 로그인이 된 상태여야 강의평가 글을 작성할 수 있다.
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	String lectureName = null;
	String professorName = null;
	int lectureYear = 0;
	String semesterDivide = null;
	String lectureDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String creditScore = null;
	String comfortableScore = null;
	String lectureScore = null;
	
	// Spring과 같은 프레임 워크를 사용하면 이런식으로 하나하나씩 수작업으로 할 필요가 없다.
	if (request.getParameter("lectureName") != null) { 
		lectureName = request.getParameter("lectureName");  
	}
	if (request.getParameter("professorName") != null) { 
		professorName = request.getParameter("professorName");  
	}
	if (request.getParameter("lectureYear") != null) {
		try {
			lectureYear = Integer.parseInt(request.getParameter("lectureYear"));
			// lectureYear는 기본적으로 int형 이다. 사용자로부터 받은 값은 무조건 String이기 때문에 정수로 바꿔줘야한다.
		} catch(Exception e) {
			System.out.println("강의 연도 데이터 오류");
		}
	}
	if (request.getParameter("semesterDivide") != null) { 
		semesterDivide = request.getParameter("semesterDivide");  
	}
	if (request.getParameter("lectureDivide") != null) { 
		lectureDivide = request.getParameter("lectureDivide");  
	}
	if (request.getParameter("evaluationTitle") != null) { 
		evaluationTitle = request.getParameter("evaluationTitle");  
	}
	if (request.getParameter("evaluationContent") != null) { 
		evaluationContent = request.getParameter("evaluationContent");  
	}
	if (request.getParameter("totalScore") != null) { 
		totalScore = request.getParameter("totalScore");  
	}
	if (request.getParameter("creditScore") != null) { 
		creditScore = request.getParameter("creditScore");  
	}
	if (request.getParameter("comfortableScore") != null) { 
		comfortableScore = request.getParameter("comfortableScore");  
	}
	if (request.getParameter("lectureScore") != null) { 
		lectureScore = request.getParameter("lectureScore");  
	}
	
	if (lectureName == null || professorName == null || lectureYear == 0 || semesterDivide == null || 
		lectureDivide == null || evaluationTitle == null || evaluationContent == null || totalScore == null ||
		creditScore == null || comfortableScore == null || lectureScore == null ||
		evaluationTitle.equals("") || evaluationContent.equals("")) {
		// 모든 변수 중에 하나라도 비어있다면, 제목과 내용이 공백이라면
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
	// 다 기입이 되어있다면 강의평가 등록
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	int result = evaluationDAO.write(new EvaluationDTO(0, userID, lectureName, professorName,
		lectureYear, semesterDivide, lectureDivide, evaluationTitle, evaluationContent, 
		totalScore, creditScore, comfortableScore, lectureScore, 0)); 
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		// 성공적으로 등록이 완료가 되었다면 메인페이지로 이동
		script.println("</script>");
		script.close();
		return;
	}
%>