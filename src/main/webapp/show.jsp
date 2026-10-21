<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="errorPage.jsp"%>
    
    <%!
        private Connection conn;
		private String url;
		private String dbDriver;
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
    	
    %>
    
    <%
    	PreparedStatement pstmt = conn.prepareStatement("select * from employees");
        ResultSet rs = pstmt.executeQuery();
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">	
<title>Show Employee Details</title>
<link rel="stylesheet" href="Css_files/show.css">
</head>
<body>

    <div class="page-container">

        <div class="employee-header">
            <div>
                <span class="page-badge">PAYROLL SYSTEM</span>
                <h1>Employee Details</h1>
                <p>View and manage all registered employee payroll records.</p>
            </div>

            <a href="payrollPortal.jsp" class="back-btn">
                ← Back to Portal
            </a>
        </div>

        <div class="table-card">

            <div class="table-heading">
                <h2>Registered Employees</h2>
                <p>Employee salary and payroll information</p>
            </div>

            <div class="table-wrapper">

                <table>

                    <thead>
                        <tr>
                            <th>Sr. No</th>
                            <th>Name</th>
                            <th>Gross Salary</th>
                            <th>Bonus</th>
                            <th>Net Salary</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                        while(rs.next()){
                    %>

                        <tr>

                            <td class="serial">
                                <%= rs.getInt(1) %>
                            </td>

                            <td class="employee-name">
                                <%= rs.getString(2) %>
                            </td>

                            <td>
                                $<%= String.format("%.2f", rs.getDouble(3)) %>
                            </td>

                            <td class="bonus">
                                $<%= String.format("%.2f", rs.getDouble(4)) %>
                            </td>

                            <td class="net-salary">
                                $<%= String.format("%.2f", rs.getDouble(5)) %>
                            </td>
							<%
    						if ("admin".equals(session.getAttribute("user"))) {
								%>

   							 <td class="actions">

        						<a href="update.jsp?id=<%= rs.getInt(1) %>"
           							class="action-btn update-btn">
            							✏ Update
       							 </a>

        							<a href="delete.jsp?id=<%= rs.getInt(1) %>"
          								 class="action-btn delete-btn">
           									 🗑 Delete
       								 </a>

    							</td>

								<%
   								 } else {
									%>
	
   									 <td class="actions">

     									   <span class="admin-label">
            									👤 View Only
        									</span>

    									</td>

											<%
    											}
												%>
                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

        </div>

        <div class="page-footer">
            <span>🔐 Secure Employee Payroll System</span>
            <span>•</span>
            <span>Java JSP & JDBC</span>
        </div>

    </div>

</body>
</html>