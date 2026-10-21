<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
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
    <%
    Integer userId = (Integer) session.getAttribute("id");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = "";
    String email = "";
    String role = "";

    PreparedStatement ps = conn.prepareStatement(
        "SELECT username, email, role FROM users WHERE id = ?"
    );

    ps.setInt(1, userId);

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        username = rs.getString("username");
        email = rs.getString("email");
        role = rs.getString("role");
    }

    rs.close();
    ps.close();
		%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Profile</title>

    <link rel="stylesheet" href="profile.css">
</head>

<body>

    <div class="admin-page">

        

        <header class="navbar">

            <div class="brand">

                <div class="brand-icon">
                    P
                </div>

                <div class="brand-text">
                    <h2>Payroll<span>Pro</span></h2>
                    <small>Administration Panel</small>
                </div>

            </div>


            <nav class="navigation">

                <a href="payrollPortal.jsp">
                    🏠 Dashboard
                </a>

                <a href="adminProfile.jsp" class="active">
                    👤 Profile
                </a>

                <a href="landing_page.jsp?logout=true" class="logout">
                    🚪 Logout
                </a>

            </nav>

        </header>




        <main class="profile-container">


>

            <div class="page-heading">

                <span class="heading-label">
                   <%= role %>
                </span>

                <h1>Administrator Profile</h1>

                <p>
                    Manage your administrator account and system access.
                </p>

            </div>


           

            <section class="profile-card">


           

                <div class="profile-cover">

                    <div class="cover-circle circle-one"></div>
                    <div class="cover-circle circle-two"></div>
                    <div class="cover-circle circle-three"></div>

                </div>


                

                <div class="profile-header">

                    <div class="admin-avatar">

                        <%= username.substring(0, 1).toUpperCase() %>

                    </div>


                    <div class="admin-name">

                        <h2>
                            <%= role %>
                        </h2>

                        <p>
                            System Administrator
                        </p>

                    </div>


                    <div class="account-status">

                        <span class="status-dot"></span>

                        Active Account

                    </div>

                </div>


                

                <div class="section">

                    <div class="section-title">

                        <div class="title-icon">
                            👤
                        </div>

                        <div>
                            <h3>Account Information</h3>

                            <p>
                                Your administrator account details
                            </p>
                        </div>

                    </div>


                    <div class="info-grid">


                   

                        <div class="info-card">

                            <div class="info-icon username-icon">
                                👤
                            </div>

                            <div class="info-content">

                                <span>Username</span>

                                <strong>
                                    <%= username %>
                                </strong>

                            </div>

                        </div>


                     

                        <div class="info-card">

                            <div class="info-icon email-icon">
                                📧
                            </div>

                            <div class="info-content">

                                <span>Email Address</span>

                                <strong>
                                    <%= email %>
                                </strong>

                            </div>

                        </div>


                       

                        <div class="info-card">

                            <div class="info-icon id-icon">
                                🆔
                            </div>

                            <div class="info-content">

                                <span>User ID</span>

                                <strong>
                                    #<%= userId %>
                                </strong>

                            </div>

                        </div>


                       

                        <div class="info-card">

                            <div class="info-icon role-icon">
                                🛡️
                            </div>

                            <div class="info-content">

                                <span>Account Role</span>

                                <strong class="admin-role">
                                    ADMINISTRATOR
                                </strong>

                            </div>

                        </div>


                    </div>

                </div>


               

                <div class="section">

                    <div class="section-title">

                        <div class="title-icon">
                            🛡️
                        </div>

                        <div>

                            <h3>Administrator Access</h3>

                            <p>
                                Features available to your account
                            </p>

                        </div>

                    </div>


                    <div class="permission-grid">


                        <div class="permission-card">

                            <div class="permission-icon">
                                👥
                            </div>

                            <div class="permission-text">

                                <strong>
                                    Employee Management
                                </strong>

                                <span>
                                    Add, update and manage employees
                                </span>

                            </div>

                            <div class="permission-status">
                                ✓
                            </div>

                        </div>


                        <div class="permission-card">

                            <div class="permission-icon">
                                💰
                            </div>

                            <div class="permission-text">

                                <strong>
                                    Payroll Management
                                </strong>

                                <span>
                                    Manage employee payroll records
                                </span>

                            </div>

                            <div class="permission-status">
                                ✓
                            </div>

                        </div>


                        <div class="permission-card">

                            <div class="permission-icon">
                                📊
                            </div>

                            <div class="permission-text">

                                <strong>
                                    Reports & Analytics
                                </strong>

                                <span>
                                    View payroll and employee reports
                                </span>

                            </div>

                            <div class="permission-status">
                                ✓
                            </div>

                        </div>


                        <div class="permission-card">

                            <div class="permission-icon">
                                ⚙️
                            </div>

                            <div class="permission-text">

                                <strong>
                                    User Management
                                </strong>

                                <span>
                                    Manage system user accounts
                                </span>

                            </div>

                            <div class="permission-status">
                                ✓
                            </div>

                        </div>


                    </div>

                </div>


                

                <div class="security-card">

                    <div class="security-icon">
                        🔐
                    </div>

                    <div class="security-content">

                        <h3>Administrator Account Security</h3>

                        <p>
                            Your administrator account has access to
                            sensitive employee and payroll information.
                            Keep your credentials secure.
                        </p>

                    </div>

                    <a href="#" class="security-button">
                        Security Settings
                    </a>

                </div>


         

                <div class="profile-footer">

                    <a href="payrollPortal.jsp">
                        ← Back to Dashboard
                    </a>

                    <span>
                        PayrollPro Administration
                    </span>

                </div>


            </section>

        </main>

    </div>

</body>
</html>