<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 현재 사용자의 클라이언트에 모든 세션정보를 다 파기	
%>
<!-- 로그아웃 후 메인화면으로 이동 -->
<script>
	location.href = 'index.jsp';
</script>