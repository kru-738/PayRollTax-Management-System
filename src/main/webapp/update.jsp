<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>

<%@ page language="java"
    contentType="text/html; charset=UTF-8"
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

<title>Update Employee's Details</title>

<link rel="stylesheet" href="Css_files/update.css">

</head>

<body>

<div class="page-container">



    <div class="page-header">

        <div class="header-content">

            <span class="page-badge">
                PAYROLL SYSTEM
            </span>

            <h1>Update Employee</h1>

            <p>
                Modify employee information and payroll details.
            </p>

        </div>

        <a href="show.jsp" class="back-btn">
            ← Back to Employees
        </a>

    </div>


 

    <div class="form-card">

        <div class="form-header">

            <div class="form-icon">
                ✏️
            </div>

            <div>

                <h2>Employee Details</h2>

                <p>
                    Update the employee information below.
                </p>

            </div>

        </div>


        <%
            String idValue = request.getParameter("id");

            if(idValue != null && !idValue.trim().isEmpty()){

                int id = Integer.parseInt(idValue);

                PreparedStatement pstmt =
                    conn.prepareStatement(
                        "SELECT * FROM employees WHERE id=?"
                    );

                pstmt.setInt(1, id);

                ResultSet rs = pstmt.executeQuery();

                if(rs.next()){
        %>


        <form action="updateProcess" method="post">


            <div class="form-group">

                <label for="id">
                    Employee ID
                </label>

                <input
                    type="text"
                    id="id"
                    value="<%= rs.getInt(1) %>"
                    readonly
                >

                <input
                    type="hidden"
                    name="id"
                    value="<%= rs.getInt(1) %>"
                >

            </div>


      

            <div class="form-group">

                <label for="name">
                    Employee Name
                </label>

                <input
                    type="text"
                    id="name"
                    name="name"
                    value="<%= rs.getString(2) %>"
                    required
                >

            </div>


            

            <div class="form-group">

                <label for="salary">
                    Gross Salary
                </label>

                <div class="input-wrapper">
                    <span>$</span>

                    <input
                        type="number"
                        id="salary"
                        name="salary"
                        value="<%= rs.getDouble(3) %>"
                        step="0.01"
                        required
                    >

                </div>

            </div>


            

            <div class="form-group">

                <label for="bonus">
                    Performance Bonus
                </label>

                <div class="input-wrapper">
                    <span>$</span>

                    <input
                        type="number"
                        id="bonus"
                        name="bonus"
                        value="<%= rs.getDouble(4) %>"
                        step="0.01"
                        required
                    >

                </div>

            </div>


           

            <div class="form-group">

                <label for="netSalary">
                    Net Salary
                </label>

                <div class="input-wrapper">
                    <span>$</span>

                    <input
                        type="number"
                        id="netSalary"
                        name="netSalary"
                        value="<%= rs.getDouble(5) %>"
                        step="0.01"
                        required
                    >

                </div>

            </div>


    

            <div class="form-actions">

                <a href="show.jsp" class="cancel-btn">
                    Cancel
                </a>

                <button type="submit" class="update-btn">
                    ✓ Update Employee
                </button>

            </div>

        </form>


        <%
                }

                else {
        %>

            <div class="error-message">
                ⚠ Employee not found.
            </div>

        <%
                }

                rs.close();
                pstmt.close();

            } else {
        %>

            <div class="error-message">
                ⚠ Invalid employee ID.
            </div>

        <%
            }
        %>

    </div>


   

    <div class="page-footer">

        <span>🔐 Secure Employee Payroll System</span>

        <span>•</span>

        <span>Java JSP & JDBC</span>

    </div>

</div>

</body>

</html>