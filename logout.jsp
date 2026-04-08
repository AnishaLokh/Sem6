<%@ page language="java" %>
<html>
<head>
<title>Logging out...</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    
    .container {
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        text-align: center;
        width: 100%;
        max-width: 400px;
    }
    
    h2 {
        color: #667eea;
        margin-bottom: 10px;
    }
    
    p {
        color: #666;
        margin-bottom: 20px;
    }
</style>
</head>
<body>
    <div class="container">
        <h2> Logged Out</h2>
        <p>You have been successfully logged out.</p>
        <p>Redirecting to login page...</p>
    </div>
    
    <%
        session.invalidate();
        response.setHeader("Refresh", "2; url=login.jsp");
    %>
</body>
</html>
