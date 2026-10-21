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
    private String taxRateValue;
	private double taxRate;

    public void jspInit(){

        ServletContext context = getServletContext();
        ServletConfig config = getServletConfig();

        url = context.getInitParameter("dbUrl");
        dbDriver = context.getInitParameter("dbDriver");
        user = context.getInitParameter("dbUser");
        pass = context.getInitParameter("dbPass");
        taxRateValue = config.getInitParameter("taxRate");
        taxRate = Double.parseDouble(taxRateValue);

        try{
            Class.forName(dbDriver);
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("Database Connection Successful");

        }catch(Exception e){
            e.printStackTrace();
        }
    }
%>

<%
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String salary = request.getParameter("salary");
		String bonus = request.getParameter("bonus");
		String netSalary = request.getParameter("netSalary");
		
		try{
			
			int idInt = Integer.parseInt(id);
			Double gross_salary = Double.parseDouble(salary);
			Double perbonus = Double.parseDouble(bonus);
			Double net_salary = Double.parseDouble(netSalary);
			
			if(gross_salary>50000){
				perbonus = gross_salary * 0.10;
			}else{
				perbonus = 0.0;
			}
			
			net_salary = (gross_salary+perbonus) - (gross_salary*taxRate);
			
			
			PreparedStatement pstmt = conn.prepareStatement("update employees set name=?,gross_salary=?,bonus=?,net_salary=? where id=?");
			pstmt.setString(1,name);
			pstmt.setDouble(2,gross_salary);
			pstmt.setDouble(3,perbonus);
			pstmt.setDouble(4,net_salary);
			pstmt.setInt(5,idInt);
			
			pstmt.executeUpdate();
			pstmt.close();
			
			response.sendRedirect("show.jsp");
			
			
			
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Update Process</title>
</head>
<body>

</body>
</html>