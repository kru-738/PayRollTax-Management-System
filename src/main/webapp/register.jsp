<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    	pageContext.setAttribute("pageTitle","Employee Registration");
    	pageContext.setAttribute("formMessage","Please Enter the Employee Name and the Gross Salary.");
    %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Employee Registration</title>

    <link rel="stylesheet" href="register.css">
</head>

<body>

    <div class="registration-container">


        <div class="registration-header">

            <div class="header-icon">
                👨‍💼
            </div>

            <div class="header-content">
                <span class="header-badge">EMPLOYEE PORTAL</span>

                <h1><%=pageContext.getAttribute("pageTitle") %></h1>

                <p>
                    Enter the employee's basic information to create
                    a new payroll record.
                </p>
            </div>

        </div>


       
        <div class="registration-card">

            <div class="card-heading">

                <div>
                    <h2>Enter Employee Details</h2>

                    <p><%= pageContext.getAttribute("formMessage") %></p>
                </div>

                <div class="card-symbol">
                    📝
                </div>

            </div>


       
            <form action="payroll" method="post">

         
                <div class="form-group">

                    <label for="ename">
                        Employee Name
                    </label>

                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>

                        <input
                            type="text"
                            id="ename"
                            name="ename"
                            placeholder="Enter employee name"
                            required>
                    </div>

                </div>


               
                <div class="form-group">

                    <label for="egross">
                        Gross Salary
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">💰</span>

                        <input
                            type="number"
                            id="egross"
                            name="egross"
                            placeholder="Enter gross salary"
                            min="0"
                            step="0.01"
                            required>

                    </div>

                </div>
                
                 
                <div class="form-group">

                    <label for="eemail">
                        E-mail
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">✉️</span>

                        <input
                            type="text"
                            id="eemail"
                            name="eemail"
                            placeholder="Enter E-mail"
                            min="0"
                            step="0.01"
                            required>

                    </div>

                </div>
                
                 
                <div class="form-group">

                    <label for="epassword">
                        Password
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">🔒</span>

                        <input
                            type="password"
                            id="epassword"
                            name="epassword"
                            placeholder="Enter Password"
                            min="0"
                            step="0.01"
                            
                            required>
						 <span class="toggle-password" onclick="togglePassword('epassword', this)">👁️</span>
                    </div>

                </div>
	
				
                <div class="button-container">

                    <button
                        type="submit"
                        class="register-btn">
                        <span>➕</span>
                        Register Employee
                    </button>

                    <a
                        href="show.jsp"
                        class="show-btn">
                        <span>👥</span>
                        Show Employees
                    </a>

                </div>

            </form>

        </div>



        <div class="back-home">

            <a href="payrollPortal.jsp">
                ← Back to Home
            </a>

        </div>


       
        <div class="registration-footer">

            <span>🔐 Secure Payroll System</span>

            <span>•</span>

            <span>Java JSP & JDBC</span>
            <span>•</span> 
           <span>Page Class: <%= page.getClass().getName() %></span>
             </div>

        </div>

    </div>
<script>
function togglePassword(inputId, iconEl) {
    const input = document.getElementById(inputId);
    if (input.type === "password") {
        input.type = "text";
        iconEl.textContent = "🙈"; 
    } else {
        input.type = "password";
        iconEl.textContent = "👁️";
    }
}
</script>
</body>
</html>