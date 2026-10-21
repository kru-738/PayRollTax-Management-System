<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="errorPage.css">
</head>
<body>
		<div class="error-card">
		<div class="error-icon">⚠️</div>
		<h2>Something Went Wrong ⚠️</h2>
		<p class="error-msg"><%= exception!=null ? exception.getMessage() : "Unknown Error Occurred" %></p>
		<a href="payrollPortal.jsp" class="back-btn">← Go Back To Portal</a>
	</div>
</body>
</html>