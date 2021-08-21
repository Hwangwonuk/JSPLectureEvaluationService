<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>우리의 첫번째 웹사이트</title>
</head>
<body>
	Hello world!
	<form action="./userJoinAction.jsp" method="post"> <%-- 일반적으로 post는 외부에 데이터가 노출되지 않는 방식으로 전달이되서 약간이라도 보안성이 뛰어나다 --%>
		<input type="text" name="userID">
		<input type="password" name="userPassword">
		<input type="submit" value="회원가입">
	</form>
</body>
</html>