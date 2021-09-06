<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
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
	request.setCharacterEncoding("UTF-8"); // index.jsp페이지는 강의평가 게시글을 출력해주기 때문에 항상 사용자가 어떤 게시물을 검색했는지 판단할 수 있어야 한다.
	String lectureDivide = "전체";		   // 기본적으로 사용자가 검색한 강의구분은 전체로 설정
	String searchType = "최신순";			   // 기본적으로 최신순으로 검색
	String search = "";				       // 기본적으로 어떠한 내용도 검색하지 않은것 공백
	int pageNumber = 0;					   // 기본적으로 0페이지
	if (request.getParameter("lectureDivide") != null) { // 사용자가 특정한 내용으로 검색을 했는지
		lectureDivide = request.getParameter("lectureDivide");
	}
	if (request.getParameter("searchType") != null) { 
		searchType = request.getParameter("searchType");
	}
	if (request.getParameter("search") != null) { 
		search = request.getParameter("search");
	}
	if (request.getParameter("pageNumber") != null) {
		try {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch (Exception e) { // 사용자가 입력한 값이 정수형이 아닌 경우에는 오류가 발생하기 때문에 예외처리
			System.out.println("검색 페이지 번호 오류");
		}	
	}
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
	<div class="container">
		<div class="row">
			<!-- 게시판의  목록들이 홀,짝 번갈아가며 색상이 변경되게 만들어줌 -->
			<table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee text-align: center;">번호</th>
						<th style="background-color: #eeeeee text-align: center;">제목</th>
						<th style="background-color: #eeeeee text-align: center;">작성자</th>
						<th style="background-color: #eeeeee text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>1</td>
						<td>안녕하세요</td>
						<td>홍길동</td>
						<td>2021-05-04</td>
					</tr>
				</tbody>
			</table>
			<div style="position:relative; left:890px;">
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
			</div>
		</div>
	</div>
	
<%
	// 사용자가 검색을 한 내용이 리스트에 담겨서 출력이 되도록 만듬
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	// 사용자가 검색한 내용을 토대로 실제로 강의평가 게시들을을 가져오게 만듬
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null)
		for(int i = 0; i < evaluationList.size(); i++) {
			if(i == 5) break; // 6개의 글중에서 5개까지만 출력되도록
			EvaluationDTO evaluation = evaluationList.get(i); // 해당 인덱스에 값을 가져오도록 하여 카드안에서 출력되도록 하기위해
%>
		
		
		
<%
	}
%>
	
	<!-- pagination은 bootstrap에서 제공되는 기술중 하나로서 여러개의 페이지가 있는 하나의 구성요소를 작업할 때 사용 일반적으로 게시판에서 사용  -->
	<ul class="pagination justify-content-center mt-3 ">
		<li class="page-item">
<%
	if(pageNumber <= 0) {
%>
	<a class="page-link disabled">이전</a>
<%
	} else {
	// 특정한 URL로 이동하는 경우에는 UTLEncoder를 이용하는게 일반적이다. 현재 사용자가 입력했던 값은 유지한채 페이지를 뒤로이동
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber - 1 %>">이전</a>
<%
	}
%>
		</li>
		<li>
<%
	if(evaluationList.size() < 6) {
%>
	<a class="page-link disabled">다음</a>
<%
	} else {
	// 특정한 URL로 이동하는 경우에는 UTLEncoder를 이용하는게 일반적이다. 현재 사용자가 입력했던 값은 유지한채 페이지를 뒤로이동
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber + 1 %>">다음</a>
<%
	}
%>
		</li>
	</ul>
	
	
	
	
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog"
		aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label>신고제목</label> <input type="text" name="reportTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>신고내용</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
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