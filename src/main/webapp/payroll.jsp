<%@page import="java.sql.ResultSet"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
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
        private String taxRateValue;
        private double taxRate;

        public void jspInit(){

          ServletConfig config = getServletConfig();
          ServletContext context = getServletContext();

           url = context.getInitParameter("dbUrl");
           dbDriver = context.getInitParameter("dbDriver");
           user = context.getInitParameter("dbUser");
           pass = context.getInitParameter("dbPass");
           taxRateValue = config.getInitParameter("taxRate");
           taxRate = Double.parseDouble(taxRateValue);

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
<title>Payroll & Tax System</title>
</head>
<body>
        <%
           boolean saved = false;

          


            String name =  request.getParameter("ename");
            String salary_gross = request.getParameter("egross");
            String username = request.getParameter("ename");
            String email = request.getParameter("eemail");
            String rawPassword = request.getParameter("epassword");
            
            double bonus=0;
            double net_salary=0;

            if(name!=null && !name.trim().isEmpty() 
            		&& salary_gross!=null && !salary_gross.trim().isEmpty() 
            		&& username!=null && !username.trim().isEmpty()
            		&& email!=null && !email.trim().isEmpty()
            		&& rawPassword!=null && !rawPassword.trim().isEmpty()
            			){

                double gross = Double.parseDouble(salary_gross);

                if(gross>50000){
                    bonus = gross * 0.10;
                }else{
                    bonus = 0.0;
                }

                net_salary = (gross+bonus) - (gross*taxRate);
				
                String hashPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt(12));

                PreparedStatement ustmt = null;
                PreparedStatement pstmt = null;
                ResultSet keys = null;

                try {
                    conn.setAutoCommit(false);

                    ustmt = conn.prepareStatement("insert into users(username,email,password) values(?,?,?)",
                    		java.sql.Statement.RETURN_GENERATED_KEYS
                    		);
                    ustmt.setString(1,username);
                    ustmt.setString(2,email);
                    ustmt.setString(3,hashPassword);
                    ustmt.executeUpdate();

                    keys = ustmt.getGeneratedKeys();
                    int newUserId = 0;
                    if(keys.next()){
                    	newUserId = keys.getInt(1);
                    }

                    pstmt = conn.prepareStatement("insert into employees(name,gross_salary,bonus,net_salary,user_id) values(?,?,?,?,?)");
                    pstmt.setString(1,name);
                    pstmt.setDouble(2,gross);
                    pstmt.setDouble(3,bonus);
                    pstmt.setDouble(4,net_salary);
                    pstmt.setInt(5, newUserId);

                       int row = pstmt.executeUpdate();

                       if(row>0){
                           saved=true;
                           conn.commit();

                           response.sendRedirect("payrollPortal.jsp?msg=Member+Registered+Successfull");
                           return;
                       } else {
                           conn.rollback();
                       }

                } catch (Exception e) {
                    conn.rollback();
                    e.printStackTrace();
                } finally {
                    conn.setAutoCommit(true);
                    if(keys != null) keys.close();
                    if(ustmt != null) ustmt.close();
                    if(pstmt != null) pstmt.close();
                }

            }
          

        %>

</body>
</html>
