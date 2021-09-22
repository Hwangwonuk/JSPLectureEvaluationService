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
				<li class="nav-item active">
					<a class="nav-link" href="main.jsp">웹 사이트 소개</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> 회원 관리 </a>
						<div class="dropdown-menu" aria-labelledby="dropdown">
							<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
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
		<div class="jumbotron">
			<div class="container">
				<h1>웹 사이트 소개</h1>
				<p>이 웹 사이트는 부트스트랩으로 만든 JSP 웹 사이트 입니다. 최소한의 간단한 로직만을 이용해서 개발했습니다.<br /> 디자인 템플릿으로는 부트스트랩을 이용했습니다.</p>
				<p><a class="btn btn-primary btn-pull" href="#" role="botton">자세히 알아보기</a></p>
			</div>
		</div>
	</div>
	<!-- carousel은 간단하게 사진첩같은 것이라고 생각하면 된다. -->>
	<div class="container">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			 
			<ol class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1" ></li>
				<li data-target="#myCarousel" data-slide-to="2" ></li>
			</ol>
			<!-- 실제로 사진이 들어가는 영역 -->
			<div class="carousel-inner">
				<div class="carousel-item active">
					<img class="d-block w-100" src="images/a.jpg" />
				</div>
				<div class="carousel-item">
					<img class="d-block w-100" src="images/b.png" />
				</div>
				<div class="carousel-item">
					<img class="d-block w-100" src="images/c.png" />
				</div>
			</div>
			<!-- 사진을 왼쪽 오른쪽으로 넘길수있게 만듬 -->
			<a class="carousel-control-prev" href="#myCarousel" role="button" data-slide="prev">
				<span class="carousel-control-prev-icon" aria-hidden="true"></span>
				<span class="sr-only">Previous</span>
			</a>
			<a class="carousel-control-next" href="#myCarousel" role="button" data-slide="next">
				<span class="carousel-control-next-icon" aria-hidden="true"></span>
				<span class="sr-only">Next</span>
			</a>
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