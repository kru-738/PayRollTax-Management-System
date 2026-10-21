<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="errorPage.jsp"%>
    
    <%!
    	private Connection conn;
    	private String dbDriver;
    	private String url;
    	private String user;
    	private String pass;
    	
    	public void jspInit(){
    		
    		ServletContext context = getServletContext();
    		 dbDriver = context.getInitParameter("dbDriver");
    		 url = context.getInitParameter("dbUrl");
    		 user = context.getInitParameter("dbUser");
    		 pass = context.getInitParameter("dbPass");
    		
    		try{
    			Class.forName(dbDriver);
    			conn = DriverManager.getConnection(url,user,pass);
    			System.out.println("Database Connection Successfull");
    		}catch(Exception e){
    			e.printStackTrace();
    		}
    	}
    	
    	public void jspDestroy(){
    		try{
    			conn.close();
    		}catch(Exception e){
    			e.printStackTrace();
    		}
    	}
    
    %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Form</title>
<link rel="stylesheet" href="login.css">
</head>
<body>

<%
    String username = request.getParameter("lname");
    String pass = request.getParameter("lpass");

    String loginError = null;
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {

    if (username == null || username.trim().isEmpty() ||
        pass == null || pass.trim().isEmpty()) {

        loginError = "Username and Password are required.";

    } else {

        PreparedStatement pstmt = conn.prepareStatement(
            "SELECT id,password, role FROM users WHERE username=?"
        );

        pstmt.setString(1, username);

        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
        	 
        	int userid = rs.getInt(1);
            String storedPass = rs.getString("password");
            String role = rs.getString("role");
           

            boolean passwordMatches = BCrypt.checkpw(pass, storedPass);

            if (passwordMatches) {

                session.setAttribute("user", username);
                session.setAttribute("role", role);
                session.setAttribute("id", userid);
				
                if("ADMIN".equals(role)){
                response.sendRedirect("payrollPortal.jsp");
                return;
                }
                else{
                	response.sendRedirect("memberPortal.jsp");
                }
            } else {

                loginError = "Invalid username or password.";
            }

        } else {

            loginError = "Invalid username or password.";
        }

        rs.close();
        pstmt.close();
    }
    }
%>

<%
    if (loginError != null) {
%>

    <div class="top-notification">
        <span class="notification-icon">⚠️</span>
        <span><%= loginError %></span>
    </div>

<%
    }
%>
    
			<div class="login-page">

        <div class="login-card">
        <div class="login-header">
                <div class="login-icon">🔐</div>
                <h2>Welcome Back</h2>
                <p>Login to access your payroll portal</p>
            </div>
            
            

            <form action="login.jsp" method="post">

                <div class="form-group">
                    <label for="lname">Username</label>
                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>
                        <input 
                            type="text" 
                            id="lname"
                            name="lname"
                            placeholder="Enter your username"
                            autocomplete="username">
                    </div>
                </div>

                <div class="form-group">
                    <label for="lpass">Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input 
                            type="password" 
                            id="lpass"
                            name="lpass"
                            placeholder="Enter your password"
                            autocomplete="current-password">
                    </div>
                </div>

                <button type="submit" class="login-btn">
                    Login
                    <span>→</span>
                </button>

            </form>

          

            <div class="back-section">
                <a href="payrollPortal.jsp">← Back to Portal</a>
            </div>

        </div>

    </div>

</body>
</html>