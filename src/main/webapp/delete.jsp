<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
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
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("Database Connection Successful");

        }catch(Exception e){
            e.printStackTrace();
        }
    }
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Employee Details</title>
</head>
<body>
			<%
				String id = request.getParameter("id");
				
				try{
					int idInt = Integer.parseInt(id);
					
					PreparedStatement pstmt = conn.prepareStatement("delete from employees where id=?");
					pstmt.setInt(1,idInt);
					
					pstmt.executeUpdate();
					pstmt.close();
					
					response.sendRedirect("show.jsp");
				}catch(Exception e){
					e.printStackTrace();
				}
			%>

</body>
</html>