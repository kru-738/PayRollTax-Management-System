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
        	
        	url = context.getInitParameter("dbUrl");
        	dbDriver = context.getInitParameter("dbDriver");
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
    
    
    <% 
    String msg = request.getParameter("msg");
    %>
    
 
<%
    String testError = request.getParameter("testError");
    if(testError != null && testError.equals("true")){
        int a = 10;
        int b = 0;
        int result = a / b;
    }
%>

<%
	if(request.getParameter("logout")!=null){
		session.invalidate();
		response.sendRedirect("landing_page.jsp");
		return;
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pay Roll Portal</title>
<link rel="stylesheet" href="payrollPortal.css">
</head>
<body>  
<%
    if(session.getAttribute("user") == null){
%>

    <a href="login.jsp" class="errorPage">Login</a>

<%
    } else {
%>

    <div class="user-menu">

        <div class="user-name">

            <%= session.getAttribute("user") %>
			<%= session.getAttribute("userid") %>
            <span class="user-arrow">▼</span>

        </div>

        <div class="dropdown_menu">

            <ul>

                <li>
                    <a href="profile.jsp">👤 Profile</a>
                </li>

                <li>
                    <a href="payrollPortal.jsp?logout=true">🚪 Logout</a>
                </li>

            </ul>

        </div>

    </div>

<%
    }
%>

  <%
 

  boolean saved = false;
   
   if (msg != null && !msg.trim().isEmpty()) {
	   
	   session.setAttribute("notification",msg);
	   response.sendRedirect("payrollPortal.jsp");
	   return;
   }
  
  String notification = (String) session.getAttribute("notification");
  
  if(notification!=null){
	  session.removeAttribute("notification");
	   %>	
  <div class="notification successlink" id="notif">
   ✓ &nbsp; <%= notification %>
   </div>
<% } %>
       <div class="portal-container"> 
       
<div class="stats-container">

    <div class="stat-card">

        <div class="stat-icon">
            👥
        </div>

        <div class="stat-content">
            <span class="stat-label">TOTAL EMPLOYEES</span>
                <%
                	int registration = 0;
                	
                	PreparedStatement ps = conn.prepareStatement("select count(*) from employees");
                	ResultSet rs = ps.executeQuery();
                	
                	if(rs.next()){
                		registration = rs.getInt(1);
                	}
                	rs.close();
                	ps.close();
                	
                %>
                
         		<h2><%= registration %></h2>

            <p>Registered Employees</p>
        </div>

    </div>

</div>
    
       <div class="portal-header"> 
       <div class="header-icon"> 👔 </div>
        <div class="header-content">
         <h1>Employee Management System</h1> 
         <p> Manage employee records, payroll information and salary details from one place. </p>
          </div> 
          </div>
      
            <div class="welcome-section">
             <span class="welcome-badge"> PAYROLL PORTAL </span> 
             <h2>What would you like to do?</h2> 
             <p> Choose an option below to manage your employee information. </p> 
             </div> 
             
             
             <div class="action-container"> 
              <a href="register.jsp" class="action-card add-card">
               <div class="card-icon"> ➕ </div>
                <div class="card-content">
                 <h3>Add Employee</h3>
                  <p> Register a new employee and enter their salary details. </p> 
                  <span class="card-link"> Add Employee → </span>
                   </div>
                    </a>
                    
                     <a href="show.jsp" class="action-card show-card">
                      <div class="card-icon"> 👥 </div>
                       <div class="card-content">
                        <h3>Show Employees</h3>
                         <p> View all registered employees and their payroll details. </p> 
                         <span class="card-link"> View Employees → </span>
                          </div>
                           </a> 
                         
                            <a href="show.jsp" class="action-card update-card">
                             <div class="card-icon"> ✏️ </div> 
                             <div class="card-content">
                              <h3>Update Employee</h3> 
                              <p> Modify employee information and update payroll records.
                               </p> 
                               <span class="card-link"> Update Employee → </span> 
                               </div> </a> 
                           
                                <a href="show.jsp" class="action-card delete-card">
                                 <div class="card-icon"> 🗑️ </div>
                                  <div class="card-content"> 
                                  <h3>Delete Employee</h3>
                                   <p> Remove an employee record from the payroll system. </p> 
                                   <span class="card-link"> Delete Employee → </span> 
                                   </div>
                                    </a>
                                     </div>
                                  
                                       <div class="portal-footer"> 
                                       <span>🔐 Secure Employee Payroll System</span>
                                        <span>•</span>
                                         <span>Java JSP & JDBC</span>
                                         <span>•</span> 
                                          <span>Page Class: <%= page.getClass().getName() %></span>
                                         </div>
                                          </div>
     
                                           </body>
</html>