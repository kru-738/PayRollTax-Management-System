<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    	
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
    	%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="Css_files/signUp.css">
</head><body>

    <%
        String username = request.getParameter("sname");
        String email = request.getParameter("semail");
        String password = request.getParameter("spass");

        String signupMessage = null;

        if (username != null || email != null || password != null) {

            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

                signupMessage = "All fields are required.";

            } else {

                try {

                 
                    PreparedStatement checkStmt = conn.prepareStatement(
                        "SELECT username, email FROM users WHERE username=? OR email=?"
                    );

                    checkStmt.setString(1, username);
                    checkStmt.setString(2, email);

                    ResultSet rs = checkStmt.executeQuery();

                    if (rs.next()) {

                        if (username.equals(rs.getString("username"))) {
                            signupMessage = "Username already exists.";
                        } 
                        else if (email.equals(rs.getString("email"))) {
                            signupMessage = "Email already exists.";
                        }

                    } else {

                        String hashPassword =
                            BCrypt.hashpw(password, BCrypt.gensalt(12));

                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO users (username,email,password) VALUES(?,?,?)",
                            java.sql.Statement.RETURN_GENERATED_KEYS
                        );

                        pstmt.setString(1, username);
                        pstmt.setString(2, email);
                        pstmt.setString(3, hashPassword);

                        int row = pstmt.executeUpdate();
						
                        ResultSet keys = pstmt.getGeneratedKeys();
                        int newUserId = 0;
                        if(keys.next()){
                        	newUserId = keys.getInt(1);
                        }
                        
                        if (row > 0) {

                            response.sendRedirect("login.jsp");

                        } else {

                            signupMessage = "Account could not be created.";
                        }

                        pstmt.close();
                    }

                    rs.close();
                    checkStmt.close();

                } catch (Exception e) {

                    e.printStackTrace();
                    signupMessage = "Something went wrong. Please try again.";
                }
            }
        }
    %>


  
    <% if (signupMessage != null) { %>

        <div class="top-notification">
            <span class="notification-icon">⚠️</span>
            <span><%= signupMessage %></span>
        </div>

    <% } %>


  

    <div class="signup-page">

        <div class="signup-card">

         

            <div class="signup-header">

                <div class="signup-icon">
                    👤
                </div>

                <h2>Create Account</h2>

                <p>
                    Register to access your payroll portal
                </p>

            </div>


          

            <form action="signUp.jsp" method="post">

                <div class="form-group">

                    <label for="sname">
                        Username
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            👤
                        </span>

                        <input
                            type="text"
                            id="sname"
                            name="sname"
                            placeholder="Enter your username"
                            autocomplete="username">

                    </div>

                </div>


                <div class="form-group">

                    <label for="semail">
                        Email
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            ✉️
                        </span>

                        <input
                            type="email"
                            id="semail"
                            name="semail"
                            placeholder="Enter your email"
                            autocomplete="email">

                    </div>

                </div>


                <div class="form-group">

                    <label for="spass">
                        Password
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            🔒
                        </span>

                        <input
                            type="password"
                            id="spass"
                            name="spass"
                            placeholder="Create a password"
                            autocomplete="new-password">

                    </div>

                </div>


                <button type="submit" class="signup-btn">

                    Create Account

                    <span>→</span>

                </button>

            </form>


    

            <div class="login-section">

                <p>
                    Already have an account?
                </p>

                <a href="login.jsp">
                    Login Here
                </a>

            </div>

        </div>

    </div>

</body>
</html>