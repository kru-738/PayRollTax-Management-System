<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
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
    	
    	public void jspDestroy(){
    		try{
    			conn.close();
    		}catch(Exception e){
    			e.printStackTrace();
    		}
    	}
    
    %>
    <%
    	String role = (String) session.getAttribute("role");
    	Integer userid = (Integer) session.getAttribute("id");
    	
    	if(userid == null || !"MEMBER".equals(role)){
    		response.sendRedirect("login.jsp");
    		return;
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
<title>Member Portal</title>
<link rel="stylesheet" href="memberPortal.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

		<%
			String empname = null;
			String email = null;
			double gross = 0;
			double bonus = 0;
			double netSalary = 0;
			
			PreparedStatement pstmt = conn.prepareStatement("select e.name, u.email, e.gross_salary, e.bonus, e.net_salary " +
			        "from employees e join users u on e.user_id = u.id " +
			        "where u.id = ?");
			pstmt.setInt(1,userid);
			
			ResultSet rs = pstmt.executeQuery();
			
			if(rs.next()){
				empname = rs.getString("name");
				email = rs.getString("email");
				gross = rs.getDouble("gross_salary");
				bonus = rs.getDouble("bonus");
				netSalary = rs.getDouble("net_salary");
			}
			rs.close();
			pstmt.close();
		%>
		<body>

    <div class="portal-container">

       
        <aside class="sidebar">

            <div class="logo">
                <div class="logo-icon">P</div>
                <div>
                    <h2>Payroll<span>Pro</span></h2>
                    <small>Employee Portal</small>
                </div>
            </div>

            <nav>
                <a href="landing_page.jsp" class="nav-link active">
                    <span>🏠</span>
                    Home
                </a>

                <a href="#profile" class="nav-link">
                    <span>👤</span>
                    My Profile
                </a>

                <a href="#salary" class="nav-link">
                    <span>💰</span>
                    Salary Details
                </a>

                <a href="memberPortal.jsp?logout=true" class="nav-link logout">
                    <span>🚪</span>
                    Logout
                </a>
            </nav>

            <div class="sidebar-footer">
                <p>© 2026 PayrollPro</p>
            </div>

        </aside>


      
        <main class="main-content">

            
            <header class="topbar">

                <div>
                    <h1>Welcome back, <%= empname %> 👋</h1>
                    <p>Here's your employee dashboard</p>
                </div>

                <div class="user-badge">
                    <div class="avatar">
                        <%= empname != null ? empname.substring(0,1).toUpperCase() : "M" %>
                    </div>

                    <div>
                        <strong><%= empname %></strong>
                        <small>Member</small>
                    </div>
                </div>

            </header>


           
            <section id="profile" class="profile-section">

                <div class="section-heading">
                    <div>
                        <h2>My Profile</h2>
                        <p>Your personal and employment information</p>
                    </div>
                </div>


                <div class="profile-card">

                    <div class="profile-header">

                        <div class="large-avatar">
                            <%= empname != null ? empname.substring(0,1).toUpperCase() : "M" %>
                        </div>

                        <div>
                            <h2><%= empname %></h2>
                            <p>Employee / Member</p>
                        </div>

                    </div>


                    <div class="profile-details">

                        <div class="detail-box">
                            <span class="detail-icon">👤</span>
                            <div>
                                <small>Full Name</small>
                                <strong><%= empname %></strong>
                            </div>
                        </div>

                        <div class="detail-box">
                            <span class="detail-icon">📧</span>
                            <div>
                                <small>Email Address</small>
                                <strong><%= email %></strong>
                            </div>
                        </div>

                    </div>

                </div>

            </section>


            
            <section id="salary" class="salary-section">

                <div class="section-heading">
                    <div>
                        <h2>Salary Overview</h2>
                        <p>Your current payroll information</p>
                    </div>
                </div>


                <div class="salary-grid">

                    <div class="salary-card gross">

                        <div class="salary-icon">
                            💼
                        </div>

                        <div>
                            <p>Gross Salary</p>
                            <h2>₹ <%= String.format("%.2f", gross) %></h2>
                        </div>

                    </div>


                    <div class="salary-card bonus">

                        <div class="salary-icon">
                            🎁
                        </div>

                        <div>
                            <p>Performance Bonus</p>
                            <h2>₹ <%= String.format("%.2f", bonus) %></h2>
                        </div>

                    </div>


                    <div class="salary-card net">

                        <div class="salary-icon">
                            💵
                        </div>

                        <div>
                            <p>Net Salary</p>
                            <h2>₹ <%= String.format("%.2f", netSalary) %></h2>
                        </div>

                    </div>

                </div>


           
                <div class="salary-highlight">

                    <div>
                        <span>💰</span>
                        <div>
                            <p>Your Take-Home Salary</p>
                            <h2>₹ <%= String.format("%.2f", netSalary) %></h2>
                        </div>
                    </div>

                    <div class="salary-status">
                        <span>●</span> Payroll Active
                    </div>

                </div>

            </section>
	
        </main>

    </div>

</body>	
</html>